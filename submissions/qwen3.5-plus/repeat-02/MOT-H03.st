PROGRAM Main
VAR
    state : INT := 0;
    req_loc : INT := 1;
    req_id : DINT := 0;
    is_cancel : BOOL := FALSE;
    ack0_sent : BOOL := FALSE;
    ack1_sent : BOOL := FALSE;
    couple_seq_ctr : DINT := 0;
    lift_target : DINT := 15000;
    target_a : DINT := 0;
    t_move : TON;
    t_lift_dock : TON;
    t_cell3 : TON;
    t_cell4 : TON;
    t_sync : TON;
    t_home : TON;
    t_final : TON;
END_VAR

CASE state OF
0: (* Idle / Initialization *)
    D2000 := 0; D2001 := 0; Y40 := FALSE;
    D2004 := 0; D2005 := 0; Y41 := FALSE;
    D2008 := 15000; D2009 := 100; Y42 := (D1008 <> 15000);
    D2012 := 15000; D2013 := 100; Y43 := (D1012 <> 15000);
    D2016 := -50000; D2017 := 100; Y44 := (D1016 <> -50000);
    D2020 := -50000; D2021 := 100; Y45 := (D1020 <> -50000);
    D2024 := 0; D2025 := 100; Y46 := (D1024 <> 0);
    D2028 := 0; D2029 := 100; Y47 := (D1028 <> 0);
    D2032 := 0; D2033 := 100; Y48 := (D1032 <> 0);
    Y30 := TRUE; Y2 := FALSE;
    D80 := 0; D81 := 0; D82 := 0;
    Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
    Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
    D300 := 0; D301 := 0; D302 := 0; D303 := 0;
    t_move(IN := FALSE); t_lift_dock(IN := FALSE); t_cell3(IN := FALSE);
    t_cell4(IN := FALSE); t_sync(IN := FALSE); t_home(IN := FALSE); t_final(IN := FALSE);
    
    IF (D100 <> 0 AND NOT ack0_sent) OR (D120 <> 0 AND NOT ack1_sent) THEN
        IF D100 <> 0 AND NOT ack0_sent THEN
            req_id := D100; req_loc := D101; is_cancel := X31;
            state := 1;
        ELSIF D120 <> 0 AND NOT ack1_sent THEN
            req_id := D120; req_loc := D121; is_cancel := X35;
            state := 1;
        END IF;
    END IF;

1: (* Move shuttle to lift dock *)
    Y30 := FALSE;
    target_a := IF req_loc = 1 THEN -360000 ELSE -230000 END_IF;
    D2000 := target_a; D2001 := 800; Y40 := TRUE;
    D2004 := 0; D2005 := 0; Y41 := FALSE;
    IF ABS(D1000 - target_a) < 200 AND ABS(D1001) < 100 THEN
        state := 2;
    END IF;

2: (* Arrived at lift, brake & dock lift *)
    Y40 := FALSE; Y30 := TRUE;
    lift_target := 73250;
    IF req_loc = 1 THEN
        D2008 := lift_target; D2009 := 500; Y42 := TRUE;
        D2012 := 15000; D2013 := 0; Y43 := FALSE;
    ELSE
        D2012 := lift_target; D2013 := 500; Y43 := TRUE;
        D2008 := 15000; D2009 := 0; Y42 := FALSE;
    END IF;
    D2004 := 0; D2005 := 0; Y41 := FALSE;
    t_lift_dock(IN := TRUE, PT := T#50ms);
    IF t_lift_dock.Q AND ((ABS(D1008 - lift_target) < 20 AND ABS(D1009) < 100) OR (ABS(D1012 - lift_target) < 20 AND ABS(D1013) < 100)) THEN
        state := 3;
    END IF;

3: (* Insert fork to connect *)
    IF req_loc = 1 THEN Y42 := (ABS(D1008 - lift_target) > 20); ELSE Y43 := (ABS(D1012 - lift_target) > 20); END IF;
    D2004 := 18000; D2005 := 300; Y41 := TRUE;
    D80 := 2; (* placement/connection *)
    D81 := req_loc;
    D82 := couple_seq_ctr + 1;
    t_move(IN := TRUE, PT := T#50ms);
    IF t_move.Q AND ((ABS(D1008 - lift_target) < 20 AND ABS(D1009) < 100) OR (ABS(D1012 - lift_target) < 20 AND ABS(D1013) < 100)) AND ABS(D1004 - 18000) < 200 THEN
        state := 4;
    END IF;

4: (* Fork inserted, prepare for transport *)
    Y41 := FALSE;
    t_move(IN := FALSE);
    state := 5;

5: (* Transport to Cell 3 *)
    Y30 := FALSE;
    D2000 := 230000; D2001 := 800; Y40 := TRUE;
    IF ABS(D1000 - 230000) < 200 AND ABS(D1001) < 100 THEN
        state := 6;
    END IF;

6: (* Cell 3 Operation *)
    Y40 := FALSE; Y30 := TRUE;
    Y70 := TRUE; Y71 := TRUE;
    D700 := 1; D701 := 1; D702 := 1000;
    D2016 := D500; D2017 := 800; Y44 := TRUE;
    D2020 := D501; D2021 := 800; Y45 := TRUE;
    D2024 := D502; D2025 := 800; Y46 := TRUE;
    t_cell3(IN := TRUE, PT := T#80ms);
    IF t_cell3.Q AND X70 THEN
        Y70 := FALSE; Y71 := FALSE; Y44 := FALSE; Y45 := FALSE; Y46 := FALSE;
        state := 7;
    END IF;

7: (* Transport to Cell 4 *)
    Y30 := FALSE;
    D2000 := 990000; D2001 := 800; Y40 := TRUE;
    IF ABS(D1000 - 990000) < 200 AND ABS(D1001) < 100 THEN
        state := 8;
    END IF;

8: (* Cell 4 Operation *)
    Y40 := FALSE; Y30 := TRUE;
    Y75 := TRUE; Y76 := TRUE;
    D710 := 1000; D711 := 1; D712 := 1000;
    D2028 := D600; D2029 := 800; Y47 := TRUE;
    D2032 := D601; D2033 := 800; Y48 := TRUE;
    t_cell4(IN := TRUE, PT := T#100ms);
    t_sync(IN := (ABS(D1032 - D601) <= 20 AND ABS(D1033) <= 100 AND ABS(D1029) <= 100), PT := T#50ms);
    IF t_cell4.Q AND t_sync.Q THEN
        Y75 := FALSE; Y76 := FALSE; Y47 := FALSE; Y48 := FALSE;
        state := 9;
    END IF;

9: (* Return to lift *)
    Y30 := FALSE;
    target_a := IF req_loc = 1 THEN -360000 ELSE -230000 END_IF;
    D2000 := target_a; D2001 := 800; Y40 := TRUE;
    IF ABS(D1000 - target_a) < 200 AND ABS(D1001) < 100 THEN
        state := 10;
    END IF;

10: (* Arrived, dock lift for release *)
    Y40 := FALSE; Y30 := TRUE;
    lift_target := 73250;
    IF req_loc = 1 THEN
        D2008 := lift_target; D2009 := 500; Y42 := TRUE;
    ELSE
        D2012 := lift_target; D2013 := 500; Y43 := TRUE;
    END IF;
    D2004 := 18000; D2005 := 300; Y41 := TRUE;
    t_move(IN := TRUE, PT := T#50ms);
    IF t_move.Q AND ((ABS(D1008 - lift_target) < 20 AND ABS(D1009) < 100) OR (ABS(D1012 - lift_target) < 20 AND ABS(D1013) < 100)) AND ABS(D1004 - 18000) < 200 THEN
        state := 11;
    END IF;

11: (* Retract fork to release *)
    D2004 := 0; D2005 := 300; Y41 := TRUE;
    D80 := 1; (* extraction *)
    IF ABS(D1004) < 200 THEN
        state := 12;
    END IF;

12: (* Lower lift to home *)
    Y41 := FALSE;
    lift_target := 15000;
    IF req_loc = 1 THEN
        D2008 := lift_target; D2009 := 500; Y42 := TRUE;
    ELSE
        D2012 := lift_target; D2013 := 500; Y43 := TRUE;
    END IF;
    t_lift_dock(IN := TRUE, PT := T#100ms);
    IF t_lift_dock.Q AND ((ABS(D1008 - 15000) < 20 AND ABS(D1009) < 100) OR (ABS(D1012 - 15000) < 20 AND ABS(D1013) < 100)) THEN
        state := 13;
    END IF;

13: (* Home shuttle *)
    Y30 := FALSE;
    D2000 := 0; D2001 := 500; Y40 := TRUE;
    IF ABS(D1000) < 200 AND ABS(D1001) < 100 THEN
        state := 14;
    END IF;

14: (* Home other axes & Brake *)
    Y40 := FALSE; Y30 := TRUE;
    D2004 := 0; D2005 := 0; Y41 := FALSE;
    D2016 := -50000; D2017 := 500; Y44 := TRUE;
    D2020 := -50000; D2021 := 500; Y45 := TRUE;
    D2024 := 0; D2025 := 500; Y46 := TRUE;
    D2028 := 0; D2029 := 500; Y47 := TRUE;
    D2032 := 0; D2033 := 500; Y48 := TRUE;
    t_home(IN := TRUE, PT := T#200ms);
    IF t_home.Q AND ABS(D1016 - (-50000)) < 200 AND ABS(D1020 - (-50000)) < 200 AND ABS(D1024) < 200 AND ABS(D1028) < 200 AND ABS(D1032) < 200 THEN
        Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE; Y48 := FALSE;
        state := 15;
    END IF;

15: (* Acknowledge & Check next *)
    IF D100 <> 0 AND NOT ack0_sent THEN
        D300 := req_id; D301 := IF is_cancel THEN 2 ELSE 1 END_IF;
        ack0_sent := TRUE;
    ELSIF D120 <> 0 AND NOT ack1_sent THEN
        D302 := req_id; D303 := IF is_cancel THEN 2 ELSE 1 END_IF;
        ack1_sent := TRUE;
    END IF;
    D80 := 0; D81 := 0; D82 := 0;
    couple_seq_ctr := couple_seq_ctr + 1;
    state := 16;

16: (* Check completion *)
    IF ack0_sent AND ack1_sent THEN
        t_final(IN := TRUE, PT := T#100ms);
        IF t_final.Q AND ABS(D1000) < 200 AND ABS(D1004) < 200 AND ABS(D1008 - 15000) < 200 AND ABS(D1012 - 15000) < 200 THEN
            state := 17;
        END IF;
    ELSE
        state := 0;
    END IF;

17: (* Final Y2 *)
    Y2 := TRUE;
    t_final(IN := TRUE, PT := T#100ms);
ELSE
    state := 0;
END_CASE;

END_PROGRAM