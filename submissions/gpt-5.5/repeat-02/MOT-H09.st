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
    activeState : INT;
    activeIndex : INT;
    activeId : DINT;
    activeOrigin : INT;
    activeLane : INT;
    cancelWanted : BOOL;
    cancelStatus : DINT;
    seqNo : DINT;
    transferActive : BOOL;
    transferAction : DINT;
    transferStation : DINT;
    readyCondition : BOOL;
    homeReady : BOOL;
    finalReady : BOOL;
    completionDeclared : BOOL;
    targetA : DINT;
    targetB : DINT;
    targetC : DINT;
    targetD : DINT;
    targetS30 : DINT;
    targetS31 : DINT;
    targetS32 : DINT;
    targetS40 : DINT;
    targetS41 : DINT;
    selectedPocket : DINT;
    req0DoneId : DINT;
    req1DoneId : DINT;
    req0DoneStatus : DINT;
    req1DoneStatus : DINT;
    cell4Phase : INT;
    liftDock : DINT;
    angleTarget : DINT;
    slideTarget : DINT;
    pocketTarget : DINT;
    readyTimer : TON;
END_VAR

liftDock := D92;
IF liftDock < 0 THEN
    liftDock := 0;
END_IF;
IF liftDock > 120000 THEN
    liftDock := 120000;
END_IF;

D2001 := 1000;
D2002 := 0;
Y40 := TRUE;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;
D2033 := 1000;
D2034 := 0;
Y48 := TRUE;

targetA := 0;
targetB := 0;
targetC := 15000;
targetD := 15000;
targetS30 := 0;
targetS31 := 0;
targetS32 := 0;
targetS40 := 0;
targetS41 := 5000;
readyCondition := FALSE;
Y70 := FALSE;
Y71 := FALSE;
Y75 := FALSE;
Y76 := FALSE;
D701 := D526;
D702 := 1000;
D711 := D626;
D712 := 1000;

IF selectedPocket < 1 THEN
    selectedPocket := 1;
END_IF;
D700 := selectedPocket;
D710 := 1;

IF activeState = 0 THEN
    activeId := 0;
    activeIndex := -1;
    cancelStatus := 1;
    cell4Phase := 0;
    transferActive := FALSE;
    IF (D100 <> 0) AND (req0DoneId <> D100) AND NOT X30 THEN
        activeIndex := 0;
        activeId := D100;
        IF D101 = 2 THEN
            activeOrigin := 2;
        ELSE
            activeOrigin := 1;
        END_IF;
        activeLane := 0;
        IF X31 THEN
            cancelStatus := 2;
        ELSE
            cancelStatus := 1;
        END_IF;
        activeState := 10;
    ELSIF (D120 <> 0) AND (req1DoneId <> D120) AND NOT X34 THEN
        activeIndex := 1;
        activeId := D120;
        IF D121 = 2 THEN
            activeOrigin := 2;
        ELSE
            activeOrigin := 1;
        END_IF;
        activeLane := 1;
        IF X35 THEN
            cancelStatus := 2;
        ELSE
            cancelStatus := 1;
        END_IF;
        activeState := 10;
    END_IF;
END_IF;

IF activeIndex = 0 THEN
    IF X31 THEN
        cancelWanted := TRUE;
        cancelStatus := 2;
    ELSE
        cancelWanted := FALSE;
    END_IF;
ELSIF activeIndex = 1 THEN
    IF X35 THEN
        cancelWanted := TRUE;
        cancelStatus := 2;
    ELSE
        cancelWanted := FALSE;
    END_IF;
ELSE
    cancelWanted := FALSE;
END_IF;

IF activeLane = 0 THEN
    selectedPocket := 1;
ELSE
    selectedPocket := 2;
END_IF;
D700 := selectedPocket;

CASE activeState OF
0:
    targetA := 0;
    targetB := 0;
    targetC := 15000;
    targetD := 15000;
    targetS30 := 0;
    targetS31 := 0;
    targetS32 := 0;
    targetS40 := 0;
    targetS41 := 5000;

10:
    targetB := 0;
    IF activeOrigin = 1 THEN
        targetA := D403;
        targetC := liftDock;
        targetD := 15000;
        readyCondition := X61 AND (ABS(D1000 - D403) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - liftDock) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        targetA := D406;
        targetC := 15000;
        targetD := liftDock;
        readyCondition := X62 AND (ABS(D1000 - D406) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1012 - liftDock) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    IF transferActive THEN
        IF D90 = activeId THEN
            transferActive := FALSE;
            activeState := 20;
        END_IF;
    END_IF;

20:
    targetA := D409;
    targetB := 18000;
    targetC := 15000;
    targetD := 15000;
    IF cancelWanted THEN
        activeState := 80;
    ELSE
        readyCondition := X63 AND (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024) <= 20) AND (ABS(D1025) <= 100);
        IF transferActive THEN
            IF (D90 <> activeId) OR (D410 = activeId) THEN
                transferActive := FALSE;
                activeState := 30;
            END_IF;
        END_IF;
    END_IF;

30:
    targetA := D409;
    targetB := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D701 := D526;
    D702 := 1000;
    IF selectedPocket = 1 THEN
        pocketTarget := D501;
        IF pocketTarget < 0 THEN
            pocketTarget := 0;
        END_IF;
        IF pocketTarget > 100000 THEN
            pocketTarget := 100000;
        END_IF;
        targetS30 := 0;
        targetS31 := pocketTarget;
        targetS32 := 0;
    ELSE
        pocketTarget := D502;
        IF pocketTarget < 0 THEN
            pocketTarget := 0;
        END_IF;
        IF pocketTarget > 100000 THEN
            pocketTarget := 100000;
        END_IF;
        targetS30 := 0;
        targetS31 := 0;
        targetS32 := pocketTarget;
    END_IF;
    IF cancelWanted THEN
        activeState := 31;
    ELSIF X70 THEN
        activeState := 31;
    END_IF;

31:
    targetA := D409;
    targetB := 0;
    targetS30 := 0;
    targetS31 := 0;
    targetS32 := 0;
    Y71 := TRUE;
    IF (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) THEN
        activeState := 40;
    END_IF;

40:
    targetA := D409;
    targetB := 0;
    Y71 := TRUE;
    readyCondition := X63 AND (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024) <= 20) AND (ABS(D1025) <= 100);
    IF transferActive THEN
        IF D90 = activeId THEN
            transferActive := FALSE;
            Y71 := FALSE;
            IF cancelWanted THEN
                activeState := 80;
            ELSE
                activeState := 50;
            END_IF;
        END_IF;
    END_IF;

50:
    targetA := D412;
    targetB := 18000;
    targetS40 := 0;
    targetS41 := 5000;
    readyCondition := X64 AND (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - 5000) <= 20) AND (ABS(D1033) <= 100);
    IF transferActive THEN
        IF (D90 <> activeId) OR (D413 = activeId) THEN
            transferActive := FALSE;
            cell4Phase := 0;
            activeState := 60;
        END_IF;
    END_IF;

60:
    targetA := D412;
    targetB := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := 1;
    D711 := D626;
    D712 := 1000;
    angleTarget := D600;
    IF angleTarget < 0 THEN
        angleTarget := 0;
    END_IF;
    IF angleTarget > 27000 THEN
        angleTarget := 27000;
    END_IF;
    slideTarget := D601;
    IF slideTarget < 0 THEN
        slideTarget := 0;
    END_IF;
    IF slideTarget > 74000 THEN
        slideTarget := 74000;
    END_IF;
    IF cell4Phase = 0 THEN
        targetS41 := 5000;
        targetS40 := angleTarget;
        IF (ABS(D1028 - angleTarget) <= 20) AND (ABS(D1029) <= 100) AND (D1032 <= 50000) AND (ABS(D1033) <= 100) THEN
            cell4Phase := 1;
        END_IF;
    ELSIF cell4Phase = 1 THEN
        targetS40 := angleTarget;
        targetS41 := slideTarget;
        IF cancelWanted THEN
            cell4Phase := 2;
        ELSIF X75 THEN
            cell4Phase := 2;
        END_IF;
    ELSIF cell4Phase = 2 THEN
        targetS40 := angleTarget;
        targetS41 := 5000;
        IF (D1032 <= 50000) AND (ABS(D1033) <= 100) THEN
            cell4Phase := 3;
        END_IF;
    ELSE
        targetS40 := 0;
        targetS41 := 5000;
        IF (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - 5000) <= 20) AND (ABS(D1033) <= 100) THEN
            activeState := 70;
        END_IF;
    END_IF;

70:
    targetA := D412;
    targetB := 0;
    targetS40 := 0;
    targetS41 := 5000;
    Y76 := TRUE;
    readyCondition := X64 AND (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - 5000) <= 20) AND (ABS(D1033) <= 100);
    IF transferActive THEN
        IF D90 = activeId THEN
            transferActive := FALSE;
            Y76 := FALSE;
            activeState := 80;
        END_IF;
    END_IF;

80:
    targetB := 18000;
    IF activeOrigin = 1 THEN
        targetA := D403;
        targetC := liftDock;
        targetD := 15000;
        readyCondition := X61 AND (ABS(D1000 - D403) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - liftDock) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        targetA := D406;
        targetC := 15000;
        targetD := liftDock;
        readyCondition := X62 AND (ABS(D1000 - D406) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1012 - liftDock) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    IF transferActive THEN
        IF D90 <> activeId THEN
            transferActive := FALSE;
            activeState := 90;
        END_IF;
    END_IF;

90:
    targetB := 0;
    targetC := 15000;
    targetD := 15000;
    IF activeOrigin = 1 THEN
        targetA := D403;
    ELSE
        targetA := D406;
    END_IF;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) THEN
        IF activeIndex = 0 THEN
            req0DoneId := activeId;
            req0DoneStatus := cancelStatus;
        ELSIF activeIndex = 1 THEN
            req1DoneId := activeId;
            req1DoneStatus := cancelStatus;
        END_IF;
        activeState := 0;
        activeId := 0;
        activeIndex := -1;
    END_IF;

ELSE
    activeState := 0;
END_CASE;

readyTimer(IN := readyCondition, PT := T#40ms);

IF NOT transferActive THEN
    IF readyTimer.Q THEN
        IF activeState = 10 THEN
            transferAction := 1;
            transferStation := activeOrigin;
            seqNo := seqNo + 1;
            transferActive := TRUE;
        ELSIF activeState = 20 THEN
            transferAction := 2;
            transferStation := 3;
            seqNo := seqNo + 1;
            transferActive := TRUE;
        ELSIF activeState = 40 THEN
            transferAction := 1;
            transferStation := 3;
            seqNo := seqNo + 1;
            transferActive := TRUE;
        ELSIF activeState = 50 THEN
            transferAction := 2;
            transferStation := 4;
            seqNo := seqNo + 1;
            transferActive := TRUE;
        ELSIF activeState = 70 THEN
            transferAction := 1;
            transferStation := 4;
            seqNo := seqNo + 1;
            transferActive := TRUE;
        ELSIF activeState = 80 THEN
            transferAction := 2;
            transferStation := activeOrigin;
            seqNo := seqNo + 1;
            transferActive := TRUE;
        END_IF;
    END_IF;
END_IF;

IF transferActive THEN
    D80 := transferAction;
    D81 := transferStation;
ELSE
    D80 := 0;
    D81 := 0;
END_IF;
D82 := seqNo;

IF targetA < -450000 THEN
    targetA := -450000;
END_IF;
IF targetA > 1461300 THEN
    targetA := 1461300;
END_IF;
IF targetB < 0 THEN
    targetB := 0;
END_IF;
IF targetB > 18000 THEN
    targetB := 18000;
END_IF;
IF targetC < 0 THEN
    targetC := 0;
END_IF;
IF targetC > 120000 THEN
    targetC := 120000;
END_IF;
IF targetD < 0 THEN
    targetD := 0;
END_IF;
IF targetD > 120000 THEN
    targetD := 120000;
END_IF;
IF targetS30 < 0 THEN
    targetS30 := 0;
END_IF;
IF targetS30 > 100000 THEN
    targetS30 := 100000;
END_IF;
IF targetS31 < 0 THEN
    targetS31 := 0;
END_IF;
IF targetS31 > 100000 THEN
    targetS31 := 100000;
END_IF;
IF targetS32 < 0 THEN
    targetS32 := 0;
END_IF;
IF targetS32 > 100000 THEN
    targetS32 := 100000;
END_IF;
IF targetS40 < 0 THEN
    targetS40 := 0;
END_IF;
IF targetS40 > 27000 THEN
    targetS40 := 27000;
END_IF;
IF targetS41 < 0 THEN
    targetS41 := 0;
END_IF;
IF targetS41 > 74000 THEN
    targetS41 := 74000;
END_IF;

D2000 := targetA;
D2004 := targetB;
D2008 := targetC;
D2012 := targetD;
D2016 := targetS30;
D2020 := targetS31;
D2024 := targetS32;
D2028 := targetS40;
D2032 := targetS41;

D300 := req0DoneId;
D301 := req0DoneStatus;
D302 := req1DoneId;
D303 := req1DoneStatus;

homeReady := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - 5000) <= 20) AND (ABS(D1033) <= 100);
finalReady := X51 AND homeReady AND (activeState = 0) AND NOT transferActive;

IF finalReady THEN
    completionDeclared := TRUE;
END_IF;
Y2 := completionDeclared;

IF finalReady AND completionDeclared THEN
    Y30 := TRUE;
ELSE
    Y30 := FALSE;
END_IF;

END_PROGRAM