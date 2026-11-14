```
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

    (* State machine *)
    state : INT := 0;
    bundle_idx : INT := 0;
    items_fed_this_bundle : INT := 0;
    form_cycle_done : ARRAY[0..2] OF BOOL := [FALSE, FALSE, FALSE];
    proc_cycle_done : ARRAY[0..2] OF BOOL := [FALSE, FALSE, FALSE];
    swap_done_flag : BOOL := FALSE;
    tape_prep_done_flag : BOOL := FALSE;
    form_advancing : BOOL := FALSE;
    proc_advancing : BOOL := FALSE;
    wrap_paused_for_swap : BOOL := FALSE;
    completed_all : BOOL := FALSE;
    complete_hold_scan : INT := 0;

    (* Timers *)
    tmr_cut : TON;
    tmr_complete : TON;
    tmr_swap : TON;
    tmr_tape_prep : TON;
    tmr_grip_resp : TON;
    tmr_hold : TON;

    (* Edge detectors *)
    edge_start : R_TRIG;
    edge_taped : R_TRIG;
    edge_sep : R_TRIG;
    edge_tg : R_TRIG;
    edge_aw : R_TRIG;
    edge_ae : R_TRIG;
    edge_fa : R_TRIG;
    edge_fg : R_TRIG;
    edge_swap : R_TRIG;
    edge_as : R_TRIG;
    edge_unit_feed_ready : R_TRIG;
    edge_form_gripped : R_TRIG;
    edge_transfer_gripped : R_TRIG;
    edge_at_wrap : R_TRIG;
    edge_at_exit : R_TRIG;
    edge_form_aligned : R_TRIG;
    edge_taped_r : R_TRIG;
    edge_sep_r : R_TRIG;
END_VAR

(* ---- Edge detection ---- *)
edge_start(CLK := X0);
edge_taped_r(CLK := X21);
edge_sep_r(CLK := X22);
edge_tg(CLK := X16);
edge_aw(CLK := X13);
edge_ae(CLK := X14);
edge_fa(CLK := X29);
edge_fg(CLK := X2A);
edge_swap(CLK := Y17);
edge_as(CLK := X12);

(* ---- Timer calls ---- *)
tmr_cut(IN := (state = 18), PT := T#800ms);
tmr_complete(IN := completed_all, PT := T#500ms);
tmr_grip_resp(IN := (state = 9) OR (state = 14) OR (state = 22), PT := T#500ms);

(* ---- Default outputs ---- *)
Y10 := FALSE;  (* grip *)
Y11 := FALSE;  (* clamp *)
Y12 := FALSE;  (* hold *)
Y13 := FALSE;  (* to_source *)
Y14 := FALSE;  (* to_wrap *)
Y15 := FALSE;  (* to_exit *)
Y16 := FALSE;  (* wrap *)
Y17 := FALSE;  (* swap *)
Y18 := FALSE;  (* prepare_tape *)
Y19 := FALSE;  (* apply_tape *)
Y20 := FALSE;  (* form_grip *)
Y21 := FALSE;  (* form_lift *)
Y22 := FALSE;  (* form_to_supply *)
Y23 := FALSE;  (* source_advance *)
Y24 := FALSE;  (* source_lower *)
Y1A := FALSE;  (* cut *)
Y1B := FALSE;  (* complete *)
Y1C := FALSE;  (* unit_feed *)
Y1D := FALSE;  (* form_stop *)
Y1E := FALSE;  (* form_index *)
Y1F := FALSE;  (* form_align *)
D200 := 0;

(* ---- Main state machine ---- *)
CASE state OF

    0: (* IDLE - wait for start *)
        IF edge_start.Q THEN
            state := 1;
        END_IF;

    1: (* FORM FEED STATE - feed items for current bundle *)
        IF (form_cycle_done(bundle_idx)) THEN
            (* Check if we have enough items or already formed *)
            IF (X2A OR bundle_idx >= 2) THEN
                form_cycle_done(bundle_idx) := TRUE;
                IF bundle_idx < 2 THEN
                    bundle_idx := bundle_idx + 1;
                    state := 1;
                ELSE
                    form_cycle_done(2) := TRUE;
                    state := 5;
                END_IF;
            ELSE
                state := 2;
            END_IF;
        ELSE
            state := 2;
        END_IF;

    2: (* FEED_CHECK - verify entrance clear and ready *)
        IF X28 AND X25 AND NOT X27 THEN
            state := 3;
        ELSIF X29 AND X2A THEN
            (* Already aligned and gripped from previous step *)
            form_cycle_done(bundle_idx) := TRUE;
            IF bundle_idx < 2 THEN
                bundle_idx := bundle_idx + 1;
                state := 1;
            ELSE
                state := 5;
            END_IF;
        END_IF;

    3: (* FEED_STOP - close stop plate *)
        Y1D := TRUE;
        IF X26 THEN
            state := 4;
        END_IF;

    4: (* FEED_ITEM - feed single item *)
        Y1D := TRUE;
        Y1C := TRUE;
        IF NOT X28 THEN
            (* Entrance now filled, release stop and prepare index *)
            Y1D := FALSE;
            Y1C := FALSE;
            state := 40;
        END_IF;

    40: (* FEED_INDEX_READY - prepare for index pulse *)
        Y1D := FALSE;
        Y1C := FALSE;
        IF NOT X27 THEN
            state := 41;
        END_IF;

    41: (* FEED_INDEX - pulse form_index to advance item *)
        Y1E := TRUE;
        (* Index pulse is just one scan, move on next scan *)
        state := 42;

    42: (* FEED_INDEX_WAIT - wait for index to complete *)
        Y1E := FALSE;
        IF NOT X27 AND X29 THEN
            (* Index done and aligned *)
            state := 43;
        ELSIF NOT X27 AND NOT X29 AND X25 THEN
            (* Index done, check if more needed *)
            state := 2;
        ELSE
            state := 42;
        END_IF;

    43: (* CHECK_MORE_ITEMS - see if bundle is complete *)
        IF X29 AND (D9 >= D10 OR (D9 = 0 AND X2A)) THEN
            form_cycle_done(bundle_idx) := TRUE;
            IF bundle_idx < 2 THEN
                bundle_idx := bundle_idx + 1;
                state := 1;
            ELSE
                state := 5;
            END_IF;
        ELSIF X29 THEN
            state := 44;
        ELSE
            state := 2;
        END_IF;

    44: (* MORE_FEED - continue feeding for this bundle *)
        IF X25 AND X28 AND NOT X27 THEN
            state := 3;
        END_IF;

    5: (* FORM_ALIGN - close alignment plates for current bundle *)
        Y1F := TRUE;
        IF X29 OR X2A THEN
            state := 6;
        END_IF;

    6: (* FORM_GRIP - grip the bundle with forming gripper *)
        Y20 := TRUE;
        IF X2A THEN
            state := 7;
        END_IF;

    7: (* FORM_LIFT - raise forming head above 1700mm for X movement *)
        Y21 := TRUE;
        Y20 := TRUE;
        IF X2C THEN
            state := 8;
        END_IF;

    8: (* TRANSFER_PREP - position transfer for pickup *)
        Y21 := TRUE;
        Y20 := TRUE;
        IF X10 AND NOT X12 THEN
            (* Source ready but not at pickup, need to lower *)
            state := 9;
        ELSIF X12 OR X17 THEN
            state := 10;
        ELSE
            state := 8;
        END_IF;

    9: (* LOWER_SOURCE - lower transfer head to pickup position *)
        Y24 := TRUE;
        IF X12 OR X33 THEN
            Y24 := FALSE;
            state := 10;
        END_IF;

    10: (* XFER_GRIP - transfer gripper grips bundle *)
        Y21 := TRUE;
        Y14 := TRUE;
        Y10 := TRUE;
        IF X16 THEN
            state := 11;
        END_IF;

    11: (* MOVE_TO_WRAP - transfer to wrapping position *)
        Y21 := TRUE;
        Y14 := TRUE;
        Y10 := TRUE;
        IF X13 THEN
            state := 12;
        END_IF;

    12: (* CLAMP - wrapping chuck clamps the bundle *)
        Y14 := TRUE;
        Y10 := TRUE;
        Y11 := TRUE;
        IF X19 THEN
            state := 13;
        END_IF;

    13: (* RELEASE_XFER - release transfer grip, chuck now holds *)
        Y14 := TRUE;
        Y10 := FALSE;
        Y11 := TRUE;
        IF X17 THEN
            state := 14;
        END_IF;

    14: (* RETURN_TO_SOURCE - transfer gripper returns *)
        Y13 := TRUE;
        Y11 := TRUE;
        IF X12 OR (NOT X15) THEN
            Y13 := FALSE;
            state := 15;
        END_IF;

    15: (* FORM_ADVANCE - check if forming area can advance supply *)
        Y11 := TRUE;
        IF X32 AND X2C AND NOT X15 THEN
            Y23 := TRUE;
            Y22 := TRUE;
            IF NOT X32 THEN
                Y23 := FALSE;
                Y22 := FALSE;
                state := 16;
            END_IF;
        ELSE
            state := 16;
        END_IF;

    16: (* WAIT_WRAP_READY - wait for clamped, held, tool_clear *)
        Y11 := TRUE;
        Y12 := TRUE;
        IF X19 AND X1B AND X18 THEN
            state := 17;
        END_IF;

    17: (* WRAP - rotate and apply film *)
        Y11 := TRUE;
        Y12 := TRUE;
        Y16 := TRUE;
        wrap_paused_for_swap := FALSE;
        IF D2 >= D3 THEN
            Y16 := FALSE;
            state := 20;
        ELSIF D4 <= 200 AND NOT swap_done_flag AND NOT wrap_paused_for_swap THEN
            (* Film running low, pause for swap *)
            Y16 := FALSE;
            wrap_paused_for_swap := TRUE;
            state := 18;
        END_IF;

    18: (* SWAP_REQUEST - request reel swap *)
        Y11 := TRUE;
        Y12 := TRUE;
        IF X19 AND X1B AND X18 AND NOT Y16 THEN
            Y17 := TRUE;
            swap_done_flag := TRUE;
        END_IF;
        IF NOT X1D AND Y17 THEN
            Y17 := FALSE;
            state := 19;
        ELSIF X1D THEN
            state := 18;
        END_IF;

    19: (* WAIT_SWAP_DONE - wait for swap to complete *)
        Y11 := TRUE;
        Y12 := TRUE;
        IF NOT X1D THEN
            state := 17;
        END_IF;

    20: (* TAPE_PREP - prepare tape for current bundle *)
        Y11 := TRUE;
        Y12 := TRUE;
        IF NOT tape_prep_done_flag THEN
            Y18 := TRUE;
            D200 := D8;
            tape_prep_done_flag := TRUE;
        END_IF;
        IF X20 OR (D5 = D0) THEN
            Y18 := FALSE;
            state := 21;
        END_IF;

    21: (* TAPE - apply tape *)
        Y11 := TRUE;
        Y12 := TRUE;
        IF D5 = D0 AND X20 THEN
            Y19 := TRUE;
        END_IF;
        IF X21 THEN
            Y19 := FALSE;
            state := 22;
        END_IF;

    22: (* CUT - cut the film *)
        Y11 := TRUE;
        Y12 := TRUE;
        Y1A := TRUE;
        IF tmr_cut.Q OR X22 THEN
            Y1A := FALSE;
            state := 23;
        END_IF;

    23: (* WAIT_SEPARATED - confirm separation *)
        Y11 := TRUE;
        Y12 := TRUE;
        IF X22 THEN
            state := 24;
        END_IF;

    24: (* GRIP_FOR_EXIT - grip bundle at wrap for exit transfer *)
        Y14 := TRUE;
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := TRUE;
        IF X16 THEN
            state := 25;
        END_IF;

    25: (* RELEASE_CLAMP - release chuck grip *)
        Y14 := TRUE;
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := TRUE;
        IF X23 AND X22 AND X17 THEN
            state := 26;
        END_IF;

    26: (* MOVE_TO_EXIT - transfer to exit position *)
        Y15 := TRUE;
        Y10 := TRUE;
        IF X14 THEN
            state := 27;
        END_IF;

    27: (* RELEASE_AT_EXIT - release bundle at exit *)
        Y15 := TRUE;
        Y10 := FALSE;
        IF X17 THEN
            state := 28;
        END_IF;

    28: (* RETURN_FROM_EXIT - return transfer gripper *)
        Y13 := TRUE;
        IF X12 OR (NOT X15) THEN
            Y13 := FALSE;
            state := 29;
        END_IF;

    29: (* CHECK_BUNDLES - see if more bundles remain *)
        IF bundle_idx < 2 AND NOT form_cycle_done(bundle_idx + 1) THEN
            (* Start next bundle formation while returning *)
            state := 30;
        ELSIF bundle_idx >= 2 AND proc_cycle_done(2) THEN
            state := 300;
        ELSE
            state := 30;
        END_IF;

    30: (* CONCURRENT_FEED - feed next bundle while processing continues *)
        IF bundle_idx < 2 THEN
            bundle_idx := bundle_idx + 1;
            state := 1;
        ELSE
            state := 300;
        END_IF;

    300: (* ALL_DONE_CHECK - verify everything is complete *)
        IF X24 AND X17 AND NOT X19 AND NOT X16 AND NOT X15 THEN
            (* All received, empty gripper, chuck released, no movement *)
            completed_all := TRUE;
            state := 301;
        ELSE
            state := 300;
        END_IF;

    301: (* COMPLETE_HOLD - maintain complete signal *)
        Y1B := TRUE;
        IF tmr_complete.Q THEN
            state := 302;
        END_IF;

    302: (* COMPLETE_FINAL - final state maintaining complete *)
        Y1B := TRUE;
        IF NOT X24 OR X16 OR X19 THEN
            state := 301;
        END_IF;

END_CASE;

(* ---- Safety interlocks ---- *)
(* X movement only above 1700mm *)
IF (Y14 OR Y15 OR Y13) AND NOT X2C THEN
    Y21 := TRUE;
END_IF;

(* No simultaneous gripper/conveyor movement *)
IF Y23 AND (Y10 OR Y13 OR Y14 OR Y15) THEN
    Y23 := FALSE;
END_IF;

(* No additional feed/index during movement *)
IF X15 OR Y14 OR Y15 OR Y13 THEN
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
END_IF;

(* Do not wrap if film exhausted or swap in progress *)
IF D4 <= 0 OR X1D THEN
    Y16 := FALSE;
END_IF;

(* Maintain film holder through wrapping and cutting *)
IF state >= 16 AND state <= 23 THEN
    Y12 := TRUE;
END_IF;

(* Prevent grip release before receiving chuck grips *)
IF state = 13 AND NOT X19 THEN
    Y10 := TRUE;
END_IF;

(* Prevent transfer before separation *)
IF state >= 24 AND NOT X22 THEN
    Y14 := TRUE;
    Y10 := TRUE;
END_IF;

(* Prevent transfer before chuck release *)
IF state >= 24 AND X19 THEN
    Y11 := TRUE;
END_IF;

(* Prevent chuck release before receiving grip *)
IF state = 25 AND NOT X16 THEN
    Y11 := TRUE;
END_IF;

(* Forming index requires item at entry, capacity, and released alignment plates *)
IF state = 41 AND (NOT X28 OR D9 >= D10 OR Y1F) THEN
    Y1E := FALSE;
END_IF;

END_PROGRAM
```