PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;

    state : INT;
    start_edge : R_TRIG;
    stable_timer : TON;
END_VAR

start_edge(CLK := X10);
stable_timer(IN := (state = 1) AND X21 AND X22 AND NOT X20, PT := T#100ms);

CASE state OF
    0:
        Y20 := TRUE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            state := 1;
        END_IF;

    1:
        Y20 := FALSE;
        Y2 := FALSE;
        IF stable_timer.Q THEN
            state := 2;
        END_IF;

    2:
        Y20 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM