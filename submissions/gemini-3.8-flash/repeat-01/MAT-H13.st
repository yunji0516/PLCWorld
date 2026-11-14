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

    (* Internal variables *)
    f_state : INT := 0;
    c_state : INT := 0;
    t_state : INT := 0;
    w_state : INT := 0;

    prev_start : BOOL := FALSE;
    started : BOOL := FALSE;

    t_pulse : TON;
    t_wait : TON;
    t_conv : TON;
    t_cut : TON;
    t_tape : TON;
    t_swap : TON;

    bundle_on_conv : BOOL := FALSE;
    bundle_at_pickup : BOOL := FALSE;
    chuck_has_bundle : BOOL := FALSE;
    tape_requested : BOOL := FALSE;
    discharged_count : INT := 0;
    completion_hold : TON;
    done_flag : BOOL := FALSE;
END_VAR

IF X0 AND NOT prev_start THEN
    started := TRUE;
END_IF;
prev_start := X0;

IF NOT started THEN
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := TRUE; (* hold film lead initially *)
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y20 := FALSE;
    Y21 := TRUE; (* forming head high *)
    Y22 := FALSE; (* forming head at table *)
    Y23 := FALSE;
    Y24 := FALSE;
    Y1A := FALSE;
    Y1B := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    RETURN;
END_IF;

(* ------------------------------------------------------------- *)
(* 1. FORMING PROCESS (f_state)                                  *)
(* ------------------------------------------------------------- *)
CASE f_state OF
    0: (* Initial: Head up, at table, wait for unit feed ready *)
        Y21 := TRUE;
        Y22 := FALSE;
        Y20 := FALSE;
        Y1F := FALSE;
        Y1E := FALSE;
        Y1C := FALSE;
        Y1D := FALSE;
        IF X2C AND X2E AND X2B THEN
            f_state := 10;
        END_IF;

    10: (* Check if formation is complete *)
        IF X31 OR (D11 >= 3) THEN
            f_state := 99; (* All bundles formed *)
        ELSIF D9 < D10 THEN
            (* Feed next single piece *)
            IF X25 AND X28 THEN
                Y1D := TRUE; (* Close stop plate *)
                IF X26 THEN
                    Y1C := TRUE; (* Feed unit *)
                    f_state := 11;
                END_IF;
            END_IF;
        ELSE
            (* Table has reached form_target_count: Align items *)
            Y1C := FALSE;
            Y1D := FALSE;
            Y1F := TRUE; (* form_align *)
            IF X29 THEN
                f_state := 20; (* Table aligned, ready to descend and grip *)
            END_IF;
        END_IF;

    11: (* Feeding unit *)
        IF NOT X28 THEN (* Entry is filled, item arrived *)
            Y1C := FALSE;
            Y1D := FALSE;
            f_state := 12;
        END_IF;

    12: (* Index incoming item *)
        IF NOT X27 THEN
            Y1E := TRUE; (* Rising edge of form_index *)
            f_state := 13;
        END_IF;

    13: (* Wait for index to complete *)
        IF X27 THEN
            Y1E := FALSE;
        ELSE
            f_state := 10;
        END_IF;

    20: (* Descend head to table (1100mm) *)
        Y21 := FALSE; (* Lower forming head *)
        IF X2D THEN
            f_state := 21;
        END_IF;

    21: (* Grip formed bundle *)
        Y20 := TRUE;
        IF X2A THEN
            Y1F := FALSE; (* Release alignment plates *)
            f_state := 22;
        END_IF;

    22: (* Lift head to 1750mm *)
        Y21 := TRUE;
        IF X2C THEN
            f_state := 23;
        END_IF;

    23: (* Move to supply position (X=0) when supply clear *)
        IF X30 AND NOT bundle_on_conv THEN
            Y22 := TRUE;
            IF X2F THEN
                f_state := 24;
            END_IF;
        END_IF;

    24: (* Lower head to supply height *)
        Y21 := FALSE;
        IF X2D THEN
            f_state := 25;
        END_IF;

    25: (* Release grip to place bundle on supply belt *)
        Y20 := FALSE;
        IF X2B THEN
            bundle_on_conv := TRUE;
            f_state := 26;
        END_IF;

    26: (* Lift head back up *)
        Y21 := TRUE;
        IF X2C THEN
            f_state := 27;
        END_IF;

    27: (* Return head to table *)
        Y22 := FALSE;
        IF X2E THEN
            f_state := 10;
        END_IF;

    99: (* Done forming all bundles *)
        Y21 := TRUE;
        Y22 := FALSE;
        Y20 := FALSE;
        Y1C := FALSE;
        Y1D := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
END_CASE;

(* ------------------------------------------------------------- *)
(* 2. SUPPLY CONVEYOR PROCESS (c_state)                          *)
(* ------------------------------------------------------------- *)
CASE c_state OF
    0:
        Y23 := FALSE;
        IF bundle_on_conv AND NOT bundle_at_pickup THEN
            c_state := 10;
        END_IF;

    10: (* Check safety before advancing supply belt *)
        (* Head must be high (X2C) and source head must be at return height (not lowered) *)
        IF X32 AND X2C AND NOT Y24 THEN
            Y23 := TRUE;
            c_state := 11;
        END_IF;

    11: (* Advancing until pickup position is reached *)
        IF X10 AND X33 THEN (* source_ready and source_head_at_pickup *)
            Y23 := FALSE;
            bundle_on_conv := FALSE;
            bundle_at_pickup := TRUE;
            c_state := 0;
        END_IF;
END_CASE;

(* ------------------------------------------------------------- *)
(* 3. TRANSFER GRIPPER PROCESS (t_state)                         *)
(* ------------------------------------------------------------- *)
CASE t_state OF
    0: (* At return height above source pickup *)
        Y10 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y24 := FALSE;
        IF bundle_at_pickup AND X10 AND X33 AND NOT chuck_has_bundle THEN
            c_state := 0;
            t_state := 10;
        END_IF;

    10: (* Lower head at pickup *)
        Y24 := TRUE;
        IF X12 THEN (* at_source *)
            t_state := 11;
        END_IF;

    11: (* Grip the bundle *)
        Y10 := TRUE;
        IF X16 THEN (* transfer_gripped *)
            bundle_at_pickup := FALSE;
            t_state := 12;
        END_IF;

    12: (* Raise head back up to return height (source_lower OFF) *)
        Y24 := FALSE;
        IF NOT X12 THEN
            t_state := 20;
        END_IF;

    20: (* Move to wrapping chuck *)
        IF NOT chuck_has_bundle THEN
            Y14 := TRUE; (* to_wrap *)
            IF X13 AND NOT X15 THEN (* at_wrap and not busy *)
                Y14 := FALSE;
                t_state := 21;
            END_IF;
        END_IF;

    21: (* Wait for wrapping chuck to clamp bundle *)
        IF X19 THEN (* clamped *)
            t_state := 22;
        END_IF;

    22: (* Release transfer grip *)
        Y10 := FALSE;
        IF X17 THEN (* transfer_open *)
            chuck_has_bundle := TRUE;
            t_state := 23;
        END_IF;

    23: (* Return transfer gripper to source position to clear chuck *)
        Y13 := TRUE;
        IF NOT X15 AND X18 THEN (* gripper clear of chuck rotation area *)
            Y13 := FALSE;
            t_state := 30;
        END_IF;

    30: (* Gripper waits while wrapping and taping happen *)
        (* When taping is done and wrapping stopped, approach chuck for discharge *)
        IF w_state = 50 THEN
            t_state := 31;
        END_IF;

    31: (* Approach wrapping chuck to grip wrapped bundle *)
        Y14 := TRUE; (* to_wrap *)
        IF X13 AND NOT X15 THEN
            Y14 := FALSE;
            t_state := 32;
        END_IF;

    32: (* Grip the wrapped bundle *)
        Y10 := TRUE;
        IF X16 THEN (* transfer_gripped *)
            t_state := 33;
        END_IF;

    33: (* Chuck releases clamp and film is cut/separated *)
        IF X1A AND X22 AND X23 THEN (* open, separated, exit_clear *)
            chuck_has_bundle := FALSE;
            t_state := 34;
        END_IF;

    34: (* Transfer to exit *)
        Y15 := TRUE; (* to_exit *)
        IF X14 AND NOT X15 THEN (* at_exit *)
            Y15 := FALSE;
            t_state := 35;
        END_IF;

    35: (* Release grip at exit *)
        Y10 := FALSE;
        IF X17 THEN
            discharged_count := discharged_count + 1;
            t_state := 36;
        END_IF;

    36: (* Return gripper to source position *)
        Y13 := TRUE;
        IF NOT X15 AND X33 THEN (* source_head_at_pickup *)
            Y13 := FALSE;
            t_state := 0;
        END_IF;
END_CASE;

(* ------------------------------------------------------------- *)
(* 4. WRAPPING AND TAPING PROCESS (w_state)                      *)
(* ------------------------------------------------------------- *)
CASE w_state OF
    0: (* Idle, wait for chuck to have bundle and transfer gripper clear *)
        Y11 := FALSE;
        Y12 := TRUE; (* hold film lead *)
        Y16 := FALSE;
        Y17 := FALSE;
        Y19 := FALSE;
        Y1A := FALSE;
        IF chuck_has_bundle AND X19 AND X1B AND X18 THEN
            w_state := 10;
        END_IF;

    10: (* Start wrapping *)
        (* Check if film is enough; if exhausted or swap needed *)
        IF D4 < 200 AND X1E THEN (* Film low, swap reel *)
            w_state := 15;
        ELSE
            IF X19 AND X1B AND X18 THEN
                Y16 := TRUE; (* wrap ON *)
                w_state := 11;
            END_IF;
        END_IF;

    11: (* Wrapping in progress *)
        IF (D4 < 50 AND D2 < D3) THEN
            (* Film exhausted mid-wrapping *)
            Y16 := FALSE; (* stop wrapping *)
            w_state := 15; (* do swap *)
        ELSIF D2 >= D3 THEN
            (* Target length reached *)
            Y16 := FALSE; (* wrap OFF *)
            w_state := 20;
        END_IF;

    15: (* Swap reel *)
        Y16 := FALSE;
        IF NOT X16 AND X18 AND X19 AND X1B THEN
            Y17 := TRUE; (* rising edge of swap *)
            w_state := 16;
        END_IF;

    16: (* Waiting for swap to start/complete *)
        IF X1D THEN
            Y17 := FALSE;
        END_IF;
        IF NOT X1D AND X1C THEN (* swap finished, film ready *)
            w_state := 10; (* resume wrapping *)
        END_IF;

    20: (* Wrapping completed, wrap OFF *)
        Y16 := FALSE;
        (* Prepare tape *)
        D200 := D0; (* Request tape matching current token *)
        Y18 := TRUE; (* prepare_tape *)
        tape_requested := TRUE;
        w_state := 21;

    21: (* Wait for tape to be ready *)
        IF X20 AND (D5 = D0) THEN
            Y18 := FALSE;
            w_state := 22;
        END_IF;

    22: (* Apply tape *)
        Y19 := TRUE;
        IF X21 THEN (* taped *)
            Y19 := FALSE;
            w_state := 30;
        END_IF;

    30: (* Cut film *)
        (* cut requires clamping/film holding/target/tape/stop *)
        IF X19 AND X1B AND (D2 >= D3) AND X21 AND NOT Y16 THEN
            Y1A := TRUE; (* cut *)
            w_state := 31;
        END_IF;

    31: (* Wait for separation *)
        IF X22 THEN (* separated *)
            Y1A := FALSE;
            w_state := 50; (* Signal transfer gripper to approach *)
        END_IF;

    50: (* Transfer gripper is approaching and gripping *)
        IF t_state = 33 THEN
            (* Transfer gripper has gripped (X16), now release chuck clamp *)
            Y11 := FALSE;
            IF X1A THEN (* Chuck open *)
                w_state := 51;
            END_IF;
        ELSE
            (* Keep clamp active until transfer gripper grips *)
            Y11 := TRUE;
        END_IF;

    51: (* Bundle taken away, wait for transfer gripper to leave *)
        IF NOT chuck_has_bundle THEN
            w_state := 0;
        END_IF;
END_CASE;

(* Clamp control interlock: chuck clamps when bundle arrives at wrap *)
IF t_state = 21 THEN
    Y11 := TRUE;
END_IF;

(* ------------------------------------------------------------- *)
(* 5. COMPLETION MONITORING                                      *)
(* ------------------------------------------------------------- *)
IF (discharged_count >= 3) AND X24 AND (t_state = 0) AND (w_state = 0) AND (f_state = 99) THEN
    done_flag := TRUE;
END_IF;

completion_hold(IN := done_flag, PT := T#500ms);
IF completion_hold.Q THEN
    Y1B := TRUE; (* complete *)
END_IF;

END_PROGRAM
