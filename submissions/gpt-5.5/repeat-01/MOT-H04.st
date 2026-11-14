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
    activeIndex : DINT;
    activeID : DINT;
    activeOrig : DINT;
    activeCancel : BOOL;
    done0 : BOOL;
    done1 : BOOL;
    lastID0 : DINT;
    lastID1 : DINT;
    seqNo : DINT;
    couplingBusy : BOOL;
    couplingAction : DINT;
    couplingStation : DINT;
    liftDock : DINT;
    origPortX : DINT;
    origPortReady : BOOL;
    aAtOrig : BOOL;
    aAt3 : BOOL;
    aAt4 : BOOL;
    aAtHome : BOOL;
    bAtRetract : BOOL;
    bAtExtend : BOOL;
    bClear : BOOL;
    liftAtDock : BOOL;
    liftAtHome : BOOL;
    s3Home : BOOL;
    s3ResultPos : BOOL;
    s3Settled : BOOL;
    s4Home : BOOL;
    s4Settled : BOOL;
    finalReady : BOOL;
    finalTimer : TON;
    s30Goal : DINT;
    s31Goal : DINT;
    s32Goal : DINT;
    s40Goal : DINT;
    cwRaw : DINT;
    cwFinalRaw : DINT;
    thetaRad : REAL;
    thetaGoalRad : REAL;
    moment4 : REAL;
    s3AccelCmd : DINT;
    tmpDist : DINT;
END_VAR

IF D100 <> lastID0 THEN
    lastID0 := D100;
    done0 := FALSE;
    D300 := 0;
    D301 := 0;
END_IF;

IF D120 <> lastID1 THEN
    lastID1 := D120;
    done1 := FALSE;
    D302 := 0;
    D303 := 0;
END_IF;

liftDock := LIMIT(0, D92, 120000);
s30Goal := LIMIT(50000, D500, 150000);
s31Goal := LIMIT(-100000, D501, 100000);
s32Goal := LIMIT(-3000, D502, 3000);
s40Goal := LIMIT(-5000, D600, 5000);

thetaRad := (REAL(D1028) / 100.0) * 0.01745329252;
thetaGoalRad := (REAL(s40Goal) / 100.0) * 0.01745329252;
cwRaw := LIMIT(-45000, DINT(ROUND(-45000.0 * SIN(thetaRad))), 45000);
cwFinalRaw := LIMIT(-45000, DINT(ROUND(-45000.0 * SIN(thetaGoalRad))), 45000);
moment4 := 0.1962 * ((450.0 * SIN(thetaRad)) + (REAL(D1032) / 100.0));

IF activeOrig = 2 THEN
    origPortX := LIMIT(-450000, D406, 510000);
    origPortReady := X62;
ELSE
    origPortX := LIMIT(-450000, D403, 510000);
    origPortReady := X61;
END_IF;

aAtOrig := (ABS(D1000 - origPortX) <= 20) AND (ABS(D1001) <= 100);
aAt3 := (ABS(D1000 - LIMIT(-450000, D409, 510000)) <= 20) AND (ABS(D1001) <= 100);
aAt4 := (ABS(D1000 - LIMIT(-450000, D412, 510000)) <= 20) AND (ABS(D1001) <= 100);
aAtHome := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100);
bAtRetract := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
bAtExtend := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
bClear := (D1004 <= 4000) AND (ABS(D1005) <= 100);
liftAtDock := (ABS(D1008 - liftDock) <= 20) AND (ABS(D1012 - liftDock) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100);
liftAtHome := (ABS(D1008 - 40000) <= 20) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100);
s3Home := (ABS(D1016 - 100000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024) <= 3) AND (ABS(D1025) <= 15);
s3ResultPos := (ABS(D1016 - s30Goal) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - s31Goal) <= 20) AND (ABS(D1021) <= 100);
s3Settled := (ABS(D1024) <= 3) AND (ABS(D1025) <= 15);
s4Home := (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);
s4Settled := (ABS(D1028 - s40Goal) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - cwFinalRaw) <= 50) AND (ABS(D1033) <= 100) AND (ABS(moment4) <= 1.0);

D2000 := 0;
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2004 := 0;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

D2008 := 40000;
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

D2012 := 40000;
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2016 := 100000;
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;

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
Y71 := FALSE;
D700 := 0;
D701 := 0;
D702 := 0;
Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := 0;
D712 := 0;
Y30 := FALSE;

IF activeID <> 0 THEN
    IF activeIndex = 0 THEN
        IF X31 THEN
            activeCancel := TRUE;
        END_IF;
    ELSE
        IF X35 THEN
            activeCancel := TRUE;
        END_IF;
    END_IF;
END_IF;

CASE state OF
0:
    couplingBusy := FALSE;
    activeID := 0;
    activeIndex := -1;
    activeCancel := FALSE;
    IF (D100 <> 0) AND NOT done0 THEN
        activeIndex := 0;
        activeID := D100;
        activeOrig := D101;
        IF (activeOrig < 1) OR (activeOrig > 2) THEN
            activeOrig := 1;
        END_IF;
        activeCancel := X31;
        state := 10;
    ELSIF (D120 <> 0) AND NOT done1 THEN
        activeIndex := 1;
        activeID := D120;
        activeOrig := D121;
        IF (activeOrig < 1) OR (activeOrig > 2) THEN
            activeOrig := 2;
        END_IF;
        activeCancel := X35;
        state := 10;
    END_IF;

10:
    D2000 := origPortX;
    D2004 := 0;
    D2008 := liftDock;
    D2012 := liftDock;
    IF origPortReady AND aAtOrig AND bAtRetract AND liftAtDock AND NOT couplingBusy THEN
        seqNo := seqNo + 1;
        IF seqNo <= 0 THEN
            seqNo := 1;
        END_IF;
        couplingAction := 1;
        couplingStation := activeOrig;
        couplingBusy := TRUE;
        state := 11;
    END_IF;

11:
    D2000 := origPortX;
    D2004 := 0;
    D2008 := liftDock;
    D2012 := liftDock;
    IF D90 = activeID THEN
        couplingBusy := FALSE;
        IF activeCancel THEN
            state := 70;
        ELSE
            state := 20;
        END_IF;
    END_IF;

20:
    D2000 := LIMIT(-450000, D409, 510000);
    D2004 := 0;
    IF X63 AND aAt3 AND bAtRetract AND s3Home THEN
        state := 23;
    END_IF;

23:
    D2000 := LIMIT(-450000, D409, 510000);
    D2004 := 18000;
    IF X63 AND aAt3 AND bAtExtend AND s3Home AND NOT couplingBusy THEN
        seqNo := seqNo + 1;
        IF seqNo <= 0 THEN
            seqNo := 1;
        END_IF;
        couplingAction := 2;
        couplingStation := 3;
        couplingBusy := TRUE;
        state := 21;
    END_IF;

21:
    D2000 := LIMIT(-450000, D409, 510000);
    D2004 := 18000;
    Y71 := TRUE;
    D700 := activeID;
    D701 := D526;
    IF D90 <> activeID THEN
        couplingBusy := FALSE;
        state := 22;
    END_IF;

22:
    D2000 := LIMIT(-450000, D409, 510000);
    D2004 := 0;
    Y71 := TRUE;
    D700 := activeID;
    D701 := D526;
    IF bClear THEN
        IF activeCancel THEN
            state := 31;
        ELSE
            state := 30;
        END_IF;
    END_IF;

30:
    D2000 := 0;
    D2004 := 0;
    D2016 := s30Goal;
    D2020 := s31Goal;
    D2024 := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := activeID;
    D701 := D526;
    IF X70 OR activeCancel THEN
        state := 31;
    END_IF;

31:
    D2000 := LIMIT(-450000, D409, 510000);
    D2004 := 0;
    D2016 := 100000;
    D2020 := 0;
    D2024 := 0;
    Y71 := TRUE;
    D700 := activeID;
    D701 := D526;
    IF X63 AND aAt3 AND bAtRetract AND s3Home AND s3Settled AND NOT couplingBusy THEN
        seqNo := seqNo + 1;
        IF seqNo <= 0 THEN
            seqNo := 1;
        END_IF;
        couplingAction := 1;
        couplingStation := 3;
        couplingBusy := TRUE;
        state := 32;
    END_IF;

32:
    D2000 := LIMIT(-450000, D409, 510000);
    D2004 := 0;
    D2016 := 100000;
    D2020 := 0;
    D2024 := 0;
    Y71 := TRUE;
    D700 := activeID;
    D701 := D526;
    IF D90 = activeID THEN
        couplingBusy := FALSE;
        IF activeCancel THEN
            state := 70;
        ELSE
            state := 40;
        END_IF;
    END_IF;

40:
    D2000 := LIMIT(-450000, D412, 510000);
    D2004 := 0;
    D2028 := 0;
    D2032 := 0;
    IF X64 AND aAt4 AND bAtRetract AND s4Home THEN
        state := 45;
    END_IF;

45:
    D2000 := LIMIT(-450000, D412, 510000);
    D2004 := 18000;
    D2028 := 0;
    D2032 := 0;
    IF X64 AND aAt4 AND bAtExtend AND s4Home AND NOT couplingBusy THEN
        seqNo := seqNo + 1;
        IF seqNo <= 0 THEN
            seqNo := 1;
        END_IF;
        couplingAction := 2;
        couplingStation := 4;
        couplingBusy := TRUE;
        state := 41;
    END_IF;

41:
    D2000 := LIMIT(-450000, D412, 510000);
    D2004 := 18000;
    Y76 := TRUE;
    D710 := activeID;
    D711 := D626;
    IF D90 <> activeID THEN
        couplingBusy := FALSE;
        state := 46;
    END_IF;

46:
    D2000 := LIMIT(-450000, D412, 510000);
    D2004 := 0;
    Y76 := TRUE;
    D710 := activeID;
    D711 := D626;
    IF bClear THEN
        IF activeCancel THEN
            state := 43;
        ELSE
            state := 42;
        END_IF;
    END_IF;

42:
    D2000 := 0;
    D2004 := 0;
    D2028 := s40Goal;
    D2032 := cwRaw;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := activeID;
    D711 := D626;
    IF X75 OR activeCancel THEN
        state := 43;
    END_IF;

43:
    D2000 := LIMIT(-450000, D412, 510000);
    D2004 := 0;
    D2028 := 0;
    D2032 := cwRaw;
    Y76 := TRUE;
    D710 := activeID;
    D711 := D626;
    IF X64 AND aAt4 AND bAtRetract AND s4Home AND NOT couplingBusy THEN
        seqNo := seqNo + 1;
        IF seqNo <= 0 THEN
            seqNo := 1;
        END_IF;
        couplingAction := 1;
        couplingStation := 4;
        couplingBusy := TRUE;
        state := 44;
    END_IF;

44:
    D2000 := LIMIT(-450000, D412, 510000);
    D2004 := 0;
    D2028 := 0;
    D2032 := cwRaw;
    Y76 := TRUE;
    D710 := activeID;
    D711 := D626;
    IF D90 = activeID THEN
        couplingBusy := FALSE;
        state := 70;
    END_IF;

70:
    D2000 := origPortX;
    D2004 := 0;
    D2008 := liftDock;
    D2012 := liftDock;
    IF origPortReady AND aAtOrig AND bAtRetract AND liftAtDock THEN
        state := 73;
    END_IF;

73:
    D2000 := origPortX;
    D2004 := 18000;
    D2008 := liftDock;
    D2012 := liftDock;
    IF origPortReady AND aAtOrig AND bAtExtend AND liftAtDock AND NOT couplingBusy THEN
        seqNo := seqNo + 1;
        IF seqNo <= 0 THEN
            seqNo := 1;
        END_IF;
        couplingAction := 2;
        couplingStation := activeOrig;
        couplingBusy := TRUE;
        state := 71;
    END_IF;

71:
    D2000 := origPortX;
    D2004 := 18000;
    D2008 := liftDock;
    D2012 := liftDock;
    IF D90 <> activeID THEN
        couplingBusy := FALSE;
        state := 74;
    END_IF;

74:
    D2000 := origPortX;
    D2004 := 0;
    D2008 := liftDock;
    D2012 := liftDock;
    IF bClear THEN
        state := 72;
    END_IF;

72:
    D2000 := origPortX;
    D2004 := 0;
    D2008 := 40000;
    D2012 := 40000;
    IF liftAtHome AND bAtRetract THEN
        IF activeIndex = 0 THEN
            D300 := activeID;
            IF activeCancel THEN
                D301 := 2;
            ELSE
                D301 := 1;
            END_IF;
            done0 := TRUE;
        ELSE
            D302 := activeID;
            IF activeCancel THEN
                D303 := 2;
            ELSE
                D303 := 1;
            END_IF;
            done1 := TRUE;
        END_IF;
        activeID := 0;
        activeIndex := -1;
        activeCancel := FALSE;
        state := 0;
    END_IF;

ELSE
    state := 0;
END_CASE;

IF (state = 30) OR (state = 31) OR (state = 32) THEN
    tmpDist := D2020 - D1020;
    s3AccelCmd := (tmpDist * 50) - (D1021 * 20);
    D702 := LIMIT(-1000000, s3AccelCmd, 1000000);
END_IF;

IF couplingBusy THEN
    D80 := couplingAction;
    D81 := couplingStation;
ELSE
    D80 := 0;
    D81 := 0;
END_IF;
D82 := seqNo;

finalReady := X51 AND aAtHome AND bAtRetract AND liftAtHome AND s3Home AND s4Home AND (ABS(D1008 - D1012) <= 8000);
finalTimer(IN := finalReady, PT := T#100ms);
Y2 := finalTimer.Q;

IF Y2 THEN
    Y30 := TRUE;
END_IF;

END_PROGRAM