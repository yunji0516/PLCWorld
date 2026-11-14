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

    (* Internal State Variables *)
    started : BOOL;
    form_state : INT;
    supply_state : INT;
    transfer_state : INT;
    wrap_state : INT;

    wrap_occupied : BOOL;
    wrap_done : BOOL;
    bundles_completed : INT;

    t_complete : TON;
    complete_latched : BOOL;

    r_index : BOOL;
    last_feed_item : BOOL;
    swap_req : BOOL;
    tape_req : BOOL;
    to_wrap_pulse : BOOL;
    to_source_pulse : BOOL;
    to_exit_pulse : BOOL;
END_VAR

(* Edge detection and latch initial start *)
IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := TRUE; (* maintain film-end holder *)
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y20 := FALSE;
    Y21 := TRUE; (* forming head starts high *)
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
    form_state := 0;
    supply_state := 0;
    transfer_state := 0;
    wrap_state := 0;
    wrap_occupied := FALSE;
    wrap_done := FALSE;
    bundles_completed := 0;
    complete_latched := FALSE;
END_IF;

IF started AND NOT complete_latched THEN

    (* Always maintain film hold active when wrapping / waiting *)
    Y12 := TRUE;

    (* ======================================================== *)
    (* 1. FORMING PROCESS                                       *)
    (* ======================================================== *)
    CASE form_state OF
        0: (* Close forming stop and wait for ready *)
            Y1D := TRUE; (* close stop plate *)
            Y21 := TRUE; (* keep high *)
            Y20 := FALSE;
            Y22 := FALSE;
            Y1F := FALSE;
            IF X26 AND NOT X31 AND (D11 < 3) THEN
                form_state := 10;
            END_IF;

        10: (* Feed single item to forming entry *)
            IF X25 AND X28 AND (D9 < D10) AND NOT X27 AND NOT Y1F THEN
                Y1C := TRUE; (* unit_feed *)
            ELSE
                Y1C := FALSE;
            END_IF;

            (* When single item reaches entry, trigger index if space available *)
            IF NOT X28 AND (D9 < D10) AND NOT X27 AND NOT Y1F THEN
                Y1C := FALSE;
                Y1E := TRUE; (* pulse form_index *)
                form_state := 15;
            ELSIF D9 >= D10 AND D9 > 0 THEN
                Y1C := FALSE;
                Y1E := FALSE;
                form_state := 20; (* proceed to align *)
            END_IF;

        15: (* Wait for indexing to finish *)
            Y1E := FALSE;
            IF NOT X27 THEN
                IF D9 >= D10 THEN
                    form_state := 20;
                ELSE
                    form_state := 10;
                END_IF;
            END_IF;

        20: (* Alignment *)
            Y1F := TRUE; (* form_align *)
            IF X29 THEN
                (* Aligned, descend forming head *)
                form_state := 30;
            END_IF;

        30: (* Descend head to low position *)
            Y21 := FALSE; (* form_lift OFF = 1100 mm *)
            IF X2D AND X2E THEN
                (* Grip bundle *)
                Y20 := TRUE; (* form_grip *)
                form_state := 40;
            END_IF;

        40: (* Wait for grip confirmation *)
            IF X2A THEN
                Y1F := FALSE; (* release alignment *)
                Y21 := TRUE;  (* form_lift ON = 1750 mm *)
                form_state := 50;
            END_IF;

        50: (* Wait for head high *)
            IF X2C THEN
                form_state := 60;
            END_IF;

        60: (* Move forming head to supply position *)
            IF X30 THEN (* form_supply_clear *)
                Y22 := TRUE; (* form_to_supply *)
                IF X2F THEN
                    form_state := 70;
                END_IF;
            END_IF;

        70: (* Lower at supply position *)
            Y21 := FALSE; (* form_lift down *)
            IF X2D THEN
                Y20 := FALSE; (* release form_grip *)
                form_state := 80;
            END_IF;

        80: (* Wait for grip fully open *)
            IF X2B THEN
                Y21 := TRUE; (* lift head back up *)
                form_state := 90;
            END_IF;

        90: (* Return forming head to table *)
            IF X2C THEN
                Y22 := FALSE; (* return to table *)
                IF X2E THEN
                    supply_state := 10; (* signal supply conveyor to advance *)
                    IF D11 < 3 AND NOT X31 THEN
                        form_state := 0; (* ready for next bundle *)
                    ELSE
                        form_state := 100; (* formation complete *)
                    END_IF;
                END_IF;
            END_IF;

        100: (* Formation idle / finished *)
            Y1C := FALSE;
            Y1E := FALSE;
            Y1F := FALSE;
            Y20 := FALSE;
            Y21 := TRUE;
            Y22 := FALSE;
    END_CASE;

    (* ======================================================== *)
    (* 2. SUPPLY CONVEYOR ADVANCE                               *)
    (* ======================================================== *)
    CASE supply_state OF
        0:
            Y23 := FALSE;

        10: (* Advance supply belt if heads are clear *)
            IF X32 AND X2C AND NOT Y24 THEN
                Y23 := TRUE;
                IF X10 THEN (* source_ready *)
                    Y23 := FALSE;
                    supply_state := 20;
                END_IF;
            ELSE
                Y23 := FALSE;
            END_IF;

        20: (* Wait until bundle is picked up from source *)
            Y23 := FALSE;
            IF NOT X10 THEN
                supply_state := 0;
            END_IF;
    END_CASE;

    (* ======================================================== *)
    (* 3. TRANSFER GRIPPER PROCESS                              *)
    (* ======================================================== *)
    CASE transfer_state OF
        0: (* Transfer gripper waiting at return height above supply *)
            Y10 := FALSE;
            Y24 := FALSE;
            Y13 := FALSE;
            Y14 := FALSE;
            Y15 := FALSE;
            IF X10 AND X33 AND NOT wrap_occupied AND (bundles_completed + BOOL_TO_INT(wrap_occupied) < 3) THEN
                (* Descend to source pickup position *)
                Y24 := TRUE;
                IF X12 THEN
                    transfer_state := 10;
                END_IF;
            END_IF;

        10: (* Grip bundle at source *)
            Y10 := TRUE; (* grip *)
            IF X16 THEN  (* transfer_gripped *)
                Y24 := FALSE; (* lift back up *)
                transfer_state := 20;
            END_IF;

        20: (* Move transfer gripper to wrap chuck *)
            IF NOT X12 THEN (* raised to clearance height *)
                Y14 := TRUE; (* to_wrap *)
                IF X13 AND X11 THEN
                    Y14 := FALSE;
                    transfer_state := 30;
                END_IF;
            END_IF;

        30: (* At wrap chuck: wait for chuck clamp *)
            IF X19 THEN (* clamped *)
                Y10 := FALSE; (* grip OFF *)
                IF X17 THEN  (* transfer_open *)
                    transfer_state := 40;
                END_IF;
            END_IF;

        40: (* Return gripper to source/standby to clear rotation area *)
            Y13 := TRUE; (* to_source *)
            wrap_occupied := TRUE;
            IF X18 THEN  (* tool_clear *)
                Y13 := FALSE;
                transfer_state := 50;
            END_IF;

        50: (* Wait for wrapping and taping and cut to complete *)
            IF wrap_done THEN
                (* Move gripper back to wrap chuck to receive finished bundle *)
                Y14 := TRUE; (* to_wrap *)
                IF X13 THEN
                    Y14 := FALSE;
                    transfer_state := 60;
                END_IF;
            END_IF;

        60: (* Grip finished bundle at wrapping chuck *)
            Y10 := TRUE; (* grip *)
            IF X16 THEN  (* transfer_gripped *)
                transfer_state := 70;
            END_IF;

        70: (* Wait for chuck to release clamp, verify separation and exit clear *)
            IF X1A AND X22 AND X23 THEN (* open, separated, exit_clear *)
                Y15 := TRUE; (* to_exit *)
                IF X14 THEN  (* at_exit *)
                    Y15 := FALSE;
                    transfer_state := 80;
                END_IF;
            END_IF;

        80: (* Place bundle at exit *)
            Y10 := FALSE; (* grip OFF *)
            IF X17 THEN  (* transfer_open *)
                bundles_completed := bundles_completed + 1;
                wrap_occupied := FALSE;
                wrap_done := FALSE;
                transfer_state := 90;
            END_IF;

        90: (* Return transfer gripper to source *)
            Y13 := TRUE; (* to_source *)
            IF X33 THEN
                Y13 := FALSE;
                IF bundles_completed >= 3 THEN
                    transfer_state := 100;
                ELSE
                    transfer_state := 0;
                END_IF;
            END_IF;

        100: (* All bundles transferred *)
            Y10 := FALSE;
            Y13 := FALSE;
            Y14 := FALSE;
            Y15 := FALSE;
            Y24 := FALSE;
    END_CASE;

    (* ======================================================== *)
    (* 4. CHUCK, WRAPPING, TAPING, AND CUT PROCESS              *)
    (* ======================================================== *)
    CASE wrap_state OF
        0: (* Chuck open and idle *)
            Y11 := FALSE;
            Y16 := FALSE;
            Y17 := FALSE;
            Y18 := FALSE;
            Y19 := FALSE;
            Y1A := FALSE;
            IF transfer_state = 30 AND X13 AND X11 THEN
                Y11 := TRUE; (* clamp *)
                IF X19 THEN
                    wrap_state := 10;
                END_IF;
            END_IF;

        10: (* Prepare tape and check wrap conditions *)
            D200 := D0; (* tape_order := token *)
            IF NOT X20 AND NOT Y18 THEN
                Y18 := TRUE; (* prepare_tape rising pulse *)
            ELSE
                Y18 := FALSE;
            END_IF;

            IF X18 AND X19 AND X1B THEN (* tool_clear, clamped, held *)
                IF NOT X1C AND X1E AND NOT X1D THEN
                    (* Film empty, request reel swap *)
                    Y17 := TRUE; (* swap *)
                    wrap_state := 15;
                ELSIF X1C THEN
                    wrap_state := 20;
                END_IF;
            END_IF;

        15: (* Reel swap in progress *)
            Y17 := FALSE;
            IF NOT X1D AND X1C THEN
                wrap_state := 20;
            END_IF;

        20: (* Wrap rotation *)
            IF NOT X1C AND X1E THEN
                (* Exhausted during wrap *)
                Y16 := FALSE;
                Y17 := TRUE;
                wrap_state := 25;
            ELSIF D2 < D3 AND X1C AND X18 AND X19 AND X1B THEN
                Y16 := TRUE; (* wrap *)
            ELSIF D2 >= D3 THEN
                Y16 := FALSE; (* stop wrap *)
                wrap_state := 30;
            END_IF;

        25: (* Wait for swap during wrap *)
            Y17 := FALSE;
            IF NOT X1D AND X1C THEN
                wrap_state := 20;
            END_IF;

        30: (* Apply Tape *)
            Y16 := FALSE;
            IF X20 AND (D5 = D0) THEN
                Y19 := TRUE; (* apply_tape *)
                IF X21 THEN  (* taped *)
                    Y19 := FALSE;
                    wrap_state := 40;
                END_IF;
            END_IF;

        40: (* Film Cut *)
            Y1A := TRUE; (* cut *)
            IF X22 THEN  (* separated *)
                Y1A := FALSE;
                wrap_done := TRUE;
                wrap_state := 50;
            END_IF;

        50: (* Wait for transfer gripper to grip, then release clamp *)
            IF transfer_state = 70 THEN
                Y11 := FALSE; (* clamp OFF *)
                IF X1A THEN   (* open *)
                    wrap_state := 60;
                END_IF;
            END_IF;

        60: (* Bundle departing wrap chuck *)
            IF NOT wrap_occupied THEN
                wrap_state := 0;
            END_IF;
    END_CASE;

END_IF;

(* ======================================================== *)
(* 5. COMPLETION MONITORING                                 *)
(* ======================================================== *)
IF (bundles_completed >= 3) AND (X24 OR (D7 >= 9)) AND NOT wrap_occupied
   AND X17 AND X18 AND X33 AND X2C AND X2E AND NOT Y10 AND NOT Y11 AND NOT Y16 AND NOT Y19 AND NOT Y1A THEN
    t_complete(IN := TRUE, PT := T#500ms);
    IF t_complete.Q THEN
        complete_latched := TRUE;
        Y1B := TRUE;
    END_IF;
ELSE
    t_complete(IN := FALSE, PT := T#500ms);
END_IF;

IF complete_latched THEN
    Y1B := TRUE;
    Y10 := FALSE;
    Y11 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y20 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y1A := FALSE;
    Y1C := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
END_IF;

END_PROGRAM