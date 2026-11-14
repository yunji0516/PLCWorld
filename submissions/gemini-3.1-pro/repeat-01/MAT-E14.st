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
    D20 : INT;
    D21 : INT;
    D22 : INT;
    
    start_edge : R_TRIG;
    state : INT;
    diff_left : INT;
    diff_right : INT;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            diff_left := ABS((D21 + D20) - D22);
            diff_right := ABS(D21 - (D22 + D20));

            IF X22 AND X23 THEN
                IF diff_left <= diff_right THEN
                    state := 1;
                ELSE
                    state := 2;
                END_IF;
            ELSIF X22 THEN
                state := 1;
            ELSIF X23 THEN
                state := 2;
            END_IF;
        END_IF;

    1:
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF X20 THEN
            Y20 := FALSE;
            state := 3;
        END_IF;

    2:
        Y21 := TRUE;
        Y20 := FALSE;
        Y2 := FALSE;
        IF X21 THEN
            Y21 := FALSE;
            state := 3;
        END_IF;

    3:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;

END_CASE;

END_PROGRAM