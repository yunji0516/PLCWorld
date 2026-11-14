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
    D1040 : DINT;
    D1041 : DINT;
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
    D503 : DINT;
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
    D2040 : DINT;
    D2041 : DINT;
    D2042 : DINT;
    Y50 : BOOL;
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
    phase        : INT := 0;
    req_idx      : INT := 0;
    cur_id       : DINT := 0;
    cur_loc      : INT := 1;
    cancel_active: BOOL := FALSE;
    seq_counter  : DINT := 0;
    ready_tmp    : BOOL := FALSE;

    (* commanded targets / rates, persistent *)
    a_tgt   : DINT := 0;
    b_tgt   : DINT := 0;
    lift_tgt: DINT := 40000;
    s30_tgt : DINT := -6500;
    s31_tgt : DINT := 0;
    s32_tgt : DINT := 6500;
    s33_tgt : DINT := 0;
    s40_tgt : DINT := -65000;
    s41_tgt : DINT := 65000;
    s42_tgt : DINT := 0;

    a_rate    : DINT := 200;
    b_rate    : DINT := 200;
    lift_rate : DINT := 200;
    s3_rate   : DINT := 200;
    s4_rate   : DINT := 200;

    TOL  : DINT := 20;
    VTOL : DINT := 100;

    (* home constants (fixed values, unchanged) *)
    HOME_A   : DINT := 0;
    HOME_B   : DINT := 0;
    HOME_C   : DINT := 40000;
    HOME_S30 : DINT := -6500;
    HOME_S31 : DINT := 0;
    HOME_S32 : DINT := 6500;
    HOME_S33 : DINT := 0;
    HOME_S40 : DINT := -65000;
    HOME_S41 : DINT := 65000;
    HOME_S42 : DINT := 0;

    hold_timer : TON;
END_VAR

(* ---- mid-process cancellation watchdog: jump to return-to-origin sequence ---- *)
IF (req_idx = 0 AND X31 AND phase >= 10 AND phase < 80) OR
   (req_idx = 1 AND X35 AND phase >= 10 AND phase < 80) THEN
    IF NOT cancel_active THEN
        cancel_active := TRUE;
        phase := 80;
    END_IF;
END_IF;

CASE phase OF

0: (* select next request *)
    IF req_idx = 0 THEN
        cur_id := D100;
        IF D101 = 1 OR D101 = 2 THEN cur_loc := INT(D101); ELSE cur_loc := 1; END_IF;
        IF X31 THEN
            cancel_active := TRUE;
            phase := 95;
        ELSE
            cancel_active := FALSE;
            phase := 10;
        END_IF;
    ELSIF req_idx = 1 THEN
        cur_id := D120;
        IF D121 = 1 OR D121 = 2 THEN cur_loc := INT(D121); ELSE cur_loc := 1; END_IF;
        IF X35 THEN
            cancel_active := TRUE;
            phase := 95;
        ELSE
            cancel_active := FALSE;
            phase := 10;
        END_IF;
    ELSE
        phase := 300;
    END_IF;

10: (* move shuttle to origin lift station *)
    IF cur_loc = 1 THEN a_tgt := D403; ELSE a_tgt := D406; END_IF;
    a_rate := 200;
    IF ABS(D1000 - a_tgt) <= TOL AND ABS(D1001) <= VTOL THEN
        phase := 11;
    END_IF;

11: (* dock origin lift *)
    lift_tgt := D92;
    lift_rate := 200;
    IF ABS(D1008 - lift_tgt) <= TOL AND ABS(D1009) <= VTOL AND
       ABS(D1012 - lift_tgt) <= TOL AND ABS(D1013) <= VTOL THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D80 := 1;
        D81 := DINT(cur_loc);
        phase := 12;
    END_IF;

12: (* extend fork to grab jig at origin *)
    b_tgt := 18000;
    b_rate := 100;
    IF cur_loc = 1 THEN ready_tmp := X61; ELSE ready_tmp := X62; END_IF;
    IF ABS(D1004 - b_tgt) <= TOL AND ABS(D1005) <= VTOL AND ready_tmp THEN
        phase := 13;
    END_IF;

13: (* retract fork - jig now on shuttle *)
    b_tgt := 0;
    b_rate := 100;
    IF ABS(D1004 - b_tgt) <= TOL AND ABS(D1005) <= VTOL THEN
        phase := 14;
    END_IF;

14: (* start returning origin lift home in parallel, proceed *)
    lift_tgt := HOME_C;
    lift_rate := 100;
    phase := 20;

20: (* move shuttle to cell 3 *)
    a_tgt := D409;
    a_rate := 200;
    IF ABS(D1000 - a_tgt) <= TOL AND ABS(D1001) <= VTOL THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D80 := 2;
        D81 := 3;
        phase := 21;
    END_IF;

21: (* extend fork to place jig at cell3 *)
    b_tgt := 18000;
    b_rate := 100;
    IF ABS(D1004 - b_tgt) <= TOL AND ABS(D1005) <= VTOL AND X63 THEN
        phase := 22;
    END_IF;

22: (* retract fork - jig placed at cell3 *)
    b_tgt := 0;
    b_rate := 100;
    IF ABS(D1004 - b_tgt) <= TOL AND ABS(D1005) <= VTOL THEN
        phase := 30;
    END_IF;

30: (* retract boom before swiveling *)
    s31_tgt := 0;
    s33_tgt := 0;
    s3_rate := 200;
    IF ABS(D1020 - s31_tgt) <= TOL AND ABS(D1021) <= VTOL AND
       ABS(D1028 - s33_tgt) <= TOL AND ABS(D1029) <= VTOL THEN
        phase := 31;
    END_IF;

31: (* swivel to requested angles *)
    s30_tgt := D500;
    s32_tgt := D502;
    s3_rate := 200;
    IF ABS(D1016 - s30_tgt) <= TOL AND ABS(D1017) <= VTOL AND
       ABS(D1024 - s32_tgt) <= TOL AND ABS(D1025) <= VTOL THEN
        phase := 32;
    END_IF;

32: (* extend boom to requested length *)
    s31_tgt := D501;
    s33_tgt := D503;
    s3_rate := 200;
    IF ABS(D1020 - s31_tgt) <= TOL AND ABS(D1021) <= VTOL AND
       ABS(D1028 - s33_tgt) <= TOL AND ABS(D1029) <= VTOL THEN
        phase := 33;
    END_IF;

33: (* trigger cell3 processing *)
    Y70 := TRUE;
    D700 := cur_id;
    D701 := D520;
    D702 := 500;
    IF X70 OR X71 THEN
        phase := 34;
    END_IF;

34:
    Y70 := FALSE;
    Y71 := TRUE;
    seq_counter := seq_counter + 1;
    D82 := seq_counter;
    D80 := 1;
    D81 := 3;
    phase := 40;

40: (* extend fork to re-take jig from cell3 *)
    b_tgt := 18000;
    b_rate := 100;
    IF ABS(D1004 - b_tgt) <= TOL AND ABS(D1005) <= VTOL AND X63 THEN
        phase := 41;
    END_IF;

41: (* retract fork - jig back on shuttle *)
    b_tgt := 0;
    b_rate := 100;
    IF ABS(D1004 - b_tgt) <= TOL AND ABS(D1005) <= VTOL THEN
        Y71 := FALSE;
        phase := 50;
    END_IF;

50: (* move shuttle to cell4 *)
    a_tgt := D412;
    a_rate := 200;
    IF ABS(D1000 - a_tgt) <= TOL AND ABS(D1001) <= VTOL THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D80 := 2;
        D81 := 4;
        phase := 51;
    END_IF;

51: (* extend fork to place jig at cell4 *)
    b_tgt := 18000;
    b_rate := 100;
    IF ABS(D1004 - b_tgt) <= TOL AND ABS(D1005) <= VTOL AND X64 THEN
        phase := 52;
    END_IF;

52: (* retract fork - jig placed at cell4 *)
    b_tgt := 0;
    b_rate := 100;
    IF ABS(D1004 - b_tgt) <= TOL AND ABS(D1005) <= VTOL THEN
        phase := 60;
    END_IF;

60: (* move exchange head axes to requested positions *)
    s40_tgt := D600;
    s41_tgt := D601;
    s42_tgt := D602;
    s4_rate := 200;
    IF ABS(D1032 - s40_tgt) <= TOL AND ABS(D1033) <= VTOL AND
       ABS(D1036 - s41_tgt) <= TOL AND ABS(D1037) <= VTOL AND
       ABS(D1040 - s42_tgt) <= TOL AND ABS(D1041) <= VTOL THEN
        phase := 61;
    END_IF;

61: (* trigger cell4 processing *)
    Y75 := TRUE;
    D710 := cur_id;
    D711 := D620;
    D712 := 500;
    IF X75 OR X76 THEN
        phase := 62;
    END_IF;

62:
    Y75 := FALSE;
    Y76 := TRUE;
    seq_counter := seq_counter + 1;
    D82 := seq_counter;
    D80 := 1;
    D81 := 4;
    phase := 70;

70: (* extend fork to re-take jig from cell4 *)
    b_tgt := 18000;
    b_rate := 100;
    IF ABS(D1004 - b_tgt) <= TOL AND ABS(D1005) <= VTOL AND X64 THEN
        phase := 71;
    END_IF;

71: (* retract fork - jig back on shuttle *)
    b_tgt := 0;
    b_rate := 100;
    IF ABS(D1004 - b_tgt) <= TOL AND ABS(D1005) <= VTOL THEN
        Y76 := FALSE;
        phase := 80;
    END_IF;

80: (* move shuttle back to origin lift station *)
    IF cur_loc = 1 THEN a_tgt := D403; ELSE a_tgt := D406; END_IF;
    a_rate := 200;
    IF ABS(D1000 - a_tgt) <= TOL AND ABS(D1001) <= VTOL THEN
        phase := 81;
    END_IF;

81: (* re-dock origin lift *)
    lift_tgt := D92;
    lift_rate := 200;
    IF ABS(D1008 - lift_tgt) <= TOL AND ABS(D1009) <= VTOL AND
       ABS(D1012 - lift_tgt) <= TOL AND ABS(D1013) <= VTOL THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D80 := 2;
        D81 := DINT(cur_loc);
        phase := 82;
    END_IF;

82: (* extend fork to place jig back at origin *)
    b_tgt := 18000;
    b_rate := 100;
    IF cur_loc = 1 THEN ready_tmp := X61; ELSE ready_tmp := X62; END_IF;
    IF ABS(D1004 - b_tgt) <= TOL AND ABS(D1005) <= VTOL AND ready_tmp THEN
        phase := 83;
    END_IF;

83: (* retract fork - jig placed back at origin *)
    b_tgt := 0;
    b_rate := 100;
    IF ABS(D1004 - b_tgt) <= TOL AND ABS(D1005) <= VTOL THEN
        phase := 84;
    END_IF;

84: (* lower lift to initial height *)
    lift_tgt := HOME_C;
    lift_rate := 100;
    IF ABS(D1008 - lift_tgt) <= TOL AND ABS(D1009) <= VTOL AND
       ABS(D1012 - lift_tgt) <= TOL AND ABS(D1013) <= VTOL THEN
        phase := 90;
    END_IF;

90: (* wait for plant-confirmed return *)
    IF req_idx = 0 THEN
        IF X30 THEN phase := 95; END_IF;
    ELSE
        IF X34 THEN phase := 95; END_IF;
    END_IF;

95: (* respond with ack/status *)
    IF req_idx = 0 THEN
        D300 := cur_id;
        IF cancel_active THEN D301 := 2; ELSE D301 := 1; END_IF;
    ELSE
        D302 := cur_id;
        IF cancel_active THEN D303 := 2; ELSE D303 := 1; END_IF;
    END_IF;
    cancel_active := FALSE;
    req_idx := req_idx + 1;
    phase := 0;

300: (* final withdrawal to initial connection posture *)
    a_tgt := HOME_A;
    b_tgt := HOME_B;
    lift_tgt := HOME_C;
    s30_tgt := HOME_S30;
    s31_tgt := HOME_S31;
    s32_tgt := HOME_S32;
    s33_tgt := HOME_S33;
    s40_tgt := HOME_S40;
    s41_tgt := HOME_S41;
    s42_tgt := HOME_S42;
    a_rate := 100;
    b_rate := 100;
    lift_rate := 100;
    s3_rate := 100;
    s4_rate := 100;
    IF ABS(D1000 - HOME_A) <= TOL AND ABS(D1001) <= VTOL AND
       ABS(D1004 - HOME_B) <= TOL AND ABS(D1005) <= VTOL AND
       ABS(D1008 - HOME_C) <= TOL AND ABS(D1009) <= VTOL AND
       ABS(D1012 - HOME_C) <= TOL AND ABS(D1013) <= VTOL AND
       ABS(D1016 - HOME_S30) <= TOL AND ABS(D1017) <= VTOL AND
       ABS(D1020 - HOME_S31) <= TOL AND ABS(D1021) <= VTOL AND
       ABS(D1024 - HOME_S32) <= TOL AND ABS(D1025) <= VTOL AND
       ABS(D1028 - HOME_S33) <= TOL AND ABS(D1029) <= VTOL AND
       ABS(D1032 - HOME_S40) <= TOL AND ABS(D1033) <= VTOL AND
       ABS(D1036 - HOME_S41) <= TOL AND ABS(D1037) <= VTOL AND
       ABS(D1040 - HOME_S42) <= TOL AND ABS(D1041) <= VTOL THEN
        phase := 310;
    END_IF;

310: (* observe completion condition for 100ms *)
    hold_timer(IN := X51 AND
        (ABS(D1000 - HOME_A) <= TOL) AND (ABS(D1004 - HOME_B) <= TOL) AND
        (ABS(D1008 - HOME_C) <= TOL) AND (ABS(D1012 - HOME_C) <= TOL) AND
        (ABS(D1016 - HOME_S30) <= TOL) AND (ABS(D1020 - HOME_S31) <= TOL) AND
        (ABS(D1024 - HOME_S32) <= TOL) AND (ABS(D1028 - HOME_S33) <= TOL) AND
        (ABS(D1032 - HOME_S40) <= TOL) AND (ABS(D1036 - HOME_S41) <= TOL) AND
        (ABS(D1040 - HOME_S42) <= TOL),
        PT := T#100ms);
    IF hold_timer.Q THEN
        Y2 := TRUE;
        phase := 320;
    END_IF;

320: (* maintain completed state *)
    Y2 := TRUE;
    a_tgt := HOME_A;
    b_tgt := HOME_B;
    lift_tgt := HOME_C;
    s30_tgt := HOME_S30;
    s31_tgt := HOME_S31;
    s32_tgt := HOME_S32;
    s33_tgt := HOME_S33;
    s40_tgt := HOME_S40;
    s41_tgt := HOME_S41;
    s42_tgt := HOME_S42;

ELSE
    phase := 0;

END_CASE;

(* ---- write outputs every scan ---- *)
D2000 := a_tgt;    D2001 := a_rate;    D2002 := 0;  Y40 := TRUE;
D2004 := b_tgt;    D2005 := b_rate;    D2006 := 0;  Y41 := TRUE;
D2008 := lift_tgt; D2009 := lift_rate; D2010 := 0;  Y42 := TRUE;
D2012 := lift_tgt; D2013 := lift_rate; D2014 := 0;  Y43 := TRUE;
D2016 := s30_tgt;  D2017 := s3_rate;   D2018 := 0;  Y44 := TRUE;
D2020 := s31_tgt;  D2021 := s3_rate;   D2022 := 0;  Y45 := TRUE;
D2024 := s32_tgt;  D2025 := s3_rate;   D2026 := 0;  Y46 := TRUE;
D2028 := s33_tgt;  D2029 := s3_rate;   D2030 := 0;  Y47 := TRUE;
D2032 := s40_tgt;  D2033 := s4_rate;   D2034 := 0;  Y48 := TRUE;
D2036 := s41_tgt;  D2037 := s4_rate;   D2038 := 0;  Y49 := TRUE;
D2040 := s42_tgt;  D2041 := s4_rate;   D2042 := 0;  Y50 := TRUE;

Y30 := (ABS(D1000 - a_tgt) <= TOL);

END_PROGRAM