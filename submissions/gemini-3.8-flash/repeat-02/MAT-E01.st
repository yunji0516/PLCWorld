PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;

    state : INT := 0;
    start_trig : R_TRIG;
    hold_timer : TON;
END_VAR

start_trig(CLK := X10);
hold_timer(IN := (state = 1) AND X20, PT := T#100ms);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        IF start_trig.Q THEN
            state := 1;
            Y20 := TRUE;
        END_IF;

    1:
        Y20 := TRUE;
        IF hold_timer.Q THEN
            state := 2;
            Y2 := TRUE;
        END_IF;

    2:
        Y20 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM