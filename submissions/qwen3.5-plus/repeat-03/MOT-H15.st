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
    
    PI : REAL := 3.14159265358979;
    st : DINT := 0;
    cur_req : DINT := 0;
    req_id : DINT := 0;
    lift_side : DINT := 0;
    dock_pos : DINT := 0;
    ack_done_0 : BOOL := FALSE;
    ack_done_1 : BOOL := FALSE;
    t_settle : TON;
    t_80ms : TON;
    t_100ms : TON;
    t_ack : TON;
    prev_route_neg : BOOL := FALSE;
    seq_cnt : DINT := 0;
END_VAR

CASE st OF
  0: (* Idle / Pick Request *)
     Y40 := FALSE; Y41 := FALSE; Y42 := FALSE; Y43 := FALSE;
     Y44 := FALSE; Y45 := FALSE; Y46 := FALSE;
     Y47 := FALSE; Y48 := FALSE; Y49 := FALSE;
     Y70 := FALSE; Y71 := FALSE; Y75 := FALSE; Y76 := FALSE;
     Y30 := FALSE; Y2 := FALSE;
     D80 := 0; D81 := 0; D82 := 0;
     D300 := 0; D301 := 0; D302 := 0; D303 := 0;
     
     IF NOT ack_done_0 AND (r0_progress > 0 OR r0_progress = 0) AND r0_progress <= 4 THEN
        cur_req := 0; req_id := D100; lift_side := D101;
        IF lift_side = 1 THEN dock_pos := -405000; ELSIF lift_side = 2 THEN dock_pos := -185000;
        ELSE dock_pos := 0; END_IF;
        st := 1;
     ELSIF ack_done_0 AND NOT ack_done_1 AND (r1_progress > 0 OR r1_progress = 0) AND r1_progress <= 4 THEN
        cur_req := 1; req_id := D120; lift_side := D121;
        IF lift_side = 1 THEN dock_pos := -405000; ELSIF lift_side = 2 THEN dock_pos := -185000;
        ELSE dock_pos := 0; END_IF;
        st := 1;
     ELSIF ack_done_0 AND ack_done_1 THEN
        st := 15;
     END_IF;

  1: (* Move A to Lift Dock *)
     D2000 := dock_pos; D2001 := 500; D2002 := 0; Y40 := TRUE;
     D2004 := 0; D2005 := 300; D2006 := 0; Y41 := TRUE;
     IF ABS(dock_pos - D1000) < 300 AND ABS(D1001) < 100 THEN
        st := 2;
     END_IF;

  2: (* Dock Lift *)
     IF lift_side = 1 THEN
        D2008 := 95000; D2009 := 400; D2010 := 0; Y42 := TRUE;
        IF ABS(95000 - D1008) < 200 AND ABS(D1009) < 100 THEN st := 3; END_IF;
     ELSIF lift_side = 2 THEN
        D2012 := 95000; D2013 := 400; D2014 := 0; Y43 := TRUE;
        IF ABS(95000 - D1012) < 200 AND ABS(D1013) < 100 THEN st := 3; END_IF;
     END_IF;

  3: (* Extend Fork *)
     D2004 := 18000; D2005 := 400; D2006 := 0; Y41 := TRUE;
     IF ABS(18000 - D1004) < 200 AND ABS(D1005) < 100 THEN st := 4; END_IF;

  4: (* Wait Port Ready & Lower Lift *)
     seq_cnt := seq_cnt + 1; D82 := seq_cnt; D81 := lift_side; D80 := 1;
     IF (lift_side = 1 AND X61) OR (lift_side = 2 AND X62) THEN
        IF lift_side = 1 THEN
           D2008 := 40000; D2009 := 400; D2010 := 0;
           IF ABS(40000 - D1008) < 200 AND ABS(D1009) < 100 THEN st := 5; END_IF;
        ELSIF lift_side = 2 THEN
           D2012 := 40000; D2013 := 400; D2014 := 0;
           IF ABS(40000 - D1012) < 200 AND ABS(D1013) < 100 THEN st := 5; END_IF;
        END_IF;
     END_IF;

  5: (* Move A to Cell 3 *)
     D2000 := 0; D2001 := 500; D2002 := 0; Y40 := TRUE;
     IF ABS(0 - D1000) < 300 AND ABS(D1001) < 100 THEN
        st := 6;
     END_IF;

  6: (* Configure Cell 3 *)
     Y70 := TRUE; Y71 := FALSE;
     D700 := 1; D701 := 1; D702 := 500;
     (* Recipe: 90 -> [35, -20], 180 -> [-35, 20] *)
     IF D500 >= 10000 THEN
        D2016 := -3500; D2017 := 400; D2018 := 0; Y44 := TRUE;
        D2020 := 2000; D2021 := 400; D2022 := 0; Y45 := TRUE;
     ELSE
        D2016 := 3500; D2017 := 400; D2018 := 0; Y44 := TRUE;
        D2020 := -2000; D2021 := 400; D2022 := 0; Y45 := TRUE;
     END_IF;
     (* Counterweight balance: x = -225*(sin(θA)+sin(θB)) *)
     D2024 := DINT(-225.0 * (SIN(REAL(D2016)/100.0 * PI / 180.0) + SIN(REAL(D2020)/100.0 * PI / 180.0)) * 100.0);
     D2025 := 400; D2026 := 0; Y46 := TRUE;
     
     IF ABS(D2016 - D1016) < 200 AND ABS(D2017) < 100 AND
        ABS(D2020 - D1020) < 200 AND ABS(D2021) < 100 AND
        ABS(D2024 - D1024) < 200 AND ABS(D2025) < 100 THEN
        st := 7;
     END_IF;

  7: (* Wait Cell 3 Sync *)
     t_80ms(IN := X72, PT := T#80ms);
     IF t_80ms.Q THEN
        Y70 := FALSE; Y71 := TRUE;
        prev_route_neg := (D526 < 0);
        st := 8;
     END_IF;

  8: (* Move A to Cell 4 *)
     Y71 := TRUE;
     D2000 := 375000; D2001 := 500; D2002 := 0; Y40 := TRUE;
     IF ABS(375000 - D1000) < 300 AND ABS(D1001) < 100 THEN
        st := 9;
     END_IF;

  9: (* Configure Cell 4 *)
     Y71 := FALSE; Y75 := TRUE; Y76 := FALSE;
     D710 := IF prev_route_neg THEN 1 ELSE 2 END_IF;
     D711 := 1; D712 := 500;
     D2028 := D600; D2029 := 400; D2030 := 0; Y47 := TRUE;
     D2032 := D601; D2033 := 400; D2034 := 0; Y48 := TRUE;
     D2036 := D602; D2037 := 400; D2038 := 0; Y49 := TRUE;
     
     IF ABS(D600 - D1028) < 200 AND ABS(D1029) < 100 AND
        ABS(D601 - D1032) < 200 AND ABS(D1033) < 100 AND
        ABS(D602 - D1036) < 200 AND ABS(D1037) < 100 THEN
        st := 10;
     END_IF;

  10: (* Wait Cell 4 Sync *)
     IF X77 THEN
        Y75 := FALSE; Y76 := TRUE;
        st := 11;
     END_IF;

  11: (* Home Cell 4 & Return A to Lift *)
     Y76 := TRUE;
     D2028 := 0; D2029 := 400; D2030 := 0;
     D2032 := 0; D2033 := 400; D2034 := 0;
     D2036 := 0; D2037 := 400; D2038 := 0;
     
     IF ABS(D1028) < 200 AND ABS(D1032) < 200 AND ABS(D1036) < 200 THEN
        IF lift_side = 1 THEN dock_pos := -405000; ELSIF lift_side = 2 THEN dock_pos := -185000;
        ELSE dock_pos := 0; END_IF;
        D2000 := dock_pos; D2001 := 500; D2002 := 0;
        IF ABS(dock_pos - D1000) < 300 AND ABS(D1001) < 100 THEN st := 12; END_IF;
     END_IF;

  12: (* Undock Lift *)
     D80 := 2;
     IF lift_side = 1 THEN
        D2008 := 95000; D2009 := 400; D2010 := 0;
        IF ABS(95000 - D1008) < 200 AND ABS(D1009) < 100 THEN
           D2004 := 0; D2005 := 400; D2006 := 0;
           IF ABS(D1004) < 200 AND ABS(D1005) < 100 THEN
              D2008 := 40000;
              IF ABS(40000 - D1008) < 200 AND ABS(D1009) < 100 THEN st := 13; END_IF;
           END_IF;
        END_IF;
     ELSIF lift_side = 2 THEN
        D2012 := 95000; D2013 := 400; D2014 := 0;
        IF ABS(95000 - D1012) < 200 AND ABS(D1013) < 100 THEN
           D2004 := 0; D2005 := 400; D2006 := 0;
           IF ABS(D1004) < 200 AND ABS(D1005) < 100 THEN
              D2012 := 40000;
              IF ABS(40000 - D1012) < 200 AND ABS(D1013) < 100 THEN st := 13; END_IF;
           END_IF;
        END_IF;
     END_IF;

  13: (* Ack Completion *)
     D80 := 0; D81 := 0;
     IF cur_req = 0 THEN
        D300 := req_id;
        IF X31 THEN D301 := 2; ELSE D301 := 1; END_IF;
        ack_done_0 := TRUE;
     ELSE
        D302 := req_id;
        IF X35 THEN D303 := 2; ELSE D303 := 1; END_IF;
        ack_done_1 := TRUE;
     END_IF;
     t_ack(IN := TRUE, PT := T#200ms);
     IF t_ack.Q THEN
        t_ack(IN := FALSE);
        st := 0;
     END_IF;

  15: (* Final Home & Completion *)
     Y70 := FALSE; Y71 := FALSE; Y75 := FALSE; Y76 := FALSE;
     D2000 := 0; D2001 := 300; D2002 := 0; Y40 := TRUE;
     D2004 := 0; D2005 := 300; D2006 := 0; Y41 := TRUE;
     D2008 := 40000; D2009 := 300; D2010 := 0; Y42 := TRUE;
     D2012 := 40000; D2013 := 300; D2014 := 0; Y43 := TRUE;
     D2016 := 0; D2017 := 300; D2018 := 0; Y44 := TRUE;
     D2020 := 0; D2021 := 300; D2022 := 0; Y45 := TRUE;
     D2024 := 0; D2025 := 300; D2026 := 0; Y46 := TRUE;
     D2028 := 0; D2029 := 300; D2030 := 0; Y47 := TRUE;
     D2032 := 0; D2033 := 300; D2034 := 0; Y48 := TRUE;
     D2036 := 0; D2037 := 300; D2038 := 0; Y49 := TRUE;
     
     IF ABS(D1000) < 200 AND ABS(D1004) < 200 AND
        ABS(D1008 - 40000) < 200 AND ABS(D1012 - 40000) < 200 AND
        ABS(D1016) < 200 AND ABS(D1020) < 200 AND ABS(D1024) < 200 AND
        ABS(D1028) < 200 AND ABS(D1032) < 200 AND ABS(D1036) < 200 THEN
        t_100ms(IN := TRUE, PT := T#100ms);
        IF t_100ms.Q THEN
           Y2 := TRUE; Y30 := TRUE;
        END_IF;
     ELSE
        t_100ms(IN := FALSE);
     END_IF;
END_CASE;
END_PROGRAM