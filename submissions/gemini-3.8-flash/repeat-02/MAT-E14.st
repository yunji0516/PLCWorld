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

    r_trig_x10 : R_TRIG;
    state : INT := 0;
    target_left : BOOL;
    diff_l : DINT;
    diff_r : DINT;
END_VAR

r_trig_x10(CLK := X10);

IF state = 0 THEN
    IF r_trig_x10.Q THEN
        diff_l := ABS((DINT(D21) + DINT(D20)) - DINT(D22));
        diff_r := ABS(DINT(D21) - (DINT(D22) + DINT(D20)));

        IF X22 AND X23 THEN
            IF diff_l <= diff_r THEN
                target_left := TRUE;
            ELSE
                target_left := FALSE;
            END_IF;
        ELSIF X22 THEN
            target_left := TRUE;
        ELSE
            target_left := FALSE;
        END_IF;

        IF target_left THEN
            state := 1;
            Y20 := TRUE;
            Y21 := FALSE;
        ELSE
            state := 2;
            Y20 := FALSE;
            Y21 := TRUE;
        END_IF;
    END_IF;
ELSIF state = 1 THEN
    IF X20 THEN
        Y20 := FALSE;
        state := 3;
    ELSE
        Y20 := TRUE;
        Y21 := FALSE;
    END_IF;
ELSIF state = 2 THEN
    IF X21 THEN
        Y21 := FALSE;
        state := 3;
    ELSE
        Y20 := FALSE;
        Y21 := TRUE;
    END_IF;
ELSIF state = 3 THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := TRUE;
END_IF;

END_PROGRAM