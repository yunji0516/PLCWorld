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
    D603 : DINT;
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
    state : INT := 0;
    prevState : INT := -1;
    seqCounter : DINT := 0;
    seqIssued : BOOL := FALSE;
    r0Done : BOOL := FALSE;
    r1Done : BOOL := FALSE;
    lastR0 : DINT := 0;
    lastR1 : DINT := 0;
    curIndex : INT := -1;
    curId : DINT := 0;
    curOrigin : INT := 1;
    curStatus : DINT := 1;
    cancelMode : BOOL := FALSE;
    loc : INT := 0;
    stateChanged : BOOL;
    curCancelled : BOOL;
    aAt : BOOL;
    bRetracted : BOOL;
    bExtended : BOOL;
    cDock : BOOL;
    dDock : BOOL;
    cHome : BOOL;
    dHome : BOOL;
    s3Home : BOOL;
    s4Home : BOOL;
    finalHome : BOOL;
    finalTimer : TON;
    targetA : DINT;
    targetLift : DINT;
    targetS3_0 : DINT;
    targetS3_1 : DINT;
    targetS4_0 : DINT;
    targetS4_1 : DINT;
    targetS4_2 : DINT;
    targetS4_3 : DINT;
END_VAR

IF D100 <> lastR0 THEN
    lastR0 := D100;
    r0Done := FALSE;
    IF D100 = 0 THEN
        D300 := 0;
        D301 := 0;
    END_IF;
END_IF;

IF D120 <> lastR1 THEN
    lastR1 := D120;
    r1Done := FALSE;
    IF D120 = 0 THEN
        D302 := 0;
        D303 := 0;
    END_IF;
END_IF;

D2000 := 0;
D2001 := 700;
D2002 := 0;
Y40 := TRUE;
D2004 := 0;
D2005 := 800;
D2006 := 0;
Y41 := TRUE;
D2008 := 15000;
D2009 := 800;
D2010 := 0;
Y42 := TRUE;
D2012 := 15000;
D2013 := 800;
D2014 := 0;
Y43 := TRUE;
D2016 := 0;
D2017 := 900;
D2018 := 0;
Y44 := TRUE;
D2020 := 5000;
D2021 := 800;
D2022 := 0;
Y45 := TRUE;
D2024 := -6500;
D2025 := 900;
D2026 := 0;
Y46 := TRUE;
D2028 := 0;
D2029 := 800;
D2030 := 0;
Y47 := TRUE;
D2032 := 6500;
D2033 := 900;
D2034 := 0;
Y48 := TRUE;
D2036 := 0;
D2037 := 800;
D2038 := 0;
Y49 := TRUE;
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
D80 := 0;
D81 := 0;
D82 := seqCounter;
Y30 := FALSE;

targetS3_0 := D500;
IF targetS3_0 < 0 THEN targetS3_0 := 0; END_IF;
IF targetS3_0 > 27000 THEN targetS3_0 := 27000; END_IF;
targetS3_1 := D501;
IF targetS3_1 < 0 THEN targetS3_1 := 0; END_IF;
IF targetS3_1 > 74000 THEN targetS3_1 := 74000; END_IF;

targetS4_0 := D600;
IF targetS4_0 < -9000 THEN targetS4_0 := -9000; END_IF;
IF targetS4_0 > 9000 THEN targetS4_0 := 9000; END_IF;
targetS4_1 := D601;
IF targetS4_1 < 0 THEN targetS4_1 := 0; END_IF;
IF targetS4_1 > 65000 THEN targetS4_1 := 65000; END_IF;
targetS4_2 := D602;
IF targetS4_2 < -9000 THEN targetS4_2 := -9000; END_IF;
IF targetS4_2 > 9000 THEN targetS4_2 := 9000; END_IF;
targetS4_3 := D603;
IF targetS4_3 < 0 THEN targetS4_3 := 0; END_IF;
IF targetS4_3 > 65000 THEN targetS4_3 := 65000; END_IF;

IF D92 < 0 THEN
    targetLift := 0;
ELSIF D92 > 120000 THEN
    targetLift := 120000;
ELSE
    targetLift := D92;
END_IF;

bRetracted := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
bExtended := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
cDock := (ABS(D1008 - targetLift) <= 20) AND (ABS(D1009) <= 100);
dDock := (ABS(D1012 - targetLift) <= 20) AND (ABS(D1013) <= 100);
cHome := (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100);
dHome := (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100);
s3Home := (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - 5000) <= 20) AND (ABS(D1021) <= 100);
s4Home := (ABS(D1024 + 6500) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - 6500) <= 20) AND (ABS(D1033) <= 100) AND (ABS(D1036) <= 20) AND (ABS(D1037) <= 100);

stateChanged := state <> prevState;
IF stateChanged THEN
    seqIssued := FALSE;
    prevState := state;
END_IF;

IF state = 0 THEN
    curId := 0;
    curIndex := -1;
    cancelMode := FALSE;
    curStatus := 1;
    loc := 0;
    IF (D100 <> 0) AND NOT r0Done THEN
        curIndex := 0;
        curId := D100;
        IF D101 = 2 THEN curOrigin := 2; ELSE curOrigin := 1; END_IF;
        cancelMode := X31;
        IF cancelMode THEN curStatus := 2; ELSE curStatus := 1; END_IF;
        loc := 1;
        state := 100;
    ELSIF (D120 <> 0) AND NOT r1Done THEN
        curIndex := 1;
        curId := D120;
        IF D121 = 2 THEN curOrigin := 2; ELSE curOrigin := 1; END_IF;
        cancelMode := X35;
        IF cancelMode THEN curStatus := 2; ELSE curStatus := 1; END_IF;
        loc := 1;
        state := 100;
    END_IF;
END_IF;

curCancelled := FALSE;
IF curIndex = 0 THEN
    curCancelled := X31;
ELSIF curIndex = 1 THEN
    curCancelled := X35;
END_IF;

IF (curId <> 0) AND curCancelled THEN
    cancelMode := TRUE;
    curStatus := 2;
END_IF;

IF (curId <> 0) AND cancelMode THEN
    IF (state = 100) AND (D90 <> curId) THEN
        state := 420;
    ELSIF ((state = 200) OR (state = 300)) AND (D90 = curId) THEN
        state := 400;
    ELSIF (state >= 230) AND (state <= 233) THEN
        state := 240;
    ELSIF (state >= 330) AND (state <= 333) THEN
        state := 340;
    END_IF;
END_IF;

CASE state OF
0:
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := 0;
    D2020 := 5000;
    D2024 := -6500;
    D2028 := 0;
    D2032 := 6500;
    D2036 := 0;

100:
    IF curOrigin = 2 THEN
        targetA := D406;
        D2012 := targetLift;
        D2008 := 15000;
        aAt := (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100);
        D2000 := targetA;
        D2004 := 0;
        IF cancelMode THEN
            state := 420;
        ELSIF aAt AND bRetracted AND dDock AND X62 THEN
            state := 110;
        END_IF;
    ELSE
        targetA := D403;
        D2008 := targetLift;
        D2012 := 15000;
        aAt := (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100);
        D2000 := targetA;
        D2004 := 0;
        IF cancelMode THEN
            state := 420;
        ELSIF aAt AND bRetracted AND cDock AND X61 THEN
            state := 110;
        END_IF;
    END_IF;

110:
    IF curOrigin = 2 THEN
        targetA := D406;
        D2012 := targetLift;
    ELSE
        targetA := D403;
        D2008 := targetLift;
    END_IF;
    D2000 := targetA;
    D2004 := 18000;
    aAt := (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100);
    IF aAt AND bExtended AND (((curOrigin = 1) AND X61) OR ((curOrigin = 2) AND X62)) THEN
        IF NOT seqIssued THEN
            seqCounter := seqCounter + 1;
            seqIssued := TRUE;
        END_IF;
        D80 := 1;
        D81 := curOrigin;
        D82 := seqCounter;
        IF D90 = curId THEN
            loc := 0;
            state := 120;
        END_IF;
    END_IF;

120:
    D2004 := 0;
    IF curOrigin = 1 THEN D2008 := 15000; ELSE D2012 := 15000; END_IF;
    IF bRetracted THEN
        IF cancelMode THEN
            state := 400;
        ELSE
            state := 200;
        END_IF;
    END_IF;

200:
    D2004 := 0;
    D2016 := 0;
    D2020 := 5000;
    IF bRetracted THEN
        D2000 := D409;
        aAt := (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100);
        IF aAt AND s3Home AND X63 THEN
            state := 210;
        END_IF;
    ELSE
        D2000 := D1000;
    END_IF;

210:
    D2000 := D409;
    D2004 := 18000;
    D2016 := 0;
    D2020 := 5000;
    aAt := (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100);
    IF aAt AND bExtended AND s3Home AND X63 THEN
        IF NOT seqIssued THEN
            seqCounter := seqCounter + 1;
            seqIssued := TRUE;
        END_IF;
        D80 := 2;
        D81 := 3;
        D82 := seqCounter;
        IF D90 <> curId THEN
            loc := 3;
            state := 220;
        END_IF;
    END_IF;

220:
    D2000 := D409;
    D2004 := 0;
    D2016 := 0;
    D2020 := 5000;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D702 := 800;
    IF bRetracted THEN
        IF cancelMode THEN
            state := 240;
        ELSE
            state := 230;
        END_IF;
    END_IF;

230:
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D702 := 800;
    D2016 := 0;
    D2020 := 50000;
    IF (ABS(D1020 - 50000) <= 20) AND (ABS(D1021) <= 100) THEN
        state := 231;
    END_IF;

231:
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D702 := 800;
    D2016 := targetS3_0;
    D2020 := 50000;
    IF (ABS(D1016 - targetS3_0) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - 50000) <= 20) AND (ABS(D1021) <= 100) THEN
        state := 232;
    END_IF;

232:
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D702 := 800;
    D2016 := targetS3_0;
    D2020 := targetS3_1;
    IF X70 OR ((ABS(D1016 - targetS3_0) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - targetS3_1) <= 20) AND (ABS(D1021) <= 100)) THEN
        state := 233;
    END_IF;

233:
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D702 := 800;
    D2016 := targetS3_0;
    D2020 := targetS3_1;
    IF X70 THEN
        state := 240;
    END_IF;

240:
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D2016 := D1016;
    D2020 := 5000;
    IF (ABS(D1020 - 5000) <= 20) AND (ABS(D1021) <= 100) THEN
        state := 241;
    END_IF;

241:
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D2016 := 0;
    D2020 := 5000;
    IF s3Home THEN
        state := 250;
    END_IF;

250:
    D2000 := D409;
    D2004 := 18000;
    D2016 := 0;
    D2020 := 5000;
    aAt := (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100);
    IF aAt AND bExtended AND s3Home AND X63 THEN
        IF NOT seqIssued THEN
            seqCounter := seqCounter + 1;
            seqIssued := TRUE;
        END_IF;
        D80 := 1;
        D81 := 3;
        D82 := seqCounter;
        IF D90 = curId THEN
            loc := 0;
            state := 260;
        END_IF;
    END_IF;

260:
    D2000 := D409;
    D2004 := 0;
    D2016 := 0;
    D2020 := 5000;
    IF bRetracted THEN
        IF cancelMode THEN
            state := 400;
        ELSE
            state := 300;
        END_IF;
    END_IF;

300:
    D2004 := 0;
    D2024 := -6500;
    D2028 := 0;
    D2032 := 6500;
    D2036 := 0;
    IF bRetracted THEN
        D2000 := D412;
        aAt := (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100);
        IF aAt AND s4Home AND X64 THEN
            state := 310;
        END_IF;
    ELSE
        D2000 := D1000;
    END_IF;

310:
    D2000 := D412;
    D2004 := 18000;
    D2024 := -6500;
    D2028 := 0;
    D2032 := 6500;
    D2036 := 0;
    aAt := (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100);
    IF aAt AND bExtended AND s4Home AND X64 THEN
        IF NOT seqIssued THEN
            seqCounter := seqCounter + 1;
            seqIssued := TRUE;
        END_IF;
        D80 := 2;
        D81 := 4;
        D82 := seqCounter;
        IF D90 <> curId THEN
            loc := 4;
            state := 320;
        END_IF;
    END_IF;

320:
    D2000 := D412;
    D2004 := 0;
    D2024 := -6500;
    D2028 := 0;
    D2032 := 6500;
    D2036 := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D712 := 800;
    IF bRetracted THEN
        IF cancelMode THEN
            state := 340;
        ELSE
            state := 330;
        END_IF;
    END_IF;

330:
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D712 := 800;
    D2024 := -6500;
    D2028 := 0;
    D2032 := 6500;
    D2036 := 0;
    IF (D1028 <= 8020) AND (ABS(D1029) <= 100) AND (D1036 <= 8020) AND (ABS(D1037) <= 100) THEN
        state := 331;
    END_IF;

331:
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D712 := 800;
    D2024 := targetS4_0;
    D2028 := 0;
    D2032 := targetS4_2;
    D2036 := 0;
    IF (ABS(D1024 - targetS4_0) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1032 - targetS4_2) <= 20) AND (ABS(D1033) <= 100) THEN
        state := 332;
    END_IF;

332:
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D712 := 800;
    D2024 := targetS4_0;
    D2028 := targetS4_1;
    D2032 := targetS4_2;
    D2036 := targetS4_3;
    IF X75 OR ((ABS(D1024 - targetS4_0) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028 - targetS4_1) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - targetS4_2) <= 20) AND (ABS(D1033) <= 100) AND (ABS(D1036 - targetS4_3) <= 20) AND (ABS(D1037) <= 100)) THEN
        state := 333;
    END_IF;

333:
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D712 := 800;
    D2024 := targetS4_0;
    D2028 := targetS4_1;
    D2032 := targetS4_2;
    D2036 := targetS4_3;
    IF X75 THEN
        state := 340;
    END_IF;

340:
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D2024 := D1024;
    D2028 := 0;
    D2032 := D1032;
    D2036 := 0;
    IF (D1028 <= 8020) AND (ABS(D1029) <= 100) AND (D1036 <= 8020) AND (ABS(D1037) <= 100) THEN
        state := 341;
    END_IF;

341:
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D2024 := -6500;
    D2028 := 0;
    D2032 := 6500;
    D2036 := 0;
    IF s4Home THEN
        state := 350;
    END_IF;

350:
    D2000 := D412;
    D2004 := 18000;
    D2024 := -6500;
    D2028 := 0;
    D2032 := 6500;
    D2036 := 0;
    aAt := (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100);
    IF aAt AND bExtended AND s4Home AND X64 THEN
        IF NOT seqIssued THEN
            seqCounter := seqCounter + 1;
            seqIssued := TRUE;
        END_IF;
        D80 := 1;
        D81 := 4;
        D82 := seqCounter;
        IF D90 = curId THEN
            loc := 0;
            state := 360;
        END_IF;
    END_IF;

360:
    D2000 := D412;
    D2004 := 0;
    D2024 := -6500;
    D2028 := 0;
    D2032 := 6500;
    D2036 := 0;
    IF bRetracted THEN
        state := 400;
    END_IF;

400:
    D2004 := 0;
    IF curOrigin = 2 THEN
        targetA := D406;
        D2012 := targetLift;
        D2008 := 15000;
        D2000 := targetA;
        aAt := (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100);
        IF aAt AND bRetracted AND dDock AND X62 THEN
            state := 410;
        END_IF;
    ELSE
        targetA := D403;
        D2008 := targetLift;
        D2012 := 15000;
        D2000 := targetA;
        aAt := (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100);
        IF aAt AND bRetracted AND cDock AND X61 THEN
            state := 410;
        END_IF;
    END_IF;

410:
    IF curOrigin = 2 THEN
        targetA := D406;
        D2012 := targetLift;
    ELSE
        targetA := D403;
        D2008 := targetLift;
    END_IF;
    D2000 := targetA;
    D2004 := 18000;
    aAt := (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100);
    IF aAt AND bExtended AND (((curOrigin = 1) AND X61) OR ((curOrigin = 2) AND X62)) THEN
        IF NOT seqIssued THEN
            seqCounter := seqCounter + 1;
            seqIssued := TRUE;
        END_IF;
        D80 := 2;
        D81 := curOrigin;
        D82 := seqCounter;
        IF D90 <> curId THEN
            loc := 1;
            state := 420;
        END_IF;
    END_IF;

420:
    D2004 := 0;
    IF curOrigin = 2 THEN
        D2012 := 15000;
        D2008 := 15000;
        IF bRetracted AND dHome THEN
            state := 430;
        END_IF;
    ELSE
        D2008 := 15000;
        D2012 := 15000;
        IF bRetracted AND cHome THEN
            state := 430;
        END_IF;
    END_IF;

430:
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    IF curIndex = 0 THEN
        D300 := curId;
        D301 := curStatus;
        r0Done := TRUE;
    ELSIF curIndex = 1 THEN
        D302 := curId;
        D303 := curStatus;
        r1Done := TRUE;
    END_IF;
    curId := 0;
    curIndex := -1;
    cancelMode := FALSE;
    state := 0;

ELSE
    state := 0;
END_CASE;

IF D2000 < -450000 THEN D2000 := -450000; END_IF;
IF D2000 > 730000 THEN D2000 := 730000; END_IF;
IF D2004 < 0 THEN D2004 := 0; END_IF;
IF D2004 > 18000 THEN D2004 := 18000; END_IF;
IF D2008 < 0 THEN D2008 := 0; END_IF;
IF D2008 > 120000 THEN D2008 := 120000; END_IF;
IF D2012 < 0 THEN D2012 := 0; END_IF;
IF D2012 > 120000 THEN D2012 := 120000; END_IF;
IF D2016 < 0 THEN D2016 := 0; END_IF;
IF D2016 > 27000 THEN D2016 := 27000; END_IF;
IF D2020 < 0 THEN D2020 := 0; END_IF;
IF D2020 > 74000 THEN D2020 := 74000; END_IF;
IF D2024 < -9000 THEN D2024 := -9000; END_IF;
IF D2024 > 9000 THEN D2024 := 9000; END_IF;
IF D2028 < 0 THEN D2028 := 0; END_IF;
IF D2028 > 65000 THEN D2028 := 65000; END_IF;
IF D2032 < -9000 THEN D2032 := -9000; END_IF;
IF D2032 > 9000 THEN D2032 := 9000; END_IF;
IF D2036 < 0 THEN D2036 := 0; END_IF;
IF D2036 > 65000 THEN D2036 := 65000; END_IF;

IF D2001 < 0 THEN D2001 := 0; END_IF;
IF D2001 > 1000 THEN D2001 := 1000; END_IF;
IF D2005 < 0 THEN D2005 := 0; END_IF;
IF D2005 > 1000 THEN D2005 := 1000; END_IF;
IF D2009 < 0 THEN D2009 := 0; END_IF;
IF D2009 > 1000 THEN D2009 := 1000; END_IF;
IF D2013 < 0 THEN D2013 := 0; END_IF;
IF D2013 > 1000 THEN D2013 := 1000; END_IF;
IF D2017 < 0 THEN D2017 := 0; END_IF;
IF D2017 > 1000 THEN D2017 := 1000; END_IF;
IF D2021 < 0 THEN D2021 := 0; END_IF;
IF D2021 > 1000 THEN D2021 := 1000; END_IF;
IF D2025 < 0 THEN D2025 := 0; END_IF;
IF D2025 > 1000 THEN D2025 := 1000; END_IF;
IF D2029 < 0 THEN D2029 := 0; END_IF;
IF D2029 > 1000 THEN D2029 := 1000; END_IF;
IF D2033 < 0 THEN D2033 := 0; END_IF;
IF D2033 > 1000 THEN D2033 := 1000; END_IF;
IF D2037 < 0 THEN D2037 := 0; END_IF;
IF D2037 > 1000 THEN D2037 := 1000; END_IF;

finalHome := X51 AND (state = 0) AND (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND cHome AND dHome AND s3Home AND s4Home;
finalTimer(IN := finalHome, PT := T#100ms);
Y2 := finalTimer.Q;

IF Y2 THEN
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := 0;
    D2020 := 5000;
    D2024 := -6500;
    D2028 := 0;
    D2032 := 6500;
    D2036 := 0;
END_IF;

END_PROGRAM