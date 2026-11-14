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
    (* Add internal variables here. *)
    accepted : BOOL;
    result_latched : BOOL;
    ratio_command : DINT;
    phase_error_abs : DINT;
    velocity_error : REAL;
    stable_ok : BOOL;
    stable_timer : TON;
END_VAR

IF (X10 AND (NOT accepted)) THEN
    IF D10 > 200000 THEN
        ratio_command := 200000;
    ELSIF D10 < -200000 THEN
        ratio_command := -200000;
    ELSE
        ratio_command := D10;
    END_IF;
    accepted := TRUE;
END_IF;

IF accepted THEN
    Y20 := TRUE;
    D20 := ratio_command;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

IF D17 < 0 THEN
    phase_error_abs := -D17;
ELSE
    phase_error_abs := D17;
END_IF;

velocity_error := REAL(D12) - ((REAL(ratio_command) * REAL(D14)) / 1000.0);
IF velocity_error < 0.0 THEN
    velocity_error := -velocity_error;
END_IF;

stable_ok := accepted AND (phase_error_abs <= 25) AND (velocity_error <= 150.0);

stable_timer(IN := stable_ok, PT := T#30ms);

IF stable_timer.Q THEN
    result_latched := TRUE;
END_IF;

Y2 := result_latched;

END_PROGRAM