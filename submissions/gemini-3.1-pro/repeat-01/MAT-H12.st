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
    
    state_a : INT := 0;
    state_b : INT := 0;
    accepted_in_bin : INT := 0;
    take_bin_prev : BOOL := FALSE;
    swap_prev : BOOL := FALSE;
    need_swap : BOOL := FALSE;
    swap_cond : BOOL := FALSE;
    wait_bin_change : BOOL := FALSE;
END_VAR

need_swap := (X17 AND (D6 > 0) AND ((accepted_in_bin + D6) > 6)) OR 
             (X1D AND (D8 > 0) AND ((accepted_in_bin + D8) > 6));

swap_cond := need_swap AND (D1 = 0) AND (D0 > 0) AND X12 AND NOT X13 AND NOT X14;

IF swap_cond AND NOT swap_prev THEN
    Y10 := TRUE;
    accepted_in_bin := 0;
ELSE
    Y10 := FALSE;
END_IF;
swap_prev := swap_cond;

IF Y10 THEN
    wait_bin_change := TRUE;
ELSIF NOT X10 THEN
    wait_bin_change := FALSE;
END_IF;

IF X13 AND NOT take_bin_prev THEN
    Y11 := TRUE;
ELSE
    Y11 := FALSE;
END_IF;
take_bin_prev := X13;

CASE state_a OF
    0:
        IF X16 AND NOT X17 AND NOT X19 AND NOT X1A THEN
            Y13 := TRUE;
            state_a := 1;
        END_IF;
    1:
        IF X17 THEN
            Y13 := FALSE;
            state_a := 2;
        END_IF;
    2:
        IF X17 AND X10 AND NOT wait_bin_change AND (D6 > 0) AND ((accepted_in_bin + D6) <= 6) AND NOT X19 AND (state_b <> 3) AND NOT Y14 THEN
            Y14 := TRUE;
            accepted_in_bin := accepted_in_bin + D6;
            state_a := 3;
        END_IF;
    3:
        Y14 := FALSE;
        state_a := 4;
    4:
        IF X1A THEN
            state_a := 5;
        END_IF;
    5:
        IF X1B THEN
            Y15 := TRUE;
            state_a := 6;
        END_IF;
    6:
        Y15 := FALSE;
        IF NOT X1A THEN
            state_a := 0;
        END_IF;
END_CASE;

CASE state_b OF
    0:
        IF X1C AND NOT X1D AND NOT X1F AND NOT X20 THEN
            Y16 := TRUE;
            state_b := 1;
        END_IF;
    1:
        IF X1D THEN
            Y16 := FALSE;
            state_b := 2;
        END_IF;
    2:
        IF X1D AND X10 AND NOT wait_bin_change AND (D8 > 0) AND ((accepted_in_bin + D8) <= 6) AND NOT X1F AND (state_a <> 3) AND NOT Y17 THEN
            Y17 := TRUE;
            accepted_in_bin := accepted_in_bin + D8;
            state_b := 3;
        END_IF;
    3:
        Y17 := FALSE;
        state_b := 4;
    4:
        IF X20 THEN
            state_b := 5;
        END_IF;
    5:
        IF X21 THEN
            Y18 := TRUE;
            state_b := 6;
        END_IF;
    6:
        Y18 := FALSE;
        IF NOT X20 THEN
            state_b := 0;
        END_IF;
END_CASE;

IF X15 AND (D1 = 0) AND X10 AND NOT X13 AND NOT X14 AND NOT X17 AND NOT X1D AND (state_a = 0) AND (state_b = 0) THEN
    Y12 := TRUE;
END_IF;

END_PROGRAM