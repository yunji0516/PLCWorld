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

    (* internal state *)
    phase : INT := 0;
    rphase : INT := 0;
    edge_idx : INT := 0;

    cut_pulse_issued : BOOL := FALSE;
    accept_issued : BOOL := FALSE;
    pickup_issued : BOOL := FALSE;
    ackexit_issued : BOOL := FALSE;
    acceptrec_issued : BOOL := FALSE;
    ackrec_issued : BOOL := FALSE;
    cutlr_issued : BOOL := FALSE;
    unload_issued : BOOL := FALSE;
    loadcore_issued : BOOL := FALSE;

    feed_started : BOOL := FALSE;
    current_pitch_active : BOOL := FALSE;
    recovery_active_flag : BOOL := FALSE;

    product_count : INT := 0;
    recovery_batch_count : INT := 0;
    roll_count : INT := 0;

    complete_latched : BOOL := FALSE;
    comp_cond : BOOL := FALSE;

    clamp_tmr : TON;
    cut_return_tmr : TON;
    edgehold_tmr : TON;
    complete_tmr : TON;

    scan_count : DINT := 0;
END_VAR

scan_count := scan_count + 1;

(* ============================================================
   Main product / pitch sequencer
   ============================================================ *)
CASE phase OF

0: (* idle / wait accept_pitch conditions *)
    IF X0 AND X10 AND (NOT current_pitch_active) AND (NOT X18) AND (D3 <= 300) THEN
        IF NOT accept_issued THEN
            Y10 := TRUE;
            accept_issued := TRUE;
        ELSE
            Y10 := FALSE;
            current_pitch_active := TRUE;
            accept_issued := FALSE;
            feed_started := FALSE;
            phase := 1;
        END_IF;
    ELSE
        Y10 := FALSE;
    END_IF;

1: (* feed 300mm *)
    Y11 := TRUE;
    IF X11 THEN
        feed_started := TRUE;
    END_IF;
    IF feed_started AND (NOT X11) THEN
        Y11 := FALSE;
        feed_started := FALSE;
        phase := 2;
    END_IF;

2: (* clamp, 2s holder response *)
    Y12 := TRUE;
    clamp_tmr(IN := TRUE, PT := T#2s);
    IF clamp_tmr.Q THEN
        clamp_tmr(IN := FALSE, PT := T#2s);
        edge_idx := 0;
        cut_pulse_issued := FALSE;
        phase := 3;
    END_IF;

3: (* cut the 4 connection edges sequentially *)
    IF edge_idx > 3 THEN
        IF X23 THEN
            D200 := 0;
            pickup_issued := FALSE;
            phase := 4;
        END_IF;
    ELSE
        CASE edge_idx OF
            0: D200 := 1;
            1: D200 := 2;
            2: D200 := 4;
            3: D200 := 8;
        ELSE
            D200 := 0;
        END_CASE;

        IF NOT cut_pulse_issued THEN
            Y13 := TRUE;
            cut_pulse_issued := TRUE;
        ELSE
            Y13 := FALSE;
            cut_return_tmr(IN := TRUE, PT := T#600ms);
            IF X14 AND cut_return_tmr.Q THEN
                cut_return_tmr(IN := FALSE, PT := T#600ms);
                edge_idx := edge_idx + 1;
                cut_pulse_issued := FALSE;
            END_IF;
        END_IF;
    END_IF;

4: (* pickup - vacuum pad *)
    IF NOT pickup_issued THEN
        Y14 := TRUE;
        pickup_issued := TRUE;
    ELSE
        IF X16 THEN
            phase := 5;
        END_IF;
    END_IF;

5: (* bed descent - only if actually held *)
    IF X16 THEN
        Y15 := TRUE;
        IF X17 THEN
            phase := 6;
        END_IF;
    ELSE
        Y15 := FALSE;
    END_IF;

6: (* wait exit margin *)
    IF X19 THEN
        phase := 7;
    END_IF;

7: (* transfer product sideways to exit *)
    Y16 := TRUE;
    IF X1A THEN
        ackexit_issued := FALSE;
        phase := 8;
    END_IF;

8: (* ack_exit and reset for next cycle *)
    IF NOT ackexit_issued THEN
        Y1A := TRUE;
        ackexit_issued := TRUE;
    ELSE
        Y1A := FALSE;
        product_count := product_count + 1;
        Y16 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y12 := FALSE;
        current_pitch_active := FALSE;
        phase := 0;
    END_IF;

ELSE
    phase := 0;
END_CASE;

(* ============================================================
   Recovery / waste-roll exchange sequencer
   ============================================================ *)
CASE rphase OF

0: (* idle, wait recovery batch or handle waste_full *)
    IF X21 THEN
        Y18 := FALSE;
        Y17 := FALSE;
        acceptrec_issued := FALSE;
        rphase := 10;
    ELSIF X0 AND X1B AND (recovery_batch_count < 4) AND (NOT recovery_active_flag) THEN
        IF NOT acceptrec_issued THEN
            Y17 := TRUE;
            acceptrec_issued := TRUE;
        ELSE
            Y17 := FALSE;
            recovery_active_flag := TRUE;
            acceptrec_issued := FALSE;
            Y18 := TRUE;
            rphase := 1;
        END_IF;
    ELSE
        Y17 := FALSE;
    END_IF;

1: (* recovering current batch *)
    IF X1D THEN
        IF NOT ackrec_issued THEN
            Y19 := TRUE;
            ackrec_issued := TRUE;
        ELSE
            Y19 := FALSE;
            recovery_batch_count := recovery_batch_count + 1;
            Y18 := FALSE;
            recovery_active_flag := FALSE;
            ackrec_issued := FALSE;
            rphase := 0;
        END_IF;
    ELSIF X21 THEN
        Y18 := FALSE;
        rphase := 10;
    END_IF;

10: (* waste_full: fix side bands with edge_hold, 0.3s *)
    Y1C := TRUE;
    edgehold_tmr(IN := TRUE, PT := T#300ms);
    IF edgehold_tmr.Q THEN
        edgehold_tmr(IN := FALSE, PT := T#300ms);
        cutlr_issued := FALSE;
        rphase := 11;
    END_IF;

11: (* cut both left/right band connections *)
    IF NOT cutlr_issued THEN
        Y1D := TRUE;
        Y1E := TRUE;
        cutlr_issued := TRUE;
    ELSE
        Y1D := FALSE;
        Y1E := FALSE;
        IF X23 THEN
            unload_issued := FALSE;
            rphase := 12;
        END_IF;
    END_IF;

12: (* unload finished waste roll *)
    IF NOT unload_issued THEN
        Y1F := TRUE;
        unload_issued := TRUE;
    ELSE
        Y1F := FALSE;
        roll_count := roll_count + 1;
        IF recovery_batch_count >= 4 THEN
            Y1C := FALSE;
            rphase := 99;
        ELSE
            rphase := 13;
        END_IF;
    END_IF;

13: (* wait empty core ready, then load_core rising edge *)
    IF X25 THEN
        loadcore_issued := FALSE;
        rphase := 14;
    END_IF;

14: (* load new core and wait dock *)
    IF NOT loadcore_issued THEN
        Y20 := TRUE;
        loadcore_issued := TRUE;
    ELSE
        Y20 := FALSE;
        IF X26 THEN
            rphase := 15;
        END_IF;
    END_IF;

15: (* thread left/right to core nip *)
    Y21 := TRUE;
    Y22 := TRUE;
    IF X27 AND X28 THEN
        rphase := 16;
    END_IF;

16: (* release edge_hold, confirm recovery_connected, resume *)
    Y1C := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    IF X29 THEN
        IF recovery_batch_count >= 4 THEN
            Y18 := FALSE;
            rphase := 99;
        ELSE
            Y18 := TRUE;
            recovery_active_flag := TRUE;
            rphase := 1;
        END_IF;
    END_IF;

99: (* recovery and waste exchange fully finished *)
    Y18 := FALSE;
    Y1C := FALSE;

ELSE
    rphase := 0;
END_CASE;

(* ============================================================
   Completion evaluation
   ============================================================ *)
comp_cond := (product_count >= 6)
             AND (recovery_batch_count >= 4)
             AND (roll_count >= 2)
             AND (phase = 0)
             AND (NOT current_pitch_active)
             AND (rphase = 99);

complete_tmr(IN := comp_cond, PT := T#500ms);
IF complete_tmr.Q THEN
    complete_latched := TRUE;
END_IF;

Y1B := complete_latched;

END_PROGRAM