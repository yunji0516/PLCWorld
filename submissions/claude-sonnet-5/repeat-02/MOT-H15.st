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

    (* ---- internal working memory ---- *)
    phase        : INT := 0;
    cur_req      : INT := 0;
    cur_location : DINT := 0;
    cur_record   : DINT := 0;
    cur_cancelled_live : BOOL := FALSE;

    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;

    seq_counter : DINT := 0;
    pocket_sel  : DINT := 0;

    dock1 : REAL := -4050.0;
    dock2 : REAL := -1850.0;
    dock3 : REAL := 0.0;
    dock4 : REAL := 3750.0;
    dock_height_r : REAL := 950.0;

    tgt_a : REAL := 0.0;
    tgt_b : REAL := 0.0;
    tgt_c : REAL := 400.0;
    tgt_d : REAL := 400.0;
    tgt_s3_0 : DINT := 0;
    tgt_s3_1 : DINT := 0;
    tgt_s3_2 : DINT := 0;
    tgt_s4_0 : DINT := 0;
    tgt_s4_1 : DINT := 0;
    tgt_s4_2 : DINT := 0;

    arrive_a  : BOOL := FALSE;
    arrive_b  : BOOL := FALSE;
    arrive_c  : BOOL := FALSE;
    arrive_d  : BOOL := FALSE;
    arrive_s3_0 : BOOL := FALSE;
    arrive_s3_1 : BOOL := FALSE;
    arrive_s3_2 : BOOL := FALSE;
    arrive_s4_0 : BOOL := FALSE;
    arrive_s4_1 : BOOL := FALSE;
    arrive_s4_2 : BOOL := FALSE;

    pi_const : REAL := 3.14159265;
    ang_a_rad : REAL := 0.0;
    ang_b_rad : REAL := 0.0;
    moment3   : REAL := 0.0;
    moment_ok : BOOL := FALSE;

    home_a_ok : BOOL := FALSE;
    home_b_ok : BOOL := FALSE;
    home_c_ok : BOOL := FALSE;
    home_d_ok : BOOL := FALSE;
    home_s3_ok : BOOL := FALSE;
    home_s4_ok : BOOL := FALSE;
    y2_cond    : BOOL := FALSE;
    y2_latched : BOOL := FALSE;

    port_ready : BOOL := FALSE;

    edge_r0 : R_TRIG;
    edge_r1 : R_TRIG;
    y2_timer : TON;
END_VAR

(* =========================================================
   1) Arrival flags - compare current inputs to previously
      commanded targets (outputs from last scan)
   ========================================================= *)
arrive_a := (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100);
arrive_b := (ABS(D1004 - D2004) <= 20) AND (ABS(D1005) <= 100);
arrive_c := (ABS(D1008 - D2008) <= 20) AND (ABS(D1009) <= 100);
arrive_d := (ABS(D1012 - D2012) <= 20) AND (ABS(D1013) <= 100);
arrive_s3_0 := (ABS(D1016 - D2016) <= 20) AND (ABS(D1017) <= 100);
arrive_s3_1 := (ABS(D1020 - D2020) <= 20) AND (ABS(D1021) <= 100);
arrive_s3_2 := (ABS(D1024 - D2024) <= 20) AND (ABS(D1025) <= 100);
arrive_s4_0 := (ABS(D1028 - D2028) <= 20) AND (ABS(D1029) <= 100);
arrive_s4_1 := (ABS(D1032 - D2032) <= 20) AND (ABS(D1033) <= 100);
arrive_s4_2 := (ABS(D1036 - D2036) <= 20) AND (ABS(D1037) <= 100);

(* =========================================================
   2) Cancellation interrupt - jump straight to return leg
   ========================================================= *)
cur_cancelled_live := (cur_req = 0 AND X31) OR (cur_req = 1 AND X35);
IF cur_cancelled_live AND phase > 0 AND phase < 70 THEN
    Y70 := FALSE;
    Y71 := FALSE;
    Y75 := FALSE;
    Y76 := FALSE;
    phase := 70;
END_IF;

(* =========================================================
   3) Continuous interlocking counterweight balancing (cell3)
      x = -225*(sinA+sinB), unless an explicit goal2 is given
   ========================================================= *)
ang_a_rad := (REAL(D1016) / 100.0) * pi_const / 180.0;
ang_b_rad := (REAL(D1020) / 100.0) * pi_const / 180.0;
IF D502 <> 0 THEN
    tgt_s3_2 := D502;
ELSE
    tgt_s3_2 := DINT(-225.0 * (SIN(ang_a_rad) + SIN(ang_b_rad)) * 100.0);
END_IF;

moment3 := 20.0 * 9.81 / 1000.0 * (225.0 * (SIN(ang_a_rad) + SIN(ang_b_rad)) + (REAL(D1024) / 100.0));
moment_ok := ABS(moment3) <= 1.0;

IF D92 <> 0 THEN
    dock_height_r := REAL(D92) / 100.0;
ELSE
    dock_height_r := 950.0;
END_IF;

(* =========================================================
   4) Main sequencing state machine
   ========================================================= *)
CASE phase OF

0: (* SELECT *)
    IF NOT req0_done THEN
        cur_req := 0;
        cur_location := D101;
        cur_record := D104;
        IF X31 THEN
            phase := 85;
        ELSE
            phase := 5;
        END_IF;
    ELSIF NOT req1_done THEN
        cur_req := 1;
        cur_location := D121;
        cur_record := D124;
        IF X35 THEN
            phase := 85;
        ELSE
            phase := 5;
        END_IF;
    ELSE
        phase := 100;
    END_IF;

5: (* EXTRACT_FROM_LIFT : raise/connect on originating lift *)
    tgt_c := dock_height_r;
    tgt_d := dock_height_r;
    IF cur_location = 1 THEN
        tgt_a := dock1;
        port_ready := X61;
    ELSE
        tgt_a := dock2;
        port_ready := X62;
    END_IF;
    tgt_b := 180.0;
    seq_counter := seq_counter + 1;
    D80 := 1;
    D81 := cur_location;
    D82 := seq_counter;
    IF arrive_a AND arrive_b AND arrive_c AND arrive_d AND port_ready THEN
        phase := 10;
    END_IF;

10: (* LOWER_AND_DEPART *)
    tgt_c := 400.0;
    tgt_d := 400.0;
    tgt_b := 0.0;
    IF arrive_c AND arrive_d AND arrive_b THEN
        phase := 15;
    END_IF;

15: (* MOVE_TO_CELL3 *)
    tgt_a := dock3;
    tgt_b := 180.0;
    seq_counter := seq_counter + 1;
    D80 := 2;
    D81 := 3;
    D82 := seq_counter;
    IF arrive_a AND arrive_b AND X63 THEN
        phase := 20;
    END_IF;

20: (* CELL3_CONFIG *)
    tgt_s3_0 := D500;
    tgt_s3_1 := D501;
    Y70 := TRUE;
    D700 := D520;
    D701 := D526;
    D702 := 500;
    IF X70 AND moment_ok THEN
        Y71 := TRUE;
        phase := 30;
    END_IF;

30: (* CELL3_WITHDRAW *)
    Y70 := FALSE;
    Y71 := FALSE;
    tgt_s3_0 := 0;
    tgt_s3_1 := 0;
    IF arrive_s3_0 AND arrive_s3_1 AND arrive_s3_2 THEN
        tgt_b := 0.0;
        IF arrive_b THEN
            phase := 40;
        END_IF;
    END_IF;

40: (* MOVE_TO_CELL4 *)
    tgt_a := dock4;
    tgt_b := 180.0;
    seq_counter := seq_counter + 1;
    D80 := 2;
    D81 := 4;
    D82 := seq_counter;
    IF arrive_a AND arrive_b AND X64 THEN
        phase := 50;
    END_IF;

50: (* CELL4_ENGAGE axis 0 *)
    IF cur_record < 0 THEN
        pocket_sel := 1;
    ELSE
        pocket_sel := 2;
    END_IF;
    tgt_s4_0 := D600;
    IF arrive_s4_0 THEN
        phase := 51;
    END_IF;

51: (* CELL4_ENGAGE axis 1 *)
    tgt_s4_1 := D601;
    IF arrive_s4_1 THEN
        phase := 52;
    END_IF;

52: (* CELL4_ENGAGE axis 2 *)
    tgt_s4_2 := D602;
    IF arrive_s4_2 THEN
        phase := 53;
    END_IF;

53: (* CELL4_SERVE_WAIT *)
    Y75 := TRUE;
    D710 := pocket_sel;
    D711 := D626;
    D712 := 500;
    IF X75 THEN
        Y76 := TRUE;
        phase := 60;
    END_IF;

60: (* CELL4_WITHDRAW *)
    Y75 := FALSE;
    Y76 := FALSE;
    tgt_s4_0 := 0;
    tgt_s4_1 := 0;
    tgt_s4_2 := 0;
    IF arrive_s4_0 AND arrive_s4_1 AND arrive_s4_2 THEN
        tgt_b := 0.0;
        IF arrive_b THEN
            phase := 70;
        END_IF;
    END_IF;

70: (* RETURN_TO_LIFT_MOVE *)
    IF cur_location = 1 THEN
        tgt_a := dock1;
        port_ready := X61;
    ELSE
        tgt_a := dock2;
        port_ready := X62;
    END_IF;
    tgt_b := 180.0;
    seq_counter := seq_counter + 1;
    D80 := 1;
    D81 := cur_location;
    D82 := seq_counter;
    IF arrive_a AND arrive_b AND port_ready THEN
        phase := 75;
    END_IF;

75: (* RAISE_FOR_PLACEMENT *)
    tgt_c := dock_height_r;
    tgt_d := dock_height_r;
    IF arrive_c AND arrive_d THEN
        tgt_b := 0.0;
        IF arrive_b THEN
            phase := 80;
        END_IF;
    END_IF;

80: (* LOWER_TO_HOME *)
    tgt_c := 400.0;
    tgt_d := 400.0;
    IF arrive_c AND arrive_d THEN
        phase := 85;
    END_IF;

85: (* WAIT_ACK *)
    IF (cur_req = 0 AND req0_done) OR (cur_req = 1 AND req1_done) THEN
        phase := 0;
    END_IF;

100: (* GO_HOME_FINAL *)
    tgt_a := 0.0;
    tgt_b := 0.0;
    tgt_c := 400.0;
    tgt_d := 400.0;
    tgt_s3_0 := 0;
    tgt_s3_1 := 0;
    tgt_s4_0 := 0;
    tgt_s4_1 := 0;
    tgt_s4_2 := 0;

ELSE
    phase := 0;
END_CASE;

(* =========================================================
   5) Clamp & write axis outputs (always enabled)
   ========================================================= *)
tgt_a := LIMIT(-4500.0, tgt_a, 4500.0);
tgt_b := LIMIT(0.0, tgt_b, 180.0);
tgt_c := LIMIT(0.0, tgt_c, 1200.0);
tgt_d := LIMIT(0.0, tgt_d, 1200.0);
tgt_s3_0 := LIMIT(-5000, tgt_s3_0, 5000);
tgt_s3_1 := LIMIT(-5000, tgt_s3_1, 5000);
tgt_s3_2 := LIMIT(-45000, tgt_s3_2, 45000);
tgt_s4_0 := LIMIT(0, tgt_s4_0, 100000);
tgt_s4_1 := LIMIT(0, tgt_s4_1, 100000);
tgt_s4_2 := LIMIT(0, tgt_s4_2, 100000);

D2000 := DINT(tgt_a * 100.0);
D2001 := 500;
D2002 := 0;
Y40 := TRUE;

D2004 := DINT(tgt_b * 100.0);
D2005 := 500;
D2006 := 0;
Y41 := TRUE;

D2008 := DINT(tgt_c * 100.0);
D2009 := 500;
D2010 := 0;
Y42 := TRUE;

D2012 := DINT(tgt_d * 100.0);
D2013 := 500;
D2014 := 0;
Y43 := TRUE;

D2016 := tgt_s3_0;
D2017 := 500;
D2018 := 0;
Y44 := TRUE;

D2020 := tgt_s3_1;
D2021 := 500;
D2022 := 0;
Y45 := TRUE;

D2024 := tgt_s3_2;
D2025 := 500;
D2026 := 0;
Y46 := TRUE;

D2028 := tgt_s4_0;
D2029 := 500;
D2030 := 0;
Y47 := TRUE;

D2032 := tgt_s4_1;
D2033 := 500;
D2034 := 0;
Y48 := TRUE;

D2036 := tgt_s4_2;
D2037 := 500;
D2038 := 0;
Y49 := TRUE;

(* =========================================================
   6) Ack / status responder (reacts to device confirmation)
   ========================================================= *)
edge_r0(CLK := X30);
IF edge_r0.Q THEN
    D300 := D100;
    IF X31 THEN
        D301 := 2;
    ELSE
        D301 := 1;
    END_IF;
    req0_done := TRUE;
END_IF;

edge_r1(CLK := X34);
IF edge_r1.Q THEN
    D302 := D120;
    IF X35 THEN
        D303 := 2;
    ELSE
        D303 := 1;
    END_IF;
    req1_done := TRUE;
END_IF;

(* =========================================================
   7) Overall completion (Y2) - all done, all axes home
   ========================================================= *)
home_a_ok := (ABS(D1000 - 0) <= 20) AND (ABS(D1001) <= 100);
home_b_ok := (ABS(D1004 - 0) <= 20) AND (ABS(D1005) <= 100);
home_c_ok := (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100);
home_d_ok := (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100);
home_s3_ok := (ABS(D1016 - 0) <= 20) AND (ABS(D1020 - 0) <= 20) AND (ABS(D1024 - 0) <= 20);
home_s4_ok := (ABS(D1028 - 0) <= 20) AND (ABS(D1032 - 0) <= 20) AND (ABS(D1036 - 0) <= 20);

y2_cond := X51 AND home_a_ok AND home_b_ok AND home_c_ok AND home_d_ok AND home_s3_ok AND home_s4_ok;

y2_timer(IN := y2_cond, PT := T#100ms);
IF y2_timer.Q THEN
    y2_latched := TRUE;
END_IF;
Y2 := y2_latched;

(* =========================================================
   8) Brake control - engaged while shuttle/fork stopped
   ========================================================= *)
Y30 := arrive_a AND arrive_b;

END_PROGRAM