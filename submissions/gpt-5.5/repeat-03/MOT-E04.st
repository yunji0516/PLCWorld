PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    (* Add internal variables here. *)
    accepted : BOOL;
    result_latched : BOOL;
    target_cmd : DINT;
    speed_error : DINT;
    stable_condition : BOOL;
    stable_timer : TON;
END_VAR

IF (NOT accepted) AND X10 THEN
    accepted := TRUE;
    IF D10 > 200000 THEN
        target_cmd := 200000;
    ELSIF D10 < -200000 THEN
        target_cmd := -200000;
    ELSE
        target_cmd := D10;
    END_IF;
END_IF;

IF accepted THEN
    Y20 := TRUE;
    D20 := target_cmd;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

speed_error := ABS(D12 - target_cmd);
stable_condition := accepted AND Y20 AND (speed_error <= 199);

stable_timer(IN := stable_condition, PT := T#30ms);

IF stable_timer.Q THEN
    result_latched := TRUE;
END_IF;

Y2 := result_latched;

END_PROGRAM