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
    stage : INT;
    lastStage : INT;
    entered : BOOL;
    seq : DINT;
    activeCh : INT;
    activeId : DINT;
    activeOrig : INT;
    activeCancelled : BOOL;
    done0Id : DINT;
    done1Id : DINT;
    desiredA : DINT;
    desiredB : DINT;
    desiredC : DINT;
    desiredD : DINT;
    desiredS31 : DINT;
    desiredS32 : DINT;
    desiredS40 : DINT;
    desiredS41 : DINT;
    sourceH : DINT;
    origX : DINT;
    origReady : BOOL;
    atA : BOOL;
    atB0 : BOOL;
    atB180 : BOOL;
    liftsAtSource : BOOL;
    liftsAtHome : BOOL;
    s3Home : BOOL;
    s4Home : BOOL;
    commonStopped : BOOL;
    finalReady : BOOL;
    finalDeclared : BOOL;
    statusToWrite : DINT;
    m3Stable : TON;
    m4Stable : TON;
    finalStable : TON;
END_VAR

entered := stage <> lastStage;

IF activeCh = 0 THEN
    activeCancelled := activeCancelled OR X31;
ELSIF activeCh = 1 THEN
    activeCancelled := activeCancelled OR X35;
END_IF;

sourceH := LIMIT(0, D92, 120000);
IF sourceH = 0 THEN
    sourceH := 95000;
END_IF;

IF activeOrig = 2 THEN
    origX := D406;
    origReady := X62;
ELSE
    origX := D403;
    origReady := X61;
END_IF;

desiredA := 0;
desiredB := 0;
desiredC := 40000;
desiredD := 40000;
desiredS31 := 0;
desiredS32 := 0;
desiredS40 := 0;
desiredS41 := 0;

D80 := 0;
D81 := 0;
Y70 := FALSE;
Y71 := FALSE;
D700 := 1000;
D701 := D526;
D702 := 1000;
Y75 := FALSE;
Y76 := FALSE;
D710 := 700;
D711 := D626;
D712 := 1000;

CASE stage OF
0:
    IF (D100 <> 0) AND (D100 <> done0Id) AND NOT X30 THEN
        activeCh := 0;
        activeId := D100;
        IF D101 = 2 THEN
            activeOrig := 2;
        ELSE
            activeOrig := 1;
        END_IF;
        activeCancelled := X31;
        D300 := 0;
        D301 := 0;
        stage := 1;
    ELSIF (D120 <> 0) AND (D120 <> done1Id) AND NOT X34 THEN
        activeCh := 1;
        activeId := D120;
        IF D121 = 2 THEN
            activeOrig := 2;
        ELSE
            activeOrig := 1;
        END_IF;
        activeCancelled := X35;
        D302 := 0;
        D303 := 0;
        stage := 1;
    END_IF;

1:
    desiredA := origX;
    desiredC := sourceH;
    desiredD := sourceH;
    IF (ABS(D1000 - origX) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1008 - sourceH) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - sourceH) <= 20) AND (ABS(D1013) <= 100) AND origReady THEN
        stage := 2;
    END_IF;

2:
    desiredA := origX;
    desiredB := 18000;
    desiredC := sourceH;
    desiredD := sourceH;
    IF (ABS(D1000 - origX) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND origReady THEN
        stage := 3;
    END_IF;

3:
    desiredA := origX;
    desiredB := 18000;
    desiredC := sourceH;
    desiredD := sourceH;
    IF entered THEN
        seq := seq + 1;
    END_IF;
    D80 := 1;
    D81 := activeOrig;
    IF D90 = activeId THEN
        stage := 4;
    END_IF;

4:
    desiredA := origX;
    desiredB := 0;
    desiredC := sourceH;
    desiredD := sourceH;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF activeCancelled THEN
            stage := 90;
        ELSE
            stage := 10;
        END_IF;
    END_IF;

10:
    desiredA := D409;
    desiredC := sourceH;
    desiredD := sourceH;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       X63 AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) THEN
        stage := 11;
    END_IF;

11:
    desiredA := D409;
    desiredB := 18000;
    desiredC := sourceH;
    desiredD := sourceH;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND X63 THEN
        stage := 12;
    END_IF;

12:
    desiredA := D409;
    desiredB := 18000;
    desiredC := sourceH;
    desiredD := sourceH;
    IF entered THEN
        seq := seq + 1;
    END_IF;
    D80 := 2;
    D81 := 3;
    IF D90 <> activeId THEN
        stage := 13;
    END_IF;

13:
    desiredA := D409;
    desiredB := 0;
    desiredC := sourceH;
    desiredD := sourceH;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF activeCancelled THEN
            stage := 21;
        ELSE
            stage := 20;
        END_IF;
    END_IF;

20:
    desiredA := D409;
    desiredC := sourceH;
    desiredD := sourceH;
    desiredS31 := LIMIT(-3600000, D501, 3600000);
    desiredS32 := LIMIT(-3600000, D502, 3600000);
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := 1000;
    D701 := D526;
    D702 := 1000;
    IF activeCancelled THEN
        stage := 21;
    ELSIF X70 THEN
        stage := 21;
    END_IF;

21:
    desiredA := D409;
    desiredC := sourceH;
    desiredD := sourceH;
    desiredS31 := 0;
    desiredS32 := 0;
    IF NOT activeCancelled THEN
        Y71 := TRUE;
    END_IF;
    IF (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) THEN
        stage := 30;
    END_IF;

30:
    desiredA := D409;
    desiredC := sourceH;
    desiredD := sourceH;
    IF NOT activeCancelled THEN
        Y71 := TRUE;
    END_IF;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X63 AND
       (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) THEN
        stage := 31;
    END_IF;

31:
    desiredA := D409;
    desiredB := 18000;
    desiredC := sourceH;
    desiredD := sourceH;
    IF NOT activeCancelled THEN
        Y71 := TRUE;
    END_IF;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 32;
    END_IF;

32:
    desiredA := D409;
    desiredB := 18000;
    desiredC := sourceH;
    desiredD := sourceH;
    IF NOT activeCancelled THEN
        Y71 := TRUE;
    END_IF;
    IF entered THEN
        seq := seq + 1;
    END_IF;
    D80 := 1;
    D81 := 3;
    IF D90 = activeId THEN
        stage := 33;
    END_IF;

33:
    desiredA := D409;
    desiredB := 0;
    desiredC := sourceH;
    desiredD := sourceH;
    IF NOT activeCancelled THEN
        Y71 := TRUE;
    END_IF;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF activeCancelled THEN
            stage := 90;
        ELSE
            stage := 40;
        END_IF;
    END_IF;

40:
    desiredA := D412;
    desiredC := sourceH;
    desiredD := sourceH;
    Y71 := TRUE;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X64 AND
       (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
        stage := 41;
    END_IF;

41:
    desiredA := D412;
    desiredB := 18000;
    desiredC := sourceH;
    desiredD := sourceH;
    Y71 := TRUE;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 42;
    END_IF;

42:
    desiredA := D412;
    desiredB := 18000;
    desiredC := sourceH;
    desiredD := sourceH;
    Y71 := TRUE;
    IF entered THEN
        seq := seq + 1;
    END_IF;
    D80 := 2;
    D81 := 4;
    IF D90 <> activeId THEN
        stage := 43;
    END_IF;

43:
    desiredA := D412;
    desiredB := 0;
    desiredC := sourceH;
    desiredD := sourceH;
    Y71 := TRUE;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 50;
    END_IF;

50:
    desiredA := D412;
    desiredC := sourceH;
    desiredD := sourceH;
    desiredS40 := LIMIT(-360000, D600, 360000);
    desiredS41 := LIMIT(-360000, D601, 360000);
    Y71 := TRUE;
    Y75 := NOT activeCancelled;
    Y76 := NOT activeCancelled;
    D710 := 700;
    D711 := D626;
    D712 := 1000;
    IF activeCancelled OR X75 THEN
        stage := 51;
    END_IF;

51:
    desiredA := D412;
    desiredC := sourceH;
    desiredD := sourceH;
    desiredS40 := 0;
    desiredS41 := 0;
    Y71 := TRUE;
    IF (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
        stage := 60;
    END_IF;

60:
    desiredA := D412;
    desiredC := sourceH;
    desiredD := sourceH;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X64 AND
       (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
        stage := 61;
    END_IF;

61:
    desiredA := D412;
    desiredB := 18000;
    desiredC := sourceH;
    desiredD := sourceH;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 62;
    END_IF;

62:
    desiredA := D412;
    desiredB := 18000;
    desiredC := sourceH;
    desiredD := sourceH;
    IF entered THEN
        seq := seq + 1;
    END_IF;
    D80 := 1;
    D81 := 4;
    IF D90 = activeId THEN
        stage := 63;
    END_IF;

63:
    desiredA := D412;
    desiredB := 0;
    desiredC := sourceH;
    desiredD := sourceH;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 90;
    END_IF;

90:
    desiredA := origX;
    desiredB := 0;
    desiredC := sourceH;
    desiredD := sourceH;
    IF (ABS(D1000 - origX) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1008 - sourceH) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - sourceH) <= 20) AND (ABS(D1013) <= 100) AND origReady THEN
        stage := 91;
    END_IF;

91:
    desiredA := origX;
    desiredB := 18000;
    desiredC := sourceH;
    desiredD := sourceH;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 92;
    END_IF;

92:
    desiredA := origX;
    desiredB := 18000;
    desiredC := sourceH;
    desiredD := sourceH;
    IF entered THEN
        seq := seq + 1;
    END_IF;
    D80 := 2;
    D81 := activeOrig;
    IF D90 <> activeId THEN
        stage := 93;
    END_IF;

93:
    desiredA := origX;
    desiredB := 0;
    desiredC := sourceH;
    desiredD := sourceH;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 95;
    END_IF;

95:
    desiredA := origX;
    desiredB := 0;
    desiredC := 40000;
    desiredD := 40000;
    IF (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) THEN
        stage := 96;
    END_IF;

96:
    desiredA := 0;
    desiredB := 0;
    desiredC := 40000;
    desiredD := 40000;
    statusToWrite := 1;
    IF activeCancelled THEN
        statusToWrite := 2;
    END_IF;
    IF activeCh = 0 THEN
        D300 := activeId;
        D301 := statusToWrite;
        done0Id := activeId;
    ELSIF activeCh = 1 THEN
        D302 := activeId;
        D303 := statusToWrite;
        done1Id := activeId;
    END_IF;
    activeCh := -1;
    activeId := 0;
    activeCancelled := FALSE;
    stage := 0;

ELSE
    stage := 0;
END_CASE;

m3Stable(IN := (stage = 20) AND ((ABS(D1020 - D501) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024 - D502) <= 20) AND (ABS(D1025) <= 100)), PT := T#80ms);
m4Stable(IN := (stage = 50) AND ((ABS(D1028 - D600) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - D601) <= 20) AND (ABS(D1033) <= 100)), PT := T#80ms);

D2000 := LIMIT(-450000, desiredA, 450000);
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2004 := LIMIT(0, desiredB, 18000);
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

D2008 := LIMIT(0, desiredC, 120000);
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

D2012 := LIMIT(0, desiredD, 120000);
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2016 := 0;
D2017 := 1000;
D2018 := 0;
Y44 := FALSE;

D2020 := LIMIT(-3600000, desiredS31, 3600000);
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2024 := LIMIT(-3600000, desiredS32, 3600000);
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2028 := LIMIT(-360000, desiredS40, 360000);
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

D2032 := LIMIT(-360000, desiredS41, 360000);
D2033 := 1000;
D2034 := 0;
Y48 := TRUE;

D82 := seq;

commonStopped := ABS(D1017) <= 100;
finalReady := X51 AND (stage = 0) AND (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
              (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
              (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
              (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) AND
              (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
              (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
              (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
              (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) AND
              commonStopped;

finalStable(IN := finalReady, PT := T#100ms);
IF finalStable.Q THEN
    finalDeclared := TRUE;
END_IF;

Y2 := finalDeclared AND finalReady;
Y30 := finalReady;

lastStage := stage;

END_PROGRAM