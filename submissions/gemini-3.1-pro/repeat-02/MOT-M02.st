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
    
    state : DINT := 0;
    dest_ab : DINT := 0;
END_VAR

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y31 := FALSE;
        Y2 := FALSE;
        D21 := 0;
        D25 := 0;
        D29 := 0;
        D20 := D10;
        D24 := D12;
        D28 := D14;
        
        IF X0 THEN
            state := 1;
        END_IF;

    1:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D21 := 1000;
        D25 := 1000;
        D29 := 1000;
        Y30 := FALSE;
        Y31 := FALSE;
        
        dest_ab := D101;
        IF dest_ab > D10 AND dest_ab > D12 THEN
            D20 := MIN(dest_ab, D12 + 700);
            D24 := MIN(dest_ab, D10 + 700);
        ELSIF dest_ab < D10 AND dest_ab < D12 THEN
            D20 := MAX(dest_ab, D12 - 700);
            D24 := MAX(dest_ab, D10 - 700);
        ELSE
            D20 := dest_ab;
            D24 := dest_ab;
        END_IF;
        
        D28 := 53000;
        
        IF X4 AND ABS(D10 - D101) <= 20 AND ABS(D12 - D101) <= 20 AND ABS(D11) <= 100 AND ABS(D13) <= 100 THEN
            state := 2;
        END_IF;

    2:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := D101;
        D24 := D101;
        D28 := 53000;
        Y30 := TRUE;
        Y31 := FALSE;
        
        IF X2 THEN
            state := 3;
        END_IF;

    3:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := D101;
        D24 := D101;
        D28 := D102;
        Y30 := TRUE;
        Y31 := FALSE;
        
        IF X5 AND ABS(D14 - D102) <= 20 AND ABS(D15) <= 100 THEN
            state := 4;
        END_IF;

    4:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := D101;
        D24 := D101;
        D28 := D102;
        Y30 := FALSE;
        Y31 := TRUE;
        
        IF X1 THEN
            state := 5;
        END_IF;

    5:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y30 := FALSE;
        Y31 := FALSE;
        D28 := D102;
        
        dest_ab := 0;
        IF dest_ab > D10 AND dest_ab > D12 THEN
            D20 := MIN(dest_ab, D12 + 700);
            D24 := MIN(dest_ab, D10 + 700);
        ELSIF dest_ab < D10 AND dest_ab < D12 THEN
            D20 := MAX(dest_ab, D12 - 700);
            D24 := MAX(dest_ab, D10 - 700);
        ELSE
            D20 := dest_ab;
            D24 := dest_ab;
        END_IF;
        
        IF ABS(D10) <= 20 AND ABS(D12) <= 20 AND ABS(D11) <= 100 AND ABS(D13) <= 100 THEN
            state := 6;
        END_IF;

    6:
        Y2 := TRUE;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := 0;
        D24 := 0;
        D28 := D102;
        Y30 := FALSE;
        Y31 := FALSE;
END_CASE;

END_PROGRAM