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
    start_trig : R_TRIG;
    stable_timer : TON;
END_VAR

start_trig(CLK := X10);

CASE state OF
    0:
        Y20 := TRUE;
        Y2 := FALSE;
        IF start_trig.Q THEN
            state := 1;
            Y20 := FALSE;
        END_IF;

    1:
        Y20 := FALSE;
        Y2 := FALSE;
        stable_timer(IN := (X21 AND (NOT X20) AND X22), PT := T#100ms);
        IF stable_timer.Q THEN
            state := 2;
        END_IF;

    2:
        Y20 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM