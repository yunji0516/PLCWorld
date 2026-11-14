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
    Y23 : BOOL;
    Y24 : BOOL;
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
    Y1F : BOOL;

    started : BOOL;
    form_state : INT;
    conv_state : INT;
    xfer_state : INT;
    wrap_state : INT;
    tape_prep_state : INT;
    prep_order_track : INT;

    t_cut : TON;
    t_swap_pulse : TON;
    t_tape_pulse : TON;
    t_prep_pulse : TON;
    t_feed_wait : TON;
    t_index_pulse : TON;

    bundle_at_supply : BOOL;
    bundle_at_pickup : BOOL;
    all_done : BOOL;
    tape_req : BOOL;
    tape_prep_req : BOOL;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := TRUE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y1A := FALSE;
    Y1B := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    D200 := 0;
    prep_order_track := 1;
    RETURN;
END_IF;

(* ------------------------------------------------------------- *)
(* 1. FORMING SUB-SYSTEM                                         *)
(* ------------------------------------------------------------- *)
CASE form_state OF
    0: (* Wait to start forming *)
        IF NOT X31 THEN
            Y1D := TRUE; (* Close stop plate *)
            IF X26 AND X2E AND X2B THEN
                form_state := 10;
            END_IF;
        END_IF;

    10: (* Check if more items needed for current bundle *)
        IF X31 THEN
            form_state := 99;
        ELSIF D9 >= D10 AND D10 > 0 THEN
            Y1C := FALSE;
            Y1E := FALSE;
            Y1F := TRUE; (* Align items *)
            IF X29 THEN
                form_state := 20;
            END_IF;
        ELSE
            (* Need items: feed single item if entrance clear *)
            IF X25 AND X28 AND NOT X27 THEN
                Y1C := TRUE;
                form_state := 11;
            END_IF;
        END_IF;

    11: (* Feeding item *)
        IF NOT X28 THEN
            (* Item entered *)
            Y1C := FALSE;
            t_feed_wait(IN := TRUE, PT := T#50ms);
            IF t_feed_wait.Q THEN
                t_feed_wait(IN := FALSE, PT := T#50ms);
                Y1E := TRUE; (* Index item *)
                form_state := 12;
            END_IF;
        ELSE
            t_feed_wait(IN := FALSE, PT := T#50ms);
        END_IF;

    12: (* Indexing *)
        IF X27 THEN
            Y1E := FALSE;
            form_state := 13;
        END_IF;

    13: (* Wait for index to finish *)
        IF NOT X27 THEN
            form_state := 10;
        END_IF;

    20: (* Aligned, prepare to grip *)
        Y1F := TRUE;
        IF NOT X2D THEN
            Y21 := FALSE; (* Lower forming head *)
        ELSE
            Y20 := TRUE; (* Grip formed bundle *)
            IF X2A THEN
                Y1F := FALSE; (* Release alignment plates *)
                form_state := 21;
            END_IF;
        END_IF;

    21: (* Lift formed bundle *)
        Y20 := TRUE;
        Y21 := TRUE; (* Lift forming head *)
        IF X2C THEN
            form_state := 22;
        END_IF;

    22: (* Move forming head to supply position if supply clear *)
        Y20 := TRUE;
        Y21 := TRUE;
        IF X30 AND NOT bundle_at_supply THEN
            Y22 := TRUE; (* Move to supply *)
            IF X2F THEN
                form_state := 23;
            END_IF;
        END_IF;

    23: (* Lower onto supply belt *)
        Y20 := TRUE;
        Y22 := TRUE;
        Y21 := FALSE; (* Lower *)
        IF X2D THEN
            form_state := 24;
        END_IF;

    24: (* Release bundle at supply *)
        Y22 := TRUE;
        Y21 := FALSE;
        Y20 := FALSE; (* Open grip *)
        IF X2B THEN
            bundle_at_supply := TRUE;
            form_state := 25;
        END_IF;

    25: (* Raise forming head *)
        Y22 := TRUE;
        Y21 := TRUE; (* Lift *)
        IF X2C THEN
            form_state := 26;
        END_IF;

    26: (* Return forming head to table *)
        Y21 := TRUE;
        Y22 := FALSE; (* To table *)
        IF X2E THEN
            IF X31 THEN
                form_state := 99;
            ELSE
                form_state := 10;
            END_IF;
        END_IF;

    99: (* All forming done *)
        Y1D := FALSE;
        Y1C := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
END_CASE;

(* ------------------------------------------------------------- *)
(* 2. SUPPLY CONVEYOR TO PICKUP                                  *)
(* ------------------------------------------------------------- *)
CASE conv_state OF
    0:
        IF bundle_at_supply AND NOT bundle_at_pickup AND NOT X10 THEN
            IF X32 AND X2C AND (NOT Y24) THEN
                Y23 := TRUE; (* source_advance *)
                conv_state := 10;
            END_IF;
        END_IF;

    10:
        IF X10 THEN (* source_ready *)
            Y23 := FALSE;
            bundle_at_supply := FALSE;
            bundle_at_pickup := TRUE;
            conv_state := 0;
        ELSIF NOT X32 THEN
            Y23 := FALSE;
            conv_state := 0;
        END_IF;
END_CASE;

(* ------------------------------------------------------------- *)
(* 3. TAPE PREPARATION                                           *)
(* ------------------------------------------------------------- *)
tape_prep_req := (prep_order_track <= 3) AND (D5 < prep_order_track) AND NOT X1F;
IF tape_prep_req AND NOT Y18 AND (tape_prep_state = 0) THEN
    D200 := prep_order_track;
    Y18 := TRUE;
    tape_prep_state := 1;
END_IF;

t_prep_pulse(IN := Y18, PT := T#100ms);
IF t_prep_pulse.Q THEN
    Y18 := FALSE;
END_IF;

IF (tape_prep_state = 1) AND (D5 = prep_order_track) THEN
    prep_order_track := prep_order_track + 1;
    tape_prep_state := 0;
END_IF;

(* ------------------------------------------------------------- *)
(* 4. WRAPPING & CUT & REEL SWAP & TAPING                        *)
(* ------------------------------------------------------------- *)
Y12 := TRUE; (* Maintain film holder *)

CASE wrap_state OF
    0: (* Wait for bundle in chuck *)
        Y16 := FALSE;
        Y17 := FALSE;
        Y19 := FALSE;
        Y1A := FALSE;
        IF X11 AND X19 AND X18 AND (D0 > 0) THEN
            wrap_state := 10;
        END_IF;

    10: (* Check film readiness and reel status *)
        IF (D4 <= 20) AND X1E AND NOT X1D THEN
            (* Film exhausted, need reel swap *)
            Y17 := TRUE;
            wrap_state := 15;
        ELSIF X1C AND (D4 > 20) THEN
            IF D2 < D3 THEN
                Y16 := TRUE; (* wrap *)
            ELSE
                Y16 := FALSE;
                wrap_state := 20;
            END_IF;
        END_IF;

    15: (* Reel swap request pulse *)
        t_swap_pulse(IN := TRUE, PT := T#100ms);
        IF t_swap_pulse.Q THEN
            Y17 := FALSE;
            IF NOT X1D AND X1C THEN
                t_swap_pulse(IN := FALSE, PT := T#100ms);
                wrap_state := 10;
            END_IF;
        END_IF;

    20: (* Wrapping length reached, wait for tape *)
        Y16 := FALSE;
        IF X20 AND (D5 = D0) THEN
            Y19 := TRUE; (* apply_tape *)
            wrap_state := 30;
        END_IF;

    30: (* Applying tape *)
        IF X21 THEN (* taped *)
            Y19 := FALSE;
            wrap_state := 40;
        END_IF;

    40: (* Tape complete, wait for transfer gripper to grip bundle before cut *)
        IF X16 AND X13 THEN
            wrap_state := 50;
        END_IF;

    50: (* Execute Cut *)
        Y1A := TRUE;
        t_cut(IN := TRUE, PT := T#800ms);
        IF t_cut.Q AND X22 THEN
            Y1A := FALSE;
            t_cut(IN := FALSE, PT := T#800ms);
            wrap_state := 60;
        END_IF;

    60: (* Film separated. Wait for chuck release *)
        Y11 := FALSE; (* Release chuck clamp *)
        IF X1A THEN
            wrap_state := 70;
        END_IF;

    70: (* Bundle leaving chuck *)
        IF NOT X11 THEN
            IF D7 >= 3 OR X24 THEN
                wrap_state := 99;
            ELSE
                wrap_state := 0;
            END_IF;
        END_IF;

    99:
        Y16 := FALSE;
        Y17 := FALSE;
        Y19 := FALSE;
        Y1A := FALSE;
END_CASE;

(* ------------------------------------------------------------- *)
(* 5. TRANSFER GRIPPER SUB-SYSTEM                                *)
(* ------------------------------------------------------------- *)
CASE xfer_state OF
    0: (* Initial / Return at height 1.70m above source *)
        Y10 := FALSE; (* open *)
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y24 := FALSE;
        IF bundle_at_pickup AND X10 AND X33 AND X17 AND NOT X11 AND (wrap_state = 0) THEN
            xfer_state := 10;
        END_IF;

    10: (* Lower transfer head to pickup *)
        Y24 := TRUE;
        IF X12 THEN (* at_source *)
            xfer_state := 11;
        END_IF;

    11: (* Grip bundle at pickup *)
        Y24 := TRUE;
        Y10 := TRUE;
        IF X16 THEN (* transfer_gripped *)
            bundle_at_pickup := FALSE;
            xfer_state := 12;
        END_IF;

    12: (* Raise transfer head back to 1.70m *)
        Y10 := TRUE;
        Y24 := FALSE;
        IF NOT X12 THEN
            xfer_state := 20;
        END_IF;

    20: (* Move to wrap station *)
        Y10 := TRUE;
        IF NOT X11 AND X1A AND (wrap_state = 0) THEN
            Y14 := TRUE;
            IF X15 THEN
                xfer_state := 21;
            END_IF;
        END_IF;

    21: (* Moving to wrap *)
        Y10 := TRUE;
        IF X13 AND NOT X15 THEN (* at_wrap *)
            Y14 := FALSE;
            xfer_state := 22;
        END_IF;

    22: (* Bundle placed in wrap chuck, clamp chuck *)
        Y10 := TRUE;
        IF X11 THEN
            Y11 := TRUE; (* Clamp chuck *)
            IF X19 THEN
                xfer_state := 23;
            END_IF;
        END_IF;

    23: (* Release transfer gripper *)
        Y10 := FALSE;
        IF X17 THEN
            xfer_state := 24;
        END_IF;

    24: (* Clear tool / return transfer gripper to source to clear rotation area *)
        IF X18 THEN
            xfer_state := 30;
        ELSE
            Y13 := TRUE;
            IF X15 THEN
                xfer_state := 25;
            END_IF;
        END_IF;

    25:
        IF X18 AND NOT X15 THEN
            Y13 := FALSE;
            xfer_state := 30;
        END_IF;

    30: (* Wait for wrap & tape to finish, then approach chuck for discharge *)
        IF (wrap_state = 40) AND NOT Y16 AND X19 THEN
            Y14 := TRUE;
            IF X15 THEN
                xfer_state := 31;
            END_IF;
        END_IF;

    31: (* Arrived at wrap chuck to receive finished bundle *)
        IF X13 AND NOT X15 THEN
            Y14 := FALSE;
            Y10 := TRUE; (* Grip wrapped bundle *)
            IF X16 THEN
                xfer_state := 40;
            END_IF;
        END_IF;

    40: (* Bundle gripped, wait for cut & chuck open & exit clear *)
        Y10 := TRUE;
        IF (wrap_state >= 60) AND X1A AND X22 AND X23 THEN
            Y15 := TRUE; (* Move to exit *)
            IF X15 THEN
                xfer_state := 41;
            END_IF;
        END_IF;

    41: (* Moving to exit *)
        Y10 := TRUE;
        IF X14 AND NOT X15 THEN (* at_exit *)
            Y15 := FALSE;
            xfer_state := 42;
        END_IF;

    42: (* Release bundle at exit *)
        Y10 := FALSE;
        IF X17 THEN
            xfer_state := 43;
        END_IF;

    43: (* Return transfer gripper to source if more bundles, or service stop *)
        IF (D7 >= 3) OR X24 THEN
            xfer_state := 99;
        ELSE
            Y13 := TRUE;
            IF X15 THEN
                xfer_state := 44;
            END_IF;
        END_IF;

    44: (* Returning to source *)
        IF X33 AND NOT X15 THEN
            Y13 := FALSE;
            xfer_state := 0;
        END_IF;

    99: (* All transfer done *)
        Y10 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y24 := FALSE;
END_CASE;

(* ------------------------------------------------------------- *)
(* 6. COMPLETION CHECK                                           *)
(* ------------------------------------------------------------- *)
IF (D7 >= 3 OR X24) AND X17 AND X1A AND (wrap_state = 99) AND (xfer_state = 99) AND (form_state = 99) THEN
    Y1B := TRUE;
END_IF;

END_PROGRAM