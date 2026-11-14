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
    fed_count : INT;
    tare_table : ARRAY[0..15] OF INT;

    pre_state : INT;
    post_state : INT;
    transfer_in_busy : BOOL;
    transfer_out_busy : BOOL;

    lane1_occupied : BOOL;
    lane2_occupied : BOOL;
    lane1_ready : BOOL;
    lane2_ready : BOOL;

    lane_prio : INT;
    selected_out_lane : INT;

    feed_pulse : BOOL;
    to_lane_pulse : BOOL;
    load_post_pulse : BOOL;
    dispatch_pulse : BOOL;
    measure_pre_pulse : BOOL;
    measure_post_pulse : BOOL;

    post_route : INT;
    all_done : BOOL;
    complete_latched : BOOL;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    RETURN;
END_IF;

(* Clear pulse outputs at scan start *)
feed_pulse := FALSE;
to_lane_pulse := FALSE;
load_post_pulse := FALSE;
dispatch_pulse := FALSE;
measure_pre_pulse := FALSE;
measure_post_pulse := FALSE;

(* Workstation status updates *)
IF X18 AND lane1_occupied THEN
    lane1_ready := TRUE;
END_IF;
IF X1A AND lane2_occupied THEN
    lane2_ready := TRUE;
END_IF;

(* Inbound scale state machine *)
CASE pre_state OF
    0: (* Wait to feed tray from source to inbound scale *)
        Y17 := FALSE;
        IF X10 AND (fed_count < 4) AND (NOT X11) AND (NOT X12) AND X1F AND (NOT transfer_in_busy) THEN
            feed_pulse := TRUE;
            fed_count := fed_count + 1;
            pre_state := 1;
        ELSIF X11 AND X1F AND (NOT X12) THEN
            pre_state := 2;
        END_IF;

    1: (* Wait for tray to arrive on inbound scale *)
        IF X11 AND (NOT X12) THEN
            pre_state := 2;
        END_IF;

    2: (* Lift scale support *)
        Y17 := TRUE;
        IF X1E AND (NOT X12) AND (NOT X15) THEN
            D202 := D202 + 1;
            measure_pre_pulse := TRUE;
            pre_state := 3;
        END_IF;

    3: (* Await inbound measurement response *)
        Y17 := TRUE;
        IF (D4 = D202) AND (NOT X15) AND (NOT X12) THEN
            IF (D0 >= 0) AND (D0 <= 15) THEN
                tare_table[D0] := D2;
            END_IF;
            pre_state := 4;
        END_IF;

    4: (* Lower support *)
        Y17 := FALSE;
        IF X1F AND (NOT X12) THEN
            pre_state := 5;
        END_IF;

    5: (* Route to empty workstation lane *)
        Y17 := FALSE;
        IF (NOT transfer_in_busy) THEN
            IF X17 AND (NOT lane1_occupied) THEN
                D200 := 1;
                to_lane_pulse := TRUE;
                lane1_occupied := TRUE;
                lane1_ready := FALSE;
                transfer_in_busy := TRUE;
                pre_state := 6;
            ELSIF X19 AND (NOT lane2_occupied) THEN
                D200 := 2;
                to_lane_pulse := TRUE;
                lane2_occupied := TRUE;
                lane2_ready := FALSE;
                transfer_in_busy := TRUE;
                pre_state := 6;
            END_IF;
        END_IF;

    6: (* Wait for inbound transfer completion *)
        Y17 := FALSE;
        IF (NOT X11) AND (NOT X12) THEN
            transfer_in_busy := FALSE;
            pre_state := 0;
        END_IF;
END_CASE;

(* Finished scale state machine *)
CASE post_state OF
    0: (* Finished scale is empty, wait for finished kit from workstation *)
        Y18 := FALSE;
        IF (NOT X13) AND (NOT X14) AND X21 AND (NOT transfer_out_busy) THEN
            selected_out_lane := 0;
            IF lane1_ready AND lane2_ready THEN
                IF lane_prio = 2 THEN
                    selected_out_lane := 2;
                ELSE
                    selected_out_lane := 1;
                END_IF;
            ELSIF lane1_ready THEN
                selected_out_lane := 1;
            ELSIF lane2_ready THEN
                selected_out_lane := 2;
            END_IF;

            IF selected_out_lane = 1 THEN
                D201 := 1;
                load_post_pulse := TRUE;
                lane1_occupied := FALSE;
                lane1_ready := FALSE;
                lane_prio := 2;
                transfer_out_busy := TRUE;
                post_state := 1;
            ELSIF selected_out_lane = 2 THEN
                D201 := 2;
                load_post_pulse := TRUE;
                lane2_occupied := FALSE;
                lane2_ready := FALSE;
                lane_prio := 1;
                transfer_out_busy := TRUE;
                post_state := 1;
            END_IF;
        ELSIF X13 AND X21 AND (NOT X14) THEN
            post_state := 2;
        END_IF;

    1: (* Wait for tray to arrive at finished scale *)
        IF X13 AND (NOT X14) THEN
            transfer_out_busy := FALSE;
            post_state := 2;
        END_IF;

    2: (* Lift finished scale support *)
        Y18 := TRUE;
        IF X20 AND (NOT X14) AND (NOT X16) THEN
            D203 := D203 + 1;
            measure_post_pulse := TRUE;
            post_state := 3;
        END_IF;

    3: (* Await finished measurement response *)
        Y18 := TRUE;
        IF (D5 = D203) AND (NOT X16) AND (NOT X14) THEN
            IF (D1 >= 0) AND (D1 <= 15) THEN
                IF ((D3 - tare_table[D1]) >= 95) AND ((D3 - tare_table[D1]) <= 105) THEN
                    post_route := 1;
                ELSE
                    post_route := 2;
                END_IF;
            ELSE
                post_route := 2;
            END_IF;
            D204 := post_route;
            post_state := 4;
        END_IF;

    4: (* Lower finished scale support *)
        Y18 := FALSE;
        IF X21 AND (NOT X14) THEN
            post_state := 5;
        END_IF;

    5: (* Dispatch to corresponding exit *)
        Y18 := FALSE;
        D204 := post_route;
        IF (post_route = 1 AND X1B) OR (post_route = 2 AND X1C) THEN
            dispatch_pulse := TRUE;
            post_state := 6;
        END_IF;

    6: (* Wait for tray to clear finished scale *)
        Y18 := FALSE;
        IF (NOT X13) AND (NOT X14) THEN
            post_state := 0;
        END_IF;
END_CASE;

(* Assign actuator outputs *)
Y10 := feed_pulse;
Y11 := measure_pre_pulse;
Y12 := to_lane_pulse;
Y13 := load_post_pulse;
Y14 := measure_post_pulse;
Y15 := dispatch_pulse;

(* Completion check *)
all_done := X1D AND (D6 >= 4) AND (pre_state = 0) AND (post_state = 0)
    AND (NOT X11) AND (NOT X13) AND (NOT X12) AND (NOT X14)
    AND (NOT lane1_occupied) AND (NOT lane2_occupied)
    AND (NOT transfer_in_busy) AND (NOT transfer_out_busy)
    AND X1F AND X21
    AND (NOT feed_pulse) AND (NOT to_lane_pulse) AND (NOT load_post_pulse) AND (NOT dispatch_pulse);

IF all_done THEN
    complete_latched := TRUE;
END_IF;

Y16 := complete_latched;

END_PROGRAM