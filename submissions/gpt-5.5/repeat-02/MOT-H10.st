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
    prevState : INT;
    currentId : DINT;
    currentChannel : INT;
    currentOrigin : INT;
    currentStatus : DINT;
    seqCount : DINT;
    connIssued : BOOL;
    entry : BOOL;
    originPort : DINT;
    originReady : BOOL;
    aCmd : DINT;
    bCmd : DINT;
    cCmd : DINT;
    dCmd : DINT;
    s30Cmd : DINT;
    s31Cmd : DINT;
    s40Cmd : DINT;
    s41Cmd : DINT;
    s42Cmd : DINT;
    angleDeg : REAL;
    angleRad : REAL;
    cwReal : REAL;
    hoistErr : DINT;
    hoistAcc : DINT;
    piVal : REAL := 3.14159265;
    readyA : BOOL;
    readyB : BOOL;
    readyC : BOOL;
    readyD : BOOL;
    readyS30 : BOOL;
    readyS31 : BOOL;
    readyS40 : BOOL;
    readyS41 : BOOL;
    readyS42 : BOOL;
    liftMove : BOOL;
    noPending0 : BOOL;
    noPending1 : BOOL;
    homeReady : BOOL;
    anyPending : BOOL;
END_VAR

entry := state <> prevState;
IF entry THEN
    connIssued := FALSE;
END_IF;
prevState := state;

D2001 := 850;
D2002 := 0;
D2005 := 850;
D2006 := 0;
D2009 := 850;
D2010 := 0;
D2013 := 850;
D2014 := 0;
D2017 := 800;
D2018 := 0;
D2021 := 900;
D2022 := 0;
D2025 := 450;
D2026 := 0;
D2029 := 600;
D2030 := 0;
D2033 := 600;
D2034 := 0;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;

D80 := 0;
D81 := 0;

aCmd := 0;
bCmd := 0;
cCmd := 15000;
dCmd := 15000;
s30Cmd := 0;
s31Cmd := 0;
s40Cmd := 100000;
s41Cmd := 0;
s42Cmd := 0;

Y70 := FALSE;
Y71 := FALSE;
D700 := 0;
D701 := D526;
D702 := 1000;
Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := D626;
D712 := 0;

noPending0 := (D100 = 0) OR (D300 = D100);
noPending1 := (D120 = 0) OR (D302 = D120);
anyPending := NOT noPending0 OR NOT noPending1;

IF currentOrigin = 2 THEN
    originPort := D406;
    originReady := X62;
ELSE
    originPort := D403;
    originReady := X61;
END_IF;

IF state = 0 THEN
    currentId := 0;
    currentChannel := 0;
    currentStatus := 1;
    IF (D100 <> 0) AND (D300 <> D100) THEN
        currentId := D100;
        currentChannel := 0;
        IF D101 = 2 THEN
            currentOrigin := 2;
        ELSE
            currentOrigin := 1;
        END_IF;
        IF X31 THEN
            currentStatus := 2;
            state := 210;
        ELSE
            currentStatus := 1;
            state := 10;
        END_IF;
    ELSIF (D120 <> 0) AND (D302 <> D120) THEN
        currentId := D120;
        currentChannel := 1;
        IF D121 = 1 THEN
            currentOrigin := 1;
        ELSIF D121 = 2 THEN
            currentOrigin := 2;
        ELSE
            currentOrigin := 2;
        END_IF;
        IF X35 THEN
            currentStatus := 2;
            state := 210;
        ELSE
            currentStatus := 1;
            state := 10;
        END_IF;
    END_IF;
END_IF;

IF currentOrigin = 2 THEN
    originPort := D406;
    originReady := X62;
ELSE
    originPort := D403;
    originReady := X61;
END_IF;

CASE state OF
0:
    aCmd := 0;
    bCmd := 0;
    cCmd := 15000;
    dCmd := 15000;
    s30Cmd := 0;
    s31Cmd := 0;
    s40Cmd := 100000;
    s41Cmd := 0;
    s42Cmd := 0;

10:
    aCmd := 0;
    bCmd := 0;
    IF currentOrigin = 2 THEN
        cCmd := 15000;
        dCmd := D92;
    ELSE
        cCmd := D92;
        dCmd := 15000;
    END_IF;
    IF ((currentOrigin = 1) AND (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100)) OR
       ((currentOrigin = 2) AND (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100)) THEN
        state := 15;
    END_IF;

15:
    aCmd := originPort;
    bCmd := 0;
    IF currentOrigin = 2 THEN
        cCmd := 15000;
        dCmd := D92;
    ELSE
        cCmd := D92;
        dCmd := 15000;
    END_IF;
    IF (ABS(D1000 - originPort) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND originReady THEN
        state := 20;
    END_IF;

20:
    aCmd := originPort;
    bCmd := 0;
    IF currentOrigin = 2 THEN
        dCmd := D92;
    ELSE
        cCmd := D92;
    END_IF;
    IF NOT connIssued THEN
        IF (ABS(D1000 - originPort) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND originReady THEN
            seqCount := seqCount + 1;
            connIssued := TRUE;
        END_IF;
    END_IF;
    IF connIssued THEN
        D80 := 1;
        D81 := DINT(currentOrigin);
    END_IF;
    IF D90 = currentId THEN
        state := 30;
    END_IF;

30:
    aCmd := D409;
    bCmd := 18000;
    cCmd := 15000;
    dCmd := 15000;
    s30Cmd := 0;
    s31Cmd := 0;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND X63 THEN
        state := 40;
    END_IF;

40:
    aCmd := D409;
    bCmd := 18000;
    IF NOT connIssued THEN
        IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND X63 THEN
            seqCount := seqCount + 1;
            connIssued := TRUE;
        END_IF;
    END_IF;
    IF connIssued THEN
        D80 := 2;
        D81 := 3;
    END_IF;
    IF (D90 <> currentId) OR (D410 = currentId) THEN
        state := 50;
    END_IF;

50:
    aCmd := D409;
    bCmd := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := currentId;
    D701 := D526;
    D702 := 1000;
    IF D500 < -5000 THEN
        s30Cmd := -5000;
    ELSIF D500 > 5000 THEN
        s30Cmd := 5000;
    ELSE
        s30Cmd := D500;
    END_IF;
    IF D501 = 0 THEN
        angleDeg := REAL(D1016) / 100.0;
        angleRad := angleDeg * piVal / 180.0;
        cwReal := -45000.0 * SIN(angleRad);
        s31Cmd := DINT(REAL_TO_INT(cwReal));
    ELSE
        s31Cmd := D501;
    END_IF;
    IF s31Cmd < -45000 THEN
        s31Cmd := -45000;
    ELSIF s31Cmd > 45000 THEN
        s31Cmd := 45000;
    END_IF;
    IF X70 AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) THEN
        state := 60;
    END_IF;

60:
    aCmd := D409;
    bCmd := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := currentId;
    s30Cmd := 0;
    s31Cmd := 0;
    IF (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND X63 THEN
        state := 70;
    END_IF;

70:
    aCmd := D409;
    bCmd := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := currentId;
    s30Cmd := 0;
    s31Cmd := 0;
    IF NOT connIssued THEN
        IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X63 THEN
            seqCount := seqCount + 1;
            connIssued := TRUE;
        END_IF;
    END_IF;
    IF connIssued THEN
        D80 := 1;
        D81 := 3;
    END_IF;
    IF D90 = currentId THEN
        state := 80;
    END_IF;

80:
    aCmd := D412;
    bCmd := 18000;
    s30Cmd := 0;
    s31Cmd := 0;
    s40Cmd := 100000;
    s41Cmd := 0;
    s42Cmd := 0;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100) AND
       (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 3) AND (ABS(D1033) <= 15) AND X64 THEN
        state := 90;
    END_IF;

90:
    aCmd := D412;
    bCmd := 18000;
    IF NOT connIssued THEN
        IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND X64 THEN
            seqCount := seqCount + 1;
            connIssued := TRUE;
        END_IF;
    END_IF;
    IF connIssued THEN
        D80 := 2;
        D81 := 4;
    END_IF;
    IF (D90 <> currentId) OR (D413 = currentId) THEN
        state := 100;
    END_IF;

100:
    aCmd := D412;
    bCmd := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := currentId;
    D711 := D626;
    IF D600 = 0 THEN
        s40Cmd := 100000;
    ELSE
        s40Cmd := D600;
    END_IF;
    IF s40Cmd < 50000 THEN
        s40Cmd := 50000;
    ELSIF s40Cmd > 150000 THEN
        s40Cmd := 150000;
    END_IF;
    s41Cmd := D601;
    IF s41Cmd < -100000 THEN
        s41Cmd := -100000;
    ELSIF s41Cmd > 100000 THEN
        s41Cmd := 100000;
    END_IF;
    s42Cmd := 0;
    hoistErr := s40Cmd - D1024;
    hoistAcc := hoistErr / 12 - D1025 / 4;
    IF hoistAcc > 5000 THEN
        hoistAcc := 5000;
    ELSIF hoistAcc < -5000 THEN
        hoistAcc := -5000;
    END_IF;
    D712 := hoistAcc;
    IF X75 AND (ABS(D1032) <= 3) AND (ABS(D1033) <= 15) THEN
        state := 110;
    END_IF;

110:
    aCmd := D412;
    bCmd := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := currentId;
    s40Cmd := 100000;
    s41Cmd := 0;
    s42Cmd := 0;
    hoistErr := 100000 - D1024;
    hoistAcc := hoistErr / 12 - D1025 / 4;
    IF hoistAcc > 4000 THEN
        hoistAcc := 4000;
    ELSIF hoistAcc < -4000 THEN
        hoistAcc := -4000;
    END_IF;
    D712 := hoistAcc;
    IF (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100) AND
       (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 3) AND (ABS(D1033) <= 15) AND X64 THEN
        state := 120;
    END_IF;

120:
    aCmd := D412;
    bCmd := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := currentId;
    s40Cmd := 100000;
    s41Cmd := 0;
    s42Cmd := 0;
    IF NOT connIssued THEN
        IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X64 THEN
            seqCount := seqCount + 1;
            connIssued := TRUE;
        END_IF;
    END_IF;
    IF connIssued THEN
        D80 := 1;
        D81 := 4;
    END_IF;
    IF D90 = currentId THEN
        state := 130;
    END_IF;

130:
    aCmd := originPort;
    bCmd := 18000;
    IF currentOrigin = 2 THEN
        dCmd := D92;
        cCmd := 15000;
    ELSE
        cCmd := D92;
        dCmd := 15000;
    END_IF;
    s40Cmd := 100000;
    s41Cmd := 0;
    s42Cmd := 0;
    IF (ABS(D1000 - originPort) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND originReady THEN
        state := 140;
    END_IF;

140:
    aCmd := originPort;
    bCmd := 18000;
    IF currentOrigin = 2 THEN
        dCmd := D92;
    ELSE
        cCmd := D92;
    END_IF;
    IF NOT connIssued THEN
        IF (ABS(D1000 - originPort) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND originReady THEN
            seqCount := seqCount + 1;
            connIssued := TRUE;
        END_IF;
    END_IF;
    IF connIssued THEN
        D80 := 2;
        D81 := DINT(currentOrigin);
    END_IF;
    IF (D90 <> currentId) OR ((currentOrigin = 1) AND (D404 = currentId)) OR ((currentOrigin = 2) AND (D407 = currentId)) THEN
        state := 150;
    END_IF;

150:
    aCmd := originPort;
    bCmd := 0;
    cCmd := 15000;
    dCmd := 15000;
    IF (((currentOrigin = 1) AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100)) OR
        ((currentOrigin = 2) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100))) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF currentChannel = 0 THEN
            D300 := currentId;
            D301 := currentStatus;
        ELSE
            D302 := currentId;
            D303 := currentStatus;
        END_IF;
        state := 0;
    END_IF;

210:
    aCmd := 0;
    bCmd := 0;
    cCmd := 15000;
    dCmd := 15000;
    IF (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) THEN
        IF currentChannel = 0 THEN
            D300 := currentId;
            D301 := 2;
        ELSE
            D302 := currentId;
            D303 := 2;
        END_IF;
        state := 0;
    END_IF;

ELSE
    state := 0;
END_CASE;

IF aCmd < -450000 THEN
    aCmd := -450000;
ELSIF aCmd > 1130000 THEN
    aCmd := 1130000;
END_IF;
IF bCmd < 0 THEN
    bCmd := 0;
ELSIF bCmd > 18000 THEN
    bCmd := 18000;
END_IF;
IF cCmd < 0 THEN
    cCmd := 0;
ELSIF cCmd > 120000 THEN
    cCmd := 120000;
END_IF;
IF dCmd < 0 THEN
    dCmd := 0;
ELSIF dCmd > 120000 THEN
    dCmd := 120000;
END_IF;
IF s30Cmd < -5000 THEN
    s30Cmd := -5000;
ELSIF s30Cmd > 5000 THEN
    s30Cmd := 5000;
END_IF;
IF s31Cmd < -45000 THEN
    s31Cmd := -45000;
ELSIF s31Cmd > 45000 THEN
    s31Cmd := 45000;
END_IF;
IF s40Cmd < 50000 THEN
    s40Cmd := 50000;
ELSIF s40Cmd > 150000 THEN
    s40Cmd := 150000;
END_IF;
IF s41Cmd < -100000 THEN
    s41Cmd := -100000;
ELSIF s41Cmd > 100000 THEN
    s41Cmd := 100000;
END_IF;
IF s42Cmd < -3000 THEN
    s42Cmd := -3000;
ELSIF s42Cmd > 3000 THEN
    s42Cmd := 3000;
END_IF;

D2000 := aCmd;
D2004 := bCmd;
D2008 := cCmd;
D2012 := dCmd;
D2016 := s30Cmd;
D2020 := s31Cmd;
D2024 := s40Cmd;
D2028 := s41Cmd;
D2032 := s42Cmd;
D82 := seqCount;

liftMove := (ABS(D2008 - D1008) > 20) OR (ABS(D2012 - D1012) > 20);
IF liftMove THEN
    Y30 := FALSE;
ELSE
    IF (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) THEN
        Y30 := TRUE;
    ELSE
        Y30 := FALSE;
    END_IF;
END_IF;

readyA := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100);
readyB := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
readyC := (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100);
readyD := (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100);
readyS30 := (ABS(D1016) <= 20) AND (ABS(D1017) <= 100);
readyS31 := (ABS(D1020) <= 20) AND (ABS(D1021) <= 100);
readyS40 := (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100);
readyS41 := (ABS(D1028) <= 20) AND (ABS(D1029) <= 100);
readyS42 := (ABS(D1032) <= 3) AND (ABS(D1033) <= 15);

homeReady := readyA AND readyB AND readyC AND readyD AND readyS30 AND readyS31 AND readyS40 AND readyS41 AND readyS42;

IF X51 AND (state = 0) AND (NOT anyPending) AND homeReady THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM