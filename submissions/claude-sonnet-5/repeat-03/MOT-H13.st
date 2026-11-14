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

    (* ---- internal working variables ---- *)
    home_a : DINT := 0;
    home_b : DINT := 0;
    home_lift : DINT := 40000;   (* 400.00 mm raw *)
    home_s3_1 : DINT := 0;
    home_s3_2 : DINT := 0;
    home_s4_0 : DINT := 0;
    home_s4_1 : DINT := 0;

    pos_tol : DINT := 20;        (* 0.2 unit raw *)
    vel_tol : DINT := 100;       (* 1 unit/s raw *)
    ang_tol_established : DINT := 20;   (* 0.2 deg raw *)
    spd_tol_established : DINT := 100;  (* 1 deg/s raw *)
    standstill_tol : DINT := 100;       (* 1 deg/s raw *)

    r0_active_cell3 : BOOL;
    r0_active_cell4 : BOOL;
    r1_active_cell3 : BOOL;
    r1_active_cell4 : BOOL;
    cell4_busy : BOOL;
    motor_needed : BOOL;

    cond0 : BOOL;
    cond1 : BOOL;
    ang_err0 : DINT;
    spd_err0 : DINT;
    ang_err1 : DINT;
    spd_err1 : DINT;
    est0 : BOOL;
    est1 : BOOL;
    ton_sync0 : TON;
    ton_sync1 : TON;

    prev_id0 : DINT := -1;
    prev_id1 : DINT := -1;
    ack0_latched : BOOL;
    ack1_latched : BOOL;
    lift_pos0 : DINT;
    lift_vel0 : DINT;
    lift_pos1 : DINT;
    lift_vel1 : DINT;
    r0_ready : BOOL;
    r1_ready : BOOL;

    desired_station0 : DINT;
    desired_station1 : DINT;
    last_commanded_station : DINT := -1;
    couple_seq : DINT := 0;

    cond_complete : BOOL;
END_VAR

(* ================= id change -> reset per-request latches ================= *)
IF D100 <> prev_id0 THEN
    ack0_latched := FALSE;
    prev_id0 := D100;
END_IF;

IF D120 <> prev_id1 THEN
    ack1_latched := FALSE;
    prev_id1 := D120;
END_IF;

(* ================= location classification ================= *)
r0_active_cell3 := (D101 = 3) AND NOT X31;
r0_active_cell4 := (D101 = 4) AND NOT X31;
r1_active_cell3 := (D121 = 3) AND NOT X35;
r1_active_cell4 := (D121 = 4) AND NOT X35;

cell4_busy := r0_active_cell4 OR r1_active_cell4;
motor_needed := r0_active_cell3 OR r0_active_cell4 OR r1_active_cell3 OR r1_active_cell4;

(* ================= cell 3 common motor (retain drive) ================= *)
Y71 := motor_needed AND NOT Y2;   (* must stop for final completion *)
Y44 := Y71;
D2016 := 0;
D2017 := 0;
D2018 := 0;
Y70 := FALSE;
D700 := 0;
D701 := D526;
D702 := 2000;   (* finite acceleration, deg/s^2, within limit 3000 *)

(* cell3 secondary axes held at docking home posture *)
D2020 := home_s3_1;
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2024 := home_s3_2;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

(* ================= cell 4 rotation synchronization axes ================= *)
Y75 := cell4_busy;
Y76 := FALSE;
D710 := 1000;
D711 := D626;
D712 := 2000;

D2028 := LIMIT(-3600, D600, 3600);
D2029 := 1000;
D2030 := 0;
Y47 := cell4_busy;

D2032 := LIMIT(-3600, D601, 3600);
D2033 := 1000;
D2034 := 0;
Y48 := cell4_busy;

(* ---- synchronization establishment / maintenance checks (r0) ---- *)
IF r0_active_cell4 THEN
    ang_err0 := ABS(D1028 - D627);
    spd_err0 := ABS(D1029 - D1017);
    cond0 := (ABS(D1017) > standstill_tol) AND (ang_err0 <= ang_tol_established) AND (spd_err0 <= spd_tol_established);
    ton_sync0(IN := cond0, PT := T#50ms);
    IF ton_sync0.Q THEN
        est0 := TRUE;
    END_IF;
ELSE
    est0 := FALSE;
    cond0 := FALSE;
    ton_sync0(IN := FALSE, PT := T#50ms);
END_IF;

(* ---- synchronization establishment / maintenance checks (r1) ---- *)
IF r1_active_cell4 THEN
    ang_err1 := ABS(D1032 - D627);
    spd_err1 := ABS(D1033 - D1017);
    cond1 := (ABS(D1017) > standstill_tol) AND (ang_err1 <= ang_tol_established) AND (spd_err1 <= spd_tol_established);
    ton_sync1(IN := cond1, PT := T#50ms);
    IF ton_sync1.Q THEN
        est1 := TRUE;
    END_IF;
ELSE
    est1 := FALSE;
    cond1 := FALSE;
    ton_sync1(IN := FALSE, PT := T#50ms);
END_IF;

(* ================= shuttle / lift axes: hold at home posture ================= *)
D2000 := home_a;
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2004 := home_b;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

D2008 := home_lift;
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

D2012 := home_lift;
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

Y30 := NOT Y71;

(* ================= new connection sequencing (D80/D81/D82) ================= *)
desired_station0 := D102;
desired_station1 := D122;

IF (NOT X31) AND (desired_station0 <> D101) THEN
    D81 := desired_station0;
    IF desired_station0 > D101 THEN
        D80 := 2;
    ELSE
        D80 := 1;
    END_IF;
    IF desired_station0 <> last_commanded_station THEN
        couple_seq := couple_seq + 1;
        last_commanded_station := desired_station0;
    END_IF;
    D82 := couple_seq;
ELSIF (NOT X35) AND (desired_station1 <> D121) THEN
    D81 := desired_station1;
    IF desired_station1 > D121 THEN
        D80 := 2;
    ELSE
        D80 := 1;
    END_IF;
    IF desired_station1 <> last_commanded_station THEN
        couple_seq := couple_seq + 1;
        last_commanded_station := desired_station1;
    END_IF;
    D82 := couple_seq;
ELSE
    D82 := couple_seq;
END_IF;

(* ================= per-request completion acknowledgement ================= *)
IF D101 = 1 THEN
    lift_pos0 := D1008;
    lift_vel0 := D1009;
ELSIF D101 = 2 THEN
    lift_pos0 := D1012;
    lift_vel0 := D1013;
ELSE
    lift_pos0 := home_lift + 100000;
    lift_vel0 := 100000;
END_IF;

r0_ready := X30 AND (ABS(lift_pos0 - home_lift) <= pos_tol) AND (ABS(lift_vel0) <= vel_tol);
IF r0_ready AND NOT ack0_latched THEN
    D300 := D100;
    D301 := SEL(X31, 1, 2);
    ack0_latched := TRUE;
END_IF;

IF D121 = 1 THEN
    lift_pos1 := D1008;
    lift_vel1 := D1009;
ELSIF D121 = 2 THEN
    lift_pos1 := D1012;
    lift_vel1 := D1013;
ELSE
    lift_pos1 := home_lift + 100000;
    lift_vel1 := 100000;
END_IF;

r1_ready := X34 AND (ABS(lift_pos1 - home_lift) <= pos_tol) AND (ABS(lift_vel1) <= vel_tol);
IF r1_ready AND NOT ack1_latched THEN
    D302 := D120;
    D303 := SEL(X35, 1, 2);
    ack1_latched := TRUE;
END_IF;

(* ================= final completion (Y2) ================= *)
cond_complete :=
    (ABS(D1000 - home_a) <= pos_tol) AND (ABS(D1001) <= vel_tol) AND
    (ABS(D1004 - home_b) <= pos_tol) AND (ABS(D1005) <= vel_tol) AND
    (ABS(D1008 - home_lift) <= pos_tol) AND (ABS(D1009) <= vel_tol) AND
    (ABS(D1012 - home_lift) <= pos_tol) AND (ABS(D1013) <= vel_tol) AND
    (ABS(D1020 - home_s3_1) <= pos_tol) AND (ABS(D1021) <= vel_tol) AND
    (ABS(D1024 - home_s3_2) <= pos_tol) AND (ABS(D1025) <= vel_tol) AND
    (ABS(D1017) <= vel_tol) AND
    (ABS(D1028 - home_s4_0) <= pos_tol) AND (ABS(D1029) <= vel_tol) AND
    (ABS(D1032 - home_s4_1) <= pos_tol) AND (ABS(D1033) <= vel_tol);

IF (NOT Y2) AND X51 AND cond_complete THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM