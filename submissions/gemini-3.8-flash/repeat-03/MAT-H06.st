```iec-st
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
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
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
    Y1F : BOOL;

    started : BOOL;
    splice_state : INT;
    splice_done : BOOL;
    waste_done : BOOL;

    piece_state : INT;
    target_len : INT;
    current_is_waste : BOOL;
    next_side_is_b : BOOL;

    hold_timer : TON;
    cut_timer : TON;
    comp_timer : TON;
    exit_ack_pulse : BOOL;
    batch_ack_pulse : BOOL;
    batch_accept_pulse : BOOL;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    RETURN;
END_IF;

(* 1. BATCH HANDLING *)
IF X10 AND NOT X11 AND NOT batch_accept_pulse THEN
    Y10 := TRUE;
    batch_accept_pulse := TRUE;
ELSE
    Y10 := FALSE;
    IF NOT X10 THEN
        batch_accept_pulse := FALSE;
    END_IF;
END_IF;

IF X12 AND NOT batch_ack_pulse THEN
    Y11 := TRUE;
    batch_ack_pulse := TRUE;
ELSE
    Y11 := FALSE;
    IF NOT X12 THEN
        batch_ack_pulse := FALSE;
    END_IF;
END_IF;

(* 2. SPLICE SEQUENCE *)
CASE splice_state OF
    0:
        IF (X27 OR D3 >= 2800) AND X20 THEN
            Y1C := TRUE;
            splice_state := 1;
        END_IF;
    1:
        IF X21 THEN
            Y1D := TRUE;
            splice_state := 2;
        END_IF;
    2:
        IF X22 THEN
            Y20 := TRUE;
            splice_state := 3;
        END_IF;
    3:
        IF X25 THEN
            Y1E := TRUE;
            Y1F := TRUE;
            splice_state := 4;
        END_IF;
    4:
        IF X23 AND X24 THEN
            Y21 := TRUE;
            splice_state := 5;
        END_IF;
    5:
        IF X26 THEN
            Y21 := FALSE;
            Y1E := FALSE;
            Y1F := FALSE;
            Y20 := FALSE;
            splice_state := 6;
        END_IF;
    6:
        IF NOT X23 AND NOT X24 AND X28 THEN
            splice_done := TRUE;
            splice_state := 7;
        END_IF;
    7:
        (* Splice complete, spare remains docked and locked *)
        ;
END_CASE;

(* FEED CONTROL *)
(* Feed only when batch is active, path is clear, fixing plates are open, and buffer has space *)
IF X11 AND (D1 > 0) AND (splice_state = 0 OR splice_state = 7) AND X28 AND (D2 < 1500) THEN
    Y15 := TRUE;
ELSE
    Y15 := FALSE;
END_IF;

(* 3. DOWNSTREAM PIECE / ORDER / WASTE HANDLING *)
hold_timer(IN := (piece_state = 3), PT := T#200ms);
cut_timer(IN := (piece_state = 4), PT := T#700ms);

CASE piece_state OF
    0:
        (* Idle - Determine next piece: normal order A/B or waste *)
        IF X1C AND (X17 OR NOT X18) THEN
            IF X26 AND NOT waste_done AND (D10 < 1200) THEN
                (* Spliced web approaching: must cut waste before splice passes cutter *)
                current_is_waste := TRUE;
                target_len := D11;
                IF target_len <= 0 THEN
                    target_len := 400;
                END_IF;
                D200 := 0;
                Y22 := TRUE;
                piece_state := 1;
            ELSIF NOT next_side_is_b AND X13 THEN
                current_is_waste := FALSE;
                target_len := D5;
                D200 := 1;
                Y12 := TRUE;
                Y14 := TRUE;
                piece_state := 1;
            ELSIF next_side_is_b AND X14 THEN
                current_is_waste := FALSE;
                target_len := D6;
                D200 := 2;
                Y13 := TRUE;
                Y14 := TRUE;
                piece_state := 1;
            ELSIF X13 THEN
                current_is_waste := FALSE;
                target_len := D5;
                D200 := 1;
                Y12 := TRUE;
                Y14 := TRUE;
                piece_state := 1;
            ELSIF X14 THEN
                current_is_waste := FALSE;
                target_len := D6;
                D200 := 2;
                Y13 := TRUE;
                Y14 := TRUE;
                piece_state := 1;
            END_IF;
        END_IF;

    1:
        (* Clear trigger pulses *)
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y22 := FALSE;
        IF X18 OR (D8 > 0) THEN
            piece_state := 2;
        END_IF;

    2:
        (* Pulling workpiece when holder is fully open *)
        IF X1F AND NOT X1B THEN
            IF D8 < (target_len - 2) THEN
                Y16 := TRUE;
            ELSE
                Y16 := FALSE;
                Y17 := TRUE;
                piece_state := 3;
            END_IF;
        ELSE
            Y16 := FALSE;
        END_IF;

    3:
        (* Clamping workpiece *)
        Y16 := FALSE;
        Y17 := TRUE;
        IF X1B AND hold_timer.Q THEN
            Y18 := TRUE;
            piece_state := 4;
        END_IF;

    4:
        (* Cutting workpiece *)
        Y17 := TRUE;
        IF (X19 OR cut_timer.Q) AND NOT X1A THEN
            Y18 := FALSE;
            Y17 := FALSE;
            Y19 := TRUE;
            piece_state := 5;
        END_IF;

    5:
        (* Releasing workpiece *)
        IF X1F AND NOT X1B THEN
            Y19 := FALSE;
            piece_state := 6;
        END_IF;

    6:
        (* Waiting for workpiece reception on belt *)
        IF X1D THEN
            Y1A := TRUE;
            exit_ack_pulse := TRUE;
            IF current_is_waste THEN
                waste_done := TRUE;
            ELSE
                next_side_is_b := NOT next_side_is_b;
            END_IF;
            piece_state := 7;
        END_IF;

    7:
        (* Acknowledge exit and wait for clear *)
        IF NOT X1D THEN
            Y1A := FALSE;
            piece_state := 0;
        ELSE
            Y1A := TRUE;
        END_IF;
END_CASE;

(* 4. COMPLETION *)
comp_timer(IN := (X1E OR (D9 >= 6 AND waste_done)), PT := T#500ms);
IF comp_timer.IN THEN
    Y1B := TRUE;
END_IF;

END_PROGRAM
```