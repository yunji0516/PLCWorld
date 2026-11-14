PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    
    firstAngle : DINT := 0;
    secondAngle : DINT := 0;
    depth1Val : DINT := 0;
    depth2Val : DINT := 0;
    
    posTol : DINT := 20;
    spdTol : DINT := 100;
    
    startEdge : R_TRIG;
END_VAR

startEdge(CLK := X0);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        IF startEdge.Q THEN
            firstAngle := D101;
            secondAngle := D102;
            depth1Val := D103;
            depth2Val := D104;
            state := 1;
        END_IF;
        
    1:
        D20 := firstAngle;
        D21 := 1000;
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF ABS(D10 - firstAngle) <= posTol AND ABS(D11) <= spdTol THEN
            state := 2;
        END_IF;
        
    2:
        D24 := depth1Val;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        IF ABS(D12 - depth1Val) <= posTol AND ABS(D13) <= spdTol THEN
            state := 3;
        END_IF;
        
    3:
        D24 := 0;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        IF ABS(D12) <= posTol AND ABS(D13) <= spdTol THEN
            state := 4;
        END_IF;
        
    4:
        D20 := secondAngle;
        D21 := 1000;
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF ABS(D10 - secondAngle) <= posTol AND ABS(D11) <= spdTol THEN
            state := 5;
        END_IF;
        
    5:
        D28 := depth2Val;
        D29 := 1000;
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := TRUE;
        IF ABS(D14 - depth2Val) <= posTol AND ABS(D15) <= spdTol THEN
            state := 6;
        END_IF;
        
    6:
        D28 := 0;
        D29 := 1000;
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := TRUE;
        IF ABS(D14) <= posTol AND ABS(D15) <= spdTol THEN
            state := 7;
        END_IF;
        
    7:
        D20 := secondAngle;
        D21 := 1000;
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF ABS(D10 - secondAngle) <= posTol AND ABS(D11) <= spdTol
           AND ABS(D12) <= posTol AND ABS(D13) <= spdTol
           AND ABS(D14) <= posTol AND ABS(D15) <= spdTol THEN
            Y2 := TRUE;
        END_IF;
        
END_CASE;

END_PROGRAM