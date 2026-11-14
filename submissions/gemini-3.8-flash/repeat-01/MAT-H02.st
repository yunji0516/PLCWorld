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
    Y20 : BOOL;
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
    D16 : INT;
    D200 : INT;
    D201 : INT;
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
    Y1F : BOOL;

    started : BOOL := FALSE;
    deck_state : INT := 0;
    prev_busy : BOOL := FALSE;
    deck_target : INT := 1;
    deck_action : INT := 0; (* 0=none, 1=load, 2=unload *)

    (* Box Handling *)
    box_state : INT := 0;
    clamp_timer : TON;
    boxes_dispatched : INT := 0;

    (* Packing Handling *)
    pack_state : INT := 0;
    a_pack_done : BOOL := FALSE;
    b_pack_done : BOOL := FALSE;

    (* Order states *)
    a_closing : BOOL := FALSE;
    b_closing : BOOL := FALSE;
    a_released : BOOL := FALSE;
    b_released : BOOL := FALSE;

    (* Completion *)
    done_timer : TON;
    completed : BOOL := FALSE;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y20 := FALSE;
    Y1A := FALSE;
    Y1B := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    RETURN;
END_IF;

(* 1. Order Acceptance *)
IF X13 AND NOT X15 THEN
    Y13 := TRUE;
ELSE
    Y13 := FALSE;
END_IF;

IF X14 AND NOT X16 THEN
    Y14 := TRUE;
ELSE
    Y14 := FALSE;
END_IF;

(* 2. Assembly Jig Coupling Request *)
IF X15 AND (D13 >= 2) AND NOT X17 AND NOT a_closing THEN
    Y15 := TRUE;
    a_closing := TRUE;
ELSE
    Y15 := FALSE;
END_IF;
IF NOT X15 OR X17 THEN
    a_closing := FALSE;
END_IF;

IF X16 AND (D14 >= 2) AND NOT X18 AND NOT b_closing THEN
    Y16 := TRUE;
    b_closing := TRUE;
ELSE
    Y16 := FALSE;
END_IF;
IF NOT X16 OR X18 THEN
    b_closing := FALSE;
END_IF;

(* 3. Release to exit when ready *)
IF X17 AND X19 AND NOT a_released AND NOT X1B THEN
    Y17 := TRUE;
    a_released := TRUE;
ELSE
    Y17 := FALSE;
END_IF;
IF NOT X17 THEN
    a_released := FALSE;
END_IF;

IF X18 AND X1A AND NOT b_released AND NOT X1C THEN
    Y18 := TRUE;
    b_released := TRUE;
ELSE
    Y18 := FALSE;
END_IF;
IF NOT X18 THEN
    b_released := FALSE;
END_IF;

(* 4. Box Feeding and Clamping *)
clamp_timer(IN := X1F AND (box_state = 1), PT := T#300ms);

CASE box_state OF
    0: (* Feed box *)
        IF boxes_dispatched < 2 THEN
            IF NOT X1F THEN
                Y1C := TRUE;
                IF X1E THEN
                    box_state := 1;
                END_IF;
            ELSE
                box_state := 1;
            END_IF;
        END_IF;

    1: (* Wait for box at station, then clamp *)
        IF X1F THEN
            Y1C := FALSE;
            IF clamp_timer.Q THEN
                Y1D := TRUE;
                IF X20 THEN
                    box_state := 2;
                END_IF;
            END_IF;
        END_IF;

    2: (* Box clamped, ready for packing and waiting until full *)
        Y1D := TRUE;
        IF X24 THEN
            (* Box full, release clamp *)
            Y1D := FALSE;
            IF NOT X20 THEN
                box_state := 3;
            END_IF;
        END_IF;

    3: (* Dispatch box *)
        IF X25 THEN
            Y20 := TRUE;
            boxes_dispatched := boxes_dispatched + 1;
            a_pack_done := FALSE;
            b_pack_done := FALSE;
            box_state := 4;
        END_IF;

    4: (* Reset dispatch pulse *)
        Y20 := FALSE;
        IF boxes_dispatched < 2 THEN
            box_state := 0;
        ELSE
            box_state := 5;
        END_IF;

    5: (* All boxes dispatched *)
        Y20 := FALSE;
        Y1D := FALSE;
        Y1C := FALSE;
END_CASE;

(* 5. Orthogonal Head Packing *)
CASE pack_state OF
    0: (* Wait for box clamped and kit ready to pack *)
        Y1E := FALSE;
        Y1F := FALSE;
        Y19 := FALSE;
        Y1A := FALSE;
        IF X20 AND NOT X21 THEN
            IF X1B AND (D9 = D16) AND NOT a_pack_done THEN
                Y1E := TRUE;
                pack_state := 1;
            ELSIF X1C AND (D10 = D16) AND NOT b_pack_done THEN
                Y1F := TRUE;
                pack_state := 3;
            END_IF;
        END_IF;

    1: (* a pack pulsed *)
        Y1E := FALSE;
        IF X22 THEN
            Y19 := TRUE; (* ack_a *)
            a_pack_done := TRUE;
            pack_state := 2;
        END_IF;

    2: (* wait ack_a clear *)
        Y19 := FALSE;
        pack_state := 0;

    3: (* b pack pulsed *)
        Y1F := FALSE;
        IF X23 THEN
            Y1A := TRUE; (* ack_b *)
            b_pack_done := TRUE;
            pack_state := 4;
        END_IF;

    4: (* wait ack_b clear *)
        Y1A := FALSE;
        pack_state := 0;
END_CASE;

(* 6. Deck Motion and Part Transfer State Machine *)
CASE deck_state OF
    0: (* Idle / Decision State *)
        Y10 := FALSE;
        Y11 := FALSE;
        Y12 := FALSE;
        deck_action := 0;

        IF NOT X11 THEN
            IF D1 = 0 THEN
                (* Deck is empty: decide where to load from *)
                (* Priority 1: Storage slot 0 matches an active need *)
                IF (D5 > 0) AND ((X15 AND (D6 = D11)) OR (X16 AND (D6 = D12))) THEN
                    deck_target := 2;
                    deck_action := 1;
                (* Priority 2: Storage slot 1 matches an active need *)
                ELSIF (D7 > 0) AND ((X15 AND (D8 = D11)) OR (X16 AND (D8 = D12))) THEN
                    deck_target := 3;
                    deck_action := 1;
                (* Priority 3: Head matches active need *)
                ELSIF X10 AND (D3 > 0) AND ((X15 AND (D4 = D11)) OR (X16 AND (D4 = D12))) THEN
                    deck_target := 1;
                    deck_action := 1;
                (* Priority 4: Storage has space and head is ready: buffer to slot 0 or 1 *)
                ELSIF X10 AND (D3 > 0) AND ((D5 = 0) OR (D7 = 0)) THEN
                    deck_target := 1;
                    deck_action := 1;
                END_IF;

                IF deck_action = 1 THEN
                    IF D0 = deck_target THEN
                        deck_state := 3; (* Load immediately *)
                    ELSE
                        D200 := deck_target;
                        Y10 := TRUE;
                        deck_state := 1; (* Move to dock target *)
                    END_IF;
                END_IF;
            ELSE
                (* Deck has an item: decide where to unload *)
                IF X15 AND (D2 = D11) THEN
                    deck_target := 4; (* Deliver to Jig A *)
                    D201 := D9;
                    deck_action := 2;
                ELSIF X16 AND (D2 = D12) THEN
                    deck_target := 5; (* Deliver to Jig B *)
                    D201 := D10;
                    deck_action := 2;
                ELSIF D5 = 0 THEN
                    deck_target := 2; (* Store in slot 0 *)
                    deck_action := 2;
                ELSIF D7 = 0 THEN
                    deck_target := 3; (* Store in slot 1 *)
                    deck_action := 2;
                END_IF;

                IF deck_action = 2 THEN
                    IF D0 = deck_target THEN
                        deck_state := 4; (* Unload immediately *)
                    ELSE
                        D200 := deck_target;
                        Y10 := TRUE;
                        deck_state := 1; (* Move to dock target *)
                    END_IF;
                END_IF;
            END_IF;
        END_IF;

    1: (* Dock rising edge pulsed, wait for busy to engage or target reached *)
        Y10 := FALSE;
        deck_state := 2;

    2: (* Moving: wait for arrival at dock and busy OFF *)
        IF NOT X11 AND (D0 = deck_target) THEN
            IF deck_action = 1 THEN
                deck_state := 3;
            ELSIF deck_action = 2 THEN
                deck_state := 4;
            ELSE
                deck_state := 0;
            END_IF;
        END_IF;

    3: (* At dock, perform Load *)
        Y11 := TRUE;
        IF X11 OR X12 OR (D1 > 0) THEN
            Y11 := FALSE;
            deck_state := 5;
        END_IF;

    4: (* At dock, perform Unload *)
        IF deck_target = 4 THEN
            D201 := D9;
        ELSIF deck_target = 5 THEN
            D201 := D10;
        END_IF;
        Y12 := TRUE;
        IF X11 OR (D1 = 0) THEN
            Y12 := FALSE;
            deck_state := 5;
        END_IF;

    5: (* Wait for transfer completion (busy OFF) *)
        Y11 := FALSE;
        Y12 := FALSE;
        IF NOT X11 THEN
            deck_state := 0;
        END_IF;
END_CASE;

(* 7. Completion Evaluation *)
done_timer(IN := (boxes_dispatched >= 2) AND (D1 = 0) AND NOT X11 AND (D15 >= 2), PT := T#500ms);

IF done_timer.Q THEN
    completed := TRUE;
END_IF;

IF completed THEN
    Y1B := TRUE;
ELSE
    Y1B := FALSE;
END_IF;

END_PROGRAM
