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
    D200 : INT;
    D201 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;

    started : BOOL := FALSE;
    state : INT := 0;
    target_side : INT := 0;
    a_sent_count : INT := 0;
    b_sent_count : INT := 0;
    swap_state : INT := 0;
    complete_timer : TON;
    ton_delay : TON;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    Y10 := TRUE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y1A := FALSE;
    D200 := 0;
    D201 := 0;
    RETURN;
END_IF;

// Assembly and release processes for Cell A and Cell B
IF X1F AND X20 AND (NOT X21) AND (NOT X22) THEN
    Y16 := TRUE;
ELSE
    Y16 := FALSE;
END_IF;

IF X22 AND X23 THEN
    Y18 := TRUE;
ELSE
    Y18 := FALSE;
END_IF;

IF X25 AND X26 AND (NOT X27) AND (NOT X28) THEN
    Y17 := TRUE;
ELSE
    Y17 := FALSE;
END_IF;

IF X28 AND X29 THEN
    Y19 := TRUE;
ELSE
    Y19 := FALSE;
END_IF;

// Magazine swap control
IF X1B AND (NOT X1C) THEN
    Y15 := TRUE;
ELSE
    Y15 := FALSE;
END_IF;

CASE swap_state OF
    0:
        IF (D0 = 201) AND (D1 = 0) AND (state = 0) AND X18 AND X14 AND X13 AND X1A AND (NOT X19) THEN
            swap_state := 1;
        END_IF;
    1:
        Y14 := TRUE;
        IF X19 THEN
            swap_state := 2;
        END_IF;
    2:
        Y14 := FALSE;
        IF (NOT X19) AND (D0 = 202) AND X10 THEN
            swap_state := 3;
        END_IF;
    3:
        // Swap complete
        swap_state := 0;
END_CASE;

// Main Extraction and Send Sequence
CASE state OF
    0:
        Y12 := FALSE;
        Y13 := FALSE;
        Y10 := TRUE;
        Y11 := FALSE;

        IF (a_sent_count + b_sent_count < 7) AND (swap_state = 0) THEN
            IF (a_sent_count < 3) AND (NOT X1F) AND X1E THEN
                target_side := 1;
            ELSIF (b_sent_count < 4) AND (NOT X25) AND X24 THEN
                target_side := 2;
            ELSIF a_sent_count < 3 THEN
                target_side := 1;
            ELSIF b_sent_count < 4 THEN
                target_side := 2;
            ELSE
                target_side := 0;
            END_IF;

            IF (target_side > 0) AND X16 AND (NOT X17) AND X11 AND X10 AND (D1 > 0) THEN
                state := 10;
            END_IF;
        END_IF;

    10:
        // Close upper support
        Y11 := TRUE;
        IF X12 THEN
            state := 20;
        END_IF;

    20:
        // Release lower support
        Y10 := FALSE;
        IF X15 AND X17 THEN
            state := 30;
        END_IF;

    30:
        // Move extractor forward
        Y12 := TRUE;
        IF X18 THEN
            state := 40;
        END_IF;

    40:
        // Restore lower support
        Y10 := TRUE;
        IF X14 THEN
            state := 50;
        END_IF;

    50:
        // Release upper support
        Y11 := FALSE;
        IF X13 THEN
            state := 60;
        END_IF;

    60:
        // Dispatch workpiece via send
        D200 := target_side;
        IF target_side = 1 THEN
            a_sent_count := a_sent_count + 1;
            D201 := a_sent_count;
        ELSE
            b_sent_count := b_sent_count + 1;
            D201 := b_sent_count;
        END_IF;
        Y13 := TRUE;
        state := 70;

    70:
        Y13 := FALSE;
        Y12 := FALSE;
        IF X16 AND (NOT X17) THEN
            state := 0;
        END_IF;
END_CASE;

// Completion Evaluation
IF (D3 >= 3) AND (D4 >= 4) AND X1D AND (D0 = 202) AND X1C AND (D1 = 1) AND X16 AND X14 AND X13 AND (state = 0) AND (swap_state = 0) THEN
    complete_timer(IN := TRUE, PT := T#500ms);
    IF complete_timer.Q THEN
        Y1A := TRUE;
    END_IF;
ELSE
    complete_timer(IN := FALSE, PT := T#500ms);
END_IF;

END_PROGRAM
