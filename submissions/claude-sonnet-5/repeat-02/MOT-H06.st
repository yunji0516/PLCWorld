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
    D1036 : DINT;
    D1037 : DINT;
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
    D603 : DINT;
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
    D2036 : DINT;
    D2037 : DINT;
    D2038 : DINT;
    Y49 : BOOL;
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

    (* Add internal variables here. *)
    HOME_A   : DINT := 0;
    HOME_B   : DINT := 0;
    HOME_C   : DINT := 15000;
    HOME_D   : DINT := 15000;
    HOME_S30 : DINT := 0;
    HOME_S31 : DINT := 5000;
    HOME_S40 : DINT := -6500;
    HOME_S41 : DINT := 0;
    HOME_S42 : DINT := 6500;
    HOME_S43 : DINT := 0;
    SAFE_S31 : DINT := 50000;
    SAFE_S41 : DINT := 8000;
    SAFE_S43 : DINT := 8000;
    TOL         : DINT := 20;
    ENTRY_LIMIT : DINT := 4000;

    cell3_cap_active : BOOL;
    cell3_owner      : DINT;
    cell3_cancel_req : BOOL;
    cell3_tgt_angle  : DINT;
    cell3_tgt_ext    : DINT;
    angle_arr3       : BOOL;
    s3_0_cmd         : DINT;
    s3_1_cmd         : DINT;

    cell4_cap_active : BOOL;
    cell4_owner      : DINT;
    cell4_cancel_req : BOOL;
    t_ang0 : DINT;
    t_ext1 : DINT;
    t_ang2 : DINT;
    t_ext3 : DINT;
    angle_arr1 : BOOL;
    angle_arr2 : BOOL;
    s4_0_cmd : DINT;
    s4_1_cmd : DINT;
    s4_2_cmd : DINT;
    s4_3_cmd : DINT;

    a_needs_move : BOOL;
    a_cmd   : DINT;
    a_final : DINT;
    b_cmd   : DINT;
    c_cmd   : DINT;
    d_cmd   : DINT;

    err    : DINT;
    rate_r : REAL;

    r0_ack_done : BOOL;
    r1_ack_done : BOOL;
    c3ok : BOOL;
    c4ok : BOOL;
    shuttle_ok : BOOL;

    all_home : BOOL;
    y2_latch : BOOL;
END_VAR

(* ===================== Cell 3 target computation ===================== *)
cell3_cap_active := D523 <> 0;
cell3_owner      := D522;
cell3_cancel_req := cell3_cap_active AND (((cell3_owner = D100) AND X31) OR ((cell3_owner = D120) AND X35));

IF cell3_cap_active AND NOT cell3_cancel_req THEN
    cell3_tgt_angle := LIMIT(0, D500, 27000);
    cell3_tgt_ext   := LIMIT(0, D501, 74000);
ELSE
    cell3_tgt_angle := HOME_S30;
    cell3_tgt_ext   := HOME_S31;
END_IF;

angle_arr3 := ABS(D1016 - cell3_tgt_angle) <= TOL;

IF D1020 > (SAFE_S31 + TOL) THEN
    s3_1_cmd := SAFE_S31;
    s3_0_cmd := D1016;
ELSE
    s3_0_cmd := cell3_tgt_angle;
    IF angle_arr3 THEN
        s3_1_cmd := cell3_tgt_ext;
    ELSE
        s3_1_cmd := MIN(D1020, SAFE_S31);
    END_IF;
END_IF;

s3_0_cmd := LIMIT(0, s3_0_cmd, 27000);
s3_1_cmd := LIMIT(0, s3_1_cmd, 74000);

(* ===================== Cell 4 target computation ===================== *)
cell4_cap_active := D623 <> 0;
cell4_owner      := D622;
cell4_cancel_req := cell4_cap_active AND (((cell4_owner = D100) AND X31) OR ((cell4_owner = D120) AND X35));

IF cell4_cap_active AND NOT cell4_cancel_req THEN
    t_ang0 := LIMIT(-9000, D600, 9000);
    t_ext1 := LIMIT(0, D601, 65000);
    t_ang2 := LIMIT(-9000, D602, 9000);
    t_ext3 := LIMIT(0, D603, 65000);
ELSE
    t_ang0 := HOME_S40;
    t_ext1 := HOME_S41;
    t_ang2 := HOME_S42;
    t_ext3 := HOME_S43;
END_IF;

angle_arr1 := ABS(D1024 - t_ang0) <= TOL;
IF D1028 > (SAFE_S41 + TOL) THEN
    s4_1_cmd := SAFE_S41;
    s4_0_cmd := D1024;
ELSE
    s4_0_cmd := t_ang0;
    IF angle_arr1 THEN
        s4_1_cmd := t_ext1;
    ELSE
        s4_1_cmd := MIN(D1028, SAFE_S41);
    END_IF;
END_IF;

angle_arr2 := ABS(D1032 - t_ang2) <= TOL;
IF D1036 > (SAFE_S43 + TOL) THEN
    s4_3_cmd := SAFE_S43;
    s4_2_cmd := D1032;
ELSE
    s4_2_cmd := t_ang2;
    IF angle_arr2 THEN
        s4_3_cmd := t_ext3;
    ELSE
        s4_3_cmd := MIN(D1036, SAFE_S43);
    END_IF;
END_IF;

s4_0_cmd := LIMIT(-9000, s4_0_cmd, 9000);
s4_1_cmd := LIMIT(0, s4_1_cmd, 65000);
s4_2_cmd := LIMIT(-9000, s4_2_cmd, 9000);
s4_3_cmd := LIMIT(0, s4_3_cmd, 65000);

(* ===================== Shuttle / fork / lifts ===================== *)
IF D1004 > ENTRY_LIMIT THEN
    a_cmd := D1000; (* freeze shuttle while receiving mechanism deeply entered *)
ELSE
    a_cmd := HOME_A;
END_IF;

a_needs_move := ABS(a_cmd - D1000) > TOL;
IF a_needs_move THEN
    Y30 := FALSE;
    IF X53 THEN
        a_final := a_cmd;
    ELSE
        a_final := D1000;
    END_IF;
ELSE
    Y30 := TRUE;
    a_final := D1000;
END_IF;

b_cmd := HOME_B;
c_cmd := HOME_C;
d_cmd := HOME_D;

(* ===================== Axis output writers ===================== *)
(* a *)
D2000 := LIMIT(-450000, a_final, 730000);
err := D2000 - D1000;
rate_r := LIMIT(0.0, ABS(REAL(err)) * 0.5, 1000.0);
D2001 := DINT(rate_r);
D2002 := 0;
Y40 := TRUE;

(* b *)
D2004 := LIMIT(0, b_cmd, 18000);
err := D2004 - D1004;
rate_r := LIMIT(0.0, ABS(REAL(err)) * 0.5, 1000.0);
D2005 := DINT(rate_r);
D2006 := 0;
Y41 := TRUE;

(* c *)
D2008 := LIMIT(0, c_cmd, 120000);
err := D2008 - D1008;
rate_r := LIMIT(0.0, ABS(REAL(err)) * 0.5, 1000.0);
D2009 := DINT(rate_r);
D2010 := 0;
Y42 := TRUE;

(* d *)
D2012 := LIMIT(0, d_cmd, 120000);
err := D2012 - D1012;
rate_r := LIMIT(0.0, ABS(REAL(err)) * 0.5, 1000.0);
D2013 := DINT(rate_r);
D2014 := 0;
Y43 := TRUE;

(* s3_0 *)
D2016 := s3_0_cmd;
err := D2016 - D1016;
rate_r := LIMIT(0.0, ABS(REAL(err)) * 0.5, 1000.0);
D2017 := DINT(rate_r);
D2018 := 0;
Y44 := TRUE;

(* s3_1 *)
D2020 := s3_1_cmd;
err := D2020 - D1020;
rate_r := LIMIT(0.0, ABS(REAL(err)) * 0.5, 1000.0);
D2021 := DINT(rate_r);
D2022 := 0;
Y45 := TRUE;

(* s4_0 *)
D2024 := s4_0_cmd;
err := D2024 - D1024;
rate_r := LIMIT(0.0, ABS(REAL(err)) * 0.5, 1000.0);
D2025 := DINT(rate_r);
D2026 := 0;
Y46 := TRUE;

(* s4_1 *)
D2028 := s4_1_cmd;
err := D2028 - D1028;
rate_r := LIMIT(0.0, ABS(REAL(err)) * 0.5, 1000.0);
D2029 := DINT(rate_r);
D2030 := 0;
Y47 := TRUE;

(* s4_2 *)
D2032 := s4_2_cmd;
err := D2032 - D1032;
rate_r := LIMIT(0.0, ABS(REAL(err)) * 0.5, 1000.0);
D2033 := DINT(rate_r);
D2034 := 0;
Y48 := TRUE;

(* s4_3 *)
D2036 := s4_3_cmd;
err := D2036 - D1036;
rate_r := LIMIT(0.0, ABS(REAL(err)) * 0.5, 1000.0);
D2037 := DINT(rate_r);
D2038 := 0;
Y49 := TRUE;

(* ===================== Idle/neutral connection-protocol outputs ===================== *)
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
D80 := 0;
D81 := 0;
D82 := 0;

(* ===================== Request completion / cancellation ack ===================== *)
IF NOT r0_ack_done THEN
    IF X30 THEN
        D300 := D100;
        D301 := 1;
        r0_ack_done := TRUE;
    ELSIF X31 THEN
        c3ok := (D522 <> D100) OR (ABS(D1016 - HOME_S30) <= TOL AND ABS(D1020 - HOME_S31) <= TOL);
        c4ok := (D622 <> D100) OR (ABS(D1024 - HOME_S40) <= TOL AND ABS(D1028 - HOME_S41) <= TOL AND
                 ABS(D1032 - HOME_S42) <= TOL AND ABS(D1036 - HOME_S43) <= TOL);
        shuttle_ok := (ABS(D1000 - HOME_A) <= TOL) AND (ABS(D1004 - HOME_B) <= TOL);
        IF c3ok AND c4ok AND shuttle_ok THEN
            D300 := D100;
            D301 := 2;
            r0_ack_done := TRUE;
        END_IF;
    END_IF;
END_IF;

IF NOT r1_ack_done THEN
    IF X34 THEN
        D302 := D120;
        D303 := 1;
        r1_ack_done := TRUE;
    ELSIF X35 THEN
        c3ok := (D522 <> D120) OR (ABS(D1016 - HOME_S30) <= TOL AND ABS(D1020 - HOME_S31) <= TOL);
        c4ok := (D622 <> D120) OR (ABS(D1024 - HOME_S40) <= TOL AND ABS(D1028 - HOME_S41) <= TOL AND
                 ABS(D1032 - HOME_S42) <= TOL AND ABS(D1036 - HOME_S43) <= TOL);
        shuttle_ok := (ABS(D1000 - HOME_A) <= TOL) AND (ABS(D1004 - HOME_B) <= TOL);
        IF c3ok AND c4ok AND shuttle_ok THEN
            D302 := D120;
            D303 := 2;
            r1_ack_done := TRUE;
        END_IF;
    END_IF;
END_IF;

(* ===================== Final completion (Y2) ===================== *)
all_home := (ABS(D1000 - HOME_A) <= TOL) AND (ABS(D1004 - HOME_B) <= TOL) AND
            (ABS(D1008 - HOME_C) <= TOL) AND (ABS(D1012 - HOME_D) <= TOL) AND
            (ABS(D1016 - HOME_S30) <= TOL) AND (ABS(D1020 - HOME_S31) <= TOL) AND
            (ABS(D1024 - HOME_S40) <= TOL) AND (ABS(D1028 - HOME_S41) <= TOL) AND
            (ABS(D1032 - HOME_S42) <= TOL) AND (ABS(D1036 - HOME_S43) <= TOL);

IF (NOT y2_latch) AND X51 AND all_home THEN
    y2_latch := TRUE;
END_IF;

Y2 := y2_latch;

END_PROGRAM