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
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
    X36 : BOOL;
    X37 : BOOL;
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
    D100 : INT;
    D101 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;

    state : INT := 0;
    sub_state : INT := 0;
    started : BOOL := FALSE;
    current_is_a : BOOL := TRUE;
    a_count : INT := 0;
    b_count : INT := 0;
    total_count : INT := 0;
    dest_pose : INT := 0;
    prev_accepted : INT := 0;
    reject_used : ARRAY [0..3] OF BOOL;
    ton_outfeed : TON;
    outfeed_timer_en : BOOL := FALSE;
END_VAR

ton_outfeed(IN := outfeed_timer_en, PT := T#1000ms);

IF X0 THEN
    started := TRUE;
END_IF;

CASE state OF
    0:
        IF started THEN
            state := 10;
        END_IF;

    10:
        IF a_count < 2 THEN
            current_is_a := TRUE;
            state := 20;
            sub_state := 0;
        ELSIF b_count < 2 THEN
            current_is_a := FALSE;
            state := 20;
            sub_state := 0;
        ELSE
            state := 300;
        END_IF;

    20:
        CASE sub_state OF
            0:
                IF (NOT X10) AND (D1 = D101) THEN
                    IF current_is_a THEN
                        D100 := 1;
                    ELSE
                        D100 := 2;
                    END_IF;
                    D101 := D101 + 1;
                    sub_state := 1;
                END_IF;
            1:
                IF (NOT X10) AND (D1 = D101) THEN
                    IF (current_is_a AND (D0 = 1)) OR ((NOT current_is_a) AND (D0 = 2)) THEN
                        sub_state := 0;
                        state := 30;
                    END_IF;
                END_IF;
        END_CASE;

    30:
        Y11 := FALSE;
        Y10 := TRUE;
        IF X13 THEN
            state := 40;
            sub_state := 0;
        END_IF;

    40:
        CASE sub_state OF
            0:
                IF current_is_a THEN
                    IF X21 AND X26 AND X1E AND (NOT X10) AND (D1 = D101) THEN
                        D100 := 3;
                        D101 := D101 + 1;
                        sub_state := 1;
                    END_IF;
                ELSE
                    IF X2C AND X31 AND X29 AND (NOT X10) AND (D1 = D101) THEN
                        D100 := 4;
                        D101 := D101 + 1;
                        sub_state := 1;
                    END_IF;
                END_IF;
            1:
                IF (NOT X10) AND (D1 = D101