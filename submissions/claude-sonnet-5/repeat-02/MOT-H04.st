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

    (* ---- internal variables ---- *)
    pi_const     : REAL := 3.14159265358979;
    tol_pos      : REAL := 0.2;
    tol_vel      : REAL := 1.0;

    pos_a_r, pos_b_r, pos_c_r, pos_d_r         : REAL;
    pos_s30_r, pos_s31_r, pos_s32_r            : REAL;
    pos_s40_r, pos_s41_r                       : REAL;
    vel_a_r, vel_b_r, vel_c_r, vel_d_r         : REAL;
    vel_s30_r, vel_s31_r, vel_s32_r            : REAL;
    vel_s40_r, vel_s41_r                       : REAL;

    home_a       : DINT := 0;
    home_b       : DINT := 0;
    home_c       : DINT := 40000;
    home_d       : DINT := 40000;
    home_s3_0    : DINT := 100000;
    home_s3_1    : DINT := 0;
    home_s4_0    : DINT := 0;
    home_s4_1    : DINT := 0;

    at_a, at_b, at_c, at_d                     : BOOL;
    at_s3_0, at_s3_1, at_s3_2                  : BOOL;
    at_s4_0, at_s4_1                            : BOOL;
    all_axes_home                               : BOOL;

    seq_counter  : DINT := 0;
    edge_p1      : R_TRIG;
    edge_p2      : R_TRIG;
    edge_p3      : R_TRIG;
    edge_p4      : R_TRIG;

    hold_timer         : TON;
    completion_latched : BOOL := FALSE;

    moment4      : REAL;
    theta4_rad   : REAL;
    x4           : REAL;

    r0_acked     : BOOL := FALSE;
    r1_acked     : BOOL := FALSE;
    prev_r0_id   : DINT := -1;
    prev_r1_id   : DINT := -1;
END_VAR

(* ================= convert scaled inputs to physical REAL ================= *)
pos_a_r   := REAL(D1000) / 100.0;
vel_a_r   := REAL(D1001) / 100.0;
pos_b_r   := REAL(D1004) / 100.0;
vel_b_r   := REAL(D1005) / 100.0;
pos_c_r   := REAL(D1008) / 100.0;
vel_c_r   := REAL(D1009) / 100.0;
pos_d_r   := REAL(D1012) / 100.0;
vel_d_r   := REAL(D1013) / 100.0;

pos_s30_r := REAL(D1016) / 100.0;
vel_s30_r := REAL(D1017) / 100.0;
pos_s31_r := REAL(D1020) / 100.0;
vel_s31_r := REAL(D1021) / 100.0;
pos_s32_r := REAL(D1024) / 100.0;
vel_s32_r := REAL(D1025) / 100.0;

pos_s40_r := REAL(D1028) / 100.0;
vel_s40_r := REAL(D1029) / 100.0;
pos_s41_r := REAL(D1032) / 100.0;
vel_s41_r := REAL(D1033) / 100.0;

(* ================= at-home evaluation ================= *)
at_a    := (ABS(pos_a_r - 0.0)   <= tol_pos) AND (ABS(vel_a_r)   <= tol_vel);
at_b    := (ABS(pos_b_r - 0.0)   <= tol_pos) AND (ABS(vel_b_r)   <= tol_vel);
at_c    := (ABS(pos_c_r - 400.0) <= tol_pos) AND (ABS(vel_c_r)   <= tol_vel);
at_d    := (ABS(pos_d_r - 400.0) <= tol_pos) AND (ABS(vel_d_r)   <= tol_vel);

at_s3_0 := (ABS(pos_s30_r - 1000.0) <= tol_pos) AND (ABS(vel_s30_r) <= tol_vel);
at_s3_1 := (ABS(pos_s31_r - 0.0)    <= tol_pos) AND (ABS(vel_s31_r) <= tol_vel);
at_s3_2 := (ABS(pos_s32_r - 0.0)    <= 0.03)    AND (ABS(vel_s32_r) <= 0.15);

at_s4_0 := (ABS(pos_s40_r - 0.0) <= tol_pos) AND (ABS(vel_s40_r) <= tol_vel);
at_s4_1 := (ABS(pos_s41_r - 0.0) <= tol_pos) AND (ABS(vel_s41_r) <= tol_vel);

all_axes_home := at_a AND at_b AND at_c AND at_d AND at_s3_0 AND at_s3_1
                  AND at_s3_2 AND at_s4_0 AND at_s4_1;

(* ================= axis targets (drive toward disclosed home posture) ================= *)
D2000 := home_a;
D2004 := home_b;
D2008 := home_c;
D2012 := home_d;
D2016 := home_s3_0;
D2020 := home_s3_1;
D2024 := D1024;      (* s3_2 externally driven: no PLC target authority, pass through actual *)
D2028 := home_s4_0;
D2032 := home_s4_1;

(* ================= drive ratios (bounded 0..1000, non-negative) ================= *)
IF at_a THEN D2001 := 0; ELSE D2001 := 300; END_IF;
IF at_b THEN D2005 := 0; ELSE D2005 := 300; END_IF;
IF at_c THEN D2009 := 0; ELSE D2009 := 300; END_IF;
IF at_d THEN D2013 := 0; ELSE D2013 := 300; END_IF;
IF at_s3_0 THEN D2017 := 0; ELSE D2017 := 300; END_IF;
IF at_s3_1 THEN D2021 := 0; ELSE D2021 := 300; END_IF;
D2025 := 0;            (* s3_2 externally driven axis: no PLC drive rate *)
IF at_s4_0 THEN D2029 := 0; ELSE D2029 := 300; END_IF;
IF at_s4_1 THEN D2033 := 0; ELSE D2033 := 300; END_IF;

(* ================= feed-forward: none required ================= *)
D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0; D2034 := 0;

(* ================= enables ================= *)
Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := FALSE;   (* s3_2 externally driven: PLC does not command torque *)
Y47 := TRUE;
Y48 := TRUE;

(* ================= cell4 (balanced inclined head) moment safety check ================= *)
theta4_rad := pos_s40_r * pi_const / 180.0;
x4 := pos_s41_r;
moment4 := 20.0 * 9.81 / 1000.0 * (450.0 * SIN(theta4_rad) + x4);
IF ABS(moment4) > 25.0 THEN
    Y47 := FALSE;
    Y48 := FALSE;
END_IF;

(* ================= common brake ================= *)
Y30 := at_a AND at_b;

(* ================= module coordination outputs: passive/safe defaults ================= *)
Y70 := FALSE;
Y71 := FALSE;
D700 := 0;
D701 := 0;
D702 := 0;

Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := 0;
D712 := 0;

(* ================= connection/handoff sequence tracking ================= *)
edge_p1(CLK := X61);
edge_p2(CLK := X62);
edge_p3(CLK := X63);
edge_p4(CLK := X64);
IF edge_p1.Q OR edge_p2.Q OR edge_p3.Q OR edge_p4.Q THEN
    seq_counter := seq_counter + 1;
END_IF;
D82 := seq_counter;
D80 := 0;
D81 := 0;

(* ================= request completion / cancellation acknowledgement ================= *)
IF D100 <> prev_r0_id THEN
    r0_acked   := FALSE;
    prev_r0_id := D100;
END_IF;

IF (NOT r0_acked) THEN
    IF X31 THEN
        IF X30 THEN
            D300 := D100;
            D301 := 2;
            r0_acked := TRUE;
        END_IF;
    ELSE
        IF X30 AND all_axes_home THEN
            D300 := D100;
            D301 := 1;
            r0_acked := TRUE;
        END_IF;
    END_IF;
END_IF;

IF D120 <> prev_r1_id THEN
    r1_acked   := FALSE;
    prev_r1_id := D120;
END_IF;

IF (NOT r1_acked) THEN
    IF X35 THEN
        IF X34 THEN
            D302 := D120;
            D303 := 2;
            r1_acked := TRUE;
        END_IF;
    ELSE
        IF X34 AND all_axes_home THEN
            D302 := D120;
            D303 := 1;
            r1_acked := TRUE;
        END_IF;
    END_IF;
END_IF;

(* ================= final completion: all requests done, home posture, 100ms stability ================= *)
hold_timer(IN := (X51 AND all_axes_home AND (NOT completion_latched)), PT := T#100ms);
IF hold_timer.Q THEN
    completion_latched := TRUE;
END_IF;

Y2 := completion_latched;

END_PROGRAM