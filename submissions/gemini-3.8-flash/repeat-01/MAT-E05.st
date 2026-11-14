PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;

    state : INT := 0;
    start_trig : R_TRIG;
    advance_timer : TON;
    retract_timer : TON;
END_VAR

start_trig(CLK := X10);
advance_timer(IN := (state = 1), PT := T#500ms);
retract_timer(IN := (state = 2) AND X22 AND X20 AND X21, PT := T#100ms);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF start_trig.Q AND (D10 = 1) THEN
            state := 1;
        END_IF;

    1:
        Y20 := TRUE;
        Y21 := TRUE;
        IF advance_timer.Q AND X20 AND X21 THEN
            state := 2;
        END_IF;

    2:
        Y20 := FALSE;
        Y21 := FALSE;
        IF retract_timer.Q THEN
            state := 3;
        END_IF;

    3:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
END_CASE;

END_PROGRAM