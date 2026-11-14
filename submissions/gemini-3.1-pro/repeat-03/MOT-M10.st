PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
END_VAR

D21 := 1000;
D25 := 1000;

CASE state OF
    0:
        D20 := D10;
        D24 := D12;
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF X0 THEN
            state := 1;
        END_IF
        
    1:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D24 := 0;
        IF ABS(D10 - 50000) <= 20 AND ABS(D11) <= 100 AND ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            state := 2;
        END_IF
        
    2:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D24 := 9000;
        IF ABS(D12 - 9000) <= 20 AND ABS(D13) <= 100 AND ABS(D10 - 50000) <= 20 AND ABS(D11) <= 100 THEN
            state := 3;
        END_IF
        
    3:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := D101;
        D24 := 9000;
        IF ABS(D10 - D101) <= 20 AND ABS(D11) <= 100 AND ABS(D12 - 9000) <= 20 AND ABS(D13) <= 100 THEN
            state := 4;
        END_IF
        
    4:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D24 := 9000;
        IF ABS(D10 - 50000) <= 20 AND ABS(D11) <= 100 AND ABS(D12 - 9000) <= 20 AND ABS(D13) <= 100 THEN
            state := 5;
        END_IF
        
    5:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D24 := 0;
        IF ABS(D10 - 50000) <= 20 AND ABS(D11) <= 100 AND ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            state := 6;
        END_IF
        
    6:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 20000;
        D24 := 0;
        IF ABS(D10 - 20000) <= 20 AND ABS(D11) <= 100 AND ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            state := 7;
        END_IF
        
    7:
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := TRUE;
END_CASE

END_PROGRAM