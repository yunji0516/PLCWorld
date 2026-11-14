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
    
    tare_table : ARRAY[0..100] OF INT;
    tare_valid : ARRAY[0..100] OF BOOL;
    
    lane_tray_id : ARRAY[1..2] OF INT;
    lane_occupied : ARRAY[1..2] OF BOOL;
    
    pre_step : INT;
    post_step : INT;
    
    pre_req_seq : INT;
    post_req_seq : INT;
    
    pre_cur_id : INT;
    post_cur_id : INT;
    
    chosen_lane : INT;
    chosen_out_lane : INT;
    net_mass : INT;
    
    t_feed : TON;
    t_tolane : TON;
    t_loadpost : TON;
    t_dispatch : TON;
    
    done_all : BOOL;
    t_complete : TON;
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
    D200 := 0;
    D201 := 0;
    D202 := 0;
    D203 := 0;
    D204 := 0;
    RETURN;
END_IF;

(* Track lane occupancy based on physical feedback *)
IF NOT X17 THEN
    lane_occupied[1] := TRUE;
ELSIF X17 AND NOT X18 AND lane_step_idle_1 THEN
    (* Lane 1 empty *)
END_IF;

(* ------------------------------------------------------------- *)
(* INBOUND SCALE & FEEDER CONTROL (pre_step)                     *)
(* ------------------------------------------------------------- *)
CASE pre_step OF
    0: (* Idle at inbound, ready to feed if source ready and scale empty/lowered *)
        Y10 := FALSE;
        Y11 := FALSE;
        Y12 := FALSE;
        Y17 := FALSE;
        IF fed_count < 4 AND X10 AND (NOT X11) AND X1F AND (NOT X15) AND (NOT X12) THEN
            Y10 := TRUE;
            pre_step := 1;
        END_IF;

    1: (* Feeding tray onto pre scale *)
        Y10 := TRUE;
        IF X11 THEN
            Y10 := FALSE;
            pre_step := 2;
        END_IF;

    2: (* Tray arrived on pre scale, verify stationary and raise lift *)
        Y10 := FALSE;
        Y17 := TRUE;
        IF X1E THEN
            pre_cur_id := D0;
            pre_step := 3;
        END_IF;

    3: (* Request pre measurement *)
        Y17 := TRUE;
        IF (NOT X12) AND (NOT X15) THEN
            pre_req_seq := pre_req_seq + 1;
            IF pre_req_seq > 30000 THEN
                pre_req_seq := 1;
            END_IF;
            D202 := pre_req_seq;
            Y11 := TRUE;
            pre_step := 4;
        END_IF;

    4: (* Await measurement completion *)
        Y17 := TRUE;
        IF D4 = pre_req_seq AND (NOT X15) THEN
            Y11 := FALSE;
            IF pre_cur_id >= 0 AND pre_cur_id <= 100 THEN
                tare_table[pre_cur_id] := D2;
                tare_valid[pre_cur_id] := TRUE;
            END_IF;
            pre_step := 5;
        END_IF;

    5: (* Lower pre lift *)
        Y11 := FALSE;
        Y17 := FALSE;
        IF X1F THEN
            pre_step := 6;
        END_IF;

    6: (* Select available lane and transfer *)
        Y17 := FALSE;
        chosen_lane := 0;
        IF X17 AND (NOT lane_occupied[1]) THEN
            chosen_lane := 1;
        ELSIF X19 AND (NOT lane_occupied[2]) THEN
            chosen_lane := 2;
        END_IF;

        IF chosen_lane > 0 AND X1F AND (NOT X15) THEN
            D200 := chosen_lane;
            Y12 := TRUE;
            lane_occupied[chosen_lane] := TRUE;
            lane_tray_id[chosen_lane] := pre_cur_id;
            fed_count := fed_count + 1;
            pre_step := 7;
        END_IF;

    7: (* Transferring to lane, wait until pre scale clears *)
        Y12 := TRUE;
        IF NOT X11 THEN
            Y12 := FALSE;
            pre_step := 0;
        END_IF;
END_CASE;

(* ------------------------------------------------------------- *)
(* OUTBOUND / POST SCALE & DISPATCH CONTROL (post_step)          *)
(* ------------------------------------------------------------- *)
CASE post_step OF
    0: (* Post scale empty and lowered, check if any lane is done *)
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y18 := FALSE;
        chosen_out_lane := 0;
        IF (NOT X13) AND X21 AND (NOT X16) AND (NOT X14) THEN
            IF X18 AND lane_occupied[1] THEN
                chosen_out_lane := 1;
            ELSIF X1A AND lane_occupied[2] THEN
                chosen_out_lane := 2;
            END_IF;

            IF chosen_out_lane > 0 THEN
                D201 := chosen_out_lane;
                Y13 := TRUE;
                post_cur_id := lane_tray_id[chosen_out_lane];
                post_step := 1;
            END_IF;
        END_IF;

    1: (* Transferring from lane to post scale *)
        Y13 := TRUE;
        IF chosen_out_lane = 1 AND X17 THEN
            lane_occupied[1] := FALSE;
        ELSIF chosen_out_lane = 2 AND X19 THEN
            lane_occupied[2] := FALSE;
        END_IF;
        IF X13 THEN
            Y13 := FALSE;
            post_step := 2;
        END_IF;

    2: (* Tray arrived on post scale, raise lift *)
        Y13 := FALSE;
        Y18 := TRUE;
        IF X20 THEN
            post_cur_id := D1;
            post_step := 3;
        END_IF;

    3: (* Request post measurement *)
        Y18 := TRUE;
        IF (NOT X14) AND (NOT X16) THEN
            post_req_seq := post_req_seq + 1;
            IF post_req_seq > 30000 THEN
                post_req_seq := 1;
            END_IF;
            D203 := post_req_seq;
            Y14 := TRUE;
            post_step := 4;
        END_IF;

    4: (* Await post measurement completion *)
        Y18 := TRUE;
        IF D5 = post_req_seq AND (NOT X16) THEN
            Y14 := FALSE;
            net_mass := D3 - tare_table[post_cur_id];
            IF net_mass >= 95 AND net_mass <= 105 THEN
                D204 := 1; (* Accept *)
            ELSE
                D204 := 2; (* Hold *)
            END_IF;
            post_step := 5;
        END_IF;

    5: (* Lower post lift *)
        Y14 := FALSE;
        Y18 := FALSE;
        IF X21 THEN
            post_step := 6;
        END_IF;

    6: (* Wait for corresponding exit to be clear before dispatch *)
        Y18 := FALSE;
        IF X21 AND (NOT X16) THEN
            IF (D204 = 1 AND X1B) OR (D204 = 2 AND X1C) THEN
                Y15 := TRUE;
                post_step := 7;
            END_IF;
        END_IF;

    7: (* Dispatching tray to exit accumulation *)
        Y15 := TRUE;
        IF NOT X13 THEN
            Y15 := FALSE;
            post_step := 0;
        END_IF;
END_CASE;

(* Pulse timers / safety timeout if needed *)
t_feed(IN := Y10, PT := T#5s);
t_tolane(IN := Y12, PT := T#5s);
t_loadpost(IN := Y13, PT := T#5s);
t_dispatch(IN := Y15, PT := T#5s);

(* ------------------------------------------------------------- *)
(* COMPLETION MONITORING                                         *)
(* ------------------------------------------------------------- *)
IF (D6 >= 4 OR X1D) AND (NOT X11) AND (NOT X13) AND X17 AND X19 AND (NOT lane_occupied[1]) AND (NOT lane_occupied[2]) AND pre_step = 0 AND post_step = 0 THEN
    done_all := TRUE;
END_IF;

t_complete(IN := done_all, PT := T#500ms);
IF t_complete.Q OR Y16 THEN
    Y16 := TRUE;
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
END_IF;

END_PROGRAM