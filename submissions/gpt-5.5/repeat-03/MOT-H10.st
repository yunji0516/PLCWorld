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
    active : BOOL;
    activeChan : INT;
    activeId : DINT;
    activeStatus : DINT;
    originStation : DINT;
    stage : INT;
    opSub : INT;
    seq : DINT;
    connIssued : BOOL;
    seen0 : DINT;
    seen1 : DINT;
    done0 : BOOL;
    done1 : BOOL;
    ack0Store : DINT;
    ack1Store : DINT;
    stat0Store : DINT;
    stat1Store : DINT;
    reqCancel : BOOL;
    locTmp : DINT;
    originX : DINT;
    originReady : BOOL;
    originPortId : DINT;
    dockHeight : DINT;
    cmdA : DINT;
    cmdB : DINT;
    cmdC : DINT;
    cmdD : DINT;
    cmdS30 : DINT;
    cmdS31 : DINT;
    cmdS40 : DINT;
    cmdS41 : DINT;
    cmdS42 : DINT;
    rateA : DINT;
    rateB : DINT;
    rateC : DINT;
    rateD : DINT;
    rateS30 : DINT;
    rateS31 : DINT;
    rateS40 : DINT;
    rateS41 : DINT;
    rateS42 : DINT;
    readyA : BOOL;
    readyB : BOOL;
    readyC : BOOL;
    readyD : BOOL;
    readyS30 : BOOL;
    readyS31 : BOOL;
    readyS40 : BOOL;
    readyS41 : BOOL;
    readyS42 : BOOL;
    readyOriginLift : BOOL;
    readyHoistHome : BOOL;
    allHome : BOOL;
    liftStopped : BOOL;
    thetaRad : REAL;
    moment3 : REAL;
    xBalRaw : DINT;
    opAngle3 : DINT;
    opS40 : DINT;
    opS41 : DINT;
    opS42 : DINT;
    res3Cond : BOOL;
    res4Cond : BOOL;
    finalReady : BOOL;
    tConn : TON;
    tRes3 : TON;
    tRes4 : TON;
END_VAR

IF D100 <> seen0 THEN
    seen0 := D100;
    done0 := FALSE;
    ack0Store := 0;
    stat0Store := 0;
END_IF;

IF D120 <> seen1 THEN
    seen1 := D120;
    done1 := FALSE;
    ack1Store := 0;
    stat1Store := 0;
END_IF;

dockHeight := LIMIT(0, D92, 120000);

opAngle3 := LIMIT(-5000, D500, 5000);
thetaRad := REAL(D1016) * 0.000174532925;
xBalRaw := DINT(ROUND(-45000.0 * SIN(thetaRad)));
xBalRaw := LIMIT(-45000, xBalRaw, 45000);
moment3 := 0.1962 * (450.0 * SIN(thetaRad) + (REAL(D1020) * 0.01));

opS40 := LIMIT(50000, D600, 150000);
opS41 := LIMIT(-100000, D601, 100000);
opS42 := LIMIT(-3000, D602, 3000);

res3Cond := active AND (stage = 30) AND (opSub = 0) AND (ABS(D1016 - opAngle3) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) AND (ABS(moment3) <= 1.0);
res4Cond := active AND (stage = 60) AND (opSub = 0) AND (ABS(D1024 - opS40) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028 - opS41) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 3) AND (ABS(D1033) <= 15);

tConn(IN := connIssued, PT := T#1000ms);
tRes3(IN := res3Cond, PT := T#100ms);
tRes4(IN := res4Cond, PT := T#100ms);

IF NOT active THEN
    connIssued := FALSE;
    stage := 0;
    opSub := 0;
    activeStatus := 1;
    IF (D100 <> 0) AND NOT done0 THEN
        active := TRUE;
        activeChan := 0;
        activeId := D100;
        IF X31 THEN
            activeStatus := 2;
            stage := 85;
        ELSE
            activeStatus := 1;
            stage := 10;
        END_IF;
        locTmp := D101;
        IF locTmp = 0 THEN
            originStation := 1;
        ELSIF locTmp = 1 THEN
            originStation := 2;
        ELSE
            originStation := LIMIT(1, locTmp, 2);
        END_IF;
    ELSIF (D120 <> 0) AND NOT done1 THEN
        active := TRUE;
        activeChan := 1;
        activeId := D120;
        IF X35 THEN
            activeStatus := 2;
            stage := 85;
        ELSE
            activeStatus := 1;
            stage := 10;
        END_IF;
        locTmp := D121;
        IF locTmp = 0 THEN
            originStation := 1;
        ELSIF locTmp = 1 THEN
            originStation := 2;
        ELSE
            originStation := LIMIT(1, locTmp, 2);
        END_IF;
    END_IF;
END_IF;

IF originStation = 2 THEN
    originX := D406;
    originReady := X62;
    originPortId := D407;
ELSE
    originX := D403;
    originReady := X61;
    originPortId := D404;
END_IF;

IF active THEN
    IF activeChan = 0 THEN
        reqCancel := X31;
    ELSE
        reqCancel := X35;
    END_IF;

    IF reqCancel AND (activeStatus <> 2) THEN
        activeStatus := 2;
        connIssued := FALSE;
        opSub := 0;
        IF D90 = activeId THEN
            stage := 80;
        ELSIF (stage >= 50) AND (stage <= 70) THEN
            stage := 70;
        ELSIF (stage >= 20) AND (stage <= 40) THEN
            stage := 40;
        ELSE
            stage := 85;
        END_IF;
    END_IF;
END_IF;

cmdA := 0;
cmdB := 0;
cmdC := 15000;
cmdD := 15000;
cmdS30 := 0;
cmdS31 := 0;
cmdS40 := 100000;
cmdS41 := 0;
cmdS42 := 0;
rateA := 1000;
rateB := 1000;
rateC := 1000;
rateD := 1000;
rateS30 := 900;
rateS31 := 1000;
rateS40 := 200;
rateS41 := 200;
rateS42 := 1000;

D80 := 0;
D81 := 0;
D82 := seq;
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

IF active THEN
    CASE stage OF
    10:
        cmdA := originX;
        cmdB := 0;
        IF originStation = 1 THEN
            cmdC := dockHeight;
            cmdD := 15000;
        ELSE
            cmdC := 15000;
            cmdD := dockHeight;
        END_IF;

        readyA := (ABS(D1000 - cmdA) <= 20) AND (ABS(D1001) <= 100);
        readyB := (ABS(D1004 - cmdB) <= 20) AND (ABS(D1005) <= 100);
        readyOriginLift := originReady AND (((originStation = 1) AND (ABS(D1008 - dockHeight) <= 20) AND (ABS(D1009) <= 100)) OR ((originStation = 2) AND (ABS(D1012 - dockHeight) <= 20) AND (ABS(D1013) <= 100)));

        IF D90 = activeId THEN
            stage := 20;
            connIssued := FALSE;
        ELSIF readyA AND readyB AND readyOriginLift THEN
            IF NOT connIssued THEN
                seq := seq + 1;
                connIssued := TRUE;
            END_IF;
            D80 := 1;
            D81 := originStation;
            D82 := seq;
            IF (D90 = activeId) OR (tConn.Q AND connIssued) THEN
                stage := 20;
                connIssued := FALSE;
            END_IF;
        END_IF;

    20:
        cmdA := D409;
        cmdB := 18000;
        cmdS30 := 0;
        cmdS31 := 0;

        readyA := (ABS(D1000 - cmdA) <= 20) AND (ABS(D1001) <= 100);
        readyB := (ABS(D1004 - cmdB) <= 20) AND (ABS(D1005) <= 100);
        readyS30 := (ABS(D1016) <= 20) AND (ABS(D1017) <= 100);
        readyS31 := (ABS(D1020) <= 20) AND (ABS(D1021) <= 100);

        IF (D90 <> activeId) AND (D410 = activeId) THEN
            stage := 30;
            opSub := 0;
            connIssued := FALSE;
        ELSIF readyA AND readyB AND X63 AND readyS30 AND readyS31 THEN
            IF NOT connIssued THEN
                seq := seq + 1;
                connIssued := TRUE;
            END_IF;
            D80 := 2;
            D81 := 3;
            D82 := seq;
            IF ((D90 <> activeId) AND (D410 = activeId)) OR (tConn.Q AND connIssued) THEN
                stage := 30;
                opSub := 0;
                connIssued := FALSE;
            END_IF;
        END_IF;

    30:
        D700 := activeId;
        D701 := D526;
        D702 := 1000;
        Y70 := TRUE;

        IF opSub = 0 THEN
            cmdS30 := opAngle3;
            IF D501 = 0 THEN
                cmdS31 := xBalRaw;
            ELSE
                cmdS31 := LIMIT(-45000, D501, 45000);
            END_IF;
            IF X70 OR tRes3.Q THEN
                opSub := 1;
            END_IF;
        ELSE
            Y71 := TRUE;
            cmdS30 := 0;
            cmdS31 := xBalRaw;
            IF (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) THEN
                stage := 40;
                opSub := 0;
                connIssued := FALSE;
            END_IF;
        END_IF;

    40:
        cmdA := D409;
        cmdB := 0;
        cmdS30 := 0;
        cmdS31 := 0;

        readyA := (ABS(D1000 - cmdA) <= 20) AND (ABS(D1001) <= 100);
        readyB := (ABS(D1004 - cmdB) <= 20) AND (ABS(D1005) <= 100);
        readyS30 := (ABS(D1016) <= 20) AND (ABS(D1017) <= 100);
        readyS31 := (ABS(D1020) <= 20) AND (ABS(D1021) <= 100);

        IF D90 = activeId THEN
            IF activeStatus = 2 THEN
                stage := 80;
            ELSE
                stage := 50;
            END_IF;
            connIssued := FALSE;
        ELSIF readyA AND readyB AND X63 AND readyS30 AND readyS31 THEN
            IF NOT connIssued THEN
                seq := seq + 1;
                connIssued := TRUE;
            END_IF;
            D80 := 1;
            D81 := 3;
            D82 := seq;
            IF (D90 = activeId) OR (tConn.Q AND connIssued) THEN
                IF activeStatus = 2 THEN
                    stage := 80;
                ELSE
                    stage := 50;
                END_IF;
                connIssued := FALSE;
            END_IF;
        END_IF;

    50:
        cmdA := D412;
        cmdB := 18000;
        cmdS40 := 100000;
        cmdS41 := 0;
        cmdS42 := 0;

        readyA := (ABS(D1000 - cmdA) <= 20) AND (ABS(D1001) <= 100);
        readyB := (ABS(D1004 - cmdB) <= 20) AND (ABS(D1005) <= 100);
        readyHoistHome := (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 3) AND (ABS(D1033) <= 15);

        IF (D90 <> activeId) AND (D413 = activeId) THEN
            stage := 60;
            opSub := 0;
            connIssued := FALSE;
        ELSIF readyA AND readyB AND X64 AND readyHoistHome THEN
            IF NOT connIssued THEN
                seq := seq + 1;
                connIssued := TRUE;
            END_IF;
            D80 := 2;
            D81 := 4;
            D82 := seq;
            IF ((D90 <> activeId) AND (D413 = activeId)) OR (tConn.Q AND connIssued) THEN
                stage := 60;
                opSub := 0;
                connIssued := FALSE;
            END_IF;
        END_IF;

    60:
        D710 := activeId;
        D711 := D626;
        Y75 := TRUE;

        IF opSub = 0 THEN
            cmdS40 := opS40;
            cmdS41 := opS41;
            cmdS42 := 0;
            D712 := 1;
            IF X75 OR tRes4.Q THEN
                opSub := 1;
            END_IF;
        ELSE
            Y76 := TRUE;
            cmdS40 := 100000;
            cmdS41 := 0;
            cmdS42 := 0;
            D712 := 0;
            IF (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 3) AND (ABS(D1033) <= 15) THEN
                stage := 70;
                opSub := 0;
                connIssued := FALSE;
            END_IF;
        END_IF;

    70:
        cmdA := D412;
        cmdB := 0;
        cmdS40 := 100000;
        cmdS41 := 0;
        cmdS42 := 0;

        readyA := (ABS(D1000 - cmdA) <= 20) AND (ABS(D1001) <= 100);
        readyB := (ABS(D1004 - cmdB) <= 20) AND (ABS(D1005) <= 100);
        readyHoistHome := (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 3) AND (ABS(D1033) <= 15);

        IF D90 = activeId THEN
            stage := 80;
            connIssued := FALSE;
        ELSIF readyA AND readyB AND X64 AND readyHoistHome THEN
            IF NOT connIssued THEN
                seq := seq + 1;
                connIssued := TRUE;
            END_IF;
            D80 := 1;
            D81 := 4;
            D82 := seq;
            IF (D90 = activeId) OR (tConn.Q AND connIssued) THEN
                stage := 80;
                connIssued := FALSE;
            END_IF;
        END_IF;

    80:
        cmdA := originX;
        cmdB := 18000;
        IF originStation = 1 THEN
            cmdC := dockHeight;
            cmdD := 15000;
        ELSE
            cmdC := 15000;
            cmdD := dockHeight;
        END_IF;

        readyA := (ABS(D1000 - cmdA) <= 20) AND (ABS(D1001) <= 100);
        readyB := (ABS(D1004 - cmdB) <= 20) AND (ABS(D1005) <= 100);
        readyOriginLift := originReady AND (((originStation = 1) AND (ABS(D1008 - dockHeight) <= 20) AND (ABS(D1009) <= 100)) OR ((originStation = 2) AND (ABS(D1012 - dockHeight) <= 20) AND (ABS(D1013) <= 100)));

        IF (D90 <> activeId) AND (originPortId = activeId) THEN
            stage := 85;
            connIssued := FALSE;
        ELSIF readyA AND readyB AND readyOriginLift THEN
            IF NOT connIssued THEN
                seq := seq + 1;
                connIssued := TRUE;
            END_IF;
            D80 := 2;
            D81 := originStation;
            D82 := seq;
            IF ((D90 <> activeId) AND (originPortId = activeId)) OR (tConn.Q AND connIssued) THEN
                stage := 85;
                connIssued := FALSE;
            END_IF;
        END_IF;

    85:
        cmdA := 0;
        cmdB := 0;
        cmdC := 15000;
        cmdD := 15000;
        IF (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) THEN
            IF activeChan = 0 THEN
                ack0Store := activeId;
                stat0Store := activeStatus;
                done0 := TRUE;
            ELSE
                ack1Store := activeId;
                stat1Store := activeStatus;
                done1 := TRUE;
            END_IF;
            active := FALSE;
            stage := 0;
            opSub := 0;
            connIssued := FALSE;
        END_IF;

    ELSE
        stage := 85;
        connIssued := FALSE;
    END_CASE;
END_IF;

D2000 := LIMIT(-450000, cmdA, 1130000);
D2004 := LIMIT(0, cmdB, 18000);
D2008 := LIMIT(0, cmdC, 120000);
D2012 := LIMIT(0, cmdD, 120000);
D2016 := LIMIT(-5000, cmdS30, 5000);
D2020 := LIMIT(-45000, cmdS31, 45000);
D2024 := LIMIT(50000, cmdS40, 150000);
D2028 := LIMIT(-100000, cmdS41, 100000);
D2032 := LIMIT(-3000, cmdS42, 3000);

D2001 := LIMIT(0, rateA, 1000);
D2005 := LIMIT(0, rateB, 1000);
D2009 := LIMIT(0, rateC, 1000);
D2013 := LIMIT(0, rateD, 1000);
D2017 := LIMIT(0, rateS30, 1000);
D2021 := LIMIT(0, rateS31, 1000);
D2025 := LIMIT(0, rateS40, 1000);
D2029 := LIMIT(0, rateS41, 1000);
D2033 := LIMIT(0, rateS42, 1000);

D2002 := 0;
D2006 := 0;
D2010 := 0;
D2014 := 0;
D2018 := 0;
D2022 := 0;
D2026 := 0;
D2030 := 0;
D2034 := 0;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := FALSE;

liftStopped := (ABS(D1009) <= 100) AND (ABS(D1013) <= 100);
Y30 := liftStopped AND (ABS(D1008 - D2008) <= 20) AND (ABS(D1012 - D2012) <= 20);

D300 := ack0Store;
D301 := stat0Store;
D302 := ack1Store;
D303 := stat1Store;

allHome := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 3) AND (ABS(D1033) <= 15);

finalReady := X51 AND allHome AND NOT active;
Y2 := finalReady;

END_PROGRAM