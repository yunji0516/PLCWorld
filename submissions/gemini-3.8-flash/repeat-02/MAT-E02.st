PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;

    state : INT := 0;
    trig_start : R_TRIG;
    timer_stable : TON;
END_VAR

trig_start(CLK := X10);
timer_stable(IN := (state = 10) AND X21 AND X22 AND NOT X20, PT := T#50ms);

CASE state OF
    0:
        Y20 := TRUE;
        Y2 := FALSE;
        IF trig_start.Q THEN
            state := 10;
        END_IF;

    10:
        Y20 := FALSE;
        Y2 := FALSE;
        IF timer_stable.Q THEN
            state := 20;
        END_IF;

    20:
        Y20 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM