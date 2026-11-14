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
    stage : DINT;
    lastStage : DINT;
    seq : DINT;
    curIndex : DINT;
    curId : DINT;
    curSource : DINT;
    curCancel : BOOL;
    waitMs : DINT;
    handMs : DINT;
    modMs : DINT;
    scanCount : DINT;
    handIssued : BOOL;
    sourcePort : DINT;
    dockHeight : DINT;
    m3t0 : DINT;
    m3t1 : DINT;
    s4t0 : DINT;
    s4t1 : DINT;
    s4t2 : DINT;
    r0 : REAL;
    r1 : REAL;
    xr : REAL;
    moment : REAL;
    ready : BOOL;
    finalReady : BOOL;
    req0Active : BOOL;
    req1Active : BOOL;
END_VAR

scanCount := scanCount + 1;

IF D100 = 0 THEN
    D300 := 0;
    D301 := 0;
END_IF;
IF D120 = 0 THEN
    D302 := 0;
    D303 := 0;
END_IF;

dockHeight := LIMIT(0, D92, 120000);
IF dockHeight = 0 THEN
    dockHeight := 95000;
END_IF;

m3t0 := LIMIT(-95000, D500, 95000);
m3t1 := LIMIT(-95000, D501, 95000);
IF m3t1 > (m3t0 + 300) THEN
    m3t1 := m3t0 + 300;
END_IF;
IF m3t1 < (m3t0 - 300) THEN
    m3t1 := m3t0 - 300;
END_IF;
m3t1 := LIMIT(-95000, m3t1, 95000);

s4t0 := LIMIT(-5000, D600, 5000);
s4t1 := LIMIT(-5000, D601, 5000);
r0 := REAL(s4t0) * 0.000174532925;
r1 := REAL(s4t1) * 0.000174532925;
xr := -225.0 * (SIN(r0) + SIN(r1));
s4t2 := LIMIT(-45000, DINT(ROUND(xr * 100.0)), 45000);

r0 := REAL(D1024) * 0.000174532925;
r1 := REAL(D1028) * 0.000174532925;
xr := REAL(D1032) * 0.01;
moment := 0.1962 * ((225.0 * (SIN(r0) + SIN(r1))) + xr);

IF stage <> lastStage THEN
    waitMs := 0;
    handMs := 0;
    modMs := 0;
    handIssued := FALSE;
    lastStage := stage;
END_IF;

CASE curSource OF
1:
    sourcePort := LIMIT(-450000, D403, 1461300);
2:
    sourcePort := LIMIT(-450000, D406, 1461300);
ELSE
    sourcePort := LIMIT(-450000, D403, 1461300);
END_CASE;

D2000 := 0;
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;
D2004 := 0;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;
D2008 := 40000;
D2009 := 80;
D2010 := 0;
Y42 := TRUE;
D2012 := 40000;
D2013 := 80;
D2014 := 0;
Y43 := TRUE;
D2016 := -60000;
D2017 := 50;
D2018 := 0;
Y44 := TRUE;
D2020 := -60000;
D2021 := 50;
D2022 := 0;
Y45 := TRUE;
D2024 := 0;
D2025 := 200;
D2026 := 0;
Y46 := TRUE;
D2028 := 0;
D2029 := 200;
D2030 := 0;
Y47 := TRUE;
D2032 := 0;
D2033 := 1000;
D2034 := 0;
Y48 := TRUE;
Y70 := FALSE;
Y71 := FALSE;
D700 := 0;
D701 := 0;
D702 := 800;
Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := 0;
D712 := 800;
D80 := 0;
D81 := 0;
D82 := seq;
Y30 := FALSE;

req0Active := (D100 <> 0) AND (D300 <> D100);
req1Active := (D120 <> 0) AND (D302 <> D120);

IF stage = 0 THEN
    IF req0Active THEN
        curIndex := 0;
        curId := D100;
        curSource := D101;
        IF (curSource < 1) OR (curSource > 2) THEN
            curSource := 1;
        END_IF;
        curCancel := X31;
        stage := 10;
    ELSIF req1Active THEN
        curIndex := 1;
        curId := D120;
        curSource := D121;
        IF (curSource < 1) OR (curSource > 2) THEN
            curSource := 2;
        END_IF;
        curCancel := X35;
        stage := 10;
    ELSE
        stage := 900;
    END_IF;
END_IF;

IF curIndex = 0 THEN
    curCancel := X31;
ELSE
    curCancel := X35;
END_IF;

CASE stage OF
10:
    D2000 := sourcePort;
    D2004 := 0;
    D2008 := dockHeight;
    D2012 := dockHeight;
    IF curSource = 1 THEN
        ready := X61;
    ELSE
        ready := X62;
    END_IF;
    ready := ready AND (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - dockHeight) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - dockHeight) <= 20) AND (ABS(D1013) <= 100);
    IF ready THEN waitMs := waitMs + 20; ELSE waitMs := 0; END_IF;
    IF waitMs >= 60 THEN stage := 11; END_IF;

11:
    D2000 := sourcePort;
    D2004 := 0;
    D2008 := dockHeight;
    D2012 := dockHeight;
    IF NOT handIssued THEN
        seq := seq + 1;
        handIssued := TRUE;
    END_IF;
    D80 := 1;
    D81 := curSource;
    D82 := seq;
    handMs := handMs + 20;
    IF (D90 = curId) OR (handMs >= 500) THEN stage := 20; END_IF;

20:
    D2000 := LIMIT(-450000, D409, 1461300);
    D2004 := 0;
    D2008 := 40000;
    D2012 := 40000;
    ready := X63 AND (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1016 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1021) <= 100);
    IF ready THEN waitMs := waitMs + 20; ELSE waitMs := 0; END_IF;
    IF waitMs >= 60 THEN stage := 21; END_IF;

21:
    D2000 := LIMIT(-450000, D409, 1461300);
    D2004 := 18000;
    ready := X63 AND (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
    IF ready THEN waitMs := waitMs + 20; ELSE waitMs := 0; END_IF;
    IF waitMs >= 40 THEN stage := 22; END_IF;

22:
    D2000 := LIMIT(-450000, D409, 1461300);
    D2004 := 18000;
    IF NOT handIssued THEN
        seq := seq + 1;
        handIssued := TRUE;
    END_IF;
    D80 := 2;
    D81 := 3;
    D82 := seq;
    handMs := handMs + 20;
    IF (D90 <> curId) OR (handMs >= 500) THEN stage := 23; END_IF;

23:
    D2000 := LIMIT(-450000, D409, 1461300);
    D2004 := 0;
    ready := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    IF ready THEN waitMs := waitMs + 20; ELSE waitMs := 0; END_IF;
    IF waitMs >= 40 THEN stage := 24; END_IF;

24:
    D2000 := LIMIT(-450000, D409, 1461300);
    D2004 := 0;
    D2016 := m3t0;
    D2020 := m3t1;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D702 := 800;
    ready := (ABS(D1016 - D2016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - D2020) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1016 - D1020) <= 300);
    IF ready THEN modMs := modMs + 20; ELSE modMs := 0; END_IF;
    IF (X70 AND ready) OR (modMs >= 120) THEN stage := 25; END_IF;

25:
    D2000 := LIMIT(-450000, D409, 1461300);
    D2004 := 0;
    D2016 := -60000;
    D2020 := -60000;
    ready := X63 AND (ABS(D1016 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1021) <= 100);
    IF ready THEN waitMs := waitMs + 20; ELSE waitMs := 0; END_IF;
    IF waitMs >= 60 THEN stage := 26; END_IF;

26:
    D2000 := LIMIT(-450000, D409, 1461300);
    D2004 := 0;
    IF NOT handIssued THEN
        seq := seq + 1;
        handIssued := TRUE;
    END_IF;
    D80 := 1;
    D81 := 3;
    D82 := seq;
    handMs := handMs + 20;
    IF (D90 = curId) OR (handMs >= 500) THEN stage := 30; END_IF;

30:
    D2000 := LIMIT(-450000, D412, 1461300);
    D2004 := 0;
    ready := X64 AND (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);
    IF ready THEN waitMs := waitMs + 20; ELSE waitMs := 0; END_IF;
    IF waitMs >= 60 THEN stage := 31; END_IF;

31:
    D2000 := LIMIT(-450000, D412, 1461300);
    D2004 := 18000;
    ready := X64 AND (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
    IF ready THEN waitMs := waitMs + 20; ELSE waitMs := 0; END_IF;
    IF waitMs >= 40 THEN stage := 32; END_IF;

32:
    D2000 := LIMIT(-450000, D412, 1461300);
    D2004 := 18000;
    IF NOT handIssued THEN
        seq := seq + 1;
        handIssued := TRUE;
    END_IF;
    D80 := 2;
    D81 := 4;
    D82 := seq;
    handMs := handMs + 20;
    IF (D90 <> curId) OR (handMs >= 500) THEN stage := 33; END_IF;

33:
    D2000 := LIMIT(-450000, D412, 1461300);
    D2004 := 0;
    ready := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    IF ready THEN waitMs := waitMs + 20; ELSE waitMs := 0; END_IF;
    IF waitMs >= 40 THEN stage := 34; END_IF;

34:
    D2000 := LIMIT(-450000, D412, 1461300);
    D2004 := 0;
    D2024 := s4t0;
    D2028 := s4t1;
    r0 := REAL(D1024) * 0.000174532925;
    r1 := REAL(D1028) * 0.000174532925;
    D2032 := LIMIT(-45000, DINT(ROUND((-225.0 * (SIN(r0) + SIN(r1))) * 100.0)), 45000);
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D712 := 800;
    ready := (ABS(D1024 - s4t0) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028 - s4t1) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - s4t2) <= 30) AND (ABS(D1033) <= 100) AND (ABS(moment) <= 1.0);
    IF ready THEN modMs := modMs + 20; ELSE modMs := 0; END_IF;
    IF (X75 AND ready) OR (modMs >= 120) THEN stage := 35; END_IF;

35:
    D2000 := LIMIT(-450000, D412, 1461300);
    D2004 := 0;
    D2024 := 0;
    D2028 := 0;
    r0 := REAL(D1024) * 0.000174532925;
    r1 := REAL(D1028) * 0.000174532925;
    D2032 := LIMIT(-45000, DINT(ROUND((-225.0 * (SIN(r0) + SIN(r1))) * 100.0)), 45000);
    ready := X64 AND (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 30) AND (ABS(D1033) <= 100) AND (ABS(moment) <= 1.0);
    IF ready THEN waitMs := waitMs + 20; ELSE waitMs := 0; END_IF;
    IF waitMs >= 60 THEN stage := 36; END_IF;

36:
    D2000 := LIMIT(-450000, D412, 1461300);
    D2004 := 0;
    IF NOT handIssued THEN
        seq := seq + 1;
        handIssued := TRUE;
    END_IF;
    D80 := 1;
    D81 := 4;
    D82 := seq;
    handMs := handMs + 20;
    IF (D90 = curId) OR (handMs >= 500) THEN stage := 40; END_IF;

40:
    D2000 := sourcePort;
    D2004 := 0;
    D2008 := dockHeight;
    D2012 := dockHeight;
    IF curSource = 1 THEN
        ready := X61;
    ELSE
        ready := X62;
    END_IF;
    ready := ready AND (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - dockHeight) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - dockHeight) <= 20) AND (ABS(D1013) <= 100);
    IF ready THEN waitMs := waitMs + 20; ELSE waitMs := 0; END_IF;
    IF waitMs >= 60 THEN stage := 41; END_IF;

41:
    D2000 := sourcePort;
    D2004 := 18000;
    D2008 := dockHeight;
    D2012 := dockHeight;
    ready := (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
    IF ready THEN waitMs := waitMs + 20; ELSE waitMs := 0; END_IF;
    IF waitMs >= 40 THEN stage := 42; END_IF;

42:
    D2000 := sourcePort;
    D2004 := 18000;
    D2008 := dockHeight;
    D2012 := dockHeight;
    IF NOT handIssued THEN
        seq := seq + 1;
        handIssued := TRUE;
    END_IF;
    D80 := 2;
    D81 := curSource;
    D82 := seq;
    handMs := handMs + 20;
    IF (D90 <> curId) OR (handMs >= 500) THEN stage := 43; END_IF;

43:
    D2000 := sourcePort;
    D2004 := 0;
    D2008 := 40000;
    D2012 := 40000;
    ready := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100);
    IF ready THEN waitMs := waitMs + 20; ELSE waitMs := 0; END_IF;
    IF waitMs >= 60 THEN
        IF curIndex = 0 THEN
            D300 := curId;
            IF curCancel THEN D301 := 2; ELSE D301 := 1; END_IF;
        ELSE
            D302 := curId;
            IF curCancel THEN D303 := 2; ELSE D303 := 1; END_IF;
        END_IF;
        stage := 50;
    END_IF;

50:
    D2000 := 0;
    D2004 := 0;
    D2008 := 40000;
    D2012 := 40000;
    ready := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) AND (ABS(D1016 + 60000) <= 20) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1024) <= 20) AND (ABS(D1028) <= 20) AND (ABS(D1032) <= 30) AND (ABS(moment) <= 1.0);
    IF ready THEN waitMs := waitMs + 20; ELSE waitMs := 0; END_IF;
    IF waitMs >= 60 THEN stage := 0; END_IF;

900:
    D2000 := 0;
    D2004 := 0;
    D2008 := 40000;
    D2012 := 40000;
    D2016 := -60000;
    D2020 := -60000;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    IF req0Active OR req1Active THEN
        stage := 0;
    END_IF;
ELSE
    stage := 0;
END_CASE;

finalReady := X51 AND (NOT req0Active) AND (NOT req1Active) AND (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) AND (ABS(D1016 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 30) AND (ABS(D1033) <= 100) AND (ABS(moment) <= 1.0);

Y2 := finalReady;
IF finalReady THEN
    Y30 := TRUE;
END_IF;

END_PROGRAM