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
    stage : INT;
    prevStage : INT;
    scanStage : INT;
    currentReq : INT;
    curId : DINT;
    curStation : DINT;
    curCancelled : BOOL;
    curReturned : BOOL;
    ack0Done : BOOL;
    ack1Done : BOOL;
    coupleSeq : DINT;
    entry : BOOL;
    homeOK : BOOL;
    completionLatched : BOOL;
    s4Final0 : DINT;
    s4Final1 : DINT;
    s4Pre0 : DINT;
    s4Pre1 : DINT;
    savedEpoch : DINT;
END_VAR

IF stage = 0 THEN
    IF (NOT ack0Done) AND (D100 <> 0) THEN
        currentReq := 0;
        stage := 10;
    ELSIF (NOT ack1Done) AND (D120 <> 0) THEN
        currentReq := 1;
        stage := 10;
    END_IF;
END_IF;

IF currentReq = 0 THEN
    curId := D100;
    curStation := 1;
    curCancelled := X31;
    curReturned := X30;
ELSE
    curId := D120;
    curStation := 2;
    curCancelled := X35;
    curReturned := X34;
END_IF;

scanStage := stage;
entry := scanStage <> prevStage;

D2000 := 0;
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;
D2004 := 0;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;
D2008 := 15000;
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;
D2012 := 15000;
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;
D2016 := -60000;
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;
D2020 := -60000;
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

D80 := 0;
D81 := 0;
D82 := coupleSeq;
Y30 := FALSE;

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

D300 := 0;
D301 := 0;
D302 := 0;
D303 := 0;

IF ack0Done THEN
    D300 := D100;
    IF X31 THEN
        D301 := 2;
    ELSE
        D301 := 1;
    END_IF;
END_IF;

IF ack1Done THEN
    D302 := D120;
    IF X35 THEN
        D303 := 2;
    ELSE
        D303 := 1;
    END_IF;
END_IF;

CASE stage OF
0:
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := -60000;
    D2020 := -60000;
    D2024 := -60000;
    D2028 := -60000;

10:
    IF curStation = 1 THEN
        D2008 := LIMIT(0, D92, 120000);
    ELSE
        D2012 := LIMIT(0, D92, 120000);
    END_IF;
    D2004 := 0;
    IF curCancelled THEN
        stage := 80;
    ELSIF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 20;
    END_IF;

20:
    D2004 := 0;
    IF curStation = 1 THEN
        D2008 := LIMIT(0, D92, 120000);
        D2000 := LIMIT(-450000, D403, 450000);
        IF (ABS(D1000 - D403) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X61 THEN
            stage := 21;
        END_IF;
    ELSE
        D2012 := LIMIT(0, D92, 120000);
        D2000 := LIMIT(-450000, D406, 450000);
        IF (ABS(D1000 - D406) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X62 THEN
            stage := 21;
        END_IF;
    END_IF;

21:
    IF entry THEN
        coupleSeq := coupleSeq + 1;
    END_IF;
    IF curStation = 1 THEN
        D2008 := LIMIT(0, D92, 120000);
        D2000 := LIMIT(-450000, D403, 450000);
    ELSE
        D2012 := LIMIT(0, D92, 120000);
        D2000 := LIMIT(-450000, D406, 450000);
    END_IF;
    D2004 := 18000;
    D80 := 1;
    D81 := curStation;
    D82 := coupleSeq;
    IF (D90 = curId) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 22;
    END_IF;

22:
    IF curStation = 1 THEN
        D2008 := LIMIT(0, D92, 120000);
        D2000 := LIMIT(-450000, D403, 450000);
    ELSE
        D2012 := LIMIT(0, D92, 120000);
        D2000 := LIMIT(-450000, D406, 450000);
    END_IF;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF curCancelled THEN
            stage := 70;
        ELSE
            stage := 24;
        END_IF;
    END_IF;

24:
    D2004 := 0;
    D2000 := LIMIT(-450000, D409, 450000);
    D2016 := -60000;
    D2020 := -60000;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X63 THEN
        stage := 25;
    END_IF;

25:
    IF entry THEN
        coupleSeq := coupleSeq + 1;
    END_IF;
    D2000 := LIMIT(-450000, D409, 450000);
    D2016 := -60000;
    D2020 := -60000;
    D2004 := 18000;
    D80 := 2;
    D81 := 3;
    D82 := coupleSeq;
    IF (D90 <> curId) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 26;
    END_IF;

26:
    D2000 := LIMIT(-450000, D409, 450000);
    D2016 := -60000;
    D2020 := -60000;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 30;
    END_IF;

30:
    D700 := curId;
    D701 := D526;
    D702 := 1000;
    D2016 := -60000;
    D2020 := -60000;
    IF (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) THEN
        Y70 := TRUE;
        IF NOT entry THEN
            stage := 31;
        END_IF;
    END_IF;

31:
    D700 := curId;
    D701 := D526;
    D702 := 1000;
    Y71 := TRUE;
    D2016 := LIMIT(-95000, D500, 95000);
    D2020 := LIMIT(-180000, D501, 180000);
    IF (ABS(D1016 - D2016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - D2020) <= 20) AND (ABS(D1021) <= 100) AND X70 AND (D522 = curId) AND (D524 = D91) THEN
        stage := 32;
    END_IF;

32:
    D700 := curId;
    D701 := D526;
    D702 := 1000;
    Y71 := TRUE;
    D2016 := -60000;
    D2020 := -60000;
    IF (ABS(D1016 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1021) <= 100) THEN
        stage := 40;
    END_IF;

40:
    D2004 := 0;
    D2000 := LIMIT(-450000, D409, 450000);
    D2016 := -60000;
    D2020 := -60000;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X63 THEN
        stage := 41;
    END_IF;

41:
    IF entry THEN
        coupleSeq := coupleSeq + 1;
    END_IF;
    D2000 := LIMIT(-450000, D409, 450000);
    D2016 := -60000;
    D2020 := -60000;
    D2004 := 18000;
    D80 := 1;
    D81 := 3;
    D82 := coupleSeq;
    IF (D90 = curId) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 42;
    END_IF;

42:
    D2000 := LIMIT(-450000, D409, 450000);
    D2016 := -60000;
    D2020 := -60000;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 44;
    END_IF;

44:
    D2004 := 0;
    D2000 := LIMIT(-450000, D412, 450000);
    D2024 := -60000;
    D2028 := -60000;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X64 THEN
        stage := 45;
    END_IF;

45:
    IF entry THEN
        coupleSeq := coupleSeq + 1;
    END_IF;
    D2000 := LIMIT(-450000, D412, 450000);
    D2024 := -60000;
    D2028 := -60000;
    D2004 := 18000;
    D80 := 2;
    D81 := 4;
    D82 := coupleSeq;
    IF (D90 <> curId) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 46;
    END_IF;

46:
    D2000 := LIMIT(-450000, D412, 450000);
    D2024 := -60000;
    D2028 := -60000;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 50;
    END_IF;

50:
    D710 := curId;
    D711 := D626;
    D712 := 1000;
    D2024 := -60000;
    D2028 := -60000;
    Y76 := FALSE;
    IF (ABS(D1024 + 60000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028 + 60000) <= 20) AND (ABS(D1029) <= 100) THEN
        stage := 51;
    END_IF;

51:
    D710 := curId;
    D711 := D626;
    D712 := 1000;
    s4Final0 := LIMIT(-95000, D600 + 25000, 95000);
    s4Final1 := LIMIT(-95000, D601 + 25000, 95000);
    IF D620 = 0 THEN
        D2024 := s4Final0;
        D2028 := -60000;
        IF (ABS(D1024 - s4Final0) <= 20) AND (ABS(D1025) <= 100) THEN
            IF X75 AND (D622 = curId) AND (D624 = D91) THEN
                savedEpoch := D91;
                stage := 52;
            ELSE
                stage := 53;
            END_IF;
        END_IF;
    ELSE
        D2024 := -60000;
        D2028 := s4Final1;
        IF (ABS(D1028 - s4Final1) <= 20) AND (ABS(D1029) <= 100) THEN
            IF X75 AND (D622 = curId) AND (D624 = D91) THEN
                savedEpoch := D91;
                stage := 52;
            ELSE
                stage := 53;
            END_IF;
        END_IF;
    END_IF;

52:
    D710 := curId;
    D711 := D626;
    D712 := 1000;
    Y76 := TRUE;
    s4Final0 := LIMIT(-95000, D600 + 25000, 95000);
    s4Final1 := LIMIT(-95000, D601 + 25000, 95000);
    IF D620 = 0 THEN
        D2024 := s4Final0;
        D2028 := -60000;
    ELSE
        D2024 := -60000;
        D2028 := s4Final1;
    END_IF;
    IF savedEpoch <> D91 THEN
        stage := 53;
    ELSIF X75 AND (D622 = curId) AND (D624 = D91) THEN
        stage := 54;
    END_IF;

53:
    D710 := curId;
    D711 := D626;
    D712 := 1000;
    s4Pre0 := LIMIT(-95000, D600 - 5000, 95000);
    s4Pre1 := LIMIT(-95000, D601 - 5000, 95000);
    IF D620 = 0 THEN
        D2024 := s4Pre0;
        D2028 := -60000;
        IF (ABS(D1024 - s4Pre0) <= 20) AND (ABS(D1025) <= 100) THEN
            stage := 51;
        END_IF;
    ELSE
        D2024 := -60000;
        D2028 := s4Pre1;
        IF (ABS(D1028 - s4Pre1) <= 20) AND (ABS(D1029) <= 100) THEN
            stage := 51;
        END_IF;
    END_IF;

54:
    D710 := curId;
    D711 := D626;
    D712 := 1000;
    Y76 := TRUE;
    D2024 := -60000;
    D2028 := -60000;
    IF (ABS(D1024 + 60000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028 + 60000) <= 20) AND (ABS(D1029) <= 100) THEN
        stage := 60;
    END_IF;

60:
    D2004 := 0;
    D2000 := LIMIT(-450000, D412, 450000);
    D2024 := -60000;
    D2028 := -60000;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X64 THEN
        stage := 61;
    END_IF;

61:
    IF entry THEN
        coupleSeq := coupleSeq + 1;
    END_IF;
    D2000 := LIMIT(-450000, D412, 450000);
    D2024 := -60000;
    D2028 := -60000;
    D2004 := 18000;
    D80 := 1;
    D81 := 4;
    D82 := coupleSeq;
    IF (D90 = curId) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 62;
    END_IF;

62:
    D2000 := LIMIT(-450000, D412, 450000);
    D2024 := -60000;
    D2028 := -60000;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 70;
    END_IF;

70:
    D2004 := 0;
    IF curStation = 1 THEN
        D2008 := LIMIT(0, D92, 120000);
        D2000 := LIMIT(-450000, D403, 450000);
        IF (ABS(D1000 - D403) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X61 THEN
            stage := 71;
        END_IF;
    ELSE
        D2012 := LIMIT(0, D92, 120000);
        D2000 := LIMIT(-450000, D406, 450000);
        IF (ABS(D1000 - D406) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X62 THEN
            stage := 71;
        END_IF;
    END_IF;

71:
    IF entry THEN
        coupleSeq := coupleSeq + 1;
    END_IF;
    IF curStation = 1 THEN
        D2008 := LIMIT(0, D92, 120000);
        D2000 := LIMIT(-450000, D403, 450000);
    ELSE
        D2012 := LIMIT(0, D92, 120000);
        D2000 := LIMIT(-450000, D406, 450000);
    END_IF;
    D2004 := 18000;
    D80 := 2;
    D81 := curStation;
    D82 := coupleSeq;
    IF (D90 <> curId) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 72;
    END_IF;

72:
    IF curStation = 1 THEN
        D2008 := 15000;
        D2000 := LIMIT(-450000, D403, 450000);
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) THEN
            stage := 80;
        END_IF;
    ELSE
        D2012 := 15000;
        D2000 := LIMIT(-450000, D406, 450000);
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) THEN
            stage := 80;
        END_IF;
    END_IF;
    D2004 := 0;

80:
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := -60000;
    D2020 := -60000;
    D2024 := -60000;
    D2028 := -60000;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) THEN
        IF currentReq = 0 THEN
            ack0Done := TRUE;
            D300 := D100;
            IF X31 THEN
                D301 := 2;
            ELSE
                D301 := 1;
            END_IF;
        ELSE
            ack1Done := TRUE;
            D302 := D120;
            IF X35 THEN
                D303 := 2;
            ELSE
                D303 := 1;
            END_IF;
        END_IF;
        stage := 0;
    END_IF;

100:
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := -60000;
    D2020 := -60000;
    D2024 := -60000;
    D2028 := -60000;

ELSE
    stage := 0;
END_CASE;

homeOK := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND (ABS(D1016 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024 + 60000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028 + 60000) <= 20) AND (ABS(D1029) <= 100);

IF X51 AND homeOK THEN
    completionLatched := TRUE;
END_IF;

IF completionLatched THEN
    stage := 100;
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := -60000;
    D2020 := -60000;
    D2024 := -60000;
    D2028 := -60000;
    Y2 := homeOK;
ELSE
    Y2 := FALSE;
END_IF;

IF Y2 THEN
    Y30 := TRUE;
END_IF;

D82 := coupleSeq;
prevStage := scanStage;

END_PROGRAM