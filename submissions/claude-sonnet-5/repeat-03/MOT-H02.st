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

    (* internal state *)
    state       : INT := 0;
    prev_state  : INT := -1;
    state_entered : BOOL := FALSE;

    active_req  : INT := 0;
    cur_id      : DINT := 0;
    cur_location: DINT := 0;
    cur_cancelled : BOOL := FALSE;
    cur_station : DINT := 1;
    cur_station_x : DINT := 0;
    cur_lift_is_c : BOOL := TRUE;

    last_id0 : DINT := 0;
    last_id1 : DINT := 0;

    seq_no : DINT := 0;
    y2_declared : BOOL := FALSE;

    tgt_a : DINT := 0;
    tgt_b : DINT := 0;
    tgt_c : DINT := 40000;
    tgt_d : DINT := 40000;
    tgt_s3_0 : DINT := -60000;
    tgt_s3_1 : DINT := -60000;
    tgt_s4_0 : DINT := -60000;
    tgt_s4_1 : DINT := -60000;

    origin_s4_0 : DINT := 0;
    origin_s4_1 : DINT := 0;
    new_tgt_s4_0 : DINT := 0;
    new_tgt_s4_1 : DINT := 0;

    pos_ok : BOOL := FALSE;
    port_ready : BOOL := FALSE;
    speeds_ok : BOOL := FALSE;
    y2_cond : BOOL := FALSE;

    settle_timer : TON;
    hold_timer : TON;

    POS_TOL : DINT := 20;
    SPEED_TOL : DINT := 100;

    STATION1 : DINT := -405000;
    STATION2 : DINT := -185000;
    STATION3 : DINT := 0;
    STATION4 : DINT := 470000;

    HOME_C : DINT := 40000;
    HOME_D : DINT := 40000;
    HOME_S3_0 : DINT := -60000;
    HOME_S3_1 : DINT := -60000;
    HOME_S4_0 : DINT := -60000;
    HOME_S4_1 : DINT := -60000;

    CONNECT_POS : DINT := 18000;
END_VAR

state_entered := (state <> prev_state);
Y75 := FALSE;

CASE state OF

0: (* IDLE - select next request *)
   IF (D100 <> 0) AND (D100 <> last_id0) THEN
       active_req := 0;
       cur_id := D100;
       cur_location := D101;
       cur_cancelled := X31;
       IF cur_location = 1 THEN
           cur_station := 1; cur_station_x := STATION1; cur_lift_is_c := TRUE;
       ELSE
           cur_station := 2; cur_station_x := STATION2; cur_lift_is_c := FALSE;
       END_IF;
       state := 1;
   ELSIF (D120 <> 0) AND (D120 <> last_id1) THEN
       active_req := 1;
       cur_id := D120;
       cur_location := D121;
       cur_cancelled := X35;
       IF cur_location = 1 THEN
           cur_station := 1; cur_station_x := STATION1; cur_lift_is_c := TRUE;
       ELSE
           cur_station := 2; cur_station_x := STATION2; cur_lift_is_c := FALSE;
       END_IF;
       state := 1;
   END_IF;

1: (* LIFT_TO_DOCK *)
   IF cur_lift_is_c THEN
       tgt_c := D92;
       pos_ok := (ABS(D1008 - D92) <= POS_TOL) AND (ABS(D1009) <= SPEED_TOL);
   ELSE
       tgt_d := D92;
       pos_ok := (ABS(D1012 - D92) <= POS_TOL) AND (ABS(D1013) <= SPEED_TOL);
   END_IF;
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 2; END_IF;

2: (* MOVE_TO_S1 *)
   tgt_a := cur_station_x; tgt_b := 0;
   pos_ok := (ABS(D1000 - tgt_a) <= POS_TOL) AND (ABS(D1001) <= SPEED_TOL)
         AND (ABS(D1004 - tgt_b) <= POS_TOL) AND (ABS(D1005) <= SPEED_TOL);
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 3; END_IF;

3: (* CONNECT_S1 *)
   IF state_entered THEN
       seq_no := seq_no + 1;
       D80 := 1; D81 := cur_station; D82 := seq_no;
   END_IF;
   tgt_b := CONNECT_POS;
   port_ready := (cur_station = 1 AND X61) OR (cur_station = 2 AND X62);
   pos_ok := (ABS(D1004 - CONNECT_POS) <= POS_TOL) AND (ABS(D1005) <= SPEED_TOL) AND port_ready;
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 4; END_IF;

4: (* DISCONNECT_S1 *)
   tgt_b := 0;
   pos_ok := (ABS(D1004 - 0) <= POS_TOL) AND (ABS(D1005) <= SPEED_TOL);
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 5; END_IF;

5: (* LIFT_RETRACT_HOME *)
   IF cur_lift_is_c THEN
       tgt_c := HOME_C;
       pos_ok := (ABS(D1008 - HOME_C) <= POS_TOL) AND (ABS(D1009) <= SPEED_TOL);
   ELSE
       tgt_d := HOME_D;
       pos_ok := (ABS(D1012 - HOME_D) <= POS_TOL) AND (ABS(D1013) <= SPEED_TOL);
   END_IF;
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN
       IF cur_cancelled THEN state := 18; ELSE state := 6; END_IF;
   END_IF;

6: (* MOVE_TO_S3 *)
   tgt_a := STATION3; tgt_b := 0;
   pos_ok := (ABS(D1000 - STATION3) <= POS_TOL) AND (ABS(D1001) <= SPEED_TOL)
         AND (ABS(D1004 - 0) <= POS_TOL) AND (ABS(D1005) <= SPEED_TOL);
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 7; END_IF;

7: (* CONNECT_S3 *)
   IF state_entered THEN
       seq_no := seq_no + 1;
       D80 := 1; D81 := 3; D82 := seq_no;
   END_IF;
   tgt_b := CONNECT_POS;
   port_ready := X63;
   pos_ok := (ABS(D1004 - CONNECT_POS) <= POS_TOL) AND (ABS(D1005) <= SPEED_TOL) AND port_ready;
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 8; END_IF;

8: (* CELL3_PROCESS *)
   tgt_s3_0 := D500; tgt_s3_1 := D501;
   IF X70 THEN state := 9; END_IF;

9: (* DISCONNECT_S3 *)
   tgt_b := 0;
   pos_ok := (ABS(D1004 - 0) <= POS_TOL) AND (ABS(D1005) <= SPEED_TOL);
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 10; END_IF;

10: (* PARK_S3 *)
   tgt_s3_0 := HOME_S3_0; tgt_s3_1 := HOME_S3_1;
   pos_ok := (ABS(D1016 - HOME_S3_0) <= POS_TOL) AND (ABS(D1017) <= SPEED_TOL)
         AND (ABS(D1020 - HOME_S3_1) <= POS_TOL) AND (ABS(D1021) <= SPEED_TOL);
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 11; END_IF;

11: (* MOVE_TO_S4 *)
   tgt_a := STATION4; tgt_b := 0;
   pos_ok := (ABS(D1000 - STATION4) <= POS_TOL) AND (ABS(D1001) <= SPEED_TOL)
         AND (ABS(D1004 - 0) <= POS_TOL) AND (ABS(D1005) <= SPEED_TOL);
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 12; END_IF;

12: (* CONNECT_S4 *)
   IF state_entered THEN
       seq_no := seq_no + 1;
       D80 := 1; D81 := 4; D82 := seq_no;
   END_IF;
   tgt_b := CONNECT_POS;
   port_ready := X64;
   pos_ok := (ABS(D1004 - CONNECT_POS) <= POS_TOL) AND (ABS(D1005) <= SPEED_TOL) AND port_ready;
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 13; END_IF;

13: (* CONFIGURE_CAPTURE - reference set while stopped *)
   Y75 := TRUE;
   speeds_ok := (ABS(D1025) <= SPEED_TOL) AND (ABS(D1029) <= SPEED_TOL);
   IF speeds_ok THEN
       origin_s4_0 := D1024; origin_s4_1 := D1028;
       new_tgt_s4_0 := origin_s4_0 + D600;
       new_tgt_s4_1 := origin_s4_1 + D601;
   END_IF;
   settle_timer(IN := speeds_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 14; END_IF;

14: (* CONFIGURE_RELEASE - deassert before moving *)
   Y75 := FALSE;
   tgt_s4_0 := new_tgt_s4_0;
   tgt_s4_1 := new_tgt_s4_1;
   state := 15;

15: (* CELL4_PROCESS *)
   IF X75 THEN state := 16; END_IF;

16: (* DISCONNECT_S4 *)
   tgt_b := 0;
   pos_ok := (ABS(D1004 - 0) <= POS_TOL) AND (ABS(D1005) <= SPEED_TOL);
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 17; END_IF;

17: (* PARK_S4 *)
   tgt_s4_0 := HOME_S4_0; tgt_s4_1 := HOME_S4_1;
   pos_ok := (ABS(D1024 - HOME_S4_0) <= POS_TOL) AND (ABS(D1025) <= SPEED_TOL)
         AND (ABS(D1028 - HOME_S4_1) <= POS_TOL) AND (ABS(D1029) <= SPEED_TOL);
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 18; END_IF;

18: (* MOVE_TO_S1_RETURN *)
   tgt_a := cur_station_x; tgt_b := 0;
   pos_ok := (ABS(D1000 - tgt_a) <= POS_TOL) AND (ABS(D1001) <= SPEED_TOL)
         AND (ABS(D1004 - 0) <= POS_TOL) AND (ABS(D1005) <= SPEED_TOL);
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 19; END_IF;

19: (* LIFT_RAISE_FOR_RETURN *)
   IF cur_lift_is_c THEN
       tgt_c := D92;
       pos_ok := (ABS(D1008 - D92) <= POS_TOL) AND (ABS(D1009) <= SPEED_TOL);
   ELSE
       tgt_d := D92;
       pos_ok := (ABS(D1012 - D92) <= POS_TOL) AND (ABS(D1013) <= SPEED_TOL);
   END_IF;
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 20; END_IF;

20: (* CONNECT_S1_RETURN - placement back *)
   IF state_entered THEN
       seq_no := seq_no + 1;
       D80 := 2; D81 := cur_station; D82 := seq_no;
   END_IF;
   tgt_b := CONNECT_POS;
   port_ready := (cur_station = 1 AND X61) OR (cur_station = 2 AND X62);
   pos_ok := (ABS(D1004 - CONNECT_POS) <= POS_TOL) AND (ABS(D1005) <= SPEED_TOL) AND port_ready;
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 21; END_IF;

21: (* DISCONNECT_S1_FINAL *)
   tgt_b := 0;
   pos_ok := (ABS(D1004 - 0) <= POS_TOL) AND (ABS(D1005) <= SPEED_TOL);
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 22; END_IF;

22: (* LIFT_DESCEND_HOME *)
   IF cur_lift_is_c THEN
       tgt_c := HOME_C;
       pos_ok := (ABS(D1008 - HOME_C) <= POS_TOL) AND (ABS(D1009) <= SPEED_TOL);
   ELSE
       tgt_d := HOME_D;
       pos_ok := (ABS(D1012 - HOME_D) <= POS_TOL) AND (ABS(D1013) <= SPEED_TOL);
   END_IF;
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 23; END_IF;

23: (* PARK_SHUTTLE *)
   tgt_a := 0; tgt_b := 0;
   pos_ok := (ABS(D1000 - 0) <= POS_TOL) AND (ABS(D1001) <= SPEED_TOL)
         AND (ABS(D1004 - 0) <= POS_TOL) AND (ABS(D1005) <= SPEED_TOL);
   settle_timer(IN := pos_ok, PT := T#30ms);
   IF settle_timer.Q THEN state := 24; END_IF;

24: (* RESPOND *)
   IF active_req = 0 THEN
       IF X30 THEN
           D300 := cur_id;
           D301 := SEL(cur_cancelled, DINT(1), DINT(2));
           last_id0 := cur_id;
           state := 0;
       END_IF;
   ELSE
       IF X34 THEN
           D302 := cur_id;
           D303 := SEL(cur_cancelled, DINT(1), DINT(2));
           last_id1 := cur_id;
           state := 0;
       END_IF;
   END_IF;

ELSE
   state := 0;

END_CASE;

(* Continuous axis command outputs *)
D2000 := tgt_a; D2001 := 1000; D2002 := 0; Y40 := TRUE;
D2004 := tgt_b; D2005 := 1000; D2006 := 0; Y41 := TRUE;
D2008 := tgt_c; D2009 := 1000; D2010 := 0; Y42 := TRUE;
D2012 := tgt_d; D2013 := 1000; D2014 := 0; Y43 := TRUE;
D2016 := tgt_s3_0; D2017 := 1000; D2018 := 0; Y44 := TRUE;
D2020 := tgt_s3_1; D2021 := 1000; D2022 := 0; Y45 := TRUE;
D2024 := tgt_s4_0; D2025 := 1000; D2026 := 0; Y46 := TRUE;
D2028 := tgt_s4_1; D2029 := 1000; D2030 := 0; Y47 := TRUE;

(* Cell control auxiliary outputs *)
Y70 := (state >= 7) AND (state <= 9);
Y71 := (state >= 7) AND (state <= 9);
Y76 := (state >= 13) AND (state <= 15);

D700 := 1; D701 := 1; D702 := 1000;
D710 := 1; D711 := 1; D712 := 1000;

(* Brake: hold when shuttle essentially stopped *)
Y30 := (ABS(D1001) <= SPEED_TOL);

(* Final completion check: all requests done, all axes at initial posture *)
y2_cond := X51 AND (state = 0)
   AND (ABS(D1000 - 0) <= POS_TOL) AND (ABS(D1004 - 0) <= POS_TOL)
   AND (ABS(D1008 - HOME_C) <= POS_TOL) AND (ABS(D1012 - HOME_D) <= POS_TOL)
   AND (ABS(D1016 - HOME_S3_0) <= POS_TOL) AND (ABS(D1020 - HOME_S3_1) <= POS_TOL)
   AND (ABS(D1024 - HOME_S4_0) <= POS_TOL) AND (ABS(D1028 - HOME_S4_1) <= POS_TOL)
   AND (ABS(D1001) <= SPEED_TOL) AND (ABS(D1005) <= SPEED_TOL)
   AND (ABS(D1009) <= SPEED_TOL) AND (ABS(D1013) <= SPEED_TOL)
   AND (ABS(D1017) <= SPEED_TOL) AND (ABS(D1021) <= SPEED_TOL)
   AND (ABS(D1025) <= SPEED_TOL) AND (ABS(D1029) <= SPEED_TOL);

IF y2_cond THEN
   y2_declared := TRUE;
END_IF;

Y2 := y2_declared;

prev_state := state;

END_PROGRAM