PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D20 : DINT;
    Y2 : BOOL;
    
    (* Physical constants and desired characteristic polynomial coefficients (poles at -2.0) *)
    g : REAL := 9.81;
    a3 : REAL := 8.0;
    a2 : REAL := 24.0;
    a1 : REAL := 32.0;
    a0 : REAL := 16.0;

    L : REAL;
    pos : REAL;
    vel : REAL;
    theta : REAL;
    theta_dot : REAL;
    
    K1 : REAL;
    K2 : REAL;
    K3 : REAL;
    K4 : REAL;
    u : REAL;
    
    completed : BOOL;
    hold_timer : TON;
END_VAR

IF X10 THEN
    (* Convert inputs to SI units (meters, radians, seconds) *)
    L := REAL(D13) / 100000.0;
    IF L < 0.1 THEN
        L := 0.1; (* Prevent unphysical pendulum lengths or division by near-zero *)
    END_IF;

    pos := REAL(D11 - D10) / 100000.0;
    vel := REAL(D12) / 100000.0;
    theta := REAL(D15) * 0.000174532925;
    theta_dot := REAL(D16) * 0.000174532925;

    (* Compute state feedback gains for pole placement *)
    K1 := a0 * L / g;
    K2 := a1 * L / g;
    K3 := L * K1 + g - a2 * L;
    K4 := L * K2 - a3 * L;

    (* Calculate requested acceleration control law *)
    u := - (K1 * pos + K2 * vel + K3 * theta + K4 * theta_dot);

    (* Limit output to +/- 1800 mm/s^2 and convert to scale factor x100 *)
    D20 := DINT(LIMIT(-180000.0, u * 100000.0, 180000.0));

    (* Evaluate completion thresholds *)
    completed := (ABS(D11 - D10) <= 100) AND 
                 (ABS(D12) <= 100) AND 
                 (ABS(D15) <= 20) AND 
                 (ABS(D16) <= 100);
    
    (* Require condition to be maintained for 30 ms before asserting success *)
    hold_timer(IN := completed, PT := T#30ms);
    
    IF hold_timer.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    (* Do not activate or publish local function before X10 request acceptance *)
    D20 := 0;
    Y2 := FALSE;
    hold_timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM