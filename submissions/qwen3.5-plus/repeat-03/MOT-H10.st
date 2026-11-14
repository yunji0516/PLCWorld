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

    nStep : INT := 0;
    nActiveReq : INT := 0;
    bReq0Done : BOOL := FALSE;
    bReq1Done : BOOL := FALSE;
    rTgtA : REAL := 0.0;
    rTgtB : REAL := 0.0;
    rTgtC : REAL := 150.0;
    rTgtD : REAL := 150.0;
    rTgtS3_0 : REAL := 0.0;
    rTgtS3_1 : REAL := 0.0;
    rTgtS4_0 : REAL := 1000.0;
    rTgtS4_1 : REAL := 0.0;
    rTgtS4_2 : REAL := 0.0;
    bBrakeCmd : BOOL := TRUE;
    nSeqNum : DINT := 0;
    bAck0Sent : BOOL := FALSE;
    bAck1Sent : BOOL := FALSE;
    tBrake : TON;
    tSettle : TON;
    tResult : TON;
    tHold : TON;
    tBrakeOpen : TON;
    tBrakeClose : TON;
    eR0New : R_TRIG;
    eR1New : R_TRIG;
    cHomeA : REAL := 0.0;
    cHomeB : REAL := 0.0;
    cHomeC : REAL := 150.0;
    cHomeD : REAL := 150.0;
    cHomeS30 : REAL := 0.0;
    cHomeS31 : REAL := 0.0;
    cHomeS40 : REAL := 1000.0;
    cHomeS41 : REAL := 0.0;
    cHomeS42 : REAL := 0.0;
    cDockC : REAL := 732.5;
    cDockD : REAL := 732.5;
    cConnB : REAL := 180.0;
    cRetB : REAL := 0.0;
    cStn1A : REAL := -3600.0;
    cStn2A : REAL := -2300.0;
    cStn3A : REAL := 2300.0;
    cStn4A : REAL := 9900.0;
    cRate : DINT := 600;
    cScale : REAL := 100.0;
    nReqLoc : INT := 0;
    nReqIdVal : DINT := 0;
    nReqDueVal : DINT := 0;
    bBrakeRequested : BOOL := TRUE;
    bLiftStopped : BOOL := FALSE;
    bResultHeld : BOOL := FALSE;
    nResultHoldStep : INT := 0;
    bCell3Done : BOOL := FALSE;
    bCell4Done : BOOL := FALSE;
    rS3_0_Angle : REAL := 0.0;
    rS3_1_CW : REAL := 0.0;
    rMoment : REAL := 0.0;
    bMomentOK : BOOL := FALSE;
    bSwayOK : BOOL := FALSE;
    bAllPositionsHome : BOOL := FALSE;
END_VAR

rTgtA := cHomeA;
rTgtB := cRetB;
rTgtC := cHomeC;
rTgtD := cHomeD;
rTgtS3_0 := cHomeS30;
rTgtS3_1 := cHomeS31;
rTgtS4_0 := cHomeS40;
rTgtS4_1 := cHomeS41;
rTgtS4_2 := cHomeS42;
bBrakeCmd := TRUE;
bBrakeRequested := TRUE;

eR0New(CLK := X31);
eR1New(CLK := X35);

bLiftStopped := (ABS(D1009) <= 100) AND (ABS(D1013) <= 100);
IF bLiftStopped THEN
    bBrakeCmd := bBrakeRequested;
ELSE
    IF bBrakeRequested THEN
        bBrakeCmd := TRUE;
    END_IF;
END_IF;

CASE nStep OF
    0:
        IF NOT bReq0Done AND (D102 >= 1) AND (D102 < 7) AND (NOT bAck0Sent) THEN
            nStep := 1;
            nActiveReq := 0;
            nReqIdVal := D100;
            nReqLoc := D101;
            nReqDueVal := D103;
            nSeqNum := nSeqNum + 1;
            bReq0Done := FALSE;
            bCell3Done := FALSE;
            bCell4Done := FALSE;
        ELSIF NOT bReq1Done AND (D122 >= 1) AND (D122 < 7) AND (NOT bAck1Sent) THEN
            nStep := 1;
            nActiveReq := 1;
            nReqIdVal := D120;
            nReqLoc := D121;
            nReqDueVal := D123;
            nSeqNum := nSeqNum + 1;
            bReq1Done := FALSE;
            bCell3Done := FALSE;
            bCell4Done := FALSE;
        END_IF;

    1:
        rTgtC := cDockC;
        rTgtD := cDockD;
        bBrakeRequested := FALSE;
        IF (ABS(REAL(D1008)/cScale - cDockC) < 0.2) AND (ABS(REAL(D1012)/cScale - cDockD) < 0.2) THEN
            tBrakeOpen(IN := bLiftStopped, PT := T#80ms);
            IF tBrakeOpen.Q THEN
                nStep := 2;
            END_IF;
        END_IF;

    2:
        IF nReqLoc = 1 THEN
            rTgtA := cStn1A;
        ELSIF nReqLoc = 2 THEN
            rTgtA := cStn2A;
        END_IF;
        bBrakeRequested := FALSE;
        IF ABS(REAL(D1000)/cScale - rTgtA) < 0.2 THEN
            nStep := 3;
        END_IF;

    3:
        rTgtB := cConnB;
        IF ABS(REAL(D1004)/cScale - cConnB) < 0.2 THEN
            nStep := 4;
        END_IF;

    4:
        rTgtA := cStn3A;
        bBrakeRequested := FALSE;
        IF ABS(REAL(D1000)/cScale - cStn3A) < 0.2 THEN
            nStep := 5;
        END_IF;

    5:
        rTgtS3_0 := REAL(D500)/cScale;
        rTgtS3_1 := REAL(D501)/cScale;
        IF rTgtS3_1 = 0.0 THEN
            rTgtS3_1 := -450.0 * SIN(rTgtS3_0 / 57.2957795);
        END_IF;
        rMoment := 20.0 * 9.81 / 1000.0 * (450.0 * SIN(rTgtS3_0 / 57.2957795) + rTgtS3_1);
        bMomentOK := ABS(rMoment) < 1.0;
        IF bMomentOK AND X72 THEN
            nResultHoldStep := 0;
            nStep := 6;
        END_IF;

    6:
        rTgtS3_0 := REAL(D500)/cScale;
        rTgtS3_1 := REAL(D501)/cScale;
        IF rTgtS3_1 = 0.0 THEN
            rTgtS3_1 := -450.0 * SIN(rTgtS3_0 / 57.2957795);
        END_IF;
        nResultHoldStep := nResultHoldStep + 1;
        IF nResultHoldStep >= 4 THEN
            bCell3Done := TRUE;
            nStep := 7;
        END_IF;

    7:
        rTgtA := cStn4A;
        bBrakeRequested := FALSE;
        IF ABS(REAL(D1000)/cScale - cStn4A) < 0.2 THEN
            nStep := 8;
        END_IF;

    8:
        rTgtS4_0 := REAL(D600)/cScale;
        rTgtS4_1 := REAL(D601)/cScale;
        rTgtS4_2 := REAL(D602)/cScale;
        bSwayOK := (ABS(REAL(D1032)/cScale) < 0.03) AND (ABS(REAL(D1033)/cScale) < 0.15);
        IF bSwayOK AND X77 THEN
            nResultHoldStep := 0;
            nStep := 9;
        END_IF;

    9:
        rTgtS4_0 := REAL(D600)/cScale;
        rTgtS4_1 := REAL(D601)/cScale;
        rTgtS4_2 := REAL(D602)/cScale;
        bSwayOK := (ABS(REAL(D1032)/cScale) < 0.03) AND (ABS(REAL(D1033)/cScale) < 0.15);
        nResultHoldStep := nResultHoldStep + 1;
        IF nResultHoldStep >= 4 AND bSwayOK THEN
            bCell4Done := TRUE;
            nStep := 10;
        END_IF;

    10:
        IF nReqLoc = 1 THEN
            rTgtA := cStn1A;
        ELSIF nReqLoc = 2 THEN
            rTgtA := cStn2A;
        END_IF;
        bBrakeRequested := FALSE;
        IF ABS(REAL(D1000)/cScale - rTgtA) < 0.2 THEN
            nStep := 11;
        END_IF;

    11:
        rTgtB := cRetB;
        IF ABS(REAL(D1004)/cScale) < 0.2 THEN
            nStep := 12;
        END_IF;

    12:
        rTgtC := cHomeC;
        rTgtD := cHomeD;
        bBrakeRequested := TRUE;
        IF (ABS(REAL(D1008)/cScale - cHomeC) < 0.2) AND (ABS(REAL(D1012)/cScale - cHomeD) < 0.2) THEN
            tBrakeClose(IN := bLiftStopped, PT := T#80ms);
            IF tBrakeClose.Q THEN
                nStep := 13;
            END_IF;
        END_IF;

    13:
        rTgtC := cHomeC;
        rTgtD := cHomeD;
        bBrakeRequested := TRUE;
        IF bLiftStopped THEN
            IF nActiveReq = 0 THEN
                D300 := nReqIdVal;
                D301 := 1;
                bAck0Sent := TRUE;
                bReq0Done := TRUE;
            ELSIF nActiveReq = 1 THEN
                D302 := nReqIdVal;
                D303 := 1;
                bAck1Sent := TRUE;
                bReq1Done := TRUE;
            END_IF;
            nStep := 0;
        END_IF;
END_CASE;

IF X31 AND (NOT bAck0Sent) AND (nStep = 0) AND (nActiveReq <> 0) THEN
    D300 := nReqIdVal;
    D301 := 2;
    bAck0Sent := TRUE;
    bReq0Done := TRUE;
    nStep := 0;
END_IF;

IF X35 AND (NOT bAck1Sent) AND (nStep = 0) AND (nActiveReq <> 1) THEN
    D302 := nReqIdVal;
    D303 := 2;
    bAck1Sent := TRUE;
    bReq1Done := TRUE;
    nStep := 0;
END_IF;

D2000 := DINT(rTgtA * cScale);
D2001 := cRate;
D2002 := 0;
Y40 := TRUE;

D2004 := DINT(rTgtB * cScale);
D2005 := cRate;
D2006 := 0;
Y41 := TRUE;

D2008 := DINT(rTgtC * cScale);
D2009 := cRate;
D2010 := 0;
Y42 := TRUE;

D2012 := DINT(rTgtD * cScale);
D2013 := cRate;
D2014 := 0;
Y43 := TRUE;

D2016 := DINT(rTgtS3_0 * cScale);
D2017 := cRate;
D2018 := 0;
Y44 := (nStep >= 5) AND (nStep <= 9);

D2020 := DINT(rTgtS3_1 * cScale);
D2021 := cRate;
D2022 := 0;
Y45 := (nStep >= 5) AND (nStep <= 9);

D2024 := DINT(rTgtS4_0 * cScale);
D2025 := cRate;
D2026 := 0;
Y46 := (nStep >= 8) AND (nStep <= 12);

D2028 := DINT(rTgtS4_1 * cScale);
D2029 := cRate;
D2030 := 0;
Y47 := (nStep >= 8) AND (nStep <= 12);

D2032 := DINT(rTgtS4_2 * cScale);
D2033 := cRate;
D2034 := 0;
Y48 := (nStep >= 8) AND (nStep <= 12);

Y30 := bBrakeCmd;

D80 := 0;
D81 := nReqLoc;
D82 := nSeqNum;

IF nStep = 0 THEN
    rTgtA := cHomeA;
    rTgtB := cRetB;
    rTgtC := cHomeC;
    rTgtD := cHomeD;
    rTgtS3_0 := cHomeS30;
    rTgtS3_1 := cHomeS31;
    rTgtS4_0 := cHomeS40;
    rTgtS4_1 := cHomeS41;
    rTgtS4_2 := cHomeS42;
    bBrakeRequested := TRUE;
END_IF;

D2000 := DINT(rTgtA * cScale);
D2004 := DINT(rTgtB * cScale);
D2008 := DINT(rTgtC * cScale);
D2012 := DINT(rTgtD * cScale);
D2016 := DINT(rTgtS3_0 * cScale);
D2020 := DINT(rTgtS3_1 * cScale);
D2024 := DINT(rTgtS4_0 * cScale);
D2028 := DINT(rTgtS4_1 * cScale);
D2032 := DINT(rTgtS4_2 * cScale);

Y70 := (nStep >= 5) AND (nStep <= 9);
Y71 := (nStep >= 5) AND (nStep <= 9);
D700 := nReqLoc;
D701 := nReqLoc;
D702 := cRate;

Y75 := (nStep >= 8) AND (nStep <= 12);
Y76 := (nStep >= 8) AND (nStep <= 12);
D710 := nReqLoc;
D711 := nReqLoc;
D712 := cRate;

bAllPositionsHome := (ABS(REAL(D1000)/cScale) < 0.2) AND (ABS(REAL(D1004)/cScale) < 0.2) AND
    (ABS(REAL(D1008)/cScale - cHomeC) < 0.2) AND (ABS(REAL(D1012)/cScale - cHomeD) < 0.2) AND
    (ABS(REAL(D1016)/cScale) < 0.2) AND (ABS(REAL(D1020)/cScale) < 0.2) AND
    (ABS(REAL(D1024)/cScale - cHomeS40) < 0.2) AND (ABS(REAL(D1028)/cScale) < 0.2) AND
    (ABS(REAL(D1032)/cScale) < 0.03) AND (ABS(REAL(D1033)/cScale) < 0.15);

IF (bReq0Done AND bAck0Sent) AND (bReq1Done AND bAck1Sent) AND bAllPositionsHome AND bBrakeCmd THEN
    tHold(IN := TRUE, PT := T#100ms);
    Y2 := tHold.Q;
ELSE
    tHold(IN := FALSE);
    Y2 := FALSE;
END_IF;

END_PROGRAM