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

    started : BOOL := FALSE;
    step_a : INT := 0;
    step_b : INT := 0;
    step_bin : INT := 0;
    batches_started_a : INT := 0;
    batches_done_a : INT := 0;
    batches_started_b : INT := 0;
    batches_done_b : INT := 0;
    swapped : BOOL := FALSE;
    bin101_retrieved : BOOL := FALSE;
    is_complete : BOOL := FALSE;
END_VAR

(* Latch start condition *)
IF X0 OR X16 OR X1C THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    RETURN;
END_IF;

(* If overall completion achieved, maintain completion and ensure actuators remain OFF *)
IF is_complete THEN
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := TRUE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    RETURN;
END_IF;

(* ========================================== *)
(* PRESS A CONTROL LOGIC                      *)
(* ========================================== *)
CASE step_a OF
    0: (* WAIT_FEED *)
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        IF X16 AND (NOT X17) AND (D5 = 0) AND (NOT X19) AND (NOT X1A) THEN
            IF batches_started_a = 0 THEN
                (* Batch 1: size 3, fits into initial bin 101 *)
                IF X10 AND (NOT X11) AND (D0 + D1 + 3 <= 6) THEN
                    step_a := 1;
                END_IF;
            ELSIF batches_started_a = 1 THEN
                (* Batch 3: size 3, requires bin 102 to be docked *)
                IF swapped AND X10 AND (NOT X11) AND (D2 = 102) AND (D0 + D1 + 3 <= 6) THEN
                    step_a := 1;
                END_IF;
            END_IF;
        END_IF;

    1: (* FEEDING *)
        IF X17 OR (D5 > 0) THEN
            Y13 := FALSE;
            step_a := 2;
        ELSE
            Y13 := TRUE;
        END_IF;

    2: (* WAIT_START *)
        Y13 := FALSE;
        IF X17 AND (NOT X19) AND (NOT X1A) AND X10 AND (NOT X11) AND (NOT Y17) THEN
            IF batches_started_a = 0 THEN
                IF (D0 + D1 + 3 <= 6) THEN
                    Y14 := TRUE;
                    batches_started_a := batches_started_a + 1;
                    step_a := 3;
                END_IF;
            ELSIF batches_started_a = 1 THEN
                IF (D2 = 102) AND (D0 + D1 + 3 <= 6) THEN
                    Y14 := TRUE;
                    batches_started_a := batches_started_a + 1;
                    step_a := 3;
                END_IF;
            END_IF;
        END_IF;

    3: (* START_PULSE *)
        Y14 := FALSE;
        step_a := 4;

    4: (* PROCESSING *)
        IF X1A AND (NOT X19) THEN
            step_a := 5;
        END_IF;

    5: (* WAIT_EJECT *)
        IF X1B THEN
            Y15 := TRUE;
            step_a := 6;
        END_IF;

    6: (* EJECT_PULSE *)
        Y15 := FALSE;
        step_a := 7;

    7: (* WAIT_EXIT *)
        IF (NOT X17) AND (D5 = 0) THEN
            batches_done_a := batches_done_a + 1;
            IF batches_done_a >= 2 THEN
                step_