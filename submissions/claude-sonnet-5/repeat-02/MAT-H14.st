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

    (* Internal state machines *)
    inb_state   : INT := 0;
    out_state   : INT := 0;

    trays_fed       : INT := 0;
    trays_completed : INT := 0;

    chosen_lane : INT := 0;
    lane1_occupied : BOOL := FALSE;
    lane2_occupied : BOOL := FALSE;
    lane1_tare : INT := 0;
    lane2_tare : INT := 0;

    pre_tare_captured : INT := 0;
    seq_pre_counter : INT := 0;
    req_seq_pre : INT := 0;

    seq_post_counter : INT := 0;
    req_seq_post : INT := 0;
    post_finished_mass : INT := 0;

    transfer_busy : BOOL := FALSE;

    out_lane_sel : INT := 0;
    current_tare : INT := 0;
    net_mass : INT := 0;
    route_calc : INT := 0;

    feed_on : BOOL := FALSE;
    pre_lift_on : BOOL := FALSE;
    post_lift_on : BOOL := FALSE;

    completed_latch : BOOL := FALSE;
    completed_condition : BOOL := FALSE;
END_VAR

(* default pulse outputs off each scan; level outputs computed below *)
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;

(* ============================= INBOUND STATE MACHINE ============================= *)
CASE inb_state OF

0: (* WAIT_FEED *)
    feed_on := FALSE;
    IF (trays_fed < 4) AND X0 AND X10 AND (NOT X11) AND X1F THEN
        inb_state := 1;
    END_IF;

1: (* FEED_ON - wait for pre_present *)
    feed_on := TRUE;
    IF X11 THEN
        feed_on := FALSE;
        inb_state := 2;
    END_IF;

2: (* LIFT_PRE - wait for pre_supported *)
    pre_lift_on := TRUE;
    IF X1E THEN
        inb_state := 3;
    END_IF;

3: (* REQ_PRE_MEAS pulse *)
    pre_lift_on := TRUE;
    IF NOT X12 THEN
        seq_pre_counter := seq_pre_counter + 1;
        req_seq_pre := seq_pre_counter;
        D202 := req_seq_pre;
        Y11 := TRUE;
        inb_state := 4;
    END_IF;

4: (* WAIT_PRE_MEAS *)
    pre_lift_on := TRUE;
    IF (D4 = req_seq_pre) AND (NOT X12) THEN
        pre_tare_captured := D2;
        inb_state := 5;
    END_IF;

5: (* LOWER_PRE - wait for pre_lowered *)
    pre_lift_on := FALSE;
    IF X1F THEN
        inb_state := 6;
    END_IF;

6: (* WAIT_LANE_FREE - choose free lane and start transfer *)
    pre_lift_on := FALSE;
    IF X11 AND (NOT transfer_busy) THEN
        IF X17 AND (NOT lane1_occupied) THEN
            chosen_lane := 1;
            D200 := 1;
            transfer_busy := TRUE;
            inb_state := 7;
        ELSIF X19 AND (NOT lane2_occupied) THEN
            chosen_lane := 2;
            D200 := 2;
            transfer_busy := TRUE;
            inb_state := 7;
        END_IF;
    END_IF;

7: (* TO_LANE_PULSE *)
    Y12 := TRUE;
    inb_state := 8;

8: (* WAIT_LANE_ACCEPT - wait for pre_present to clear *)
    IF NOT X11 THEN
        transfer_busy := FALSE;
        IF chosen_lane = 1 THEN
            lane1_occupied := TRUE;
            lane1_tare := pre_tare_captured;
        ELSIF chosen_lane = 2 THEN
            lane2_occupied := TRUE;
            lane2_tare := pre_tare_captured;
        END_IF;
        trays_fed := trays_fed + 1;
        chosen_lane := 0;
        inb_state := 0;
    END_IF;

ELSE
    inb_state := 0;
END_CASE;

(* ============================= OUTBOUND STATE MACHINE ============================= *)
CASE out_state OF

0: (* WAIT_LANE_DONE *)
    post_lift_on := FALSE;
    IF (NOT X13) AND X21 AND (NOT transfer_busy) THEN
        IF lane1_occupied AND X18 THEN
            out_lane_sel := 1;
            D201 := 1;
            transfer_busy := TRUE;
            out_state := 1;
        ELSIF lane2_occupied AND X1A THEN
            out_lane_sel := 2;
            D201 := 2;
            transfer_busy := TRUE;
            out_state := 1;
        END_IF;
    END_IF;

1: (* LOAD_POST_PULSE *)
    Y13 := TRUE;
    out_state := 2;

2: (* WAIT_POST_PRESENT *)
    IF X13 THEN
        transfer_busy := FALSE;
        IF out_lane_sel = 1 THEN
            current_tare := lane1_tare;
            lane1_occupied := FALSE;
        ELSIF out_lane_sel = 2 THEN
            current_tare := lane2_tare;
            lane2_occupied := FALSE;
        END_IF;
        out_state := 3;
    END_IF;

3: (* LIFT_POST *)
    post_lift_on := TRUE;
    IF X20 THEN
        out_state := 4;
    END_IF;

4: (* REQ_POST_MEAS pulse *)
    post_lift_on := TRUE;
    IF NOT X14 THEN
        seq_post_counter := seq_post_counter + 1;
        req_seq_post := seq_post_counter;
        D203 := req_seq_post;
        Y14 := TRUE;
        out_state := 5;
    END_IF;

5: (* WAIT_POST_MEAS *)
    post_lift_on := TRUE;
    IF (D5 = req_seq_post) AND (NOT X14) THEN
        post_finished_mass := D3;
        out_state := 6;
    END_IF;

6: (* LOWER_POST *)
    post_lift_on := FALSE;
    IF X21 THEN
        out_state := 7;
    END_IF;

7: (* COMPUTE_ROUTE *)
    net_mass := post_finished_mass - current_tare;
    IF (net_mass >= 95) AND (net_mass <= 105) THEN
        route_calc := 1;
    ELSE
        route_calc := 2;
    END_IF;
    D204 := route_calc;
    out_state := 8;

8: (* WAIT_EXIT_FREE *)
    IF (route_calc = 1) AND X1B THEN
        out_state := 9;
    ELSIF (route_calc = 2) AND X1C THEN
        out_state := 9;
    END_IF;

9: (* DISPATCH_PULSE *)
    Y15 := TRUE;
    out_state := 10;

10: (* WAIT_DEPART *)
    IF NOT X13 THEN
        trays_completed := trays_completed + 1;
        out_lane_sel := 0;
        out_state := 0;
    END_IF;

ELSE
    out_state := 0;
END_CASE;

(* ============================= LEVEL OUTPUTS ============================= *)
Y10 := feed_on;
Y17 := pre_lift_on;
Y18 := post_lift_on;

(* ============================= COMPLETION LOGIC ============================= *)
completed_condition := (trays_fed = 4) AND (trays_completed = 4) AND
                        (NOT X11) AND (NOT X13) AND
                        (NOT lane1_occupied) AND (NOT lane2_occupied) AND
                        (NOT transfer_busy) AND
                        (inb_state = 0) AND (out_state = 0);

IF completed_condition THEN
    completed_latch := TRUE;
END_IF;

Y16 := completed_latch OR completed_condition;

END_PROGRAM