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

    (* internal working variables *)
    pi_c            : REAL := 3.14159265358979;
    theta_rad       : REAL;
    s3_1_actual     : REAL;
    moment3         : REAL;
    s3_0_target     : REAL;
    s3_1_target     : REAL;
    s4_0_target     : REAL;
    a_target        : REAL;
    b_target        : REAL;
    c_target        : REAL;
    d_target        : REAL;
    c_vel           : REAL;
    d_vel           : REAL;
    lift_stopped    : BOOL;
    lift_move_cmd   : BOOL;
    req0_active     : BOOL;
    req1_active     : BOOL;
    station_sel     : DINT;
    prev_station    : DINT := -999;
    seq_counter     : DINT := 0;
    c_needs_dock    : BOOL;
    d_needs_dock    : BOOL;
    home_ok         : BOOL;
    completion_ready: BOOL;
    completion_timer: TON;
    y2_latched      : BOOL;
    d_pos_shuttle   : REAL;
    d_pos_fork      : REAL;
    d_pos_c         : REAL;
    d_pos_d         : REAL;
    d_pos_s30       : REAL;
    d_pos_s31       : REAL;
    d_pos_s40       : REAL;
    d_pos_s41       : REAL;
    d_pos_s42       : REAL;
    d_vel_s42       : REAL;
END_VAR

(* ---------- basic physical readbacks ---------- *)
c_vel := REAL(D1009) / 100.0;
d_vel := REAL(D1013) / 100.0;
lift_stopped := (ABS(c_vel) <= 1.0) AND (ABS(d_vel) <= 1.0);

theta_rad   := (REAL(D1016) / 100.0) * pi_c / 180.0;
s3_1_actual := REAL(D1020) / 100.0;
moment3     := 0.1962 * (450.0 * SIN(theta_rad) + s3_1_actual);

(* ---------- cell3 counterweight interlock (keeps |moment| within limits) ---------- *)
IF D501 = 0 THEN
    s3_1_target := -450.0 * SIN(theta_rad);
ELSE
    s3_1_target := REAL(D501) / 100.0;
END_IF;
s3_1_target := MAX(-450.0, MIN(450.0, s3_1_target));

s3_0_target := REAL(D500) / 100.0;
s3_0_target := MAX(-50.0, MIN(50.0, s3_0_target));

(* ---------- cell4 rope length target ---------- *)
IF D600 = 0 THEN
    s4_0_target := 1000.0;
ELSE
    s4_0_target := REAL(D600) / 100.0;
END_IF;
s4_0_target := MAX(500.0, MIN(1500.0, s4_0_target));

(* ---------- request activity ---------- *)
req0_active := (D100 <> 0) AND (NOT X30) AND (NOT X31);
req1_active := (D120 <> 0) AND (NOT X34) AND (NOT X35);

IF req0_active THEN
    station_sel := D101;
ELSIF req1_active THEN
    station_sel := D121;
ELSE
    station_sel := 0;
END_IF;

(* ---------- shuttle target from nominal docking coordinates ---------- *)
CASE station_sel OF
    1: a_target := -3600.0;
    2: a_target := -2300.0;
    3: a_target := 2300.0;
    4: a_target := 9900.0;
ELSE
    a_target := 0.0;
END_CASE;
a_target := MAX(-4500.0, MIN(11300.0, a_target));

(* fork: connect only while addressing a station *)
IF station_sel <> 0 THEN
    b_target := 180.0;
ELSE
    b_target := 0.0;
END_IF;
b_target := MAX(0.0, MIN(180.0, b_target));

(* ---------- lift docking logic ---------- *)
c_needs_dock := (req0_active AND D101 = 1) OR (req1_active AND D121 = 1);
d_needs_dock := (req0_active AND D101 = 2) OR (req1_active AND D121 = 2);

IF c_needs_dock THEN
    c_target := 732.5;
ELSE
    c_target := 150.0;
END_IF;
IF d_needs_dock THEN
    d_target := 732.5;
ELSE
    d_target := 150.0;
END_IF;
c_target := MAX(0.0, MIN(1200.0, c_target));
d_target := MAX(0.0, MIN(1200.0, d_target));

(* ---------- common brake: only close when both lifts stopped and no move commanded ---------- *)
d_pos_c := REAL(D1008) / 100.0;
d_pos_d := REAL(D1012) / 100.0;
lift_move_cmd := (ABS(c_target - d_pos_c) > 0.2) OR (ABS(d_target - d_pos_d) > 0.2);
Y30 := lift_stopped AND (NOT lift_move_cmd);

(* ---------- sequence number handling ---------- *)
IF station_sel <> prev_station THEN
    seq_counter := seq_counter + 1;
    prev_station := station_sel;
END_IF;
D82 := seq_counter;

IF station_sel <> 0 THEN
    D80 := 2; (* placement / approach *)
ELSE
    D80 := 1; (* extraction / retreat *)
END_IF;
D81 := station_sel;

(* ---------- cell3 / cell4 configure & retain handshake ---------- *)
Y70 := (station_sel = 3);
Y71 := X70 OR (station_sel = 3);
Y75 := (station_sel = 4);
Y76 := X75 OR (station_sel = 4);

IF station_sel = 3 THEN
    IF req0_active AND D101 = 3 THEN
        D700 := D100;
    ELSIF req1_active AND D121 = 3 THEN
        D700 := D120;
    ELSE
        D700 := 0;
    END_IF;
    D701 := D526;
    D702 := 100;
ELSE
    D700 := 0;
    D701 := 0;
    D702 := 0;
END_IF;

IF station_sel = 4 THEN
    IF req0_active AND D101 = 4 THEN
        D710 := D100;
    ELSIF req1_active AND D121 = 4 THEN
        D710 := D120;
    ELSE
        D710 := 0;
    END_IF;
    D711 := D626;
    D712 := 100;
ELSE
    D710 := 0;
    D711 := 0;
    D712 := 0;
END_IF;

(* ---------- write shuttle / fork / lift outputs ---------- *)
D2000 := DINT(MAX(-450000.0, MIN(1130000.0, a_target * 100.0)));
D2001 := 300;
D2002 := 0;
Y40   := TRUE;

D2004 := DINT(MAX(0.0, MIN(18000.0, b_target * 100.0)));
D2005 := 300;
D2006 := 0;
Y41   := TRUE;

D2008 := DINT(MAX(0.0, MIN(120000.0, c_target * 100.0)));
D2009 := 300;
D2010 := 0;
Y42   := TRUE;

D2012 := DINT(MAX(0.0, MIN(120000.0, d_target * 100.0)));
D2013 := 300;
D2014 := 0;
Y43   := TRUE;

(* ---------- cell3 axes ---------- *)
D2016 := DINT(MAX(-5000.0, MIN(5000.0, s3_0_target * 100.0)));
D2017 := 300;
D2018 := 0;
Y44   := TRUE;

D2020 := DINT(MAX(-45000.0, MIN(45000.0, s3_1_target * 100.0)));
D2021 := 300;
D2022 := 0;
Y45   := TRUE;

(* ---------- cell4 axes ---------- *)
D2024 := DINT(MAX(50000.0, MIN(150000.0, s4_0_target * 100.0)));
D2025 := 300;
D2026 := 0;
Y46   := TRUE;

(* trolley: acceleration-controlled, hold at rest to keep sway safe *)
D2028 := 0;
D2029 := 0;
D2030 := 0;
Y47   := TRUE;

(* s4_2 sway is externally driven, PLC does not command it *)
D2032 := 0;
D2033 := 0;
D2034 := 0;
Y48   := FALSE;

(* ---------- request completion acknowledgement ---------- *)
IF X30 THEN
    D300 := D100;
    IF X31 THEN
        D301 := 2;
    ELSE
        D301 := 1;
    END_IF;
ELSE
    D300 := 0;
    D301 := 0;
END_IF;

IF X34 THEN
    D302 := D120;
    IF X35 THEN
        D303 := 2;
    ELSE
        D303 := 1;
    END_IF;
ELSE
    D302 := 0;
    D303 := 0;
END_IF;

(* ---------- final completion: all requests done and every axis at home ---------- *)
d_pos_shuttle := REAL(D1000) / 100.0;
d_pos_fork    := REAL(D1004) / 100.0;
d_pos_s30     := REAL(D1016) / 100.0;
d_pos_s31     := REAL(D1020) / 100.0;
d_pos_s40     := REAL(D1024) / 100.0;
d_pos_s41     := REAL(D1028) / 100.0;
d_pos_s42     := REAL(D1032) / 100.0;
d_vel_s42     := REAL(D1033) / 100.0;

home_ok := (ABS(d_pos_shuttle - 0.0) <= 0.3)
       AND (ABS(d_pos_fork - 0.0) <= 0.3)
       AND (ABS(d_pos_c - 150.0) <= 0.2)
       AND (ABS(d_pos_d - 150.0) <= 0.2)
       AND (ABS(d_pos_s30 - 0.0) <= 0.2)
       AND (ABS(d_pos_s31 - 0.0) <= 0.2)
       AND (ABS(d_pos_s40 - 1000.0) <= 0.2)
       AND (ABS(d_pos_s41 - 0.0) <= 0.2)
       AND (ABS(d_pos_s42) <= 0.03)
       AND (ABS(d_vel_s42) <= 0.15)
       AND (ABS(c_vel) <= 1.0)
       AND (ABS(d_vel) <= 1.0);

completion_ready := X51 AND home_ok;

completion_timer(IN := completion_ready, PT := T#100ms);

IF completion_timer.Q THEN
    y2_latched := TRUE;
END_IF;

Y2 := y2_latched;

END_PROGRAM