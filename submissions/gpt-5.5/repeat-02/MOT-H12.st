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
    phase : INT := 0;
    prevPhase : INT := -1;
    phaseEntry : BOOL;
    seqCounter : DINT := 0;
    curChannel : INT := -1;
    curId : DINT := 0;
    curOrigin : INT := 1;
    curCancel : BOOL := FALSE;
    curStatus : DINT := 0;
    done0 : BOOL := FALSE;
    done1 : BOOL := FALSE;
    done0Id : DINT := 0;
    done1Id : DINT := 0;
    done0Status : DINT := 0;
    done1Status : DINT := 0;
    sourceDock : DINT;
    originX : DINT;
    originReady : BOOL;
    port3X : DINT;
    port4X : DINT;
    goal3_0 : DINT;
    goal3_1 : DINT;
    goal4_0 : DINT;
    goal4_1 : DINT;
    goal4_2 : DINT;
    cmdA : DINT;
    cmdB : DINT;
    cmdC : DINT;
    cmdD : DINT;
    cmdS30 : DINT;
    cmdS31 : DINT;
    cmdS40 : DINT;
    cmdS41 : DINT;
    cmdS42 : DINT;
    liftADock : BOOL;
    liftBDock : BOOL;
    retain3 : BOOL;
    retain4 : BOOL;
    process3 : BOOL;
    process4 : BOOL;
    finalReady : BOOL;
    aAtOrigin : BOOL;
    aAt3 : BOOL;
    aAt4 : BOOL;
    aAtHome : BOOL;
    bAtHome : BOOL;
    bAtConnect : BOOL;
    cAtHome : BOOL;
    dAtHome : BOOL;
    cAtDock : BOOL;
    dAtDock : BOOL;
    s3AtHome : BOOL;
    s3AtGoal : BOOL;
    s4AtHome : BOOL;
    s4AtGoal : BOOL;
END_VAR

IF done0 AND (D100 <> done0Id) THEN
    done0 := FALSE;
    done0Id := 0;
    done0Status := 0;
END_IF;
IF done1 AND (D120 <> done1Id) THEN
    done1 := FALSE;
    done1Id := 0;
    done1Status := 0;
END_IF;

phaseEntry := FALSE;
IF phase <> prevPhase THEN
    phaseEntry := TRUE;
    prevPhase := phase;
END_IF;

sourceDock := D92;
IF sourceDock < 0 THEN sourceDock := 0; END_IF;
IF sourceDock > 120000 THEN sourceDock := 120000; END_IF;

IF curOrigin = 2 THEN
    originX := D406;
    originReady := X62;
ELSE
    originX := D403;
    originReady := X61;
END_IF;
IF originX < -450000 THEN originX := -450000; END_IF;
IF originX > 450000 THEN originX := 450000; END_IF;

port3X := D409;
IF port3X < -450000 THEN port3X := -450000; END_IF;
IF port3X > 450000 THEN port3X := 450000; END_IF;

port4X := D412;
IF port4X < -450000 THEN port4X := -450000; END_IF;
IF port4X > 450000 THEN port4X := 450000; END_IF;

goal3_0 := D500;
IF goal3_0 < -95000 THEN goal3_0 := -95000; END_IF;
IF goal3_0 > 95000 THEN goal3_0 := 95000; END_IF;
goal3_1 := D501;
IF goal3_1 < -95000 THEN goal3_1 := -95000; END_IF;
IF goal3_1 > 95000 THEN goal3_1 := 95000; END_IF;

goal4_0 := D600;
IF goal4_0 < -90000 THEN goal4_0 := -90000; END_IF;
IF goal4_0 > 90000 THEN goal4_0 := 90000; END_IF;
goal4_1 := D601;
IF goal4_1 < -90000 THEN goal4_1 := -90000; END_IF;
IF goal4_1 > 90000 THEN goal4_1 := 90000; END_IF;
goal4_2 := D602;
IF goal4_2 < 0 THEN goal4_2 := 0; END_IF;
IF goal4_2 > 35000 THEN goal4_2 := 35000; END_IF;

aAtHome := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100);
aAtOrigin := (ABS(D1000 - originX) <= 20) AND (ABS(D1001) <= 100);
aAt3 := (ABS(D1000 - port3X) <= 20) AND (ABS(D1001) <= 100);
aAt4 := (ABS(D1000 - port4X) <= 20) AND (ABS(D1001) <= 100);
bAtHome := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
bAtConnect := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
cAtHome := (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100);
dAtHome := (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100);
cAtDock := (ABS(D1008 - sourceDock) <= 20) AND (ABS(D1009) <= 100);
dAtDock := (ABS(D1012 - sourceDock) <= 20) AND (ABS(D1013) <= 100);
s3AtHome := (ABS(D1016 + 85000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 + 85000) <= 20) AND (ABS(D1021) <= 100);
s3AtGoal := (ABS(D1016 - goal3_0) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - goal3_1) <= 20) AND (ABS(D1021) <= 100);
s4AtHome := (ABS(D1024 + 65000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028 - 65000) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);
s4AtGoal := (ABS(D1024 - goal4_0) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028 - goal4_1) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - goal4_2) <= 20) AND (ABS(D1033) <= 100);

cmdA := 0;
cmdB := 0;
cmdC := 15000;
cmdD := 15000;
cmdS30 := -85000;
cmdS31 := -85000;
cmdS40 := -65000;
cmdS41 := 65000;
cmdS42 := 0;
liftADock := FALSE;
liftBDock := FALSE;
retain3 := FALSE;
retain4 := FALSE;
process3 := FALSE;
process4 := FALSE;
D80 := 0;
D81 := 0;

IF curChannel = 0 THEN
    IF X31 THEN curCancel := TRUE; END_IF;
ELSIF curChannel = 1 THEN
    IF X35 THEN curCancel := TRUE; END_IF;
END_IF;

CASE phase OF
0:
    curChannel := -1;
    curId := 0;
    curCancel := FALSE;
    curStatus := 0;
    IF (D100 <> 0) AND (NOT done0) THEN
        curChannel := 0;
        curId := D100;
        curOrigin := D101 + 1;
        IF curOrigin < 1 THEN curOrigin := 1; END_IF;
        IF curOrigin > 2 THEN curOrigin := 2; END_IF;
        curCancel := X31;
        phase := 10;
    ELSIF (D120 <> 0) AND (NOT done1) THEN
        curChannel := 1;
        curId := D120;
        curOrigin := D121 + 1;
        IF curOrigin < 1 THEN curOrigin := 1; END_IF;
        IF curOrigin > 2 THEN curOrigin := 2; END_IF;
        curCancel := X35;
        phase := 10;
    END_IF;

10:
    IF curCancel THEN
        phase := 97;
    ELSE
        cmdA := originX;
        IF curOrigin = 1 THEN
            liftADock := TRUE;
        ELSE
            liftBDock := TRUE;
        END_IF;
        IF aAtOrigin AND bAtHome AND originReady AND ((curOrigin = 1 AND cAtDock) OR (curOrigin = 2 AND dAtDock)) THEN
            phase := 20;
        END_IF;
    END_IF;

20:
    cmdA := originX;
    cmdB := 18000;
    IF curOrigin = 1 THEN
        liftADock := TRUE;
    ELSE
        liftBDock := TRUE;
    END_IF;
    IF aAtOrigin AND bAtConnect AND originReady AND ((curOrigin = 1 AND cAtDock) OR (curOrigin = 2 AND dAtDock)) THEN
        phase := 22;
    END_IF;

22:
    cmdA := originX;
    cmdB := 18000;
    IF curOrigin = 1 THEN
        liftADock := TRUE;
    ELSE
        liftBDock := TRUE;
    END_IF;
    D80 := 1;
    D81 := curOrigin;
    IF phaseEntry THEN
        seqCounter := seqCounter + 1;
        IF seqCounter <= 0 THEN seqCounter := 1; END_IF;
    END_IF;
    IF D90 = curId THEN
        phase := 24;
    END_IF;

24:
    cmdA := originX;
    cmdB := 0;
    IF bAtHome THEN
        IF curCancel THEN
            phase := 90;
        ELSE
            phase := 30;
        END_IF;
    END_IF;

30:
    cmdA := port3X;
    cmdB := 0;
    retain3 := TRUE;
    IF aAt3 AND bAtHome AND X63 AND s3AtHome THEN
        phase := 32;
    END_IF;

32:
    cmdA := port3X;
    cmdB := 18000;
    retain3 := TRUE;
    IF aAt3 AND bAtConnect AND X63 AND s3AtHome THEN
        phase := 34;
    END_IF;

34:
    cmdA := port3X;
    cmdB := 18000;
    retain3 := TRUE;
    D80 := 2;
    D81 := 3;
    IF phaseEntry THEN
        seqCounter := seqCounter + 1;
        IF seqCounter <= 0 THEN seqCounter := 1; END_IF;
    END_IF;
    IF D90 <> curId THEN
        phase := 36;
    END_IF;

36:
    cmdA := port3X;
    cmdB := 0;
    retain3 := TRUE;
    IF bAtHome THEN
        IF curCancel THEN
            phase := 50;
        ELSE
            phase := 40;
        END_IF;
    END_IF;

40:
    cmdA := port3X;
    cmdB := 0;
    retain3 := TRUE;
    process3 := TRUE;
    IF curCancel THEN
        phase := 50;
    ELSIF X70 AND s3AtGoal THEN
        phase := 50;
    END_IF;

50:
    cmdA := port3X;
    cmdB := 0;
    retain3 := TRUE;
    IF aAt3 AND bAtHome AND X63 AND s3AtHome THEN
        phase := 52;
    END_IF;

52:
    cmdA := port3X;
    cmdB := 18000;
    retain3 := TRUE;
    IF aAt3 AND bAtConnect AND X63 AND s3AtHome THEN
        phase := 54;
    END_IF;

54:
    cmdA := port3X;
    cmdB := 18000;
    retain3 := TRUE;
    D80 := 1;
    D81 := 3;
    IF phaseEntry THEN
        seqCounter := seqCounter + 1;
        IF seqCounter <= 0 THEN seqCounter := 1; END_IF;
    END_IF;
    IF D90 = curId THEN
        phase := 56;
    END_IF;

56:
    cmdA := port3X;
    cmdB := 0;
    retain3 := TRUE;
    IF bAtHome THEN
        IF curCancel THEN
            phase := 90;
        ELSE
            phase := 60;
        END_IF;
    END_IF;

60:
    cmdA := port4X;
    cmdB := 0;
    retain4 := TRUE;
    IF aAt4 AND bAtHome AND X64 AND s4AtHome THEN
        phase := 62;
    END_IF;

62:
    cmdA := port4X;
    cmdB := 18000;
    retain4 := TRUE;
    IF aAt4 AND bAtConnect AND X64 AND s4AtHome THEN
        phase := 64;
    END_IF;

64:
    cmdA := port4X;
    cmdB := 18000;
    retain4 := TRUE;
    D80 := 2;
    D81 := 4;
    IF phaseEntry THEN
        seqCounter := seqCounter + 1;
        IF seqCounter <= 0 THEN seqCounter := 1; END_IF;
    END_IF;
    IF D90 <> curId THEN
        phase := 66;
    END_IF;

66:
    cmdA := port4X;
    cmdB := 0;
    retain4 := TRUE;
    IF bAtHome THEN
        IF curCancel THEN
            phase := 80;
        ELSE
            phase := 70;
        END_IF;
    END_IF;

70:
    cmdA := port4X;
    cmdB := 0;
    retain4 := TRUE;
    process4 := TRUE;
    IF curCancel THEN
        phase := 80;
    ELSIF X75 AND s4AtGoal THEN
        phase := 80;
    END_IF;

80:
    cmdA := port4X;
    cmdB := 0;
    retain4 := TRUE;
    IF aAt4 AND bAtHome AND X64 AND s4AtHome THEN
        phase := 82;
    END_IF;

82:
    cmdA := port4X;
    cmdB := 18000;
    retain4 := TRUE;
    IF aAt4 AND bAtConnect AND X64 AND s4AtHome THEN
        phase := 84;
    END_IF;

84:
    cmdA := port4X;
    cmdB := 18000;
    retain4 := TRUE;
    D80 := 1;
    D81 := 4;
    IF phaseEntry THEN
        seqCounter := seqCounter + 1;
        IF seqCounter <= 0 THEN seqCounter := 1; END_IF;
    END_IF;
    IF D90 = curId THEN
        phase := 86;
    END_IF;

86:
    cmdA := port4X;
    cmdB := 0;
    retain4 := TRUE;
    IF bAtHome THEN
        phase := 90;
    END_IF;

90:
    cmdA := originX;
    cmdB := 0;
    IF curOrigin = 1 THEN
        liftADock := TRUE;
    ELSE
        liftBDock := TRUE;
    END_IF;
    IF aAtOrigin AND bAtHome AND originReady AND ((curOrigin = 1 AND cAtDock) OR (curOrigin = 2 AND dAtDock)) THEN
        phase := 92;
    END_IF;

92:
    cmdA := originX;
    cmdB := 18000;
    IF curOrigin = 1 THEN
        liftADock := TRUE;
    ELSE
        liftBDock := TRUE;
    END_IF;
    IF aAtOrigin AND bAtConnect AND originReady AND ((curOrigin = 1 AND cAtDock) OR (curOrigin = 2 AND dAtDock)) THEN
        phase := 94;
    END_IF;

94:
    cmdA := originX;
    cmdB := 18000;
    IF curOrigin = 1 THEN
        liftADock := TRUE;
    ELSE
        liftBDock := TRUE;
    END_IF;
    D80 := 2;
    D81 := curOrigin;
    IF phaseEntry THEN
        seqCounter := seqCounter + 1;
        IF seqCounter <= 0 THEN seqCounter := 1; END_IF;
    END_IF;
    IF D90 <> curId THEN
        phase := 96;
    END_IF;

96:
    cmdA := originX;
    cmdB := 0;
    IF curOrigin = 1 THEN
        liftADock := TRUE;
    ELSE
        liftBDock := TRUE;
    END_IF;
    IF bAtHome THEN
        phase := 97;
    END_IF;

97:
    cmdA := originX;
    cmdB := 0;
    IF ((curOrigin = 1) AND cAtHome) OR ((curOrigin = 2) AND dAtHome) THEN
        phase := 98;
    END_IF;

98:
    cmdA := originX;
    cmdB := 0;
    IF ((curOrigin = 1) AND cAtHome) OR ((curOrigin = 2) AND dAtHome) THEN
        IF curCancel THEN
            curStatus := 2;
        ELSE
            curStatus := 1;
        END_IF;
        IF curChannel = 0 THEN
            done0 := TRUE;
            done0Id := curId;
            done0Status := curStatus;
        ELSIF curChannel = 1 THEN
            done1 := TRUE;
            done1Id := curId;
            done1Status := curStatus;
        END_IF;
        phase := 0;
    END_IF;
ELSE
    phase := 0;
END_CASE;

IF liftADock THEN cmdC := sourceDock; END_IF;
IF liftBDock THEN cmdD := sourceDock; END_IF;

IF process3 THEN
    cmdS30 := goal3_0;
    cmdS31 := goal3_1;
END_IF;

IF process4 THEN
    cmdS40 := goal4_0;
    cmdS41 := goal4_1;
    cmdS42 := goal4_2;
END_IF;

IF cmdA < -450000 THEN cmdA := -450000; END_IF;
IF cmdA > 450000 THEN cmdA := 450000; END_IF;
IF cmdB < 0 THEN cmdB := 0; END_IF;
IF cmdB > 18000 THEN cmdB := 18000; END_IF;
IF cmdC < 0 THEN cmdC := 0; END_IF;
IF cmdC > 120000 THEN cmdC := 120000; END_IF;
IF cmdD < 0 THEN cmdD := 0; END_IF;
IF cmdD > 120000 THEN cmdD := 120000; END_IF;

D2000 := cmdA;
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2004 := cmdB;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

D2008 := cmdC;
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

D2012 := cmdD;
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2016 := cmdS30;
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;

D2020 := cmdS31;
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2024 := cmdS40;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2028 := cmdS41;
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

D2032 := cmdS42;
D2033 := 1000;
D2034 := 0;
Y48 := TRUE;

Y70 := process3;
Y71 := retain3;
IF retain3 OR process3 THEN
    D700 := curId;
    D701 := D526;
    D702 := 1000;
ELSE
    D700 := 0;
    D701 := 0;
    D702 := 1000;
END_IF;

Y75 := process4;
Y76 := retain4;
IF retain4 OR process4 THEN
    D710 := curId;
    D711 := D626;
    D712 := 1000;
ELSE
    D710 := 0;
    D711 := 0;
    D712 := 1000;
END_IF;

D82 := seqCounter;

IF done0 THEN
    D300 := done0Id;
    D301 := done0Status;
ELSE
    D300 := 0;
    D301 := 0;
END_IF;

IF done1 THEN
    D302 := done1Id;
    D303 := done1Status;
ELSE
    D302 := 0;
    D303 := 0;
END_IF;

finalReady := X51 AND aAtHome AND bAtHome AND cAtHome AND dAtHome AND s3AtHome AND s4AtHome AND (phase = 0);

Y30 := finalReady;
Y2 := finalReady;

END_PROGRAM