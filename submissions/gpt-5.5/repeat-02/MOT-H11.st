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
    initialized : BOOL;
    processState : INT;
    activeChan : INT;
    activeId : DINT;
    activeOrigin : INT;
    activeCancel : BOOL;
    prev0 : DINT;
    prev1 : DINT;
    ack0_id : DINT;
    ack0_status : DINT;
    ack1_id : DINT;
    ack1_status : DINT;
    seq : DINT;
    connIssued : BOOL;
    cmdA : DINT;
    cmdB : DINT;
    cmdC : DINT;
    cmdD : DINT;
    cmdS30 : DINT;
    cmdS31 : DINT;
    cmdS40 : DINT;
    cmdS41 : DINT;
    cmdS42 : DINT;
    liftDock : DINT;
    goal30 : DINT;
    goal31 : DINT;
    goal40 : DINT;
    cand0 : BOOL;
    cand1 : BOOL;
    aAt : BOOL;
    bHome : BOOL;
    bExt : BOOL;
    cDock : BOOL;
    dDock : BOOL;
    liftsDock : BOOL;
    liftsHome : BOOL;
    s3Home : BOOL;
    s4Home : BOOL;
    finalHome : BOOL;
    originReady : BOOL;
    originPortId : DINT;
    originX : DINT;
    chan0Done : BOOL;
    chan1Done : BOOL;
END_VAR

IF NOT initialized THEN
    initialized := TRUE;
    processState := 0;
    activeChan := 0;
    activeId := 0;
    activeOrigin := 1;
    activeCancel := FALSE;
    seq := 1;
    connIssued := FALSE;
    cmdA := 0;
    cmdB := 0;
    cmdC := 40000;
    cmdD := 40000;
    cmdS30 := 0;
    cmdS31 := 5000;
    cmdS40 := 0;
    cmdS41 := 0;
    cmdS42 := 0;
END_IF;

IF D100 <> prev0 THEN
    prev0 := D100;
    ack0_id := 0;
    ack0_status := 0;
END_IF;

IF D120 <> prev1 THEN
    prev1 := D120;
    ack1_id := 0;
    ack1_status := 0;
END_IF;

liftDock := D92;
IF liftDock < 0 THEN
    liftDock := 0;
ELSIF liftDock > 120000 THEN
    liftDock := 120000;
END_IF;

goal30 := D500;
IF goal30 < 0 THEN
    goal30 := 0;
ELSIF goal30 > 27000 THEN
    goal30 := 27000;
END_IF;

goal31 := D501;
IF goal31 < 0 THEN
    goal31 := 0;
ELSIF goal31 > 74000 THEN
    goal31 := 74000;
END_IF;

goal40 := D600;
IF goal40 < 0 THEN
    goal40 := 0;
ELSIF goal40 > 27000 THEN
    goal40 := 27000;
END_IF;

IF activeOrigin = 2 THEN
    originX := D406;
    originReady := X62;
    originPortId := D407;
ELSE
    originX := D403;
    originReady := X61;
    originPortId := D404;
END_IF;

aAt := (ABS(D1000 - cmdA) <= 20) AND (ABS(D1001) <= 100);
bHome := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
bExt := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
cDock := (ABS(D1008 - liftDock) <= 20) AND (ABS(D1009) <= 100);
dDock := (ABS(D1012 - liftDock) <= 20) AND (ABS(D1013) <= 100);
liftsDock := cDock AND dDock AND (ABS(D1008 - D1012) <= 8000);
liftsHome := (ABS(D1008 - 40000) <= 20) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) AND (ABS(D1008 - D1012) <= 8000);
s3Home := (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - 5000) <= 20) AND (ABS(D1021) <= 100);
s4Home := (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);
finalHome := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND bHome AND liftsHome AND s3Home AND s4Home;

D80 := 0;
D81 := 0;

IF (processState = 0) AND (activeChan = 0) THEN
    IF (D100 <> 0) AND X31 AND (ack0_status = 0) THEN
        ack0_id := D100;
        ack0_status := 2;
    END_IF;
    IF (D120 <> 0) AND X35 AND (ack1_status = 0) THEN
        ack1_id := D120;
        ack1_status := 2;
    END_IF;
END_IF;

CASE processState OF
0:
    cmdA := 0;
    cmdB := 0;
    cmdC := 40000;
    cmdD := 40000;
    cmdS30 := 0;
    cmdS31 := 5000;
    cmdS40 := 0;
    cmdS41 := 0;
    cmdS42 := 0;
    connIssued := FALSE;

    cand0 := (D100 <> 0) AND (ack0_status = 0) AND NOT X31;
    cand1 := (D120 <> 0) AND (ack1_status = 0) AND NOT X35;

    IF cand0 OR cand1 THEN
        IF cand0 AND cand1 THEN
            IF D103 <= D123 THEN
                activeChan := 1;
                activeId := D100;
                IF (D101 = 1) OR (D101 = 2) THEN
                    activeOrigin := INT(D101);
                ELSE
                    activeOrigin := 1;
                END_IF;
                activeCancel := FALSE;
            ELSE
                activeChan := 2;
                activeId := D120;
                IF (D121 = 1) OR (D121 = 2) THEN
                    activeOrigin := INT(D121);
                ELSE
                    activeOrigin := 2;
                END_IF;
                activeCancel := FALSE;
            END_IF;
        ELSIF cand0 THEN
            activeChan := 1;
            activeId := D100;
            IF (D101 = 1) OR (D101 = 2) THEN
                activeOrigin := INT(D101);
            ELSE
                activeOrigin := 1;
            END_IF;
            activeCancel := FALSE;
        ELSE
            activeChan := 2;
            activeId := D120;
            IF (D121 = 1) OR (D121 = 2) THEN
                activeOrigin := INT(D121);
            ELSE
                activeOrigin := 2;
            END_IF;
            activeCancel := FALSE;
        END_IF;
        processState := 10;
    END_IF;

10:
    IF activeOrigin = 2 THEN
        cmdA := D406;
    ELSE
        cmdA := D403;
    END_IF;
    cmdB := 0;
    cmdC := liftDock;
    cmdD := liftDock;
    cmdS30 := 0;
    cmdS31 := 5000;
    cmdS40 := 0;
    cmdS41 := 0;
    cmdS42 := 0;
    IF aAt AND bHome AND liftsDock AND originReady THEN
        processState := 11;
    END_IF;

11:
    IF activeOrigin = 2 THEN
        cmdA := D406;
    ELSE
        cmdA := D403;
    END_IF;
    cmdB := 18000;
    cmdC := liftDock;
    cmdD := liftDock;
    IF aAt AND bExt AND liftsDock AND originReady THEN
        processState := 12;
        connIssued := FALSE;
    END_IF;

12:
    IF activeOrigin = 2 THEN
        cmdA := D406;
    ELSE
        cmdA := D403;
    END_IF;
    cmdB := 18000;
    cmdC := liftDock;
    cmdD := liftDock;
    D80 := 1;
    D81 := DINT(activeOrigin);
    IF NOT connIssued THEN
        seq := seq + 1;
        connIssued := TRUE;
    END_IF;
    IF D90 = activeId THEN
        processState := 13;
        connIssued := FALSE;
    END_IF;

13:
    IF activeOrigin = 2 THEN
        cmdA := D406;
    ELSE
        cmdA := D403;
    END_IF;
    cmdB := 0;
    cmdC := liftDock;
    cmdD := liftDock;
    IF bHome AND (D90 = activeId) THEN
        processState := 20;
    END_IF;

20:
    cmdA := D409;
    cmdB := 0;
    cmdC := liftDock;
    cmdD := liftDock;
    cmdS30 := 0;
    cmdS31 := 5000;
    IF aAt AND bHome AND X63 AND s3Home AND (D90 = activeId) THEN
        processState := 21;
    END_IF;

21:
    cmdA := D409;
    cmdB := 18000;
    cmdC := liftDock;
    cmdD := liftDock;
    cmdS30 := 0;
    cmdS31 := 5000;
    IF aAt AND bExt AND X63 AND s3Home THEN
        processState := 22;
        connIssued := FALSE;
    END_IF;

22:
    cmdA := D409;
    cmdB := 18000;
    cmdC := liftDock;
    cmdD := liftDock;
    cmdS30 := 0;
    cmdS31 := 5000;
    D80 := 2;
    D81 := 3;
    IF NOT connIssued THEN
        seq := seq + 1;
        connIssued := TRUE;
    END_IF;
    IF D90 <> activeId THEN
        processState := 23;
        connIssued := FALSE;
    END_IF;

23:
    cmdA := D409;
    cmdB := 0;
    cmdC := liftDock;
    cmdD := liftDock;
    cmdS30 := 0;
    cmdS31 := 5000;
    IF bHome THEN
        processState := 30;
    END_IF;

30:
    cmdB := 0;
    cmdS30 := 0;
    cmdS31 := 50000;
    IF (ABS(D1020 - 50000) <= 20) AND (ABS(D1021) <= 100) THEN
        processState := 31;
    END_IF;

31:
    cmdB := 0;
    cmdS30 := goal30;
    cmdS31 := 50000;
    IF (ABS(D1016 - goal30) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - 50000) <= 20) AND (ABS(D1021) <= 100) THEN
        processState := 32;
    END_IF;

32:
    cmdB := 0;
    cmdS30 := goal30;
    cmdS31 := goal31;
    IF X70 OR X71 THEN
        processState := 33;
    END_IF;

33:
    cmdB := 0;
    cmdS30 := 0;
    cmdS31 := 5000;
    IF s3Home THEN
        processState := 40;
    END_IF;

40:
    cmdA := D409;
    cmdB := 0;
    cmdS30 := 0;
    cmdS31 := 5000;
    IF aAt AND bHome AND X63 AND s3Home THEN
        processState := 41;
    END_IF;

41:
    cmdA := D409;
    cmdB := 18000;
    cmdS30 := 0;
    cmdS31 := 5000;
    IF aAt AND bExt AND X63 AND s3Home THEN
        processState := 42;
        connIssued := FALSE;
    END_IF;

42:
    cmdA := D409;
    cmdB := 18000;
    cmdS30 := 0;
    cmdS31 := 5000;
    D80 := 1;
    D81 := 3;
    IF NOT connIssued THEN
        seq := seq + 1;
        connIssued := TRUE;
    END_IF;
    IF D90 = activeId THEN
        processState := 43;
        connIssued := FALSE;
    END_IF;

43:
    cmdA := D409;
    cmdB := 0;
    cmdS30 := 0;
    cmdS31 := 5000;
    IF bHome AND (D90 = activeId) THEN
        processState := 50;
    END_IF;

50:
    cmdA := D412;
    cmdB := 0;
    cmdS40 := 0;
    cmdS41 := 0;
    cmdS42 := 0;
    IF aAt AND bHome AND X64 AND s4Home AND (D90 = activeId) THEN
        processState := 51;
    END_IF;

51:
    cmdA := D412;
    cmdB := 18000;
    cmdS40 := 0;
    cmdS41 := 0;
    cmdS42 := 0;
    IF aAt AND bExt AND X64 AND s4Home THEN
        processState := 52;
        connIssued := FALSE;
    END_IF;

52:
    cmdA := D412;
    cmdB := 18000;
    cmdS40 := 0;
    cmdS41 := 0;
    cmdS42 := 0;
    D80 := 2;
    D81 := 4;
    IF NOT connIssued THEN
        seq := seq + 1;
        connIssued := TRUE;
    END_IF;
    IF D90 <> activeId THEN
        processState := 53;
        connIssued := FALSE;
    END_IF;

53:
    cmdA := D412;
    cmdB := 0;
    cmdS40 := 0;
    cmdS41 := 0;
    cmdS42 := 0;
    IF bHome THEN
        processState := 60;
    END_IF;

60:
    cmdB := 0;
    cmdS40 := goal40;
    cmdS41 := 0;
    cmdS42 := 0;
    IF (ABS(D1024 - goal40) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
        processState := 61;
    END_IF;

61:
    cmdB := 0;
    cmdS40 := goal40;
    IF D620 = 0 THEN
        cmdS41 := 4000;
        cmdS42 := 0;
    ELSE
        cmdS41 := 0;
        cmdS42 := 4000;
    END_IF;
    IF X75 OR X76 THEN
        processState := 62;
    END_IF;

62:
    cmdB := 0;
    cmdS40 := 0;
    cmdS41 := 0;
    cmdS42 := 0;
    IF s4Home THEN
        processState := 70;
    END_IF;

70:
    cmdA := D412;
    cmdB := 0;
    cmdS40 := 0;
    cmdS41 := 0;
    cmdS42 := 0;
    IF aAt AND bHome AND X64 AND s4Home THEN
        processState := 71;
    END_IF;

71:
    cmdA := D412;
    cmdB := 18000;
    cmdS40 := 0;
    cmdS41 := 0;
    cmdS42 := 0;
    IF aAt AND bExt AND X64 AND s4Home THEN
        processState := 72;
        connIssued := FALSE;
    END_IF;

72:
    cmdA := D412;
    cmdB := 18000;
    cmdS40 := 0;
    cmdS41 := 0;
    cmdS42 := 0;
    D80 := 1;
    D81 := 4;
    IF NOT connIssued THEN
        seq := seq + 1;
        connIssued := TRUE;
    END_IF;
    IF D90 = activeId THEN
        processState := 73;
        connIssued := FALSE;
    END_IF;

73:
    cmdA := D412;
    cmdB := 0;
    cmdS40 := 0;
    cmdS41 := 0;
    cmdS42 := 0;
    IF bHome AND (D90 = activeId) THEN
        processState := 80;
    END_IF;

80:
    IF activeOrigin = 2 THEN
        cmdA := D406;
    ELSE
        cmdA := D403;
    END_IF;
    cmdB := 0;
    cmdC := liftDock;
    cmdD := liftDock;
    IF aAt AND bHome AND liftsDock AND originReady AND (D90 = activeId) THEN
        processState := 81;
    END_IF;

81:
    IF activeOrigin = 2 THEN
        cmdA := D406;
    ELSE
        cmdA := D403;
    END_IF;
    cmdB := 18000;
    cmdC := liftDock;
    cmdD := liftDock;
    IF aAt AND bExt AND liftsDock AND originReady THEN
        processState := 82;
        connIssued := FALSE;
    END_IF;

82:
    IF activeOrigin = 2 THEN
        cmdA := D406;
    ELSE
        cmdA := D403;
    END_IF;
    cmdB := 18000;
    cmdC := liftDock;
    cmdD := liftDock;
    D80 := 2;
    D81 := DINT(activeOrigin);
    IF NOT connIssued THEN
        seq := seq + 1;
        connIssued := TRUE;
    END_IF;
    IF D90 <> activeId THEN
        processState := 83;
        connIssued := FALSE;
    END_IF;

83:
    IF activeOrigin = 2 THEN
        cmdA := D406;
    ELSE
        cmdA := D403;
    END_IF;
    cmdB := 0;
    cmdC := liftDock;
    cmdD := liftDock;
    IF bHome THEN
        processState := 84;
    END_IF;

84:
    cmdB := 0;
    cmdC := 40000;
    cmdD := 40000;
    IF liftsHome THEN
        IF activeChan = 1 THEN
            ack0_id := activeId;
            IF activeCancel THEN
                ack0_status := 2;
            ELSE
                ack0_status := 1;
            END_IF;
        ELSIF activeChan = 2 THEN
            ack1_id := activeId;
            IF activeCancel THEN
                ack1_status := 2;
            ELSE
                ack1_status := 1;
            END_IF;
        END_IF;
        activeChan := 0;
        activeId := 0;
        activeCancel := FALSE;
        processState := 0;
    END_IF;

ELSE
    processState := 0;
END_CASE;

IF cmdA < -450000 THEN
    cmdA := -450000;
ELSIF cmdA > 450000 THEN
    cmdA := 450000;
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
IF cmdS30 < 0 THEN
    cmdS30 := 0;
ELSIF cmdS30 > 27000 THEN
    cmdS30 := 27000;
END_IF;
IF cmdS31 < 0 THEN
    cmdS31 := 0;
ELSIF cmdS31 > 74000 THEN
    cmdS31 := 74000;
END_IF;
IF cmdS40 < 0 THEN
    cmdS40 := 0;
ELSIF cmdS40 > 27000 THEN
    cmdS40 := 27000;
END_IF;
IF cmdS41 < 0 THEN
    cmdS41 := 0;
ELSIF cmdS41 > 4000 THEN
    cmdS41 := 4000;
END_IF;
IF cmdS42 < 0 THEN
    cmdS42 := 0;
ELSIF cmdS42 > 4000 THEN
    cmdS42 := 4000;
END_IF;

IF (processState >= 30) AND (processState <= 32) THEN
    Y70 := TRUE;
ELSE
    Y70 := FALSE;
END_IF;
IF (processState >= 30) AND (processState <= 43) THEN
    Y71 := TRUE;
ELSE
    Y71 := FALSE;
END_IF;

IF (processState >= 60) AND (processState <= 61) THEN
    Y75 := TRUE;
ELSE
    Y75 := FALSE;
END_IF;
IF (processState >= 60) AND (processState <= 73) THEN
    Y76 := TRUE;
ELSE
    Y76 := FALSE;
END_IF;

IF activeId <> 0 THEN
    D700 := activeId;
    D710 := activeId;
ELSE
    D700 := 0;
    D710 := 0;
END_IF;
D701 := D526;
D702 := 1000;
D711 := D626;
D712 := 1000;

chan0Done := (D100 = 0) OR (ack0_status <> 0) OR X30;
chan1Done := (D120 = 0) OR (ack1_status <> 0) OR X34;

IF X51 AND finalHome AND (processState = 0) AND (activeChan = 0) AND chan0Done AND chan1Done THEN
    Y2 := TRUE;
ELSE
    IF NOT Y2 THEN
        Y2 := FALSE;
    END_IF;
END_IF;

IF Y2 THEN
    cmdA := 0;
    cmdB := 0;
    cmdC := 40000;
    cmdD := 40000;
    cmdS30 := 0;
    cmdS31 := 5000;
    cmdS40 := 0;
    cmdS41 := 0;
    cmdS42 := 0;
    D80 := 0;
    D81 := 0;
END_IF;

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

D300 := ack0_id;
D301 := ack0_status;
D302 := ack1_id;
D303 := ack1_status;

D82 := seq;
Y30 := FALSE;

END_PROGRAM