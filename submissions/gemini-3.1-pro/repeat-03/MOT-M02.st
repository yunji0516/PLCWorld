PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D90 : DINT;
    D101 : DINT;
    D102 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y31 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    R_AB : DINT := 0;
    R_C : DINT := 10000;
END_VAR

IF state = 0 THEN
    IF X0 THEN
        state := 1;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        R_AB := 0;
        R_C := 10000;
        D21 := 1000;
        D25 := 1000;
        D29 := 1000;
        Y30 := FALSE;
        Y31 := FALSE;
    END_IF;
END_IF;

IF state > 0 THEN
    IF state = 1 THEN
        IF R_AB < D101 THEN
            R_AB := R_AB + 100;
            IF R_AB > D101 THEN 
                R_AB := D101; 
            END_IF;
        ELSIF R_AB > D101 THEN
            R_AB := R_AB - 100;
            IF R_AB < D101 THEN 
                R_AB := D101; 
            END_IF;
        END_IF;
    ELSIF state = 3 THEN
        IF R_C < D102 THEN
            R_C := R_C + 100;
            IF R_C > D102 THEN 
                R_C := D102; 
            END_IF;
        ELSIF R_C > D102 THEN
            R_C := R_C - 100;
            IF R_C < D102 THEN 
                R_C := D102; 
            END_IF;
        END_IF;
    ELSIF state = 5 THEN
        IF R_AB > 0 THEN
            R_AB := R_AB - 100;
            IF R_AB < 0 THEN 
                R_AB := 0; 
            END_IF;
        END_IF;
    END_IF;

    D20 := R_AB;
    D24 := R_AB;
    D28 := R_C;

    CASE state OF
        1:
            IF X4 AND (R_AB = D101) 
               AND (ABS(D10 - D101) <= 20) AND (ABS(D11) <= 100) 
               AND (ABS(D12 - D101) <= 20) AND (ABS(D13) <= 100) THEN
                state := 2;
            END_IF;
        2:
            Y30 := TRUE;
            Y31 := FALSE;
            IF X2 AND NOT X3 THEN
                state := 3;
            END_IF;
        3:
            IF X5 AND (R_C = D102) 
               AND (ABS(D14 - D102) <= 20) AND (ABS(D15) <= 100) THEN
                state := 4;
            END_IF;
        4:
            Y30 := FALSE;
            Y31 := TRUE;
            IF X1 THEN
                state := 5;
            END_IF;
        5:
            IF (R_AB = 0) 
               AND (ABS(D10) <= 20) AND (ABS(D11) <= 100) 
               AND (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
                state := 6;
            END_IF;
        6:
            Y2 := TRUE;
    END_CASE;
END_IF;

END_PROGRAM