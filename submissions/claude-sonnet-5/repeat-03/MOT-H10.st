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
    D602 : DINT;
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

    (* ---- internal constants ---- *)
    pi          : REAL := 3.14159265358979;
    pos_tol     : DINT := 20;     (* 0.2 mm/deg raw *)
    spd_tol     : DINT := 100;    (* 1 mm/s or deg/s raw *)
    ang_tol     : DINT := 20;
    angspd_tol  : DINT := 100;
    sway_tol    : DINT := 3;      (* 0.03 deg raw *)
    swayspd_tol : DINT := 15;     (* 0.15 deg/s raw *)

    HOME_C  : DINT := 15000;
    HOME_D  : DINT := 15000;
    HOME_S40 : DINT := 100000;

    st1 : DINT := -360000;
    st2 : DINT := -230000;
    st3 : DINT := 230000;
    st4 : DINT := 990000;
    fork_home : DINT := 0;
    fork_conn : DINT := 18000;

    A_MIN : DINT := -450000; A_MAX : DINT := 1130000;
    B_MIN : DINT := 0;       B_MAX : DINT := 18000;
    C_MIN : DINT := 0;       C_MAX : DINT := 120000;
    D_MIN : DINT := 0;       D_MAX : DINT := 120000;
    S30_MIN : DINT := -5000; S30_MAX : DINT := 5000;
    S31_MIN : DINT := -45000; S31_MAX : DINT := 45000;
    S40_MIN : DINT := 50000; S40_MAX : DINT := 150000;
    S41_MIN : DINT := -100000; S41_MAX : DINT := 100000;

    seq_counter : DINT := 0;

    (* request channel 0 *)
    r0_last_id : DINT := -1;
    r0_state   : INT := 0;
    r0_origin  : DINT := 1;
    r0_cancel_flag : BOOL := FALSE;
    r0_drive_shuttle : BOOL := FALSE;

    (* request channel 1 *)
    r1_last_id : DINT := -1;
    r1_state   : INT := 0;
    r1_origin  : DINT := 1;
    r1_cancel_flag : BOOL := FALSE;
    r1_drive_shuttle : BOOL := FALSE;

    active_owner : INT := 0;

    a_tgt, b_tgt, c_tgt, d_tgt : DINT;
    s30_tgt, s31_tgt : DINT;
    s40_tgt, s41_tgt, s42_tgt : DINT;

    origin_station_coord : DINT;
    origin_port_ready : BOOL;
    origin_port_id : DINT;
    origin_lift_pos : DINT;
    origin_lift_vel : DINT;

    lift_dock_r0 : BOOL;
    lift_dock_r1 : BOOL;
    lift_stopped : BOOL;
    lift_move_pending : BOOL;

    theta_act_rad : REAL;
    x_cw_act : REAL;
    moment3 : REAL;
    theta_cmd_rad : REAL;

    home_condition : BOOL;
    y2_timer : TON;
    y2_latched : BOOL := FALSE;
END_VAR

(* ============ defaults each scan ============ *)
a_tgt := 0;
b_tgt := 0;
c_tgt := HOME_C;
d_tgt := HOME_D;
s30_tgt := 0;
s31_tgt := 0;
s40_tgt := HOME_S40;
s41_tgt := 0;
Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;

(* ============ shuttle arbitration ============ *)
r0_drive_shuttle := FALSE;
r1_drive_shuttle := FALSE;

IF (r0_state >= 1) AND (r0_state <= 3) OR (r0_state >= 6) AND (r0_state <= 8) OR (r0_state >= 11) AND (r0_state <= 14) THEN
    IF (active_owner = 0) OR (active_owner = 1) THEN
        active_owner := 1;
        r0_drive_shuttle := TRUE;
    END_IF
ELSE
    IF active_owner = 1 THEN active_owner := 0; END_IF
END_IF

IF (r1_state >= 1) AND (r1_state <= 3) OR (r1_state >= 6) AND (r1_state <= 8) OR (r1_state >= 11) AND (r1_state <= 14) THEN
    IF (active_owner = 0) OR (active_owner = 2) THEN
        active_owner := 2;
        r1_drive_shuttle := TRUE;
    END_IF
ELSE
    IF active_owner = 2 THEN active_owner := 0; END_IF
END_IF

(* ============ Channel 0 state machine ============ *)
IF r0_origin = 1 THEN
    origin_station_coord := st1;
    origin_port_ready := X61;
    origin_port_id := D404;
    origin_lift_pos := D1008;
    origin_lift_vel := D1009;
ELSE
    origin_station_coord := st2;
    origin_port_ready := X62;
    origin_port_id := D407;
    origin_lift_pos := D1012;
    origin_lift_vel := D1013;
END_IF

CASE r0_state OF
0:
    IF (D100 <> 0) AND (D100 <> r0_last_id) THEN
        r0_last_id := D100;
        r0_origin := D101;
        r0_cancel_flag := FALSE;
        r0_state := 1;
    END_IF

1: (* approach origin, extract fixture from lift *)
    IF r0_drive_shuttle THEN
        a_tgt := origin_station_coord;
        b_tgt := fork_conn;
        IF ABS(D1000 - origin_station_coord) <= pos_tol AND ABS(D1001) <= spd_tol
           AND ABS(D1004 - fork_conn) <= pos_tol AND ABS(D1005) <= spd_tol
           AND origin_port_ready THEN
            seq_counter := seq_counter + 1;
            D80 := 1; D81 := r0_origin; D82 := seq_counter;
            r0_state := 2;
        END_IF
    END_IF

2: (* travel to cell 3 *)
    IF r0_drive_shuttle THEN
        a_tgt := st3;
        b_tgt := fork_home;
        IF X31 THEN r0_cancel_flag := TRUE; END_IF
        IF ABS(D1000 - st3) <= pos_tol AND ABS(D1001) <= spd_tol THEN
            r0_state := 3;
        END_IF
    END_IF

3: (* connect at cell3 *)
    IF r0_drive_shuttle THEN
        a_tgt := st3;
        b_tgt := fork_conn;
        IF ABS(D1004 - fork_conn) <= pos_tol AND ABS(D1005) <= spd_tol AND X63 THEN
            seq_counter := seq_counter + 1;
            D80 := 2; D81 := 3; D82 := seq_counter;
            r0_state := 4;
        END_IF
    END_IF

4: (* cell3 move to goal *)
    IF X31 THEN r0_cancel_flag := TRUE; END_IF
    IF r0_cancel_flag THEN
        r0_state := 5;
    ELSIF X70 THEN
        r0_state := 5;
    END_IF

5: (* cell3 return home posture *)
    IF ABS(D1016) <= ang_tol AND ABS(D1017) <= angspd_tol
       AND ABS(D1020) <= pos_tol AND ABS(D1021) <= spd_tol THEN
        r0_state := 6;
    END_IF

6: (* disconnect from cell3 *)
    IF r0_drive_shuttle THEN
        a_tgt := st3;
        b_tgt := fork_home;
        IF ABS(D1004 - fork_home) <= pos_tol AND ABS(D1005) <= spd_tol THEN
            seq_counter := seq_counter + 1;
            D80 := 1; D81 := 3; D82 := seq_counter;
            IF r0_cancel_flag THEN
                r0_state := 12;
            ELSE
                r0_state := 7;
            END_IF
        END_IF
    END_IF

7: (* travel to cell4 *)
    IF r0_drive_shuttle THEN
        a_tgt := st4;
        b_tgt := fork_home;
        IF X31 THEN r0_cancel_flag := TRUE; END_IF
        IF ABS(D1000 - st4) <= pos_tol AND ABS(D1001) <= spd_tol THEN
            r0_state := 8;
        END_IF
    END_IF

8: (* connect at cell4 - require home posture and sway settled *)
    IF r0_drive_shuttle THEN
        a_tgt := st4;
        b_tgt := fork_conn;
        IF ABS(D1004 - fork_conn) <= pos_tol AND ABS(D1005) <= spd_tol AND X64
           AND ABS(D1024 - HOME_S40) <= pos_tol AND ABS(D1025) <= spd_tol
           AND ABS(D1028) <= pos_tol AND ABS(D1029) <= spd_tol
           AND ABS(D1032) <= sway_tol AND ABS(D1033) <= swayspd_tol THEN
            seq_counter := seq_counter + 1;
            D80 := 2; D81 := 4; D82 := seq_counter;
            r0_state := 9;
        END_IF
    END_IF

9: (* cell4 move to goal *)
    IF X31 THEN r0_cancel_flag := TRUE; END_IF
    IF r0_cancel_flag THEN
        r0_state := 10;
    ELSIF X75 THEN
        r0_state := 10;
    END_IF

10: (* cell4 return home posture *)
    IF ABS(D1024 - HOME_S40) <= pos_tol AND ABS(D1025) <= spd_tol
       AND ABS(D1028) <= pos_tol AND ABS(D1029) <= spd_tol
       AND ABS(D1032) <= sway_tol AND ABS(D1033) <= swayspd_tol THEN
        r0_state := 11;
    END_IF

11: (* disconnect from cell4 *)
    IF r0_drive_shuttle THEN
        a_tgt := st4;
        b_tgt := fork_home;
        IF ABS(D1004 - fork_home) <= pos_tol AND ABS(D1005) <= spd_tol THEN
            seq_counter := seq_counter + 1;
            D80 := 1; D81 := 4; D82 := seq_counter;
            r0_state := 12;
        END_IF
    END_IF

12: (* travel back to origin lift *)
    IF r0_drive_shuttle THEN
        a_tgt := origin_station_coord;
        b_tgt := fork_home;
        IF ABS(D1000 - origin_station_coord) <= pos_tol AND ABS(D1001) <= spd_tol THEN
            r0_state := 13;
        END_IF
    END_IF

13: (* connect at lift, place fixture back *)
    IF r0_drive_shuttle THEN
        a_tgt := origin_station_coord;
        b_tgt := fork_conn;
        IF ABS(D1004 - fork_conn) <= pos_tol AND ABS(D1005) <= spd_tol AND origin_port_ready THEN
            seq_counter := seq_counter + 1;
            D80 := 2; D81 := r0_origin; D82 := seq_counter;
            r0_state := 14;
        END_IF
    END_IF

14: (* settle: retract fork, lift returns home, wait return confirm, ack *)
    IF r0_drive_shuttle THEN
        a_tgt := origin_station_coord;
        b_tgt := fork_home;
    END_IF
    IF ABS(origin_lift_pos - HOME_C) <= pos_tol AND ABS(origin_lift_vel) <= spd_tol AND X30 THEN
        D300 := r0_last_id;
        IF r0_cancel_flag THEN
            D301 := 2;
        ELSE
            D301 := 1;
        END_IF
        r0_state := 0;
    END_IF

ELSE
    r0_state := 0;
END_CASE

(* lift dock height override for channel 0 *)
lift_dock_r0 := (r0_state = 1) OR (r0_state = 12) OR (r0_state = 13);
IF lift_dock_r0 THEN
    IF r0_origin = 1 THEN c_tgt := D92; ELSE d_tgt := D92; END_IF
END_IF

(* ============ Channel 1 state machine ============ *)
IF r1_origin = 1 THEN
    origin_station_coord := st1;
    origin_port_ready := X61;
    origin_port_id := D404;
    origin_lift_pos := D1008;
    origin_lift_vel := D1009;
ELSE
    origin_station_coord := st2;
    origin_port_ready := X62;
    origin_port_id := D407;
    origin_lift_pos := D1012;
    origin_lift_vel := D1013;
END_IF

CASE r1_state OF
0:
    IF (D120 <> 0) AND (D120 <> r1_last_id) THEN
        r1_last_id := D120;
        r1_origin := D121;
        r1_cancel_flag := FALSE;
        r1_state := 1;
    END_IF

1:
    IF r1_drive_shuttle THEN
        a_tgt := origin_station_coord;
        b_tgt := fork_conn;
        IF ABS(D1000 - origin_station_coord) <= pos_tol AND ABS(D1001) <= spd_tol
           AND ABS(D1004 - fork_conn) <= pos_tol AND ABS(D1005) <= spd_tol
           AND origin_port_ready THEN
            seq_counter := seq_counter + 1;
            D80 := 1; D81 := r1_origin; D82 := seq_counter;
            r1_state := 2;
        END_IF
    END_IF

2:
    IF r1_drive_shuttle THEN
        a_tgt := st3;
        b_tgt := fork_home;
        IF X35 THEN r1_cancel_flag := TRUE; END_IF
        IF ABS(D1000 - st3) <= pos_tol AND ABS(D1001) <= spd_tol THEN
            r1_state := 3;
        END_IF
    END_IF

3:
    IF r1_drive_shuttle THEN
        a_tgt := st3;
        b_tgt := fork_conn;
        IF ABS(D1004 - fork_conn) <= pos_tol AND ABS(D1005) <= spd_tol AND X63 THEN
            seq_counter := seq_counter + 1;
            D80 := 2; D81 := 3; D82 := seq_counter;
            r1_state := 4;
        END_IF
    END_IF

4:
    IF X35 THEN r1_cancel_flag := TRUE; END_IF
    IF r1_cancel_flag THEN
        r1_state := 5;
    ELSIF X70 THEN
        r1_state := 5;
    END_IF

5:
    IF ABS(D1016) <= ang_tol AND ABS(D1017) <= angspd_tol
       AND ABS(D1020) <= pos_tol AND ABS(D1021) <= spd_tol THEN
        r1_state := 6;
    END_IF

6:
    IF r1_drive_shuttle THEN
        a_tgt := st3;
        b_tgt := fork_home;
        IF ABS(D1004 - fork_home) <= pos_tol AND ABS(D1005) <= spd_tol THEN
            seq_counter := seq_counter + 1;
            D80 := 1; D81 := 3; D82 := seq_counter;
            IF r1_cancel_flag THEN
                r1_state := 12;
            ELSE
                r1_state := 7;
            END_IF
        END_IF
    END_IF

7:
    IF r1_drive_shuttle THEN
        a_tgt := st4;
        b_tgt := fork_home;
        IF X35 THEN r1_cancel_flag := TRUE; END_IF
        IF ABS(D1000 - st4) <= pos_tol AND ABS(D1001) <= spd_tol THEN
            r1_state := 8;
        END_IF
    END_IF

8:
    IF r1_drive_shuttle THEN
        a_tgt := st4;
        b_tgt := fork_conn;
        IF ABS(D1004 - fork_conn) <= pos_tol AND ABS(D1005) <= spd_tol AND X64
           AND ABS(D1024 - HOME_S40) <= pos_tol AND ABS(D1025) <= spd_tol
           AND ABS(D1028) <= pos_tol AND ABS(D1029) <= spd_tol
           AND ABS(D1032) <= sway_tol AND ABS(D1033) <= swayspd_tol THEN
            seq_counter := seq_counter + 1;
            D80 := 2; D81 := 4; D82 := seq_counter;
            r1_state := 9;
        END_IF
    END_IF

9:
    IF X35 THEN r1_cancel_flag := TRUE; END_IF
    IF r1_cancel_flag THEN
        r1_state := 10;
    ELSIF X75 THEN
        r1_state := 10;
    END_IF

10:
    IF ABS(D1024 - HOME_S40) <= pos_tol AND ABS(D1025) <= spd_tol
       AND ABS(D1028) <= pos_tol AND ABS(D1029) <= spd_tol
       AND ABS(D1032) <= sway_tol AND ABS(D1033) <= swayspd_tol THEN
        r1_state := 11;
    END_IF

11:
    IF r1_drive_shuttle THEN
        a_tgt := st4;
        b_tgt := fork_home;
        IF ABS(D1004 - fork_home) <= pos_tol AND ABS(D1005) <= spd_tol THEN
            seq_counter := seq_counter + 1;
            D80 := 1; D81 := 4; D82 := seq_counter;
            r1_state := 12;
        END_IF
    END_IF

12:
    IF r1_drive_shuttle THEN
        a_tgt := origin_station_coord;
        b_tgt := fork_home;
        IF ABS(D1000 - origin_station_coord) <= pos_tol AND ABS(D1001) <= spd_tol THEN
            r1_state := 13;
        END_IF
    END_IF

13:
    IF r1_drive_shuttle THEN
        a_tgt := origin_station_coord;
        b_tgt := fork_conn;
        IF ABS(D1004 - fork_conn) <= pos_tol AND ABS(D1005) <= spd_tol AND origin_port_ready THEN
            seq_counter := seq_counter + 1;
            D80 := 2; D81 := r1_origin; D82 := seq_counter;
            r1_state := 14;
        END_IF
    END_IF

14:
    IF r1_drive_shuttle THEN
        a_tgt := origin_station_coord;
        b_tgt := fork_home;
    END_IF
    IF ABS(origin_lift_pos - HOME_D) <= pos_tol AND ABS(origin_lift_vel) <= spd_tol AND X34 THEN
        D302 := r1_last_id;
        IF r1_cancel_flag THEN
            D303 := 2;
        ELSE
            D303 := 1;
        END_IF
        r1_state := 0;
    END_IF

ELSE
    r1_state := 0;
END_CASE

lift_dock_r1 := (r1_state = 1) OR (r1_state = 12) OR (r1_state = 13);
IF lift_dock_r1 THEN
    IF r1_origin = 1 THEN c_tgt := D92; ELSE d_tgt := D92; END_IF
END_IF

(* ============ Cell 3 axis command ============ *)
IF (r0_state = 4) OR (r1_state = 4) THEN
    IF r0_state = 4 THEN
        D700 := r0_last_id; D701 := D520;
    ELSE
        D700 := r1_last_id; D701 := D620;
    END_IF
    D702 := 100;
    Y70 := TRUE;
    s30_tgt := D500;
    IF D501 <> 0 THEN
        s31_tgt := D501;
    ELSE
        theta_cmd_rad := REAL(D500) / 100.0 * pi / 180.0;
        s31_tgt := DINT(-450.0 * SIN(theta_cmd_rad) * 100.0);
    END_IF
ELSIF (r0_state = 5) OR (r0_state = 6) OR (r1_state = 5) OR (r1_state = 6) THEN
    Y71 := TRUE;
    s30_tgt := 0;
    s31_tgt := 0;
ELSE
    s30_tgt := 0;
    s31_tgt := 0;
END_IF

(* ============ Cell 4 axis command ============ *)
IF (r0_state = 9) OR (r1_state = 9) THEN
    IF r0_state = 9 THEN
        D710 := r0_last_id; D711 := D620;
    ELSE
        D710 := r1_last_id; D711 := D620;
    END_IF
    D712 := 100;
    Y75 := TRUE;
    s40_tgt := D600;
    s41_tgt := D601;
ELSIF (r0_state = 10) OR (r0_state = 11) OR (r1_state = 10) OR (r1_state = 11) THEN
    Y76 := TRUE;
    s40_tgt := HOME_S40;
    s41_tgt := 0;
ELSE
    s40_tgt := HOME_S40;
    s41_tgt := 0;
END_IF
s42_tgt := D1032;

(* ============ monitoring moment (not directly commanded) ============ *)
theta_act_rad := REAL(D1016) / 100.0 * pi / 180.0;
x_cw_act := REAL(D1020) / 100.0;
moment3 := 20.0 * 9.81 / 1000.0 * (450.0 * SIN(theta_act_rad) + x_cw_act);

(* ============ lift brake safety ============ *)
lift_stopped := (ABS(D1009) <= spd_tol) AND (ABS(D1013) <= spd_tol);
lift_move_pending := (ABS(c_tgt - D1008) > pos_tol) OR (ABS(d_tgt - D1012) > pos_tol);
Y30 := lift_stopped AND NOT lift_move_pending;

(* ============ write clamped axis outputs ============ *)
D2000 := LIMIT(A_MIN, a_tgt, A_MAX);
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2004 := LIMIT(B_MIN, b_tgt, B_MAX);
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

D2008 := LIMIT(C_MIN, c_tgt, C_MAX);
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

D2012 := LIMIT(D_MIN, d_tgt, D_MAX);
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2016 := LIMIT(S30_MIN, s30_tgt, S30_MAX);
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;

D2020 := LIMIT(S31_MIN, s31_tgt, S31_MAX);
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2024 := LIMIT(S40_MIN, s40_tgt, S40_MAX);
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2028 := LIMIT(S41_MIN, s41_tgt, S41_MAX);
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

D2032 := s42_tgt;
D2033 := 0;
D2034 := 0;
Y48 := FALSE;

(* ============ final completion ============ *)
home_condition :=
    (ABS(D1000) <= pos_tol) AND (ABS(D1001) <= spd_tol) AND
    (ABS(D1004) <= pos_tol) AND (ABS(D1005) <= spd_tol) AND
    (ABS(D1008 - HOME_C) <= pos_tol) AND (ABS(D1009) <= spd_tol) AND
    (ABS(D1012 - HOME_D) <= pos_tol) AND (ABS(D1013) <= spd_tol) AND
    (ABS(D1016) <= ang_tol) AND (ABS(D1017) <= angspd_tol) AND
    (ABS(D1020) <= pos_tol) AND (ABS(D1021) <= spd_tol) AND
    (ABS(D1024 - HOME_S40) <= pos_tol) AND (ABS(D1025) <= spd_tol) AND
    (ABS(D1028) <= pos_tol) AND (ABS(D1029) <= spd_tol) AND
    (ABS(D1032) <= sway_tol) AND (ABS(D1033) <= swayspd_tol) AND
    X51;

y2_timer(IN := home_condition AND NOT y2_latched, PT := T#100ms);
IF y2_timer.Q THEN
    y2_latched := TRUE;
END_IF
Y2 := y2_latched;

END_PROGRAM