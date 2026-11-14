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

    (* --- internal variables --- *)
    home_a_raw    : DINT := 0;
    home_b_raw    : DINT := 0;
    home_c_raw    : DINT := 15000;
    home_d_raw    : DINT := 15000;
    home_s3_0_raw : DINT := 0;
    home_s3_1_raw : DINT := 5000;
    home_s4_0_raw : DINT := -6500;
    home_s4_1_raw : DINT := 0;
    home_s4_2_raw : DINT := 6500;
    home_s4_3_raw : DINT := 0;

    pos_tol       : DINT := 20;    (* 0.2 unit * 100 *)
    vel_tol       : DINT := 100;   (* 1 unit * 100 *)
    boom_ret_lim  : DINT := 8000;  (* 80 mm * 100 *)
    slide_rot_lim : DINT := 50000; (* 500 mm * 100 *)
    entry_lim     : DINT := 4000;  (* 40 mm * 100 *)

    drive_rate    : DINT := 400;   (* fixed 0.4 fraction, above 0.02 floor *)

    entry_deep       : BOOL;
    boom_retract_ok  : BOOL;
    table_rotate_ok  : BOOL;

    at_home_a    : BOOL;
    at_home_b    : BOOL;
    at_home_c    : BOOL;
    at_home_d    : BOOL;
    at_home_s3_0 : BOOL;
    at_home_s3_1 : BOOL;
    at_home_s4_0 : BOOL;
    at_home_s4_1 : BOOL;
    at_home_s4_2 : BOOL;
    at_home_s4_3 : BOOL;
    all_settled  : BOOL;
    qualifying   : BOOL;

    a_tgt      : DINT;
    b_tgt      : DINT;
    c_tgt      : DINT;
    d_tgt      : DINT;
    s3_0_tgt   : DINT;
    s3_1_tgt   : DINT;
    s4_0_tgt   : DINT;
    s4_1_tgt   : DINT;
    s4_2_tgt   : DINT;
    s4_3_tgt   : DINT;

    hold_timer : TON;
END_VAR

(* ---------------- Safety interlock: entry depth on fork axis b ---------------- *)
entry_deep := ABS(D1004) > entry_lim;

(* boom (cell 4) must retract to <=80mm before swiveling *)
boom_retract_ok := (D1028 <= boom_ret_lim) AND (D1036 <= boom_ret_lim);

(* table (cell 3) slide must be <=500mm before rotating *)
table_rotate_ok := (D1020 <= slide_rot_lim);

(* ---------------- Compute targets ---------------- *)

(* shuttle X *)
IF entry_deep THEN
    a_tgt := D1000;
ELSE
    a_tgt := home_a_raw;
END_IF;

(* connection fork always retracts toward 0 (retrieval position) *)
b_tgt := home_b_raw;

(* lifts A/B always to initial height *)
c_tgt := home_c_raw;
d_tgt := home_d_raw;

(* cell 3 : table swivel gated by slide retracted, slide always driven home *)
IF entry_deep THEN
    s3_0_tgt := D1016;
    s3_1_tgt := D1020;
ELSE
    IF table_rotate_ok THEN
        s3_0_tgt := home_s3_0_raw;
    ELSE
        s3_0_tgt := D1016;
    END_IF;
    s3_1_tgt := home_s3_1_raw;
END_IF;

(* cell 4 : boom swivel gated by extension retracted, extension always driven home *)
IF entry_deep THEN
    s4_0_tgt := D1024;
    s4_2_tgt := D1032;
    s4_1_tgt := D1028;
    s4_3_tgt := D1036;
ELSE
    IF boom_retract_ok THEN
        s4_0_tgt := home_s4_0_raw;
        s4_2_tgt := home_s4_2_raw;
    ELSE
        s4_0_tgt := D1024;
        s4_2_tgt := D1032;
    END_IF;
    s4_1_tgt := home_s4_1_raw;
    s4_3_tgt := home_s4_3_raw;
END_IF;

(* ---------------- Arrival / settling checks ---------------- *)
at_home_a    := (ABS(D1000 - home_a_raw)    <= pos_tol) AND (ABS(D1001) <= vel_tol);
at_home_b    := (ABS(D1004 - home_b_raw)    <= pos_tol) AND (ABS(D1005) <= vel_tol);
at_home_c    := (ABS(D1008 - home_c_raw)    <= pos_tol) AND (ABS(D1009) <= vel_tol);
at_home_d    := (ABS(D1012 - home_d_raw)    <= pos_tol) AND (ABS(D1013) <= vel_tol);
at_home_s3_0 := (ABS(D1016 - home_s3_0_raw) <= pos_tol) AND (ABS(D1017) <= vel_tol);
at_home_s3_1 := (ABS(D1020 - home_s3_1_raw) <= pos_tol) AND (ABS(D1021) <= vel_tol);
at_home_s4_0 := (ABS(D1024 - home_s4_0_raw) <= pos_tol) AND (ABS(D1025) <= vel_tol);
at_home_s4_1 := (ABS(D1028 - home_s4_1_raw) <= pos_tol) AND (ABS(D1029) <= vel_tol);
at_home_s4_2 := (ABS(D1032 - home_s4_2_raw) <= pos_tol) AND (ABS(D1033) <= vel_tol);
at_home_s4_3 := (ABS(D1036 - home_s4_3_raw) <= pos_tol) AND (ABS(D1037) <= vel_tol);

all_settled := at_home_a AND at_home_b AND at_home_c AND at_home_d AND
               at_home_s3_0 AND at_home_s3_1 AND
               at_home_s4_0 AND at_home_s4_1 AND at_home_s4_2 AND at_home_s4_3;

(* ---------------- Drive outputs ---------------- *)
IF all_settled THEN
    (* fully returned to initial connection posture: disable drives, hold with brake *)
    Y40 := FALSE; Y41 := FALSE; Y42 := FALSE; Y43 := FALSE;
    Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE; Y48 := FALSE; Y49 := FALSE;

    D2000 := home_a_raw;    D2004 := home_b_raw;    D2008 := home_c_raw;    D2012 := home_d_raw;
    D2016 := home_s3_0_raw; D2020 := home_s3_1_raw;
    D2024 := home_s4_0_raw; D2028 := home_s4_1_raw; D2032 := home_s4_2_raw; D2036 := home_s4_3_raw;

    D2001 := 0; D2005 := 0; D2009 := 0; D2013 := 0;
    D2017 := 0; D2021 := 0; D2025 := 0; D2029 := 0; D2033 := 0; D2037 := 0;

    D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
    D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0; D2034 := 0; D2038 := 0;

    Y30 := TRUE; (* engage common brake while at rest *)
ELSE
    Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
    Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE; Y49 := TRUE;

    D2000 := a_tgt;    D2004 := b_tgt;    D2008 := c_tgt;    D2012 := d_tgt;
    D2016 := s3_0_tgt; D2020 := s3_1_tgt;
    D2024 := s4_0_tgt; D2028 := s4_1_tgt; D2032 := s4_2_tgt; D2036 := s4_3_tgt;

    D2001 := drive_rate; D2005 := drive_rate; D2009 := drive_rate; D2013 := drive_rate;
    D2017 := drive_rate; D2021 := drive_rate; D2025 := drive_rate; D2029 := drive_rate; D2033 := drive_rate; D2037 := drive_rate;

    D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
    D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0; D2034 := 0; D2038 := 0;

    Y30 := FALSE; (* release brake while motion is required *)
END_IF;

(* ---------------- Cell handshake outputs held neutral/safe ---------------- *)
Y70 := FALSE; Y71 := FALSE;
D700 := 0; D701 := 0; D702 := 0;
Y75 := FALSE; Y76 := FALSE;
D710 := 0; D711 := 0; D712 := 0;
D80 := 0; D81 := 0; D82 := 0;

(* ---------------- Request completion / cancellation-retrieval acknowledgement ---------------- *)
IF X30 THEN
    D300 := D100;
    D301 := 1;
ELSIF X31 THEN
    D300 := D100;
    D301 := 2;
END_IF;

IF X34 THEN
    D302 := D120;
    D303 := 1;
ELSIF X35 THEN
    D302 := D120;
    D303 := 2;
END_IF;

(* ---------------- Final completion latch ---------------- *)
qualifying := X51 AND all_settled;
hold_timer(IN := qualifying, PT := T#100ms);

IF hold_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM