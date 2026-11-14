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
    state : INT;
    seq : DINT;
    coupleHold : INT;
    curIndex : INT;
    curId : DINT;
    curOrigin : INT;
    curCancelled : BOOL;
    done0 : BOOL;
    done1 : BOOL;
    ack0Id : DINT;
    ack0Status : DINT;
    ack1Id : DINT;
    ack1Status : DINT;
    finalLatched : BOOL;
    aT : DINT;
    bT : DINT;
    cT : DINT;
    dT : DINT;
    s30T : DINT;
    s31T : DINT;
    s40T : DINT;
    s41T : DINT;
    s42T : DINT;
    originX : DINT;
    originReady : BOOL;
    originLiftAtDock : BOOL;
    originLiftAtHome : BOOL;
    bHome : BOOL;
    bConn : BOOL;
    s3Home : BOOL;
    s4Home : BOOL;
    allHome : BOOL;
    m3g0 : DINT;
    m3g1 : DINT;
    m4g0 : DINT;
    m4g1 : DINT;
    m4g2 : DINT;
    s4NeedHigh : BOOL;
    newReqWaiting : BOOL;
END_VAR

bHome := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
bConn := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
s3Home := (ABS(D1016 + 85000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 + 85000) <= 20) AND (ABS(D1021) <= 100);
s4Home := (ABS(D1024 + 65000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028 - 65000) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);
allHome := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND bHome AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND s3Home AND s4Home;

IF curIndex = 0 THEN
    IF X31 THEN
        curCancelled := TRUE;
    END_IF;
ELSIF curIndex = 1 THEN
    IF X35 THEN
        curCancelled := TRUE;
    END_IF;
END_IF;

IF curOrigin = 2 THEN
    originX := D406;
    originReady := X62;
    originLiftAtDock := (ABS(D1012 - LIMIT(0, D92, 120000)) <= 20) AND (ABS(D1013) <= 100);
    originLiftAtHome := (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100);
ELSE
    originX := D403;
    originReady := X61;
    originLiftAtDock := (ABS(D1008 - LIMIT(0, D92, 120000)) <= 20) AND (ABS(D1009) <= 100);
    originLiftAtHome := (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100);
END_IF;

aT := 0;
bT := 0;
cT := 15000;
dT := 15000;
s30T := -85000;
s31T := -85000;
s40T := -65000;
s41T := 65000;
s42T := 0;
D80 := 0;
D81 := 0;
D82 := seq;
Y70 := FALSE;
Y71 := FALSE;
D700 := 0;
D701 := 0;
D702 := 800;
Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := 0;
D712 := 800;
Y30 := FALSE;

CASE state OF
0:
    coupleHold := 0;
    curIndex := -1;
    curId := 0;
    IF (D100 <> 0) AND NOT done0 THEN
        curIndex := 0;
        curId := D100;
        IF D101 = 2 THEN
            curOrigin := 2;
        ELSE
            curOrigin := 1;
        END_IF;
        curCancelled := X31;
        state := 10;
    ELSIF (D120 <> 0) AND NOT done1 THEN
        curIndex := 1;
        curId := D120;
        IF D121 = 2 THEN
            curOrigin := 2;
        ELSE
            curOrigin := 1;
        END_IF;
        curCancelled := X35;
        state := 10;
    ELSE
        state := 900;
    END_IF;

10:
    aT := originX;
    bT := 0;
    IF curOrigin = 2 THEN
        dT := LIMIT(0, D92, 120000);
    ELSE
        cT := LIMIT(0, D92, 120000);
    END_IF;
    IF (ABS(D1000 - aT) <= 20) AND (ABS(D1001) <= 100) AND bHome AND originLiftAtDock AND originReady THEN
        state := 11;
    END_IF;

11:
    aT := originX;
    bT := 18000;
    Y30 := TRUE;
    IF curOrigin = 2 THEN
        dT := LIMIT(0, D92, 120000);
    ELSE
        cT := LIMIT(0, D92, 120000);
    END_IF;
    IF bConn AND originLiftAtDock AND originReady THEN
        seq := seq + 1;
        coupleHold := 0;
        state := 12;
    END_IF;

12:
    aT := originX;
    IF coupleHold < 2 THEN
        bT := 18000;
        coupleHold := coupleHold + 1;
    ELSE
        bT := 0;
    END_IF;
    IF curOrigin = 2 THEN
        dT := LIMIT(0, D92, 120000);
    ELSE
        cT := LIMIT(0, D92, 120000);
    END_IF;
    D80 := 1;
    D81 := curOrigin;
    D82 := seq;
    Y30 := TRUE;
    IF bHome AND (D90 = curId) THEN
        IF curCancelled THEN
            state := 80;
        ELSE
            state := 20;
        END_IF;
    END_IF;

20:
    aT := D409;
    bT := 0;
    IF (ABS(D1000 - aT) <= 20) AND (ABS(D1001) <= 100) AND bHome AND X63 AND s3Home THEN
        state := 21;
    END_IF;

21:
    aT := D409;
    bT := 18000;
    Y30 := TRUE;
    IF bConn AND X63 AND s3Home THEN
        seq := seq + 1;
        coupleHold := 0;
        state := 22;
    END_IF;

22:
    aT := D409;
    IF coupleHold < 2 THEN
        bT := 18000;
        coupleHold := coupleHold + 1;
    ELSE
        bT := 0;
    END_IF;
    D80 := 2;
    D81 := 3;
    D82 := seq;
    Y30 := TRUE;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D702 := 800;
    IF bHome AND (D90 <> curId) THEN
        IF curCancelled THEN
            state := 40;
        ELSE
            state := 30;
        END_IF;
    END_IF;

30:
    bT := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D702 := 800;
    m3g0 := LIMIT(-95000, D500, 95000);
    m3g1 := LIMIT(-95000, D501, 95000);
    IF ABS(m3g1 - m3g0) < 23000 THEN
        IF m3g0 <= 72000 THEN
            m3g1 := m3g0 + 23000;
        ELSE
            m3g1 := m3g0 - 23000;
        END_IF;
    END_IF;
    s30T := LIMIT(-95000, m3g0, 95000);
    s31T := LIMIT(-95000, m3g1, 95000);
    IF X70 OR curCancelled THEN
        state := 40;
    END_IF;

40:
    aT := D409;
    bT := 0;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D702 := 800;
    IF (ABS(D1000 - aT) <= 20) AND (ABS(D1001) <= 100) AND bHome AND X63 AND s3Home THEN
        state := 41;
    END_IF;

41:
    aT := D409;
    bT := 18000;
    Y30 := TRUE;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D702 := 800;
    IF bConn AND X63 AND s3Home THEN
        seq := seq + 1;
        coupleHold := 0;
        state := 42;
    END_IF;

42:
    aT := D409;
    IF coupleHold < 2 THEN
        bT := 18000;
        coupleHold := coupleHold + 1;
    ELSE
        bT := 0;
    END_IF;
    D80 := 1;
    D81 := 3;
    D82 := seq;
    Y30 := TRUE;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D702 := 800;
    IF bHome AND (D90 = curId) THEN
        IF curCancelled THEN
            state := 80;
        ELSE
            state := 50;
        END_IF;
    END_IF;

50:
    aT := D412;
    bT := 0;
    IF (ABS(D1000 - aT) <= 20) AND (ABS(D1001) <= 100) AND bHome AND X64 AND s4Home THEN
        state := 51;
    END_IF;

51:
    aT := D412;
    bT := 18000;
    Y30 := TRUE;
    IF bConn AND X64 AND s4Home THEN
        seq := seq + 1;
        coupleHold := 0;
        state := 52;
    END_IF;

52:
    aT := D412;
    IF coupleHold < 2 THEN
        bT := 18000;
        coupleHold := coupleHold + 1;
    ELSE
        bT := 0;
    END_IF;
    D80 := 2;
    D81 := 4;
    D82 := seq;
    Y30 := TRUE;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D712 := 800;
    IF bHome AND (D90 <> curId) THEN
        IF curCancelled THEN
            state := 70;
        ELSE
            state := 60;
        END_IF;
    END_IF;

60:
    bT := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D712 := 800;
    m4g0 := LIMIT(-90000, D600, 90000);
    m4g1 := LIMIT(-90000, D601, 90000);
    m4g2 := LIMIT(0, D602, 35000);
    IF ABS(D1024 - D1028) < 23000 THEN
        IF D1032 < 22000 THEN
            s40T := D1024;
            s41T := D1028;
            s42T := 22000;
        ELSE
            s40T := m4g0;
            s41T := m4g1;
            IF ABS(m4g0 - m4g1) < 23000 THEN
                s42T := MAX(m4g2, 22000);
            ELSE
                s42T := m4g2;
            END_IF;
        END_IF;
    ELSE
        s40T := m4g0;
        s41T := m4g1;
        IF ABS(m4g0 - m4g1) < 23000 THEN
            s42T := MAX(m4g2, 22000);
        ELSE
            s42T := m4g2;
        END_IF;
    END_IF;
    IF X75 OR curCancelled THEN
        state := 70;
    END_IF;

70:
    aT := D412;
    bT := 0;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D712 := 800;
    IF (ABS(D1000 - aT) <= 20) AND (ABS(D1001) <= 100) AND bHome AND X64 AND s4Home THEN
        state := 71;
    END_IF;

71:
    aT := D412;
    bT := 18000;
    Y30 := TRUE;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D712 := 800;
    IF bConn AND X64 AND s4Home THEN
        seq := seq + 1;
        coupleHold := 0;
        state := 72;
    END_IF;

72:
    aT := D412;
    IF coupleHold < 2 THEN
        bT := 18000;
        coupleHold := coupleHold + 1;
    ELSE
        bT := 0;
    END_IF;
    D80 := 1;
    D81 := 4;
    D82 := seq;
    Y30 := TRUE;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D712 := 800;
    IF bHome AND (D90 = curId) THEN
        state := 80;
    END_IF;

80:
    aT := originX;
    bT := 0;
    IF curOrigin = 2 THEN
        dT := LIMIT(0, D92, 120000);
    ELSE
        cT := LIMIT(0, D92, 120000);
    END_IF;
    IF (ABS(D1000 - aT) <= 20) AND (ABS(D1001) <= 100) AND bHome AND originLiftAtDock AND originReady THEN
        state := 81;
    END_IF;

81:
    aT := originX;
    bT := 18000;
    Y30 := TRUE;
    IF curOrigin = 2 THEN
        dT := LIMIT(0, D92, 120000);
    ELSE
        cT := LIMIT(0, D92, 120000);
    END_IF;
    IF bConn AND originLiftAtDock AND originReady THEN
        seq := seq + 1;
        coupleHold := 0;
        state := 82;
    END_IF;

82:
    aT := originX;
    IF coupleHold < 2 THEN
        bT := 18000;
        coupleHold := coupleHold + 1;
    ELSE
        bT := 0;
    END_IF;
    IF curOrigin = 2 THEN
        dT := LIMIT(0, D92, 120000);
    ELSE
        cT := LIMIT(0, D92, 120000);
    END_IF;
    D80 := 2;
    D81 := curOrigin;
    D82 := seq;
    Y30 := TRUE;
    IF bHome AND (D90 <> curId) THEN
        state := 90;
    END_IF;

90:
    aT := originX;
    bT := 0;
    IF curOrigin = 2 THEN
        dT := 15000;
    ELSE
        cT := 15000;
    END_IF;
    IF bHome AND originLiftAtHome THEN
        IF curIndex = 0 THEN
            ack0Id := curId;
            IF curCancelled THEN
                ack0Status := 2;
            ELSE
                ack0Status := 1;
            END_IF;
            done0 := TRUE;
        ELSIF curIndex = 1 THEN
            ack1Id := curId;
            IF curCancelled THEN
                ack1Status := 2;
            ELSE
                ack1Status := 1;
            END_IF;
            done1 := TRUE;
        END_IF;
        curIndex := -1;
        curId := 0;
        curCancelled := FALSE;
        state := 0;
    END_IF;

900:
    newReqWaiting := ((D100 <> 0) AND NOT done0) OR ((D120 <> 0) AND NOT done1);
    IF newReqWaiting AND NOT finalLatched THEN
        state := 0;
    ELSE
        aT := 0;
        bT := 0;
        cT := 15000;
        dT := 15000;
        IF X51 AND allHome THEN
            finalLatched := TRUE;
        END_IF;
    END_IF;

ELSE
    state := 0;
END_CASE;

IF NOT ((state = 60) OR (state = 52) OR (state = 70) OR (state = 71) OR (state = 72)) THEN
    IF NOT s4Home THEN
        IF (ABS(D1024 - D1028) < 23000) AND (D1032 < 22000) THEN
            s40T := D1024;
            s41T := D1028;
            s42T := 22000;
        ELSE
            s40T := -65000;
            s41T := 65000;
            IF ABS(D1024 - D1028) > 23000 THEN
                s42T := 0;
            ELSE
                s42T := MAX(D1032, 22000);
            END_IF;
        END_IF;
    END_IF;
END_IF;

IF (state = 10) OR (state = 11) OR (state = 12) OR (state = 80) OR (state = 81) OR (state = 82) OR (state = 90) THEN
    IF curOrigin = 2 THEN
        cT := 15000;
    ELSE
        dT := 15000;
    END_IF;
END_IF;

D2000 := LIMIT(-450000, aT, 450000);
D2001 := 900;
D2002 := 0;
Y40 := TRUE;
D2004 := LIMIT(0, bT, 18000);
D2005 := 850;
D2006 := 0;
Y41 := TRUE;
D2008 := LIMIT(0, cT, 120000);
D2009 := 850;
D2010 := 0;
Y42 := TRUE;
D2012 := LIMIT(0, dT, 120000);
D2013 := 850;
D2014 := 0;
Y43 := TRUE;
D2016 := LIMIT(-95000, s30T, 95000);
D2017 := 850;
D2018 := 0;
Y44 := TRUE;
D2020 := LIMIT(-95000, s31T, 95000);
D2021 := 850;
D2022 := 0;
Y45 := TRUE;
D2024 := LIMIT(-90000, s40T, 90000);
D2025 := 900;
D2026 := 0;
Y46 := TRUE;
D2028 := LIMIT(-90000, s41T, 90000);
D2029 := 900;
D2030 := 0;
Y47 := TRUE;
D2032 := LIMIT(0, s42T, 35000);
D2033 := 900;
D2034 := 0;
Y48 := TRUE;

D300 := ack0Id;
D301 := ack0Status;
D302 := ack1Id;
D303 := ack1Status;
Y2 := finalLatched;

END_PROGRAM