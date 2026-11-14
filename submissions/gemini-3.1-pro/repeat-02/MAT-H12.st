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
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    
    state_A : INT;
    state_B : INT;
    goods_count : INT;
    swap_trigger : BOOL;
    edge_return : R_TRIG;
    complete_flag : BOOL;
    system_started : BOOL;
END_VAR

IF X0 THEN
    system_started := TRUE;
END_IF

(* Press A Control *)
CASE state_A OF
    0:
        IF system_started AND X16 AND NOT X17 AND NOT X18 AND NOT X19 AND NOT X1A THEN
            Y13 := TRUE;
            state_A := 1;
        END_IF
    1:
        IF X17 THEN
            Y13 := FALSE;
            state_A := 2;
        END_IF
    2:
        IF X10 AND ((D0 + D1 + D6) <= 6) AND (state_B < 3 OR state_B > 4) THEN
            Y14 := TRUE;
            state_A := 3;
        END_IF
    3:
        Y14 := FALSE;
        state_A := 4;
    4:
        IF X19 THEN
            state_A := 5;
        END_IF
    5:
        IF X1A THEN
            state_A := 6;
        END_IF
    6:
        IF X1B THEN
            Y15 := TRUE;
            goods_count := goods_count + 1;
            state_A := 7;
        END_IF
    7:
        Y15 := FALSE;
        IF NOT X17 AND NOT X1A THEN
            state_A := 0;
        END_IF
END_CASE

(* Press B Control *)
CASE state_B OF
    0:
        IF system_started AND X1C AND NOT X1D AND NOT X1E AND NOT X1F AND NOT X20 THEN
            Y16 := TRUE;
            state_B := 1;
        END_IF
    1:
        IF X1D THEN
            Y16 := FALSE;
            state_B := 2;
        END_IF
    2:
        IF X10 AND ((D0 + D1 + D8) <= 6) AND (state_A < 3 OR state_A > 4) THEN
            Y17 := TRUE;
            state_B := 3;
        END_IF
    3:
        Y17 := FALSE;
        state_B := 4;
    4:
        IF X1F THEN
            state_B := 5;
        END_IF
    5:
        IF X20 THEN
            state_B := 6;
        END_IF
    6:
        IF X21 THEN
            Y18 := TRUE;
            goods_count := goods_count + 1;
            state_B := 7;
        END_IF
    7:
        Y18 := FALSE;
        IF NOT X1D AND NOT X20 THEN
            state_B := 0;
        END_IF
END_CASE

(* Bin Swap Control *)
IF (state_A = 2 AND (D0 + D1 + D6 > 6)) OR (state_B = 2 AND (D0 + D1 + D8 > 6)) THEN
    IF D1 = 0 AND D0 > 0 AND X12 AND NOT X13 AND NOT X14 AND NOT X11 AND NOT swap_trigger THEN
        Y10 := TRUE;
        swap_trigger := TRUE;
    ELSE
        Y10 := FALSE;
    END_IF
ELSE
    Y10 := FALSE;
END_IF

IF NOT X10 THEN
    swap_trigger := FALSE;
END_IF

(* Bin Return Control *)
edge_return(CLK := X13);
IF edge_return.Q THEN
    Y11 := TRUE;
ELSE
    Y11 := FALSE;
END_IF

(* Completion Logic *)
IF goods_count >= 3 AND D1 = 0 AND X15 AND X10 AND NOT X11 AND NOT X13 AND NOT X14 THEN
    complete_flag := TRUE;
END_IF

Y12 := complete_flag;

END_PROGRAM