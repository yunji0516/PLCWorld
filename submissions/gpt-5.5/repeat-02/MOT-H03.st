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
    state : INT := 0;
    prevState : INT := -1;
    scanState : INT := 0;
    stateEntry : BOOL := FALSE;
    processIndex : INT := 0;
    curId : DINT := 0;
    curStatus : DINT := 1;
    sourceStation : DINT := 1;
    seqCounter : DINT := 0;
    done0 : BOOL := FALSE;
    done1 : BOOL := FALSE;
    ackId0 : DINT := 0;
    ackId1 : DINT := 0;
    statusMem0 : DINT := 0;
    statusMem1 : DINT := 0;
    completedLatch : BOOL := FALSE;
    cmdA : DINT := 0;
    cmdB : DINT := 0;
    cmdC : DINT := 15000;
    cmdD : DINT := 15000;
    cmdS30 : DINT := -50000;
    cmdS31 : DINT := -50000;
    cmdS32 : DINT := 0;
    cmdS40 : DINT := 0;
    cmdS41 : DINT := 0;
    cmdAFF : DINT := 0;
    cmdBFF : DINT := 0;
    cmdCFF : DINT := 0;
    cmdDFF : DINT := 0;
    cmdS30FF : DINT := 0;
    cmdS31FF : DINT := 0;
    cmdS32FF : DINT := 0;
    cmdS40FF : DINT := 0;
    cmdS41FF : DINT := 0;
    sourceX : DINT := 0;
    sourceReady : BOOL := FALSE;
    sourceLiftReady : BOOL := FALSE;
    sourceReturned : BOOL := FALSE;
    g3_0 : DINT := 0;
    g3_1 : DINT := 0;
    g3_2 : DINT := 0;
    g4_0 : DINT := 0;
    g4_1 : DINT := 0;
    g4_select : DINT := 1000;
    syncStartA : DINT := 0;
    cell3AtGoals : BOOL := FALSE;
    cell4AtGoals : BOOL := FALSE;
    sync3Ok : BOOL := FALSE;
    gearSyncOk : BOOL := FALSE;
    finalStable : BOOL := FALSE;
    gearErrRaw : REAL := 0.0;
    gearSpdErrRaw : REAL := 0.0;
    tCell3Sync : TON;
    tCell3Result : TON;
    tGearSync : TON;
    tGearResult : TON;
    tFinal : TON;
END_VAR

scanState := state;
stateEntry := scanState <> prevState;

g3_0 := D500;
IF g3_0 < -95000 THEN
    g3_0 := -95000;
ELSIF g3_0 > 95000 THEN
    g3_0 := 95000;
END_IF;

g3_1 := D501;
IF g3_1 < -95000 THEN
    g3_1 := -95000;
ELSIF g3_1 > 95000 THEN
    g3_1 := 95000;
END_IF;

g3_2 := D502;
IF g3_2 < 0 THEN
    g3_2 := 0;
ELSIF g3_2 > 18000 THEN
    g3_2 := 18000;
END_IF;

g4_0 := D600;
IF g4_0 < -360000 THEN
    g4_0 := -360000;
ELSIF g4_0 > 360000 THEN
    g4_0 := 360000;
END_IF;

g4_1 := D601;
IF g4_1 < -360000 THEN
    g4_1 := -360000;
ELSIF g4_1 > 360000 THEN
    g4_1 := 360000;
END_IF;

IF D600 <> 0 THEN
    g4_select := (D601 * 1000) / D600;
ELSE
    g4_select := 1000;
END_IF;
IF g4_select < -20000 THEN
    g4_select := -20000;
ELSIF g4_select > 20000 THEN
    g4_select := 20000;
END_IF;

IF sourceStation = 2 THEN
    sourceX := D406;
    sourceReady := X62;
    sourceLiftReady := (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
    sourceReturned := X34;
ELSE
    sourceX := D403;
    sourceReady := X61;
    sourceLiftReady := (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
    sourceReturned := X30;
END_IF;

cell3AtGoals := (ABS(D1016 - g3_0) <= 20) AND (ABS(D1017) <= 100) AND
                (ABS(D1020 - g3_1) <= 20) AND (ABS(D1021) <= 100) AND
                (ABS(D1024 - g3_2) <= 20) AND (ABS(D1025) <= 100);

cell4AtGoals := (ABS(D1028 - g4_0) <= 20) AND (ABS(D1029) <= 100) AND
                (ABS(D1032 - g4_1) <= 20) AND (ABS(D1033) <= 100);

sync3Ok := (state = 52) AND (ABS(D1000 - D409) <= 20) AND
           (ABS(D1001 - D1017) <= 100) AND (ABS(D1001) > 100);

gearErrRaw := ABS(REAL(D1032) - ((REAL(D1028) * REAL(g4_select)) / 1000.0));
gearSpdErrRaw := ABS(REAL(D1033) - ((REAL(D1029) * REAL(g4_select)) / 1000.0));
gearSyncOk := (state = 90) AND (ABS(D1029) > 100) AND (gearErrRaw <= 20.0) AND (gearSpdErrRaw <= 100.0);

finalStable := (state = 200) AND X51 AND
               (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
               (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
               (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
               (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND
               (ABS(D1016 + 50000) <= 20) AND (ABS(D1017) <= 100) AND
               (ABS(D1020 + 50000) <= 20) AND (ABS(D1021) <= 100) AND
               (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
               (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
               (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);

tCell3Sync(IN := sync3Ok, PT := T#50ms);
tCell3Result(IN := (state = 62) AND cell3AtGoals, PT := T#100ms);
tGearSync(IN := gearSyncOk, PT := T#50ms);
tGearResult(IN := (state = 90) AND cell4AtGoals, PT := T#100ms);
tFinal(IN := finalStable, PT := T#100ms);

cmdA := 0;
cmdB := 0;
cmdC := 15000;
cmdD := 15000;
cmdS30 := -50000;
cmdS31 := -50000;
cmdS32 := 0;
cmdS40 := 0;
cmdS41 := 0;
cmdAFF := 0;
cmdBFF := 0;
cmdCFF := 0;
cmdDFF := 0;
cmdS30FF := 0;
cmdS31FF := 0;
cmdS32FF := 0;
cmdS40FF := 0;
cmdS41FF := 0;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;

D2001 := 1000;
D2005 := 800;
D2009 := 1000;
D2013 := 1000;
D2017 := 1000;
D2021 := 1000;
D2025 := 1000;
D2029 := 1000;
D2033 := 1000;

Y70 := FALSE;
Y71 := FALSE;
D700 := 1000;
D701 := D526;
D702 := 1000;
Y75 := FALSE;
Y76 := FALSE;
D710 := g4_select;
D711 := D626;
D712 := 1000;

D80 := 0;
D81 := 0;
Y30 := FALSE;

IF done0 THEN
    D300 := ackId0;
    D301 := statusMem0;
ELSE
    D300 := 0;
    D301 := 0;
END_IF;

IF done1 THEN
    D302 := ackId1;
    D303 := statusMem1;
ELSE
    D302 := 0;
    D303 := 0;
END_IF;

CASE state OF
0:
    state := 10;

10:
    IF (processIndex = 0) AND (NOT done0) AND (D100 <> 0) THEN
        curId := D100;
        ackId0 := D100;
        IF D101 = 2 THEN
            sourceStation := 2;
        ELSE
            sourceStation := 1;
        END_IF;
        IF X31 THEN
            curStatus := 2;
        ELSE
            curStatus := 1;
        END_IF;
        state := 20;
    ELSIF (processIndex = 1) AND (NOT done1) AND (D120 <> 0) THEN
        curId := D120;
        ackId1 := D120;
        IF D121 = 2 THEN
            sourceStation := 2;
        ELSE
            sourceStation := 1;
        END_IF;
        IF X35 THEN
            curStatus := 2;
        ELSE
            curStatus := 1;
        END_IF;
        state := 20;
    ELSIF (processIndex >= 2) OR (done0 AND done1) THEN
        state := 200;
    END_IF;

20:
    cmdA := sourceX;
    cmdB := 0;
    IF sourceStation = 2 THEN
        cmdD := D92;
    ELSE
        cmdC := D92;
    END_IF;
    IF sourceReady AND sourceLiftReady AND (ABS(D1000 - sourceX) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 30;
    END_IF;

30:
    cmdA := sourceX;
    cmdB := 18000;
    IF sourceStation = 2 THEN
        cmdD := D92;
    ELSE
        cmdC := D92;
    END_IF;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND sourceReady AND
       (ABS(D1000 - sourceX) <= 20) AND (ABS(D1001) <= 100) THEN
        state := 32;
    END_IF;

32:
    cmdA := sourceX;
    cmdB := 18000;
    IF sourceStation = 2 THEN
        cmdD := D92;
    ELSE
        cmdC := D92;
    END_IF;
    IF stateEntry THEN
        seqCounter := seqCounter + 1;
    END_IF;
    D80 := 1;
    D81 := sourceStation;
    IF D90 = curId THEN
        state := 34;
    END_IF;

34:
    cmdA := sourceX;
    cmdB := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF curStatus = 2 THEN
            state := 120;
        ELSE
            state := 40;
        END_IF;
    END_IF;

40:
    cmdA := D409;
    cmdB := 0;
    IF X63 AND (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 50;
    END_IF;

50:
    cmdA := D409;
    cmdB := 18000;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) THEN
        state := 52;
    END_IF;

52:
    IF stateEntry THEN
        syncStartA := D1000;
    END_IF;
    cmdA := D409;
    cmdAFF := D1017;
    cmdB := 18000;
    cmdS30 := -25000;
    cmdS31 := -50000;
    cmdS32 := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := 1000;
    D701 := D526;
    D702 := 1000;
    IF tCell3Sync.Q AND (ABS(D1000 - syncStartA) >= 20000) THEN
        state := 54;
    END_IF;

54:
    cmdA := D409;
    cmdB := 18000;
    cmdS30 := -25000;
    cmdS31 := -50000;
    cmdS32 := 0;
    IF stateEntry THEN
        seqCounter := seqCounter + 1;
    END_IF;
    D80 := 2;
    D81 := 3;
    IF D90 <> curId THEN
        state := 56;
    END_IF;

56:
    cmdA := D409;
    cmdB := 0;
    cmdS30 := -25000;
    cmdS31 := -50000;
    cmdS32 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 60;
    END_IF;

60:
    cmdA := D409;
    cmdB := 0;
    cmdS30 := g3_0;
    cmdS31 := g3_1;
    cmdS32 := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := 1000;
    D701 := D526;
    D702 := 1000;
    IF (ABS(D1016 - g3_0) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020 - g3_1) <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) THEN
        state := 62;
    END_IF;

62:
    cmdA := D409;
    cmdB := 0;
    cmdS30 := g3_0;
    cmdS31 := g3_1;
    cmdS32 := g3_2;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := 1000;
    D701 := D526;
    D702 := 1000;
    IF X70 OR tCell3Result.Q THEN
        state := 64;
    END_IF;

64:
    cmdA := D409;
    cmdB := 0;
    cmdS30 := g3_0;
    cmdS31 := g3_1;
    cmdS32 := 0;
    Y71 := TRUE;
    IF (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
       (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) THEN
        state := 66;
    END_IF;

66:
    cmdA := D409;
    cmdB := 18000;
    cmdS30 := g3_0;
    cmdS31 := g3_1;
    cmdS32 := 0;
    Y71 := TRUE;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 68;
    END_IF;

68:
    cmdA := D409;
    cmdB := 18000;
    cmdS30 := g3_0;
    cmdS31 := g3_1;
    cmdS32 := 0;
    Y71 := TRUE;
    IF stateEntry THEN
        seqCounter := seqCounter + 1;
    END_IF;
    D80 := 1;
    D81 := 3;
    IF D90 = curId THEN
        state := 70;
    END_IF;

70:
    cmdA := D409;
    cmdB := 0;
    cmdS30 := -50000;
    cmdS31 := -50000;
    cmdS32 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 80;
    END_IF;

80:
    cmdA := D412;
    cmdB := 0;
    IF X64 AND (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 82;
    END_IF;

82:
    cmdA := D412;
    cmdB := 18000;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) THEN
        state := 84;
    END_IF;

84:
    cmdA := D412;
    cmdB := 18000;
    IF stateEntry THEN
        seqCounter := seqCounter + 1;
    END_IF;
    D80 := 2;
    D81 := 4;
    IF D90 <> curId THEN
        state := 86;
    END_IF;

86:
    cmdA := D412;
    cmdB := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 90;
    END_IF;

90:
    cmdA := D412;
    cmdB := 0;
    cmdS40 := g4_0;
    cmdS41 := g4_1;
    cmdS41FF := DINT((REAL(D1029) * REAL(g4_select)) / 1000.0);
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := g4_select;
    D711 := D626;
    D712 := 1000;
    IF tGearSync.Q AND (X75 OR tGearResult.Q) THEN
        state := 92;
    END_IF;

92:
    cmdA := D412;
    cmdB := 0;
    cmdS40 := g4_0;
    cmdS41 := g4_1;
    Y76 := TRUE;
    IF X64 AND (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 94;
    END_IF;

94:
    cmdA := D412;
    cmdB := 18000;
    cmdS40 := g4_0;
    cmdS41 := g4_1;
    Y76 := TRUE;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 96;
    END_IF;

96:
    cmdA := D412;
    cmdB := 18000;
    cmdS40 := g4_0;
    cmdS41 := g4_1;
    Y76 := TRUE;
    IF stateEntry THEN
        seqCounter := seqCounter + 1;
    END_IF;
    D80 := 1;
    D81 := 4;
    IF D90 = curId THEN
        state := 98;
    END_IF;

98:
    cmdA := D412;
    cmdB := 0;
    cmdS40 := 0;
    cmdS41 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 120;
    END_IF;

120:
    cmdA := sourceX;
    cmdB := 0;
    cmdS40 := 0;
    cmdS41 := 0;
    IF sourceStation = 2 THEN
        cmdD := D92;
    ELSE
        cmdC := D92;
    END_IF;
    IF sourceReady AND sourceLiftReady AND (ABS(D1000 - sourceX) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 122;
    END_IF;

122:
    cmdA := sourceX;
    cmdB := 18000;
    IF sourceStation = 2 THEN
        cmdD := D92;
    ELSE
        cmdC := D92;
    END_IF;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1000 - sourceX) <= 20) AND (ABS(D1001) <= 100) THEN
        state := 124;
    END_IF;

124:
    cmdA := sourceX;
    cmdB := 18000;
    IF sourceStation = 2 THEN
        cmdD := D92;
    ELSE
        cmdC := D92;
    END_IF;
    IF stateEntry THEN
        seqCounter := seqCounter + 1;
    END_IF;
    D80 := 2;
    D81 := sourceStation;
    IF (D90 <> curId) OR sourceReturned THEN
        state := 126;
    END_IF;

126:
    cmdA := sourceX;
    cmdB := 0;
    cmdC := 15000;
    cmdD := 15000;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) THEN
        IF processIndex = 0 THEN
            done0 := TRUE;
            statusMem0 := curStatus;
            processIndex := 1;
        ELSE
            done1 := TRUE;
            statusMem1 := curStatus;
            processIndex := 2;
        END_IF;
        state := 10;
    END_IF;

200:
    cmdA := 0;
    cmdB := 0;
    cmdC := 15000;
    cmdD := 15000;
    cmdS30 := -50000;
    cmdS31 := -50000;
    cmdS32 := 0;
    cmdS40 := 0;
    cmdS41 := 0;
    Y30 := TRUE;
    IF tFinal.Q THEN
        completedLatch := TRUE;
    END_IF;

ELSE
    state := 10;
END_CASE;

IF cmdA < -450000 THEN
    cmdA := -450000;
ELSIF cmdA > 1130000 THEN
    cmdA := 1130000;
END_IF;
IF cmdB < 0 THEN
    cmdB := 0;
ELSIF cmdB > 18000 THEN
    cmdB := 18000;
END_IF;
IF cmdC < 0 THEN
    cmdC := 0;
ELSIF cmdC > 120000 THEN
    cmdC := 120000;
END_IF;
IF cmdD < 0 THEN
    cmdD := 0;
ELSIF cmdD > 120000 THEN
    cmdD := 120000;
END_IF;
IF cmdS30 < -95000 THEN
    cmdS30 := -95000;
ELSIF cmdS30 > 95000 THEN
    cmdS30 := 95000;
END_IF;
IF cmdS31 < -95000 THEN
    cmdS31 := -95000;
ELSIF cmdS31 > 95000 THEN
    cmdS31 := 95000;
END_IF;
IF cmdS32 < 0 THEN
    cmdS32 := 0;
ELSIF cmdS32 > 18000 THEN
    cmdS32 := 18000;
END_IF;
IF cmdS40 < -360000 THEN
    cmdS40 := -360000;
ELSIF cmdS40 > 360000 THEN
    cmdS40 := 360000;
END_IF;
IF cmdS41 < -360000 THEN
    cmdS41 := -360000;
ELSIF cmdS41 > 360000 THEN
    cmdS41 := 360000;
END_IF;

D2000 := cmdA;
D2002 := cmdAFF;
D2004 := cmdB;
D2006 := cmdBFF;
D2008 := cmdC;
D2010 := cmdCFF;
D2012 := cmdD;
D2014 := cmdDFF;
D2016 := cmdS30;
D2018 := cmdS30FF;
D2020 := cmdS31;
D2022 := cmdS31FF;
D2024 := cmdS32;
D2026 := cmdS32FF;
D2028 := cmdS40;
D2030 := cmdS40FF;
D2032 := cmdS41;
D2034 := cmdS41FF;

D82 := seqCounter;
Y2 := completedLatch;

prevState := scanState;

END_PROGRAM