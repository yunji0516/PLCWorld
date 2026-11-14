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
    active : BOOL := FALSE;
    currentReq : INT := 0;
    reqId : DINT := 0;
    originStation : INT := 1;
    moveStation : INT := 0;
    stationPos : DINT := 0;
    stationId : DINT := 0;
    stationReady : BOOL := FALSE;
    seqNo : DINT := 0;
    seqIssued : BOOL := FALSE;
    cancelFlag : BOOL := FALSE;
    ack0Val : DINT := 0;
    ack1Val : DINT := 0;
    ack0Status : DINT := 0;
    ack1Status : DINT := 0;
    initialized : BOOL := FALSE;
    dockTarget : DINT := 95000;
    liftDesired : DINT := 40000;
    liftCmd : DINT := 40000;
    gantryCmd : DINT := -60000;
    gantryDesired : DINT := -60000;
    gantryWorkTgt : DINT := 0;
    s4Tgt0 : DINT := 0;
    s4Tgt1 : DINT := 0;
    atStation : BOOL := FALSE;
    forkHome : BOOL := FALSE;
    forkConn : BOOL := FALSE;
    liftAtDock : BOOL := FALSE;
    liftAtHome : BOOL := FALSE;
    s3Home : BOOL := FALSE;
    s4Home : BOOL := FALSE;
    m3AtTarget : BOOL := FALSE;
    m4AtTarget : BOOL := FALSE;
    finalCond : BOOL := FALSE;
    liftCloseToCmd : BOOL := FALSE;
    gantryCloseToCmd : BOOL := FALSE;
    gantrySkewOk : BOOL := FALSE;
    t_m3 : TON;
    t_m4 : TON;
    t_final : TON;
END_VAR

IF NOT initialized THEN
    liftCmd := (D1008 + D1012) / 2;
    gantryCmd := (D1016 + D1020) / 2;
    initialized := TRUE;
END_IF;

dockTarget := LIMIT(0, D92, 120000);
IF dockTarget < 1000 THEN
    dockTarget := 95000;
END_IF;

gantryWorkTgt := LIMIT(-95000, D500, 95000);
s4Tgt0 := LIMIT(-95000, D600, 95000);
s4Tgt1 := LIMIT(-180000, D601, 180000);

IF active THEN
    IF currentReq = 0 THEN
        cancelFlag := cancelFlag OR X31;
    ELSE
        cancelFlag := cancelFlag OR X35;
    END_IF;
END_IF;

moveStation := 0;
CASE state OF
    20..50:
        moveStation := originStation;
    60..90:
        moveStation := 3;
    130..160:
        moveStation := 3;
    170..200:
        moveStation := 4;
    240..260:
        moveStation := 4;
    270..300:
        moveStation := originStation;
ELSE
    moveStation := 0;
END_CASE;

stationPos := 0;
stationReady := FALSE;
stationId := 0;
CASE moveStation OF
    1:
        stationPos := LIMIT(-450000, D403, 510000);
        stationReady := X61;
        stationId := D404;
    2:
        stationPos := LIMIT(-450000, D406, 510000);
        stationReady := X62;
        stationId := D407;
    3:
        stationPos := LIMIT(-450000, D409, 510000);
        stationReady := X63;
        stationId := D410;
    4:
        stationPos := LIMIT(-450000, D412, 510000);
        stationReady := X64;
        stationId := D413;
ELSE
        stationPos := 0;
        stationReady := FALSE;
        stationId := 0;
END_CASE;

liftDesired := 40000;
CASE state OF
    20..50:
        liftDesired := dockTarget;
    270..290:
        liftDesired := dockTarget;
ELSE
    liftDesired := 40000;
END_CASE;

liftCloseToCmd := (ABS(D1008 - liftCmd) <= 100) AND (ABS(D1012 - liftCmd) <= 100) AND (ABS(D1009) <= 500) AND (ABS(D1013) <= 500);
IF liftCloseToCmd THEN
    IF liftCmd < (liftDesired - 2000) THEN
        liftCmd := liftCmd + 2000;
    ELSIF liftCmd > (liftDesired + 2000) THEN
        liftCmd := liftCmd - 2000;
    ELSE
        liftCmd := liftDesired;
    END_IF;
END_IF;
liftCmd := LIMIT(0, liftCmd, 120000);

gantryDesired := -60000;
IF state = 110 THEN
    gantryDesired := gantryWorkTgt;
END_IF;

gantrySkewOk := ABS(D1016 - D1020) <= 250;
gantryCloseToCmd := (ABS(D1016 - gantryCmd) <= 80) AND (ABS(D1020 - gantryCmd) <= 80) AND (ABS(D1017) <= 1000) AND (ABS(D1021) <= 1000) AND gantrySkewOk;
IF gantryCloseToCmd THEN
    IF gantryCmd < (gantryDesired - 200) THEN
        gantryCmd := gantryCmd + 200;
    ELSIF gantryCmd > (gantryDesired + 200) THEN
        gantryCmd := gantryCmd - 200;
    ELSE
        gantryCmd := gantryDesired;
    END_IF;
END_IF;
gantryCmd := LIMIT(-95000, gantryCmd, 95000);

atStation := (moveStation <> 0) AND (ABS(D1000 - stationPos) <= 20) AND (ABS(D1001) <= 100);
forkHome := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
forkConn := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
liftAtDock := (ABS(D1008 - dockTarget) <= 20) AND (ABS(D1012 - dockTarget) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) AND (ABS(D1008 - D1012) <= 8000);
liftAtHome := (ABS(D1008 - 40000) <= 20) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) AND (ABS(D1008 - D1012) <= 8000);
s3Home := (ABS(D1016 + 60000) <= 20) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) AND (ABS(D1016 - D1020) <= 300);
s4Home := (ABS(D1024 + 60000) <= 20) AND (ABS(D1028 + 60000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100);
m3AtTarget := (ABS(D1016 - gantryWorkTgt) <= 20) AND (ABS(D1020 - gantryWorkTgt) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) AND (ABS(D1016 - D1020) <= 300);
m4AtTarget := (ABS(D1024 - s4Tgt0) <= 20) AND (ABS(D1028 - s4Tgt1) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100);

t_m3(IN := ((state = 110) AND m3AtTarget), PT := T#80ms);
t_m4(IN := ((state = 220) AND m4AtTarget), PT := T#80ms);

finalCond := (state = 0) AND (NOT active) AND X51 AND
             (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
             forkHome AND liftAtHome AND s3Home AND s4Home;
t_final(IN := finalCond, PT := T#100ms);

D2000 := 0;
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;
D2004 := 0;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;
D2008 := liftCmd;
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;
D2012 := liftCmd;
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;
D2016 := gantryCmd;
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;
D2020 := gantryCmd;
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;
D2024 := -60000;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;
D2028 := -60000;
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;
Y70 := FALSE;
Y71 := FALSE;
D700 := LIMIT(0, D520, 1);
D701 := D526;
D702 := 1000;
Y75 := FALSE;
Y76 := FALSE;
D710 := LIMIT(0, D620, 1);
D711 := D626;
D712 := 1000;
D80 := 0;
D81 := 0;
D82 := seqNo;
Y30 := finalCond;
Y2 := t_final.Q;

IF moveStation <> 0 THEN
    D2000 := stationPos;
END_IF;

D300 := ack0Val;
D301 := ack0Status;
D302 := ack1Val;
D303 := ack1Status;

CASE state OF
    0:
        seqIssued := FALSE;
        IF NOT active THEN
            IF (D100 <> 0) AND (ack0Val <> D100) THEN
                currentReq := 0;
                reqId := D100;
                originStation := INT(D101);
                IF (originStation < 1) OR (originStation > 2) THEN
                    originStation := 1;
                END_IF;
                cancelFlag := X31;
                active := TRUE;
                state := 20;
            ELSIF (D120 <> 0) AND (ack1Val <> D120) THEN
                currentReq := 1;
                reqId := D120;
                originStation := INT(D121);
                IF (originStation < 1) OR (originStation > 2) THEN
                    originStation := 2;
                END_IF;
                cancelFlag := X35;
                active := TRUE;
                state := 20;
            END_IF;
        END_IF;

    20:
        D2004 := 0;
        IF atStation AND forkHome AND liftAtDock AND stationReady AND ((stationId = reqId) OR (stationId = 0)) THEN
            state := 30;
        END_IF;

    30:
        D2004 := 18000;
        IF forkConn AND atStation AND liftAtDock THEN
            state := 40;
            seqIssued := FALSE;
        END_IF;

    40:
        D2004 := 18000;
        D80 := 1;
        D81 := DINT(moveStation);
        IF NOT seqIssued THEN
            seqNo := seqNo + 1;
            seqIssued := TRUE;
        END_IF;
        D82 := seqNo;
        IF D90 = reqId THEN
            seqIssued := FALSE;
            state := 50;
        END_IF;

    50:
        D2004 := 0;
        IF forkHome THEN
            IF cancelFlag THEN
                state := 270;
            ELSE
                state := 60;
            END_IF;
        END_IF;

    60:
        D2004 := 0;
        IF atStation AND forkHome AND s3Home AND stationReady AND ((stationId = 0) OR (stationId = reqId)) THEN
            state := 70;
        END_IF;

    70:
        D2004 := 18000;
        IF forkConn AND atStation AND s3Home THEN
            state := 80;
            seqIssued := FALSE;
        END_IF;

    80:
        D2004 := 18000;
        D80 := 2;
        D81 := 3;
        IF NOT seqIssued THEN
            seqNo := seqNo + 1;
            seqIssued := TRUE;
        END_IF;
        D82 := seqNo;
        IF (D90 <> reqId) AND ((stationId = reqId) OR (D90 = 0)) THEN
            seqIssued := FALSE;
            state := 90;
        END_IF;

    90:
        D2004 := 0;
        IF forkHome THEN
            state := 100;
        END_IF;

    100:
        Y70 := TRUE;
        Y71 := TRUE;
        IF s3Home THEN
            state := 110;
        END_IF;

    110:
        Y71 := TRUE;
        D2016 := gantryCmd;
        D2020 := gantryCmd;
        IF (m3AtTarget AND (X70 OR t_m3.Q)) OR cancelFlag THEN
            state := 120;
        END_IF;

    120:
        Y71 := TRUE;
        D2016 := gantryCmd;
        D2020 := gantryCmd;
        IF s3Home THEN
            state := 130;
        END_IF;

    130:
        D2004 := 0;
        IF atStation AND forkHome AND s3Home AND stationReady AND ((stationId = reqId) OR (stationId = 0)) THEN
            state := 140;
        END_IF;

    140:
        D2004 := 18000;
        IF forkConn AND atStation AND s3Home THEN
            state := 150;
            seqIssued := FALSE;
        END_IF;

    150:
        D2004 := 18000;
        D80 := 1;
        D81 := 3;
        IF NOT seqIssued THEN
            seqNo := seqNo + 1;
            seqIssued := TRUE;
        END_IF;
        D82 := seqNo;
        IF D90 = reqId THEN
            seqIssued := FALSE;
            state := 160;
        END_IF;

    160:
        D2004 := 0;
        IF forkHome THEN
            IF cancelFlag THEN
                state := 270;
            ELSE
                state := 170;
            END_IF;
        END_IF;

    170:
        D2004 := 0;
        IF atStation AND forkHome AND s4Home AND stationReady AND ((stationId = 0) OR (stationId = reqId)) THEN
            state := 180;
        END_IF;

    180:
        D2004 := 18000;
        IF forkConn AND atStation AND s4Home THEN
            state := 190;
            seqIssued := FALSE;
        END_IF;

    190:
        D2004 := 18000;
        D80 := 2;
        D81 := 4;
        IF NOT seqIssued THEN
            seqNo := seqNo + 1;
            seqIssued := TRUE;
        END_IF;
        D82 := seqNo;
        IF (D90 <> reqId) AND ((stationId = reqId) OR (D90 = 0)) THEN
            seqIssued := FALSE;
            state := 200;
        END_IF;

    200:
        D2004 := 0;
        IF forkHome THEN
            state := 210;
        END_IF;

    210:
        Y75 := TRUE;
        Y76 := TRUE;
        IF s4Home THEN
            state := 220;
        END_IF;

    220:
        Y76 := TRUE;
        D2024 := s4Tgt0;
        D2028 := s4Tgt1;
        IF (m4AtTarget AND (X75 OR t_m4.Q)) OR cancelFlag THEN
            state := 230;
        END_IF;

    230:
        Y76 := TRUE;
        D2024 := -60000;
        D2028 := -60000;
        IF s4Home THEN
            state := 240;
        END_IF;

    240:
        D2004 := 0;
        IF atStation AND forkHome AND s4Home AND stationReady AND ((stationId = reqId) OR (stationId = 0)) THEN
            state := 250;
        END_IF;

    250:
        D2004 := 18000;
        IF forkConn AND atStation AND s4Home THEN
            state := 260;
            seqIssued := FALSE;
        END_IF;

    260:
        D2004 := 18000;
        D80 := 1;
        D81 := 4;
        IF NOT seqIssued THEN
            seqNo := seqNo + 1;
            seqIssued := TRUE;
        END_IF;
        D82 := seqNo;
        IF D90 = reqId THEN
            seqIssued := FALSE;
            state := 270;
        END_IF;

    270:
        D2004 := 0;
        IF atStation AND forkHome AND liftAtDock AND stationReady AND ((stationId = 0) OR (stationId = reqId)) THEN
            state := 280;
        END_IF;

    280:
        D2004 := 18000;
        IF forkConn AND atStation AND liftAtDock THEN
            state := 290;
            seqIssued := FALSE;
        END_IF;

    290:
        D2004 := 18000;
        D80 := 2;
        D81 := DINT(originStation);
        IF NOT seqIssued THEN
            seqNo := seqNo + 1;
            seqIssued := TRUE;
        END_IF;
        D82 := seqNo;
        IF (D90 <> reqId) AND ((stationId = reqId) OR (D90 = 0)) THEN
            seqIssued := FALSE;
            state := 300;
        END_IF;

    300:
        D2004 := 0;
        IF forkHome AND liftAtHome THEN
            IF currentReq = 0 THEN
                ack0Val := reqId;
                IF cancelFlag THEN
                    ack0Status := 2;
                ELSE
                    ack0Status := 1;
                END_IF;
            ELSE
                ack1Val := reqId;
                IF cancelFlag THEN
                    ack1Status := 2;
                ELSE
                    ack1Status := 1;
                END_IF;
            END_IF;
            active := FALSE;
            reqId := 0;
            state := 0;
        END_IF;

ELSE
    state := 0;
END_CASE;

D300 := ack0Val;
D301 := ack0Status;
D302 := ack1Val;
D303 := ack1Status;
D82 := seqNo;

END_PROGRAM