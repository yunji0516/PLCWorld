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
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    D15 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT;
    D204 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    head_state : INT := 0;
    fork_state : INT := 0;
    pick_kind : INT := 0;
    target_side : INT := 0;
    init_done : BOOL := FALSE;
    a_pallet_done : BOOL := FALSE;
    b_pallet_done : BOOL := FALSE;
    a_shipped : BOOL := FALSE;
    b_shipped : BOOL := FALSE;
    bHeadUsingD201 : BOOL := FALSE;
    bForkUsingD201 : BOOL := FALSE;
    complete_cond : BOOL := FALSE;
END_VAR

IF NOT init_done THEN
    D203 := 850;
    Y14 := TRUE;
    D204 := 850;
    Y15 := TRUE;
    init_done := TRUE;
END_IF

IF X1B AND NOT X1D THEN
    Y10 := TRUE;
ELSE
    Y10 := FALSE;
END_IF

IF X1C AND NOT X1E THEN
    Y11 := TRUE;
ELSE
    Y11 := FALSE;
END_IF

bHeadUsingD201 := (head_state = 20);

CASE fork_state OF
0:
    IF NOT a_pallet_done AND NOT X28 AND X27 THEN
        fork_state := 10;
    ELSIF NOT b_pallet_done AND NOT X29 AND X27 THEN
        fork_state := 20;
    ELSIF X1F AND NOT a_shipped AND NOT X12 THEN
        fork_state := 39;
    ELSIF X20 AND NOT b_shipped AND NOT X12 THEN
        fork_state := 49;
    END_IF

10: 
    Y1C := TRUE;
    IF X2A THEN Y1C := FALSE; fork_state := 11; END_IF
11: 
    Y1D := TRUE;
    IF X2B THEN Y1D := FALSE; fork_state := 19; END_IF
19: 
    IF NOT bHeadUsingD201 THEN fork_state := 12; END_IF
12: 
    D201 := 1; Y1E := TRUE;
    IF X2C THEN Y1E := FALSE; fork_state := 13; END_IF
13: 
    Y1F := TRUE;
    IF X18 THEN Y1F := FALSE; a_pallet_done := TRUE; fork_state := 0; END_IF

20: 
    Y1C := TRUE;
    IF X2A THEN Y1C := FALSE; fork_state := 21; END_IF
21: 
    Y1D := TRUE;
    IF X2B THEN Y1D := FALSE; fork_state := 29; END_IF
29: 
    IF NOT bHeadUsingD201 THEN fork_state := 22; END_IF
22: 
    D201 := 2; Y1E := TRUE;
    IF X2C THEN Y1E := FALSE; fork_state := 23; END_IF
23: 
    Y1F := TRUE;
    IF X18 THEN Y1F := FALSE; b_pallet_done := TRUE; fork_state := 0; END_IF

39: 
    IF NOT bHeadUsingD201 THEN fork_state := 30; END_IF
30: 
    D201 := 1; Y16 := TRUE;
    IF X15 THEN Y16 := FALSE; fork_state := 31; END_IF
31: 
    Y17 := TRUE;
    IF X16 THEN Y17 := FALSE; fork_state := 32; END_IF
32: 
    D203 := 780; Y14 := TRUE;
    IF X23 THEN fork_state := 33; END_IF
33: 
    Y18 := TRUE;
    IF X17 THEN Y18 := FALSE; fork_state := 34; END_IF
34: 
    IF X19 THEN fork_state := 35; END_IF
35: 
    Y19 := TRUE; Y1A := TRUE;
    IF X18 THEN Y19 := FALSE; Y1A := FALSE; a_shipped := TRUE; fork_state := 36; END_IF
36: 
    D203 := 850; Y14 := TRUE;
    IF X21 THEN fork_state := 0; END_IF

49: 
    IF NOT bHeadUsingD201 THEN fork_state := 40; END_IF
40: 
    D201 := 2; Y16 := TRUE;
    IF X15 THEN Y16 := FALSE; fork_state := 41; END_IF
41: 
    Y17 := TRUE;
    IF X16 THEN Y17 := FALSE; fork_state := 42; END_IF
42: 
    D204 := 780; Y15 := TRUE;
    IF X24 THEN fork_state := 43; END_IF
43: 
    Y18 := TRUE;
    IF X17 THEN Y18 := FALSE; fork_state := 44; END_IF
44: 
    IF X19 THEN fork_state := 45; END_IF
45: 
    Y19 := TRUE; Y1A := TRUE;
    IF X18 THEN Y19 := FALSE; Y1A := FALSE; b_shipped := TRUE; fork_state := 46; END_IF
46: 
    D204 := 850; Y15 := TRUE;
    IF X22 THEN fork_state := 0; END_IF
END_CASE

bForkUsingD201 := (fork_state = 12) OR (fork_state = 22) OR (fork_state = 30) OR (fork_state = 40);

CASE head_state OF
0:
    IF NOT X12 THEN
        IF X1D AND NOT X1F AND X25 AND D7 > 0 THEN
            IF (D7 = 1 AND X10) OR (D7 = 2 AND X11) THEN
                pick_kind := D7;
                target_side := 1;
                head_state := 10;
            END_IF
        END_IF
        
        IF head_state = 0 AND X1E AND NOT X20 AND X26 AND D8 > 0 THEN
            IF (D8 = 1 AND X10) OR (D8 = 2 AND X11) THEN
                pick_kind := D8;
                target_side := 2;
                head_state := 10;
            END_IF
        END_IF
    END_IF

10: 
    D200 := pick_kind;
    Y12 := TRUE; 
    IF X13 THEN 
        Y12 := FALSE;
        head_state := 11;
    END_IF

11: 
    IF NOT bForkUsingD201 THEN
        head_state := 20;
    END_IF

20: 
    D201 := target_side;
    IF target_side = 1 THEN D202 := D9; ELSE D202 := D10; END_IF
    Y13 := TRUE;
    IF NOT X13 THEN
        Y13 := FALSE;
        head_state := 21;
    END_IF

21: 
    IF NOT X12 THEN
        head_state := 0;
    END_IF
END_CASE

complete_cond := a_shipped AND b_shipped AND fork_state = 0 AND head_state = 0 AND X21 AND X22;
IF complete_cond THEN
    Y1B := TRUE;
END_IF

END_PROGRAM