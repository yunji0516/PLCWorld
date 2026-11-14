PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D94 : DINT;
    D95 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    init_d95 : DINT := 0;
END_VAR

Y30 := FALSE;
Y2 := FALSE;

CASE state OF
    0:
        IF X0 THEN
            init_d95 := D95;
            state := 1;
        END_IF;

    1:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := D101;
        D21 := 1000;
        D24 := D102;
        D25 := 1000;
        
        IF ABS(D10 - D101) <= 20 AND ABS(D11) <= 100 AND 
           ABS(D12 - D102) <= 20 AND ABS(D13) <= 100 AND NOT X34 THEN
            state := 2;
        END_IF;

    2:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := D101;
        D21 := 1000;
        D24 := D102;
        D25 := 1000;
        Y30 := TRUE;
        
        IF X34 THEN
            state := 3;
        END_IF;

    3:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := D101;
        D21 := 1000;
        D24 := D102;
        D25 := 1000;
        
        IF X35 OR D95 > init_d95 THEN
            state := 4;
        END_IF;

    4:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := D101;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;
        
        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            state := 5;
        END_IF;

    5:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := D101;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;
        Y2 := TRUE;

END_CASE;

END_PROGRAM