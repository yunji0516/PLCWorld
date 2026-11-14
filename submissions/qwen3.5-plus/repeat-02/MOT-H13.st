PROGRAM Main
VAR
    D1000 : DINT;
    D1001 : DINT;
    D1004 : DINT;
    D1005 : DINT;
    D1008 : DINT;
    D1009 : DINT;
    D1012 : DINT;
    D1013 : DINT;
    D1016 : DINT;
    D1017 : DINT;
    D1020 : DINT;
    D1021 : DINT;
    D1024 : DINT;
    D1025 : DINT;
    D1028 : DINT;
    D1029 : DINT;
    D1032 : DINT;
    D1033 : DINT;
    D100 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    X30 : BOOL;
    X31 : BOOL;
    D120 : DINT;
    D121 : DINT;
    D122 : DINT;
    D123 : DINT;
    D124 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    X51 : BOOL;
    D90 : DINT;
    D91 : DINT;
    D92 : DINT;
    X52 : BOOL;
    X53 : BOOL;
    D403 : DINT;
    D404 : DINT;
    X61 : BOOL;
    D406 : DINT;
    D407 : DINT;
    X62 : BOOL;
    D409 : DINT;
    D410 : DINT;
    X63 : BOOL;
    D412 : DINT;
    D413 : DINT;
    X64 : BOOL;
    D500 : DINT;
    D501 : DINT;
    D502 : DINT;
    D520 : DINT;
    D521 : DINT;
    D522 : DINT;
    D523 : DINT;
    D524 : DINT;
    D525 : DINT;
    D526 : DINT;
    D527 : DINT;
    X70 : BOOL;
    X71 : BOOL;
    X72 : BOOL;
    D600 : DINT;
    D601 : DINT;
    D620 : DINT;
    D621 : DINT;
    D622 : DINT;
    D623 : DINT;
    D624 : DINT;
    D625 : DINT;
    D626 : DINT;
    D627 : DINT;
    X75 : BOOL;
    X76 : BOOL;
    X77 : BOOL;
    D2000 : DINT;
    D2001 : DINT;
    D2002 : DINT;
    Y40 : BOOL;
    D2004 : DINT;
    D2005 : DINT;
    D2006 : DINT;
    Y41 : BOOL;
    D2008 : DINT;
    D2009 : DINT;
    D2010 : DINT;
    Y42 : BOOL;
    D2012 : DINT;
    D2013 : DINT;
    D2014 : DINT;
    Y43 : BOOL;
    D2016 : DINT;
    D2017 : DINT;
    D2018 : DINT;
    Y44 : BOOL;
    D2020 : DINT;
    D2021 : DINT;
    D2022 : DINT;
    Y45 : BOOL;
    D2024 : DINT;
    D2025 : DINT;
    D2026 : DINT;
    Y46 : BOOL;
    D2028 : DINT;
    D2029 : DINT;
    D2030 : DINT;
    Y47 : BOOL;
    D2032 : DINT;
    D2033 : DINT;
    D2034 : DINT;
    Y48 : BOOL;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    Y70 : BOOL;
    Y71 : BOOL;
    D700 : DINT;
    D701 : DINT;
    D702 : DINT;
    Y75 : BOOL;
    Y76 : BOOL;
    D710 : DINT;
    D711 : DINT;
    D712 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y30 : BOOL;
    Y2 : BOOL;

    (* Internal state tracking *)
    prev_r0_loc : DINT := -1;
    prev_r1_loc : DINT := -1;
    prev_r0_prog : DINT := -1;
    prev_r1_prog : DINT := -1;

    req0_assigned : BOOL := FALSE;
    req0_port : DINT := 0;
    req0_done : BOOL := FALSE;
    req0_cancel_flag : BOOL := FALSE;
    req0_ack_pending : BOOL := FALSE;
    req0_lift_pos : DINT := 0;

    req1_assigned : BOOL := FALSE;
    req1_port : DINT := 0;
    req1_done : BOOL := FALSE;
    req1_cancel_flag : BOOL := FALSE;
    req1_ack_pending : BOOL := FALSE;
    req1_lift_pos : DINT := 0;

    seq_num : DINT := 0;
    shuttle_busy : BOOL := FALSE;
    shuttle_req_owner : DINT := 0;
    fork_extended : BOOL := FALSE;
    shuttle_target_set : DINT := 0;

    (* Timers *)
    cell4_sync_timer : TON;
    cell4_violation_timer : TON;
    y2_hold_timer : TON;
    lift_move_timer : TON;
    cell3_result_timer : TON;
    cell4_result_timer : TON;

    (* Constants *)
    SHUTTLE_PORT1 : DINT := -405000;
    SHUTTLE_PORT2 : DINT := -185000;
    SHUTTLE_PORT3 : DINT := 65000;
    SHUTTLE_PORT4 : DINT := 360000;
    LIFT_DOCK_H : DINT := 95000;
    LIFT_HOME_H : DINT := 0;
    FORK_RETRACT : DINT := 0;
    FORK_CONNECT : DINT := 18000;
    HOME_A : DINT := 0;
    HOME_B : DINT := 0;
    HOME_C : DINT := 40000;
    HOME_D : DINT := 40000;
    HOME_S3_0 : DINT := 0;
    HOME_S3_1 : DINT := 0;
    HOME_S3_2 : DINT := 0;
    HOME_S4_0 : DINT := 0;
    HOME_S4_1 : DINT := 0;
    MOTOR_SPEED_RAW : DINT := 20000;
    MOTOR_RATE : DINT := 200;
    TOLERANCE_0_2 : DINT := 20;
    TOLERANCE_0_6 : DINT := 60;
    SPEED_TOL_1 : DINT := 100;

END_VAR

(* ============================================ *)
(* Internal helper: absolute DINT difference    *)
(* ============================================
FUNCTION ABS_DINT : DINT
VAR_INPUT val : DINT; END_VAR
END_FUNCTION
*)

(* ============================================ *)
(* Initialize outputs and internal state        *)
(* ============================================ *)

(* Default: brake open unless needed *)
Y30 := FALSE;
Y2 := FALSE;

(* Default shuttle/fork/lift states *)
(* These will be set per-request logic below *)

(* ============================================ *)
(* Request detection and assignment              *)
(* ============================================ *)

(* Detect request 0 arrival *)
IF prev_r0_loc < 0 AND D101 > 0 THEN
    prev_r0_loc := D101;
    req0_assigned := TRUE;
    req0_done := FALSE;
    req0_cancel_flag := FALSE;
    req0_ack_pending := FALSE;
    CASE D101 OF
        1: req0_port := 1; req0_lift_pos := LIFT_DOCK_H;
        2: req0_port := 2; req0_lift_pos := LIFT_DOCK_H;
        ELSE
            req0_port := D101;
            req0_lift_pos := LIFT_DOCK_H;
    END_CASE;
ELSIF prev_r0_loc >= 0 THEN
    prev_r0_loc := D101;
END_IF;

(* Detect request 1 arrival *)
IF prev_r1_loc < 0 AND D121 > 0 THEN
    prev_r1_loc := D121;
    req1_assigned := TRUE;
    req1_done := FALSE;
    req1_cancel_flag := FALSE;
    req1_ack_pending := FALSE;
    CASE D121 OF
        1: req1_port := 1; req1_lift_pos := LIFT_DOCK_H;
        2: req1_port := 2; req1_lift_pos := LIFT_DOCK_H;
        ELSE
            req1_port := D121;
            req1_lift_pos := LIFT_DOCK_H;
    END_CASE;
ELSIF prev_r1_loc >= 0 THEN
    prev_r1_loc := D121;
END_IF;

(* ============================================ *)
(* Common rotation drive (Cell 3) motor control *)
(* ============================================ *)

(* s3_0 is the continuous rotation motor, runs at 200 deg/s when retain=TRUE *)
(* Must run when any non-cancelled request is in cell 3 or cell 4 phase *)
IF (req0_assigned AND NOT req0_done AND NOT req0_cancel_flag AND D102 >= 3 AND D102 <= 5) OR
   (req1_assigned AND NOT req1_done AND NOT req1_cancel_flag AND D122 >= 3 AND D122 <= 5) THEN
    Y71 := TRUE;  (* m3_retain: keep motor running *)
    D700 := MOTOR_RATE;  (* select ratio *)
    D701 := 0;  (* route *)
    D702 := 3000;  (* accel *)
    s3_0_target := s3_0_position + MOTOR_SPEED_RAW;
    s3_0_rate := MOTOR_RATE;
    s3_0_ff := 0;
    s3_0_enable := TRUE;
    cell3_motor_on := TRUE;
ELSIF (req0_assigned AND NOT req0_done AND NOT req0_cancel_flag AND D102 >= 6) OR
      (req1_assigned AND NOT req1_done AND NOT req1_cancel_flag AND D122 >= 6) OR
      (NOT req0_assigned AND NOT req1_assigned) THEN
    (* Stop motor when returning or done *)
    IF ABS_DINT_VAL(s3_0_velocity) <= SPEED_TOL_1 THEN
        Y71 := FALSE;
        s3_0_enable := FALSE;
        s3_0_rate := 0;
        cell3_motor_on := FALSE;
    END_IF;
END_IF;

(* Cell 3 axes s3_1 and s3_2 must be at home for docking *)
s3_1_target := HOME_S3_1;
s3_1_rate := 200;
s3_1_ff := 0;
s3_1_enable := TRUE;

s3_2_target := HOME_S3_2;
s3_2_rate := 200;
s3_2_ff := 0;
s3_2_enable := TRUE;

(* Configure cell 3 when needed *)
IF (req0_assigned AND NOT req0_done AND NOT req0_cancel_flag AND D102 >= 2) OR
   (req1_assigned AND NOT req1_done AND NOT req1_cancel_flag AND D122 >= 2) THEN
    Y70 := TRUE;  (* m3_configure *)
END_IF;

(* ============================================ *)
(* Cell 4 (gear sync) configuration             *)
(* ============================================ *)

(* Electronic gear: s4 follows s3_0 at select/1000 ratio *)
IF (req0_assigned AND NOT req0_done AND NOT req0_cancel_flag AND D102 >= 4 AND D102 <= 5) OR
   (req1_assigned AND NOT req1_done AND NOT req1_cancel_flag AND D122 >= 4 AND D122 <= 5) THEN
    Y75 := TRUE;  (* m4_configure *)
    Y76 := TRUE;  (* m4_retain *)

    (* Set gear ratio from request data *)
    D710 := 1000;  (* default 1:1, adjust per request *)
    D711 := 0;  (* route *)
    D712 := 3000;  (* accel *)

    (* Sync error checking *)
    (* Angle error: |s4_angle - ratio * s3_angle| <= 0.2 deg (20 raw) *)
    (* Speed error: |s4_speed - ratio * s3_speed| <= 1 deg/s (100 raw) *)
    IF D627 <> 0 AND D527 <> 0 THEN
        (* Check sync establishment for 50ms *)
        cell4_sync_timer(IN := TRUE, PT := T#50ms);
    END_IF;
END_IF;

(* ============================================ *)
(* Request state machine                        *)
(* ============================================ *)

(* --- Request 0 --- *)
IF req0_assigned AND NOT req0_done THEN
    CASE D102 OF
        (* Stage 0: At source lift, prepare *)
        0:
            (* Set station and action for lift *)
            D81 := req0_port;  (* lift A or B *)
            D80 := 1;  (* extract *)
            (* Move lift to dock height *)
            IF req0_port = 1 THEN
                c_target := LIFT_DOCK_H;
                c_rate := 200;
                c_ff := 0;
                c_enable := TRUE;
            ELSIF req0_port = 2 THEN
                d_target := LIFT_DOCK_H;
                d_rate := 200;
                d_ff := 0;
                d_enable := TRUE;
            END_IF;
            (* Position shuttle at corresponding port *)
            IF req0_port = 1 THEN
                a_target := SHUTTLE_PORT1;
            ELSIF req0_port = 2 THEN
                a_target := SHUTTLE_PORT2;
            END_IF;
            a_rate := 200;
            a_ff := 0;
            a_enable := TRUE;
            shuttle_busy := TRUE;
            shuttle_req_owner := 0;

        (* Stage 1: Moving to cell 3 / connection established *)
        1:
            (* Fork extended, jig on shuttle *)
            b_target := FORK_CONNECT;
            b_rate := 100;
            b_ff := 0;
            b_enable := TRUE;
            fork_extended := TRUE;

            (* Move shuttle to cell 3 *)
            a_target := SHUTTLE_PORT3;
            a_rate := 200;
            a_ff := 0;
            a_enable := TRUE;

        (* Stage 2: At cell 3, processing *)
        2:
            (* Retract fork before cell 3 entry *)
            b_target := FORK_RETRACT;
            b_rate := 100;
            b_ff := 0;
            b_enable := TRUE;
            fork_extended := FALSE;

            (* Cell 3 processing - motor running *)
            Y70 := TRUE;
            Y71 := TRUE;

        (* Stage 3: Moving to cell 4 *)
        3:
            (* Move shuttle to cell 4 *)
            a_target := SHUTTLE_PORT4;
            a_rate := 200;
            a_ff := 0;
            a_enable := TRUE;

        (* Stage 4: At cell 4, gear sync processing *)
        4:
            (* Cell 4 processing with gear sync *)
            Y75 := TRUE;
            Y76 := TRUE;
            cell4_sync_timer(IN := X77, PT := T#50ms);

            (* Keep motor at 200 deg/s *)
            Y71 := TRUE;
            D700 := MOTOR_RATE;
            s3_0_rate := MOTOR_RATE;
            s3_0_enable := TRUE;

            (* Configure gear ratio for s4 axes *)
            D710 := 1000;
            s4_0_rate := 200;
            s4_0_enable := TRUE;
            s4_1_rate := 200;
            s4_1_enable := TRUE;

        (* Stage 5: Returning to lift *)
        5:
            (* Retract from cell 4, return to lift port *)
            b_target := FORK_RETRACT;
            b_rate := 100;
            b_ff := 0;
            b_enable := TRUE;
            fork_extended := FALSE;

            IF req0_port = 1 THEN
                a_target := SHUTTLE_PORT1;
            ELSIF req0_port = 2 THEN
                a_target := SHUTTLE_PORT2;
            END_IF;
            a_rate := 200;
            a_ff := 0;
            a_enable := TRUE;

        (* Stage 6: At source lift, deliver *)
        6:
            (* Extend fork to deliver *)
            b_target := FORK_CONNECT;
            b_rate := 100;
            b_ff := 0;
            b_enable := TRUE;
            fork_extended := TRUE;

            (* Lower lift *)
            IF req0_port = 1 THEN
                c_target := LIFT_HOME_H;
                c_rate := 200;
                c_ff := 0;
                c_enable := TRUE;
            ELSIF req0_port = 2 THEN
                d_target := LIFT_HOME_H;
                d_rate := 200;
                d_ff := 0;
                d_enable := TRUE;
            END_IF;

        (* Stage 7: Done - retract and complete *)
        7:
            b_target := FORK_RETRACT;
            b_rate := 100;
            b_ff := 0;
            b_enable := TRUE;
            fork_extended := FALSE;

            (* Acknowledge completion *)
            req0_ack_pending := TRUE;
            req0_done := TRUE;
            shuttle_busy := FALSE;

    END_CASE;

    (* Handle cancellation *)
    IF X31 AND NOT req0_cancel_flag THEN
        req0_cancel_flag := TRUE;
    END_IF;

    IF req0_cancel_flag AND D102 >= 1 THEN
        (* Cancel: retrieve and return *)
        b_target := FORK_RETRACT;
        b_rate := 100;
        b_ff := 0;
        b_enable := TRUE;
        fork_extended := FALSE;

        IF req0_port = 1 THEN
            a_target := SHUTTLE_PORT1;
        ELSIF req0_port = 2 THEN
            a_target := SHUTTLE_PORT2;
        END_IF;
        a_rate := 200;
        a_ff := 0;
        a_enable := TRUE;

        IF D102 >= 6 THEN
            req0_ack_pending := TRUE;
            req0_done := TRUE;
            shuttle_busy := FALSE;
        END_IF;
    END_IF;
END_IF;

(* --- Request 1 --- *)
IF req1_assigned AND NOT req1_done THEN
    CASE D122 OF
        (* Stage 0: At source lift, prepare *)
        0:
            D81 := req1_port;
            D80 := 1;
            IF req1_port = 1 THEN
                c_target := LIFT_DOCK_H;
                c_rate := 200;
                c_ff := 0;
                c_enable := TRUE;
            ELSIF req1_port = 2 THEN
                d_target := LIFT_DOCK_H;
                d_rate := 200;
                d_ff := 0;
                d_enable := TRUE;
            END_IF;
            IF req1_port = 1 THEN
                a_target := SHUTTLE_PORT1;
            ELSIF req1_port = 2 THEN
                a_target := SHUTTLE_PORT2;
            END_IF;
            a_rate := 200;
            a_ff := 0;
            a_enable := TRUE;
            shuttle_busy := TRUE;
            shuttle_req_owner := 1;

        (* Stage 1: Moving to cell 3 *)
        1:
            b_target := FORK_CONNECT;
            b_rate := 100;
            b_ff := 0;
            b_enable := TRUE;
            fork_extended := TRUE;
            a_target := SHUTTLE_PORT3;
            a_rate := 200;
            a_ff := 0;
            a_enable := TRUE;

        (* Stage 2: At cell 3 *)
        2:
            b_target := FORK_RETRACT;
            b_rate := 100;
            b_ff := 0;
            b_enable := TRUE;
            fork_extended := FALSE;
            Y70 := TRUE;
            Y71 := TRUE;

        (* Stage 3: Moving to cell 4 *)
        3:
            a_target := SHUTTLE_PORT4;
            a_rate := 200;
            a_ff := 0;
            a_enable := TRUE;

        (* Stage 4: At cell 4, gear sync *)
        4:
            Y75 := TRUE;
            Y76 := TRUE;
            cell4_sync_timer(IN := X77, PT := T#50ms);
            Y71 := TRUE;
            D700 := MOTOR_RATE;
            s3_0_rate := MOTOR_RATE;
            s3_0_enable := TRUE;
            D710 := 1000;
            s4_0_rate := 200;
            s4_0_enable := TRUE;
            s4_1_rate := 200;
            s4_1_enable := TRUE;

        (* Stage 5: Returning to lift *)
        5:
            b_target := FORK_RETRACT;
            b_rate := 100;
            b_ff := 0;
            b_enable := TRUE;
            fork_extended := FALSE;
            IF req1_port = 1 THEN
                a_target := SHUTTLE_PORT1;
            ELSIF req1_port = 2 THEN
                a_target := SHUTTLE_PORT2;
            END_IF;
            a_rate := 200;
            a_ff := 0;
            a_enable := TRUE;

        (* Stage 6: At source lift, deliver *)
        6:
            b_target := FORK_CONNECT;
            b_rate := 100;
            b_ff := 0;
            b_enable := TRUE;
            fork_extended := TRUE;
            IF req1_port = 1 THEN
                c_target := LIFT_HOME_H;
                c_rate := 200;
                c_ff := 0;
                c_enable := TRUE;
            ELSIF req1_port = 2 THEN
                d_target := LIFT_HOME_H;
                d_rate := 200;
                d_ff := 0;
                d_enable := TRUE;
            END_IF;

        (* Stage 7: Done *)
        7:
            b_target := FORK_RETRACT;
            b_rate := 100;
            b_ff := 0;
            b_enable := TRUE;
            fork_extended := FALSE;
            req1_ack_pending := TRUE;
            req1_done := TRUE;
            shuttle_busy := FALSE;
    END_CASE;

    (* Handle cancellation for request 1 *)
    IF X35 AND NOT req1_cancel_flag THEN
        req1_cancel_flag := TRUE;
    END_IF;

    IF req1_cancel_flag AND D122 >= 1 THEN
        b_target := FORK_RETRACT;
        b_rate := 100;
        b_ff := 0;
        b_enable := TRUE;
        fork_extended := FALSE;
        IF req1_port = 1 THEN
            a_target := SHUTTLE_PORT1;
        ELSIF req1_port = 2 THEN
            a_target := SHUTTLE_PORT2;
        END_IF;
        a_rate := 200;
        a_ff := 0;
        a_enable := TRUE;
        IF D122 >= 6 THEN
            req1_ack_pending := TRUE;
            req1_done := TRUE;
            shuttle_busy := FALSE;
        END_IF;
    END_IF;
END_IF;

(* ============================================ *)
(* Sequence number management                   *)
(* ============================================ *)
IF (D102 = 0 AND D101 > 0) OR (D122 = 0 AND D121 > 0) THEN
    seq_num := seq_num + 1;
    D82 := seq_num;
END_IF;

(* ============================================ *)
(* Acknowledge completions                      *)
(* ============================================ *)
IF req0_ack_pending THEN
    D300 := D100;  (* ack0 = request id *)
    IF req0_cancel_flag THEN
        D301 := 2;  (* cancellation retrieval *)
    ELSE
        D301 := 1;  (* completion *)
    END_IF;
    req0_ack_pending := FALSE;
END_IF;

IF req1_ack_pending THEN
    D302 := D120;  (* ack1 = request id *)
    IF req1_cancel_flag THEN
        D303 := 2;
    ELSE
        D303 := 1;
    END_IF;
    req1_ack_pending := FALSE;
END_IF;

(* ============================================ *)
(* Cell 3 and Cell 4 result maintenance         *)
(* ============================================ *)

(* Cell 3 result: maintain for 80ms *)
IF (req0_assigned AND D102 = 2 AND NOT req0_cancel_flag) OR
   (req1_assigned AND D122 = 2 AND NOT req1_cancel_flag) THEN
    cell3_result_timer(IN := TRUE, PT := T#80ms);
    IF cell3_result_timer.Q THEN
        X70 := TRUE;  (* m3_served *)
    END_IF;
ELSE
    cell3_result_timer(IN := FALSE);
END_IF;

(* Cell 4 result: maintain for 80ms *)
IF (req0_assigned AND D102 = 4 AND NOT req0_cancel_flag AND cell4_sync_timer.Q) OR
   (req1_assigned AND D122 = 4 AND NOT req1_cancel_flag AND cell4_sync_timer.Q) THEN
    cell4_result_timer(IN := TRUE, PT := T#80ms);
    IF cell4_result_timer.Q THEN
        X75 := TRUE;  (* m4_served *)
    END_IF;
ELSE
    cell4_result_timer(IN := FALSE);
END_IF;

(* ============================================ *)
(* Safety: lift height difference <= 80mm       *)
(* ============================================ *)
IF ABS(DINT_TO_REAL(c_position) - DINT_TO_REAL(d_position)) > 8000 THEN
    (* Brake if height difference too large *)
    Y30 := TRUE;
END_IF;

(* ============================================ *)
(* Safety: shuttle stop when fork engaged > 40mm*)
(* ============================================ *)
IF fork_extended AND b_position > 4000 THEN
    a_enable := FALSE;
END_IF;

(* ============================================ *)
(* Completion detection                         *)
(* ============================================ *)

(* Check all conditions for Y2 completion *)
IF X51 THEN
    y2_hold_timer(IN := TRUE, PT := T#100ms);
    IF y2_hold_timer.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    y2_hold_timer(IN := FALSE);
END_IF;

(* Final Y2 requirements check *)
IF Y2 THEN
    (* Verify shuttle and fork at 0, cells at home, lifts at home *)
    IF a_position <> HOME_A OR b_position <> HOME_B OR
       c_position <> HOME_C OR d_position <> HOME_D OR
       s3_0_position <> HOME_S3_0 OR s3_1_position <> HOME_S3_1 OR
       s3_2_position <> HOME_S3_2 OR s4_0_position <> HOME_S4_0 OR
       s4_1_position <> HOME_S4_1 THEN
        Y2 := FALSE;
        y2_hold_timer(IN := FALSE);
    END_IF;
END_IF;

(* ============================================ *)
(* Default state for unassigned/empty inputs    *)
(* ============================================ *)
IF NOT req0_assigned AND NOT req1_assigned THEN
    (* All at home *)
    a_target := HOME_A;
    a_rate := 0;
    a_enable := FALSE;
    b_target := FORK_RETRACT;
    b_rate := 0;
    b_enable := FALSE;
    c_target := HOME_C;
    c_rate := 0;
    c_enable := FALSE;
    d_target := HOME_D;
    d_rate := 0;
    d_enable := FALSE;
    s3_0_target := HOME_S3_0;
    s3_0_rate := 0;
    s3_0_enable := FALSE;
    s3_1_target := HOME_S3_1;
    s3_1_rate := 0;
    s3_1_enable := FALSE;
    s3_2_target := HOME_S3_2;
    s3_2_rate := 0;
    s3_2_enable := FALSE;
    s4_0_target := HOME_S4_0;
    s4_0_rate := 0;
    s4_0_enable := FALSE;
    s4_1_target := HOME_S4_1;
    s4_1_rate := 0;
    s4_1_enable := FALSE;
    Y70 := FALSE;
    Y71 := FALSE;
    Y75 := FALSE;
    Y76 := FALSE;
END_IF;

END_PROGRAM