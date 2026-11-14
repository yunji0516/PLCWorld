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
    started : BOOL;
    complete_latched : BOOL;
    pre_state : INT;
    post_state : INT;
    rec_id : ARRAY[1..4] OF INT;
    rec_tare : ARRAY[1..4] OF INT;
    rec_status : ARRAY[1..4] OF INT;
    feed_count : INT;
    done_count : INT;
    pre_current_slot : INT;
    post_current_slot : INT;
    pre_transfer_lane : INT;
    post_transfer_lane : INT;
    next_seq : INT := 100;
    pre_req_seq : INT;
    post_req_seq : INT;
    post_route : INT;
    post_measured : BOOL;
    transfer_active : BOOL;
    transferTimer : TON;
    i : INT;
    free_slot : INT;
    selected_slot : INT;
    selected_lane : INT;
    found_slot : INT;
    net_value : INT;
    completion_condition : BOOL;
END_VAR

transferTimer(IN := transfer_active, PT := T#2000ms);

Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y17 := FALSE;
Y18 := FALSE;

IF X0 THEN
    started := TRUE;
END_IF;

IF started AND NOT complete_latched THEN

    CASE post_state OF
        0:
            IF (NOT transfer_active) AND (NOT X13) AND X21 AND (NOT X14) AND (NOT X16) THEN
                selected_slot := 0;
                selected_lane := 0;

                IF X18 THEN
                    FOR i := 1 TO 4 DO
                        IF (selected_slot = 0) AND (rec_status[i] = 2) THEN
                            selected_slot := i;
                            selected_lane := 1;
                        END_IF;
                    END_FOR;
                END_IF;

                IF (selected_slot = 0) AND X1A THEN
                    FOR i := 1 TO 4 DO
                        IF (selected_slot = 0) AND (rec_status[i] = 3) THEN
                            selected_slot := i;
                            selected_lane := 2;
                        END_IF;
                    END_FOR;
                END_IF;

                IF selected_slot <> 0 THEN
                    D201 := selected_lane;
                    Y13 := TRUE;
                    post_current_slot := selected_slot;
                    post_transfer_lane := selected_lane;
                    rec_status[selected_slot] := 4;
                    post_measured := FALSE;
                    transfer_active := TRUE;
                    post_state := 10;
                END_IF;
            END_IF;

        10:
            Y18 := FALSE;
            IF transferTimer.Q AND X13 THEN
                IF ((post_transfer_lane = 1) AND X17) OR ((post_transfer_lane = 2) AND X19) THEN
                    transfer_active := FALSE;
                    post_state := 20;
                END_IF;
            END_IF;

        20:
            Y18 := TRUE;
            IF X20 AND (NOT X14) AND (NOT X16) THEN
                next_seq := next_seq + 1;
                post_req_seq := next_seq;
                D203 := post_req_seq;
                Y14 := TRUE;
                post_state := 30;
            END_IF;

        30:
            Y18 := TRUE;
            IF (D5 = post_req_seq) AND (NOT X16) THEN
                found_slot := 0;
                FOR i := 1 TO 4 DO
                    IF (found_slot = 0) AND (rec_status[i] = 4) AND (rec_id[i] = D1) THEN
                        found_slot := i;
                    END_IF;
                END_FOR;

                IF found_slot <> 0 THEN
                    post_current_slot := found_slot;
                END_IF;

                IF (post_current_slot >= 1) AND (post_current_slot <= 4) AND (rec_status[post_current_slot] = 4) THEN
                    net_value := D3 - rec_tare[post_current_slot];
                    IF (net_value >= 95) AND (net_value <= 105) THEN
                        post_route := 1;
                    ELSE
                        post_route := 2;
                    END_IF;
                    D204 := post_route;
                    post_measured := TRUE;
                    post_state := 40;
                END_IF;
            END_IF;

        40:
            IF X16 THEN
                Y18 := TRUE;
            ELSE
                Y18 := FALSE;
            END_IF;

            IF (NOT X16) AND X21 THEN
                post_state := 50;
            END_IF;

        50:
            Y18 := FALSE;
            D204 := post_route;
            IF post_measured AND (NOT transfer_active) AND X21 AND (NOT X16) THEN
                IF ((post_route = 1) AND X1B) OR ((post_route = 2) AND X1C) THEN
                    Y15 := TRUE;
                    transfer_active := TRUE;
                    post_state := 60;
                END_IF;
            END_IF;

        60:
            Y18 := FALSE;
            D204 := post_route;
            IF transferTimer.Q AND (NOT X13) THEN
                transfer_active := FALSE;
                IF (post_current_slot >= 1) AND (post_current_slot <= 4) THEN
                    IF rec_status[post_current_slot] <> 6 THEN
                        rec_status[post_current_slot] := 6;
                        done_count := done_count + 1;
                    END_IF;
                END_IF;
                post_current_slot := 0;
                post_transfer_lane := 0;
                post_measured := FALSE;
                post_state := 0;
            END_IF;

        ELSE
            post_state := 0;
    END_CASE;


    CASE pre_state OF
        0:
            IF (feed_count < 4) AND X10 AND (NOT X11) AND X1F AND (NOT transfer_active) THEN
                free_slot := 0;
                FOR i := 1 TO 4 DO
                    IF (free_slot = 0) AND (rec_status[i] = 0) THEN
                        free_slot := i;
                    END_IF;
                END_FOR;

                IF free_slot <> 0 THEN
                    Y10 := TRUE;
                    pre_current_slot := free_slot;
                    rec_status[free_slot] := 10;
                    feed_count := feed_count + 1;
                    transfer_active := TRUE;
                    pre_state := 10;
                END_IF;
            END_IF;

        10:
            Y17 := FALSE;
            IF transferTimer.Q AND X11 THEN
                transfer_active := FALSE;
                pre_state := 20;
            END_IF;

        20:
            Y17 := TRUE;
            IF X1E AND (NOT X12) AND (NOT X15) THEN
                next_seq := next_seq + 1;
                pre_req_seq := next_seq;
                D202 := pre_req_seq;
                Y11 := TRUE;
                pre_state := 30;
            END_IF;

        30:
            Y17 := TRUE;
            IF (D4 = pre_req_seq) AND (NOT X15) THEN
                IF (pre_current_slot >= 1) AND (pre_current_slot <= 4) THEN
                    rec_id[pre_current_slot] := D0;
                    rec_tare[pre_current_slot] := D2;
                    rec_status[pre_current_slot] := 1;
                    pre_state := 40;
                END_IF;
            END_IF;

        40:
            IF X15 THEN
                Y17 := TRUE;
            ELSE
                Y17 := FALSE;
            END_IF;

            IF (NOT X15) AND X1F THEN
                pre_state := 50;
            END_IF;

        50:
            Y17 := FALSE;
            IF (pre_current_slot >= 1) AND (pre_current_slot <= 4) THEN
                IF (rec_status[pre_current_slot] = 1) AND X1F AND (NOT X15) AND (NOT transfer_active) THEN
                    IF X17 THEN
                        D200 := 1;
                        Y12 := TRUE;
                        rec_status[pre_current_slot] := 2;
                        pre_transfer_lane := 1;
                        transfer_active := TRUE;
                        pre_state := 60;
                    ELSIF X19 THEN
                        D200 := 2;
                        Y12 := TRUE;
                        rec_status[pre_current_slot] := 3;
                        pre_transfer_lane := 2;
                        transfer_active := TRUE;
                        pre_state := 60;
                    END_IF;
                END_IF;
            END_IF;

        60:
            Y17 := FALSE;
            IF transferTimer.Q AND (NOT X11) THEN
                IF ((pre_transfer_lane = 1) AND (NOT X17)) OR ((pre_transfer_lane = 2) AND (NOT X19)) THEN
                    transfer_active := FALSE;
                    pre_current_slot := 0;
                    pre_transfer_lane := 0;
                    pre_state := 0;
                END_IF;
            END_IF;

        ELSE
            pre_state := 0;
    END_CASE;

END_IF;

IF X15 THEN
    Y17 := TRUE;
END_IF;

IF X16 THEN
    Y18 := TRUE;
END_IF;

completion_condition := started AND (done_count >= 4) AND (X1D OR (D6 >= 4)) AND (NOT X11) AND (NOT X13) AND X17 AND X19 AND (NOT X15) AND (NOT X16) AND (NOT transfer_active) AND (pre_state = 0) AND (post_state = 0);

IF completion_condition THEN
    complete_latched := TRUE;
END_IF;

Y16 := complete_latched;

END_PROGRAM