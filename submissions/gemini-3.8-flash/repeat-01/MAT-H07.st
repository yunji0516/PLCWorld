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
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
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
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
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
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
    Y28 : BOOL;
    Y29 : BOOL;

    step : INT := 0;
    rolls_completed : INT := 0;
    wait_cnt : INT := 0;

    a_accepted : BOOL := FALSE;
    b_accepted : BOOL := FALSE;
    b_trimmed : BOOL := FALSE;

    tape_step : INT := 0;
    core_step : INT := 0;

    t_timer : TON;
    t_en : BOOL := FALSE;
    t_pt : TIME := T#0ms;
END_VAR

IF NOT X0 THEN
    RETURN;
END_IF;

(* Sub-task 1: Accept Web A *)
IF NOT a_accepted THEN
    IF X10 AND NOT X12 THEN
        Y10 := TRUE;
    ELSE
        Y10 := FALSE;
        IF X12 THEN
            a_accepted := TRUE;
        END_IF;
    END_IF;
ELSE
    Y10 := FALSE;
END_IF;

(* Sub-task 2: Accept Web B, Jog to origin_b, Hold, Trim, Ack Trim *)
IF NOT b_trimmed THEN
    IF NOT b_accepted THEN
        IF X11 AND NOT X13 THEN
            Y11 := TRUE;
        ELSE
            Y11 := FALSE;
            IF X13 THEN
                b_accepted := TRUE;
            END_IF;
        END_IF;
    ELSE
        Y11 := FALSE;
        IF D2 < D0 THEN
            Y14 := TRUE;
            Y13 := FALSE;
        ELSE
            Y14 := FALSE;
            Y13 := TRUE;
            IF X15 AND NOT X16 THEN
                Y15 := TRUE;
            ELSE
                Y15 := FALSE;
                IF X17 THEN
                    Y16 := TRUE;
                    b_trimmed := TRUE;
                ELSE
                    Y16 := FALSE;
                END_IF;
            END_IF;
        END_IF;
    END_IF;
ELSE
    Y11 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
END_IF;

(* Tape Preparation Sub-routine for current roll *)
CASE tape_step OF
    0:
        IF rolls_completed < 3 THEN
            IF NOT X32 AND NOT X31 AND NOT X30 AND NOT X2F THEN
                Y25 := TRUE;
                tape_step := 1;
            END_IF;
        END_IF;
    1:
        Y25 := FALSE;
        IF X2F THEN
            Y26 := TRUE;
            IF X30 THEN
                Y27 := TRUE;
                tape_step := 2;
            END_IF;
        END_IF;
    2:
        Y27 := FALSE;
        IF X31 THEN
            tape_step := 3; (* Tape prepared, held, severed; ready for apply *)
        END_IF;
    3:
        (* Holding tape until application *)
        Y26 := TRUE;
    4:
        (* Tape applied, reset state for next roll *)
        Y26 := FALSE;
        IF NOT X31 AND NOT X30 THEN
            tape_step := 0;
        END_IF;
END_CASE;

(* Core Feed Sub-routine *)
CASE core_step OF
    0:
        IF rolls_completed < 3 THEN
            IF NOT X2D AND NOT X2C THEN
                Y24 := TRUE; (* core_stop closed *)
                IF X2E THEN
                    Y23 := TRUE; (* core_feed *)
                    core_step := 1;
                END_IF;
            ELSIF X2D AND X2E THEN
                core_step := 2; (* Core seated and ready *)
            END_IF;
        END_IF;
    1:
        IF X2D THEN
            Y23 := FALSE;
            core_step := 2;
        END_IF;
    2:
        (* Core ready at seated position *)
        IF step >= 20 AND step <= 25 THEN
            (* Core has been accepted and moved onto shaft *)
            core_step := 0;
        END_IF;
END_CASE;

(* Main Roll Winding and Extraction Sequence *)
CASE step OF
    0: (* Wait for Web A ready, Web B trimmed, Tape ready, and Core seated *)
        IF a_accepted AND b_trimmed AND (tape_step = 3) AND (core_step = 2) AND X1D THEN
            Y17 := TRUE; (* accept_roll *)
            step := 1;
        END_IF;

    1:
        Y17 := FALSE;
        IF X19 THEN (* roll_ready *)
            Y1F := TRUE; (* extend_mandrel *)
            Y1E := FALSE;
            step := 2;
        END_IF;

    2:
        IF X1E THEN (* mandrel_in *)
            Y1F := FALSE;
            (* Close nips, release holders *)
            Y18 := TRUE; (* nip_a *)
            Y19 := TRUE; (* nip_b *)
            Y12 := FALSE; (* hold_a *)
            Y13 := FALSE; (* hold_b *)
            step := 3;
        END_IF;

    3:
        IF X1B AND X1C AND X24 THEN (* nips engaged, holders released *)
            Y1A := TRUE; (* wind *)
            step := 4;
        END_IF;

    4:
        (* Wind until allocated target reached *)
        IF D5 >= (D4 - 2) THEN
            Y1A := FALSE; (* Stop wind *)
            Y12 := TRUE;  (* hold_a *)
            Y13 := TRUE;  (* hold_b *)
            step := 5;
        END_IF;

    5:
        IF X14 AND X15 THEN (* Both holders contacted *)
            Y1C := TRUE; (* cut_a *)
            Y1D := TRUE; (* cut_b *)
            step := 6;
        END_IF;

    6:
        Y1C := FALSE;
        Y1D := FALSE;
        IF X27 AND X28 THEN (* webs_cut and cutters_clear *)
            Y1A := TRUE; (* Wind tail without new supply *)
            step := 7;
        END_IF;

    7:
        IF (D7 <= 0) OR X26 THEN (* Tail wound *)
            Y1A := FALSE; (* Wind OFF *)
            step := 8;
        END_IF;

    8:
        IF NOT Y1A THEN
            Y1B := TRUE; (* Support outer diameter with cradle *)
            IF X1F THEN  (* support_contact *)
                step := 9;
            END_IF;
        END_IF;

    9:
        (* Apply tape to secure tail *)
        IF tape_step = 3 THEN
            Y28 := TRUE; (* tape_apply *)
            step := 10;
        END_IF;

    10:
        Y28 := FALSE;
        IF X33 THEN (* tail_taped *)
            tape_step := 4; (* Release tape hold and prepare for next *)
            step := 11;
        END_IF;

    11:
        (* Retract mandrel *)
        IF X1F AND X33 THEN
            Y1E := TRUE; (* retract_mandrel *)
            Y1F := FALSE;
            step := 12;
        END_IF;

    12:
        IF X1D THEN (* mandrel_out *)
            Y1E := FALSE;
            Y18 := FALSE; (* release nip_a *)
            Y19 := FALSE; (* release nip_b *)
            step := 13;
        END_IF;

    13:
        (* Eject roll to fixed receiving roller *)
        IF NOT X21 THEN (* exit not busy *)
            Y20 := TRUE; (* eject *)
            step := 14;
        END_IF;

    14:
        Y20 := FALSE;
        IF X21 THEN
            step := 15;
        END_IF;

    15:
        IF NOT X21 THEN (* Eject movement completed, cradle returned *)
            step := 16;
        END_IF;

    16:
        (* Export roll to external receiver *)
        IF X34 AND X35 THEN (* exit_clear and receiver_ready *)
            Y29 := TRUE; (* release_exit *)
            step := 17;
        END_IF;

    17:
        IF X22 THEN (* exit_received *)
            Y21 := TRUE; (* ack_exit *)
            step := 18;
        END_IF;

    18:
        Y21 := FALSE;
        Y29 := FALSE; (* retract pusher *)
        rolls_completed := rolls_completed + 1;
        IF rolls_completed >= 3 THEN
            step := 30; (* All rolls done *)
        ELSE
            step := 20; (* Prepare for next roll *)
        END_IF;

    20:
        (* Next roll preparation *)
        IF (tape_step = 3) AND (core_step = 2) AND X1D THEN
            step := 0;
        END_IF;

    30:
        (* Final completion check and claim *)
        IF X23 OR (rolls_completed >= 3 AND X1D AND NOT X21 AND NOT Y29) THEN
            Y22 := TRUE; (* complete *)
        END_IF;
END_CASE;

END_PROGRAM
