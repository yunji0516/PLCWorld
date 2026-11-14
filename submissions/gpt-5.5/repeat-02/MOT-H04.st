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
    D502 : DINT;
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
    phase : INT;
    currentSlot : INT;
    currentId : DINT;
    currentLoc : INT;
    currentStatus : DINT;
    cancelFlag : BOOL;
    seq : DINT;
    done0Id : DINT;
    done0Status : DINT;
    done1Id : DINT;
    done1Status : DINT;
    dockHeight : DINT;
    portX : DINT;
    s3g0 : DINT;
    s3g1 : DINT;
    s3g2 : DINT;
    s4g0 : DINT;
    s4g1 : DINT;
    s4xCalc : DINT;
    err : DINT;
    vel : DINT;
    accCmd : DINT;
    thetaRad : REAL;
    xReal : REAL;
    piVal : REAL := 3.14159265;
    finalStable : BOOL;
END_VAR

dockHeight := D92;
IF dockHeight < 0 THEN
    dockHeight := 0;
END_IF;
IF dockHeight > 120000 THEN
    dockHeight := 120000;
END_IF;

s3g0 := D500;
IF s3g0 < 50000 THEN
    s3g0 := 50000;
END_IF;
IF s3g0 > 150000 THEN
    s3g0 := 150000;
END_IF;

s3g1 := D501;
IF s3g1 < -100000 THEN
    s3g1 := -100000;
END_IF;
IF s3g1 > 100000 THEN
    s3g1 := 100000;
END_IF;

s3g2 := D502;
IF s3g2 < -3000 THEN
    s3g2 := -3000;
END_IF;
IF s3g2 > 3000 THEN
    s3g2 := 3000;
END_IF;

s4g0 := D600;
IF s4g0 < -5000 THEN
    s4g0 := -5000;
END_IF;
IF s4g0 > 5000 THEN
    s4g0 := 5000;
END_IF;

thetaRad := (REAL(s4g0) / 100.0) * piVal / 180.0;
xReal := -45000.0 * SIN(thetaRad);
s4xCalc := DINT(ROUND(xReal));

IF D601 = 0 THEN
    s4g1 := s4xCalc;
ELSE
    s4g1 := D601;
END_IF;
IF s4g1 < -45000 THEN
    s4g1 := -45000;
END_IF;
IF s4g1 > 45000 THEN
    s4g1 := 45000;
END_IF;

D2000 := 0;
D2001 := 850;
D2002 := 0;
Y40 := TRUE;
D2004 := 0;
D2005 := 850;
D2006 := 0;
Y41 := TRUE;
D2008 := 40000;
D2009 := 850;
D2010 := 0;
Y42 := TRUE;
D2012 := 40000;
D2013 := 850;
D2014 := 0;
Y43 := TRUE;

D2016 := 100000;
D2017 := 800;
D2018 := 0;
Y44 := TRUE;
D2020 := 0;
D2021 := 700;
D2022 := 0;
Y45 := TRUE;
D2024 := 0;
D2025 := 600;
D2026 := 0;
Y46 := FALSE;

D2028 := 0;
D2029 := 750;
D2030 := 0;
Y47 := TRUE;
D2032 := 0;
D2033 := 850;
D2034 := 0;
Y48 := TRUE;

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

D80 := 0;
D81 := 0;
D82 := seq;
Y30 := FALSE;

IF currentSlot = 0 THEN
    IF X31 THEN
        cancelFlag := TRUE;
    END_IF;
ELSIF currentSlot = 1 THEN
    IF X35 THEN
        cancelFlag := TRUE;
    END_IF;
END_IF;

IF phase = 0 THEN
    currentSlot := -1;
    currentId := 0;
    cancelFlag := FALSE;
    currentStatus := 1;
    IF (D100 <> 0) AND (D100 <> done0Id) THEN
        currentSlot := 0;
        currentId := D100;
        currentLoc := INT(D101);
        IF (currentLoc < 1) OR (currentLoc > 2) THEN
            currentLoc := 1;
        END_IF;
        cancelFlag := X31;
        currentStatus := 1;
        phase := 10;
    ELSIF (D120 <> 0) AND (D120 <> done1Id) THEN
        currentSlot := 1;
        currentId := D120;
        currentLoc := INT(D121);
        IF (currentLoc < 1) OR (currentLoc > 2) THEN
            currentLoc := 2;
        END_IF;
        cancelFlag := X35;
        currentStatus := 1;
        phase := 10;
    END_IF;
END_IF;

CASE phase OF
10:
    IF D90 = currentId THEN
        IF cancelFlag THEN
            phase := 80;
        ELSE
            phase := 20;
        END_IF;
    ELSE
        IF currentLoc = 1 THEN
            portX := D403;
            D2000 := portX;
            D81 := 1;
        ELSE
            portX := D406;
            D2000 := portX;
            D81 := 2;
        END_IF;
        D2004 := 0;
        D2008 := dockHeight;
        D2012 := dockHeight;
        IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
           (ABS(D1008 - dockHeight) <= 20) AND (ABS(D1009) <= 100) AND
           (ABS(D1012 - dockHeight) <= 20) AND (ABS(D1013) <= 100) AND
           (((currentLoc = 1) AND X61 AND (D404 = currentId)) OR ((currentLoc = 2) AND X62 AND (D407 = currentId))) THEN
            seq := seq + 1;
            D82 := seq;
            D80 := 1;
            D81 := currentLoc;
            phase := 12;
        END_IF;
    END_IF;

12:
    D2004 := 0;
    D2008 := dockHeight;
    D2012 := dockHeight;
    IF currentLoc = 1 THEN
        D2000 := D403;
    ELSE
        D2000 := D406;
    END_IF;
    IF D90 = currentId THEN
        IF cancelFlag THEN
            phase := 80;
        ELSE
            phase := 20;
        END_IF;
    END_IF;

20:
    D2004 := 0;
    D2000 := D409;
    D2016 := 100000;
    D2020 := 0;
    D2024 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1016 - 100000) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1024) <= 3) AND (ABS(D1025) <= 15) AND X63 THEN
        phase := 21;
    END_IF;

21:
    D2000 := D409;
    D2004 := 18000;
    D2016 := 100000;
    D2020 := 0;
    D2024 := 0;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1016 - 100000) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1024) <= 3) AND (ABS(D1025) <= 15) AND X63 THEN
        seq := seq + 1;
        D82 := seq;
        D80 := 2;
        D81 := 3;
        phase := 22;
    END_IF;

22:
    D2000 := D409;
    D2004 := 0;
    D2016 := 100000;
    D2020 := 0;
    D2024 := 0;
    Y71 := TRUE;
    D700 := currentId;
    D701 := D526;
    IF D90 <> currentId THEN
        phase := 30;
    END_IF;

30:
    D2004 := 0;
    D2016 := s3g0;
    D2020 := s3g1;
    D2024 := s3g2;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := currentId;
    D701 := D526;
    err := s3g1 - D1020;
    vel := D1021;
    accCmd := (err / 8) - (vel / 3);
    IF accCmd > 60000 THEN
        accCmd := 60000;
    END_IF;
    IF accCmd < -60000 THEN
        accCmd := -60000;
    END_IF;
    D702 := accCmd;
    IF X70 OR cancelFlag THEN
        phase := 31;
    END_IF;

31:
    D2004 := 0;
    D2016 := 100000;
    D2020 := 0;
    D2024 := 0;
    Y71 := TRUE;
    D700 := currentId;
    D701 := D526;
    err := 0 - D1020;
    vel := D1021;
    accCmd := (err / 8) - (vel / 3);
    IF accCmd > 60000 THEN
        accCmd := 60000;
    END_IF;
    IF accCmd < -60000 THEN
        accCmd := -60000;
    END_IF;
    D702 := accCmd;
    IF (ABS(D1016 - 100000) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1024) <= 3) AND (ABS(D1025) <= 15) AND X63 THEN
        phase := 40;
    END_IF;

40:
    D2000 := D409;
    D2004 := 0;
    D2016 := 100000;
    D2020 := 0;
    D2024 := 0;
    Y71 := TRUE;
    D700 := currentId;
    D701 := D526;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1016 - 100000) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1024) <= 3) AND (ABS(D1025) <= 15) AND X63 AND (D410 = currentId) THEN
        seq := seq + 1;
        D82 := seq;
        D80 := 1;
        D81 := 3;
        phase := 42;
    END_IF;

42:
    D2000 := D409;
    D2004 := 0;
    D2016 := 100000;
    D2020 := 0;
    D2024 := 0;
    Y71 := TRUE;
    D700 := currentId;
    D701 := D526;
    IF D90 = currentId THEN
        IF cancelFlag THEN
            phase := 80;
        ELSE
            phase := 50;
        END_IF;
    END_IF;

50:
    D2004 := 0;
    D2000 := D412;
    D2028 := 0;
    D2032 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) AND X64 THEN
        phase := 51;
    END_IF;

51:
    D2000 := D412;
    D2004 := 18000;
    D2028 := 0;
    D2032 := 0;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) AND X64 THEN
        seq := seq + 1;
        D82 := seq;
        D80 := 2;
        D81 := 4;
        phase := 52;
    END_IF;

52:
    D2000 := D412;
    D2004 := 0;
    D2028 := 0;
    D2032 := 0;
    Y76 := TRUE;
    D710 := currentId;
    D711 := D626;
    IF D90 <> currentId THEN
        phase := 60;
    END_IF;

60:
    D2004 := 0;
    D2028 := s4g0;
    D2032 := s4g1;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := currentId;
    D711 := D626;
    IF X75 OR cancelFlag THEN
        phase := 61;
    END_IF;

61:
    D2004 := 0;
    D2028 := 0;
    D2032 := 0;
    Y76 := TRUE;
    D710 := currentId;
    D711 := D626;
    IF (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) AND X64 THEN
        phase := 70;
    END_IF;

70:
    D2000 := D412;
    D2004 := 0;
    D2028 := 0;
    D2032 := 0;
    Y76 := TRUE;
    D710 := currentId;
    D711 := D626;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) AND X64 AND (D413 = currentId) THEN
        seq := seq + 1;
        D82 := seq;
        D80 := 1;
        D81 := 4;
        phase := 72;
    END_IF;

72:
    D2000 := D412;
    D2004 := 0;
    D2028 := 0;
    D2032 := 0;
    Y76 := TRUE;
    D710 := currentId;
    D711 := D626;
    IF D90 = currentId THEN
        phase := 80;
    END_IF;

80:
    D2004 := 0;
    D2008 := dockHeight;
    D2012 := dockHeight;
    IF currentLoc = 1 THEN
        D2000 := D403;
    ELSE
        D2000 := D406;
    END_IF;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1008 - dockHeight) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - dockHeight) <= 20) AND (ABS(D1013) <= 100) AND
       (((currentLoc = 1) AND X61) OR ((currentLoc = 2) AND X62)) THEN
        phase := 81;
    END_IF;

81:
    D2008 := dockHeight;
    D2012 := dockHeight;
    IF currentLoc = 1 THEN
        D2000 := D403;
        D81 := 1;
    ELSE
        D2000 := D406;
        D81 := 2;
    END_IF;
    D2004 := 18000;
    IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1008 - dockHeight) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - dockHeight) <= 20) AND (ABS(D1013) <= 100) AND
       (((currentLoc = 1) AND X61) OR ((currentLoc = 2) AND X62)) THEN
        seq := seq + 1;
        D82 := seq;
        D80 := 2;
        D81 := currentLoc;
        phase := 82;
    END_IF;

82:
    IF currentLoc = 1 THEN
        D2000 := D403;
    ELSE
        D2000 := D406;
    END_IF;
    D2004 := 0;
    D2008 := 40000;
    D2012 := 40000;
    IF D90 <> currentId THEN
        phase := 83;
    END_IF;

83:
    D2000 := 0;
    D2004 := 0;
    D2008 := 40000;
    D2012 := 40000;
    IF cancelFlag THEN
        currentStatus := 2;
    ELSE
        currentStatus := 1;
    END_IF;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) THEN
        IF currentSlot = 0 THEN
            done0Id := currentId;
            done0Status := currentStatus;
        ELSE
            done1Id := currentId;
            done1Status := currentStatus;
        END_IF;
        phase := 0;
        currentSlot := -1;
        currentId := 0;
        cancelFlag := FALSE;
    END_IF;
ELSE
END_CASE;

IF (D100 <> 0) AND (D100 = done0Id) THEN
    D300 := done0Id;
    D301 := done0Status;
ELSE
    D300 := 0;
    D301 := 0;
END_IF;

IF (D120 <> 0) AND (D120 = done1Id) THEN
    D302 := done1Id;
    D303 := done1Status;
ELSE
    D302 := 0;
    D303 := 0;
END_IF;

finalStable := X51 AND
    (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
    (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
    (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
    (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) AND
    (ABS(D1016 - 100000) <= 20) AND (ABS(D1017) <= 100) AND
    (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
    (ABS(D1024) <= 3) AND (ABS(D1025) <= 15) AND
    (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
    (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);

Y2 := finalStable;

END_PROGRAM