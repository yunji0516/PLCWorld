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
    initDone : BOOL;
    state : INT;
    prevState : INT;
    curIndex : INT;
    curId : DINT;
    curSource : INT;
    curCancel : BOOL;
    r0Done : BOOL;
    r1Done : BOOL;
    ack0Val : DINT;
    stat0Val : DINT;
    ack1Val : DINT;
    stat1Val : DINT;
    seq : DINT;
    cmdIssued : BOOL;
    targetStation : INT;
    portX : DINT;
    portId : DINT;
    portReady : BOOL;
    sourceDock : DINT;
    liftDesired : DINT;
    liftCmd : DINT;
    s3Desired : DINT;
    s3Cmd : DINT;
    s3Goal : DINT;
    s4Desired0 : DINT;
    s4Desired1 : DINT;
    s4Cmd0 : DINT;
    s4Cmd1 : DINT;
    bDesired : DINT;
    aDesired : DINT;
    cell3Ok : BOOL;
    cell4Ok : BOOL;
    finalStable : BOOL;
    completionLatched : BOOL;
    configCnt : INT;
    tCell3 : TON;
    tCell4 : TON;
    tFinal : TON;
END_VAR

IF NOT initDone THEN
    initDone := TRUE;
    state := 0;
    prevState := -1;
    liftCmd := D1008;
    s3Cmd := (D1016 + D1020) / 2;
    s4Cmd0 := D1024;
    s4Cmd1 := D1028;
    seq := 0;
END_IF;

IF state <> prevState THEN
    cmdIssued := FALSE;
    configCnt := 0;
    prevState := state;
END_IF;

sourceDock := D92;
IF sourceDock < 0 THEN
    sourceDock := 0;
ELSIF sourceDock > 120000 THEN
    sourceDock := 120000;
END_IF;

D80 := 0;
D81 := 0;
D82 := seq;
Y70 := FALSE;
Y71 := FALSE;
Y75 := FALSE;
Y76 := FALSE;

D2001 := 1000;
D2002 := 0;
D2005 := 1000;
D2006 := 0;
D2009 := 1000;
D2010 := 0;
D2013 := 1000;
D2014 := 0;
D2017 := 1000;
D2018 := 0;
D2021 := 1000;
D2022 := 0;
D2025 := 1000;
D2026 := 0;
D2029 := 1000;
D2030 := 0;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;

D700 := D520;
D701 := D526;
D702 := 1000;
D710 := D620;
D711 := D626;
D712 := 1000;

D300 := ack0Val;
D301 := stat0Val;
D302 := ack1Val;
D303 := stat1Val;

targetStation := 0;

CASE state OF
    20, 30, 31, 32, 100, 101, 102, 103:
        targetStation := curSource;
    40, 41, 42, 43, 50, 51, 60, 61, 62, 63:
        targetStation := 3;
    70, 71, 72, 73, 80, 81, 82, 90, 91, 92, 93:
        targetStation := 4;
ELSE
    targetStation := 0;
END_CASE;

CASE targetStation OF
    1:
        portX := D403;
        portId := D404;
        portReady := X61;
    2:
        portX := D406;
        portId := D407;
        portReady := X62;
    3:
        portX := D409;
        portId := D410;
        portReady := X63;
    4:
        portX := D412;
        portId := D413;
        portReady := X64;
ELSE
    portX := 0;
    portId := 0;
    portReady := FALSE;
END_CASE;

aDesired := 0;
IF targetStation <> 0 THEN
    aDesired := portX;
END_IF;

bDesired := 0;
CASE state OF
    30, 31, 41, 42, 61, 62, 71, 72, 91, 92, 101, 102:
        bDesired := 18000;
ELSE
    bDesired := 0;
END_CASE;

liftDesired := 40000;
CASE state OF
    10..102:
        liftDesired := sourceDock;
ELSE
    liftDesired := 40000;
END_CASE;

s3Goal := (D500 + D501) / 2;
s3Desired := -60000;
CASE state OF
    50:
        s3Desired := s3Goal;
ELSE
    s3Desired := -60000;
END_CASE;

s4Desired0 := -60000;
s4Desired1 := -60000;
CASE state OF
    80:
        s4Desired0 := -60000;
        s4Desired1 := D601;
    81:
        s4Desired0 := D600;
        s4Desired1 := D601;
ELSE
    s4Desired0 := -60000;
    s4Desired1 := -60000;
END_CASE;

IF liftCmd < (liftDesired - 100) THEN
    liftCmd := liftCmd + 100;
ELSIF liftCmd > (liftDesired + 100) THEN
    liftCmd := liftCmd - 100;
ELSE
    liftCmd := liftDesired;
END_IF;

IF s3Cmd < (s3Desired - 100) THEN
    s3Cmd := s3Cmd + 100;
ELSIF s3Cmd > (s3Desired + 100) THEN
    s3Cmd := s3Cmd - 100;
ELSE
    s3Cmd := s3Desired;
END_IF;

IF s4Cmd0 < (s4Desired0 - 300) THEN
    s4Cmd0 := s4Cmd0 + 300;
ELSIF s4Cmd0 > (s4Desired0 + 300) THEN
    s4Cmd0 := s4Cmd0 - 300;
ELSE
    s4Cmd0 := s4Desired0;
END_IF;

IF s4Cmd1 < (s4Desired1 - 300) THEN
    s4Cmd1 := s4Cmd1 + 300;
ELSIF s4Cmd1 > (s4Desired1 + 300) THEN
    s4Cmd1 := s4Cmd1 - 300;
ELSE
    s4Cmd1 := s4Desired1;
END_IF;

D2000 := aDesired;
D2004 := bDesired;
D2008 := liftCmd;
D2012 := liftCmd;
D2016 := s3Cmd;
D2020 := s3Cmd;
D2024 := s4Cmd0;
D2028 := s4Cmd1;

IF D2000 < -450000 THEN
    D2000 := -450000;
ELSIF D2000 > 510000 THEN
    D2000 := 510000;
END_IF;
IF D2004 < 0 THEN
    D2004 := 0;
ELSIF D2004 > 18000 THEN
    D2004 := 18000;
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
IF D2016 < -95000 THEN
    D2016 := -95000;
ELSIF D2016 > 95000 THEN
    D2016 := 95000;
END_IF;
IF D2020 < -95000 THEN
    D2020 := -95000;
ELSIF D2020 > 95000 THEN
    D2020 := 95000;
END_IF;
IF D2024 < -95000 THEN
    D2024 := -95000;
ELSIF D2024 > 95000 THEN
    D2024 := 95000;
END_IF;
IF D2028 < -180000 THEN
    D2028 := -180000;
ELSIF D2028 > 180000 THEN
    D2028 := 180000;
END_IF;

IF state = 50 THEN
    Y71 := TRUE;
END_IF;
IF state = 81 THEN
    Y76 := TRUE;
END_IF;

IF state = 31 THEN
    IF NOT cmdIssued THEN
        seq := seq + 1;
        cmdIssued := TRUE;
    END_IF;
    D80 := 1;
    D81 := curSource;
    D82 := seq;
END_IF;

IF state = 42 THEN
    IF NOT cmdIssued THEN
        seq := seq + 1;
        cmdIssued := TRUE;
    END_IF;
    D80 := 2;
    D81 := 3;
    D82 := seq;
END_IF;

IF state = 62 THEN
    IF NOT cmdIssued THEN
        seq := seq + 1;
        cmdIssued := TRUE;
    END_IF;
    D80 := 1;
    D81 := 3;
    D82 := seq;
END_IF;

IF state = 72 THEN
    IF NOT cmdIssued THEN
        seq := seq + 1;
        cmdIssued := TRUE;
    END_IF;
    D80 := 2;
    D81 := 4;
    D82 := seq;
END_IF;

IF state = 92 THEN
    IF NOT cmdIssued THEN
        seq := seq + 1;
        cmdIssued := TRUE;
    END_IF;
    D80 := 1;
    D81 := 4;
    D82 := seq;
END_IF;

IF state = 102 THEN
    IF NOT cmdIssued THEN
        seq := seq + 1;
        cmdIssued := TRUE;
    END_IF;
    D80 := 2;
    D81 := curSource;
    D82 := seq;
END_IF;

IF state = 80 THEN
    IF (ABS(D1025) <= 100) AND (ABS(D1029) <= 100) AND (ABS(D1024 - (-60000)) <= 20) AND (ABS(D1028 - D601) <= 20) THEN
        Y75 := TRUE;
        configCnt := configCnt + 1;
    ELSE
        configCnt := 0;
    END_IF;
END_IF;

cell3Ok := (state = 50) AND (ABS(D1016 - D500) <= 20) AND (ABS(D1020 - D501) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) AND (ABS(D1016 - D1020) <= 300);
cell4Ok := (state = 81) AND (ABS(D1024 - D600) <= 20) AND (ABS(D1028 - D601) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100);

tCell3(IN := cell3Ok, PT := T#100ms);
tCell4(IN := cell4Ok, PT := T#100ms);

finalStable := (state = 900) AND X51 AND (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) AND (ABS(D1016 - (-60000)) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - (-60000)) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024 - (-60000)) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028 - (-60000)) <= 20) AND (ABS(D1029) <= 100);

tFinal(IN := finalStable, PT := T#100ms);

IF tFinal.Q THEN
    completionLatched := TRUE;
END_IF;

Y2 := completionLatched;

IF completionLatched OR (state = 0) THEN
    Y30 := TRUE;
ELSE
    Y30 := FALSE;
END_IF;

CASE state OF
    0:
        IF (D100 <> 0) AND NOT r0Done THEN
            curIndex := 0;
            curId := D100;
            IF D101 = 2 THEN
                curSource := 2;
            ELSE
                curSource := 1;
            END_IF;
            curCancel := X31;
            IF curCancel THEN
                state := 110;
            ELSE
                state := 10;
            END_IF;
        ELSIF (D120 <> 0) AND NOT r1Done THEN
            curIndex := 1;
            curId := D120;
            IF D121 = 2 THEN
                curSource := 2;
            ELSE
                curSource := 1;
            END_IF;
            curCancel := X35;
            IF curCancel THEN
                state := 110;
            ELSE
                state := 10;
            END_IF;
        ELSIF X51 THEN
            state := 900;
        END_IF;

    10:
        IF (ABS(D1008 - sourceDock) <= 20) AND (ABS(D1012 - sourceDock) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) AND (ABS(D1008 - D1012) <= 8000) THEN
            state := 20;
        END_IF;

    20:
        IF portReady AND (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            state := 30;
        END_IF;

    30:
        IF portReady AND (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            state := 31;
        END_IF;

    31:
        IF D90 = curId THEN
            state := 32;
        END_IF;

    32:
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            state := 40;
        END_IF;

    40:
        IF portReady AND (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1016 - (-60000)) <= 20) AND (ABS(D1020 - (-60000)) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) THEN
            state := 41;
        END_IF;

    41:
        IF portReady AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100) THEN
            state := 42;
        END_IF;

    42:
        IF D90 <> curId THEN
            state := 43;
        END_IF;

    43:
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            state := 50;
        END_IF;

    50:
        IF tCell3.Q AND X70 THEN
            state := 51;
        END_IF;

    51:
        IF (ABS(D1016 - (-60000)) <= 20) AND (ABS(D1020 - (-60000)) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) AND (ABS(D1016 - D1020) <= 300) THEN
            state := 60;
        END_IF;

    60:
        IF portReady AND (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            state := 61;
        END_IF;

    61:
        IF portReady AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100) THEN
            state := 62;
        END_IF;

    62:
        IF D90 = curId THEN
            state := 63;
        END_IF;

    63:
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            state := 70;
        END_IF;

    70:
        IF portReady AND (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1024 - (-60000)) <= 20) AND (ABS(D1028 - (-60000)) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100) THEN
            state := 71;
        END_IF;

    71:
        IF portReady AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100) THEN
            state := 72;
        END_IF;

    72:
        IF D90 <> curId THEN
            state := 73;
        END_IF;

    73:
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            state := 80;
        END_IF;

    80:
        IF configCnt >= 2 THEN
            state := 81;
        END_IF;

    81:
        IF tCell4.Q AND X75 THEN
            state := 82;
        END_IF;

    82:
        IF (ABS(D1024 - (-60000)) <= 20) AND (ABS(D1028 - (-60000)) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100) THEN
            state := 90;
        END_IF;

    90:
        IF portReady AND (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            state := 91;
        END_IF;

    91:
        IF portReady AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100) THEN
            state := 92;
        END_IF;

    92:
        IF D90 = curId THEN
            state := 93;
        END_IF;

    93:
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            state := 100;
        END_IF;

    100:
        IF portReady AND (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1008 - sourceDock) <= 20) AND (ABS(D1012 - sourceDock) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) THEN
            state := 101;
        END_IF;

    101:
        IF portReady AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100) THEN
            state := 102;
        END_IF;

    102:
        IF D90 <> curId THEN
            state := 103;
        END_IF;

    103:
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            state := 110;
        END_IF;

    110:
        IF (ABS(D1008 - 40000) <= 20) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            IF curIndex = 0 THEN
                ack0Val := curId;
                IF curCancel THEN
                    stat0Val := 2;
                ELSE
                    stat0Val := 1;
                END_IF;
                r0Done := TRUE;
            ELSE
                ack1Val := curId;
                IF curCancel THEN
                    stat1Val := 2;
                ELSE
                    stat1Val := 1;
                END_IF;
                r1Done := TRUE;
            END_IF;
            state := 0;
        END_IF;

    900:
        IF completionLatched THEN
            state := 900;
        END_IF;
ELSE
    state := 0;
END_CASE;

D300 := ack0Val;
D301 := stat0Val;
D302 := ack1Val;
D303 := stat1Val;
END_PROGRAM