PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D20 : DINT;
    Y20 : BOOL;
    D21 : DINT;
    Y21 : BOOL;
    D22 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;

    State : INT := 0;
    InitA : DINT;
    InitB : DINT;
    SettleCnt : INT := 0;
END_VAR

CASE State OF
0:
    IF X10 THEN
        State := 1;
        InitA := D11;
        InitB := D14;
        SettleCnt := 0;
    END_IF;

1:
    D20 := InitA; 
    Y20 := TRUE;
    D21 := InitB; 
    Y21 := TRUE;
    D22 := 40000; 
    Y22 := TRUE;
    
    IF ABS(D16 - 40000) <= 20 AND ABS(D17) <= 100 AND
       ABS(D11 - InitA) <= 20 AND ABS(D12) <= 100 AND
       ABS(D14 - InitB) <= 20 AND ABS(D15) <= 100 THEN
        SettleCnt := SettleCnt + 1;
    ELSE
        SettleCnt := 0;
    END_IF;
    
    IF SettleCnt >= 4 THEN
        State := 2;
        SettleCnt := 0;
    END_IF;

2:
    D20 := D10; 
    Y20 := TRUE;
    D21 := D13; 
    Y21 := TRUE;
    D22 := 40000; 
    Y22 := TRUE;
    
    IF ABS(D16 - 40000) <= 20 AND ABS(D17) <= 100 AND
       ABS(D11 - D10) <= 20 AND ABS(D12) <= 100 AND
       ABS(D14 - D13) <= 20 AND ABS(D15) <= 100 THEN
        SettleCnt := SettleCnt + 1;
    ELSE
        SettleCnt := 0;
    END_IF;
    
    IF SettleCnt >= 4 THEN
        State := 3;
        SettleCnt := 0;
    END_IF;

3:
    D20 := D10; 
    Y20 := TRUE;
    D21 := D13; 
    Y21 := TRUE;
    D22 := 0;     
    Y22 := TRUE;
    
    IF ABS(D16) <= 20 AND ABS(D17) <= 100 AND
       ABS(D11 - D10) <= 20 AND ABS(D12) <= 100 AND
       ABS(D14 - D13) <= 20 AND ABS(D15) <= 100 THEN
        SettleCnt := SettleCnt + 1;
    ELSE
        SettleCnt := 0;
    END_IF;
    
    IF SettleCnt >= 4 THEN
        State := 4;
    END_IF;

4:
    D20 := D10; 
    Y20 := TRUE;
    D21 := D13; 
    Y21 := TRUE;
    D22 := 0;   
    Y22 := TRUE;
    Y2 := TRUE;
END_CASE;

END_PROGRAM