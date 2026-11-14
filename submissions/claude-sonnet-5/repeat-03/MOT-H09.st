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
    Y30 : BOOL := TRUE;
    Y2 : BOOL := FALSE;

    (* internal working variables *)
    stage      : DINT := 0;
    prev_stage : DINT := -1;
    entering   : BOOL;
    active_req : DINT := 0;
    seq_counter: DINT := 0;
    cur_id     : DINT;
    cur_loc    : DINT;
    pocket_sel : DINT;
    req_cancelled : BOOL;
    req0_done  : BOOL := FALSE;
    req1_done  : BOOL := FALSE;

    a_tgt : DINT := 0;
    b_tgt : DINT := 0;
    c_tgt : DINT := 15000;
    d_tgt : DINT := 15000;
    s3_0_tgt : DINT := 0;
    s3_1_tgt : DINT := 0;
    s3_2_tgt : DINT := 0;
    s4_0_tgt : DINT := 0;
    s4_1_tgt : DINT := 5000;
END_VAR

entering := (stage <> prev_stage);

CASE stage OF

0: (* SELECT_REQUEST *)
    IF active_req = 0 THEN
        cur_id := D100;
        cur_loc := D101;
        req_cancelled := X31;
    ELSE
        cur_id := D120;
        cur_loc := D121;
        req_cancelled := X35;
    END_IF;
    pocket_sel := cur_loc;
    IF req_cancelled THEN
        stage := 190;
    ELSE
        stage := 1;
    END_IF;

1: (* MOVE_TO_ORIGIN *)
    Y30 := FALSE;
    IF cur_loc = 1 THEN
        a_tgt := -360000;
    ELSE
        a_tgt := -230000;
    END_IF;
    IF ABS(D1000 - a_tgt) <= 20 AND ABS(D1001) <= 100 THEN
        Y30 := TRUE;
        IF X52 THEN
            stage := 2;
        END_IF;
    END_IF;

2: (* RAISE_LIFT *)
    IF cur_loc = 1 THEN
        c_tgt := D92;
        IF ABS(D1008 - c_tgt) <= 20 AND ABS(D1009) <= 100 THEN
            stage := 3;
        END_IF;
    ELSE
        d_tgt := D92;
        IF ABS(D1012 - d_tgt) <= 20 AND ABS(D1013) <= 100 THEN
            stage := 3;
        END_IF;
    END_IF;

3: (* CONNECT_FORK_ORIGIN *)
    b_tgt := 18000;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
        stage := 4;
    END_IF;

4: (* HANDOVER_EXTRACT_ORIGIN *)
    IF entering THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D80 := 1;
        D81 := cur_loc;
    END_IF;
    IF (cur_loc = 1 AND X61) OR (cur_loc = 2 AND X62) THEN
        stage := 5;
    END_IF;

5: (* RETRACT_FORK_ORIGIN *)
    b_tgt := 0;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        stage := 6;
    END_IF;

6: (* MOVE_TO_CELL3 *)
    Y30 := FALSE;
    a_tgt := 490000;
    IF ABS(D1000 - 490000) <= 20 AND ABS(D1001) <= 100 THEN
        Y30 := TRUE;
        IF X52 THEN
            stage := 7;
        END_IF;
    END_IF;

7: (* CONNECT_FORK_CELL3 *)
    b_tgt := 18000;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
        stage := 8;
    END_IF;

8: (* HANDOVER_PLACE_CELL3 *)
    IF entering THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D80 := 2;
        D81 := 3;
    END_IF;
    IF X63 THEN
        stage := 9;
    END_IF;

9: (* CELL3_CONFIGURE *)
    s3_0_tgt := D500;
    s3_1_tgt := D501;
    s3_2_tgt := D502;
    D700 := pocket_sel;
    D701 := D526;
    D702 := 500;
    Y70 := TRUE;
    IF ABS(D1016 - D500) <= 20 AND ABS(D1020 - D501) <= 20 AND ABS(D1024 - D502) <= 20 THEN
        stage := 10;
    END_IF;

10: (* CELL3_WAIT_SERVED *)
    Y71 := TRUE;
    IF X70 THEN
        stage := 11;
    END_IF;

11: (* CELL3_RETRACT_POCKET *)
    Y70 := FALSE;
    s3_0_tgt := 0;
    s3_1_tgt := 0;
    s3_2_tgt := 0;
    IF ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 THEN
        stage := 12;
    END_IF;

12: (* HANDOVER_RETRIEVE_CELL3 *)
    IF entering THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D80 := 1;
        D81 := 3;
        Y71 := FALSE;
    END_IF;
    IF X63 THEN
        stage := 13;
    END_IF;

13: (* RETRACT_FORK_CELL3 *)
    b_tgt := 0;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        stage := 14;
    END_IF;

14: (* MOVE_TO_CELL4 *)
    Y30 := FALSE;
    a_tgt := 1140000;
    IF ABS(D1000 - 1140000) <= 20 AND ABS(D1001) <= 100 THEN
        Y30 := TRUE;
        IF X52 THEN
            stage := 15;
        END_IF;
    END_IF;

15: (* CONNECT_FORK_CELL4 *)
    b_tgt := 18000;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
        stage := 16;
    END_IF;

16: (* HANDOVER_PLACE_CELL4 *)
    IF entering THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D80 := 2;
        D81 := 4;
    END_IF;
    IF X64 THEN
        stage := 17;
    END_IF;

17: (* CELL4_ROTATE *)
    Y75 := TRUE;
    D710 := D620;
    D711 := D626;
    D712 := 500;
    s4_0_tgt := D600;
    IF ABS(D1028 - D600) <= 20 AND ABS(D1029) <= 100 THEN
        stage := 18;
    END_IF;

18: (* CELL4_EXTEND *)
    s4_1_tgt := D601;
    IF ABS(D1032 - D601) <= 20 AND ABS(D1033) <= 100 THEN
        stage := 19;
    END_IF;

19: (* CELL4_WAIT_SERVED *)
    Y76 := TRUE;
    IF X75 THEN
        stage := 20;
    END_IF;

20: (* CELL4_RETRACT_SLIDE *)
    Y76 := FALSE;
    s4_1_tgt := 5000;
    IF ABS(D1032 - 5000) <= 20 AND ABS(D1033) <= 100 THEN
        stage := 21;
    END_IF;

21: (* CELL4_ROTATE_HOME *)
    s4_0_tgt := 0;
    Y75 := FALSE;
    IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 THEN
        stage := 22;
    END_IF;

22: (* HANDOVER_RETRIEVE_CELL4 *)
    IF entering THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D80 := 1;
        D81 := 4;
    END_IF;
    IF X64 THEN
        stage := 23;
    END_IF;

23: (* RETRACT_FORK_CELL4 *)
    b_tgt := 0;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        stage := 24;
    END_IF;

24: (* MOVE_TO_ORIGIN_RETURN *)
    Y30 := FALSE;
    IF cur_loc = 1 THEN
        a_tgt := -360000;
    ELSE
        a_tgt := -230000;
    END_IF;
    IF ABS(D1000 - a_tgt) <= 20 AND ABS(D1001) <= 100 THEN
        Y30 := TRUE;
        IF X52 THEN
            stage := 25;
        END_IF;
    END_IF;

25: (* CONNECT_FORK_ORIGIN_RETURN *)
    b_tgt := 18000;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
        stage := 26;
    END_IF;

26: (* HANDOVER_PLACE_ORIGIN *)
    IF entering THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D80 := 2;
        D81 := cur_loc;
    END_IF;
    IF (cur_loc = 1 AND X61) OR (cur_loc = 2 AND X62) THEN
        stage := 27;
    END_IF;

27: (* RETRACT_FORK_ORIGIN_RETURN *)
    b_tgt := 0;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        stage := 28;
    END_IF;

28: (* LOWER_LIFT_HOME *)
    IF cur_loc = 1 THEN
        c_tgt := 15000;
        IF ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 THEN
            stage := 29;
        END_IF;
    ELSE
        d_tgt := 15000;
        IF ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 THEN
            stage := 29;
        END_IF;
    END_IF;

29: (* RESPOND_COMPLETE *)
    IF active_req = 0 THEN
        D300 := cur_id;
        D301 := 1;
    ELSE
        D302 := cur_id;
        D303 := 1;
    END_IF;
    stage := 30;

30: (* NEXT_REQUEST *)
    IF active_req = 0 THEN
        req0_done := TRUE;
        active_req := 1;
        stage := 0;
    ELSE
        req1_done := TRUE;
        stage := 100;
    END_IF;

190: (* RESPOND_CANCEL *)
    IF active_req = 0 THEN
        D300 := cur_id;
        D301 := 2;
    ELSE
        D302 := cur_id;
        D303 := 2;
    END_IF;
    stage := 30;

100: (* FINAL_HOME *)
    a_tgt := 0;
    b_tgt := 0;
    c_tgt := 15000;
    d_tgt := 15000;
    s3_0_tgt := 0;
    s3_1_tgt := 0;
    s3_2_tgt := 0;
    s4_0_tgt := 0;
    s4_1_tgt := 5000;
    Y30 := FALSE;
    IF ABS(D1000) <= 20 AND ABS(D1001) <= 100
       AND ABS(D1004) <= 20 AND ABS(D1005) <= 100
       AND ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100
       AND ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100
       AND ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 20
       AND ABS(D1028) <= 20 AND ABS(D1032 - 5000) <= 20
       AND X51 THEN
        Y30 := TRUE;
        Y2 := TRUE;
        stage := 101;
    END_IF;

101: (* FINAL_DONE - maintain home posture and completion *)
    a_tgt := 0;
    b_tgt := 0;
    c_tgt := 15000;
    d_tgt := 15000;
    s3_0_tgt := 0;
    s3_1_tgt := 0;
    s3_2_tgt := 0;
    s4_0_tgt := 0;
    s4_1_tgt := 5000;
    Y30 := TRUE;
    Y2 := TRUE;

ELSE
    stage := 0;

END_CASE;

(* apply outputs every scan *)
D2000 := LIMIT(-450000, a_tgt, 1461300);
D2001 := 300;
D2002 := 0;
Y40 := TRUE;

D2004 := LIMIT(0, b_tgt, 18000);
D2005 := 300;
D2006 := 0;
Y41 := TRUE;

D2008 := LIMIT(0, c_tgt, 120000);
D2009 := 300;
D2010 := 0;
Y42 := TRUE;

D2012 := LIMIT(0, d_tgt, 120000);
D2013 := 300;
D2014 := 0;
Y43 := TRUE;

D2016 := LIMIT(0, s3_0_tgt, 100000);
D2017 := 300;
D2018 := 0;
Y44 := TRUE;

D2020 := LIMIT(0, s3_1_tgt, 100000);
D2021 := 300;
D2022 := 0;
Y45 := TRUE;

D2024 := LIMIT(0, s3_2_tgt, 100000);
D2025 := 300;
D2026 := 0;
Y46 := TRUE;

D2028 := LIMIT(0, s4_0_tgt, 27000);
D2029 := 300;
D2030 := 0;
Y47 := TRUE;

D2032 := LIMIT(0, s4_1_tgt, 74000);
D2033 := 300;
D2034 := 0;
Y48 := TRUE;

prev_stage := stage;

END_PROGRAM