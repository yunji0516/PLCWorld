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
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;

    state : INT := 0;
    completed_count : INT := 0;
    current_pouch_id : INT := 0;
    bit_is_set : BOOL := FALSE;
    
    t_sep : TON;
    t_fix : TON;
    t_complete : TON;
END_VAR

CASE state OF
    0:
        IF X0 THEN
            state := 10;
        END_IF;
        
    10:
        IF X10 AND NOT X21 THEN
            IF X20 THEN
                state := 20;
            ELSIF X23 THEN
                state := 30;
            END_IF;
        END_IF;

    20:
        Y1B := TRUE;
        IF t_sep.Q THEN
            state := 21;
        END_IF;

    21:
        Y1C := TRUE;
        IF X21 THEN
            state := 22;
        END_IF;

    22:
        Y1C := FALSE;
        IF X23 AND NOT X21 THEN
            Y1B := FALSE;
            state := 30;
        END_IF;

    30:
        IF NOT X21 THEN
            Y10 := TRUE;
            IF X12 THEN
                state := 31;
            END_IF;
        END_IF;

    31:
        Y10 := FALSE;
        IF X11 THEN
            current_pouch_id := D0;
            state := 32;
        END_IF;

    32:
        bit_is_set := FALSE;
        CASE current_pouch_id OF
            1: bit_is_set := (D4 MOD 2) <> 0;
            2: bit_is_set := ((D4 / 2) MOD 2) <> 0;
            3: bit_is_set := ((D4 / 4) MOD 2) <> 0;
            4: bit_is_set := ((D4 / 8) MOD 2) <> 0;
        END_CASE;

        IF bit_is_set AND NOT X14 AND NOT X16 THEN
            D200 := current_pouch_id;
            Y11 := TRUE;
            IF X14 THEN
                state := 33;
            END_IF;
        END_IF;

    33:
        Y11 := FALSE;
        IF X15 AND (D2 = current_pouch_id) THEN
            state := 34;
        END_IF;

    34:
        Y1D := TRUE;
        Y1E := TRUE;
        IF X24 THEN
            state := 35;
        END_IF;

    35:
        Y1D := FALSE;
        Y1E := FALSE;
        IF X25 THEN
            state := 36;
        END_IF;

    36:
        Y12 := TRUE;
        Y13 := TRUE;
        IF X1A AND X1B THEN
            state := 37;
        END_IF;

    37:
        Y14 := TRUE;
        IF X1C AND (D5 >= (D6 + 4)) THEN
            state := 38;
        END_IF;

    38:
        Y15 := TRUE;
        IF X13 THEN
            state := 39;
        END_IF;

    39:
        IF X13 AND X1A AND X1B AND (D5 >= (D6 + 4)) AND (D2 = current_pouch_id) AND X25 THEN
            Y16 := TRUE;
            IF X18 AND X19 THEN
                state := 40;
            END_IF;
        END_IF;

    40:
        Y16 := FALSE;
        Y17 := TRUE;
        IF X17 THEN
            state := 41;
        END_IF;

    41:
        Y17 := FALSE;
        Y14 := FALSE;
        IF t_fix.Q THEN
            state := 42;
        END_IF;

    42:
        IF X1D AND NOT X14 AND NOT X16 THEN
            Y18 := TRUE;
            state := 43;
        END_IF;

    43:
        Y18 := FALSE;
        Y15 := FALSE;
        Y12 := FALSE;
        Y13 := FALSE;
        IF X1E THEN
            state := 44;
        END_IF;

    44:
        Y19 := TRUE;
        IF NOT X1E THEN
            state := 45;
        END_IF;

    45:
        Y19 := FALSE;
        completed_count := completed_count + 1;
        IF completed_count >= 4 THEN
            state := 50;
        ELSE
            state := 10;
        END_IF;

    50:
        IF NOT Y15 AND X17 AND NOT X14 AND NOT X21 THEN
            Y1A := TRUE;
            IF t_complete.Q THEN
                state := 51;
            END_IF;
        END_IF;

    51:
        ; 
END_CASE;

t_sep(IN := (state = 20), PT := T#250ms);
t_fix(IN := (state = 41), PT := T#500ms);
t_complete(IN := (state = 50) AND Y1A, PT := T#500ms);

END_PROGRAM