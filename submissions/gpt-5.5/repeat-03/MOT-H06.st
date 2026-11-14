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
    D1036 : DINT;
    D1037 : DINT;
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
    D603 : DINT;
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
    D2036 : DINT;
    D2037 : DINT;
    D2038 : DINT;
    Y49 : BOOL;
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
    prevState : INT;
    curReq : INT;
    originStation : INT;
    loc : INT;
    curId : DINT;
    curStatus : DINT;
    seq : DINT;
    connIssued : BOOL;
    connCount : INT;
    curCancel : BOOL;
    portTarget : DINT;
    portReady : BOOL;
    liftReady : BOOL;
    cellHome3 : BOOL;
    cellHome4 : BOOL;
    aReady : BOOL;
    b0Ready : BOOL;
    bConnReady : BOOL;
    finalReady : BOOL;
    s3AngleTarget : DINT;
    s3SlideTarget : DINT;
    s4Ang0Target : DINT;
    s4Ext1Target : DINT;
    s4Ang2Target : DINT;
    s4Ext3Target : DINT;
END_VAR

IF state <> prevState THEN
    connIssued := FALSE;
    connCount := 0;
END_IF;

IF curReq = 1 THEN
    curId := D100;
    curCancel := X31;
ELSIF curReq = 2 THEN
    curId := D120;
    curCancel := X35;
ELSE
    curId := 0;
    curCancel := FALSE;
END_IF;

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
D2016 := 0;
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;
D2020 := 5000;
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;
D2024 := -6500;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;
D2028 := 0;
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;
D2032 := 6500;
D2033 := 1000;
D2034 := 0;
Y48 := TRUE;
D2036 := 0;
D2037 := 1000;
D2038 := 0;
Y49 := TRUE;
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
Y30 := FALSE;

IF state <> 0 THEN
    IF curCancel AND (curStatus <> 2) THEN
        curStatus := 2;
        IF loc = 4 THEN
            state := 43;
        ELSIF loc = 3 THEN
            state := 33;
        ELSIF loc = 1 THEN
            state := 80;
        ELSE
            IF D90 = curId THEN
                loc := 1;
                state := 80;
            ELSE
                state := 82;
            END_IF;
        END_IF;
    END_IF;
END_IF;

CASE state OF
0:
    curReq := 0;
    loc := 0;
    curStatus := 1;
    originStation := 1;
    IF (D100 <> 0) AND (D300 <> D100) THEN
        curReq := 1;
        curId := D100;
        curStatus := 1;
        IF D101 = 2 THEN
            originStation := 2;
        ELSE
            originStation := 1;
        END_IF;
        state := 10;
    ELSIF (D120 <> 0) AND (D302 <> D120) THEN
        curReq := 2;
        curId := D120;
        curStatus := 1;
        IF D121 = 2 THEN
            originStation := 2;
        ELSE
            originStation := 1;
        END_IF;
        state := 10;
    END_IF;

10:
    IF originStation = 1 THEN
        D2008 := LIMIT(0, D92, 120000);
        IF (ABS(D1008 - D2008) <= 20) AND (ABS(D1009) <= 100) THEN
            state := 20;
        END_IF;
    ELSE
        D2012 := LIMIT(0, D92, 120000);
        IF (ABS(D1012 - D2012) <= 20) AND (ABS(D1013) <= 100) THEN
            state := 20;
        END_IF;
    END_IF;

20:
    IF originStation = 1 THEN
        portTarget := LIMIT(-450000, D403, 730000);
        portReady := X61;
        D2008 := LIMIT(0, D92, 120000);
        liftReady := (ABS(D1008 - D2008) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        portTarget := LIMIT(-450000, D406, 730000);
        portReady := X62;
        D2012 := LIMIT(0, D92, 120000);
        liftReady := (ABS(D1012 - D2012) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    D2000 := portTarget;
    D2004 := 0;
    IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND portReady AND liftReady THEN
        state := 21;
    END_IF;

21:
    IF originStation = 1 THEN
        portTarget := LIMIT(-450000, D403, 730000);
        portReady := X61;
        D2008 := LIMIT(0, D92, 120000);
        liftReady := (ABS(D1008 - D2008) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        portTarget := LIMIT(-450000, D406, 730000);
        portReady := X62;
        D2012 := LIMIT(0, D92, 120000);
        liftReady := (ABS(D1012 - D2012) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    D2000 := portTarget;
    D2004 := 18000;
    D80 := 1;
    D81 := DINT(originStation);
    IF (NOT connIssued) AND (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND portReady AND liftReady THEN
        seq := seq + 1;
        D82 := seq;
        connIssued := TRUE;
    END_IF;
    IF connIssued AND ((D90 = curId) OR (connCount >= 6)) THEN
        loc := 1;
        state := 22;
    END_IF;

22:
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF curStatus = 2 THEN
            state := 80;
        ELSE
            state := 30;
        END_IF;
    END_IF;

30:
    D2000 := LIMIT(-450000, D409, 730000);
    D2004 := 0;
    IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X63 THEN
        state := 31;
    END_IF;

31:
    D2000 := LIMIT(-450000, D409, 730000);
    D2004 := 18000;
    D80 := 2;
    D81 := 3;
    IF (NOT connIssued) AND (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND X63 THEN
        seq := seq + 1;
        D82 := seq;
        connIssued := TRUE;
    END_IF;
    IF connIssued AND ((D90 <> curId) OR (D410 = curId) OR (connCount >= 6)) THEN
        loc := 3;
        state := 32;
    END_IF;

32:
    D2000 := LIMIT(-450000, D409, 730000);
    D2004 := 0;
    Y71 := TRUE;
    Y70 := TRUE;
    D700 := curId;
    D701 := D526;
    D702 := 1000;
    s3AngleTarget := LIMIT(0, D500, 27000);
    s3SlideTarget := LIMIT(0, D501, 74000);
    IF s3SlideTarget < 70000 THEN
        s3SlideTarget := 70000;
    END_IF;
    D2016 := s3AngleTarget;
    IF (ABS(D1016 - s3AngleTarget) <= 20) AND (ABS(D1017) <= 100) THEN
        D2020 := s3SlideTarget;
    ELSE
        D2020 := 50000;
    END_IF;
    IF X70 THEN
        state := 33;
    END_IF;

33:
    D2000 := LIMIT(-450000, D409, 730000);
    D2004 := 0;
    Y71 := TRUE;
    D2016 := 0;
    D2020 := 5000;
    IF (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - 5000) <= 20) AND (ABS(D1021) <= 100) AND X63 THEN
        state := 34;
    END_IF;

34:
    D2000 := LIMIT(-450000, D409, 730000);
    D2004 := 18000;
    Y71 := TRUE;
    D2016 := 0;
    D2020 := 5000;
    D80 := 1;
    D81 := 3;
    IF (NOT connIssued) AND (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND X63 THEN
        seq := seq + 1;
        D82 := seq;
        connIssued := TRUE;
    END_IF;
    IF connIssued AND ((D90 = curId) OR (connCount >= 6)) THEN
        loc := 1;
        state := 35;
    END_IF;

35:
    D2000 := LIMIT(-450000, D409, 730000);
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF curStatus = 2 THEN
            state := 80;
        ELSE
            state := 40;
        END_IF;
    END_IF;

40:
    D2000 := LIMIT(-450000, D412, 730000);
    D2004 := 0;
    IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X64 THEN
        state := 41;
    END_IF;

41:
    D2000 := LIMIT(-450000, D412, 730000);
    D2004 := 18000;
    D80 := 2;
    D81 := 4;
    IF (NOT connIssued) AND (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND X64 THEN
        seq := seq + 1;
        D82 := seq;
        connIssued := TRUE;
    END_IF;
    IF connIssued AND ((D90 <> curId) OR (D413 = curId) OR (connCount >= 6)) THEN
        loc := 4;
        state := 42;
    END_IF;

42:
    D2000 := LIMIT(-450000, D412, 730000);
    D2004 := 0;
    Y76 := TRUE;
    Y75 := TRUE;
    D710 := curId;
    D711 := D626;
    D712 := 1000;
    s4Ang0Target := LIMIT(-9000, D600, 9000);
    s4Ext1Target := LIMIT(0, D601, 65000);
    s4Ang2Target := LIMIT(-9000, D602, 9000);
    s4Ext3Target := LIMIT(0, D603, 65000);
    IF (D1028 <= 8000) AND (D1036 <= 8000) AND (ABS(D1029) <= 100) AND (ABS(D1037) <= 100) THEN
        D2024 := s4Ang0Target;
        D2032 := s4Ang2Target;
        IF (ABS(D1024 - s4Ang0Target) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1032 - s4Ang2Target) <= 20) AND (ABS(D1033) <= 100) THEN
            D2028 := s4Ext1Target;
            D2036 := s4Ext3Target;
        ELSE
            D2028 := 0;
            D2036 := 0;
        END_IF;
    ELSE
        D2024 := D1024;
        D2032 := D1032;
        D2028 := 0;
        D2036 := 0;
    END_IF;
    IF X75 THEN
        state := 43;
    END_IF;

43:
    D2000 := LIMIT(-450000, D412, 730000);
    D2004 := 0;
    Y76 := TRUE;
    D2028 := 0;
    D2036 := 0;
    IF (D1028 <= 8000) AND (D1036 <= 8000) AND (ABS(D1029) <= 100) AND (ABS(D1037) <= 100) THEN
        D2024 := -6500;
        D2032 := 6500;
    ELSE
        D2024 := D1024;
        D2032 := D1032;
    END_IF;
    IF (ABS(D1024 + 6500) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - 6500) <= 20) AND (ABS(D1033) <= 100) AND (ABS(D1036) <= 20) AND (ABS(D1037) <= 100) AND X64 THEN
        state := 44;
    END_IF;

44:
    D2000 := LIMIT(-450000, D412, 730000);
    D2004 := 18000;
    Y76 := TRUE;
    D2024 := -6500;
    D2028 := 0;
    D2032 := 6500;
    D2036 := 0;
    D80 := 1;
    D81 := 4;
    IF (NOT connIssued) AND (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND X64 THEN
        seq := seq + 1;
        D82 := seq;
        connIssued := TRUE;
    END_IF;
    IF connIssued AND ((D90 = curId) OR (connCount >= 6)) THEN
        loc := 1;
        state := 45;
    END_IF;

45:
    D2000 := LIMIT(-450000, D412, 730000);
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 80;
    END_IF;

80:
    IF originStation = 1 THEN
        portTarget := LIMIT(-450000, D403, 730000);
        portReady := X61;
        D2008 := LIMIT(0, D92, 120000);
        liftReady := (ABS(D1008 - D2008) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        portTarget := LIMIT(-450000, D406, 730000);
        portReady := X62;
        D2012 := LIMIT(0, D92, 120000);
        liftReady := (ABS(D1012 - D2012) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    D2000 := portTarget;
    D2004 := 0;
    IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND portReady AND liftReady THEN
        state := 81;
    END_IF;

81:
    IF originStation = 1 THEN
        portTarget := LIMIT(-450000, D403, 730000);
        portReady := X61;
        D2008 := LIMIT(0, D92, 120000);
        liftReady := (ABS(D1008 - D2008) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        portTarget := LIMIT(-450000, D406, 730000);
        portReady := X62;
        D2012 := LIMIT(0, D92, 120000);
        liftReady := (ABS(D1012 - D2012) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    D2000 := portTarget;
    D2004 := 18000;
    D80 := 2;
    D81 := DINT(originStation);
    IF (NOT connIssued) AND (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND portReady AND liftReady THEN
        seq := seq + 1;
        D82 := seq;
        connIssued := TRUE;
    END_IF;
    IF connIssued AND ((D90 <> curId) OR (connCount >= 6)) THEN
        loc := 0;
        state := 82;
    END_IF;

82:
    IF originStation = 1 THEN
        D2000 := LIMIT(-450000, D403, 730000);
        D2008 := 15000;
        liftReady := (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        D2000 := LIMIT(-450000, D406, 730000);
        D2012 := 15000;
        liftReady := (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND liftReady THEN
        state := 90;
    END_IF;

90:
    IF curReq = 1 THEN
        D300 := D100;
        D301 := curStatus;
    ELSIF curReq = 2 THEN
        D302 := D120;
        D303 := curStatus;
    END_IF;
    state := 0;

ELSE
    state := 0;
END_CASE;

D2000 := LIMIT(-450000, D2000, 730000);
D2004 := LIMIT(0, D2004, 18000);
D2008 := LIMIT(0, D2008, 120000);
D2012 := LIMIT(0, D2012, 120000);
D2016 := LIMIT(0, D2016, 27000);
D2020 := LIMIT(0, D2020, 74000);
D2024 := LIMIT(-9000, D2024, 9000);
D2028 := LIMIT(0, D2028, 65000);
D2032 := LIMIT(-9000, D2032, 9000);
D2036 := LIMIT(0, D2036, 65000);

D2001 := LIMIT(0, D2001, 1000);
D2005 := LIMIT(0, D2005, 1000);
D2009 := LIMIT(0, D2009, 1000);
D2013 := LIMIT(0, D2013, 1000);
D2017 := LIMIT(0, D2017, 1000);
D2021 := LIMIT(0, D2021, 1000);
D2025 := LIMIT(0, D2025, 1000);
D2029 := LIMIT(0, D2029, 1000);
D2033 := LIMIT(0, D2033, 1000);
D2037 := LIMIT(0, D2037, 1000);

D82 := seq;

IF connIssued THEN
    IF connCount < 30000 THEN
        connCount := connCount + 1;
    END_IF;
ELSE
    connCount := 0;
END_IF;

cellHome3 := (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - 5000) <= 20) AND (ABS(D1021) <= 100);
cellHome4 := (ABS(D1024 + 6500) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - 6500) <= 20) AND (ABS(D1033) <= 100) AND (ABS(D1036) <= 20) AND (ABS(D1037) <= 100);
aReady := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100);
b0Ready := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);

finalReady := X51 AND (state = 0) AND aReady AND b0Ready AND cellHome3 AND cellHome4 AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100);

IF finalReady THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

prevState := state;

END_PROGRAM