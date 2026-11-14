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

    (* Internal state *)
    phase        : INT := 0;
    prev_phase   : INT := -1;
    phase_changed: BOOL;
    active_req   : INT := 0;
    req_done     : ARRAY[0..1] OF BOOL;
    cur_id       : DINT;
    cur_location : DINT;
    cur_cancelled: BOOL;
    lift_station : DINT := 1;
    seq_ctr      : DINT := 0;

    target_a  : DINT; en_a  : BOOL;
    target_b  : DINT; en_b  : BOOL;
    target_c  : DINT; en_c  : BOOL;
    target_d  : DINT; en_d  : BOOL;
    target_s30: DINT; en_s30: BOOL;
    target_s31: DINT; en_s31: BOOL;
    target_s40: DINT; en_s40: BOOL;
    target_s41: DINT; en_s41: BOOL;
    target_s42: DINT; en_s42: BOOL;

    rate_default : DINT := 300;
    cond      : BOOL;
    cap_target: DINT;
    cap_axis_is0 : BOOL;
    pin_target: DINT := 4000;
    pin_axis_is1 : BOOL;
    angle_target : DINT;
    at_home   : BOOL;

    stationCoord : ARRAY[1..4] OF DINT := [-360000, -230000, 230000, 990000];

    arrive_tmr : TON;
END_VAR

phase_changed := (phase <> prev_phase);

CASE phase OF

0:
    IF NOT req_done[0] THEN
        active_req := 0;
        cur_id := D100; cur_location := D101; cur_cancelled := X31;
        IF cur_location = 1 THEN lift_station := 1; ELSE lift_station := 2; END_IF;
        phase := 10;
    ELSIF NOT req_done[1] THEN
        active_req := 1;
        cur_id := D120; cur_location := D121; cur_cancelled := X35;
        IF cur_location = 1 THEN lift_station := 1; ELSE lift_station := 2; END_IF;
        phase := 10;
    ELSE
        phase := 100;
    END_IF;

10:
    IF lift_station = 1 THEN
        target_c := 73250; en_c := TRUE;
        en_d := FALSE;
        cond := (ABS(D1008-73250)<=20) AND (ABS(D1009)<=100);
    ELSE
        target_d := 73250; en_d := TRUE;
        en_c := FALSE;
        cond := (ABS(D1012-73250)<=20) AND (ABS(D1013)<=100);
    END_IF;
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 11; END_IF;

11:
    target_a := stationCoord[lift_station]; en_a := TRUE;
    target_b := 0; en_b := TRUE;
    cond := (ABS(D1000-target_a)<=20) AND (ABS(D1001)<=100) AND (ABS(D1004-0)<=20) AND (ABS(D1005)<=100);
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 12; END_IF;

12:
    target_b := 18000; en_b := TRUE;
    cond := (ABS(D1004-18000)<=20) AND (ABS(D1005)<=100);
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 13; END_IF;

13:
    IF phase_changed THEN seq_ctr := seq_ctr + 1; END_IF;
    D80 := 1; D81 := lift_station; D82 := seq_ctr;
    IF lift_station = 1 THEN cond := X61; ELSE cond := X62; END_IF;
    arrive_tmr(IN:=cond, PT:=T#40ms);
    IF arrive_tmr.Q THEN phase := 14; END_IF;

14:
    target_b := 0; en_b := TRUE;
    cond := (ABS(D1004-0)<=20) AND (ABS(D1005)<=100);
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN
        IF cur_cancelled THEN phase := 40; ELSE phase := 20; END_IF;
    END_IF;

20:
    target_a := stationCoord[3]; en_a := TRUE;
    target_b := 0; en_b := TRUE;
    cond := (ABS(D1000-target_a)<=20) AND (ABS(D1001)<=100);
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 21; END_IF;

21:
    target_b := 18000; en_b := TRUE;
    cond := (ABS(D1004-18000)<=20) AND (ABS(D1005)<=100);
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 22; END_IF;

22:
    IF phase_changed THEN seq_ctr := seq_ctr + 1; END_IF;
    D80 := 2; D81 := 3; D82 := seq_ctr;
    cond := X63;
    arrive_tmr(IN:=cond, PT:=T#40ms);
    IF arrive_tmr.Q THEN phase := 23; END_IF;

23:
    D700 := cur_id;
    Y70 := TRUE;
    Y71 := TRUE;
    IF D520 = 0 THEN
        cap_axis_is0 := TRUE;
        cap_target := LIMIT(-95000, D500 + 25000, 95000);
        target_s30 := cap_target; en_s30 := TRUE;
        en_s31 := FALSE;
    ELSE
        cap_axis_is0 := FALSE;
        cap_target := LIMIT(-95000, D501 + 25000, 95000);
        target_s31 := cap_target; en_s31 := TRUE;
        en_s30 := FALSE;
    END_IF;
    IF cap_axis_is0 THEN
        cond := (ABS(D1016-cap_target)<=20) AND (ABS(D1017)<=100) AND (D522=cur_id) AND (D524=D91);
    ELSE
        cond := (ABS(D1020-cap_target)<=20) AND (ABS(D1021)<=100) AND (D522=cur_id) AND (D524=D91);
    END_IF;
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 24; END_IF;

24:
    Y70 := FALSE;
    IF phase_changed THEN seq_ctr := seq_ctr + 1; END_IF;
    D80 := 1; D81 := 3; D82 := seq_ctr;
    cond := X63;
    arrive_tmr(IN:=cond, PT:=T#40ms);
    IF arrive_tmr.Q THEN phase := 25; END_IF;

25:
    target_b := 0; en_b := TRUE;
    cond := (ABS(D1004-0)<=20) AND (ABS(D1005)<=100);
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 30; END_IF;

30:
    target_a := stationCoord[4]; en_a := TRUE;
    target_b := 0; en_b := TRUE;
    cond := (ABS(D1000-target_a)<=20) AND (ABS(D1001)<=100);
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 31; END_IF;

31:
    target_b := 18000; en_b := TRUE;
    cond := (ABS(D1004-18000)<=20) AND (ABS(D1005)<=100);
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 32; END_IF;

32:
    IF phase_changed THEN seq_ctr := seq_ctr + 1; END_IF;
    D80 := 2; D81 := 4; D82 := seq_ctr;
    cond := X64;
    arrive_tmr(IN:=cond, PT:=T#40ms);
    IF arrive_tmr.Q THEN phase := 33; END_IF;

33:
    D710 := cur_id;
    Y75 := TRUE;
    Y76 := TRUE;
    Y71 := FALSE;
    angle_target := LIMIT(0, D600, 27000);
    target_s40 := angle_target; en_s40 := TRUE;
    cond := (ABS(D1024-angle_target)<=20) AND (ABS(D1025)<=100);
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 34; END_IF;

34:
    Y75 := FALSE;
    IF D620 = 0 THEN
        pin_axis_is1 := TRUE;
        target_s41 := 4000; en_s41 := TRUE;
        en_s42 := FALSE;
    ELSE
        pin_axis_is1 := FALSE;
        target_s42 := 4000; en_s42 := TRUE;
        en_s41 := FALSE;
    END_IF;
    IF pin_axis_is1 THEN
        cond := (ABS(D1028-4000)<=20) AND (ABS(D1029)<=100) AND (D622=cur_id) AND (D624=D91);
    ELSE
        cond := (ABS(D1032-4000)<=20) AND (ABS(D1033)<=100) AND (D622=cur_id) AND (D624=D91);
    END_IF;
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 35; END_IF;

35:
    target_s41 := 0; en_s41 := TRUE;
    target_s42 := 0; en_s42 := TRUE;
    target_s40 := 0; en_s40 := TRUE;
    cond := (ABS(D1028-0)<=20) AND (ABS(D1029)<=100) AND (ABS(D1032-0)<=20) AND (ABS(D1033)<=100)
            AND (ABS(D1024-0)<=20) AND (ABS(D1025)<=100);
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 36; END_IF;

36:
    IF phase_changed THEN seq_ctr := seq_ctr + 1; END_IF;
    D80 := 1; D81 := 4; D82 := seq_ctr;
    cond := X64;
    arrive_tmr(IN:=cond, PT:=T#40ms);
    IF arrive_tmr.Q THEN phase := 37; END_IF;

37:
    target_b := 0; en_b := TRUE;
    cond := (ABS(D1004-0)<=20) AND (ABS(D1005)<=100);
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN
        Y76 := FALSE;
        phase := 40;
    END_IF;

40:
    target_a := stationCoord[lift_station]; en_a := TRUE;
    target_b := 0; en_b := TRUE;
    cond := (ABS(D1000-target_a)<=20) AND (ABS(D1001)<=100);
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 41; END_IF;

41:
    target_b := 18000; en_b := TRUE;
    cond := (ABS(D1004-18000)<=20) AND (ABS(D1005)<=100);
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 42; END_IF;

42:
    IF phase_changed THEN seq_ctr := seq_ctr + 1; END_IF;
    D80 := 2; D81 := lift_station; D82 := seq_ctr;
    IF lift_station = 1 THEN cond := X61; ELSE cond := X62; END_IF;
    arrive_tmr(IN:=cond, PT:=T#40ms);
    IF arrive_tmr.Q THEN phase := 43; END_IF;

43:
    target_b := 0; en_b := TRUE;
    cond := (ABS(D1004-0)<=20) AND (ABS(D1005)<=100);
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 44; END_IF;

44:
    IF lift_station = 1 THEN
        target_c := 15000; en_c := TRUE;
        cond := (ABS(D1008-15000)<=20) AND (ABS(D1009)<=100);
    ELSE
        target_d := 15000; en_d := TRUE;
        cond := (ABS(D1012-15000)<=20) AND (ABS(D1013)<=100);
    END_IF;
    arrive_tmr(IN:=cond, PT:=T#30ms);
    IF arrive_tmr.Q THEN phase := 45; END_IF;

45:
    IF active_req = 0 THEN
        D300 := cur_id;
        IF cur_cancelled THEN D301 := 2; ELSE D301 := 1; END_IF;
    ELSE
        D302 := cur_id;
        IF cur_cancelled THEN D303 := 2; ELSE D303 := 1; END_IF;
    END_IF;
    req_done[active_req] := TRUE;
    phase := 0;

100:
    target_a := 0; en_a := TRUE;
    target_b := 0; en_b := TRUE;
    target_c := 15000; en_c := TRUE;
    target_d := 15000; en_d := TRUE;
    target_s30 := -60000; en_s30 := TRUE;
    target_s31 := -60000; en_s31 := TRUE;
    target_s40 := 0; en_s40 := TRUE;
    target_s41 := 0; en_s41 := TRUE;
    target_s42 := 0; en_s42 := TRUE;
    at_home := (ABS(D1000-0)<=20) AND (ABS(D1001)<=100)
        AND (ABS(D1004-0)<=20) AND (ABS(D1005)<=100)
        AND (ABS(D1008-15000)<=20) AND (ABS(D1009)<=100)
        AND (ABS(D1012-15000)<=20) AND (ABS(D1013)<=100)
        AND (ABS(D1016-(-60000))<=20) AND (ABS(D1017)<=100)
        AND (ABS(D1020-(-60000))<=20) AND (ABS(D1021)<=100)
        AND (ABS(D1024-0)<=20) AND (ABS(D1025)<=100)
        AND (ABS(D1028-0)<=20) AND (ABS(D1029)<=100)
        AND (ABS(D1032-0)<=20) AND (ABS(D1033)<=100);
    Y2 := at_home AND X51;

END_CASE;

D2000 := target_a; D2001 := SEL(en_a, 0, rate_default); D2002 := 0; Y40 := en_a;
D2004 := target_b; D2005 := SEL(en_b, 0, rate_default); D2006 := 0; Y41 := en_b;
D2008 := target_c; D2009 := SEL(en_c, 0, rate_default); D2010 := 0; Y42 := en_c;
D2012 := target_d; D2013 := SEL(en_d, 0, rate_default); D2014 := 0; Y43 := en_d;
D2016 := target_s30; D2017 := SEL(en_s30, 0, rate_default); D2018 := 0; Y44 := en_s30;
D2020 := target_s31; D2021 := SEL(en_s31, 0, rate_default); D2022 := 0; Y45 := en_s31;
D2024 := target_s40; D2025 := SEL(en_s40, 0, rate_default); D2026 := 0; Y46 := en_s40;
D2028 := target_s41; D2029 := SEL(en_s41, 0, rate_default); D2030 := 0; Y47 := en_s41;
D2032 := target_s42; D2033 := SEL(en_s42, 0, rate_default); D2034 := 0; Y48 := en_s42;

D701 := 0; D702 := 0; D711 := 0; D712 := 0;
Y30 := NOT (en_c OR en_d);

prev_phase := phase;

END_PROGRAM