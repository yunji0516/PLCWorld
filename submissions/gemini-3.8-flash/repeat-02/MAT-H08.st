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

    (* Pitch / Head Control State Machine *)
    pitch_step : INT := 0;
    pitches_done : INT := 0;
    ton_clamp : TON;
    ton_cut : TON;
    ton_transfer : TON;

    (* Recovery Control State Machine *)
    rec_step : INT := 0;
    rec_batches_done : INT := 0;

    (* Reel Exchange State Machine *)
    reel_step : INT := 0;
    reels_unloaded : INT := 0;
    ton_edge_hold : TON;

    (* Completion Tracking *)
    ton_complete : TON;
    all_tasks_finished : BOOL := FALSE;
    started : BOOL := FALSE;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    RETURN;
END_IF;

(* ========================================== *)
(* 1. PRODUCT PITCH & CUT & TRANSFER SEQUENCE *)
(* ========================================== *)

(* Default pulse commands *)
Y10 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y16 := FALSE;
Y1A := FALSE;

CASE pitch_step OF
    0:
        (* Idle / Wait for pitch arrival *)
        IF pitches_done < 6 THEN
            (* Check conditions: pitch available, no feed busy, head idle, exit clear, storage limit *)
            IF X10 AND NOT X11 AND NOT X18 AND X19 AND X20 AND (D3 <= 300) THEN
                Y10 := TRUE; (* accept_pitch rising edge *)
                pitch_step := 10;
            END_IF;
        ELSE
            pitch_step := 100; (* All pitches done *)
        END_IF;

    10:
        (* Feed pitch to bed *)
        IF NOT X12 THEN
            Y11 := TRUE; (* feed level *)
        ELSE
            Y11 := FALSE;
            pitch_step := 20;
        END_IF;

    20:
        (* Clamp material at bed *)
        Y12 := TRUE; (* clamp *)
        ton_clamp(IN := X15, PT := T#200ms);
        IF ton_clamp.Q THEN
            ton_clamp(IN := FALSE, PT := T#200ms);
            D200 := 15; (* Cut mask for 4 edges: bits 0-3 *)
            Y13 := TRUE; (* cut pulse *)
            pitch_step := 30;
        END_IF;

    30:
        (* Cut execution *)
        IF X14 AND NOT X13 THEN
            (* Cutting completed *)
            Y14 := TRUE; (* pickup pulse *)
            pitch_step := 40;
        END_IF;

    40:
        (* Vacuum holding confirmation *)
        IF X16 THEN
            (* Lower bed *)
            Y15 := TRUE; (* release_bed *)
            IF X17 THEN
                pitch_step := 50;
            END_IF;
        END_IF;

    50:
        (* Transfer product *)
        IF X19 THEN
            Y16 := TRUE; (* transfer pulse *)
            pitch_step := 60;
        END_IF;

    60:
        (* Wait for product exit receipt *)
        IF X1A THEN
            Y1A := TRUE; (* ack_exit pulse *)
            pitches_done := pitches_done + 1;
            (* Release clamp and bed *)
            Y12 := FALSE;
            Y15 := FALSE;
            pitch_step := 70;
        END_IF;

    70:
        (* Wait for head return and clamp fully open *)
        IF NOT X18 AND X20 THEN
            pitch_step := 0;
        END_IF;

    100:
        (* Pitch feeding and product processing completely finished *)
        Y11 := FALSE;
        Y12 := FALSE;
        Y15 := FALSE;
END_CASE;

(* ========================================== *)
(* 2. REEL EXCHANGE SEQUENCE                  *)
(* ========================================== *)

Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;
Y20 := FALSE;

CASE reel_step OF
    0:
        (* Check if waste reel is full *)
        IF X21 AND (reels_unloaded = 0) THEN
            Y1C := TRUE; (* edge_hold *)
            reel_step := 10;
        END_IF;

    10:
        (* Hold edges for 0.3s *)
        ton_edge_hold(IN := X22, PT := T#300ms);
        IF ton_edge_hold.Q THEN
            ton_edge_hold(IN := FALSE, PT := T#300ms);
            Y1D := TRUE; (* cut_left *)
            Y1E := TRUE; (* cut_right *)
            reel_step := 20;
        END_IF;

    20:
        (* Wait for edges cut confirmation *)
        IF X23 THEN
            Y1F := TRUE; (* unload_reel *)
            reel_step := 30;
        END_IF;

    30:
        (* Wait for empty core ready and reel idle *)
        IF X25 AND NOT X24 THEN
            Y20 := TRUE; (* load_core *)
            reel_step := 40;
        END_IF;

    40:
        (* Wait for core docked *)
        IF X26 THEN
            reel_step := 50;
        END_IF;

    50:
        (* Thread left and right guides *)
        IF NOT X27 THEN
            Y21 := TRUE;
        ELSE
            Y21 := FALSE;
        END_IF;

        IF NOT X28 THEN
            Y22 := TRUE;
        ELSE
            Y22 := FALSE;
        END_IF;

        IF X27 AND X28 THEN
            Y21 := FALSE;
            Y22 := FALSE;
            Y1C := FALSE; (* Release edge_hold *)
            reel_step := 60;
        END_IF;

    60:
        (* Confirm recovery connected *)
        IF X29 THEN
            reels_unloaded := 1;
            reel_step := 70;
        END_IF;

    70:
        (* Second reel in use *)
        IF X21 AND (reels_unloaded = 1) AND (rec_batches_done >= 4) THEN
            (* Final reel unloading *)
            Y1C := TRUE;
            reel_step := 80;
        END_IF;

    80:
        ton_edge_hold(IN := X22, PT := T#300ms);
        IF ton_edge_hold.Q THEN
            ton_edge_hold(IN := FALSE, PT := T#300ms);
            Y1D := TRUE;
            Y1E := TRUE;
            reel_step := 90;
        END_IF;

    90:
        IF X23 THEN
            Y1F := TRUE;
            reels_unloaded := 2;
            reel_step := 100;
        END_IF;

    100:
        (* Both reels unloaded *)
        Y1C := FALSE;
END_CASE;

(* ========================================== *)
(* 3. RECOVERY BATCH SEQUENCE                 *)
(* ========================================== *)

Y17 := FALSE;
Y19 := FALSE;

CASE rec_step OF
    0:
        (* Wait for recovery available and reel ready (not full, connected) *)
        IF (rec_batches_done < 4) AND X1B AND NOT X21 AND (reel_step = 0 OR reel_step = 70) THEN
            Y17 := TRUE; (* accept_recovery *)
            rec_step := 10;
        END_IF;

    10:
        (* Wait for active or reel exchange interruption *)
        IF X21 THEN
            (* Waste full, pause recovery *)
            Y18 := FALSE;
        ELSE
            (* Only recover if storage has material or drain_ready is reached *)
            IF (D3 > 0) OR X1E THEN
                Y18 := TRUE; (* recover *)
            ELSE
                Y18 := FALSE;
            END_IF;
        END_IF;

        IF X1D THEN
            Y18 := FALSE;
            Y19 := TRUE; (* ack_recovery *)
            rec_batches_done := rec_batches_done + 1;
            rec_step := 20;
        END_IF;

    20:
        (* Step delay / settle *)
        rec_step := 0;
END_CASE;

(* ========================================== *)
(* 4. COMPLETION CHECK                        *)
(* ========================================== *)

all_tasks_finished := (pitches_done >= 6) AND 
                      (rec_batches_done >= 4) AND 
                      (reels_unloaded >= 2) AND 
                      (D6 >= 6) AND 
                      X1F AND 
                      NOT X11 AND 
                      NOT X18 AND 
                      NOT X1C AND 
                      X20;

ton_complete(IN := all_tasks_finished, PT := T#500ms);

IF ton_complete.Q THEN
    Y1B := TRUE;
END_IF;

END_PROGRAM