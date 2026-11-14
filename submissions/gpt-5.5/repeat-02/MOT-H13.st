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
    state : INT;
    target_station : INT;
    current_id : DINT;
    current_index : INT;
    origin_station : INT;
    current_cancel : BOOL;
    r0_done : BOOL;
    r1_done : BOOL;
    r0_seen : DINT;
    r1_seen : DINT;
    seq : DINT;
    seq_issued : BOOL;
    dock_x : DINT;
    dock_ready : BOOL;
    dock_port_id : DINT;
    docked : BOOL;
    lifts_at_dock : BOOL;
    lifts_at_home : BOOL;
    fork_home : BOOL;
    fork_extended : BOOL;
    cell3_home : BOOL;
    cell4_home : BOOL;
    final_ok : BOOL;
    finalTimer : TON;
END_VAR

IF D100 <> r0_seen THEN
    r0_seen := D100;
    r0_done := FALSE;
    D300 := 0;
    D301 := 0;
END_IF;

IF D120 <> r1_seen THEN
    r1_seen := D120;
    r1_done := FALSE;
    D302 := 0;
    D303 := 0;
END_IF;

IF (state <> 0) AND (state <> 200) THEN
    IF current_index = 0 THEN
        current_cancel := current_cancel OR X31;
    ELSE
        current_cancel := current_cancel OR X35;
    END_IF;
END_IF;

IF target_station = 1 THEN
    dock_x := D403;
    dock_ready := X61;
    dock_port_id := D404;
ELSIF target_station = 2 THEN
    dock_x := D406;
    dock_ready := X62;
    dock_port_id := D407;
ELSIF target_station = 3 THEN
    dock_x := D409;
    dock_ready := X63;
    dock_port_id := D410;
ELSIF target_station = 4 THEN
    dock_x := D412;
    dock_ready := X64;
    dock_port_id := D413;
ELSE
    dock_x := 0;
    dock_ready := TRUE;
    dock_port_id := 0;
END_IF;

docked := (ABS(D1000 - dock_x) <= 20) AND (ABS(D1001) <= 100);
lifts_at_dock := (ABS(D1008 - D92) <= 20) AND (ABS(D1012 - D92) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100);
lifts_at_home := (ABS(D1008 - 40000) <= 20) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100);
fork_home := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
fork_extended := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
cell3_home := (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024) <= 20) AND (ABS(D1025) <= 100);
cell4_home := (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);

D2001 := 1000;
D2002 := 0;
Y40 := TRUE;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;
D2008 := LIMIT(0, D92, 120000);
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;
D2012 := LIMIT(0, D92, 120000);
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2016 := 0;
D2017 := 1000;
D2018 := 0;
Y44 := FALSE;
D2020 := 0;
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;
D2024 := 0;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;
D2028 := 0;
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;
D2032 := 0;
D2033 := 1000;
D2034 := 0;
Y48 := TRUE;

Y70 := FALSE;
Y75 := FALSE;
Y76 := FALSE;
D700 := 1000;
D701 := D526;
D702 := 1000;
D710 := 700;
D711 := D626;
D712 := 1000;
D80 := 0;
D81 := 0;
D82 := seq;
Y30 := FALSE;
Y2 := FALSE;

IF (state >= 50) AND (state <= 95) AND NOT current_cancel THEN
    Y71 := TRUE;
ELSE
    Y71 := FALSE;
END_IF;

IF ABS(D1004) <= 4000 THEN
    D2000 := LIMIT(-450000, dock_x, 450000);
ELSE
    D2000 := D1000;
END_IF;
D2004 := 0;

CASE state OF
0:
    target_station := 0;
    D2000 := 0;
    D2004 := 0;
    IF (D100 <> 0) AND NOT r0_done THEN
        current_id := D100;
        current_index := 0;
        IF (D101 = 2) THEN
            origin_station := 2;
        ELSE
            origin_station := 1;
        END_IF;
        current_cancel := X31;
        target_station := origin_station;
        seq_issued := FALSE;
        state := 10;
    ELSIF (D120 <> 0) AND NOT r1_done THEN
        current_id := D120;
        current_index := 1;
        IF (D121 = 2) THEN
            origin_station := 2;
        ELSE
            origin_station := 1;
        END_IF;
        current_cancel := X35;
        target_station := origin_station;
        seq_issued := FALSE;
        state := 10;
    ELSIF X51 THEN
        state := 200;
    END_IF;

10:
    target_station := origin_station;
    D2004 := 0;
    IF ABS(D1004) <= 4000 THEN
        D2000 := LIMIT(-450000, dock_x, 450000);
    ELSE
        D2000 := D1000;
    END_IF;
    IF docked AND fork_home AND lifts_at_dock AND dock_ready THEN
        seq_issued := FALSE;
        state := 20;
    END_IF;

20:
    target_station := origin_station;
    D80 := 1;
    D81 := target_station;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 18000;
    IF fork_extended AND docked AND lifts_at_dock AND dock_ready AND NOT seq_issued THEN
        seq := seq + 1;
        D82 := seq;
        seq_issued := TRUE;
    END_IF;
    IF seq_issued AND (D90 = current_id) THEN
        state := 25;
    END_IF;

25:
    target_station := origin_station;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 0;
    IF fork_home THEN
        IF current_cancel THEN
            target_station := origin_station;
            state := 110;
        ELSE
            target_station := 3;
            state := 30;
        END_IF;
    END_IF;

30:
    target_station := 3;
    D2004 := 0;
    IF ABS(D1004) <= 4000 THEN
        D2000 := LIMIT(-450000, dock_x, 450000);
    ELSE
        D2000 := D1000;
    END_IF;
    IF docked AND fork_home AND dock_ready AND cell3_home THEN
        seq_issued := FALSE;
        state := 40;
    END_IF;

40:
    target_station := 3;
    D80 := 2;
    D81 := 3;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 18000;
    IF fork_extended AND docked AND dock_ready AND cell3_home AND NOT seq_issued THEN
        seq := seq + 1;
        D82 := seq;
        seq_issued := TRUE;
    END_IF;
    IF seq_issued AND ((D90 <> current_id) OR (D410 = current_id)) THEN
        state := 45;
    END_IF;

45:
    target_station := 3;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 0;
    IF fork_home THEN
        IF current_cancel THEN
            state := 55;
        ELSE
            state := 50;
        END_IF;
    END_IF;

50:
    target_station := 3;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 0;
    Y71 := TRUE;
    Y70 := TRUE;
    D700 := 1000;
    D701 := D526;
    D702 := 1000;
    D2020 := LIMIT(-3600000, D501, 3600000);
    D2024 := LIMIT(-3600000, D502, 3600000);
    IF current_cancel OR X70 THEN
        state := 55;
    END_IF;

55:
    target_station := 3;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 0;
    IF NOT current_cancel THEN
        Y71 := TRUE;
    END_IF;
    D2020 := 0;
    D2024 := 0;
    IF cell3_home THEN
        seq_issued := FALSE;
        state := 60;
    END_IF;

60:
    target_station := 3;
    D2004 := 0;
    IF ABS(D1004) <= 4000 THEN
        D2000 := LIMIT(-450000, dock_x, 450000);
    ELSE
        D2000 := D1000;
    END_IF;
    IF NOT current_cancel THEN
        Y71 := TRUE;
    END_IF;
    IF docked AND fork_home AND dock_ready AND cell3_home THEN
        seq_issued := FALSE;
        state := 61;
    END_IF;

61:
    target_station := 3;
    D80 := 1;
    D81 := 3;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 18000;
    IF NOT current_cancel THEN
        Y71 := TRUE;
    END_IF;
    IF fork_extended AND docked AND dock_ready AND cell3_home AND NOT seq_issued THEN
        seq := seq + 1;
        D82 := seq;
        seq_issued := TRUE;
    END_IF;
    IF seq_issued AND (D90 = current_id) THEN
        state := 65;
    END_IF;

65:
    target_station := 3;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 0;
    IF NOT current_cancel THEN
        Y71 := TRUE;
    END_IF;
    IF fork_home THEN
        IF current_cancel THEN
            target_station := origin_station;
            state := 110;
        ELSE
            target_station := 4;
            state := 70;
        END_IF;
    END_IF;

70:
    target_station := 4;
    D2004 := 0;
    Y71 := TRUE;
    IF ABS(D1004) <= 4000 THEN
        D2000 := LIMIT(-450000, dock_x, 450000);
    ELSE
        D2000 := D1000;
    END_IF;
    IF docked AND fork_home AND dock_ready AND cell4_home THEN
        seq_issued := FALSE;
        state := 80;
    END_IF;

80:
    target_station := 4;
    D80 := 2;
    D81 := 4;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 18000;
    Y71 := TRUE;
    IF fork_extended AND docked AND dock_ready AND cell4_home AND NOT seq_issued THEN
        seq := seq + 1;
        D82 := seq;
        seq_issued := TRUE;
    END_IF;
    IF seq_issued AND ((D90 <> current_id) OR (D413 = current_id)) THEN
        state := 85;
    END_IF;

85:
    target_station := 4;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 0;
    Y71 := TRUE;
    IF fork_home THEN
        state := 90;
    END_IF;

90:
    target_station := 4;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 0;
    Y71 := TRUE;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := 700;
    D711 := D626;
    D712 := 1000;
    D2028 := LIMIT(-360000, D600, 360000);
    D2032 := LIMIT(-360000, D601, 360000);
    IF current_cancel OR X75 THEN
        state := 95;
    END_IF;

95:
    target_station := 4;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 0;
    D2028 := 0;
    D2032 := 0;
    IF cell4_home THEN
        seq_issued := FALSE;
        state := 100;
    END_IF;

100:
    target_station := 4;
    D2004 := 0;
    IF ABS(D1004) <= 4000 THEN
        D2000 := LIMIT(-450000, dock_x, 450000);
    ELSE
        D2000 := D1000;
    END_IF;
    IF docked AND fork_home AND dock_ready AND cell4_home THEN
        seq_issued := FALSE;
        state := 101;
    END_IF;

101:
    target_station := 4;
    D80 := 1;
    D81 := 4;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 18000;
    IF fork_extended AND docked AND dock_ready AND cell4_home AND NOT seq_issued THEN
        seq := seq + 1;
        D82 := seq;
        seq_issued := TRUE;
    END_IF;
    IF seq_issued AND (D90 = current_id) THEN
        state := 105;
    END_IF;

105:
    target_station := 4;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 0;
    IF fork_home THEN
        target_station := origin_station;
        state := 110;
    END_IF;

110:
    target_station := origin_station;
    D2004 := 0;
    IF ABS(D1004) <= 4000 THEN
        D2000 := LIMIT(-450000, dock_x, 450000);
    ELSE
        D2000 := D1000;
    END_IF;
    IF docked AND fork_home AND lifts_at_dock AND dock_ready THEN
        seq_issued := FALSE;
        state := 120;
    END_IF;

120:
    target_station := origin_station;
    D80 := 2;
    D81 := target_station;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 18000;
    IF fork_extended AND docked AND lifts_at_dock AND dock_ready AND NOT seq_issued THEN
        seq := seq + 1;
        D82 := seq;
        seq_issued := TRUE;
    END_IF;
    IF seq_issued AND (D90 <> current_id) THEN
        state := 125;
    END_IF;

125:
    target_station := origin_station;
    D2000 := LIMIT(-450000, dock_x, 450000);
    D2004 := 0;
    IF fork_home THEN
        state := 130;
    END_IF;

130:
    target_station := 0;
    D2000 := 0;
    D2004 := 0;
    IF current_index = 0 THEN
        D300 := current_id;
        IF current_cancel THEN
            D301 := 2;
        ELSE
            D301 := 1;
        END_IF;
        r0_done := TRUE;
    ELSE
        D302 := current_id;
        IF current_cancel THEN
            D303 := 2;
        ELSE
            D303 := 1;
        END_IF;
        r1_done := TRUE;
    END_IF;
    current_id := 0;
    current_cancel := FALSE;
    state := 0;

200:
    target_station := 0;
    D2000 := 0;
    D2004 := 0;
    D2008 := 40000;
    D2012 := 40000;
    D2020 := 0;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    Y71 := FALSE;
    Y70 := FALSE;
    Y75 := FALSE;
    Y76 := FALSE;
    Y30 := TRUE;
    IF NOT X51 THEN
        state := 0;
    END_IF;

ELSE
    state := 0;
END_CASE;

final_ok := X51 AND (state = 200) AND (D90 = 0) AND (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND fork_home AND lifts_at_home AND cell3_home AND cell4_home AND (ABS(D1017) <= 100);
finalTimer(IN := final_ok, PT := T#100ms);
Y2 := finalTimer.Q;

IF Y2 THEN
    Y30 := TRUE;
    Y71 := FALSE;
    Y70 := FALSE;
    Y75 := FALSE;
    Y76 := FALSE;
    D2000 := 0;
    D2004 := 0;
    D2008 := 40000;
    D2012 := 40000;
    D2020 := 0;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
END_IF;

END_PROGRAM