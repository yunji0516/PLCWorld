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
    step : INT := 0;

    a_req_count : INT := 0;
    b_req_count : INT := 0;
    total_sent : INT := 0;
    target_side : INT := 0;

    swap_done : BOOL := FALSE;
    take_empty_done : BOOL := FALSE;

    ton_drop : TON;
    ton_swap : TON;
    ton_extract : TON;
    ton_comp : TON;

    prev_return_ready : BOOL := FALSE;
    prev_take_empty : BOOL := FALSE;
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
    RETURN;
END_IF;

(* Assembly Station A control *)
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

(* Assembly Station B control *)
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

(* Empty magazine recovery *)
IF X1B AND (NOT prev_return_ready) THEN
    Y15 := TRUE;
ELSE
    Y15 := FALSE;
END_IF;
prev_return_ready := X1B;

(* Extraction and Dispense State Machine *)
CASE step OF
    0: (* Idle / Check if need to extract or swap *)
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y10 := TRUE;  (* lower closed *)
        Y11 := FALSE; (* upper open *)

        IF total_sent < 7 THEN
            IF D1 > 0 THEN
                (* Decide target cell: A needs 3, B needs 4 *)
                IF a_req_count < 3 AND X1E AND (NOT X1F) THEN
                    target_side := 1;
                ELSIF b_req_count < 4 AND X24 AND (NOT X25) THEN
                    target_side := 2;
                ELSIF a_req_count < 3 THEN
                    target_side := 1;
                ELSE
                    target_side := 2;
                END_IF;

                (* Prepare to dispense: shuttle must be home and empty *)
                IF X16 AND (NOT X17) AND X11 AND X18 AND X14 AND X13 THEN
                    Y11 := TRUE; (* engage upper retention *)
                    step := 10;
                END_IF;
            ELSE
                (* Magazine empty, initiate swap *)
                IF (NOT swap_done) AND X18 AND X14 AND X13 AND X1A AND (NOT X19) THEN
                    Y14 := TRUE;
                    step := 50;
                END_IF;
            END_IF;
        ELSE
            (* All 7 items extracted, wait for full assembly and delivery *)
            IF X1D AND (D3 >= 3) AND (D4 >= 4) AND X16 AND X14 AND X13 AND X18 THEN
                step := 100;
            END_IF;
        END_IF;

    10: (* Wait for upper to close *)
        Y11 := TRUE;
        Y10 := TRUE;
        IF X12 THEN
            Y10 := FALSE; (* release lower support *)
            step := 11;
        END_IF;

    11: (* Lower opening, waiting for item to fall onto shuttle *)
        Y11 := TRUE;
        Y10 := FALSE;
        IF X17 THEN (* shuttle loaded *)
            Y12 := TRUE; (* move extractor forward *)
            step := 12;
        END_IF;

    12: (* Moving forward with extractor *)
        Y11 := TRUE;
        Y10 := FALSE;
        Y12 := TRUE;
        IF X18 THEN (* extractor cleared column *)
            Y10 := TRUE; (* restore lower support *)
            step := 13;
        END_IF;

    13: (* Restore lower support *)
        Y11 := TRUE;
        Y10 := TRUE;
        Y12 := TRUE;
        IF X14 THEN (* lower closed *)
            Y11 := FALSE; (* release upper retention *)
            step := 14;
        END_IF;

    14: (* Wait for upper to open *)
        Y11 := FALSE;
        Y10 := TRUE;
        IF X13 THEN
            (* Ready to send to target consumption cell *)
            D200 := target_side;
            IF target_side = 1 THEN
                a_req_count := a_req_count + 1;
                D201 := a_req_count;
            ELSE
                b_req_count := b_req_count + 1;
                D201 := b_req_count;
            END_IF;
            total_sent := total_sent + 1;
            Y13 := TRUE; (* send rising edge *)
            step := 15;
        END_IF;

    15: (* Wait for shuttle to leave home and finish send pulse *)
        Y11 := FALSE;
        Y10 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        IF NOT X16 THEN
            step := 16;
        END_IF;

    16: (* Wait for shuttle to return home *)
        Y11 := FALSE;
        Y10 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        IF X16 AND (NOT X17) THEN
            step := 0; (* ready for next cycle *)
        END_IF;

    50: (* Swapping magazine *)
        Y14 := FALSE;
        IF X19 OR (D0 = 202) THEN
            step := 51;
        END_IF;

    51: (* Wait for swap completion *)
        IF (NOT X19) AND (D0 = 202) AND X10 AND X11 THEN
            swap_done := TRUE;
            step := 0;
        END_IF;

    100: (* Completion holding *)
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y1A := TRUE;
END_CASE;

ton_comp(IN := (step = 100), PT := T#500ms);
IF ton_comp.Q THEN
    Y1A := TRUE;
END_IF;

END_PROGRAM