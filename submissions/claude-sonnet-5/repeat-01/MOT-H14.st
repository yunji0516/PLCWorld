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

    (* ---- internal constants ---- *)
    POS_TOL : DINT := 20;      (* 0.2 mm *100 *)
    VEL_TOL : DINT := 100;     (* 1 mm/s *100 *)
    POS1    : DINT := -360000;
    POS2    : DINT := -230000;
    POS3    : DINT := 0;
    POS4    : DINT := 360000;
    FORK_RETR : DINT := 0;
    FORK_CONN : DINT := 18000;
    HOME_LIFT : DINT := 15000;
    STOP_OFFSET : DINT := 25000;

    A_MIN : DINT := -450000; A_MAX : DINT := 450000;
    B_MIN : DINT := 0;       B_MAX : DINT := 18000;
    C_MIN : DINT := 0;       C_MAX : DINT := 120000;
    D_MIN : DINT := 0;       D_MAX : DINT := 120000;
    S30_MIN : DINT := -95000; S30_MAX : DINT := 95000;
    S31_MIN : DINT := -180000; S31_MAX : DINT := 180000;
    S40_MIN : DINT := -95000; S40_MAX : DINT := 95000;
    S41_MIN : DINT := -95000; S41_MAX : DINT := 95000;

    (* ---- persistent axis commands ---- *)
    a_tgt : DINT; a_rate : DINT; a_en : BOOL;
    b_tgt : DINT; b_rate : DINT; b_en : BOOL;
    c_tgt : DINT; c_rate : DINT; c_en : BOOL;
    d_tgt : DINT; d_rate : DINT; d_en : BOOL;
    s3_0_tgt : DINT; s3_0_rate : DINT; s3_0_en : BOOL;
    s3_1_tgt : DINT; s3_1_rate : DINT; s3_1_en : BOOL;
    s4_0_tgt : DINT; s4_0_rate : DINT; s4_0_en : BOOL;
    s4_1_tgt : DINT; s4_1_rate : DINT; s4_1_en : BOOL;

    (* ---- state machines ---- *)
    state0 : INT := 1;
    state1 : INT := 1;
    prev_state0 : INT := 1;
    prev_state1 : INT := 1;
    entering0 : BOOL;
    entering1 : BOOL;
    owner : INT := 0;
    needs_shared0 : BOOL;
    needs_shared1 : BOOL;

    seq_counter : DINT := 0;

    cap4_s40_0 : DINT; cap4_s41_0 : DINT; cap4_epoch0 : DINT; cap4_valid0 : BOOL;
    cap4_s40_1 : DINT; cap4_s41_1 : DINT; cap4_epoch1 : DINT; cap4_valid1 : BOOL;

    done0 : BOOL;
    done1 : BOOL;
    y2_latch : BOOL;
    initial_ok : BOOL;
    completion_ready : BOOL;
    brake_cmd : BOOL;
END_VAR

(* ================= release shared ownership if no longer needed ================= *)
needs_shared0 := (state0 >= 3 AND state0 <= 19) OR (state0 >= 80 AND state0 <= 83);
needs_shared1 := (state1 >= 3 AND state1 <= 19) OR (state1 >= 80 AND state1 <= 83);
IF owner = 1 AND NOT needs_shared0 THEN owner := 0; END_IF;
IF owner = 2 AND NOT needs_shared1 THEN owner := 0; END_IF;

(* ================= cancellation triggers ================= *)
IF X31 AND state0 < 21 AND state0 < 80 THEN
    IF state0 <= 2 THEN state0 := 84; ELSE state0 := 80; END_IF;
END_IF;
IF X35 AND state1 < 21 AND state1 < 80 THEN
    IF state1 <= 2 THEN state1 := 84; ELSE state1 := 80; END_IF;
END_IF;

(* ================= arbitration for shared shuttle/cell pipeline ================= *)
IF owner = 0 THEN
    IF state0 = 2 THEN
        owner := 1; state0 := 3;
    ELSIF state1 = 2 THEN
        owner := 2; state1 := 3;
    END_IF;
END_IF;

(* ================= entering-state edge flags ================= *)
entering0 := (state0 <> prev_state0);
entering1 := (state1 <> prev_state1);

(* ================================= REQUEST 0 ================================= *)
CASE state0 OF
1: (* PREP_LIFT *)
    c_tgt := D92; c_rate := 500; c_en := TRUE;
    IF ABS(D1008 - c_tgt) <= POS_TOL AND ABS(D1009) <= VEL_TOL THEN
        state0 := 2;
    END_IF;

2: (* WAIT_TURN - handled by arbitration *)
    ;

3: (* APPROACH_LIFT *)
    a_tgt := POS1; a_rate := 500; a_en := TRUE;
    b_tgt := FORK_CONN; b_rate := 500; b_en := TRUE;
    IF entering0 THEN
        D80 := 2; D81 := 1; seq_counter := seq_counter + 1; D82 := seq_counter;
    END_IF;
    IF ABS(D1000-a_tgt)<=POS_TOL AND ABS(D1001)<=VEL_TOL AND
       ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL AND X61 THEN
        state0 := 4;
    END_IF;

4: (* RETRACT_LIFT pickup *)
    b_tgt := FORK_RETR; b_rate := 500; b_en := TRUE;
    IF entering0 THEN D80 := 1; D81 := 1; END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL THEN
        state0 := 5;
    END_IF;

5: (* MOVE_TO_C3 *)
    a_tgt := POS3; a_rate := 500; a_en := TRUE;
    IF ABS(D1000-a_tgt)<=POS_TOL AND ABS(D1001)<=VEL_TOL THEN
        state0 := 6;
    END_IF;

6: (* CONNECT_C3 *)
    b_tgt := FORK_CONN; b_rate := 500; b_en := TRUE;
    IF entering0 THEN
        D80 := 2; D81 := 3; seq_counter := seq_counter + 1; D82 := seq_counter;
    END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL AND X63 THEN
        state0 := 7;
    END_IF;

7: (* FRAME_SET *)
    Y70 := TRUE; D700 := D100; D701 := D526; D702 := 500;
    IF X72 THEN
        Y70 := FALSE; state0 := 8;
    END_IF;

8: (* WORK_C3 *)
    s3_0_tgt := LIMIT(S30_MIN, D500, S30_MAX); s3_0_rate := 500; s3_0_en := TRUE;
    s3_1_tgt := LIMIT(S31_MIN, D501, S31_MAX); s3_1_rate := 500; s3_1_en := TRUE;
    D700 := D100;
    IF (D522 = D100 AND D524 = D91) OR X70 THEN
        state0 := 10;
    END_IF;

10: (* RETRACT_C3 *)
    b_tgt := FORK_RETR; b_rate := 500; b_en := TRUE;
    IF entering0 THEN D80 := 1; D81 := 3; END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL THEN
        state0 := 11;
    END_IF;

11: (* MOVE_TO_C4 *)
    a_tgt := POS4; a_rate := 500; a_en := TRUE;
    IF ABS(D1000-a_tgt)<=POS_TOL AND ABS(D1001)<=VEL_TOL THEN
        state0 := 12;
    END_IF;

12: (* CONNECT_C4 *)
    b_tgt := FORK_CONN; b_rate := 500; b_en := TRUE;
    IF entering0 THEN
        D80 := 2; D81 := 4; seq_counter := seq_counter + 1; D82 := seq_counter;
    END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL AND X64 THEN
        state0 := 13;
    END_IF;

13: (* SELECT_C4 *)
    D710 := D100; D711 := D626; D712 := 500;
    Y75 := TRUE;
    state0 := 14;

14: (* WORK_C4 - drive and watch for valid new capture at current epoch *)
    s4_0_tgt := LIMIT(S40_MIN, D600, S40_MAX); s4_0_rate := 500; s4_0_en := TRUE;
    s4_1_tgt := LIMIT(S41_MIN, D601, S41_MAX); s4_1_rate := 500; s4_1_en := TRUE;
    D710 := D100;
    IF D622 = D100 AND D624 = D91 THEN
        cap4_s40_0 := D621 + STOP_OFFSET;
        cap4_s41_0 := D621 + STOP_OFFSET;
        cap4_epoch0 := D624;
        cap4_valid0 := TRUE;
        state0 := 15;
    END_IF;

15: (* STOP_AT_250 - discard stale capture if epoch changed *)
    IF D91 <> cap4_epoch0 THEN
        cap4_valid0 := FALSE;
        state0 := 14;
    ELSE
        s4_0_tgt := LIMIT(S40_MIN, cap4_s40_0, S40_MAX); s4_0_rate := 300; s4_0_en := TRUE;
        s4_1_tgt := LIMIT(S41_MIN, cap4_s41_0, S41_MAX); s4_1_rate := 300; s4_1_en := TRUE;
        IF ABS(D1024-s4_0_tgt)<=POS_TOL AND ABS(D1025)<=VEL_TOL AND
           ABS(D1028-s4_1_tgt)<=POS_TOL AND ABS(D1029)<=VEL_TOL AND
           X75 AND D622 = D100 AND D624 = D91 THEN
            Y75 := FALSE;
            state0 := 16;
        END_IF;
    END_IF;

16: (* RETRACT_C4 *)
    b_tgt := FORK_RETR; b_rate := 500; b_en := TRUE;
    IF entering0 THEN D80 := 1; D81 := 4; END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL THEN
        state0 := 17;
    END_IF;

17: (* MOVE_TO_LIFT return *)
    a_tgt := POS1; a_rate := 500; a_en := TRUE;
    IF ABS(D1000-a_tgt)<=POS_TOL AND ABS(D1001)<=VEL_TOL THEN
        state0 := 18;
    END_IF;

18: (* CONNECT_LIFT_IN *)
    b_tgt := FORK_CONN; b_rate := 500; b_en := TRUE;
    IF entering0 THEN
        D80 := 2; D81 := 1; seq_counter := seq_counter + 1; D82 := seq_counter;
    END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL AND X61 THEN
        state0 := 19;
    END_IF;

19: (* RETRACT_LIFT_IN - transfer to lift *)
    b_tgt := FORK_RETR; b_rate := 500; b_en := TRUE;
    IF entering0 THEN D80 := 1; D81 := 1; END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL THEN
        state0 := 20;
    END_IF;

20: (* LOWER_LIFT *)
    c_tgt := HOME_LIFT; c_rate := 500; c_en := TRUE;
    IF ABS(D1008-c_tgt)<=POS_TOL AND ABS(D1009)<=VEL_TOL THEN
        state0 := 21;
    END_IF;

21: (* RESPOND completion *)
    IF X30 AND ABS(D1008-c_tgt)<=POS_TOL AND ABS(D1009)<=VEL_TOL THEN
        D300 := D100; D301 := 1;
        state0 := 22;
    END_IF;

22: (* DONE *)
    done0 := TRUE;

80: (* CANCEL_RETRACT_ANY *)
    b_tgt := FORK_RETR; b_rate := 500; b_en := TRUE;
    IF entering0 THEN D80 := 1; END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL THEN
        state0 := 81;
    END_IF;

81: (* CANCEL_MOVE to own lift *)
    a_tgt := POS1; a_rate := 500; a_en := TRUE;
    IF ABS(D1000-a_tgt)<=POS_TOL AND ABS(D1001)<=VEL_TOL THEN
        state0 := 82;
    END_IF;

82: (* CANCEL_CONNECT *)
    b_tgt := FORK_CONN; b_rate := 500; b_en := TRUE;
    IF entering0 THEN
        D80 := 2; D81 := 1; seq_counter := seq_counter + 1; D82 := seq_counter;
    END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL AND X61 THEN
        state0 := 83;
    END_IF;

83: (* CANCEL_RETRACT2 *)
    b_tgt := FORK_RETR; b_rate := 500; b_en := TRUE;
    IF entering0 THEN D80 := 1; D81 := 1; END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL THEN
        state0 := 84;
    END_IF;

84: (* CANCEL_LOWER *)
    c_tgt := HOME_LIFT; c_rate := 500; c_en := TRUE;
    IF ABS(D1008-c_tgt)<=POS_TOL AND ABS(D1009)<=VEL_TOL THEN
        state0 := 85;
    END_IF;

85: (* CANCEL_RESPOND *)
    IF X30 AND ABS(D1008-c_tgt)<=POS_TOL AND ABS(D1009)<=VEL_TOL THEN
        D300 := D100; D301 := 2;
        state0 := 86;
    END_IF;

86: (* CANCEL_DONE *)
    done0 := TRUE;

ELSE
    ;
END_CASE;

(* ================================= REQUEST 1 ================================= *)
CASE state1 OF
1: (* PREP_LIFT *)
    d_tgt := D92; d_rate := 500; d_en := TRUE;
    IF ABS(D1012 - d_tgt) <= POS_TOL AND ABS(D1013) <= VEL_TOL THEN
        state1 := 2;
    END_IF;

2:
    ;

3: (* APPROACH_LIFT *)
    a_tgt := POS2; a_rate := 500; a_en := TRUE;
    b_tgt := FORK_CONN; b_rate := 500; b_en := TRUE;
    IF entering1 THEN
        D80 := 2; D81 := 2; seq_counter := seq_counter + 1; D82 := seq_counter;
    END_IF;
    IF ABS(D1000-a_tgt)<=POS_TOL AND ABS(D1001)<=VEL_TOL AND
       ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL AND X62 THEN
        state1 := 4;
    END_IF;

4:
    b_tgt := FORK_RETR; b_rate := 500; b_en := TRUE;
    IF entering1 THEN D80 := 1; D81 := 2; END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL THEN
        state1 := 5;
    END_IF;

5:
    a_tgt := POS3; a_rate := 500; a_en := TRUE;
    IF ABS(D1000-a_tgt)<=POS_TOL AND ABS(D1001)<=VEL_TOL THEN
        state1 := 6;
    END_IF;

6:
    b_tgt := FORK_CONN; b_rate := 500; b_en := TRUE;
    IF entering1 THEN
        D80 := 2; D81 := 3; seq_counter := seq_counter + 1; D82 := seq_counter;
    END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL AND X63 THEN
        state1 := 7;
    END_IF;

7:
    Y70 := TRUE; D700 := D120; D701 := D526; D702 := 500;
    IF X72 THEN
        Y70 := FALSE; state1 := 8;
    END_IF;

8:
    s3_0_tgt := LIMIT(S30_MIN, D500, S30_MAX); s3_0_rate := 500; s3_0_en := TRUE;
    s3_1_tgt := LIMIT(S31_MIN, D501, S31_MAX); s3_1_rate := 500; s3_1_en := TRUE;
    D700 := D120;
    IF (D522 = D120 AND D524 = D91) OR X70 THEN
        state1 := 10;
    END_IF;

10:
    b_tgt := FORK_RETR; b_rate := 500; b_en := TRUE;
    IF entering1 THEN D80 := 1; D81 := 3; END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL THEN
        state1 := 11;
    END_IF;

11:
    a_tgt := POS4; a_rate := 500; a_en := TRUE;
    IF ABS(D1000-a_tgt)<=POS_TOL AND ABS(D1001)<=VEL_TOL THEN
        state1 := 12;
    END_IF;

12:
    b_tgt := FORK_CONN; b_rate := 500; b_en := TRUE;
    IF entering1 THEN
        D80 := 2; D81 := 4; seq_counter := seq_counter + 1; D82 := seq_counter;
    END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL AND X64 THEN
        state1 := 13;
    END_IF;

13:
    D710 := D120; D711 := D626; D712 := 500;
    Y75 := TRUE;
    state1 := 14;

14:
    s4_0_tgt := LIMIT(S40_MIN, D600, S40_MAX); s4_0_rate := 500; s4_0_en := TRUE;
    s4_1_tgt := LIMIT(S41_MIN, D601, S41_MAX); s4_1_rate := 500; s4_1_en := TRUE;
    D710 := D120;
    IF D622 = D120 AND D624 = D91 THEN
        cap4_s40_1 := D621 + STOP_OFFSET;
        cap4_s41_1 := D621 + STOP_OFFSET;
        cap4_epoch1 := D624;
        cap4_valid1 := TRUE;
        state1 := 15;
    END_IF;

15:
    IF D91 <> cap4_epoch1 THEN
        cap4_valid1 := FALSE;
        state1 := 14;
    ELSE
        s4_0_tgt := LIMIT(S40_MIN, cap4_s40_1, S40_MAX); s4_0_rate := 300; s4_0_en := TRUE;
        s4_1_tgt := LIMIT(S41_MIN, cap4_s41_1, S41_MAX); s4_1_rate := 300; s4_1_en := TRUE;
        IF ABS(D1024-s4_0_tgt)<=POS_TOL AND ABS(D1025)<=VEL_TOL AND
           ABS(D1028-s4_1_tgt)<=POS_TOL AND ABS(D1029)<=VEL_TOL AND
           X75 AND D622 = D120 AND D624 = D91 THEN
            Y75 := FALSE;
            state1 := 16;
        END_IF;
    END_IF;

16:
    b_tgt := FORK_RETR; b_rate := 500; b_en := TRUE;
    IF entering1 THEN D80 := 1; D81 := 4; END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL THEN
        state1 := 17;
    END_IF;

17:
    a_tgt := POS2; a_rate := 500; a_en := TRUE;
    IF ABS(D1000-a_tgt)<=POS_TOL AND ABS(D1001)<=VEL_TOL THEN
        state1 := 18;
    END_IF;

18:
    b_tgt := FORK_CONN; b_rate := 500; b_en := TRUE;
    IF entering1 THEN
        D80 := 2; D81 := 2; seq_counter := seq_counter + 1; D82 := seq_counter;
    END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL AND X62 THEN
        state1 := 19;
    END_IF;

19:
    b_tgt := FORK_RETR; b_rate := 500; b_en := TRUE;
    IF entering1 THEN D80 := 1; D81 := 2; END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL THEN
        state1 := 20;
    END_IF;

20:
    d_tgt := HOME_LIFT; d_rate := 500; d_en := TRUE;
    IF ABS(D1012-d_tgt)<=POS_TOL AND ABS(D1013)<=VEL_TOL THEN
        state1 := 21;
    END_IF;

21:
    IF X34 AND ABS(D1012-d_tgt)<=POS_TOL AND ABS(D1013)<=VEL_TOL THEN
        D302 := D120; D303 := 1;
        state1 := 22;
    END_IF;

22:
    done1 := TRUE;

80:
    b_tgt := FORK_RETR; b_rate := 500; b_en := TRUE;
    IF entering1 THEN D80 := 1; END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL THEN
        state1 := 81;
    END_IF;

81:
    a_tgt := POS2; a_rate := 500; a_en := TRUE;
    IF ABS(D1000-a_tgt)<=POS_TOL AND ABS(D1001)<=VEL_TOL THEN
        state1 := 82;
    END_IF;

82:
    b_tgt := FORK_CONN; b_rate := 500; b_en := TRUE;
    IF entering1 THEN
        D80 := 2; D81 := 2; seq_counter := seq_counter + 1; D82 := seq_counter;
    END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL AND X62 THEN
        state1 := 83;
    END_IF;

83:
    b_tgt := FORK_RETR; b_rate := 500; b_en := TRUE;
    IF entering1 THEN D80 := 1; D81 := 2; END_IF;
    IF ABS(D1004-b_tgt)<=POS_TOL AND ABS(D1005)<=VEL_TOL THEN
        state1 := 84;
    END_IF;

84:
    d_tgt := HOME_LIFT; d_rate := 500; d_en := TRUE;
    IF ABS(D1012-d_tgt)<=POS_TOL AND ABS(D1013)<=VEL_TOL THEN
        state1 := 85;
    END_IF;

85:
    IF X34 AND ABS(D1012-d_tgt)<=POS_TOL AND ABS(D1013)<=VEL_TOL THEN
        D302 := D120; D303 := 2;
        state1 := 86;
    END_IF;

86:
    done1 := TRUE;

ELSE
    ;
END_CASE;

(* ================= completion / Y2 ================= *)
initial_ok :=
    ABS(D1000 - 0) <= POS_TOL AND ABS(D1001) <= VEL_TOL AND
    ABS(D1004 - 0) <= POS_TOL AND ABS(D1005) <= VEL_TOL AND
    ABS(D1008 - HOME_LIFT) <= POS_TOL AND ABS(D1009) <= VEL_TOL AND
    ABS(D1012 - HOME_LIFT) <= POS_TOL AND ABS(D1013) <= VEL_TOL AND
    ABS(D1016 - (-60000)) <= POS_TOL AND ABS(D1017) <= VEL_TOL AND
    ABS(D1020 - (-60000)) <= POS_TOL AND ABS(D1021) <= VEL_TOL AND
    ABS(D1024 - (-60000)) <= POS_TOL AND ABS(D1025) <= VEL_TOL AND
    ABS(D1028 - (-60000)) <= POS_TOL AND ABS(D1029) <= VEL_TOL;

completion_ready := X51 AND done0 AND done1 AND initial_ok;
IF completion_ready THEN
    y2_latch := TRUE;
END_IF;
Y2 := y2_latch;

(* ================= brake management ================= *)
brake_cmd := NOT (a_en OR b_en OR c_en OR d_en);
Y30 := brake_cmd;

(* ================= output application with range clipping ================= *)
D2000 := LIMIT(A_MIN, a_tgt, A_MAX);
D2001 := a_rate;
D2002 := 0;
Y40   := a_en;

D2004 := LIMIT(B_MIN, b_tgt, B_MAX);
D2005 := b_rate;
D2006 := 0;
Y41   := b_en;

D2008 := LIMIT(C_MIN, c_tgt, C_MAX);
D2009 := c_rate;
D2010 := 0;
Y42   := c_en;

D2012 := LIMIT(D_MIN, d_tgt, D_MAX);
D2013 := d_rate;
D2014 := 0;
Y43   := d_en;

D2016 := LIMIT(S30_MIN, s3_0_tgt, S30_MAX);
D2017 := s3_0_rate;
D2018 := 0;
Y44   := s3_0_en;

D2020 := LIMIT(S31_MIN, s3_1_tgt, S31_MAX);
D2021 := s3_1_rate;
D2022 := 0;
Y45   := s3_1_en;

D2024 := LIMIT(S40_MIN, s4_0_tgt, S40_MAX);
D2025 := s4_0_rate;
D2026 := 0;
Y46   := s4_0_en;

D2028 := LIMIT(S41_MIN, s4_1_tgt, S41_MAX);
D2029 := s4_1_rate;
D2030 := 0;
Y47   := s4_1_en;

Y71 := FALSE;
Y76 := FALSE;

(* ================= state history update ================= *)
prev_state0 := state0;
prev_state1 := state1;

END_PROGRAM