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
    X23 : BOOL;

    trig_start : R_TRIG;
    t_rearm : TON;
    state : INT := 0;
END_VAR

trig_start(CLK := X10);
t_rearm(IN := (state = 1), PT := T#1600ms);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF trig_start.Q THEN
            state := 1;
        END_IF;

    1:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF t_rearm.Q AND (NOT X21) AND X22 THEN
            state := 2;
        END_IF;

    2:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := TRUE;
        IF X21 THEN
            state := 3;
        END_IF;

    3:
        Y2 := FALSE;
        Y20 := TRUE;
        Y21 := TRUE;
        IF X20 AND X23 THEN
            state := 4;
        END_IF;

    4:
        Y2 := FALSE;
        Y20 := TRUE;
        Y21 := FALSE;
        IF NOT X21 THEN
            state := 5;
        END_IF;

    5:
        Y2 := TRUE;
        Y20 := TRUE;
        Y21 := FALSE;
END_CASE;

END_PROGRAM