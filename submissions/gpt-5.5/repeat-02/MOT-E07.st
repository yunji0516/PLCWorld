PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D10 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    accepted : BOOL;
    done_latch : BOOL;
    ratio_cmd : DINT;
    phase_ok : BOOL;
    velocity_ok : BOOL;
    stable_ok : BOOL;
    velocity_error_scaled : DINT;
    stable_timer : TON;
END_VAR

IF X10 THEN
    accepted := TRUE;
END_IF;

IF accepted THEN
    ratio_cmd := LIMIT(-200000, D10, 200000);
    D20 := ratio_cmd;
    Y20 := TRUE;
ELSE
    D20 := 0;
    Y20 := FALSE;
END_IF;

phase_ok := ABS(D17) <= 30;

velocity_error_scaled := (D12 * 1000) - (ratio_cmd * D14);
velocity_ok := ABS(velocity_error_scaled) <= 200000;

stable_ok := accepted AND Y20 AND phase_ok AND velocity_ok;

stable_timer(IN := stable_ok, PT := T#30ms);

IF stable_timer.Q THEN
    done_latch := TRUE;
END_IF;

Y2 := done_latch;

END_PROGRAM