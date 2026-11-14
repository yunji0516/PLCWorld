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

    (* ---- internal state ---- *)
    pstate : INT := 0;
    rstate : INT := 0;
    saved_rstate : INT := 0;
    edge_idx : INT := 0;
    cut_sub : INT := 0;
    mask_val : INT := 0;

    product_count : INT := 0;
    batch_count : INT := 0;
    roll_count : INT := 0;

    current_pitch : BOOL := FALSE;
    head_returned : BOOL := TRUE;
    current_recovery : BOOL := FALSE;
    exch_final : BOOL := FALSE;

    feed_started : BOOL := FALSE;
    pickup_issued : BOOL := FALSE;
    ack_sent : BOOL := FALSE;
    unload_issued : BOOL := FALSE;
    busy_seen : BOOL := FALSE;
    loadcore_issued : BOOL := FALSE;

    accept_pulse : BOOL := FALSE;
    ackexit_pulse : BOOL := FALSE;
    acceptrec_pulse : BOOL := FALSE;
    ackrec_pulse : BOOL := FALSE;
    pickup_pulse : BOOL := FALSE;
    unload_pulse : BOOL := FALSE;
    loadcore_pulse : BOOL := FALSE;
    y13_pulse : BOOL := FALSE;

    storage_ok : BOOL := FALSE;
    all_conditions : BOOL := FALSE;
    complete_latched : BOOL := FALSE;
    timer_in : BOOL := FALSE;

    clamp_timer : TON;
    cut_timer : TON;
    edgehold_timer : TON;
    thread_timer : TON;
    completion_timer : TON;

    scan_count : DINT := 0;
END_VAR

(* ================= scan bookkeeping ================= *)
scan_count := scan_count + 1;

(* reset one-scan pulse flags *)
accept_pulse := FALSE;
ackexit_pulse := FALSE;
acceptrec_pulse := FALSE;
ackrec_pulse := FALSE;
pickup_pulse := FALSE;
unload_pulse := FALSE;
loadcore_pulse := FALSE;
y13_pulse := FALSE;

(* ================= PRODUCT PIPELINE ================= *)
CASE pstate OF

0: (* IDLE *)
    IF X0 THEN
        pstate := 1;
    END_IF;

1: (* WAIT_PITCH *)
    IF product_count >= 6 THEN
        pstate := 10;
    ELSIF X10 AND (NOT current_pitch) AND (NOT X18) AND head_returned THEN
        accept_pulse := TRUE;
        current_pitch := TRUE;
        head_returned := FALSE;
        feed_started := FALSE;
        pstate := 2;
    END_IF;

2: (* FEEDING - 300mm, respect 600mm storage cap *)
    storage_ok := (D3 + 300) <= 600;
    IF storage_ok THEN
        IF X11 THEN
            feed_started := TRUE;
        END_IF;
        IF feed_started AND (NOT X11) THEN
            feed_started := FALSE;
            pstate := 3;
        END_IF;
    END_IF;

3: (* CLAMPING - wait clamped then 2s holder response *)
    clamp_timer(IN := X15, PT := T#2s);
    IF clamp_timer.Q THEN
        pstate := 4;
        edge_idx := 0;
        cut_sub := 0;
    END_IF;

4: (* CUTTING - 4 connection edges *)
    IF edge_idx >= 4 THEN
        pstate := 5;
        pickup_issued := FALSE;
    ELSE
        CASE edge_idx OF
            0: mask_val := 1;
            1: mask_val := 2;
            2: mask_val := 4;
            3: mask_val := 8;
        ELSE
            mask_val := 0;
        END_CASE;
        D200 := mask_val;
        IF cut_sub = 0 THEN
            y13_pulse := TRUE;
            cut_timer(IN := TRUE, PT := T#600ms);
            cut_sub := 1;
        ELSE
            timer_in := TRUE;
            IF cut_timer.Q AND X14 THEN
                timer_in := FALSE;
            END_IF;
            cut_timer(IN := timer_in, PT := T#600ms);
            IF NOT timer_in THEN
                edge_idx := edge_idx + 1;
                cut_sub := 0;
            END_IF;
        END_IF;
    END_IF;

5: (* PICKUP *)
    IF NOT pickup_issued THEN
        pickup_pulse := TRUE;
        pickup_issued := TRUE;
    END_IF;
    IF X16 THEN
        pstate := 6;
    END_IF;

6: (* BED_DESCENT - only if actually held *)
    IF X16 AND X17 THEN
        pstate := 7;
    END_IF;

7: (* WAIT_EXIT_MARGIN *)
    IF X19 THEN
        pstate := 8;
    END_IF;

8: (* TRANSFER *)
    IF X1A THEN
        pstate := 9;
        ack_sent := FALSE;
    END_IF;

9: (* ACK_EXIT / RETURN *)
    IF NOT ack_sent THEN
        ackexit_pulse := TRUE;
        ack_sent := TRUE;
    ELSIF NOT X18 THEN
        product_count := product_count + 1;
        current_pitch := FALSE;
        head_returned := TRUE;
        ack_sent := FALSE;
        pickup_issued := FALSE;
        pstate := 1;
    END_IF;

10: (* DONE - all six products delivered *)
    ;

ELSE
    pstate := 0;
END_CASE;

(* ================= RECOVERY / REEL PIPELINE ================= *)
IF X21 AND (rstate < 5) THEN
    saved_rstate := rstate;
    rstate := 5;
END_IF;

CASE rstate OF

0: (* IDLE - wait recovery request *)
    IF X1B AND (NOT current_recovery) AND (batch_count < 4) THEN
        acceptrec_pulse := TRUE;
        current_recovery := TRUE;
        rstate := 1;
    END_IF;

1: (* RECOVERING *)
    IF X1D THEN
        rstate := 2;
    END_IF;

2: (* ACK batch *)
    ackrec_pulse := TRUE;
    batch_count := batch_count + 1;
    current_recovery := FALSE;
    rstate := 0;

5: (* EXCH_STOP *)
    rstate := 6;
    edgehold_timer(IN := FALSE, PT := T#300ms);

6: (* EXCH_EDGEHOLD *)
    edgehold_timer(IN := TRUE, PT := T#300ms);
    IF edgehold_timer.Q AND X22 THEN
        rstate := 7;
    END_IF;

7: (* EXCH_CUT both bands *)
    IF X23 THEN
        rstate := 8;
        unload_issued := FALSE;
        busy_seen := FALSE;
    END_IF;

8: (* EXCH_UNLOAD *)
    IF NOT unload_issued THEN
        unload_pulse := TRUE;
        unload_issued := TRUE;
    END_IF;
    IF X24 THEN
        busy_seen := TRUE;
    END_IF;
    IF busy_seen AND (NOT X24) THEN
        roll_count := roll_count + 1;
        exch_final := (batch_count >= 4);
        rstate := 9;
        loadcore_issued := FALSE;
        thread_timer(IN := FALSE, PT := T#700ms);
    END_IF;

9: (* EXCH_LOADCORE *)
    IF exch_final THEN
        rstate := 11;
    ELSIF X25 THEN
        IF NOT loadcore_issued THEN
            loadcore_pulse := TRUE;
            loadcore_issued := TRUE;
        END_IF;
        IF X26 THEN
            rstate := 10;
        END_IF;
    END_IF;

10: (* EXCH_THREAD *)
    thread_timer(IN := TRUE, PT := T#700ms);
    IF thread_timer.Q AND X27 AND X28 THEN
        rstate := 11;
    END_IF;

11: (* EXCH_RECONNECT / FINISH *)
    IF exch_final THEN
        rstate := 99;
    ELSIF X29 THEN
        rstate := saved_rstate;
    END_IF;

99: (* ALL RECOVERY / REEL WORK COMPLETE *)
    ;

ELSE
    rstate := 0;
END_CASE;

(* ================= OUTPUT MAPPING ================= *)

Y10 := accept_pulse;
Y11 := (pstate = 2) AND storage_ok;
Y12 := (pstate = 3) OR (pstate = 4);
Y13 := y13_pulse;
Y14 := (pstate >= 5) AND (pstate <= 9);
Y15 := (pstate >= 6) AND (pstate <= 9) AND X16;
Y16 := (pstate = 8);
Y1A := ackexit_pulse;

Y17 := acceptrec_pulse;
Y18 := (rstate = 1);
Y19 := ackrec_pulse;
Y20 := loadcore_pulse;
Y21 := (rstate = 10);
Y22 := (rstate = 10);
Y1C := (rstate >= 6) AND (rstate <= 10);
Y1D := (rstate = 7);
Y1E := (rstate = 7);
Y1F := unload_pulse;

IF pstate <> 4 THEN
    D200 := 0;
END_IF;

(* ================= COMPLETION ================= *)
all_conditions := (pstate = 10) AND (rstate = 99) AND (roll_count >= 2)
                   AND (product_count >= 6) AND (batch_count >= 4) AND (D5 <= 0);

completion_timer(IN := all_conditions, PT := T#500ms);

IF completion_timer.Q AND (scan_count <= 30000) THEN
    complete_latched := TRUE;
END_IF;

Y1B := complete_latched;

END_PROGRAM