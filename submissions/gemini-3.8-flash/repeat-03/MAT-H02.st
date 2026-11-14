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

    started : BOOL;
    deck_state : INT;
    dest_pos : INT;

    prev_dock : BOOL;
    prev_load : BOOL;
    prev_unload : BOOL;

    step_pulse : INT;

    req_a_prev : BOOL;
    req_b_prev : BOOL;
    a_closed : BOOL;
    b_closed : BOOL;
    a_released : BOOL;
    b_released : BOOL;
    a_packed_latched : BOOL;
    b_packed_latched : BOOL;

    box_state : INT;
    pack_seq : INT;
    dispatched_count : INT;

    clamp_timer : TON;
    comp_timer : TON;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    RETURN;
END_IF;

(* ---------------- ORDER ACCEPTANCE ---------------- *)
IF X13 AND NOT X15 AND NOT req_a_prev THEN
    Y13 := TRUE;
ELSE
    Y13 := FALSE;
END_IF;
req_a_prev := X13;

IF X14 AND NOT X16 AND NOT req_b_prev THEN
    Y14 := TRUE;
ELSE
    Y14 := FALSE;
END_IF;
req_b_prev := X14;

(* ---------------- LOCAL WORK CLOSE & RELEASE ---------------- *)
IF X15 AND (D13 = 2) AND NOT a_closed THEN
    Y15 := TRUE;
    a_closed := TRUE;
ELSE
    Y15 := FALSE;
END_IF;

IF X16 AND (D14 = 2) AND NOT b_closed THEN
    Y16 := TRUE;
    b_closed := TRUE;
ELSE
    Y16 := FALSE;
END_IF;

IF X17 AND X19 AND NOT a_released THEN
    Y17 := TRUE;
    a_released := TRUE;
ELSE
    Y17 := FALSE;
END_IF;

IF X18 AND X1A AND NOT b_released THEN
    Y18 := TRUE;
    b_released := TRUE;
ELSE
    Y18 := FALSE;
END_IF;

(* ---------------- BOX FEED & CLAMP ---------------- *)
CASE box_state OF
    0: (* Feed new box if needed *)
        IF dispatched_count < 2 THEN
            IF X1F THEN
                box_state := 20;
            ELSIF X1E THEN
                Y1C := TRUE;
                box_state := 10;
            END_IF;
        END_IF;

    10: (* Wait box to reach station *)
        IF X1F THEN
            Y1C := FALSE;
            box_state := 20;
        END_IF;

    20: (* Clamp box *)
        Y1D := TRUE;
        clamp_timer(IN := TRUE, PT := T#350ms);
        IF clamp_timer.Q AND X20 THEN
            clamp_timer(IN := FALSE, PT := T#350ms);
            box_state := 30;
        END_IF;

    30: (* Clamped, packing done in pack section *)
        IF X24 THEN
            Y1D := FALSE;
            IF NOT X20 AND X25 THEN
                Y20 := TRUE;
                box_state := 40;
            END_IF;
        END_IF;

    40: (* Dispatching pulse *)
        Y20 := FALSE;
        dispatched_count := dispatched_count + 1;
        a_packed_latched := FALSE;
        b_packed_latched := FALSE;
        box_state := 0;
END_CASE;

(* ---------------- PACKING LOGIC ---------------- *)
IF X22 THEN
    a_packed_latched := TRUE;
END_IF;
IF X23 THEN
    b_packed_latched := TRUE;
END_IF;

CASE pack_seq OF
    0:
        IF (box_state = 30) AND NOT X21 THEN
            IF X1B AND (D9 = D16) AND NOT a_packed_latched THEN
                Y1E := TRUE;
                pack_seq := 1;
            ELSIF X1C AND (D10 = D16) AND NOT b_packed_latched THEN
                Y1F := TRUE;
                pack_seq := 2;
            END_IF;
        END_IF;

    1:
        Y1E := FALSE;
        IF X22 OR a_packed_latched THEN
            Y19 := TRUE;
            a_closed := FALSE;
            a_released := FALSE;
            pack_seq := 3;
        END_IF;

    2:
        Y1F := FALSE;
        IF X23 OR b_packed_latched THEN
            Y1A := TRUE;
            b_closed := FALSE;
            b_released := FALSE;
            pack_seq := 3;
        END_IF;

    3:
        Y19 := FALSE;
        Y1A := FALSE;
        pack_seq := 0;
END_CASE;

(* ---------------- DECK MOTION & PART TRANSFER ---------------- *)
CASE deck_state OF
    0: (* Idle / Decision *)
        IF NOT X11 THEN
            IF D1 > 0 THEN
                (* Deck has part: decide destination *)
                IF X15 AND (D13 < 2) AND (D2 = D11) THEN
                    dest_pos := 4;
                    D201 := D9;
                    deck_state := 10;
                ELSIF X16 AND (D14 < 2) AND (D2 = D12) THEN
                    dest_pos := 5;
                    D201 := D10;
                    deck_state := 10;
                ELSIF D5 = 0 THEN
                    dest_pos := 2;
                    deck_state := 10;
                ELSIF D7 = 0 THEN
                    dest_pos := 3;
                    deck_state := 10;
                END_IF;
            ELSE
                (* Deck empty: decide pickup *)
                IF X15 AND (D13 < 2) AND (D5 > 0) AND (D6 = D11) THEN
                    dest_pos := 2;
                    deck_state := 10;
                ELSIF X16 AND (D14 < 2) AND (D5 > 0) AND (D6 = D12) THEN
                    dest_pos := 2;
                    deck_state := 10;
                ELSIF X15 AND (D13 < 2) AND (D7 > 0) AND (D8 = D11) THEN
                    dest_pos := 3;
                    deck_state := 10;
                ELSIF X16 AND (D14 < 2) AND (D7 > 0) AND (D8 = D12) THEN
                    dest_pos := 3;
                    deck_state := 10;
                ELSIF X10 AND (D3 > 0) THEN
                    dest_pos := 1;
                    deck_state := 10;
                END_IF;
            END_IF;
        END_IF;

    10: (* Move deck to dest_pos *)
        IF D0 = dest_pos THEN
            deck_state := 20;
        ELSE
            D200 := dest_pos;
            Y10 := TRUE;
            deck_state := 11;
        END_IF;

    11: (* Dock pulse off, wait arrival *)
        Y10 := FALSE;
        IF (NOT X11) AND (D0 = dest_pos) THEN
            deck_state := 20;
        END_IF;

    20: (* At dock position: Load or Unload *)
        IF dest_pos = 1 THEN
            IF X10 AND (D3 > 0) AND NOT X11 THEN
                Y11 := TRUE;
                deck_state := 21;
            END_IF;
        ELSIF (dest_pos = 2) OR (dest_pos = 3) THEN
            IF D1 = 0 THEN
                (* Pickup from storage *)
                IF NOT X11 THEN
                    Y11 := TRUE;
                    deck_state := 21;
                END_IF;
            ELSE
                (* Dropoff to storage *)
                IF NOT X11 THEN
                    Y12 := TRUE;
                    deck_state := 22;
                END_IF;
            END_IF;
        ELSIF (dest_pos = 4) OR (dest_pos = 5) THEN
            IF (D1 > 0) AND NOT X11 THEN
                IF dest_pos = 4 THEN
                    D201 := D9;
                ELSE
                    D201 := D10;
                END_IF;
                Y12 := TRUE;
                deck_state := 22;
            END_IF;
        END_IF;

    21: (* Waiting load complete *)
        Y11 := FALSE;
        IF X12 AND NOT X11 THEN
            deck_state := 0;
        END_IF;

    22: (* Waiting unload complete *)
        Y12 := FALSE;
        IF (D1 = 0) AND NOT X11 THEN
            deck_state := 0;
        END_IF;
END_CASE;

(* ---------------- COMPLETION ---------------- *)
comp_timer(IN := X1D AND (D1 = 0) AND NOT X11 AND (dispatched_count >= 2), PT := T#500ms);
IF comp_timer.Q THEN
    Y1B := TRUE;
END_IF;

END_PROGRAM