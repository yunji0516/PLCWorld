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

    active : BOOL := FALSE;
    state : INT := 0;
    timer_hold : TON;
    conditions_met : BOOL;
    
    L_m : REAL;
    x_m : REAL;
    v_m : REAL;
    theta_rad : REAL;
    theta_dot_rad : REAL;
    
    k1 : REAL;
    k2 : REAL;
    k3 : REAL;
    k4 : REAL;
    u_m : REAL;
    
    (* Characteristic polynomial coefficients for 4 poles at -1.85 rad/s *)
    C0 : REAL := 11.7136;
    C1 : REAL := 25.327;
    C2 : REAL := 20.535;
    C3 : REAL := 7.4;
    g : REAL := 9.81;
END_VAR

IF X10 THEN
    IF NOT active THEN
        active := TRUE;
        state := 1;
        timer_hold(IN := FALSE, PT := T#30ms);
    END_IF;

    (* Read and scale physical states *)
    L_m := REAL(D13) / 100000.0;
    IF L_m < 0.1 THEN
        L_m := 0.1;
    END_IF;
    
    x_m := REAL(D11 - D10) / 100000.0;
    v_m := REAL(D12) / 100000.0;
    theta_rad := (REAL(D15) / 100.0) * 0.0174532925;
    theta_dot_rad := (REAL(D16) / 100.0) * 0.0174532925;

    (* Dynamically calculate state-space feedback gains based on current hoist length *)
    k1 := C0 * L_m / g;
    k2 := C1 * L_m / g;
    k4 := L_m * (k2 - C3);
    k3 := g + k1 * L_m - C2 * L_m;

    (* Full-state feedback control law for trolley acceleration *)
    u_m := - (k1 * x_m + k2 * v_m + k3 * theta_rad + k4 * theta_dot_rad);

    (* Clamp to permitted acceleration bounds (±1800 mm/s²) *)
    IF u_m > 1.8 THEN
        u_m := 1.8;
    ELSIF u_m < -1.8 THEN
        u_m := -1.8;
    END_IF;

    D20 := DINT(u_m * 100000.0);

    (* Check completion conditions *)
    conditions_met := (ABS(D11 - D10) <= 100) AND (ABS(D12) <= 100) AND (ABS(D15) <= 20) AND (ABS(D16) <= 100);

    (* State machine for holding and completion reporting *)
    IF state = 1 THEN
        timer_hold(IN := conditions_met, PT := T#30ms);
        IF timer_hold.Q THEN
            state := 2;
            Y2 := TRUE;
        END_IF;
    ELSIF state = 2 THEN
        timer_hold(IN := conditions_met, PT := T#30ms);
        Y2 := TRUE;
    END_IF;

ELSE
    active := FALSE;
    state := 0;
    Y2 := FALSE;
    D20 := 0;
    timer_hold(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM