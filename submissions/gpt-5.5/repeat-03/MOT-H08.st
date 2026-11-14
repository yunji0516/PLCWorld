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
    init_done : BOOL;
    state : INT;
    current_slot : INT;
    current_id : DINT;
    origin_station : DINT;
    return_status : DINT;
    prev_r0 : DINT;
    prev_r1 : DINT;
    couple_issued : BOOL;
    seq_no : DINT;
    a_goal : DINT;
    b_goal : DINT;
    lift_goal : DINT;
    s3_0_goal : DINT;
    s3_1_goal : DINT;
    s4_0_goal : DINT;
    s4_1_goal : DINT;
    s4_2_goal : DINT;
    lift_sp : DINT;
    s3_0_sp : DINT;
    s3_1_sp : DINT;
    s4_0_sp : DINT;
    s4_1_sp : DINT;
    port_x : DINT;
    port_id : DINT;
    port_ready : BOOL;
    origin_port_id : DINT;
    origin_ready : BOOL;
    pending0 : BOOL;
    pending1 : BOOL;
    final_cond : BOOL;
    r0_cancel : BOOL;
    r1_cancel : BOOL;
    s3_done : BOOL;
    s4_done : BOOL;
    at_a : BOOL;
    at_b : BOOL;
    at_lift_dock : BOOL;
    at_lift_home : BOOL;
    at_s3_home : BOOL;
    at_s4_home : BOOL;
    at_s3_goal : BOOL;
    at_s4_goal : BOOL;
    moment_abs : REAL;
    sin0 : REAL;
    sin1 : REAL;
    cw_real : REAL;
    avg_s3 : DINT;
    tmp : DINT;
END_VAR

IF NOT init_done THEN
    init_done := TRUE;
    lift_sp := D1008;
    s3_0_sp := D1016;
    s3_1_sp := D1020;
    s4_0_sp := D1024;
    s4_1_sp := D1028;
    seq_no := D82;
    state := 0;
    current_slot := -1;
END_IF;

IF D100 <> prev_r0 THEN
    D300 := 0;
    D301 := 0;
    prev_r0 := D100;
END_IF;

IF D120 <> prev_r1 THEN
    D302 := 0;
    D303 := 0;
    prev_r1 := D120;
END_IF;

pending0 := (D100 <> 0) AND (D300 <> D100);
pending1 := (D120 <> 0) AND (D302 <> D120);
r0_cancel := X31;
r1_cancel := X35;

a_goal := 0;
b_goal := 0;
lift_goal := 40000;
s3_0_goal := -60000;
s3_1_goal := -60000;
s4_0_goal := 0;
s4_1_goal := 0;
s4_2_goal := 0;

Y70 := FALSE;
Y71 := FALSE;
D700 := 0;
D701 := 0;
D702 := 1000;
Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := 0;
D712 := 1000;

D80 := 0;
D81 := 0;

IF state = 0 THEN
    couple_issued := FALSE;
    current_id := 0;
    current_slot := -1;
    IF pending0 THEN
        current_slot := 0;
        current_id := D100;
        origin_station := D101;
        IF (origin_station < 1) OR (origin_station > 2) THEN
            origin_station := 1;
        END_IF;
        IF r0_cancel THEN
            return_status := 2;
        ELSE
            return_status := 1;
        END_IF;
        state := 10;
    ELSIF pending1 THEN
        current_slot := 1;
        current_id := D120;
        origin_station := D121;
        IF (origin_station < 1) OR (origin_station > 2) THEN
            origin_station := 2;
        END_IF;
        IF r1_cancel THEN
            return_status := 2;
        ELSE
            return_status := 1;
        END_IF;
        state := 10;
    END_IF;
END_IF;

IF D92 < 0 THEN
    tmp := 0;
ELSIF D92 > 120000 THEN
    tmp := 120000;
ELSE
    tmp := D92;
END_IF;

CASE state OF
0:
    a_goal := 0;
    b_goal := 0;
    lift_goal := 40000;
    s3_0_goal := -60000;
    s3_1_goal := -60000;
    s4_0_goal := 0;
    s4_1_goal := 0;

10:
    lift_goal := tmp;
    b_goal := 0;
    IF (ABS(D1008 - lift_goal) <= 20) AND (ABS(D1012 - lift_goal) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) THEN
        state := 20;
    END_IF;

20:
    lift_goal := tmp;
    b_goal := 0;
    IF origin_station = 1 THEN
        a_goal := D403;
        port_ready := X61;
        port_id := D404;
    ELSE
        a_goal := D406;
        port_ready := X62;
        port_id := D407;
    END_IF;
    IF (ABS(D1000 - a_goal) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND port_ready AND (port_id = current_id) THEN
        couple_issued := FALSE;
        state := 30;
    END_IF;

30:
    lift_goal := tmp;
    b_goal := 0;
    IF origin_station = 1 THEN
        a_goal := D403;
    ELSE
        a_goal := D406;
    END_IF;
    IF NOT couple_issued THEN
        seq_no := seq_no + 1;
        couple_issued := TRUE;
    END_IF;
    D80 := 1;
    D81 := origin_station;
    IF D90 = current_id THEN
        couple_issued := FALSE;
        IF return_status = 2 THEN
            state := 120;
        ELSE
            state := 40;
        END_IF;
    END_IF;

40:
    lift_goal := tmp;
    a_goal := D409;
    b_goal := 18000;
    s3_0_goal := -60000;
    s3_1_goal := -60000;
    IF (ABS(D1000 - a_goal) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - b_goal) <= 20) AND (ABS(D1005) <= 100) AND X63 AND (ABS(D1016 + 60000) <= 20) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) THEN
        couple_issued := FALSE;
        state := 50;
    END_IF;

50:
    lift_goal := tmp;
    a_goal := D409;
    b_goal := 18000;
    s3_0_goal := -60000;
    s3_1_goal := -60000;
    Y71 := TRUE;
    D700 := current_id;
    D701 := D526;
    IF NOT couple_issued THEN
        seq_no := seq_no + 1;
        couple_issued := TRUE;
    END_IF;
    D80 := 2;
    D81 := 3;
    IF (D90 <> current_id) AND (D410 = current_id) THEN
        couple_issued := FALSE;
        state := 60;
    END_IF;

60:
    lift_goal := tmp;
    a_goal := D409;
    b_goal := 0;
    s3_0_goal := D500;
    s3_1_goal := D501;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := current_id;
    D701 := D526;
    D702 := 1000;
    IF s3_0_goal < -95000 THEN s3_0_goal := -95000; END_IF;
    IF s3_0_goal > 95000 THEN s3_0_goal := 95000; END_IF;
    IF s3_1_goal < -95000 THEN s3_1_goal := -95000; END_IF;
    IF s3_1_goal > 95000 THEN s3_1_goal := 95000; END_IF;
    IF ABS(s3_0_goal - s3_1_goal) > 250 THEN
        avg_s3 := (s3_0_goal + s3_1_goal) / 2;
        s3_0_goal := avg_s3;
        s3_1_goal := avg_s3;
    END_IF;
    s3_done := X70 OR ((ABS(D1016 - s3_0_goal) <= 20) AND (ABS(D1020 - s3_1_goal) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100));
    IF s3_done THEN
        state := 70;
    END_IF;

70:
    lift_goal := tmp;
    a_goal := D409;
    b_goal := 0;
    s3_0_goal := -60000;
    s3_1_goal := -60000;
    Y71 := TRUE;
    D700 := current_id;
    D701 := D526;
    IF (ABS(D1016 + 60000) <= 20) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) THEN
        state := 80;
    END_IF;

80:
    lift_goal := tmp;
    a_goal := D409;
    b_goal := 0;
    s3_0_goal := -60000;
    s3_1_goal := -60000;
    Y71 := TRUE;
    D700 := current_id;
    D701 := D526;
    IF (ABS(D1000 - a_goal) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X63 AND (D410 = current_id) THEN
        IF NOT couple_issued THEN
            seq_no := seq_no + 1;
            couple_issued := TRUE;
        END_IF;
        D80 := 1;
        D81 := 3;
        IF D90 = current_id THEN
            couple_issued := FALSE;
            state := 90;
        END_IF;
    END_IF;

90:
    lift_goal := tmp;
    a_goal := D412;
    b_goal := 18000;
    s4_0_goal := 0;
    s4_1_goal := 0;
    IF (ABS(D1000 - a_goal) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - b_goal) <= 20) AND (ABS(D1005) <= 100) AND X64 AND (ABS(D1024) <= 20) AND (ABS(D1028) <= 20) AND (ABS(D1032) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100) AND (ABS(D1033) <= 100) THEN
        couple_issued := FALSE;
        state := 100;
    END_IF;

100:
    lift_goal := tmp;
    a_goal := D412;
    b_goal := 18000;
    Y76 := TRUE;
    D710 := current_id;
    D711 := D626;
    IF NOT couple_issued THEN
        seq_no := seq_no + 1;
        couple_issued := TRUE;
    END_IF;
    D80 := 2;
    D81 := 4;
    IF (D90 <> current_id) AND (D413 = current_id) THEN
        couple_issued := FALSE;
        state := 105;
    END_IF;

105:
    lift_goal := tmp;
    a_goal := D412;
    b_goal := 0;
    s4_0_goal := D600;
    s4_1_goal := D601;
    IF s4_0_goal < -5000 THEN s4_0_goal := -5000; END_IF;
    IF s4_0_goal > 5000 THEN s4_0_goal := 5000; END_IF;
    IF s4_1_goal < -5000 THEN s4_1_goal := -5000; END_IF;
    IF s4_1_goal > 5000 THEN s4_1_goal := 5000; END_IF;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := current_id;
    D711 := D626;
    D712 := 1000;
    sin0 := SIN(REAL(D1024) * 0.000174532925);
    sin1 := SIN(REAL(D1028) * 0.000174532925);
    cw_real := -22500.0 * (sin0 + sin1);
    s4_2_goal := DINT(ROUND(cw_real));
    IF s4_2_goal < -45000 THEN s4_2_goal := -45000; END_IF;
    IF s4_2_goal > 45000 THEN s4_2_goal := 45000; END_IF;
    moment_abs := ABS(0.1962 * (225.0 * (sin0 + sin1) + (REAL(D1032) * 0.01)));
    s4_done := (X75 OR ((ABS(D1024 - s4_0_goal) <= 20) AND (ABS(D1028 - s4_1_goal) <= 20))) AND (moment_abs <= 1.0) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100) AND (ABS(D1033) <= 100);
    IF s4_done THEN
        state := 110;
    END_IF;

110:
    lift_goal := tmp;
    a_goal := D412;
    b_goal := 0;
    s4_0_goal := 0;
    s4_1_goal := 0;
    Y76 := TRUE;
    D710 := current_id;
    D711 := D626;
    IF (ABS(D1024) <= 20) AND (ABS(D1028) <= 20) AND (ABS(D1032) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100) AND (ABS(D1033) <= 100) THEN
        state := 115;
    END_IF;

115:
    lift_goal := tmp;
    a_goal := D412;
    b_goal := 0;
    IF (ABS(D1000 - a_goal) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X64 AND (D413 = current_id) THEN
        IF NOT couple_issued THEN
            seq_no := seq_no + 1;
            couple_issued := TRUE;
        END_IF;
        D80 := 1;
        D81 := 4;
        IF D90 = current_id THEN
            couple_issued := FALSE;
            state := 120;
        END_IF;
    END_IF;

120:
    lift_goal := tmp;
    IF origin_station = 1 THEN
        a_goal := D403;
    ELSE
        a_goal := D406;
    END_IF;
    b_goal := 18000;
    IF (ABS(D1000 - a_goal) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - b_goal) <= 20) AND (ABS(D1005) <= 100) THEN
        IF origin_station = 1 THEN
            port_ready := X61;
        ELSE
            port_ready := X62;
        END_IF;
        IF port_ready THEN
            IF NOT couple_issued THEN
                seq_no := seq_no + 1;
                couple_issued := TRUE;
            END_IF;
            D80 := 2;
            D81 := origin_station;
            IF D90 <> current_id THEN
                IF origin_station = 1 THEN
                    IF D404 = current_id THEN
                        couple_issued := FALSE;
                        state := 130;
                    END_IF;
                ELSE
                    IF D407 = current_id THEN
                        couple_issued := FALSE;
                        state := 130;
                    END_IF;
                END_IF;
            END_IF;
        END_IF;
    END_IF;

130:
    lift_goal := 40000;
    b_goal := 0;
    IF origin_station = 1 THEN
        a_goal := D403;
    ELSE
        a_goal := D406;
    END_IF;
    IF (ABS(D1008 - 40000) <= 20) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF current_slot = 0 THEN
            D300 := current_id;
            D301 := return_status;
        ELSIF current_slot = 1 THEN
            D302 := current_id;
            D303 := return_status;
        END_IF;
        state := 0;
    END_IF;
ELSE
    state := 0;
END_CASE;

IF lift_goal < 0 THEN lift_goal := 0; END_IF;
IF lift_goal > 120000 THEN lift_goal := 120000; END_IF;

IF lift_sp < lift_goal THEN
    lift_sp := lift_sp + 200;
    IF lift_sp > lift_goal THEN lift_sp := lift_goal; END_IF;
ELSIF lift_sp > lift_goal THEN
    lift_sp := lift_sp - 200;
    IF lift_sp < lift_goal THEN lift_sp := lift_goal; END_IF;
END_IF;

IF s3_0_goal < -95000 THEN s3_0_goal := -95000; END_IF;
IF s3_0_goal > 95000 THEN s3_0_goal := 95000; END_IF;
IF s3_1_goal < -95000 THEN s3_1_goal := -95000; END_IF;
IF s3_1_goal > 95000 THEN s3_1_goal := 95000; END_IF;
IF ABS(s3_0_goal - s3_1_goal) > 250 THEN
    avg_s3 := (s3_0_goal + s3_1_goal) / 2;
    s3_0_goal := avg_s3;
    s3_1_goal := avg_s3;
END_IF;

IF s3_0_sp < s3_0_goal THEN
    s3_0_sp := s3_0_sp + 200;
    IF s3_0_sp > s3_0_goal THEN s3_0_sp := s3_0_goal; END_IF;
ELSIF s3_0_sp > s3_0_goal THEN
    s3_0_sp := s3_0_sp - 200;
    IF s3_0_sp < s3_0_goal THEN s3_0_sp := s3_0_goal; END_IF;
END_IF;

IF s3_1_sp < s3_1_goal THEN
    s3_1_sp := s3_1_sp + 200;
    IF s3_1_sp > s3_1_goal THEN s3_1_sp := s3_1_goal; END_IF;
ELSIF s3_1_sp > s3_1_goal THEN
    s3_1_sp := s3_1_sp - 200;
    IF s3_1_sp < s3_1_goal THEN s3_1_sp := s3_1_goal; END_IF;
END_IF;

IF ABS(s3_0_sp - s3_1_sp) > 250 THEN
    avg_s3 := (s3_0_sp + s3_1_sp) / 2;
    s3_0_sp := avg_s3;
    s3_1_sp := avg_s3;
END_IF;

IF s4_0_goal < -5000 THEN s4_0_goal := -5000; END_IF;
IF s4_0_goal > 5000 THEN s4_0_goal := 5000; END_IF;
IF s4_1_goal < -5000 THEN s4_1_goal := -5000; END_IF;
IF s4_1_goal > 5000 THEN s4_1_goal := 5000; END_IF;

IF s4_0_sp < s4_0_goal THEN
    s4_0_sp := s4_0_sp + 100;
    IF s4_0_sp > s4_0_goal THEN s4_0_sp := s4_0_goal; END_IF;
ELSIF s4_0_sp > s4_0_goal THEN
    s4_0_sp := s4_0_sp - 100;
    IF s4_0_sp < s4_0_goal THEN s4_0_sp := s4_0_goal; END_IF;
END_IF;

IF s4_1_sp < s4_1_goal THEN
    s4_1_sp := s4_1_sp + 100;
    IF s4_1_sp > s4_1_goal THEN s4_1_sp := s4_1_goal; END_IF;
ELSIF s4_1_sp > s4_1_goal THEN
    s4_1_sp := s4_1_sp - 100;
    IF s4_1_sp < s4_1_goal THEN s4_1_sp := s4_1_goal; END_IF;
END_IF;

sin0 := SIN(REAL(D1024) * 0.000174532925);
sin1 := SIN(REAL(D1028) * 0.000174532925);
cw_real := -22500.0 * (sin0 + sin1);
s4_2_goal := DINT(ROUND(cw_real));
IF (state = 0) OR (state = 90) OR (state = 100) OR (state = 110) OR (state = 115) THEN
    IF (s4_0_goal = 0) AND (s4_1_goal = 0) AND (ABS(D1024) <= 50) AND (ABS(D1028) <= 50) THEN
        s4_2_goal := 0;
    END_IF;
END_IF;
IF s4_2_goal < -45000 THEN s4_2_goal := -45000; END_IF;
IF s4_2_goal > 45000 THEN s4_2_goal := 45000; END_IF;

IF a_goal < -450000 THEN a_goal := -450000; END_IF;
IF a_goal > 1461300 THEN a_goal := 1461300; END_IF;
IF b_goal < 0 THEN b_goal := 0; END_IF;
IF b_goal > 18000 THEN b_goal := 18000; END_IF;

D2000 := a_goal;
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2004 := b_goal;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

D2008 := lift_sp;
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

D2012 := lift_sp;
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2016 := s3_0_sp;
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;

D2020 := s3_1_sp;
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2024 := s4_0_sp;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2028 := s4_1_sp;
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

D2032 := s4_2_goal;
D2033 := 1000;
D2034 := 0;
Y48 := TRUE;

D82 := seq_no;

final_cond := X51 AND (state = 0) AND (NOT pending0) AND (NOT pending1) AND
              (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
              (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
              (ABS(D1008 - 40000) <= 20) AND (ABS(D1012 - 40000) <= 20) AND
              (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) AND
              (ABS(D1016 + 60000) <= 20) AND (ABS(D1020 + 60000) <= 20) AND
              (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) AND
              (ABS(D1024) <= 20) AND (ABS(D1028) <= 20) AND (ABS(D1032) <= 20) AND
              (ABS(D1025) <= 100) AND (ABS(D1029) <= 100) AND (ABS(D1033) <= 100);

Y2 := final_cond;
Y30 := final_cond;

END_PROGRAM