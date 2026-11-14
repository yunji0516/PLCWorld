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
    state : DINT;
    seqNo : DINT;
    connActive : BOOL;
    connWait : DINT;
    curSlot : DINT;
    curId : DINT;
    curSource : DINT;
    curStatus : DINT;
    curCancel : BOOL;
    lastR0 : DINT;
    lastR1 : DINT;
    r0Done : BOOL;
    r1Done : BOOL;
    r0Status : DINT;
    r1Status : DINT;
    aCmd : DINT;
    bCmd : DINT;
    cCmd : DINT;
    dCmd : DINT;
    s30Cmd : DINT;
    s31Cmd : DINT;
    s32Cmd : DINT;
    s40Cmd : DINT;
    s41Cmd : DINT;
    sourceX : DINT;
    sourceReady : BOOL;
    liftDock : DINT;
    proc3_0 : DINT;
    proc3_1 : DINT;
    proc3_2 : DINT;
    proc4_0 : DINT;
    proc4_1 : DINT;
    angleRad : REAL;
    cwReal : REAL;
    homeReady : BOOL;
    aReady : BOOL;
    bReady0 : BOOL;
    bReady180 : BOOL;
    liftReadyDock : BOOL;
    liftReadyHome : BOOL;
    s3HomeReady : BOOL;
    s4HomeReady : BOOL;
    cell3Ready : BOOL;
    cell4Ready : BOOL;
    finalReady : BOOL;
END_VAR

IF D100 <> lastR0 THEN
    lastR0 := D100;
    r0Done := FALSE;
    r0Status := 0;
END_IF;

IF D120 <> lastR1 THEN
    lastR1 := D120;
    r1Done := FALSE;
    r1Status := 0;
END_IF;

IF D100 = 0 THEN
    r0Done := TRUE;
    r0Status := 0;
END_IF;

IF D120 = 0 THEN
    r1Done := TRUE;
    r1Status := 0;
END_IF;

aCmd := 0;
bCmd := 0;
cCmd := 40000;
dCmd := 40000;
s30Cmd := 100000;
s31Cmd := 0;
s32Cmd := 0;
s40Cmd := 0;
s41Cmd := 0;

D2001 := 900;
D2002 := 0;
D2005 := 900;
D2006 := 0;
D2009 := 900;
D2010 := 0;
D2013 := 900;
D2014 := 0;
D2017 := 850;
D2018 := 0;
D2021 := 850;
D2022 := 0;
D2025 := 300;
D2026 := 0;
D2029 := 850;
D2030 := 0;
D2033 := 850;
D2034 := 0;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := FALSE;
Y47 := TRUE;
Y48 := TRUE;

Y70 := FALSE;
Y71 := FALSE;
D700 := 0;
D701 := 0;
D702 := 0;
Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := 0;
D712 := 0;

D80 := 0;
D81 := 0;

liftDock := D92;
IF liftDock < 0 THEN
    liftDock := 0;
END_IF;
IF liftDock > 120000 THEN
    liftDock := 120000;
END_IF;

IF D500 >= 50000 AND D500 <= 150000 THEN
    proc3_0 := D500;
ELSE
    proc3_0 := 100000;
END_IF;

IF D501 >= -100000 AND D501 <= 100000 THEN
    proc3_1 := D501;
ELSE
    proc3_1 := 0;
END_IF;

IF D502 >= -3000 AND D502 <= 3000 THEN
    proc3_2 := D502;
ELSE
    IF (D502 / 10) >= -3000 AND (D502 / 10) <= 3000 THEN
        proc3_2 := D502 / 10;
    ELSE
        proc3_2 := 0;
    END_IF;
END_IF;

IF D600 >= -5000 AND D600 <= 5000 THEN
    proc4_0 := D600;
ELSE
    IF (D600 / 10) >= -5000 AND (D600 / 10) <= 5000 THEN
        proc4_0 := D600 / 10;
    ELSE
        IF D600 > 0 THEN
            proc4_0 := 5000;
        ELSE
            proc4_0 := -5000;
        END_IF;
    END_IF;
END_IF;

angleRad := REAL(proc4_0) * 0.000174532925;
cwReal := -45000.0 * SIN(angleRad);
proc4_1 := DINT(REAL_TO_INT(cwReal));
IF proc4_1 < -45000 THEN
    proc4_1 := -45000;
END_IF;
IF proc4_1 > 45000 THEN
    proc4_1 := 45000;
END_IF;

IF curSource = 2 THEN
    sourceX := D406;
    sourceReady := X62;
ELSE
    sourceX := D403;
    sourceReady := X61;
END_IF;

IF sourceX < -450000 THEN
    sourceX := -450000;
END_IF;
IF sourceX > 510000 THEN
    sourceX := 510000;
END_IF;

CASE state OF
0:
    connActive := FALSE;
    connWait := 0;
    IF (D100 <> 0) AND NOT r0Done THEN
        curSlot := 0;
        curId := D100;
        IF D101 <> 0 THEN
            curSource := 2;
        ELSE
            curSource := 1;
        END_IF;
        IF X31 THEN
            curStatus := 2;
            curCancel := TRUE;
        ELSE
            curStatus := 1;
            curCancel := FALSE;
        END_IF;
        state := 10;
    ELSIF (D120 <> 0) AND NOT r1Done THEN
        curSlot := 1;
        curId := D120;
        IF D121 <> 0 THEN
            curSource := 2;
        ELSE
            curSource := 1;
        END_IF;
        IF X35 THEN
            curStatus := 2;
            curCancel := TRUE;
        ELSE
            curStatus := 1;
            curCancel := FALSE;
        END_IF;
        state := 10;
    END_IF;

10:
    cCmd := liftDock;
    dCmd := liftDock;
    bCmd := 0;
    liftReadyDock := (ABS(D1008 - liftDock) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - liftDock) <= 20) AND (ABS(D1013) <= 100) AND (ABS(D1008 - D1012) <= 8000);
    IF liftReadyDock THEN
        state := 20;
    END_IF;

20:
    aCmd := sourceX;
    bCmd := 0;
    cCmd := liftDock;
    dCmd := liftDock;
    aReady := (ABS(D1000 - sourceX) <= 20) AND (ABS(D1001) <= 100);
    bReady0 := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    IF aReady AND bReady0 AND sourceReady THEN
        state := 30;
        connActive := FALSE;
        connWait := 0;
    END_IF;

30:
    aCmd := sourceX;
    bCmd := 0;
    cCmd := liftDock;
    dCmd := liftDock;
    IF NOT connActive THEN
        seqNo := seqNo + 1;
        connActive := TRUE;
        connWait := 0;
    END_IF;
    D80 := 1;
    D81 := curSource;
    connWait := connWait + 1;
    IF (connWait >= 3) AND (D90 = curId) THEN
        D80 := 0;
        connActive := FALSE;
        connWait := 0;
        IF curCancel THEN
            state := 140;
        ELSE
            state := 40;
        END_IF;
    END_IF;

40:
    aCmd := D409;
    bCmd := 0;
    cCmd := liftDock;
    dCmd := liftDock;
    IF aCmd < -450000 THEN
        aCmd := -450000;
    END_IF;
    IF aCmd > 510000 THEN
        aCmd := 510000;
    END_IF;
    s30Cmd := 100000;
    s31Cmd := 0;
    s32Cmd := 0;
    aReady := (ABS(D1000 - aCmd) <= 20) AND (ABS(D1001) <= 100);
    bReady0 := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    s3HomeReady := (ABS(D1016 - 100000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024) <= 3) AND (ABS(D1025) <= 15);
    IF aReady AND bReady0 AND X63 AND s3HomeReady THEN
        state := 50;
        connActive := FALSE;
        connWait := 0;
    END_IF;

50:
    aCmd := D409;
    bCmd := 18000;
    cCmd := liftDock;
    dCmd := liftDock;
    s30Cmd := 100000;
    s31Cmd := 0;
    s32Cmd := 0;
    IF NOT connActive THEN
        seqNo := seqNo + 1;
        connActive := TRUE;
        connWait := 0;
    END_IF;
    D80 := 2;
    D81 := 3;
    connWait := connWait + 1;
    IF (connWait >= 3) AND (D90 <> curId) THEN
        D80 := 0;
        connActive := FALSE;
        connWait := 0;
        state := 60;
    END_IF;

60:
    aCmd := D409;
    bCmd := 0;
    cCmd := liftDock;
    dCmd := liftDock;
    s30Cmd := proc3_0;
    s31Cmd := proc3_1;
    s32Cmd := proc3_2;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D702 := 0;
    IF X70 THEN
        state := 70;
    END_IF;

70:
    aCmd := D409;
    bCmd := 0;
    cCmd := liftDock;
    dCmd := liftDock;
    s30Cmd := 100000;
    s31Cmd := 0;
    s32Cmd := 0;
    Y71 := TRUE;
    s3HomeReady := (ABS(D1016 - 100000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024) <= 3) AND (ABS(D1025) <= 15);
    aReady := (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100);
    IF s3HomeReady AND aReady AND X63 THEN
        state := 80;
        connActive := FALSE;
        connWait := 0;
    END_IF;

80:
    aCmd := D409;
    bCmd := 0;
    cCmd := liftDock;
    dCmd := liftDock;
    s30Cmd := 100000;
    s31Cmd := 0;
    s32Cmd := 0;
    IF NOT connActive THEN
        seqNo := seqNo + 1;
        connActive := TRUE;
        connWait := 0;
    END_IF;
    D80 := 1;
    D81 := 3;
    connWait := connWait + 1;
    IF (connWait >= 3) AND (D90 = curId) THEN
        D80 := 0;
        connActive := FALSE;
        connWait := 0;
        state := 90;
    END_IF;

90:
    aCmd := D412;
    bCmd := 0;
    cCmd := liftDock;
    dCmd := liftDock;
    s40Cmd := 0;
    s41Cmd := 0;
    IF aCmd < -450000 THEN
        aCmd := -450000;
    END_IF;
    IF aCmd > 510000 THEN
        aCmd := 510000;
    END_IF;
    aReady := (ABS(D1000 - aCmd) <= 20) AND (ABS(D1001) <= 100);
    bReady0 := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    s4HomeReady := (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);
    IF aReady AND bReady0 AND X64 AND s4HomeReady THEN
        state := 100;
        connActive := FALSE;
        connWait := 0;
    END_IF;

100:
    aCmd := D412;
    bCmd := 18000;
    cCmd := liftDock;
    dCmd := liftDock;
    s40Cmd := 0;
    s41Cmd := 0;
    IF NOT connActive THEN
        seqNo := seqNo + 1;
        connActive := TRUE;
        connWait := 0;
    END_IF;
    D80 := 2;
    D81 := 4;
    connWait := connWait + 1;
    IF (connWait >= 3) AND (D90 <> curId) THEN
        D80 := 0;
        connActive := FALSE;
        connWait := 0;
        state := 110;
    END_IF;

110:
    aCmd := D412;
    bCmd := 0;
    cCmd := liftDock;
    dCmd := liftDock;
    s40Cmd := proc4_0;
    s41Cmd := proc4_1;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D712 := 0;
    IF X75 THEN
        state := 120;
    END_IF;

120:
    aCmd := D412;
    bCmd := 0;
    cCmd := liftDock;
    dCmd := liftDock;
    s40Cmd := 0;
    s41Cmd := 0;
    Y76 := TRUE;
    s4HomeReady := (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);
    aReady := (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100);
    IF s4HomeReady AND aReady AND X64 THEN
        state := 130;
        connActive := FALSE;
        connWait := 0;
    END_IF;

130:
    aCmd := D412;
    bCmd := 0;
    cCmd := liftDock;
    dCmd := liftDock;
    s40Cmd := 0;
    s41Cmd := 0;
    IF NOT connActive THEN
        seqNo := seqNo + 1;
        connActive := TRUE;
        connWait := 0;
    END_IF;
    D80 := 1;
    D81 := 4;
    connWait := connWait + 1;
    IF (connWait >= 3) AND (D90 = curId) THEN
        D80 := 0;
        connActive := FALSE;
        connWait := 0;
        state := 140;
    END_IF;

140:
    aCmd := sourceX;
    bCmd := 0;
    cCmd := liftDock;
    dCmd := liftDock;
    aReady := (ABS(D1000 - sourceX) <= 20) AND (ABS(D1001) <= 100);
    bReady0 := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    IF aReady AND bReady0 AND sourceReady THEN
        state := 150;
        connActive := FALSE;
        connWait := 0;
    END_IF;

150:
    aCmd := sourceX;
    bCmd := 18000;
    cCmd := liftDock;
    dCmd := liftDock;
    IF NOT connActive THEN
        seqNo := seqNo + 1;
        connActive := TRUE;
        connWait := 0;
    END_IF;
    D80 := 2;
    D81 := curSource;
    connWait := connWait + 1;
    IF (connWait >= 3) AND (D90 <> curId) THEN
        D80 := 0;
        connActive := FALSE;
        connWait := 0;
        state := 160;
    END_IF;

160:
    aCmd := sourceX;
    bCmd := 0;
    cCmd := 40000;
    dCmd := 40000;
    liftReadyHome := (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) AND (ABS(D1008 - D1012) <= 8000);
    bReady0 := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    IF liftReadyHome AND bReady0 THEN
        IF curSlot = 0 THEN
            r0Done := TRUE;
            r0Status := curStatus;
        ELSE
            r1Done := TRUE;
            r1Status := curStatus;
        END_IF;
        state := 0;
    END_IF;

ELSE
    state := 0;
END_CASE;

IF aCmd < -450000 THEN
    aCmd := -450000;
END_IF;
IF aCmd > 510000 THEN
    aCmd := 510000;
END_IF;
IF bCmd < 0 THEN
    bCmd := 0;
END_IF;
IF bCmd > 18000 THEN
    bCmd := 18000;
END_IF;
IF cCmd < 0 THEN
    cCmd := 0;
END_IF;
IF cCmd > 120000 THEN
    cCmd := 120000;
END_IF;
IF dCmd < 0 THEN
    dCmd := 0;
END_IF;
IF dCmd > 120000 THEN
    dCmd := 120000;
END_IF;
IF s30Cmd < 50000 THEN
    s30Cmd := 50000;
END_IF;
IF s30Cmd > 150000 THEN
    s30Cmd := 150000;
END_IF;
IF s31Cmd < -100000 THEN
    s31Cmd := -100000;
END_IF;
IF s31Cmd > 100000 THEN
    s31Cmd := 100000;
END_IF;
IF s32Cmd < -3000 THEN
    s32Cmd := -3000;
END_IF;
IF s32Cmd > 3000 THEN
    s32Cmd := 3000;
END_IF;
IF s40Cmd < -5000 THEN
    s40Cmd := -5000;
END_IF;
IF s40Cmd > 5000 THEN
    s40Cmd := 5000;
END_IF;
IF s41Cmd < -45000 THEN
    s41Cmd := -45000;
END_IF;
IF s41Cmd > 45000 THEN
    s41Cmd := 45000;
END_IF;

D2000 := aCmd;
D2004 := bCmd;
D2008 := cCmd;
D2012 := dCmd;
D2016 := s30Cmd;
D2020 := s31Cmd;
D2024 := s32Cmd;
D2028 := s40Cmd;
D2032 := s41Cmd;

D82 := seqNo;

IF r0Done AND (D100 <> 0) THEN
    D300 := D100;
    D301 := r0Status;
ELSE
    D300 := 0;
    D301 := 0;
END_IF;

IF r1Done AND (D120 <> 0) THEN
    D302 := D120;
    D303 := r1Status;
ELSE
    D302 := 0;
    D303 := 0;
END_IF;

IF (ABS(D1000 - aCmd) > 20) OR (ABS(D1001) > 100) THEN
    Y30 := FALSE;
ELSE
    Y30 := TRUE;
END_IF;

homeReady := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
             (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
             (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
             (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) AND
             (ABS(D1008 - D1012) <= 8000) AND
             (ABS(D1016 - 100000) <= 20) AND (ABS(D1017) <= 100) AND
             (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
             (ABS(D1024) <= 3) AND (ABS(D1025) <= 15) AND
             (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
             (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);

finalReady := X51 AND homeReady AND r0Done AND r1Done AND (state = 0);
Y2 := finalReady;

END_PROGRAM