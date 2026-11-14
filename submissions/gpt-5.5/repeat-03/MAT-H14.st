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
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT;
    D204 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    (* Add internal variables here. *)
    started : BOOL;
    seq_init : BOOL;
    pre_state : INT;
    post_state : INT;
    pre_next_seq : INT;
    post_next_seq : INT;
    pre_active_seq : INT;
    post_active_seq : INT;
    fed_count : INT;
    handover_count : INT;
    pre_tare : INT;
    pre_tray_id : INT;
    pre_have_tare : BOOL;
    lane1_has_tray : BOOL;
    lane1_tare : INT;
    lane1_id : INT;
    post_tare : INT;
    post_id_saved : INT;
    post_net : INT;
    post_route : INT;
    post_measured : BOOL;
    post_valid_match : BOOL;
    path_hold : BOOL;
    path_block_this_scan : BOOL;
    path_timer : TON;
    completion_condition : BOOL;
    complete_declared : BOOL;
END_VAR

Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
D200 := 0;
D201 := 0;
D204 := 0;

IF X0 AND NOT started THEN
    started := TRUE;
END_IF;

IF started AND NOT seq_init THEN
    IF D4 < 30000 THEN
        pre_next_seq := D4 + 1;
    ELSE
        pre_next_seq := 1;
    END_IF;
    IF D5 < 30000 THEN
        post_next_seq := D5 + 1;
    ELSE
        post_next_seq := 1;
    END_IF;
    seq_init := TRUE;
END_IF;

path_block_this_scan := FALSE;
path_timer(IN := path_hold, PT := T#3000ms);
IF path_timer.Q THEN
    path_hold := FALSE;
    path_block_this_scan := TRUE;
END_IF;

IF started AND NOT complete_declared THEN
    IF pre_state = 0 THEN
        IF (fed_count < 4) AND X10 AND (NOT X11) AND X1F AND (NOT X12) AND (NOT X15) AND (NOT path_hold) AND (NOT path_block_this_scan) THEN
            Y10 := TRUE;
            path_hold := TRUE;
            fed_count := fed_count + 1;
            pre_state := 10;
        END_IF;
    ELSIF pre_state = 10 THEN
        IF X11 THEN
            pre_state := 20;
        END_IF;
    ELSIF pre_state = 20 THEN
        IF X11 AND X1E THEN
            pre_state := 30;
        END_IF;
    ELSIF pre_state = 30 THEN
        IF X11 AND X1E AND (NOT X12) AND (NOT X15) THEN
            pre_active_seq := pre_next_seq;
            IF pre_next_seq < 30000 THEN
                pre_next_seq := pre_next_seq + 1;
            ELSE
                pre_next_seq := 1;
            END_IF;
            Y11 := TRUE;
            pre_state := 40;
        END_IF;
    ELSIF pre_state = 40 THEN
        IF (D4 = pre_active_seq) AND (NOT X12) AND (NOT X15) THEN
            pre_tare := D2;
            pre_tray_id := D0;
            pre_have_tare := TRUE;
            pre_state := 50;
        END_IF;
    ELSIF pre_state = 50 THEN
        IF (NOT X12) AND (NOT X15) AND X1F THEN
            pre_state := 60;
        END_IF;
    ELSIF pre_state = 60 THEN
        IF pre_have_tare AND X11 AND X1F AND X17 AND (NOT lane1_has_tray) AND (NOT path_hold) AND (NOT path_block_this_scan) THEN
            D200 := 1;
            Y12 := TRUE;
            path_hold := TRUE;
            lane1_has_tray := TRUE;
            lane1_tare := pre_tare;
            lane1_id := pre_tray_id;
            pre_state := 70;
        END_IF;
    ELSIF pre_state = 70 THEN
        IF NOT X11 THEN
            pre_have_tare := FALSE;
            pre_state := 0;
        END_IF;
    END_IF;

    IF post_state = 0 THEN
        IF lane1_has_tray AND X18 AND (NOT X13) AND X21 AND (NOT X14) AND (NOT X16) AND (NOT path_hold) AND (NOT path_block_this_scan) THEN
            D201 := 1;
            Y13 := TRUE;
            path_hold := TRUE;
            post_tare := lane1_tare;
            post_id_saved := lane1_id;
            post_measured := FALSE;
            post_valid_match := FALSE;
            post_route := 0;
            post_state := 10;
        END_IF;
    ELSIF post_state = 10 THEN
        IF X13 THEN
            lane1_has_tray := FALSE;
            post_state := 20;
        END_IF;
    ELSIF post_state = 20 THEN
        IF X13 AND X20 THEN
            post_state := 30;
        END_IF;
    ELSIF post_state = 30 THEN
        IF X13 AND X20 AND (NOT X14) AND (NOT X16) THEN
            post_active_seq := post_next_seq;
            IF post_next_seq < 30000 THEN
                post_next_seq := post_next_seq + 1;
            ELSE
                post_next_seq := 1;
            END_IF;
            Y14 := TRUE;
            post_state := 40;
        END_IF;
    ELSIF post_state = 40 THEN
        IF (D5 = post_active_seq) AND (NOT X14) AND (NOT X16) THEN
            post_net := D3 - post_tare;
            IF (post_net >= 95) AND (post_net <= 105) THEN
                post_route := 1;
            ELSE
                post_route := 2;
            END_IF;
            post_measured := TRUE;
            IF D1 = post_id_saved THEN
                post_valid_match := TRUE;
            ELSE
                post_valid_match := FALSE;
            END_IF;
            post_state := 50;
        END_IF;
    ELSIF post_state = 50 THEN
        IF (NOT X14) AND (NOT X16) AND X21 THEN
            post_state := 60;
        END_IF;
    ELSIF post_state = 60 THEN
        D204 := post_route;
        IF X13 AND X21 AND post_measured AND post_valid_match AND (NOT X14) AND (NOT X16) AND (NOT path_hold) AND (NOT path_block_this_scan) THEN
            IF ((post_route = 1) AND X1B) OR ((post_route = 2) AND X1C) THEN
                D204 := post_route;
                Y15 := TRUE;
                path_hold := TRUE;
                post_state := 70;
            END_IF;
        END_IF;
    ELSIF post_state = 70 THEN
        D204 := post_route;
        IF NOT X13 THEN
            handover_count := handover_count + 1;
            post_measured := FALSE;
            post_valid_match := FALSE;
            post_route := 0;
            post_state := 0;
        END_IF;
    END_IF;
END_IF;

Y17 := FALSE;
IF (pre_state = 20) OR (pre_state = 30) OR (pre_state = 40) OR (X15 AND X11) OR (X12 AND X11 AND NOT X1F) THEN
    Y17 := TRUE;
END_IF;

Y18 := FALSE;
IF (post_state = 20) OR (post_state = 30) OR (post_state = 40) OR (X16 AND X13) OR (X14 AND X13 AND NOT X21) THEN
    Y18 := TRUE;
END_IF;

IF post_state = 60 THEN
    D204 := post_route;
END_IF;
IF post_state = 70 THEN
    D204 := post_route;
END_IF;

D202 := pre_active_seq;
D203 := post_active_seq;

completion_condition := (handover_count >= 4) AND (X1D OR (D6 >= 4)) AND (pre_state = 0) AND (post_state = 0) AND (NOT lane1_has_tray) AND (NOT X11) AND (NOT X13) AND X17 AND X19 AND (NOT path_hold) AND (NOT path_block_this_scan);

IF completion_condition THEN
    complete_declared := TRUE;
END_IF;

Y16 := complete_declared;

END_PROGRAM