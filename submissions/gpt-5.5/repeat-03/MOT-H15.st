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
    initialized : BOOL;
    state : INT;
    currSlot : INT;
    currId : DINT;
    currOrigin : INT;
    currCancelled : BOOL;
    seq : DINT;
    aCmd : DINT;
    bCmd : DINT;
    cCmd : DINT;
    dCmd : DINT;
    s30Cmd : DINT;
    s31Cmd : DINT;
    s32Cmd : DINT;
    s40Cmd : DINT;
    s41Cmd : DINT;
    s42Cmd : DINT;
    originX : DINT;
    dockHeight : DINT;
    s30Goal : DINT;
    s31Goal : DINT;
    s32Goal : DINT;
    s4Goal : DINT;
    selectedPocket : INT;
    combinedRecord : DINT;
    ack0Done : BOOL;
    ack1Done : BOOL;
    ack0Id : DINT;
    ack1Id : DINT;
    ack0Status : DINT;
    ack1Status : DINT;
    lastR0Id : DINT;
    lastR1Id : DINT;
    finalTimer : TON;
    allHome : BOOL;
    pocketHome : BOOL;
    s3Home : BOOL;
    liftDocked : BOOL;
    liftHome : BOOL;
    forkHome : BOOL;
    forkConn : BOOL;
    shuttleStopped : BOOL;
    rad0 : REAL;
    rad1 : REAL;
    cwReal : REAL;
    cwRaw : DINT;
END_VAR

IF NOT initialized THEN
    state := 0;
    seq := 0;
    aCmd := 0;
    bCmd := 0;
    cCmd := 40000;
    dCmd := 40000;
    s30Cmd := 0;
    s31Cmd := 0;
    s32Cmd := 0;
    s40Cmd := 0;
    s41Cmd := 0;
    s42Cmd := 0;
    initialized := TRUE;
END_IF;

IF D100 <> lastR0Id THEN
    lastR0Id := D100;
    ack0Done := FALSE;
    ack0Id := 0;
    ack0Status := 0;
END_IF;

IF D120 <> lastR1Id THEN
    lastR1Id := D120;
    ack1Done := FALSE;
    ack1Id := 0;
    ack1Status := 0;
END_IF;

IF D92 < 0 THEN
    dockHeight := 0;
ELSIF D92 > 120000 THEN
    dockHeight := 120000;
ELSE
    dockHeight := D92;
END_IF;

forkHome := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
forkConn := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
shuttleStopped := ABS(D1001) <= 100;
liftDocked := (ABS(D1008 - dockHeight) <= 20) AND (ABS(D1012 - dockHeight) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100);
liftHome := (ABS(D1008 - 40000) <= 20) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100);
s3Home := (ABS(D1016) <= 20) AND (ABS(D1020) <= 20) AND (ABS(D1024) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) AND (ABS(D1025) <= 100);
pocketHome := (ABS(D1028) <= 20) AND (ABS(D1032) <= 20) AND (ABS(D1036) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1033) <= 100) AND (ABS(D1037) <= 100);

allHome := (ABS(D1000) <= 20) AND shuttleStopped AND forkHome AND liftHome AND s3Home AND pocketHome;

rad0 := REAL(D1016) * 0.000174532925;
rad1 := REAL(D1020) * 0.000174532925;
cwReal := -22500.0 * (SIN(rad0) + SIN(rad1));
cwRaw := DINT(ROUND(cwReal));
IF cwRaw < -45000 THEN
    cwRaw := -45000;
ELSIF cwRaw > 45000 THEN
    cwRaw := 45000;
END_IF;

IF state <> 0 THEN
    IF currSlot = 0 THEN
        IF X31 THEN
            currCancelled := TRUE;
        END_IF;
    ELSE
        IF X35 THEN
            currCancelled := TRUE;
        END_IF;
    END_IF;
END_IF;

D80 := 0;
D81 := 0;
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

CASE state OF
0:
    aCmd := 0;
    bCmd := 0;
    cCmd := 40000;
    dCmd := 40000;
    s30Cmd := 0;
    s31Cmd := 0;
    s32Cmd := 0;
    s40Cmd := 0;
    s41Cmd := 0;
    s42Cmd := 0;
    selectedPocket := 0;
    IF (D100 <> 0) AND (NOT ack0Done) AND (NOT X30) THEN
        currSlot := 0;
        currId := D100;
        currCancelled := X31;
        IF D101 = 2 THEN
            currOrigin := 2;
        ELSE
            currOrigin := 1;
        END_IF;
        state := 10;
    ELSIF (D120 <> 0) AND (NOT ack1Done) AND (NOT X34) THEN
        currSlot := 1;
        currId := D120;
        currCancelled := X35;
        IF D121 = 2 THEN
            currOrigin := 2;
        ELSE
            currOrigin := 1;
        END_IF;
        state := 10;
    ELSIF (D100 <> 0) AND (NOT ack0Done) AND X30 THEN
        ack0Done := TRUE;
        ack0Id := D100;
        IF X31 THEN
            ack0Status := 2;
        ELSE
            ack0Status := 1;
        END_IF;
    ELSIF (D120 <> 0) AND (NOT ack1Done) AND X34 THEN
        ack1Done := TRUE;
        ack1Id := D120;
        IF X35 THEN
            ack1Status := 2;
        ELSE
            ack1Status := 1;
        END_IF;
    END_IF;

10:
    bCmd := 0;
    cCmd := dockHeight;
    dCmd := dockHeight;
    s30Cmd := 0;
    s31Cmd := 0;
    s32Cmd := 0;
    s40Cmd := 0;
    s41Cmd := 0;
    s42Cmd := 0;
    IF currOrigin = 2 THEN
        originX := D406;
        aCmd := D406;
        IF (ABS(D1000 - D406) <= 20) AND shuttleStopped AND liftDocked AND forkHome AND X62 THEN
            seq := seq + 1;
            state := 20;
        END_IF;
    ELSE
        originX := D403;
        aCmd := D403;
        IF (ABS(D1000 - D403) <= 20) AND shuttleStopped AND liftDocked AND forkHome AND X61 THEN
            seq := seq + 1;
            state := 20;
        END_IF;
    END_IF;

20:
    aCmd := originX;
    bCmd := 18000;
    cCmd := dockHeight;
    dCmd := dockHeight;
    IF forkConn THEN
        state := 21;
    END_IF;

21:
    aCmd := originX;
    bCmd := 18000;
    cCmd := dockHeight;
    dCmd := dockHeight;
    D80 := 1;
    D81 := currOrigin;
    IF D90 = currId THEN
        state := 22;
    END_IF;

22:
    aCmd := originX;
    bCmd := 0;
    cCmd := dockHeight;
    dCmd := dockHeight;
    IF forkHome THEN
        IF currCancelled THEN
            state := 110;
        ELSE
            state := 30;
        END_IF;
    END_IF;

30:
    aCmd := D409;
    bCmd := 0;
    cCmd := dockHeight;
    dCmd := dockHeight;
    s30Cmd := 0;
    s31Cmd := 0;
    s32Cmd := 0;
    IF (ABS(D1000 - D409) <= 20) AND shuttleStopped AND forkHome AND X63 AND s3Home THEN
        seq := seq + 1;
        state := 40;
    END_IF;

40:
    aCmd := D409;
    bCmd := 18000;
    IF forkConn THEN
        state := 41;
    END_IF;

41:
    aCmd := D409;
    bCmd := 18000;
    D80 := 2;
    D81 := 3;
    IF (D90 = 0) OR (D410 = currId) THEN
        state := 42;
    END_IF;

42:
    aCmd := D409;
    bCmd := 0;
    IF forkHome THEN
        state := 50;
    END_IF;

50:
    aCmd := D409;
    bCmd := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    IF D500 < -5000 THEN
        s30Goal := -5000;
    ELSIF D500 > 5000 THEN
        s30Goal := 5000;
    ELSE
        s30Goal := D500;
    END_IF;
    IF D501 < -5000 THEN
        s31Goal := -5000;
    ELSIF D501 > 5000 THEN
        s31Goal := 5000;
    ELSE
        s31Goal := D501;
    END_IF;
    IF (s30Goal = 0) AND (s31Goal = 0) THEN
        IF currSlot = 0 THEN
            IF D104 >= 135 THEN
                s30Goal := -3500;
                s31Goal := 2000;
            ELSE
                s30Goal := 3500;
                s31Goal := -2000;
            END_IF;
        ELSE
            IF D124 >= 135 THEN
                s30Goal := -3500;
                s31Goal := 2000;
            ELSE
                s30Goal := 3500;
                s31Goal := -2000;
            END_IF;
        END_IF;
    END_IF;
    s30Cmd := s30Goal;
    s31Cmd := s31Goal;
    s32Cmd := cwRaw;
    IF s30Goal < 0 THEN
        D700 := 180;
    ELSE
        D700 := 90;
    END_IF;
    D701 := 4;
    IF X70 THEN
        IF D527 <> 0 THEN
            combinedRecord := D527;
        ELSE
            IF currSlot = 0 THEN
                combinedRecord := D104;
            ELSE
                combinedRecord := D124;
            END_IF;
        END_IF;
        state := 55;
    END_IF;

55:
    aCmd := D409;
    bCmd := 0;
    Y71 := TRUE;
    s30Cmd := 0;
    s31Cmd := 0;
    s32Cmd := 0;
    IF s3Home THEN
        state := 60;
    END_IF;

60:
    aCmd := D409;
    bCmd := 0;
    Y71 := TRUE;
    IF (ABS(D1000 - D409) <= 20) AND shuttleStopped AND forkHome AND X63 AND s3Home THEN
        seq := seq + 1;
        state := 61;
    END_IF;

61:
    aCmd := D409;
    bCmd := 18000;
    Y71 := TRUE;
    IF forkConn THEN
        state := 62;
    END_IF;

62:
    aCmd := D409;
    bCmd := 18000;
    Y71 := TRUE;
    D80 := 1;
    D81 := 3;
    IF D90 = currId THEN
        state := 63;
    END_IF;

63:
    aCmd := D409;
    bCmd := 0;
    IF forkHome THEN
        IF currCancelled THEN
            state := 110;
        ELSE
            state := 70;
        END_IF;
    END_IF;

70:
    aCmd := D412;
    bCmd := 0;
    s40Cmd := 0;
    s41Cmd := 0;
    s42Cmd := 0;
    IF pocketHome THEN
        IF combinedRecord < 0 THEN
            selectedPocket := 1;
        ELSE
            selectedPocket := 2;
        END_IF;
        IF (ABS(D1000 - D412) <= 20) AND shuttleStopped AND forkHome AND X64 THEN
            seq := seq + 1;
            state := 80;
        END_IF;
    END_IF;

80:
    aCmd := D412;
    bCmd := 18000;
    Y75 := TRUE;
    D710 := selectedPocket;
    D711 := selectedPocket;
    IF forkConn THEN
        state := 81;
    END_IF;

81:
    aCmd := D412;
    bCmd := 18000;
    Y75 := TRUE;
    D710 := selectedPocket;
    D711 := selectedPocket;
    D80 := 2;
    D81 := 4;
    IF (D90 = 0) OR (D413 = currId) THEN
        state := 82;
    END_IF;

82:
    aCmd := D412;
    bCmd := 0;
    Y75 := TRUE;
    D710 := selectedPocket;
    D711 := selectedPocket;
    IF forkHome THEN
        state := 90;
    END_IF;

90:
    aCmd := D412;
    bCmd := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := selectedPocket;
    D711 := selectedPocket;
    IF D602 <= 0 THEN
        s4Goal := 70000;
    ELSIF D602 > 100000 THEN
        s4Goal := 100000;
    ELSE
        s4Goal := D602;
    END_IF;
    IF selectedPocket = 1 THEN
        s40Cmd := s4Goal;
        s41Cmd := 0;
        s42Cmd := 0;
    ELSE
        s40Cmd := 0;
        s41Cmd := s4Goal;
        s42Cmd := 0;
    END_IF;
    IF X75 THEN
        state := 95;
    END_IF;

95:
    aCmd := D412;
    bCmd := 0;
    Y76 := TRUE;
    D710 := selectedPocket;
    D711 := selectedPocket;
    s40Cmd := 0;
    s41Cmd := 0;
    s42Cmd := 0;
    IF pocketHome THEN
        state := 100;
    END_IF;

100:
    aCmd := D412;
    bCmd := 0;
    Y76 := TRUE;
    D710 := selectedPocket;
    D711 := selectedPocket;
    IF (ABS(D1000 - D412) <= 20) AND shuttleStopped AND forkHome AND X64 AND pocketHome THEN
        seq := seq + 1;
        state := 101;
    END_IF;

101:
    aCmd := D412;
    bCmd := 18000;
    Y76 := TRUE;
    D710 := selectedPocket;
    D711 := selectedPocket;
    IF forkConn THEN
        state := 102;
    END_IF;

102:
    aCmd := D412;
    bCmd := 18000;
    Y76 := TRUE;
    D710 := selectedPocket;
    D711 := selectedPocket;
    D80 := 1;
    D81 := 4;
    IF D90 = currId THEN
        state := 103;
    END_IF;

103:
    aCmd := D412;
    bCmd := 0;
    IF forkHome THEN
        state := 110;
    END_IF;

110:
    bCmd := 0;
    cCmd := dockHeight;
    dCmd := dockHeight;
    IF currOrigin = 2 THEN
        originX := D406;
        aCmd := D406;
        IF (ABS(D1000 - D406) <= 20) AND shuttleStopped AND liftDocked AND forkHome AND X62 THEN
            seq := seq + 1;
            state := 111;
        END_IF;
    ELSE
        originX := D403;
        aCmd := D403;
        IF (ABS(D1000 - D403) <= 20) AND shuttleStopped AND liftDocked AND forkHome AND X61 THEN
            seq := seq + 1;
            state := 111;
        END_IF;
    END_IF;

111:
    aCmd := originX;
    bCmd := 18000;
    cCmd := dockHeight;
    dCmd := dockHeight;
    IF forkConn THEN
        state := 112;
    END_IF;

112:
    aCmd := originX;
    bCmd := 18000;
    cCmd := dockHeight;
    dCmd := dockHeight;
    D80 := 2;
    D81 := currOrigin;
    IF (D90 = 0) OR ((currOrigin = 1) AND (D404 = currId)) OR ((currOrigin = 2) AND (D407 = currId)) THEN
        state := 113;
    END_IF;

113:
    aCmd := originX;
    bCmd := 0;
    cCmd := dockHeight;
    dCmd := dockHeight;
    IF forkHome THEN
        state := 114;
    END_IF;

114:
    aCmd := 0;
    bCmd := 0;
    cCmd := 40000;
    dCmd := 40000;
    s30Cmd := 0;
    s31Cmd := 0;
    s32Cmd := 0;
    s40Cmd := 0;
    s41Cmd := 0;
    s42Cmd := 0;
    IF liftHome AND forkHome AND (ABS(D1000) <= 20) AND shuttleStopped THEN
        IF currSlot = 0 THEN
            ack0Done := TRUE;
            ack0Id := currId;
            IF currCancelled THEN
                ack0Status := 2;
            ELSE
                ack0Status := 1;
            END_IF;
        ELSE
            ack1Done := TRUE;
            ack1Id := currId;
            IF currCancelled THEN
                ack1Status := 2;
            ELSE
                ack1Status := 1;
            END_IF;
        END_IF;
        state := 0;
    END_IF;

ELSE
    state := 0;
END_CASE;

IF aCmd < -450000 THEN
    aCmd := -450000;
ELSIF aCmd > 450000 THEN
    aCmd := 450000;
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
IF s31Cmd < -5000 THEN
    s31Cmd := -5000;
ELSIF s31Cmd > 5000 THEN
    s31Cmd := 5000;
END_IF;
IF s32Cmd < -45000 THEN
    s32Cmd := -45000;
ELSIF s32Cmd > 45000 THEN
    s32Cmd := 45000;
END_IF;
IF s40Cmd < 0 THEN
    s40Cmd := 0;
ELSIF s40Cmd > 100000 THEN
    s40Cmd := 100000;
END_IF;
IF s41Cmd < 0 THEN
    s41Cmd := 0;
ELSIF s41Cmd > 100000 THEN
    s41Cmd := 100000;
END_IF;
IF s42Cmd < 0 THEN
    s42Cmd := 0;
ELSIF s42Cmd > 100000 THEN
    s42Cmd := 100000;
END_IF;

D2000 := aCmd;
D2001 := 800;
D2002 := 0;
Y40 := TRUE;

D2004 := bCmd;
D2005 := 500;
D2006 := 0;
Y41 := TRUE;

D2008 := cCmd;
D2009 := 700;
D2010 := 0;
Y42 := TRUE;

D2012 := dCmd;
D2013 := 700;
D2014 := 0;
Y43 := TRUE;

D2016 := s30Cmd;
D2017 := 300;
D2018 := 0;
Y44 := TRUE;

D2020 := s31Cmd;
D2021 := 300;
D2022 := 0;
Y45 := TRUE;

D2024 := s32Cmd;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2028 := s40Cmd;
D2029 := 700;
D2030 := 0;
Y47 := TRUE;

D2032 := s41Cmd;
D2033 := 700;
D2034 := 0;
Y48 := TRUE;

D2036 := s42Cmd;
D2037 := 700;
D2038 := 0;
Y49 := TRUE;

D82 := seq;

IF ack0Done THEN
    D300 := ack0Id;
    D301 := ack0Status;
ELSE
    D300 := 0;
    D301 := 0;
END_IF;

IF ack1Done THEN
    D302 := ack1Id;
    D303 := ack1Status;
ELSE
    D302 := 0;
    D303 := 0;
END_IF;

Y30 := (state = 0) AND X51 AND allHome;

finalTimer(IN := (state = 0) AND X51 AND allHome, PT := T#100ms);
Y2 := finalTimer.Q;
END_PROGRAM