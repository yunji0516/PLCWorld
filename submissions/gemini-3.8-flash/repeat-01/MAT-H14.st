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

    started : BOOL := FALSE;
    complete_latched : BOOL := FALSE;

    fed_count : INT := 0;
    dispatched_count : INT := 0;

    pre_state : INT := 0;
    pre_seq_req : INT := 0;

    post_state : INT := 0;
    post_seq_req : INT := 0;

    lane1_occupied : BOOL := FALSE;
    lane2_occupied : BOOL := FALSE;

    target_lane : INT := 0;
    chosen_out_lane : INT := 0;
    target_route : INT := 0;

    tare_count : INT := 0;
    tray_saved_id : ARRAY[1..10] OF INT;
    tray_saved_tare : ARRAY[1..10] OF INT;

    i : INT := 0;
    matched_tare : INT := 0;
    net_mass : INT := 0;

    lane1_avail : BOOL := FALSE;
    lane2_avail : BOOL := FALSE;
    exit_clear : BOOL := FALSE;
    shared_busy : BOOL := FALSE;

    ton_pre_lift : TON;
    ton_pre_lower : TON;
    ton_post_lift : TON;
    ton_post_lower : TON;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF complete_latched THEN
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := TRUE;
    Y17 := FALSE;
    Y18 := FALSE;
    RETURN;
END_IF;

Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;

ton_pre_lift(IN := (pre_state = 3 AND X1E), PT := T#50ms);
ton_pre_lower(IN := (pre_state = 6 AND X1F), PT := T#50ms);
ton_post_lift(IN := (post_state = 2 AND X20), PT := T#50ms);
ton_post_lower(IN := (post_state = 5 AND X21), PT := T#50ms);

shared_busy := X12 OR X14 OR (pre_state = 1) OR (pre_state = 8) OR (post_state = 1) OR (post_state = 7);

CASE post_state OF
    0:
        IF NOT X13 AND NOT X14 AND X21 AND NOT Y18 AND NOT shared_busy THEN
            IF lane1_occupied AND X18 THEN
                chosen_out_lane := 1;
                D201 := 1;
                Y13 := TRUE;
                post_state := 1;
            ELSIF lane2_occupied AND X1A THEN
                chosen_out_lane := 2;
                D201 := 2;
                Y13 := TRUE;
                post_state := 1;
            END_IF;
        END_IF;

    1:
        IF X13 AND NOT X14 THEN
            IF chosen_out_lane = 1 THEN
                lane1_occupied := FALSE;
            ELSE
                lane2_occupied := FALSE;
            END_IF;
            post_state := 2;
        END_IF;

    2:
        IF ton_post_lift.Q THEN
            post_state := 3;
        END_IF;

    3:
        IF NOT X16 THEN
            post_seq_req := post_seq_req + 1;
            D203 := post_seq_req;
            Y14 := TRUE;
            post_state := 4;
        END_IF;

    4:
        IF (D5 = post_seq_req) AND NOT X16 THEN
            matched_tare := 0;
            FOR i := 1 TO tare_count DO
                IF tray_saved_id[i] = D1 THEN
                    matched_tare := tray_saved_tare[i];
                END_IF;
            END_FOR;
            net_mass := D3 - matched_tare;
            IF (net_mass >= 95) AND (net_mass <= 105) THEN
                target_route := 1;
            ELSE
                target_route := 2;
            END_IF;
            D204 := target_route;
            post_state := 5;
        END_IF;

    5:
        IF ton_post_lower.Q THEN
            post_state := 6;
        END_IF;

    6:
        IF target_route = 1 THEN
            exit_clear := X1B;
        ELSE
            exit_clear := X1C;
        END_IF;

        IF exit_clear AND NOT X12 AND NOT X14 AND (pre_state <> 8) THEN
            D204 := target_route;
            Y15 := TRUE;
            post_state := 7;
        END_IF;

    7:
        IF NOT X13 AND NOT X14 THEN
            dispatched_count := dispatched_count + 1;
            post_state := 0;
        END_IF;
END_CASE;

shared_busy := X12 OR X14 OR (pre_state = 1) OR (pre_state = 8) OR (post_state = 1) OR (post_state = 7);

CASE pre_state OF
    0:
        IF started AND (fed_count < 4) AND X10 AND NOT X11 AND NOT X12 AND X1F AND NOT Y17 AND NOT shared_busy THEN
            pre_state := 1;
            Y10 := TRUE;
        END_IF;

    1:
        IF X11 THEN
            fed_count := fed_count + 1;
            pre_state := 2;
            Y10 := FALSE;
        ELSE
            Y10 := TRUE;
        END_IF;

    2:
        IF NOT X12 THEN
            pre_state := 3;
        END_IF;

    3:
        IF ton_pre_lift.Q THEN
            pre_state := 4;
        END_IF;

    4:
        IF NOT X15 THEN
            pre_seq_req := pre_seq_req + 1;
            D202 := pre_seq_req;
            Y11 := TRUE;
            pre_state := 5;
        END_IF;

    5:
        IF (D4 = pre_seq_req) AND NOT X15 THEN
            IF tare_count < 10 THEN
                tare_count := tare_count + 1;
                tray_saved_id[tare_count] := D0;
                tray_saved_tare[tare_count] := D2;
            END_IF;
            pre_state := 6;
        END_IF;

    6:
        IF ton_pre_lower.Q THEN
            pre_state := 7;
        END_IF;

    7:
        lane1_avail := X17 AND NOT lane1_occupied;
        lane2_avail := X19 AND NOT lane2_occupied;

        IF NOT shared_busy AND NOT (post_state = 0 AND ((lane1_occupied AND X18) OR (lane2_occupied AND X1A)) AND NOT X13) THEN
            IF lane1_avail THEN
                target_lane := 1;
                lane1_occupied := TRUE;
                D200 := 1;
                Y12 := TRUE;
                pre_state := 8;
            ELSIF lane2_avail THEN
                target_lane := 2;
                lane2_occupied := TRUE;
                D200 := 2;
                Y12 := TRUE;
                pre_state := 8;
            END_IF;
        END_IF;

    8:
        IF NOT X11 AND NOT X12 THEN
            pre_state := 0;
        END_IF;
END_CASE;

Y17 := (pre_state = 3) OR (pre_state = 4) OR (pre_state = 5);
Y18 := (post_state = 2) OR (post_state = 3) OR (post_state = 4);

IF (dispatched_count >= 4) AND (X1D OR (D6 >= 4)) AND (pre_state = 0) AND (post_state = 0)
   AND NOT X11 AND NOT X13 AND NOT X12 AND NOT X14 AND NOT lane1_occupied AND NOT lane2_occupied THEN
    complete_latched := TRUE;
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := TRUE;
    Y17 := FALSE;
    Y18 := FALSE;
ELSE
    Y16 := FALSE;
END_IF;

END_PROGRAM