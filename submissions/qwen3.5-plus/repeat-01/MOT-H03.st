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
    
    state : INT := 0;
    cur_req : INT := 0;
    lift_st : DINT := 0;
    seq_cnt : DINT := 1;
    ack_done0 : BOOL := FALSE;
    ack_done1 : BOOL := FALSE;
    t1 : TON;
    t2 : TON;
    t3 : TON;
    t4 : TON;
    target_a : DINT;
    target_lift : DINT;
    err : REAL;
    vel_err : REAL;
END_VAR

CASE state OF
0: (* IDLE *)
    D80 := 0; D81 := 0; D82 := 0;
    Y30 := TRUE;
    Y40 := FALSE; Y41 := FALSE; Y42 := FALSE; Y43 := FALSE;
    Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE; Y48 := FALSE;
    D2000 := 0; D2001 := 0; D2002 := 0;
    D2004 := 0; D2005 := 0; D2006 := 0;
    D2008 := 15000; D2009 := 0; D2010 := 0;
    D2012 := 15000; D2013 := 0; D2014 := 0;
    D2016 := -50000; D2017 := 0; D2018 := 0;
    D2020 := -50000; D2021 := 0; D2022 := 0;
    D2024 := 0; D2025 := 0; D2026 := 0;
    D2028 := 0; D2029 := 0; D2030 := 0;
    D2032 := 0; D2033 := 0; D2034 := 0;
    Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
    Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
    IF NOT ack_done0 AND (D102 > 0) THEN cur_req := 0; lift_st := D101; state := 10;
    ELSIF NOT ack_done1 AND (D122 > 0) THEN cur_req := 1; lift_st := D121; state := 10;
    END_IF;

10: (* MOVE TO LIFT DOCK *)
    Y30 := FALSE;
    target_a := IF lift_st = 1 THEN -360000 ELSE -230000 END_IF;
    D2000 := target_a; D2001 := 600; Y40 := TRUE;
    target_lift := D92;
    IF lift_st = 1 THEN D2008 := target_lift; D2009 := 600; Y42 := TRUE;
    ELSE D2012 := target_lift; D2013 := 600; Y43 := TRUE; END_IF;
    D2004 := 0; D2005 := 200; Y41 := TRUE;
    IF ABS(D1000 - target_a) <= 500 AND ABS(D1001) <= 100 THEN
        IF (lift_st=1 AND ABS(D1008 - target_lift) <= 500) OR (lift_st=2 AND ABS(D1012 - target_lift) <= 500) THEN
            state := 20;
        END_IF;
    END_IF;

20: (* CONNECT LIFT *)
    D2001 := 200; D2005 := 200; D2009 := 200; D2013 := 200;
    D80 := 1; D81 := lift_st; D82 := seq_cnt; seq_cnt := seq_cnt + 1;
    t1(IN := TRUE, PT := T#50ms);
    IF t1.Q OR (lift_st=1 AND X61) OR (lift_st=2 AND X62) THEN
        IF (lift_st=1 AND ABS(D1000 - D403) <= 20) OR (lift_st=2 AND ABS(D1000 - D406) <= 20) THEN
            IF ABS(D1001) <= 100 THEN state := 30; END_IF;
        END_IF;
    END_IF;

30: (* INSERT FORK *)
    D2004 := 18000; D2005 := 300;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN state := 40; END_IF;

40: (* MOVE TO C3 *)
    D80 := 0; D81 := 0; D82 := 0;
    D2000 := 0; D2001 := 800; Y40 := TRUE;
    t2(IN := TRUE, PT := T#30ms);
    IF ABS(D1000 - 0) <= 500 AND ABS(D1001) <= 200 THEN
        IF t2.Q THEN state := 50; END_IF;
    END_IF;

50: (* CONFIGURE C3 *)
    Y70 := TRUE; Y71 := TRUE;
    D700 := 1000; D701 := 0; D702 := 600;
    D2016 := D500; D2017 := 600; D2018 := 0; Y44 := TRUE;
    D2020 := D501; D2021 := 600; D2022 := 0; Y45 := TRUE;
    D2024 := D502; D2025 := 600; D2026 := 0; Y46 := TRUE;
    D2001 := 200;
    IF X70 OR X72 THEN state := 60; END_IF;

60: (* MOVE TO C4 *)
    D2000 := 360000; D2001 := 800; Y40 := TRUE;
    IF ABS(D1000 - 360000) <= 500 AND ABS(D1001) <= 200 THEN state := 70; END_IF;

70: (* CONFIGURE C4 & SYNC *)
    Y75 := TRUE; Y76 := TRUE;
    D710 := 1000; D711 := 0; D712 := 600;
    D2028 := D600; D2029 := 600; D2030 := 0; Y47 := TRUE;
    D2032 := D601; D2033 := 600; D2034 := 0; Y48 := TRUE;
    D2001 := 200;
    err := ABS((D1028 / 100.0) - (D1032 / 100.0));
    vel_err := ABS((D1029 / 100.0) - (D1033 / 100.0));
    IF err <= 0.2 AND vel_err <= 1.0 THEN
        t3(IN := TRUE, PT := T#50ms);
        IF t3.Q THEN state := 80; END_IF;
    ELSE
        t3(IN := FALSE, PT := T#50ms);
    END_IF;

80: (* MAINTAIN SYNC *)
    err := ABS((D1028 / 100.0) - (D1032 / 100.0));
    IF err > 0.6 THEN state := 70; END_IF;
    IF X75 THEN state := 90; END_IF;

90: (* RETURN C4->C3 *)
    D2000 := 0; D2001 := 800; Y40 := TRUE;
    IF ABS(D1000 - 0) <= 500 AND ABS(D1001) <= 200 THEN state := 100; END_IF;

100: (* RETURN C3->LIFT *)
    target_a := IF lift_st = 1 THEN -360000 ELSE -230000 END_IF;
    D2000 := target_a; D2001 := 800; Y40 := TRUE;
    IF ABS(D1000 - target_a) <= 500 AND ABS(D1001) <= 200 THEN state := 110; END_IF;

110: (* PLACE LIFT *)
    D2001 := 200;
    D80 := 2; D81 := lift_st; D82 := seq_cnt; seq_cnt := seq_cnt + 1;
    IF (lift_st=1 AND X61) OR (lift_st=2 AND X62) THEN
        IF (lift_st=1 AND ABS(D1000 - D403) <= 20) OR (lift_st=2 AND ABS(D1000 - D406) <= 20) THEN
            IF ABS(D1001) <= 100 THEN state := 120; END_IF;
        END_IF;
    END_IF;

120: (* RETRACT & DESCEND *)
    D2004 := 0; D2005 := 300;
    target_lift := IF lift_st = 1 THEN 15000 ELSE 15000 END_IF;
    IF lift_st = 1 THEN D2008 := target_lift; D2009 := 600;
    ELSE D2012 := target_lift; D2013 := 600; END_IF;
    IF ABS(D1004 - 0) <= 20 AND ((lift_st=1 AND ABS(D1008 - 15000) <= 500) OR (lift_st=2 AND ABS(D1012 - 15000) <= 500)) THEN
        state := 130;
    END_IF;

130: (* ACK *)
    D80 := 0; D81 := 0; D82 := 0;
    IF cur_req = 0 THEN
        D300 := D100;
        D301 := IF X31 THEN 2 ELSE 1 END_IF;
        ack_done0 := TRUE;
    ELSE
        D302 := D120;
        D303 := IF X35 THEN 2 ELSE 1 END_IF;
        ack_done1 := TRUE;
    END_IF;
    IF NOT ack_done0 THEN state := 10;
    ELSIF NOT ack_done1 THEN state := 10;
    ELSE state := 140; END_IF;

140: (* HOME ALL *)
    Y30 := TRUE;
    Y40 := FALSE; Y41 := FALSE; Y42 := FALSE; Y43 := FALSE;
    Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE; Y48 := FALSE;
    D2000 := 0; D2004 := 0;
    D2008 := 15000; D2012 := 15000;
    D2016 := -50000; D2020 := -50000; D2024 := 0;
    D2028 := 0; D2032 := 0;
    Y70 := FALSE; Y75 := FALSE;
    IF ABS(D1000 - 0) <= 20 AND ABS(D1004 - 0) <= 20 THEN
        IF (ABS(D1008 - 15000) <= 20) AND (ABS(D1012 - 15000) <= 20) THEN
            IF (ABS(D1016 - (-50000)) <= 20) AND (ABS(D1020 - (-50000)) <= 20) AND (ABS(D1024 - 0) <= 20) THEN
                IF (ABS(D1028 - 0) <= 20) AND (ABS(D1032 - 0) <= 20) THEN
                    state := 150;
                END_IF;
            END_IF;
        END_IF;
    END_IF;

150: (* DONE *)
    Y2 := TRUE;
    t4(IN := TRUE, PT := T#100ms);
    IF t4.Q THEN state := 160; END_IF;

160: (* HOLD *)
    Y2 := TRUE;
END_CASE;

END_PROGRAM