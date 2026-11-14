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
    r0_latched : DINT := 0;
    r1_latched : DINT := 0;
    r0_state : DINT := 0;
    r1_state : DINT := 0;
    r0_origin : DINT := 1;
    r1_origin : DINT := 2;
    r0_cancel : BOOL := FALSE;
    r1_cancel : BOOL := FALSE;
    r0_status : DINT := 0;
    r1_status : DINT := 0;
    ack0_i : DINT := 0;
    stat0_i : DINT := 0;
    ack1_i : DINT := 0;
    stat1_i : DINT := 0;
    currentSlot : DINT := 0;
    reqID : DINT := 0;
    reqState : DINT := 0;
    reqOrigin : DINT := 1;
    reqCancel : BOOL := FALSE;
    desiredStation : DINT := 0;
    desiredAction : DINT := 0;
    portX : DINT := 0;
    portID : DINT := 0;
    portReady : BOOL := FALSE;
    liftDock : DINT := 95000;
    liftHome : DINT := 40000;
    shuttleTarget : DINT := 0;
    forkTarget : DINT := 0;
    liftTarget : DINT := 40000;
    s3t0 : DINT := -60000;
    s3t1 : DINT := -60000;
    s4t0 : DINT := 0;
    s4t1 : DINT := 0;
    s4t2 : DINT := 0;
    s3g0 : DINT := 0;
    s3g1 : DINT := 0;
    s4g0 : DINT := 0;
    s4g1 : DINT := 0;
    alignedA : BOOL := FALSE;
    forkIn : BOOL := FALSE;
    forkOut : BOOL := FALSE;
    liftAtDock : BOOL := FALSE;
    liftAtHome : BOOL := FALSE;
    s3Home : BOOL := FALSE;
    s4Home : BOOL := FALSE;
    stationMechReady : BOOL := FALSE;
    canStartCouple : BOOL := FALSE;
    coupleActive : BOOL := FALSE;
    coupleAction : DINT := 0;
    coupleStation : DINT := 0;
    coupleReq : DINT := 0;
    seq_i : DINT := 0;
    coupleDone : BOOL := FALSE;
    stationMoveActive : BOOL := FALSE;
    cell3Processing : BOOL := FALSE;
    cell4Processing : BOOL := FALSE;
    holdCell3 : BOOL := FALSE;
    holdCell4 : BOOL := FALSE;
    finalReady : BOOL := FALSE;
    finalDeclared : BOOL := FALSE;
    finalTimer : TON;
    theta0 : REAL := 0.0;
    theta1 : REAL := 0.0;
    cwMm : REAL := 0.0;
    momentArm : REAL := 0.0;
    rawReal : REAL := 0.0;
    tempD : DINT := 0;
    diffD : DINT := 0;
END_VAR

IF (D100 <> 0) AND ((r0_latched <> D100) AND ((r0_state = 0) OR (r0_state = 10))) THEN
    r0_latched := D100;
    r0_state := 1;
    r0_cancel := FALSE;
    r0_status := 1;
    ack0_i := 0;
    stat0_i := 0;
    IF (D101 = 1) OR (D101 = 2) THEN
        r0_origin := D101;
    ELSE
        r0_origin := 1;
    END_IF;
END_IF;

IF (D120 <> 0) AND ((r1_latched <> D120) AND ((r1_state = 0) OR (r1_state = 10))) THEN
    r1_latched := D120;
    r1_state := 1;
    r1_cancel := FALSE;
    r1_status := 1;
    ack1_i := 0;
    stat1_i := 0;
    IF (D121 = 1) OR (D121 = 2) THEN
        r1_origin := D121;
    ELSE
        r1_origin := 2;
    END_IF;
END_IF;

IF X31 AND (r0_state > 0) AND (r0_state < 10) THEN
    r0_cancel := TRUE;
    r0_status := 2;
END_IF;
IF X35 AND (r1_state > 0) AND (r1_state < 10) THEN
    r1_cancel := TRUE;
    r1_status := 2;
END_IF;

IF (currentSlot = 1) AND ((r0_state = 10) OR (r0_state = 0)) THEN
    currentSlot := 0;
END_IF;
IF (currentSlot = 2) AND ((r1_state = 10) OR (r1_state = 0)) THEN
    currentSlot := 0;
END_IF;

IF currentSlot = 0 THEN
    IF (r0_state > 0) AND (r0_state < 10) THEN
        currentSlot := 1;
    ELSIF (r1_state > 0) AND (r1_state < 10) THEN
        currentSlot := 2;
    END_IF;
END_IF;

reqID := 0;
reqState := 0;
reqOrigin := 1;
reqCancel := FALSE;

IF currentSlot = 1 THEN
    reqID := r0_latched;
    reqState := r0_state;
    reqOrigin := r0_origin;
    reqCancel := r0_cancel;
ELSIF currentSlot = 2 THEN
    reqID := r1_latched;
    reqState := r1_state;
    reqOrigin := r1_origin;
    reqCancel := r1_cancel;
END_IF;

IF D92 > 0 THEN
    liftDock := D92;
ELSE
    liftDock := 95000;
END_IF;
IF liftDock < 0 THEN
    liftDock := 0;
ELSIF liftDock > 120000 THEN
    liftDock := 120000;
END_IF;

desiredStation := 0;
desiredAction := 0;
stationMoveActive := FALSE;
cell3Processing := FALSE;
cell4Processing := FALSE;
liftTarget := liftHome;
shuttleTarget := 0;
forkTarget := 0;
s3t0 := -60000;
s3t1 := -60000;
s4t0 := 0;
s4t1 := 0;

IF currentSlot <> 0 THEN
    CASE reqState OF
        1:
            desiredStation := reqOrigin;
            desiredAction := 1;
            stationMoveActive := TRUE;
            liftTarget := liftDock;
        2:
            desiredStation := 3;
            desiredAction := 2;
            stationMoveActive := TRUE;
            liftTarget := liftDock;
        3:
            cell3Processing := TRUE;
            liftTarget := liftHome;
        4:
            desiredStation := 3;
            desiredAction := 1;
            stationMoveActive := TRUE;
            liftTarget := liftHome;
        5:
            desiredStation := 4;
            desiredAction := 2;
            stationMoveActive := TRUE;
            liftTarget := liftHome;
        6:
            cell4Processing := TRUE;
            liftTarget := liftHome;
        7:
            desiredStation := 4;
            desiredAction := 1;
            stationMoveActive := TRUE;
            liftTarget := liftHome;
        8:
            desiredStation := reqOrigin;
            desiredAction := 2;
            stationMoveActive := TRUE;
            liftTarget := liftDock;
        9:
            liftTarget := liftHome;
        ELSE
            liftTarget := liftHome;
    END_CASE;
END_IF;

CASE desiredStation OF
    1:
        portX := D403;
        portID := D404;
        portReady := X61;
    2:
        portX := D406;
        portID := D407;
        portReady := X62;
    3:
        portX := D409;
        portID := D410;
        portReady := X63;
    4:
        portX := D412;
        portID := D413;
        portReady := X64;
    ELSE
        portX := 0;
        portID := 0;
        portReady := FALSE;
END_CASE;

IF stationMoveActive THEN
    shuttleTarget := portX;
ELSE
    shuttleTarget := 0;
END_IF;

IF shuttleTarget < -450000 THEN
    shuttleTarget := -450000;
ELSIF shuttleTarget > 1461300 THEN
    shuttleTarget := 1461300;
END_IF;

alignedA := (ABS(D1000 - shuttleTarget) <= 20) AND (ABS(D1001) <= 100);
forkIn := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
forkOut := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
liftAtDock := (ABS(D1008 - liftDock) <= 20) AND (ABS(D1012 - liftDock) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100);
liftAtHome := (ABS(D1008 - liftHome) <= 20) AND (ABS(D1012 - liftHome) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100);
s3Home := (ABS(D1016 + 60000) <= 20) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100);
s4Home := (ABS(D1024) <= 20) AND (ABS(D1028) <= 20) AND (ABS(D1032) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100) AND (ABS(D1033) <= 100);

stationMechReady := FALSE;
IF (desiredStation = 1) OR (desiredStation = 2) THEN
    stationMechReady := portReady AND liftAtDock;
ELSIF desiredStation = 3 THEN
    stationMechReady := portReady AND s3Home;
ELSIF desiredStation = 4 THEN
    stationMechReady := portReady AND s4Home;
END_IF;

IF stationMoveActive AND alignedA AND stationMechReady THEN
    forkTarget := 18000;
ELSE
    forkTarget := 0;
END_IF;

canStartCouple := stationMoveActive AND alignedA AND stationMechReady AND forkOut AND (NOT coupleActive) AND (reqID <> 0);

IF canStartCouple THEN
    seq_i := seq_i + 1;
    IF seq_i > 2000000000 THEN
        seq_i := 1;
    END_IF;
    coupleActive := TRUE;
    coupleAction := desiredAction;
    coupleStation := desiredStation;
    coupleReq := reqID;
END_IF;

coupleDone := FALSE;
IF coupleActive THEN
    IF coupleAction = 1 THEN
        coupleDone := (D90 = coupleReq);
    ELSIF coupleAction = 2 THEN
        coupleDone := (D90 = 0);
    END_IF;
    IF coupleDone THEN
        coupleActive := FALSE;
    END_IF;
END_IF;

IF coupleActive THEN
    D80 := coupleAction;
    D81 := coupleStation;
ELSE
    D80 := 0;
    D81 := 0;
END_IF;
D82 := seq_i;

IF (currentSlot <> 0) THEN
    IF reqCancel AND (reqState = 3) THEN
        reqState := 4;
    ELSIF reqCancel AND (reqState = 6) THEN
        reqState := 7;
    END_IF;

    CASE reqState OF
        1:
            IF D90 = reqID THEN
                IF reqCancel THEN
                    reqState := 8;
                ELSE
                    reqState := 2;
                END_IF;
            END_IF;
        2:
            IF D90 = 0 THEN
                reqState := 3;
            END_IF;
        3:
            IF reqCancel THEN
                reqState := 4;
            ELSIF X70 THEN
                reqState := 4;
            END_IF;
        4:
            IF D90 = reqID THEN
                IF reqCancel THEN
                    reqState := 8;
                ELSE
                    reqState := 5;
                END_IF;
            END_IF;
        5:
            IF D90 = 0 THEN
                reqState := 6;
            END_IF;
        6:
            IF reqCancel THEN
                reqState := 7;
            ELSIF X75 THEN
                reqState := 7;
            END_IF;
        7:
            IF D90 = reqID THEN
                reqState := 8;
            END_IF;
        8:
            IF D90 = 0 THEN
                reqState := 9;
            END_IF;
        9:
            IF liftAtHome AND forkIn AND (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) THEN
                IF currentSlot = 1 THEN
                    ack0_i := r0_latched;
                    IF r0_cancel THEN
                        stat0_i := 2;
                    ELSE
                        stat0_i := 1;
                    END_IF;
                ELSIF currentSlot = 2 THEN
                    ack1_i := r1_latched;
                    IF r1_cancel THEN
                        stat1_i := 2;
                    ELSE
                        stat1_i := 1;
                    END_IF;
                END_IF;
                reqState := 10;
            END_IF;
    END_CASE;

    IF currentSlot = 1 THEN
        r0_state := reqState;
    ELSIF currentSlot = 2 THEN
        r1_state := reqState;
    END_IF;
END_IF;

D300 := ack0_i;
D301 := stat0_i;
D302 := ack1_i;
D303 := stat1_i;

IF cell3Processing THEN
    s3g0 := D500;
    s3g1 := D501;
    IF s3g0 < -95000 THEN
        s3g0 := -95000;
    ELSIF s3g0 > 95000 THEN
        s3g0 := 95000;
    END_IF;
    IF s3g1 < -95000 THEN
        s3g1 := -95000;
    ELSIF s3g1 > 95000 THEN
        s3g1 := 95000;
    END_IF;
    IF ABS(s3g0 - s3g1) > 300 THEN
        s3g1 := s3g0;
    END_IF;
    s3t0 := s3g0;
    s3t1 := s3g1;
END_IF;

IF cell4Processing THEN
    s4g0 := D600;
    s4g1 := D601;
    IF s4g0 < -5000 THEN
        s4g0 := -5000;
    ELSIF s4g0 > 5000 THEN
        s4g0 := 5000;
    END_IF;
    IF s4g1 < -5000 THEN
        s4g1 := -5000;
    ELSIF s4g1 > 5000 THEN
        s4g1 := 5000;
    END_IF;
    s4t0 := s4g0;
    s4t1 := s4g1;
END_IF;

theta0 := REAL(D1024) * 0.000174532925;
theta1 := REAL(D1028) * 0.000174532925;
cwMm := -225.0 * (SIN(theta0) + SIN(theta1));
rawReal := cwMm * 100.0;
s4t2 := DINT(ROUND(rawReal));
IF s4t2 < -45000 THEN
    s4t2 := -45000;
ELSIF s4t2 > 45000 THEN
    s4t2 := 45000;
END_IF;

IF (D1004 > 4000) AND stationMoveActive THEN
    D2000 := D1000;
ELSE
    D2000 := shuttleTarget;
END_IF;
IF D2000 < -450000 THEN
    D2000 := -450000;
ELSIF D2000 > 1461300 THEN
    D2000 := 1461300;
END_IF;

D2004 := forkTarget;
IF D2004 < 0 THEN
    D2004 := 0;
ELSIF D2004 > 18000 THEN
    D2004 := 18000;
END_IF;

IF liftTarget < 0 THEN
    liftTarget := 0;
ELSIF liftTarget > 120000 THEN
    liftTarget := 120000;
END_IF;

diffD := D1008 - D1012;
D2008 := liftTarget;
D2012 := liftTarget;
IF diffD > 6000 THEN
    D2008 := D1008;
ELSIF diffD < -6000 THEN
    D2012 := D1012;
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

diffD := D1016 - D1020;
D2016 := s3t0;
D2020 := s3t1;
IF diffD > 150 THEN
    D2016 := D10116;
END_IF;
END_PROGRAM