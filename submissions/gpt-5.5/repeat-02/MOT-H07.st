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
    state : INT := 0;
    curSlot : INT := 0;
    curId : DINT := 0;
    curOrig : INT := 1;
    curStatus : DINT := 1;
    seq : DINT := 0;
    ack0Done : BOOL := FALSE;
    ack1Done : BOOL := FALSE;
    ack0Id : DINT := 0;
    ack1Id : DINT := 0;
    ack0Status : DINT := 0;
    ack1Status : DINT := 0;
    connStarted : BOOL := FALSE;
    connTimer : TON;
    doneTimer : TON;
    finalDeclared : BOOL := FALSE;
    s4Phase : INT := 0;
    aCmd : DINT := 0;
    bCmd : DINT := 0;
    liftCmd : DINT := 40000;
    cCmd : DINT := 40000;
    dCmd : DINT := 40000;
    s30Cmd : DINT := -6500;
    s31Cmd : DINT := 0;
    s32Cmd : DINT := 6500;
    s33Cmd : DINT := 0;
    s40Cmd : DINT := -65000;
    s41Cmd : DINT := 65000;
    s42Cmd : DINT := 0;
    portCmd : DINT := 0;
    atA : BOOL := FALSE;
    atB0 : BOOL := FALSE;
    atB180 : BOOL := FALSE;
    liftDocked : BOOL := FALSE;
    liftInitial : BOOL := FALSE;
    s3Home : BOOL := FALSE;
    s4Home : BOOL := FALSE;
    m3AtGoal : BOOL := FALSE;
    m4AtGoal : BOOL := FALSE;
    finalHome : BOOL := FALSE;
    m3g0 : DINT := 0;
    m3g1 : DINT := 0;
    m3g2 : DINT := 0;
    m3g3 : DINT := 0;
    m4g0 : DINT := 0;
    m4g1 : DINT := 0;
    m4g2 : DINT := 0;
    safeZ : DINT := 22000;
    gapRaw : DINT := 0;
    minLift : DINT := 0;
    maxLift : DINT := 0;
END_VAR

m3g0 := D500;
IF m3g0 < -9000 THEN m3g0 := -9000; END_IF;
IF m3g0 > 9000 THEN m3g0 := 9000; END_IF;
m3g1 := D501;
IF m3g1 < 0 THEN m3g1 := 0; END_IF;
IF m3g1 > 65000 THEN m3g1 := 65000; END_IF;
m3g2 := D502;
IF m3g2 < -9000 THEN m3g2 := -9000; END_IF;
IF m3g2 > 9000 THEN m3g2 := 9000; END_IF;
m3g3 := D503;
IF m3g3 < 0 THEN m3g3 := 0; END_IF;
IF m3g3 > 65000 THEN m3g3 := 65000; END_IF;

m4g0 := D600;
IF m4g0 < -90000 THEN m4g0 := -90000; END_IF;
IF m4g0 > 90000 THEN m4g0 := 90000; END_IF;
m4g1 := D601;
IF m4g1 < -90000 THEN m4g1 := -90000; END_IF;
IF m4g1 > 90000 THEN m4g1 := 90000; END_IF;
m4g2 := D602;
IF m4g2 < 0 THEN m4g2 := 0; END_IF;
IF m4g2 > 35000 THEN m4g2 := 35000; END_IF;

aCmd := 0;
bCmd := 0;
liftCmd := 40000;
s30Cmd := -6500;
s31Cmd := 0;
s32Cmd := 6500;
s33Cmd := 0;
s40Cmd := -65000;
s41Cmd := 65000;
s42Cmd := 0;

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

IF curOrig = 2 THEN
    portCmd := D406;
ELSE
    portCmd := D403;
END_IF;

s3Home := (ABS(D1016 + 6500) <= 20) AND (ABS(D1017) <= 100) AND
          (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
          (ABS(D1024 - 6500) <= 20) AND (ABS(D1025) <= 100) AND
          (ABS(D1028) <= 20) AND (ABS(D1029) <= 100);

s4Home := (ABS(D1032 + 65000) <= 20) AND (ABS(D1033) <= 100) AND
          (ABS(D1036 - 65000) <= 20) AND (ABS(D1037) <= 100) AND
          (ABS(D1040) <= 20) AND (ABS(D1041) <= 100);

m3AtGoal := (ABS(D1016 - m3g0) <= 20) AND (ABS(D1017) <= 100) AND
            (ABS(D1020 - m3g1) <= 20) AND (ABS(D1021) <= 100) AND
            (ABS(D1024 - m3g2) <= 20) AND (ABS(D1025) <= 100) AND
            (ABS(D1028 - m3g3) <= 20) AND (ABS(D1029) <= 100);

m4AtGoal := (ABS(D1032 - m4g0) <= 20) AND (ABS(D1033) <= 100) AND
            (ABS(D1036 - m4g1) <= 20) AND (ABS(D1037) <= 100) AND
            (ABS(D1040 - m4g2) <= 20) AND (ABS(D1041) <= 100);

liftDocked := (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100) AND
              (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
liftInitial := (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
               (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100);

atB0 := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
atB180 := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);

CASE state OF
0:
    state := 5;

5:
    IF (NOT ack0Done) AND (D100 <> 0) THEN
        IF X31 THEN
            ack0Done := TRUE;
            ack0Id := D100;
            ack0Status := 2;
        ELSE
            curSlot := 0;
            curId := D100;
            IF D101 = 2 THEN curOrig := 2; ELSE curOrig := 1; END_IF;
            curStatus := 1;
            state := 10;
        END_IF;
    ELSIF (NOT ack1Done) AND (D120 <> 0) THEN
        IF X35 THEN
            ack1Done := TRUE;
            ack1Id := D120;
            ack1Status := 2;
        ELSE
            curSlot := 1;
            curId := D120;
            IF D121 = 2 THEN curOrig := 2; ELSE curOrig := 1; END_IF;
            curStatus := 1;
            state := 10;
        END_IF;
    END_IF;

10:
    liftCmd := D92;
    aCmd := portCmd;
    IF curOrig = 2 THEN
        IF (ABS(D1000 - portCmd) <= 20) AND (ABS(D1001) <= 100) AND liftDocked AND atB0 AND s3Home AND s4Home AND X62 THEN
            state := 30;
        END_IF;
    ELSE
        IF (ABS(D1000 - portCmd) <= 20) AND (ABS(D1001) <= 100) AND liftDocked AND atB0 AND s3Home AND s4Home AND X61 THEN
            state := 30;
        END_IF;
    END_IF;

30:
    liftCmd := D92;
    aCmd := portCmd;
    bCmd := 18000;
    IF atB180 THEN
        connStarted := FALSE;
        state := 40;
    END_IF;

40:
    liftCmd := D92;
    aCmd := portCmd;
    bCmd := 18000;
    D80 := 1;
    D81 := curOrig;
    IF NOT connStarted THEN
        seq := seq + 1;
        connStarted := TRUE;
    END_IF;
    IF (D90 = curId) OR connTimer.Q THEN
        connStarted := FALSE;
        state := 50;
    END_IF;

50:
    liftCmd := D92;
    aCmd := portCmd;
    bCmd := 0;
    IF atB0 THEN
        state := 60;
    END_IF;

60:
    aCmd := D409;
    bCmd := 0;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND atB0 AND s3Home AND X63 THEN
        state := 70;
    END_IF;

70:
    aCmd := D409;
    bCmd := 18000;
    IF atB180 THEN
        connStarted := FALSE;
        state := 75;
    END_IF;

75:
    aCmd := D409;
    bCmd := 18000;
    D80 := 2;
    D81 := 3;
    IF NOT connStarted THEN
        seq := seq + 1;
        connStarted := TRUE;
    END_IF;
    IF (D90 <> curId) OR connTimer.Q THEN
        connStarted := FALSE;
        state := 78;
    END_IF;

78:
    aCmd := D409;
    bCmd := 0;
    IF atB0 THEN
        state := 80;
    END_IF;

80:
    aCmd := D409;
    bCmd := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D702 := 1000;
    IF (ABS(D1016 - m3g0) <= 20) AND (ABS(D1024 - m3g2) <= 20) THEN
        s30Cmd := m3g0;
        s31Cmd := m3g1;
        s32Cmd := m3g2;
        s33Cmd := m3g3;
    ELSE
        s30Cmd := m3g0;
        s31Cmd := 0;
        s32Cmd := m3g2;
        s33Cmd := 0;
    END_IF;
    IF X70 AND m3AtGoal THEN
        state := 90;
    END_IF;

90:
    aCmd := D409;
    bCmd := 0;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    s31Cmd := 0;
    s33Cmd := 0;
    IF (D1020 <= 8000) AND (D1028 <= 8000) THEN
        s30Cmd := -6500;
        s32Cmd := 6500;
    ELSE
        s30Cmd := D1016;
        s32Cmd := D1024;
    END_IF;
    IF s3Home AND X63 THEN
        state := 100;
    END_IF;

100:
    aCmd := D409;
    bCmd := 0;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND atB0 AND s3Home AND X63 THEN
        state := 105;
    END_IF;

105:
    aCmd := D409;
    bCmd := 18000;
    IF atB180 THEN
        connStarted := FALSE;
        state := 106;
    END_IF;

106:
    aCmd := D409;
    bCmd := 18000;
    D80 := 1;
    D81 := 3;
    IF NOT connStarted THEN
        seq := seq + 1;
        connStarted := TRUE;
    END_IF;
    IF (D90 = curId) OR connTimer.Q THEN
        connStarted := FALSE;
        state := 110;
    END_IF;

110:
    aCmd := D409;
    bCmd := 0;
    IF atB0 THEN
        state := 120;
    END_IF;

120:
    aCmd := D412;
    bCmd := 0;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND atB0 AND s4Home AND X64 THEN
        state := 130;
    END_IF;

130:
    aCmd := D412;
    bCmd := 18000;
    IF atB180 THEN
        connStarted := FALSE;
        state := 135;
    END_IF;

135:
    aCmd := D412;
    bCmd := 18000;
    D80 := 2;
    D81 := 4;
    IF NOT connStarted THEN
        seq := seq + 1;
        connStarted := TRUE;
    END_IF;
    IF (D90 <> curId) OR connTimer.Q THEN
        connStarted := FALSE;
        state := 138;
    END_IF;

138:
    aCmd := D412;
    bCmd := 0;
    IF atB0 THEN
        s4Phase := 0;
        state := 150;
    END_IF;

150:
    aCmd := D412;
    bCmd := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D712 := 1000;
    gapRaw := ABS(m4g0 - m4g1);
    safeZ := 22000;
    IF m4g2 > safeZ THEN safeZ := m4g2; END_IF;
    IF (gapRaw < 23000) AND (safeZ < 22000) THEN safeZ := 22000; END_IF;

    IF s4Phase = 0 THEN
        s40Cmd := -65000;
        s41Cmd := 65000;
        s42Cmd := safeZ;
        IF (ABS(D1040 - safeZ) <= 20) AND (ABS(D1041) <= 100) THEN
            s4Phase := 1;
        END_IF;
    ELSIF s4Phase = 1 THEN
        s40Cmd := m4g0;
        s41Cmd := m4g1;
        s42Cmd := safeZ;
        IF (ABS(D1032 - m4g0) <= 20) AND (ABS(D1033) <= 100) AND
           (ABS(D1036 - m4g1) <= 20) AND (ABS(D1037) <= 100) THEN
            s4Phase := 2;
        END_IF;
    ELSE
        s40Cmd := m4g0;
        s41Cmd := m4g1;
        s42Cmd := m4g2;
    END_IF;

    IF X75 AND m4AtGoal THEN
        s4Phase := 0;
        state := 160;
    END_IF;

160:
    aCmd := D412;
    bCmd := 0;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    gapRaw := ABS(D1032 - D1036);
    IF s4Phase = 0 THEN
        s40Cmd := D1032;
        s41Cmd := D1036;
        IF gapRaw < 23000 THEN
            s42Cmd := 22000;
            IF (ABS(D1040 - 22000) <= 20) AND (ABS(D1041) <= 100) THEN
                s4Phase := 1;
            END_IF;
        ELSE
            s42Cmd := D1040;
            s4Phase := 1;
        END_IF;
    ELSIF s4Phase = 1 THEN
        s40Cmd := -65000;
        s41Cmd := 65000;
        IF gapRaw < 23000 THEN
            s42Cmd := 22000;
        ELSE
            s42Cmd := D1040;
        END_IF;
        IF (ABS(D1032 + 65000) <= 20) AND (ABS(D1033) <= 100) AND
           (ABS(D1036 - 65000) <= 20) AND (ABS(D1037) <= 100) THEN
            s4Phase := 2;
        END_IF;
    ELSE
        s40Cmd := -65000;
        s41Cmd := 65000;
        s42Cmd := 0;
    END_IF;
    IF s4Home AND X64 THEN
        state := 170;
    END_IF;

170:
    aCmd := D412;
    bCmd := 0;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND atB0 AND s4Home AND X64 THEN
        state := 175;
    END_IF;

175:
    aCmd := D412;
    bCmd := 18000;
    IF atB180 THEN
        connStarted := FALSE;
        state := 176;
    END_IF;

176:
    aCmd := D412;
    bCmd := 18000;
    D80 := 1;
    D81 := 4;
    IF NOT connStarted THEN
        seq := seq + 1;
        connStarted := TRUE;
    END_IF;
    IF (D90 = curId) OR connTimer.Q THEN
        connStarted := FALSE;
        state := 180;
    END_IF;

180:
    aCmd := D412;
    bCmd := 0;
    IF atB0 THEN
        state := 185;
    END_IF;

185:
    liftCmd := D92;
    aCmd := portCmd;
    bCmd := 0;
    IF curOrig = 2 THEN
        IF (ABS(D1000 - portCmd) <= 20) AND (ABS(D1001) <= 100) AND liftDocked AND atB0 AND X62 THEN
            state := 190;
        END_IF;
    ELSE
        IF (ABS(D1000 - portCmd) <= 20) AND (ABS(D1001) <= 100) AND liftDocked AND atB0 AND X61 THEN
            state := 190;
        END_IF;
    END_IF;

190:
    liftCmd := D92;
    aCmd := portCmd;
    bCmd := 18000;
    IF atB180 THEN
        connStarted := FALSE;
        state := 195;
    END_IF;

195:
    liftCmd := D92;
    aCmd := portCmd;
    bCmd := 18000;
    D80 := 2;
    D81 := curOrig;
    IF NOT connStarted THEN
        seq := seq + 1;
        connStarted := TRUE;
    END_IF;
    IF (D90 <> curId) OR connTimer.Q THEN
        connStarted := FALSE;
        state := 200;
    END_IF;

200:
    liftCmd := 40000;
    aCmd := 0;
    bCmd := 0;
    IF liftInitial AND atB0 AND (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND s3Home AND s4Home THEN
        IF curSlot = 0 THEN
            ack0Done := TRUE;
            ack0Id := curId;
            ack0Status := curStatus;
        ELSE
            ack1Done := TRUE;
            ack1Id := curId;
            ack1Status := curStatus;
        END_IF;
        curId := 0;
        curSlot := 0;
        state := 5;
    END_IF;

ELSE
    state := 5;
END_CASE;

connTimer(IN := connStarted, PT := T#1000ms);

IF liftCmd < 0 THEN liftCmd := 0; END_IF;
IF liftCmd > 120000 THEN liftCmd := 120000; END_IF;

IF liftCmd > MAX(D1008, D1012) THEN
    minLift := MIN(D1008, D1012);
    cCmd := MIN(liftCmd, minLift + 2000);
    dCmd := cCmd;
ELSIF liftCmd < MIN(D1008, D1012) THEN
    maxLift := MAX(D1008, D1012);
    cCmd := MAX(liftCmd, maxLift - 2000);
    dCmd := cCmd;
ELSE
    cCmd := liftCmd;
    dCmd := liftCmd;
END_IF;

IF aCmd < -450000 THEN aCmd := -450000; END_IF;
IF aCmd > 730000 THEN aCmd := 730000; END_IF;
IF bCmd < 0 THEN bCmd := 0; END_IF;
IF bCmd > 18000 THEN bCmd := 18000; END_IF;
IF cCmd < 0 THEN cCmd := 0; END_IF;
IF cCmd > 120000 THEN cCmd := 120000; END_IF;
IF dCmd < 0 THEN dCmd := 0; END_IF;
IF dCmd > 120000 THEN dCmd := 120000; END_IF;
IF s30Cmd < -9000 THEN s30Cmd := -9000; END_IF;
IF s30Cmd > 9000 THEN s30Cmd := 9000; END_IF;
IF s31Cmd < 0 THEN s31Cmd := 0; END_IF;
IF s31Cmd > 65000 THEN s31Cmd := 65000; END_IF;
IF s32Cmd < -9000 THEN s32Cmd := -9000; END_IF;
IF s32Cmd > 9000 THEN s32Cmd := 9000; END_IF;
IF s33Cmd < 0 THEN s33Cmd := 0; END_IF;
IF s33Cmd > 65000 THEN s33Cmd := 65000; END_IF;
IF s40Cmd < -90000 THEN s40Cmd := -90000; END_IF;
IF s40Cmd > 90000 THEN s40Cmd := 90000; END_IF;
IF s41Cmd < -90000 THEN s41Cmd := -90000; END_IF;
IF s41Cmd > 90000 THEN s41Cmd := 90000; END_IF;
IF s42Cmd < 0 THEN s42Cmd := 0; END_IF;
IF s42Cmd > 35000 THEN s42Cmd := 35000; END_IF;

D2000 := aCmd;
D2001 := 900;
D2002 := 0;
Y40 := TRUE;
D2004 := bCmd;
D2005 := 800;
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
D2017 := 850;
D2018 := 0;
Y44 := TRUE;
D2020 := s31Cmd;
D2021 := 800;
D2022 := 0;
Y45 := TRUE;
D2024 := s32Cmd;
D2025 := 850;
D2026 := 0;
Y46 := TRUE;
D2028 := s33Cmd;
D2029 := 800;
D2030 := 0;
Y47 := TRUE;

D2032 := s40Cmd;
D2033 := 800;
D2034 := 0;
Y48 := TRUE;
D2036 := s41Cmd;
D2037 := 800;
D2038 := 0;
Y49 := TRUE;
D2040 := s42Cmd;
D2041 := 850;
D2042 := 0;
Y50 := TRUE;

D82 := seq;
Y30 := FALSE;

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

finalHome := X51 AND (state = 5) AND atB0 AND liftInitial AND s3Home AND s4Home AND
             (ABS(D1000) <= 20) AND (ABS(D1001) <= 100);

doneTimer(IN := finalHome, PT := T#100ms);
IF doneTimer.Q THEN
    finalDeclared := TRUE;
END_IF;

Y2 := finalDeclared AND finalHome;

END_PROGRAM