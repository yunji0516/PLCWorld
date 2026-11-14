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

    (* Internal working variables *)
    HOME_C : DINT := 40000;
    HOME_D : DINT := 40000;
    HOME_S3_0 : DINT := -6500;
    HOME_S3_1 : DINT := 0;
    HOME_S3_2 : DINT := 6500;
    HOME_S3_3 : DINT := 0;
    HOME_S4_0 : DINT := -65000;
    HOME_S4_1 : DINT := 65000;
    HOME_S4_2 : DINT := 0;
    tol_pos : DINT := 20;

    c0_phase : INT := 0;
    c0_prev_phase : INT := 0;
    c0_new_phase : BOOL;
    c0_last_id : DINT := 0;
    c0_cancel : BOOL := FALSE;
    c0_cur_seq : DINT := 0;
    c0_status : DINT := 0;

    c1_phase : INT := 0;
    c1_prev_phase : INT := 0;
    c1_new_phase : BOOL;
    c1_last_id : DINT := 0;
    c1_cancel : BOOL := FALSE;
    c1_cur_seq : DINT := 0;
    c1_status : DINT := 0;

    seq_counter : DINT := 0;
    bus_owner : INT := 0;
    c0_needs_bus : BOOL;
    c1_needs_bus : BOOL;

    comp_timer : TON;
    y2_latch : BOOL := FALSE;
    completion_cond : BOOL;
    all_home : BOOL;

    c0_cancel_trig : R_TRIG;
    c1_cancel_trig : R_TRIG;
END_VAR

(* ---- edge detect helper flags ---- *)
c0_new_phase := (c0_phase <> c0_prev_phase);
c1_new_phase := (c1_phase <> c1_prev_phase);

c0_cancel_trig(CLK := X31);
IF c0_cancel_trig.Q AND c0_phase <> 0 THEN
    c0_cancel := TRUE;
END_IF;

c1_cancel_trig(CLK := X35);
IF c1_cancel_trig.Q AND c1_phase <> 0 THEN
    c1_cancel := TRUE;
END_IF;

(* ---- default: hold home for dedicated axes ---- *)
D2008 := HOME_C; D2009 := 250; D2010 := 0; Y42 := TRUE;
D2012 := HOME_D; D2013 := 250; D2014 := 0; Y43 := TRUE;

D2016 := HOME_S3_0; D2017 := 200; D2018 := 0; Y44 := TRUE;
D2020 := HOME_S3_1; D2021 := 200; D2022 := 0; Y45 := TRUE;
D2024 := HOME_S3_2; D2025 := 200; D2026 := 0; Y46 := TRUE;
D2028 := HOME_S3_3; D2029 := 200; D2030 := 0; Y47 := TRUE;

D2032 := HOME_S4_0; D2033 := 250; D2034 := 0; Y48 := TRUE;
D2036 := HOME_S4_1; D2037 := 250; D2038 := 0; Y49 := TRUE;
D2040 := HOME_S4_2; D2041 := 250; D2042 := 0; Y50 := TRUE;

(* ---- bus arbitration for shared shuttle (a) and fork (b) ---- *)
c0_needs_bus := ((c0_phase >= 10) AND (c0_phase <= 15)) OR
                ((c0_phase >= 20) AND (c0_phase <= 23)) OR
                ((c0_phase >= 40) AND (c0_phase <= 43)) OR
                ((c0_phase >= 50) AND (c0_phase <= 53)) OR
                ((c0_phase >= 70) AND (c0_phase <= 73)) OR
                ((c0_phase >= 90) AND (c0_phase <= 95));

c1_needs_bus := ((c1_phase >= 10) AND (c1_phase <= 15)) OR
                ((c1_phase >= 20) AND (c1_phase <= 23)) OR
                ((c1_phase >= 40) AND (c1_phase <= 43)) OR
                ((c1_phase >= 50) AND (c1_phase <= 53)) OR
                ((c1_phase >= 70) AND (c1_phase <= 73)) OR
                ((c1_phase >= 90) AND (c1_phase <= 95));

IF bus_owner = 0 THEN
    IF c0_needs_bus THEN
        bus_owner := 1;
    ELSIF c1_needs_bus THEN
        bus_owner := 2;
    END_IF;
ELSIF bus_owner = 1 THEN
    IF NOT c0_needs_bus THEN
        bus_owner := 0;
        IF c1_needs_bus THEN
            bus_owner := 2;
        END_IF;
    END_IF;
ELSIF bus_owner = 2 THEN
    IF NOT c1_needs_bus THEN
        bus_owner := 0;
        IF c0_needs_bus THEN
            bus_owner := 1;
        END_IF;
    END_IF;
END_IF;

IF bus_owner = 0 THEN
    D2000 := 0; D2001 := 200; D2002 := 0; Y40 := TRUE;
    D2004 := 0; D2005 := 200; D2006 := 0; Y41 := TRUE;
END_IF;

(* =========================== CHANNEL 0 (request r0) =========================== *)
CASE c0_phase OF
0:
    IF (D100 <> 0) AND (D100 <> c0_last_id) THEN
        c0_last_id := D100;
        c0_cancel := FALSE;
        c0_status := 1;
        IF X31 THEN
            c0_cancel := TRUE;
            c0_status := 2;
            c0_phase := 96;
        ELSE
            c0_phase := 10;
        END_IF;
    END_IF;

10:
    IF bus_owner = 1 THEN
        D2000 := D403; D2001 := 300; D2002 := 0; Y40 := TRUE;
        IF ABS(D1000 - D403) <= tol_pos THEN
            c0_phase := 11;
        END_IF;
    END_IF;

11:
    IF bus_owner = 1 THEN
        D2004 := 18000; D2005 := 250; D2006 := 0; Y41 := TRUE;
        IF ABS(D1004 - 18000) <= tol_pos THEN
            c0_phase := 12;
        END_IF;
    END_IF;

12:
    IF bus_owner = 1 THEN
        D2008 := D92; D2009 := 250; D2010 := 0;
        IF ABS(D1008 - D92) <= tol_pos THEN
            c0_phase := 13;
        END_IF;
    END_IF;

13:
    IF bus_owner = 1 THEN
        IF c0_new_phase THEN
            seq_counter := seq_counter + 1;
            c0_cur_seq := seq_counter;
        END_IF;
        D80 := 1; D81 := 1; D82 := c0_cur_seq;
        IF X61 THEN
            c0_phase := 14;
        END_IF;
    END_IF;

14:
    IF bus_owner = 1 THEN
        D2004 := 0; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 0) <= tol_pos THEN
            c0_phase := 15;
        END_IF;
    END_IF;

15:
    IF bus_owner = 1 THEN
        D2008 := HOME_C; D2009 := 250; D2010 := 0;
        IF ABS(D1008 - HOME_C) <= tol_pos THEN
            IF c0_cancel THEN
                c0_phase := 90;
            ELSE
                c0_phase := 20;
            END_IF;
        END_IF;
    END_IF;

20:
    IF bus_owner = 1 THEN
        D2000 := D409; D2001 := 300; D2002 := 0;
        IF ABS(D1000 - D409) <= tol_pos THEN
            c0_phase := 21;
        END_IF;
    END_IF;

21:
    IF bus_owner = 1 THEN
        D2004 := 18000; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 18000) <= tol_pos THEN
            c0_phase := 22;
        END_IF;
    END_IF;

22:
    IF bus_owner = 1 THEN
        IF c0_new_phase THEN
            seq_counter := seq_counter + 1;
            c0_cur_seq := seq_counter;
        END_IF;
        D80 := 2; D81 := 3; D82 := c0_cur_seq;
        IF X63 THEN
            c0_phase := 23;
        END_IF;
    END_IF;

23:
    IF bus_owner = 1 THEN
        D2004 := 0; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 0) <= tol_pos THEN
            IF c0_cancel THEN
                c0_phase := 40;
            ELSE
                c0_phase := 30;
            END_IF;
        END_IF;
    END_IF;

30:
    D2020 := 0; D2021 := 250; D2022 := 0;
    D2016 := HOME_S3_0; D2017 := 200; D2018 := 0;
    IF ABS(D1020 - 0) <= tol_pos THEN
        c0_phase := 31;
    END_IF;

31:
    D2016 := D500; D2017 := 200; D2018 := 0;
    D2020 := 0; D2021 := 250; D2022 := 0;
    IF ABS(D1016 - D500) <= tol_pos THEN
        c0_phase := 32;
    END_IF;

32:
    D2020 := D501; D2021 := 250; D2022 := 0;
    IF ABS(D1020 - D501) <= tol_pos THEN
        c0_phase := 33;
    END_IF;

33:
    IF c0_new_phase THEN
        D700 := c0_last_id; D701 := D526; D702 := 500; Y70 := TRUE;
    ELSE
        Y70 := FALSE;
    END_IF;
    Y71 := TRUE;
    IF X70 THEN
        c0_phase := 34;
    END_IF;

34:
    D2020 := 0; D2021 := 250; D2022 := 0;
    Y71 := FALSE;
    IF ABS(D1020 - 0) <= tol_pos THEN
        c0_phase := 35;
    END_IF;

35:
    D2016 := HOME_S3_0; D2017 := 200; D2018 := 0;
    IF ABS(D1016 - HOME_S3_0) <= tol_pos THEN
        c0_phase := 40;
    END_IF;

40:
    IF bus_owner = 1 THEN
        D2000 := D409; D2001 := 300; D2002 := 0;
        IF ABS(D1000 - D409) <= tol_pos THEN
            c0_phase := 41;
        END_IF;
    END_IF;

41:
    IF bus_owner = 1 THEN
        D2004 := 18000; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 18000) <= tol_pos THEN
            c0_phase := 42;
        END_IF;
    END_IF;

42:
    IF bus_owner = 1 THEN
        IF c0_new_phase THEN
            seq_counter := seq_counter + 1;
            c0_cur_seq := seq_counter;
        END_IF;
        D80 := 1; D81 := 3; D82 := c0_cur_seq;
        IF X63 THEN
            c0_phase := 43;
        END_IF;
    END_IF;

43:
    IF bus_owner = 1 THEN
        D2004 := 0; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 0) <= tol_pos THEN
            IF c0_cancel THEN
                c0_phase := 90;
            ELSE
                c0_phase := 50;
            END_IF;
        END_IF;
    END_IF;

50:
    IF bus_owner = 1 THEN
        D2000 := D412; D2001 := 300; D2002 := 0;
        IF ABS(D1000 - D412) <= tol_pos THEN
            c0_phase := 51;
        END_IF;
    END_IF;

51:
    IF bus_owner = 1 THEN
        D2004 := 18000; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 18000) <= tol_pos THEN
            c0_phase := 52;
        END_IF;
    END_IF;

52:
    IF bus_owner = 1 THEN
        IF c0_new_phase THEN
            seq_counter := seq_counter + 1;
            c0_cur_seq := seq_counter;
        END_IF;
        D80 := 2; D81 := 4; D82 := c0_cur_seq;
        IF X64 THEN
            c0_phase := 53;
        END_IF;
    END_IF;

53:
    IF bus_owner = 1 THEN
        D2004 := 0; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 0) <= tol_pos THEN
            IF c0_cancel THEN
                c0_phase := 70;
            ELSE
                c0_phase := 60;
            END_IF;
        END_IF;
    END_IF;

60:
    IF c0_new_phase THEN
        D710 := c0_last_id; D711 := D626; D712 := 500; Y75 := TRUE;
    ELSE
        Y75 := FALSE;
    END_IF;
    Y76 := TRUE;
    D2032 := D600; D2033 := 250; D2034 := 0;
    D2040 := D602; D2041 := 250; D2042 := 0;
    IF (ABS(D1032 - D600) <= tol_pos) AND (ABS(D1040 - D602) <= tol_pos) THEN
        c0_phase := 61;
    END_IF;

61:
    IF X75 THEN
        c0_phase := 62;
    END_IF;

62:
    D2032 := HOME_S4_0; D2033 := 250; D2034 := 0;
    D2040 := HOME_S4_2; D2041 := 250; D2042 := 0;
    Y76 := FALSE;
    IF (ABS(D1032 - HOME_S4_0) <= tol_pos) AND (ABS(D1040 - HOME_S4_2) <= tol_pos) THEN
        c0_phase := 70;
    END_IF;

70:
    IF bus_owner = 1 THEN
        D2000 := D412; D2001 := 300; D2002 := 0;
        IF ABS(D1000 - D412) <= tol_pos THEN
            c0_phase := 71;
        END_IF;
    END_IF;

71:
    IF bus_owner = 1 THEN
        D2004 := 18000; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 18000) <= tol_pos THEN
            c0_phase := 72;
        END_IF;
    END_IF;

72:
    IF bus_owner = 1 THEN
        IF c0_new_phase THEN
            seq_counter := seq_counter + 1;
            c0_cur_seq := seq_counter;
        END_IF;
        D80 := 1; D81 := 4; D82 := c0_cur_seq;
        IF X64 THEN
            c0_phase := 73;
        END_IF;
    END_IF;

73:
    IF bus_owner = 1 THEN
        D2004 := 0; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 0) <= tol_pos THEN
            c0_phase := 90;
        END_IF;
    END_IF;

90:
    IF bus_owner = 1 THEN
        D2000 := D403; D2001 := 300; D2002 := 0;
        IF ABS(D1000 - D403) <= tol_pos THEN
            c0_phase := 91;
        END_IF;
    END_IF;

91:
    IF bus_owner = 1 THEN
        D2004 := 18000; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 18000) <= tol_pos THEN
            c0_phase := 92;
        END_IF;
    END_IF;

92:
    IF bus_owner = 1 THEN
        D2008 := D92; D2009 := 250; D2010 := 0;
        IF ABS(D1008 - D92) <= tol_pos THEN
            c0_phase := 93;
        END_IF;
    END_IF;

93:
    IF bus_owner = 1 THEN
        IF c0_new_phase THEN
            seq_counter := seq_counter + 1;
            c0_cur_seq := seq_counter;
        END_IF;
        D80 := 2; D81 := 1; D82 := c0_cur_seq;
        IF X61 THEN
            c0_phase := 94;
        END_IF;
    END_IF;

94:
    IF bus_owner = 1 THEN
        D2004 := 0; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 0) <= tol_pos THEN
            c0_phase := 95;
        END_IF;
    END_IF;

95:
    IF bus_owner = 1 THEN
        D2008 := HOME_C; D2009 := 250; D2010 := 0;
        IF ABS(D1008 - HOME_C) <= tol_pos THEN
            c0_phase := 96;
        END_IF;
    END_IF;

96:
    D300 := c0_last_id;
    D301 := c0_status;
    c0_phase := 0;

ELSE
    c0_phase := 0;
END_CASE;

(* =========================== CHANNEL 1 (request r1) =========================== *)
CASE c1_phase OF
0:
    IF (D120 <> 0) AND (D120 <> c1_last_id) THEN
        c1_last_id := D120;
        c1_cancel := FALSE;
        c1_status := 1;
        IF X35 THEN
            c1_cancel := TRUE;
            c1_status := 2;
            c1_phase := 96;
        ELSE
            c1_phase := 10;
        END_IF;
    END_IF;

10:
    IF bus_owner = 2 THEN
        D2000 := D406; D2001 := 300; D2002 := 0; Y40 := TRUE;
        IF ABS(D1000 - D406) <= tol_pos THEN
            c1_phase := 11;
        END_IF;
    END_IF;

11:
    IF bus_owner = 2 THEN
        D2004 := 18000; D2005 := 250; D2006 := 0; Y41 := TRUE;
        IF ABS(D1004 - 18000) <= tol_pos THEN
            c1_phase := 12;
        END_IF;
    END_IF;

12:
    IF bus_owner = 2 THEN
        D2012 := D92; D2013 := 250; D2014 := 0;
        IF ABS(D1012 - D92) <= tol_pos THEN
            c1_phase := 13;
        END_IF;
    END_IF;

13:
    IF bus_owner = 2 THEN
        IF c1_new_phase THEN
            seq_counter := seq_counter + 1;
            c1_cur_seq := seq_counter;
        END_IF;
        D80 := 1; D81 := 2; D82 := c1_cur_seq;
        IF X62 THEN
            c1_phase := 14;
        END_IF;
    END_IF;

14:
    IF bus_owner = 2 THEN
        D2004 := 0; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 0) <= tol_pos THEN
            c1_phase := 15;
        END_IF;
    END_IF;

15:
    IF bus_owner = 2 THEN
        D2012 := HOME_D; D2013 := 250; D2014 := 0;
        IF ABS(D1012 - HOME_D) <= tol_pos THEN
            IF c1_cancel THEN
                c1_phase := 90;
            ELSE
                c1_phase := 20;
            END_IF;
        END_IF;
    END_IF;

20:
    IF bus_owner = 2 THEN
        D2000 := D409; D2001 := 300; D2002 := 0;
        IF ABS(D1000 - D409) <= tol_pos THEN
            c1_phase := 21;
        END_IF;
    END_IF;

21:
    IF bus_owner = 2 THEN
        D2004 := 18000; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 18000) <= tol_pos THEN
            c1_phase := 22;
        END_IF;
    END_IF;

22:
    IF bus_owner = 2 THEN
        IF c1_new_phase THEN
            seq_counter := seq_counter + 1;
            c1_cur_seq := seq_counter;
        END_IF;
        D80 := 2; D81 := 3; D82 := c1_cur_seq;
        IF X63 THEN
            c1_phase := 23;
        END_IF;
    END_IF;

23:
    IF bus_owner = 2 THEN
        D2004 := 0; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 0) <= tol_pos THEN
            IF c1_cancel THEN
                c1_phase := 40;
            ELSE
                c1_phase := 30;
            END_IF;
        END_IF;
    END_IF;

30:
    D2028 := 0; D2029 := 250; D2030 := 0;
    D2024 := HOME_S3_2; D2025 := 200; D2026 := 0;
    IF ABS(D1028 - 0) <= tol_pos THEN
        c1_phase := 31;
    END_IF;

31:
    D2024 := D502; D2025 := 200; D2026 := 0;
    D2028 := 0; D2029 := 250; D2030 := 0;
    IF ABS(D1024 - D502) <= tol_pos THEN
        c1_phase := 32;
    END_IF;

32:
    D2028 := D503; D2029 := 250; D2030 := 0;
    IF ABS(D1028 - D503) <= tol_pos THEN
        c1_phase := 33;
    END_IF;

33:
    IF c1_new_phase THEN
        D700 := c1_last_id; D701 := D526; D702 := 500; Y70 := TRUE;
    ELSE
        Y70 := FALSE;
    END_IF;
    Y71 := TRUE;
    IF X70 THEN
        c1_phase := 34;
    END_IF;

34:
    D2028 := 0; D2029 := 250; D2030 := 0;
    Y71 := FALSE;
    IF ABS(D1028 - 0) <= tol_pos THEN
        c1_phase := 35;
    END_IF;

35:
    D2024 := HOME_S3_2; D2025 := 200; D2026 := 0;
    IF ABS(D1024 - HOME_S3_2) <= tol_pos THEN
        c1_phase := 40;
    END_IF;

40:
    IF bus_owner = 2 THEN
        D2000 := D409; D2001 := 300; D2002 := 0;
        IF ABS(D1000 - D409) <= tol_pos THEN
            c1_phase := 41;
        END_IF;
    END_IF;

41:
    IF bus_owner = 2 THEN
        D2004 := 18000; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 18000) <= tol_pos THEN
            c1_phase := 42;
        END_IF;
    END_IF;

42:
    IF bus_owner = 2 THEN
        IF c1_new_phase THEN
            seq_counter := seq_counter + 1;
            c1_cur_seq := seq_counter;
        END_IF;
        D80 := 1; D81 := 3; D82 := c1_cur_seq;
        IF X63 THEN
            c1_phase := 43;
        END_IF;
    END_IF;

43:
    IF bus_owner = 2 THEN
        D2004 := 0; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 0) <= tol_pos THEN
            IF c1_cancel THEN
                c1_phase := 90;
            ELSE
                c1_phase := 50;
            END_IF;
        END_IF;
    END_IF;

50:
    IF bus_owner = 2 THEN
        D2000 := D412; D2001 := 300; D2002 := 0;
        IF ABS(D1000 - D412) <= tol_pos THEN
            c1_phase := 51;
        END_IF;
    END_IF;

51:
    IF bus_owner = 2 THEN
        D2004 := 18000; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 18000) <= tol_pos THEN
            c1_phase := 52;
        END_IF;
    END_IF;

52:
    IF bus_owner = 2 THEN
        IF c1_new_phase THEN
            seq_counter := seq_counter + 1;
            c1_cur_seq := seq_counter;
        END_IF;
        D80 := 2; D81 := 4; D82 := c1_cur_seq;
        IF X64 THEN
            c1_phase := 53;
        END_IF;
    END_IF;

53:
    IF bus_owner = 2 THEN
        D2004 := 0; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 0) <= tol_pos THEN
            IF c1_cancel THEN
                c1_phase := 70;
            ELSE
                c1_phase := 60;
            END_IF;
        END_IF;
    END_IF;

60:
    IF c1_new_phase THEN
        D710 := c1_last_id; D711 := D626; D712 := 500; Y75 := TRUE;
    ELSE
        Y75 := FALSE;
    END_IF;
    Y76 := TRUE;
    D2036 := D601; D2037 := 250; D2038 := 0;
    IF ABS(D1036 - D601) <= tol_pos THEN
        c1_phase := 61;
    END_IF;

61:
    IF X75 THEN
        c1_phase := 62;
    END_IF;

62:
    D2036 := HOME_S4_1; D2037 := 250; D2038 := 0;
    Y76 := FALSE;
    IF ABS(D1036 - HOME_S4_1) <= tol_pos THEN
        c1_phase := 70;
    END_IF;

70:
    IF bus_owner = 2 THEN
        D2000 := D412; D2001 := 300; D2002 := 0;
        IF ABS(D1000 - D412) <= tol_pos THEN
            c1_phase := 71;
        END_IF;
    END_IF;

71:
    IF bus_owner = 2 THEN
        D2004 := 18000; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 18000) <= tol_pos THEN
            c1_phase := 72;
        END_IF;
    END_IF;

72:
    IF bus_owner = 2 THEN
        IF c1_new_phase THEN
            seq_counter := seq_counter + 1;
            c1_cur_seq := seq_counter;
        END_IF;
        D80 := 1; D81 := 4; D82 := c1_cur_seq;
        IF X64 THEN
            c1_phase := 73;
        END_IF;
    END_IF;

73:
    IF bus_owner = 2 THEN
        D2004 := 0; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 0) <= tol_pos THEN
            c1_phase := 90;
        END_IF;
    END_IF;

90:
    IF bus_owner = 2 THEN
        D2000 := D406; D2001 := 300; D2002 := 0;
        IF ABS(D1000 - D406) <= tol_pos THEN
            c1_phase := 91;
        END_IF;
    END_IF;

91:
    IF bus_owner = 2 THEN
        D2004 := 18000; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 18000) <= tol_pos THEN
            c1_phase := 92;
        END_IF;
    END_IF;

92:
    IF bus_owner = 2 THEN
        D2012 := D92; D2013 := 250; D2014 := 0;
        IF ABS(D1012 - D92) <= tol_pos THEN
            c1_phase := 93;
        END_IF;
    END_IF;

93:
    IF bus_owner = 2 THEN
        IF c1_new_phase THEN
            seq_counter := seq_counter + 1;
            c1_cur_seq := seq_counter;
        END_IF;
        D80 := 2; D81 := 2; D82 := c1_cur_seq;
        IF X62 THEN
            c1_phase := 94;
        END_IF;
    END_IF;

94:
    IF bus_owner = 2 THEN
        D2004 := 0; D2005 := 250; D2006 := 0;
        IF ABS(D1004 - 0) <= tol_pos THEN
            c1_phase := 95;
        END_IF;
    END_IF;

95:
    IF bus_owner = 2 THEN
        D2012 := HOME_D; D2013 := 250; D2014 := 0;
        IF ABS(D1012 - HOME_D) <= tol_pos THEN
            c1_phase := 96;
        END_IF;
    END_IF;

96:
    D302 := c1_last_id;
    D303 := c1_status;
    c1_phase := 0;

ELSE
    c1_phase := 0;
END_CASE;

(* ---- completion evaluation ---- *)
all_home := (ABS(D1000 - 0) <= tol_pos) AND (ABS(D1004 - 0) <= tol_pos) AND
            (ABS(D1008 - HOME_C) <= tol_pos) AND (ABS(D1012 - HOME_D) <= tol_pos) AND
            (ABS(D1016 - HOME_S3_0) <= tol_pos) AND (ABS(D1020 - HOME_S3_1) <= tol_pos) AND
            (ABS(D1024 - HOME_S3_2) <= tol_pos) AND (ABS(D1028 - HOME_S3_3) <= tol_pos) AND
            (ABS(D1032 - HOME_S4_0) <= tol_pos) AND (ABS(D1036 - HOME_S4_1) <= tol_pos) AND
            (ABS(D1040 - HOME_S4_2) <= tol_pos);

completion_cond := X51 AND (c0_phase = 0) AND (c1_phase = 0) AND all_home;

comp_timer(IN := completion_cond, PT := T#100ms);

IF comp_timer.Q THEN
    y2_latch := TRUE;
END_IF;

Y2 := y2_latch;
Y30 := (bus_owner = 0);

(* ---- save phase history for edge detection ---- *)
c0_prev_phase := c0_phase;
c1_prev_phase := c1_phase;

END_PROGRAM