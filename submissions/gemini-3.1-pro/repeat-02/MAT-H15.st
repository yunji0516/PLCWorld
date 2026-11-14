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
    
    init : BOOL;
    a_accepted_flag : BOOL;
    b_accepted_flag : BOOL;
    a_removed : BOOL;
    b_removed : BOOL;
    Fork_State : INT;
    Head_State : INT;
    target : INT;
    fork_uses_side : BOOL;
    all_completed : BOOL;
END_VAR

IF NOT init THEN
    D203 := 850;
    D204 := 850;
    init := TRUE;
END_IF;

Y14 := TRUE;
Y15 := TRUE;

IF X1B AND NOT a_accepted_flag THEN
    Y10 := TRUE;
    a_accepted_flag := TRUE;
    a_removed := FALSE;
ELSE
    Y10 := FALSE;
END_IF;

IF X1C AND NOT b_accepted_flag THEN
    Y11 := TRUE;
    b_accepted_flag := TRUE;
    b_removed := FALSE;
ELSE
    Y11 := FALSE;
END_IF;

CASE Fork_State OF
    0:
        IF Head_State <> 111 THEN
            IF X1D AND NOT X1F AND NOT X28 AND NOT a_removed THEN 
                Fork_State := 10;
            ELSIF X1E AND NOT X20 AND NOT X29 AND NOT b_removed THEN 
                Fork_State := 20;
            ELSIF X1F AND NOT a_removed THEN 
                Fork_State := 30;
            ELSIF X20 AND NOT b_removed THEN 
                Fork_State := 40;
            END_IF;
        END_IF;

    10: IF X27 THEN Fork_State := 11; END_IF;
    11: IF X2A AND Head_State <> 111 THEN Fork_State := 12; END_IF;
    12: IF X2B THEN Fork_State := 13; END_IF;
    13: IF X2C THEN Fork_State := 14; END_IF;
    14: IF X18 AND X28 THEN Fork_State := 0; END_IF;

    20: IF X27 THEN Fork_State := 21; END_IF;
    21: IF X2A AND Head_State <> 111 THEN Fork_State := 22; END_IF;
    22: IF X2B THEN Fork_State := 23; END_IF;
    23: IF X2C THEN Fork_State := 24; END_IF;
    24: IF X18 AND X29 THEN Fork_State := 0; END_IF;

    30: IF NOT X12 AND Head_State <> 111 THEN Fork_State := 31; END_IF;
    31: IF X15 THEN Fork_State := 32; END_IF;
    32: IF X16 THEN Fork_State := 33; END_IF;
    33: IF X23 THEN Fork_State := 34; END_IF;
    34: IF X17 THEN Fork_State := 35; END_IF;
    35: IF X19 THEN Fork_State := 36; END_IF;
    36: IF NOT X19 THEN Fork_State := 37; END_IF;
    37: IF X18 THEN Fork_State := 38; END_IF;
    38: IF X21 THEN a_removed := TRUE; Fork_State := 0; END_IF;

    40: IF NOT X12 AND Head_State <> 111 THEN Fork_State := 41; END_IF;
    41: IF X15 THEN Fork_State := 42; END_IF;
    42: IF X16 THEN Fork_State := 43; END_IF;
    43: IF X24 THEN Fork_State := 44; END_IF;
    44: IF X17 THEN Fork_State := 45; END_IF;
    45: IF X19 THEN Fork_State := 46; END_IF;
    46: IF NOT X19 THEN Fork_State := 47; END_IF;
    47: IF X18 THEN Fork_State := 48; END_IF;
    48: IF X22 THEN b_removed := TRUE; Fork_State := 0; END_IF;
END_CASE;

fork_uses_side := (Fork_State = 12) OR (Fork_State = 13) OR 
                  (Fork_State = 22) OR (Fork_State = 23) OR 
                  (Fork_State = 30) OR (Fork_State = 31) OR 
                  (Fork_State = 40) OR (Fork_State = 41);

CASE Head_State OF
    0:
        IF D7 = 1 AND X10 AND NOT X1F THEN
            target := 1; 
            D200 := 1; 
            Head_State := 10;
        ELSIF D7 = 2 AND X11 AND NOT X1F THEN
            target := 1; 
            D200 := 2; 
            Head_State := 10;
        ELSIF D8 = 1 AND X10 AND NOT X20 THEN
            target := 2; 
            D200 := 1; 
            Head_State := 10;
        ELSIF D8 = 2 AND X11 AND NOT X20 THEN
            target := 2; 
            D200 := 2; 
            Head_State := 10;
        END_IF;
        
    10:
        IF X13 THEN 
            Head_State := 11; 
        END_IF;
        
    11:
        IF (target = 1 AND X25 AND X28 AND NOT X1F) OR (target = 2 AND X26 AND X29 AND NOT X20) THEN
            IF NOT fork_uses_side THEN
                Head_State := 111;
            END_IF;
        END_IF;
        
    111:
        D201 := target;
        IF target = 1 THEN 
            D202 := 850 + D9; 
        ELSE 
            D202 := 850 + D10; 
        END_IF;
        
        IF NOT X13 THEN 
            Head_State := 12; 
        END_IF;
        
    12:
        IF NOT X12 THEN 
            Head_State := 0; 
        END_IF;
END_CASE;

Y1C := (Fork_State = 11) OR (Fork_State = 21);
Y1D := (Fork_State = 12) OR (Fork_State = 22);
Y1E := (Fork_State = 13) OR (Fork_State = 23);
Y1F := (Fork_State = 14) OR (Fork_State = 24);

Y16 := (Fork_State = 31) OR (Fork_State = 41);
Y17 := (Fork_State = 32) OR (Fork_State = 42);
Y18 := (Fork_State = 34) OR (Fork_State = 44);
Y19 := (Fork_State = 35) OR (Fork_State = 45);
Y1A := (Fork_State = 36) OR (Fork_State = 46);

Y12 := (Head_State = 10);
Y13 := (Head_State = 111);

IF (Fork_State >= 12 AND Fork_State <= 13) OR (Fork_State >= 30 AND Fork_State <= 31) THEN
    D201 := 1;
ELSIF (Fork_State >= 22 AND Fork_State <= 23) OR (Fork_State >= 40 AND Fork_State <= 41) THEN
    D201 := 2;
ELSIF Head_State = 111 THEN
    D201 := target;
END_IF;

IF Fork_State = 33 OR Fork_State = 34 OR Fork_State = 35 OR Fork_State = 36 OR Fork_State = 37 THEN
    D203 := 780;
ELSE
    D203 := 850;
END_IF;

IF Fork_State = 43 OR Fork_State = 44 OR Fork_State = 45 OR Fork_State = 46 OR Fork_State = 47 THEN
    D204 := 780;
ELSE
    D204 := 850;
END_IF;

all_completed := a_removed AND b_removed AND (Fork_State = 0) AND (Head_State = 0);
IF all_completed THEN
    Y1B := TRUE;
ELSE
    Y1B := FALSE;
END_IF;

END_PROGRAM