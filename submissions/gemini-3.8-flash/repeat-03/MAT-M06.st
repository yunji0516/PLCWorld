PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;

    x10_prev : BOOL;
    started : BOOL;
    step : INT;
    target : INT;
END_VAR

IF NOT started THEN
    IF X10 AND NOT x10_prev THEN
        started := TRUE;
        target := D10;
        step := 1;
    END_IF;
END_IF;
x10_prev := X10;

CASE step OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;

    1:
        (* Move nozzle down to receiving position *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X21 THEN
            Y20 := FALSE;
            step := 2;
        END_IF;

    2:
        (* Open valve *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF X22 THEN
            step := 3;
        END_IF;

    3:
        (* Run pump until target volume is reached *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := TRUE;
        IF D20 >= target THEN
            Y23 := FALSE;
            Y22 := FALSE;
            step := 4;
        END_IF;

    4:
        (* Wait for valve to close fully *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X23 THEN
            step := 5;
        END_IF;

    5:
        (* Retract nozzle to upper position *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X20 THEN
            Y21 := FALSE;
            step := 6;
        END_IF;

    6:
        (* Complete and maintain terminal state *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X20 AND X23 AND (ABS(D20 - target) <= 2) THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM