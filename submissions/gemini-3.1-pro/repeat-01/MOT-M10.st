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
    req_pos : DINT := 0;
END_VAR

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        D21 := 0;
        D25 := 0;
        IF X0 THEN
            req_pos := D101;
            state := 1;
        END_IF;
        
    1:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;
        IF ABS(D10 - 50000) <= 20 AND ABS(D11) <= 100 AND ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            state := 2;
        END_IF;
        
    2:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D21 := 1000;
        D24 := 9000;
        D25 := 1000;
        IF ABS(D10 - 50000) <= 20 AND ABS(D11) <= 100 AND ABS(D12 - 9000) <= 20 AND ABS(D13) <= 100 THEN
            state := 3;
        END_IF;
        
    3:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := req_pos;
        D21 := 1000;
        D24 := 9000;
        D25 := 1000;
        IF ABS(D10 - req_pos) <= 20 AND ABS(D11) <= 100 AND ABS(D12 - 9000) <= 20 AND ABS(D13) <= 100 THEN
            state := 4;
        END_IF;
        
    4:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D21 := 1000;
        D24 := 9000;
        D25 := 1000;
        IF ABS(D10 - 50000) <= 20 AND ABS(D11) <= 100 AND ABS(D12 - 9000) <= 20 AND ABS(D13) <= 100 THEN
            state := 5;
        END_IF;
        
    5:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;
        IF ABS(D10 - 50000) <= 20 AND ABS(D11) <= 100 AND ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            state := 6;
        END_IF;
        
    6:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 20000;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;
        IF ABS(D10 - 20000) <= 20 AND ABS(D11) <= 100 AND ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            state := 7;
        END_IF;
        
    7:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 20000;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;
        Y2 := TRUE;
END_CASE;

END_PROGRAM