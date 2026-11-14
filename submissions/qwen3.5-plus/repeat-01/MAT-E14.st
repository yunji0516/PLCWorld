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
    target_left : BOOL;
    state : INT := 0;
    left_diff : INT;
    right_diff : INT;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            left_diff := ABS(D21 + D20 - D22);
            right_diff := ABS(D21 - D22 - D20);
            IF X22 AND X23 THEN
                IF left_diff <= right_diff THEN
                    target_left := TRUE;
                ELSE
                    target_left := FALSE;
                END_IF;
            ELSIF X22 THEN
                target_left := TRUE;
            ELSIF X23 THEN
                target_left := FALSE;
            ELSE
                target_left := FALSE;
            END_IF;
            state := 1;
        END_IF;
    1:
        Y2 := FALSE;
        IF target_left THEN
            Y20 := TRUE;
            Y21 := FALSE;
            IF X20 THEN
                Y20 := FALSE;
                state := 2;
            END_IF;
        ELSE
            Y21 := TRUE;
            Y20 := FALSE;
            IF X21 THEN
                Y21 := FALSE;
                state := 2;
            END_IF;
        END_IF;
    2:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM