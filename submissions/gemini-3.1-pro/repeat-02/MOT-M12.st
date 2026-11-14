PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y24 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y25 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
END_VAR

CASE state OF
    0:
        IF X0 THEN
            state := 1;
        END_IF

    1:
        (* Check 1: Extraction position - A=40, B=180, C=0, D=0 *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        
        Y24 := TRUE;
        D20 := 0;
        D21 := 1000;
        
        Y25 := TRUE;
        D24 := 0;
        D25 := 1000;
        
        IF X2 AND X4 AND (ABS(D10) <= 20) AND (ABS(D11) <= 100) AND (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
            state := 2;
        END_IF

    2:
        (* Move to Jig approach horizontal coordinates - A=40, B=0, D=100 *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        
        D24 := 10000;
        
        IF X2 AND X3 AND X5 AND (D12 >= 9980) AND (D12 <= 10020) AND (ABS(D13) <= 100) THEN
            state := 3;
        END_IF

    3:
        (* Check 2: Jig approach depth - C=50 *)
        D20 := 5000;
        
        IF (D10 >= 4980) AND (D10 <= 5020) AND (ABS(D11) <= 100) THEN
            state := 4;
        END_IF

    4:
        (* Retract C to safe height before horizontal moves *)
        D20 := 0;
        
        IF (D10 <= 900) THEN
            state := 5;
        END_IF

    5:
        (* Return all to origin - A=0, B=0, C=0, D=0 *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := TRUE;
        D24 := 0;
        
        IF X1 AND X3 AND (ABS(D10) <= 20) AND (ABS(D11) <= 100) AND (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
            state := 6;
        END_IF

    6:
        (* Claim completion while maintaining origins *)
        Y2 := TRUE;
END_CASE

END_PROGRAM