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

    (* Internal state *)
    pre_lift_tmr : TON;
    post_lift_tmr : TON;
    complete_tmr : TON;

    pre_stage : INT := 0;
    pre_req_seq : INT := 0;
    pre_cur_tray : INT := 0;
    pre_cur_tare : INT := 0;
    fed_count : INT := 0;
    sel_lane : INT := 0;

    lane_state : ARRAY[1..2] OF INT;
    lane_tray_id : ARRAY[1..2] OF INT;
    lane_tare : ARRAY[1..2] OF INT;

    post_stage : INT := 0;
    post_req_seq : INT := 0;
    post_active_lane : INT := 0;
    post_active_tray : INT := 0;
    post_active_tare : INT := 0;
    post_finished_mass : INT := 0;
    net_mass : INT := 0;
    completed_count : INT := 0;

    i : INT;
    complete_cond : BOOL := FALSE;
    complete_latched : BOOL := FALSE;
END_VAR

(* ---- reset pulse outputs every scan ---- *)
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;

(* ---- feed control (level output, guarded against pushing onto occupied scale) ---- *)
Y10 := X10 AND NOT X11 AND (fed_count < 4) AND (pre_stage = 0);

(* ---- pre scale lift level output : held through lift + measure phases ---- *)
Y17 := (pre_stage = 1) OR (pre_stage = 2) OR (pre_stage = 3);
pre_lift_tmr(IN := (pre_stage = 1), PT := T#350ms);

(* ---- pre-scale sequence ---- *)
CASE pre_stage OF
0:
    IF X11 THEN
        pre_stage := 1;
    END_IF;

1:
    IF pre_lift_tmr.Q AND X1E THEN
        pre_stage := 2;
    END_IF;

2:
    D202 := D202 + 1;
    pre_req_seq := D202;
    Y11 := TRUE;
    pre_stage := 3;

3:
    IF (D4 = pre_req_seq) AND NOT X15 THEN
        pre_cur_tare := D2;
        pre_cur_tray := D0;
        pre_stage := 4;
    END_IF;

4:
    IF X1F THEN
        pre_stage := 5;
    END_IF;

5:
    IF sel_lane = 0 THEN
        IF X17 AND (lane_state[1] = 0) THEN
            sel_lane := 1;
        ELSIF X19 AND (lane_state[2] = 0) THEN
            sel_lane := 2;
        END_IF;
    END_IF;
    IF sel_lane <> 0 THEN
        D200 := sel_lane;
        Y12 := TRUE;
        lane_state[sel_lane] := 1;
        lane_tray_id[sel_lane] := pre_cur_tray;
        lane_tare[sel_lane] := pre_cur_tare;
        fed_count := fed_count + 1;
        sel_lane := 0;
        pre_stage := 6;
    END_IF;

6:
    IF NOT X11 THEN
        pre_stage := 0;
    END_IF;

ELSE
    pre_stage := 0;
END_CASE;

(* ---- lane (workstation) state machines ---- *)
FOR i := 1 TO 2 DO
    CASE lane_state[i] OF
    1:
        IF (i = 1 AND X18) OR (i = 2 AND X1A) THEN
            lane_state[i] := 2;
        END_IF;
    ELSE
        ;
    END_CASE;
END_FOR;

(* ---- post scale lift level output ---- *)
Y18 := (post_stage = 2) OR (post_stage = 3) OR (post_stage = 4);
post_lift_tmr(IN := (post_stage = 2), PT := T#350ms);

(* ---- post-scale / dispatch sequence ---- *)
CASE post_stage OF
0:
    IF NOT X13 THEN
        IF lane_state[1] = 2 THEN
            post_active_lane := 1;
        ELSIF lane_state[2] = 2 THEN
            post_active_lane := 2;
        ELSE
            post_active_lane := 0;
        END_IF;
        IF post_active_lane <> 0 THEN
            D201 := post_active_lane;
            Y13 := TRUE;
            lane_state[post_active_lane] := 3;
            post_stage := 1;
        END_IF;
    END_IF;

1:
    IF X13 THEN
        post_active_tray := lane_tray_id[post_active_lane];
        post_active_tare := lane_tare[post_active_lane];
        lane_state[post_active_lane] := 0;
        post_stage := 2;
    END_IF;

2:
    IF post_lift_tmr.Q AND X20 THEN
        post_stage := 3;
    END_IF;

3:
    D203 := D203 + 1;
    post_req_seq := D203;
    Y14 := TRUE;
    post_stage := 4;

4:
    IF (D5 = post_req_seq) AND NOT X16 THEN
        post_finished_mass := D3;
        net_mass := post_finished_mass - post_active_tare;
        IF (net_mass >= 95) AND (net_mass <= 105) THEN
            D204 := 1;
        ELSE
            D204 := 2;
        END_IF;
        post_stage := 5;
    END_IF;

5:
    IF X21 THEN
        post_stage := 6;
    END_IF;

6:
    IF (D204 = 1 AND X1B) OR (D204 = 2 AND X1C) THEN
        Y15 := TRUE;
        post_stage := 7;
    END_IF;

7:
    IF NOT X13 THEN
        completed_count := completed_count + 1;
        post_active_lane := 0;
        post_active_tray := 0;
        post_active_tare := 0;
        post_stage := 0;
    END_IF;

ELSE
    post_stage := 0;
END_CASE;

(* ---- completion logic ---- *)
complete_cond := (completed_count >= 4) AND NOT X11 AND NOT X13
                 AND (lane_state[1] = 0) AND (lane_state[2] = 0)
                 AND (pre_stage = 0) AND (post_stage = 0);

complete_tmr(IN := complete_cond AND NOT complete_latched, PT := T#500ms);

IF complete_tmr.Q THEN
    complete_latched := TRUE;
END_IF;

Y16 := complete_latched;

END_PROGRAM