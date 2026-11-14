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
    state : INT;
    prevState : INT;
    currentReq : INT;
    curId : DINT;
    curStatus : DINT;
    originStation : DINT;
    seqNo : DINT;
    connIssued : BOOL;
    connWait : INT;
    m3Count : INT;
    m4Count : INT;
    r0Done : BOOL;
    r1Done : BOOL;
    lastR0Id : DINT;
    lastR1Id : DINT;
    dockTarget : DINT;
    portTarget : DINT;
    m3T0 : DINT;
    m3T1 : DINT;
    m3T2 : DINT;
    m4Target : DINT;
    pocketSelect : DINT := 2;
    combinedRecord : DINT;
    recipeCode : DINT;
    angle0Rad : REAL;
    angle1Rad : REAL;
    cwRawReal : REAL;
    momentReal : REAL;
    allHome : BOOL;
    allPocketsHome : BOOL;
    readyBool : BOOL;
END_VAR

IF D100 <> lastR0Id THEN
    lastR0Id := D100;
    r0Done := FALSE;
    D300 := 0;
    D301 := 0;
END_IF;
IF D120 <> lastR1Id THEN
    lastR1Id := D120;
    r1Done := FALSE;
    D302 := 0;
    D303 := 0;
END_IF;

IF state <> prevState THEN
    connIssued := FALSE;
    connWait := 0;
    m3Count := 0;
    m4Count := 0;
    prevState := state;
END_IF;

dockTarget := D92;
IF dockTarget < 0 THEN
    dockTarget := 0;
ELSIF dockTarget > 120000 THEN
    dockTarget := 120000;
END_IF;

IF currentReq = 0 THEN
    recipeCode := D104;
ELSE
    recipeCode := D124;
END_IF;

IF (ABS(D500) > 100) OR (ABS(D501) > 100) THEN
    m3T0 := D500;
    m3T1 := D501;
ELSE
    IF recipeCode = 180 THEN
        m3T0 := -3500;
        m3T1 := 2000;
    ELSE
        m3T0 := 3500;
        m3T1 := -2000;
    END_IF;
END_IF;

IF m3T0 < -5000 THEN
    m3T0 := -5000;
ELSIF m3T0 > 5000 THEN
    m3T0 := 5000;
END_IF;
IF m3T1 < -5000 THEN
    m3T1 := -5000;
ELSIF m3T1 > 5000 THEN
    m3T1 := 5000;
END_IF;

angle0Rad := REAL(m3T0) * 0.000174532925;
angle1Rad := REAL(m3T1) * 0.000174532925;
cwRawReal := -22500.0 * (SIN(angle0Rad) + SIN(angle1Rad));
m3T2 := DINT(REAL_TO_INT(cwRawReal));
IF m3T2 < -45000 THEN
    m3T2 := -45000;
ELSIF m3T2 > 45000 THEN
    m3T2 := 45000;
END_IF;

angle0Rad := REAL(D1016) * 0.000174532925;
angle1Rad := REAL(D1020) * 0.000174532925;
momentReal := 0.1962 * (225.0 * (SIN(angle0Rad) + SIN(angle1Rad)) + REAL(D1024) * 0.01);

allPocketsHome := (ABS(D1028) <= 20) AND (ABS(D1032) <= 20) AND (ABS(D1036) <= 20) AND
                  (ABS(D1029) <= 100) AND (ABS(D1033) <= 100) AND (ABS(D1037) <= 100);

allHome := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
           (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
           (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) AND
           (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND
           (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
           (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
           allPocketsHome;

D2001 := 1000;
D2005 := 1000;
D2009 := 1000;
D2013 := 1000;
D2017 := 1000;
D2021 := 1000;
D2025 := 1000;
D2029 := 1000;
D2033 := 1000;
D2037 := 1000;

D2002 := 0;
D2006 := 0;
D2010 := 0;
D2014 := 0;
D2018 := 0;
D2022 := 0;
D2026 := 0;
D2030 := 0;
D2034 := 0;
D2038 := 0;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;
Y49 := TRUE;

D2000 := 0;
D2004 := 0;
D2008 := 40000;
D2012 := 40000;
D2016 := 0;
D2020 := 0;
D2024 := 0;
D2028 := 0;
D2032 := 0;
D2036 := 0;

Y70 := FALSE;
Y71 := FALSE;
D700 := 1;
D701 := 4;
D702 := 1000;
Y75 := FALSE;
Y76 := FALSE;
D710 := pocketSelect;
D711 := 0;
D712 := 1000;

D80 := 0;
D81 := 0;
Y30 := FALSE;
Y2 := FALSE;

CASE state OF
0:
    Y30 := TRUE;
    IF (D100 > 0) AND NOT r0Done AND NOT X30 THEN
        currentReq := 0;
        curId := D100;
        IF X31 THEN
            curStatus := 2;
        ELSE
            curStatus := 1;
        END_IF;
        IF D101 <= 1 THEN
            originStation := D101 + 1;
        ELSE
            IF D101 = 2 THEN
                originStation := 2;
            ELSE
                originStation := 1;
            END_IF;
        END_IF;
        state := 20;
    ELSIF (D120 > 0) AND NOT r1Done AND NOT X34 THEN
        currentReq := 1;
        curId := D120;
        IF X35 THEN
            curStatus := 2;
        ELSE
            curStatus := 1;
        END_IF;
        IF D121 <= 1 THEN
            originStation := D121 + 1;
        ELSE
            IF D121 = 2 THEN
                originStation := 2;
            ELSE
                originStation := 1;
            END_IF;
        END_IF;
        state := 20;
    ELSE
        IF X51 AND allHome THEN
            Y2 := TRUE;
            Y30 := TRUE;
        END_IF;
    END_IF;

20:
    D2008 := dockTarget;
    D2012 := dockTarget;
    IF originStation = 2 THEN
        portTarget := D406;
        readyBool := X62;
    ELSE
        portTarget := D403;
        readyBool := X61;
    END_IF;
    IF portTarget < -450000 THEN
        portTarget := -450000;
    ELSIF portTarget > 450000 THEN
        portTarget := 450000;
    END_IF;
    D2000 := portTarget;
    D2004 := 0;
    IF (ABS(D1000 - portTarget) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1008 - dockTarget) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - dockTarget) <= 20) AND (ABS(D1013) <= 100) AND readyBool THEN
        state := 30;
    END_IF;

30:
    D2008 := dockTarget;
    D2012 := dockTarget;
    IF originStation = 2 THEN
        portTarget := D406;
    ELSE
        portTarget := D403;
    END_IF;
    D2000 := portTarget;
    D2004 := 18000;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        IF NOT connIssued THEN
            seqNo := seqNo + 1;
            D82 := seqNo;
            D80 := 1;
            D81 := originStation;
            connIssued := TRUE;
            connWait := 0;
        ELSE
            connWait := connWait + 1;
            IF (D90 = curId) OR (connWait >= 10) THEN
                state := 35;
            END_IF;
        END_IF;
    END_IF;

35:
    D2008 := dockTarget;
    D2012 := dockTarget;
    IF originStation = 2 THEN
        D2000 := D406;
    ELSE
        D2000 := D403;
    END_IF;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF curStatus = 2 THEN
            state := 120;
        ELSE
            state := 40;
        END_IF;
    END_IF;

40:
    D2008 := dockTarget;
    D2012 := dockTarget;
    portTarget := D409;
    IF portTarget < -450000 THEN
        portTarget := -450000;
    ELSIF portTarget > 450000 THEN
        portTarget := 450000;
    END_IF;
    D2000 := portTarget;
    D2004 := 0;
    IF (ABS(D1000 - portTarget) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X63 AND
       (ABS(D1016) <= 20) AND (ABS(D1020) <= 20) AND (ABS(D1024) <= 20) THEN
        state := 50;
    END_IF;

50:
    D2008 := dockTarget;
    D2012 := dockTarget;
    D2000 := D409;
    D2004 := 18000;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        IF NOT connIssued THEN
            seqNo := seqNo + 1;
            D82 := seqNo;
            D80 := 2;
            D81 := 3;
            connIssued := TRUE;
            connWait := 0;
        ELSE
            connWait := connWait + 1;
            IF (D90 <> curId) OR (connWait >= 10) THEN
                state := 55;
            END_IF;
        END_IF;
    END_IF;

55:
    D2008 := dockTarget;
    D2012 := dockTarget;
    D2000 := D409;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 60;
    END_IF;

60:
    D2008 := dockTarget;
    D2012 := dockTarget;
    D2000 := D409;
    D2004 := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := 1;
    D701 := 4;
    D702 := 1000;
    D2016 := m3T0;
    D2020 := m3T1;
    D2024 := m3T2;
    IF (ABS(D1016 - m3T0) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020 - m3T1) <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1024 - m3T2) <= 20) AND (ABS(D1025) <= 100) AND
       (ABS(momentReal) <= 1.0) THEN
        IF m3Count < 10 THEN
            m3Count := m3Count + 1;
        END_IF;
    ELSE
        m3Count := 0;
    END_IF;
    IF X70 OR (m3Count >= 4) THEN
        combinedRecord := D1016 + D1020;
        state := 65;
    END_IF;

65:
    D2008 := dockTarget;
    D2012 := dockTarget;
    D2000 := D409;
    D2004 := 0;
    Y71 := TRUE;
    D2016 := 0;
    D2020 := 0;
    D2024 := 0;
    IF (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) THEN
        state := 70;
    END_IF;

70:
    D2008 := dockTarget;
    D2012 := dockTarget;
    D2000 := D409;
    D2004 := 18000;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        IF NOT connIssued THEN
            seqNo := seqNo + 1;
            D82 := seqNo;
            D80 := 1;
            D81 := 3;
            connIssued := TRUE;
            connWait := 0;
        ELSE
            connWait := connWait + 1;
            IF (D90 = curId) OR (connWait >= 10) THEN
                state := 75;
            END_IF;
        END_IF;
    END_IF;

75:
    D2008 := dockTarget;
    D2012 := dockTarget;
    D2000 := D409;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 80;
    END_IF;

80:
    D2008 := dockTarget;
    D2012 := dockTarget;
    D2000 := D412;
    D2004 := 0;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X64 AND allPocketsHome THEN
        state := 85;
    END_IF;

85:
    D2008 := dockTarget;
    D2012 := dockTarget;
    D2000 := D412;
    D2004 := 18000;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        IF NOT connIssued THEN
            seqNo := seqNo + 1;
            D82 := seqNo;
            D80 := 2;
            D81 := 4;
            connIssued := TRUE;
            connWait := 0;
        ELSE
            connWait := connWait + 1;
            IF (D90 <> curId) OR (connWait >= 10) THEN
                state := 86;
            END_IF;
        END_IF;
    END_IF;

86:
    D2008 := dockTarget;
    D2012 := dockTarget;
    D2000 := D412;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF combinedRecord < 0 THEN
            pocketSelect := 1;
        ELSE
            pocketSelect := 2;
        END_IF;
        state := 90;
    END_IF;

90:
    D2008 := dockTarget;
    D2012 := dockTarget;
    D2000 := D412;
    D2004 := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := pocketSelect;
    D711 := originStation;
    D712 := 1000;
    IF pocketSelect = 1 THEN
        m4Target := D600;
        IF m4Target <= 0 THEN
            m4Target := 70000;
        END_IF;
        D2028 := m4Target;
        D2032 := 0;
        D2036 := 0;
        IF (ABS(D1028 - m4Target) <= 20) AND (ABS(D1029) <= 100) THEN
            IF m4Count < 10 THEN
                m4Count := m4Count + 1;
            END_IF;
        ELSE
            m4Count := 0;
        END_IF;
    ELSE
        m4Target := D601;
        IF m4Target <= 0 THEN
            m4Target := 70000;
        END_IF;
        D2028 := 0;
        D2032 := m4Target;
        D2036 := 0;
        IF (ABS(D1032 - m4Target) <= 20) AND (ABS(D1033) <= 100) THEN
            IF m4Count < 10 THEN
                m4Count := m4Count + 1;
            END_IF;
        ELSE
            m4Count := 0;
        END_IF;
    END_IF;
    IF m4Target > 100000 THEN
        m4Target := 100000;
    END_IF;
    IF X75 OR (m4Count >= 4) THEN
        state := 100;
    END_IF;

100:
    D2008 := dockTarget;
    D2012 := dockTarget;
    D2000 := D412;
    D2004 := 0;
    Y76 := TRUE;
    D710 := pocketSelect;
    D2028 := 0;
    D2032 := 0;
    D2036 := 0;
    IF allPocketsHome THEN
        state := 110;
    END_IF;

110:
    D2008 := dockTarget;
    D2012 := dockTarget;
    D2000 := D412;
    D2004 := 18000;
    D710 := pocketSelect;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND allPocketsHome THEN
        IF NOT connIssued THEN
            seqNo := seqNo + 1;
            D82 := seqNo;
            D80 := 1;
            D81 := 4;
            connIssued := TRUE;
            connWait := 0;
        ELSE
            connWait := connWait + 1;
            IF (D90 = curId) OR (connWait >= 10) THEN
                state := 111;
            END_IF;
        END_IF;
    END_IF;

111:
    D2008 := dockTarget;
    D2012 := dockTarget;
    D2000 := D412;
    D2004 := 0;
    D710 := pocketSelect;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 120;
    END_IF;

120:
    D2008 := dockTarget;
    D2012 := dockTarget;
    IF originStation = 2 THEN
        portTarget := D406;
        readyBool := X62;
    ELSE
        portTarget := D403;
        readyBool := X61;
    END_IF;
    D2000 := portTarget;
    D2004 := 0;
    IF (ABS(D1000 - portTarget) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1008 - dockTarget) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - dockTarget) <= 20) AND (ABS(D1013) <= 100) AND readyBool THEN
        state := 125;
    END_IF;

125:
    D2008 := dockTarget;
    D2012 := dockTarget;
    IF originStation = 2 THEN
        D2000 := D406;
    ELSE
        D2000 := D403;
    END_IF;
    D2004 := 18000;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        IF NOT connIssued THEN
            seqNo := seqNo + 1;
            D82 := seqNo;
            D80 := 2;
            D81 := originStation;
            connIssued := TRUE;
            connWait := 0;
        ELSE
            connWait := connWait + 1;
            IF (D90 <> curId) OR (connWait >= 10) THEN
                state := 126;
            END_IF;
        END_IF;
    END_IF;

126:
    IF originStation = 2 THEN
        D2000 := D406;
    ELSE
        D2000 := D403;
    END_IF;
    D2008 := dockTarget;
    D2012 := dockTarget;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 130;
    END_IF;

130:
    IF originStation = 2 THEN
        D2000 := D406;
    ELSE
        D2000 := D403;
    END_IF;
    D2004 := 0;
    D2008 := 40000;
    D2012 := 40000;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) THEN
        IF currentReq = 0 THEN
            D300 := curId;
            D301 := curStatus;
            r0Done := TRUE;
        ELSE
            D302 := curId;
            D303 := curStatus;
            r1Done := TRUE;
        END_IF;
        state := 0;
    END_IF;

ELSE
    state := 0;
END_CASE;

IF D2000 < -450000 THEN
    D2000 := -450000;
ELSIF D2000 > 450000 THEN
    D2000 := 450000;
END_IF;
IF D2004 < 0 THEN
    D2004 := 0;
ELSIF D2004 > 18000 THEN
    D2004 := 18000;
END_IF;
IF D2008 < 0 THEN
    D2008 := 0;
ELSIF D2008 > 120000 THEN
    D2008 := 120000;
END_IF;
IF D2012 < 0 THEN
    D2012 := 0;
ELSIF D2012 > 120000 THEN
    D2012 := 120000;
END_IF;
IF D2016 < -5000 THEN
    D2016 := -5000;
ELSIF D2016 > 5000 THEN
    D2016 := 5000;
END_IF;
IF D2020 < -5000 THEN
    D2020 := -5000;
ELSIF D2020 > 5000 THEN
    D2020 := 5000;
END_IF;
IF D2024 < -45000 THEN
    D2024 := -45000;
ELSIF D2024 > 45000 THEN
    D2024 := 45000;
END_IF;
IF D2028 < 0 THEN
    D2028 := 0;
ELSIF D2028 > 100000 THEN
    D2028 := 100000;
END_IF;
IF D2032 < 0 THEN
    D2032 := 0;
ELSIF D2032 > 100000 THEN
    D2032 := 100000;
END_IF;
IF D2036 < 0 THEN
    D2036 := 0;
ELSIF D2036 > 100000 THEN
    D2036 := 100000;
END_IF;

IF D2001 < 0 THEN D2001 := 0; ELSIF D2001 > 1000 THEN D2001 := 1000; END_IF;
IF D2005 < 0 THEN D2005 := 0; ELSIF D2005 > 1000 THEN D2005 := 1000; END_IF;
IF D2009 < 0 THEN D2009 := 0; ELSIF D2009 > 1000 THEN D2009 := 1000; END_IF;
IF D2013 < 0 THEN D2013 := 0; ELSIF D2013 > 1000 THEN D2013 := 1000; END_IF;
IF D2017 < 0 THEN D2017 := 0; ELSIF D2017 > 1000 THEN D2017 := 1000; END_IF;
IF D2021 < 0 THEN D2021 := 0; ELSIF D2021 > 1000 THEN D2021 := 1000; END_IF;
IF D2025 < 0 THEN D2025 := 0; ELSIF D2025 > 1000 THEN D2025 := 1000; END_IF;
IF D2029 < 0 THEN D2029 := 0; ELSIF D2029 > 1000 THEN D2029 := 1000; END_IF;
IF D2033 < 0 THEN D2033 := 0; ELSIF D2033 > 1000 THEN D2033 := 1000; END_IF;
IF D2037 < 0 THEN D2037 := 0; ELSIF D2037 > 1000 THEN D2037 := 1000; END_IF;
END_PROGRAM