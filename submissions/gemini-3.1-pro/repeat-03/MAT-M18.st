PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D200 : INT;
    
    state : INT := 0;
    start_req : BOOL := FALSE;
    complete_timer : INT := 0;
END_VAR

IF X0 THEN
    start_req := TRUE;
END_IF

CASE state OF
    0:
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        D200 := 100;
        
        IF start_req AND X12 AND NOT X14 THEN
            state := 1;
            D200 := D0;
        END_IF
        
    1:
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := TRUE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        D200 := D0;
        
        IF X11 AND (ABS(D1 - D0) <= 1) THEN
            state := 2;
        END_IF

    2:
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        
        IF X14 THEN
            state := 3;
        END_IF

    3:
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        
        IF X19 THEN
            state := 4;
        END_IF

    4:
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := TRUE;
        Y17 := FALSE;
        
        IF X1C THEN
            state := 5;
        END_IF

    5:
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := TRUE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := TRUE;
        Y17 := FALSE;
        
        IF X16 THEN
            state := 6;
        END_IF

    6:
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := TRUE;
        Y17 := FALSE;
        
        IF X15 AND X17 THEN
            state := 7;
        END_IF

    7:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := TRUE;
        Y17 := FALSE;
        
        IF X13 THEN
            state := 8;
            D200 := 100;
        END_IF

    8:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := TRUE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := TRUE;
        Y17 := FALSE;
        D200 := 100;
        
        IF X18 AND X10 AND X11 THEN
            state := 9;
        END_IF

    9:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := TRUE;
        Y17 := FALSE;
        
        IF X1B AND X1D THEN
            state := 10;
        END_IF

    10:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := TRUE;
        Y16 := TRUE;
        Y17 := FALSE;
        
        IF X19 THEN
            state := 11;
        END_IF

    11:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := TRUE;
        Y16 := FALSE;
        Y17 := FALSE;
        
        IF NOT X1C THEN
            state := 12;
        END_IF

    12:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := FALSE;
        Y17 := FALSE;
        
        IF X18 THEN
            state := 13;
        END_IF

    13:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        
        IF X1A THEN
            state := 14;
        END_IF

    14:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        
        IF (ABS(D3 - D0) <= 1) AND X14 AND X15 AND X10 AND X13 AND X18 AND X1A AND NOT X1C THEN
            complete_timer := complete_timer + 1;
        ELSE
            complete_timer := 0;
        END_IF
        
        IF complete_timer >= 51 THEN
            Y17 := TRUE;
        ELSE
            Y17 := FALSE;
        END_IF

END_CASE

END_PROGRAM