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
    phase : INT := 0;
    active : INT := 0;
    curId : DINT := 0;
    sourceStation : INT := 0;
    sourceX : DINT := 0;
    sourcePortId : DINT := 0;
    seqNo : DINT := 0;
    seqIssued : BOOL := FALSE;
    acked0 : BOOL := FALSE;
    acked1 : BOOL := FALSE;
    ack0Id : DINT := 0;
    ack1Id : DINT := 0;
    ack0Status : DINT := 0;
    ack1Status : DINT := 0;
    cancelMode : BOOL := FALSE;
    configureCount : INT := 0;
    workEpoch : DINT := 0;
    s3t0 : DINT := -60000;
    s3t1 : DINT := -60000;
    s4t0 : DINT := -60000;
    s4t1 : DINT := -60000;
    atA0 : BOOL;
    atB0 : BOOL;
    atB180 : BOOL;
    atC0 : BOOL;
    atD0 : BOOL;
    atS3Home : BOOL;
    atS4Home : BOOL;
    stoppedA : BOOL;
    stoppedB : BOOL;
    stoppedC : BOOL;
    stoppedD : BOOL;
    stoppedS3 : BOOL;
    stoppedS4 : BOOL;
    finalState : BOOL;
    finalLatch : BOOL := FALSE;
END_VAR

stoppedA := ABS(D1001) <= 100;
stoppedB := ABS(D1005) <= 100;
stoppedC := ABS(D1009) <= 100;
stoppedD := ABS(D1013) <= 100;
stoppedS3 := (ABS(D1017) <= 100) AND (ABS(D1021) <= 100);
stoppedS4 := (ABS(D1025) <= 100) AND (ABS(D1029) <= 100);

atA0 := (ABS(D1000) <= 20) AND stoppedA;
atB0 := (ABS(D1004) <= 20) AND stoppedB;
atB180 := (ABS(D1004 - 18000) <= 20) AND stoppedB;
atC0 := (ABS(D1008 - 15000) <= 20) AND stoppedC;
atD0 := (ABS(D1012 - 15000) <= 20) AND stoppedD;
atS3Home := (ABS(D1016 + 60000) <= 20) AND (ABS(D1020 + 60000) <= 20) AND stoppedS3;
atS4Home := (ABS(D1024 + 60000) <= 20) AND (ABS(D1028 + 60000) <= 20) AND stoppedS4;

IF sourceStation = 1 THEN
    sourceX := D403;
    sourcePortId := D404;
ELSIF sourceStation = 2 THEN
    sourceX := D406;
    sourcePortId := D407;
ELSE
    sourceX := 0;
    sourcePortId := 0;
END_IF;

D2000 := 0;
D2001 := 900;
D2002 := 0;
Y40 := TRUE;
D2004 := 0;
D2005 := 900;
D2006 := 0;
Y41 := TRUE;
D2008 := 15000;
D2009 := 900;
D2010 := 0;
Y42 := TRUE;
D2012 := 15000;
D2013 := 900;
D2014 := 0;
Y43 := TRUE;
D2016 := -60000;
D2017 := 850;
D2018 := 0;
Y44 := TRUE;
D2020 := -60000;
D2021 := 850;
D2022 := 0;
Y45 := TRUE;
D2024 := -60000;
D2025 := 850;
D2026 := 0;
Y46 := TRUE;
D2028 := -60000;
D2029 := 850;
D2030 := 0;
Y47 := TRUE;

Y70 := FALSE;
Y71 := FALSE;
D700 := 0;
D701 := 0;
D702 := 1000;
Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := 0;
D712 := 1000;

D80 := 0;
D81 := 0;
D82 := seqNo;
Y30 := FALSE;

D300 := ack0Id;
D301 := ack0Status;
D302 := ack1Id;
D303 := ack1Status;

IF active = 0 THEN
    cancelMode := FALSE;
ELSIF active = 1 THEN
    IF X31 THEN
        cancelMode := TRUE;
    END_IF;
ELSIF active = 2 THEN
    IF X35 THEN
        cancelMode := TRUE;
    END_IF;
END_IF;

CASE phase OF
0:
    active := 0;
    curId := 0;
    sourceStation := 0;
    seqIssued := FALSE;
    configureCount := 0;
    IF (NOT acked0) AND (D100 <> 0) THEN
        IF X31 THEN
            acked0 := TRUE;
            ack0Id := D100;
            ack0Status := 2;
        ELSE
            active := 1;
            curId := D100;
            sourceStation := 1;
            cancelMode := FALSE;
            phase := 10;
        END_IF;
    ELSIF (NOT acked1) AND (D120 <> 0) THEN
        IF X35 THEN
            acked1 := TRUE;
            ack1Id := D120;
            ack1Status := 2;
        ELSE
            active := 2;
            curId := D120;
            sourceStation := 2;
            cancelMode := FALSE;
            phase := 10;
        END_IF;
    END_IF;

10:
    D2000 := sourceX;
    D2004 := 0;
    IF sourceStation = 1 THEN
        D2008 := D92;
        IF (ABS(D1000 - sourceX) <= 20) AND stoppedA AND atB0 AND (ABS(D1008 - D92) <= 20) AND stoppedC AND X61 AND (D404 = curId) THEN
            phase := 20;
        END_IF;
    ELSE
        D2012 := D92;
        IF (ABS(D1000 - sourceX) <= 20) AND stoppedA AND atB0 AND (ABS(D1012 - D92) <= 20) AND stoppedD AND X62 AND (D407 = curId) THEN
            phase := 20;
        END_IF;
    END_IF;

20:
    D2000 := sourceX;
    D2004 := 18000;
    IF sourceStation = 1 THEN
        D2008 := D92;
    ELSE
        D2012 := D92;
    END_IF;
    IF atB180 THEN
        seqIssued := FALSE;
        phase := 21;
    END_IF;

21:
    D2000 := sourceX;
    D2004 := 18000;
    IF sourceStation = 1 THEN
        D2008 := D92;
    ELSE
        D2012 := D92;
    END_IF;
    D80 := 1;
    D81 := DINT(sourceStation);
    IF NOT seqIssued THEN
        seqNo := seqNo + 1;
        seqIssued := TRUE;
    END_IF;
    D82 := seqNo;
    IF D90 = curId THEN
        phase := 22;
    END_IF;

22:
    D2000 := sourceX;
    D2004 := 0;
    IF sourceStation = 1 THEN
        D2008 := D92;
    ELSE
        D2012 := D92;
    END_IF;
    IF atB0 THEN
        IF cancelMode THEN
            phase := 90;
        ELSE
            phase := 30;
        END_IF;
    END_IF;

30:
    D2000 := D409;
    D2004 := 0;
    IF (ABS(D1000 - D409) <= 20) AND stoppedA AND atB0 AND X63 AND atS3Home THEN
        phase := 31;
    END_IF;

31:
    D2000 := D409;
    D2004 := 18000;
    IF atB180 THEN
        seqIssued := FALSE;
        phase := 32;
    END_IF;

32:
    D2000 := D409;
    D2004 := 18000;
    D80 := 2;
    D81 := 3;
    IF NOT seqIssued THEN
        seqNo := seqNo + 1;
        seqIssued := TRUE;
    END_IF;
    D82 := seqNo;
    IF (D90 <> curId) OR (D410 = curId) THEN
        phase := 33;
    END_IF;

33:
    D2000 := D409;
    D2004 := 0;
    IF atB0 THEN
        configureCount := 0;
        phase := 40;
    END_IF;

40:
    D700 := curId;
    D701 := 1;
    D702 := 1000;
    Y71 := TRUE;
    IF stoppedS3 THEN
        Y70 := TRUE;
        configureCount := configureCount + 1;
    ELSE
        Y70 := FALSE;
        configureCount := 0;
    END_IF;
    IF configureCount >= 2 THEN
        workEpoch := D91;
        phase := 41;
    END_IF;

41:
    D700 := curId;
    D701 := 1;
    D702 := 1000;
    Y71 := TRUE;
    s3t0 := LIMIT(-95000, D521 + D500, 95000);
    s3t1 := LIMIT(-180000, D521 + D501, 180000);
    D2016 := s3t0;
    D2020 := s3t1;
    IF X70 AND (D522 = curId) AND (D524 = D91) AND (ABS(D1016 - s3t0) <= 20) AND (ABS(D1020 - s3t1) <= 20) AND stoppedS3 THEN
        phase := 42;
    END_IF;

42:
    D700 := curId;
    D701 := 1;
    D702 := 1000;
    Y71 := TRUE;
    D2016 := -60000;
    D2020 := -60000;
    IF atS3Home THEN
        phase := 50;
    END_IF;

50:
    D2000 := D409;
    D2004 := 0;
    IF (ABS(D1000 - D409) <= 20) AND stoppedA AND atB0 AND X63 AND atS3Home THEN
        phase := 51;
    END_IF;

51:
    D2000 := D409;
    D2004 := 18000;
    IF atB180 THEN
        seqIssued := FALSE;
        phase := 52;
    END_IF;

52:
    D2000 := D409;
    D2004 := 18000;
    D80 := 1;
    D81 := 3;
    IF NOT seqIssued THEN
        seqNo := seqNo + 1;
        seqIssued := TRUE;
    END_IF;
    D82 := seqNo;
    IF D90 = curId THEN
        phase := 53;
    END_IF;

53:
    D2000 := D409;
    D2004 := 0;
    IF atB0 THEN
        phase := 60;
    END_IF;

60:
    D2000 := D412;
    D2004 := 0;
    IF (ABS(D1000 - D412) <= 20) AND stoppedA AND atB0 AND X64 AND atS4Home THEN
        phase := 61;
    END_IF;

61:
    D2000 := D412;
    D2004 := 18000;
    IF atB180 THEN
        seqIssued := FALSE;
        phase := 62;
    END_IF;

62:
    D2000 := D412;
    D2004 := 18000;
    D80 := 2;
    D81 := 4;
    IF NOT seqIssued THEN
        seqNo := seqNo + 1;
        seqIssued := TRUE;
    END_IF;
    D82 := seqNo;
    IF (D90 <> curId) OR (D413 = curId) THEN
        phase := 63;
    END_IF;

63:
    D2000 := D412;
    D2004 := 0;
    IF atB0 THEN
        workEpoch := D91;
        phase := 70;
    END_IF;

70:
    D710 := curId;
    D711 := 1;
    D712 := 1000;
    Y76 := TRUE;
    IF atS4Home THEN
        workEpoch := D91;
        phase := 71;
    END_IF;

71:
    D710 := curId;
    D711 := 1;
    D712 := 1000;
    Y76 := TRUE;
    s4t0 := LIMIT(-95000, D621 + D600 + 25000, 95000);
    s4t1 := LIMIT(-95000, D621 + D601 + 25000, 95000);
    D2024 := s4t0;
    D2028 := s4t1;
    IF D91 <> workEpoch THEN
        phase := 72;
    ELSIF X75 AND (D622 = curId) AND (D624 = D91) AND (ABS(D1024 - s4t0) <= 20) AND (ABS(D1028 - s4t1) <= 20) AND stoppedS4 THEN
        phase := 73;
    END_IF;

72:
    D710 := curId;
    D711 := 1;
    D712 := 1000;
    Y76 := TRUE;
    D2024 := -60000;
    D2028 := -60000;
    IF atS4Home THEN
        workEpoch := D91;
        phase := 71;
    END_IF;

73:
    D710 := curId;
    D711 := 1;
    D712 := 1000;
    Y76 := TRUE;
    D2024 := -60000;
    D2028 := -60000;
    IF atS4Home THEN
        phase := 80;
    END_IF;

80:
    D2000 := D412;
    D2004 := 0;
    IF (ABS(D1000 - D412) <= 20) AND stoppedA AND atB0 AND X64 AND atS4Home THEN
        phase := 81;
    END_IF;

81:
    D2000 := D412;
    D2004 := 18000;
    IF atB180 THEN
        seqIssued := FALSE;
        phase := 82;
    END_IF;

82:
    D2000 := D412;
    D2004 := 18000;
    D80 := 1;
    D81 := 4;
    IF NOT seqIssued THEN
        seqNo := seqNo + 1;
        seqIssued := TRUE;
    END_IF;
    D82 := seqNo;
    IF D90 = curId THEN
        phase := 83;
    END_IF;

83:
    D2000 := D412;
    D2004 := 0;
    IF atB0 THEN
        phase := 90;
    END_IF;

90:
    D2000 := sourceX;
    D2004 := 0;
    IF sourceStation = 1 THEN
        D2008 := D92;
        IF (ABS(D1000 - sourceX) <= 20) AND stoppedA AND atB0 AND (ABS(D1008 - D92) <= 20) AND stoppedC AND X61 THEN
            phase := 91;
        END_IF;
    ELSE
        D2012 := D92;
        IF (ABS(D1000 - sourceX) <= 20) AND stoppedA AND atB0 AND (ABS(D1012 - D92) <= 20) AND stoppedD AND X62 THEN
            phase := 91;
        END_IF;
    END_IF;

91:
    D2000 := sourceX;
    D2004 := 18000;
    IF sourceStation = 1 THEN
        D2008 := D92;
    ELSE
        D2012 := D92;
    END_IF;
    IF atB180 THEN
        seqIssued := FALSE;
        phase := 92;
    END_IF;

92:
    D2000 := sourceX;
    D2004 := 18000;
    IF sourceStation = 1 THEN
        D2008 := D92;
    ELSE
        D2012 := D92;
    END_IF;
    D80 := 2;
    D81 := DINT(sourceStation);
    IF NOT seqIssued THEN
        seqNo := seqNo + 1;
        seqIssued := TRUE;
    END_IF;
    D82 := seqNo;
    IF D90 <> curId THEN
        phase := 93;
    END_IF;

93:
    D2000 := sourceX;
    D2004 := 0;
    IF sourceStation = 1 THEN
        D2008 := D92;
    ELSE
        D2012 := D92;
    END_IF;
    IF atB0 THEN
        phase := 94;
    END_IF;

94:
    D2000 := 0;
    D2004 := 0;
    IF sourceStation = 1 THEN
        D2008 := 15000;
        IF atC0 AND atB0 THEN
            IF active = 1 THEN
                acked0 := TRUE;
                ack0Id := curId;
                IF cancelMode THEN
                    ack0Status := 2;
                ELSE
                    ack0Status := 1;
                END_IF;
            ELSE
                acked1 := TRUE;
                ack1Id := curId;
                IF cancelMode THEN
                    ack1Status := 2;
                ELSE
                    ack1Status := 1;
                END_IF;
            END_IF;
            phase := 0;
        END_IF;
    ELSE
        D2012 := 15000;
        IF atD0 AND atB0 THEN
            IF active = 1 THEN
                acked0 := TRUE;
                ack0Id := curId;
                IF cancelMode THEN
                    ack0Status := 2;
                ELSE
                    ack0Status := 1;
                END_IF;
            ELSE
                acked1 := TRUE;
                ack1Id := curId;
                IF cancelMode THEN
                    ack1Status := 2;
                ELSE
                    ack1Status := 1;
                END_IF;
            END_IF;
            phase := 0;
        END_IF;
    END_IF;
ELSE
    phase := 0;
END_CASE;

D300 := ack0Id;
D301 := ack0Status;
D302 := ack1Id;
D303 := ack1Status;
D82 := seqNo;

finalState := X51 AND acked0 AND acked1 AND atA0 AND atB0 AND atC0 AND atD0 AND atS3Home AND atS4Home;

IF finalState THEN
    finalLatch := TRUE;
END_IF;

IF finalLatch THEN
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := -60000;
    D2020 := -60000;
    D2024 := -60000;
    D2028 := -60000;
    Y30 := TRUE;
    Y2 := finalState;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM