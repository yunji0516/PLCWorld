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

    state : INT := 0;
    start_trig : R_TRIG;
    diff_l : DINT;
    diff_r : DINT;
END_VAR

start_trig(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF start_trig.Q THEN
            diff_l := ABS((DINT(D21) + DINT(D20)) - DINT(D22));
            diff_r := ABS(DINT(D21) - (DINT(D22) + DINT(D20)));
            IF X22 AND X23 THEN
                IF diff_l <= diff_r THEN
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
        IF X20 THEN
            Y20 := FALSE;
            state := 3;
        ELSE
            Y20 := TRUE;
            Y21 := FALSE;
        END_IF;

    2:
        IF X21 THEN
            Y21 := FALSE;
            state := 3;
        ELSE
            Y21 := TRUE;
            Y20 := FALSE;
        END_IF;

    3:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM