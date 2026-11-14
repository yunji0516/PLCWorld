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

    deck_step : INT := 0;
    box_step : INT := 0;
    pack_step : INT := 0;
    complete_timer : TON;

    a_accepted : BOOL := FALSE;
    b_accepted : BOOL := FALSE;
    a_coupled : BOOL := FALSE;
    b_coupled : BOOL := FALSE;
    a_released : BOOL := FALSE;
    b_released : BOOL := FALSE;
    a_acked : BOOL := FALSE;
    b_acked : BOOL := FALSE;

    curr_box_gen : INT := 0;
    boxes_dispatched : INT := 0;

    a_target_gen : INT := 0;
    b_target_gen : INT := 0;
    pack_turn : INT := 0;

    clamp_timer : TON;
    clamp_cmd : BOOL := FALSE;

    feed_cmd : BOOL := FALSE;
    dispatch_req : BOOL := FALSE;
    pack_a_req : BOOL := FALSE;
    pack_b_req : BOOL := FALSE;
    close_a_req : BOOL := FALSE;
    close_b_req : BOOL := FALSE;
    release_a_req : BOOL := FALSE;
    release_b_req : BOOL := FALSE;
    ack_a_req : BOOL := FALSE;
    ack_b_req : BOOL := FALSE;
    accept_a_req : BOOL := FALSE;
    accept_b_req : BOOL := FALSE;
    dock_req : BOOL := FALSE;
    load_req : BOOL := FALSE;
    unload_req : BOOL := FALSE;

    wanted_dest : INT := 0;
    wanted_src : INT := 0;
    dest_gen : INT := 0;
    deck_action : INT := 0; (* 1=move_to_src, 2=load, 3=move_to_dest, 4=unload *)
END_VAR

(* Edge command resets *)
dock_req := FALSE;
load_req := FALSE;
unload_req := FALSE;
accept_a_req := FALSE;
accept_b_req := FALSE;
close_a_req := FALSE;
close_b_req := FALSE;
release_a_req := FALSE;
release_b_req := FALSE;
ack_a_req := FALSE;
ack_b_req := FALSE;
pack_a_req := FALSE;
pack_b_req := FALSE;
dispatch_req := FALSE;

(* Accept requests for A and B *)
IF X13 AND NOT a_accepted THEN
    accept_a_req := TRUE;
    a_accepted := TRUE;
    a_target_gen := D9;
    a_coupled := FALSE;
    a_released := FALSE;
    a_acked := FALSE;
END_IF;

IF X14 AND NOT b_accepted THEN
    accept_b_req := TRUE;
    b_accepted := TRUE;
    b_target_gen := D10;
    b_coupled := FALSE;
    b_released := FALSE;
    b_acked := FALSE;
END_IF;

(* Close requests when counts reach 2 *)
IF a_accepted AND (D13 = 2) AND NOT a_coupled AND NOT X17 THEN
    close_a_req := TRUE;
    a_coupled := TRUE;
END_IF;

IF b_accepted AND (D14 = 2) AND NOT b_coupled AND NOT X18 THEN
    close_b_req := TRUE;
    b_coupled := TRUE;
END_IF;

(* Release requests when ready and clear *)
IF a_accepted AND X17 AND X19 AND NOT a_released THEN
    release_a_req := TRUE;
    a_released := TRUE;
END_IF;

IF b_accepted AND X18 AND X1A AND NOT b_released THEN
    release_b_req := TRUE;
    b_released := TRUE;
END_IF;

(* Deck transfer logic *)
IF X0 THEN
    CASE deck_step OF
        0: (* Idle / Decision *)
            IF NOT X11 THEN
                IF D2 <> 0 THEN
                    (* Part on deck: find where it can go *)
                    IF a_accepted AND X15 AND (D13 < 2) AND (D2 = D11) THEN
                        wanted_dest := 4;
                        dest_gen := a_target_gen;
                        deck_step := 30;
                    ELSIF b_accepted AND X16 AND (D14 < 2) AND (D2 = D12) THEN
                        wanted_dest := 5;
                        dest_gen := b_target_gen;
                        deck_step := 30;
                    ELSIF D6 = 0 THEN
                        wanted_dest := 2;
                        dest_gen := 0;
                        deck_step := 30;
                    ELSIF D8 = 0 THEN
                        wanted_dest := 3;
                        dest_gen := 0;
                        deck_step := 30;
                    END_IF;
                ELSE
                    (* Deck empty: decide what to pick up *)
                    (* Priority 1: Check storage slot 0 for needed part *)
                    IF (D6 <> 0) AND ((a_accepted AND X15 AND (D13 < 2) AND (D6 = D11)) OR (b_accepted AND X16 AND (D14 < 2) AND (D6 = D12))) THEN
                        wanted_src := 2;
                        deck_step := 10;
                    (* Priority 2: Check storage slot 1 for needed part *)
                    ELSIF (D8 <> 0) AND ((a_accepted AND X15 AND (D13 < 2) AND (D8 = D11)) OR (b_accepted AND X16 AND (D14 < 2) AND (D8 = D12))) THEN
                        wanted_src := 3;
                        deck_step := 10;
                    (* Priority 3: Check inbound feeder if ready *)
                    ELSIF X10 AND (D4 <> 0) THEN
                        (* Can we use it directly, or store it? *)
                        IF (a_accepted AND X15 AND (D13 < 2) AND (D4 = D11)) OR
                           (b_accepted AND X16 AND (D14 < 2) AND (D4 = D12)) OR
                           (D6 = 0) OR (D8 = 0) THEN
                            wanted_src := 1;
                            deck_step := 10;
                        END_IF;
                    END_IF;
                END_IF;
            END_IF;

        10: (* Move to source *)
            IF D0 = wanted_src THEN
                deck_step := 20;
            ELSE
                D200 := wanted_src;
                dock_req := TRUE;
                deck_step := 11;
            END_IF;

        11: (* Wait arrival at source *)
            IF (D0 = wanted_src) AND NOT X11 THEN
                deck_step := 20;
            END_IF;

        20: (* Load from source *)
            IF NOT X11 THEN
                load_req := TRUE;
                deck_step := 21;
            END_IF;

        21: (* Wait until fully on deck *)
            IF X12 AND NOT X11 THEN
                deck_step := 0; (* Go to decision to route the loaded part *)
            END_IF;

        30: (* Move to destination *)
            IF D0 = wanted_dest THEN
                deck_step := 40;
            ELSE
                D200 := wanted_dest;
                dock_req := TRUE;
                deck_step := 31;
            END_IF;

        31: (* Wait arrival at destination *)
            IF (D0 = wanted_dest) AND NOT X11 THEN
                deck_step := 40;
            END_IF;

        40: (* Unload to destination *)
            IF NOT X11 THEN
                IF (wanted_dest = 4) OR (wanted_dest = 5) THEN
                    D201 := dest_gen;
                END_IF;
                unload_req := TRUE;
                deck_step := 41;
            END_IF;

        41: (* Wait until unloaded *)
            IF (D2 = 0) AND NOT X11 THEN
                deck_step := 0;
            END_IF;
    END_CASE;
END_IF;

(* Box handling sequence *)
IF X0 THEN
    CASE box_step OF
        0: (* Need box *)
            IF (boxes_dispatched < 2) AND X1E THEN
                feed_cmd := TRUE;
                box_step := 1;
            END_IF;

        1: (* Wait box at station *)
            IF X1F THEN
                feed_cmd := FALSE;
                clamp_cmd := TRUE;
                box_step := 2;
            END_IF;

        2: (* Clamping box *)
            clamp_timer(IN := TRUE, PT := T#350ms);
            IF clamp_timer.Q AND X20 THEN
                clamp_timer(IN := FALSE, PT := T#350ms);
                curr_box_gen := D16;
                box_step := 3;
            END_IF;

        3: (* Box ready for packing, wait until box is full *)
            IF X24 THEN
                clamp_cmd := FALSE;
                box_step := 4;
            END_IF;

        4: (* Wait clamp fully released and exit clear *)
            IF NOT X20 AND X25 THEN
                dispatch_req := TRUE;
                boxes_dispatched := boxes_dispatched + 1;
                box_step := 5;
            END_IF;

        5: (* Wait exit clear or next *)
            IF boxes_dispatched >= 2 THEN
                box_step := 10; (* Done all boxes *)
            ELSE
                box_step := 0;
            END_IF;

        10: (* All boxes dispatched *)
            ;
    END_CASE;
ELSE
    clamp_timer(IN := FALSE, PT := T#350ms);
END_IF;

(* Packing sequence (pack_a and pack_b) *)
IF X0 AND (box_step = 3) AND NOT X21 THEN
    CASE pack_step OF
        0: (* Select kit to pack *)
            IF X1B AND (D9 = curr_box_gen) AND NOT X22 THEN
                pack_a_req := TRUE;
                pack_step := 1;
            ELSIF X1C AND (D10 = curr_box_gen) AND NOT X23 THEN
                pack_b_req := TRUE;
                pack_step := 2;
            END_IF;

        1: (* Wait A packed *)
            IF X22 THEN
                ack_a_req := TRUE;
                a_accepted := FALSE;
                pack_step := 3;
            END_IF;

        2: (* Wait B packed *)
            IF X23 THEN
                ack_b_req := TRUE;
                b_accepted := FALSE;
                pack_step := 3;
            END_IF;

        3: (* Wait pack head not busy *)
            IF NOT X21 THEN
                pack_step := 0;
            END_IF;
    END_CASE;
ELSE
    IF (box_step <> 3) THEN
        pack_step := 0;
    END_IF;
END_IF;

(* Completion condition *)
complete_timer(
    IN := (boxes_dispatched >= 2) AND X1D AND (D2 = 0) AND NOT X11 AND NOT X21,
    PT := T#500ms
);

IF complete_timer.Q THEN
    Y1B := TRUE;
ELSE
    Y1B := FALSE;
END_IF;

(* Assign outputs *)
Y10 := dock_req;
Y11 := load_req;
Y12 := unload_req;
Y13 := accept_a_req;
Y14 := accept_b_req;
Y15 := close_a_req;
Y16 := close_b_req;
Y17 := release_a_req;
Y18 := release_b_req;
Y19 := ack_a_req;
Y1A := ack_b_req;
Y1C := feed_cmd;
Y1D := clamp_cmd;
Y1E := pack_a_req;
Y1F := pack_b_req;
Y20 := dispatch_req;

END_PROGRAM