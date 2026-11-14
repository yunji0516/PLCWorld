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
    D20 : INT;
    start_edge : R_TRIG;
    push_timer : TON;
    state : INT;
    whole_seen : BOOL;
END_VAR

start_edge(CLK := X10);

IF X22 THEN
    whole_seen := TRUE;
END_IF;

push_timer(IN := (state = 1), PT := T#2050ms);

IF Y2 THEN
    state := 4;
END_IF;

CASE state OF
    0:
        IF start_edge.Q AND (D10 = 1) THEN
            IF X22 THEN
                whole_seen := TRUE;
                state := 3;
            ELSIF X20 THEN
                state := 1;
            ELSE
                state := 2;
            END_IF;
        END_IF;

    1:
        IF whole_seen THEN
            state := 3;
        ELSIF push_timer.Q THEN
            state := 2;
        END_IF;

    2:
        IF whole_seen THEN
            state := 3;
        ELSIF X20 THEN
            state := 1;
        END_IF;

    3:
        IF X20 AND X22 THEN
            Y2 := TRUE;
            state := 4;
        END_IF;

    4:
        Y2 := TRUE;

ELSE
    state := 0;
END_CASE;

Y20 := (state = 1) AND (NOT Y2);
Y21 := ((state = 2) OR ((state = 3) AND (NOT X20))) AND (NOT Y2);

END_PROGRAM