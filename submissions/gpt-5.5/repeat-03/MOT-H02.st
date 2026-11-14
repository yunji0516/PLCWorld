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
    state : INT;
    lastState : INT;
    stateInit : BOOL;
    initialized : BOOL;
    seqIssued : BOOL;
    seqNo : DINT;
    reqIndex : INT;
    activeId : DINT;
    activeOrig : DINT;
    activeStatus : DINT;
    activeCancelled : BOOL;
    done0 : BOOL;
    done1 : BOOL;
    cmdA : DINT;
    cmdB : DINT;
    cmdC : DINT;
    cmdD : DINT;
    cmdS30 : DINT;
    cmdS31 : DINT;
    cmdS40 : DINT;
    cmdS41 : DINT;
    dockTarget : DINT;
    sourceHeight : DINT;
    goal30 : DINT;
    goal31 : DINT;
    goal40 : DINT;
    goal41 : DINT;
    atA : BOOL;
    atB : BOOL;
    atC : BOOL;
    atD : BOOL;
    atS3Home : BOOL;
    atS4Home : BOOL;
    atLiftDock : BOOL;
    atLiftHome : BOOL;
    atFinal : BOOL;
    sourceReady : BOOL;
    sourceHasId : BOOL;
    cond3 : BOOL;
    cond4 : BOOL;
    condFinal : BOOL;
    t3 : TON;
    t4 : TON;
    tfinal : TON;
END_VAR

IF NOT initialized THEN
    cmdA := 0;
    cmdB := 0;
    cmdC := 40000;
    cmdD := 40000;
    cmdS30 := -60000;
    cmdS31 := -60000;
    cmdS40 := -60000;
    cmdS41 := -60000;
    state := 0;
    lastState := -1;
    reqIndex := -1;
    activeStatus := 1;
    initialized := TRUE;
END_IF;

stateInit := state <> lastState;
IF stateInit THEN
    seqIssued := FALSE;
END_IF;

IF D92 < 0 THEN
    sourceHeight := 0;
ELSIF D92 > 120000 THEN
    sourceHeight := 120000;
ELSE
    sourceHeight := D92;
END_IF;

IF activeOrig = 2 THEN
    dockTarget := D406;
    sourceReady := X62;
    sourceHasId := D407 = activeId;
ELSE
    dockTarget := D403;
    sourceReady := X61;
    sourceHasId := D404 = activeId;
END_IF;

IF dockTarget < -450000 THEN
    dockTarget := -450000;
ELSIF dockTarget > 510000 THEN
    dockTarget := 510000;
END_IF;

IF reqIndex = 0 THEN
    activeCancelled := X31;
ELSIF reqIndex = 1 THEN
    activeCancelled := X35;
ELSE
    activeCancelled := FALSE;
END_IF;

D80 := 0;
D81 := 0;
Y70 := FALSE;
Y71 := FALSE;
Y75 := FALSE;
Y76 := FALSE;
cond3 := FALSE;
cond4 := FALSE;
condFinal := FALSE;

atB := (ABS(D1004 - cmdB) <= 20) AND (ABS(D1005) <= 100);
atC := (ABS(D1008 - cmdC) <= 20) AND (ABS(D1009) <= 100);
atD := (ABS(D1012 - cmdD) <= 20) AND (ABS(D1013) <= 100);
atA := (ABS(D1000 - cmdA) <= 20) AND (ABS(D1001) <= 100);
atLiftDock := (ABS(D1008 - sourceHeight) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - sourceHeight) <= 20) AND (ABS(D1013) <= 100);
atLiftHome := (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100);
atS3Home := (ABS(D1016 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1021) <= 100);
atS4Home := (ABS(D1024 + 60000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028 + 60000) <= 20) AND (ABS(D1029) <= 100);

CASE state OF
    0:
        cmdA := 0;
        cmdB := 0;
        cmdC := 40000;
        cmdD := 40000;
        cmdS30 := -60000;
        cmdS31 := -60000;
        cmdS40 := -60000;
        cmdS41 := -60000;
        reqIndex := -1;
        IF (NOT done0) AND (D100 <> 0) THEN
            reqIndex := 0;
            activeId := D100;
            IF D101 = 2 THEN
                activeOrig := 2;
            ELSE
                activeOrig := 1;
            END_IF;
            activeStatus := 1;
            state := 10;
        ELSIF (NOT done1) AND (D120 <> 0) THEN
            reqIndex := 1;
            activeId := D120;
            IF D121 = 2 THEN
                activeOrig := 2;
            ELSE
                activeOrig := 1;
            END_IF;
            activeStatus := 1;
            state := 10;
        ELSIF ((done0 OR (D100 = 0)) AND (done1 OR (D120 = 0))) THEN
            state := 900;
        END_IF;

    10:
        cmdA := dockTarget;
        cmdB := 0;
        cmdC := sourceHeight;
        cmdD := sourceHeight;
        cmdS30 := -60000;
        cmdS31 := -60000;
        cmdS40 := -60000;
        cmdS41 := -60000;
        IF atA AND atB AND atLiftDock AND sourceReady AND sourceHasId THEN
            state := 20;
        END_IF;

    20:
        cmdA := dockTarget;
        cmdB := 0;
        cmdC := sourceHeight;
        cmdD := sourceHeight;
        IF NOT seqIssued THEN
            seqNo := seqNo + 1;
            seqIssued := TRUE;
        END_IF;
        D80 := 1;
        D81 := activeOrig;
        IF D90 = activeId THEN
            state := 30;
        END_IF;

    30:
        cmdA := dockTarget;
        cmdB := 0;
        cmdC := sourceHeight;
        cmdD := sourceHeight;
        IF activeCancelled THEN
            activeStatus := 2;
            state := 300;
        ELSE
            activeStatus := 1;
            state := 40;
        END_IF;

    40:
        cmdA := D409;
        IF cmdA < -450000 THEN
            cmdA := -450000;
        ELSIF cmdA > 510000 THEN
            cmdA := 510000;
        END_IF;
        cmdB := 0;
        cmdC := sourceHeight;
        cmdD := sourceHeight;
        cmdS30 := -60000;
        cmdS31 := -60000;
        IF atA AND atB AND X63 AND atS3Home THEN
            state := 50;
        END_IF;

    50:
        cmdA := D409;
        IF cmdA < -450000 THEN
            cmdA := -450000;
        ELSIF cmdA > 510000 THEN
            cmdA := 510000;
        END_IF;
        cmdB := 18000;
        cmdS30 := -60000;
        cmdS31 := -60000;
        IF NOT seqIssued THEN
            seqNo := seqNo + 1;
            seqIssued := TRUE;
        END_IF;
        D80 := 2;
        D81 := 3;
        IF D410 = activeId THEN
            state := 55;
        END_IF;

    55:
        cmdB := 0;
        cmdS30 := -60000;
        cmdS31 := -60000;
        IF atB THEN
            state := 60;
        END_IF;

    60:
        cmdB := 0;
        cmdS30 := -60000;
        cmdS31 := -60000;
        IF D500 < -95000 THEN
            goal30 := -95000;
        ELSIF D500 > 95000 THEN
            goal30 := 95000;
        ELSE
            goal30 := D500;
        END_IF;
        IF D501 < -95000 THEN
            goal31 := -95000;
        ELSIF D501 > 95000 THEN
            goal31 := 95000;
        ELSE
            goal31 := D501;
        END_IF;
        D700 := D520;
        D701 := D526;
        D702 := 1000;
        IF atS3Home THEN
            Y70 := TRUE;
            state := 61;
        END_IF;

    61:
        Y71 := TRUE;
        D700 := D520;
        D701 := D526;
        D702 := 1000;
        cmdS30 := goal30;
        cmdS31 := goal31;
        cond3 := (ABS(D1016 - goal30) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - goal31) <= 20) AND (ABS(D1021) <= 100);
        IF X70 OR t3.Q THEN
            state := 70;
        END_IF;

    70:
        Y71 := TRUE;
        cmdS30 := -60000;
        cmdS31 := -60000;
        IF atS3Home THEN
            state := 80;
        END_IF;

    80:
        cmdA := D409;
        IF cmdA < -450000 THEN
            cmdA := -450000;
        ELSIF cmdA > 510000 THEN
            cmdA := 510000;
        END_IF;
        cmdB := 0;
        cmdS30 := -60000;
        cmdS31 := -60000;
        IF atA AND atB AND X63 AND atS3Home AND (D410 = activeId) THEN
            state := 81;
        END_IF;

    81:
        cmdA := D409;
        IF cmdA < -450000 THEN
            cmdA := -450000;
        ELSIF cmdA > 510000 THEN
            cmdA := 510000;
        END_IF;
        cmdB := 0;
        cmdS30 := -60000;
        cmdS31 := -60000;
        IF NOT seqIssued THEN
            seqNo := seqNo + 1;
            seqIssued := TRUE;
        END_IF;
        D80 := 1;
        D81 := 3;
        IF D90 = activeId THEN
            state := 90;
        END_IF;

    90:
        cmdA := D412;
        IF cmdA < -450000 THEN
            cmdA := -450000;
        ELSIF cmdA > 510000 THEN
            cmdA := 510000;
        END_IF;
        cmdB := 0;
        cmdS40 := -60000;
        cmdS41 := -60000;
        IF atA AND atB AND X64 AND atS4Home THEN
            state := 100;
        END_IF;

    100:
        cmdA := D412;
        IF cmdA < -450000 THEN
            cmdA := -450000;
        ELSIF cmdA > 510000 THEN
            cmdA := 510000;
        END_IF;
        cmdB := 18000;
        cmdS40 := -60000;
        cmdS41 := -60000;
        IF NOT seqIssued THEN
            seqNo := seqNo + 1;
            seqIssued := TRUE;
        END_IF;
        D80 := 2;
        D81 := 4;
        IF D413 = activeId THEN
            state := 105;
        END_IF;

    105:
        cmdB := 0;
        cmdS40 := -60000;
        cmdS41 := -60000;
        IF atB THEN
            state := 110;
        END_IF;

    110:
        cmdB := 0;
        cmdS40 := -60000;
        cmdS41 := -60000;
        IF D600 < -95000 THEN
            goal40 := -95000;
        ELSIF D600 > 95000 THEN
            goal40 := 95000;
        ELSE
            goal40 := D600;
        END_IF;
        IF D601 < -180000 THEN
            goal41 := -180000;
        ELSIF D601 > 180000 THEN
            goal41 := 180000;
        ELSE
            goal41 := D601;
        END_IF;
        D710 := D620;
        D711 := D626;
        D712 := 1000;
        IF atS4Home THEN
            Y75 := TRUE;
            state := 111;
        END_IF;

    111:
        Y76 := TRUE;
        D710 := D620;
        D711 := D626;
        D712 := 1000;
        cmdS40 := goal40;
        cmdS41 := goal41;
        cond4 := (ABS(D1024 - goal40) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028 - goal41) <= 20) AND (ABS(D1029) <= 100);
        IF X75 OR t4.Q THEN
            state := 120;
        END_IF;

    120:
        Y76 := TRUE;
        cmdS40 := -60000;
        cmdS41 := -60000;
        IF atS4Home THEN
            state := 130;
        END_IF;

    130:
        cmdA := D412;
        IF cmdA < -450000 THEN
            cmdA := -450000;
        ELSIF cmdA > 510000 THEN
            cmdA := 510000;
        END_IF;
        cmdB := 0;
        cmdS40 := -60000;
        cmdS41 := -60000;
        IF atA AND atB AND X64 AND atS4Home AND (D413 = activeId) THEN
            state := 131;
        END_IF;

    131:
        cmdA := D412;
        IF cmdA < -450000 THEN
            cmdA := -450000;
        ELSIF cmdA > 510000 THEN
            cmdA := 510000;
        END_IF;
        cmdB := 0;
        cmdS40 := -60000;
        cmdS41 := -60000;
        IF NOT seqIssued THEN
            seqNo := seqNo + 1;
            seqIssued := TRUE;
        END_IF;
        D80 := 1;
        D81 := 4;
        IF D90 = activeId THEN
            state := 300;
        END_IF;

    300:
        cmdA := dockTarget;
        cmdB := 0;
        cmdC := sourceHeight;
        cmdD := sourceHeight;
        IF atA AND atB AND atLiftDock AND sourceReady THEN
            state := 310;
        END_IF;

    310:
        cmdA := dockTarget;
        cmdB := 18000;
        cmdC := sourceHeight;
        cmdD := sourceHeight;
        IF NOT seqIssued THEN
            seqNo := seqNo + 1;
            seqIssued := TRUE;
        END_IF;
        D80 := 2;
        D81 := activeOrig;
        IF sourceHasId THEN
            state := 320;
        END_IF;

    320:
        cmdA := dockTarget;
        cmdB := 0;
        cmdC := 40000;
        cmdD := 40000;
        IF atB AND atLiftHome THEN
            IF reqIndex = 0 THEN
                D300 := activeId;
                D301 := activeStatus;
                done0 := TRUE;
            ELSIF reqIndex = 1 THEN
                D302 := activeId;
                D303 := activeStatus;
                done1 := TRUE;
            END_IF;
            state := 0;
        END_IF;

    900:
        cmdA := 0;
        cmdB := 0;
        cmdC := 40000;
        cmdD := 40000;
        cmdS30 := -60000;
        cmdS31 := -60000;
        cmdS40 := -60000;
        cmdS41 := -60000;

    ELSE
        state := 0;
END_CASE;

t3(IN := cond3, PT := T#100ms);
t4(IN := cond4, PT := T#100ms);

atFinal := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
           (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
           (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) AND
           (ABS(D1016 + 60000) <= 20) AND (ABS(D1017) <= 100) AND
           (ABS(D1020 + 60000) <= 20) AND (ABS(D1021) <= 100) AND
           (ABS(D1024 + 60000) <= 20) AND (ABS(D1025) <= 100) AND
           (ABS(D1028 + 60000) <= 20) AND (ABS(D1029) <= 100);

condFinal := (state = 900) AND X51 AND ((done0 OR (D100 = 0)) AND (done1 OR (D120 = 0))) AND atFinal;
tfinal(IN := condFinal, PT := T#100ms);
Y2 := tfinal.Q;

IF cmdA < -450000 THEN
    cmdA := -450000;
ELSIF cmdA > 510000 THEN
    cmdA := 510000;
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
IF cmdS40 < -95000 THEN
    cmdS40 := -95000;
ELSIF cmdS40 > 95000 THEN
    cmdS40 := 95000;
END_IF;
IF cmdS41 < -180000 THEN
    cmdS41 := -180000;
ELSIF cmdS41 > 180000 THEN
    cmdS41 := 180000;
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

D82 := seqNo;
Y30 := Y2;

lastState := state;

END_PROGRAM