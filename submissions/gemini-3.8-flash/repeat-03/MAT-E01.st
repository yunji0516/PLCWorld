PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;

    state : INT;
    start_trig : R_TRIG;
    hold_timer : TON;
END_VAR

start_trig(CLK := X10);
hold_timer(IN := (state = 1) AND X20, PT := T#50ms);

CASE state OF
    0:
        Y20 := FALSE;
        Y2 := FALSE;
        IF start_trig.Q THEN
            state := 1;
        END_IF;

    1:
        Y20 := TRUE;
        IF hold_timer.Q THEN
            state := 2;
        END_IF;

    2:
        Y20 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM