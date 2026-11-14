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
    seq : DINT;
    seqIssued : BOOL;
    curSlot : INT;
    curID : DINT;
    curOrigin : INT;
    curRecipe : DINT;
    curCancelled : BOOL;
    r0_seen : DINT;
    r1_seen : DINT;
    r0_done : BOOL;
    r1_done : BOOL;
    r0_status : DINT;
    r1_status : DINT;
    originX : DINT;
    originReady : BOOL;
    liftHigh : DINT;
    liftDesired : DINT;
    cCmd : DINT;
    dCmd : DINT;
    avgLift : DINT;
    movingUp : BOOL;
    recipeSel : INT;
    angle0Target : DINT;
    angle1Target : DINT;
    cwTarget : DINT;
    cwReal : REAL;
    a0Real : REAL;
    a1Real : REAL;
    momentNm : REAL;
    prevRecord : DINT;
    pocket : INT;
    pocketTarget : DINT;
    finalHome : BOOL;
    s3Home : BOOL;
    s4Home : BOOL;
    liftAtDesired : BOOL;
    tCouple : TON;
    tFinal : TON;
END_VAR

IF D100 <> r0_seen THEN
    r0_seen := D100;
    r0_done := FALSE;
    r0_status := 0;
END_IF;
IF D120 <> r1_seen THEN
    r1_seen := D120;
    r1_done := FALSE;
    r1_status := 0;
END_IF;

IF D92 < 0 THEN
    liftHigh := 95000;
ELSIF D92 > 120000 THEN
    liftHigh := 95000;
ELSIF D92 = 0 THEN
    liftHigh := 95000;
ELSE
    liftHigh := D92;
END_IF;

IF curOrigin = 2 THEN
    originX := D406;
    originReady := X62;
ELSE
    originX := D403;
    originReady := X61;
END_IF;
IF originX < -450000 THEN
    originX := -450000;
ELSIF originX > 450000 THEN
    originX := 450000;
END_IF;

a0Real := REAL(D1016) * 0.01;
a1Real := REAL(D1020) * 0.01;
cwReal := -22500.0 * (SIN(a0Real * 0.0174532925) + SIN(a1Real * 0.0174532925));
cwTarget := DINT(REAL_TO_INT(cwReal));
IF cwTarget < -45000 THEN
    cwTarget := -45000;
ELSIF cwTarget > 45000 THEN
    cwTarget := 45000;
END_IF;
momentNm := 0.1962 * (225.0 * (SIN(a0Real * 0.0174532925) + SIN(a1Real * 0.0174532925)) + REAL(D1024) * 0.01);

IF (D500 >= -5000) AND (D500 <= 5000) AND ((D500 <> 0) OR (D501 <> 0)) THEN
    angle0Target := D500;
    angle1Target := D501;
ELSE
    IF (curRecipe = 180) OR (curRecipe >= 13500) THEN
        angle0Target := -3500;
        angle1Target := 2000;
    ELSE
        angle0Target := 3500;
        angle1Target := -2000;
    END_IF;
END_IF;
IF angle0Target < -5000 THEN
    angle0Target := -5000;
ELSIF angle0Target > 5000 THEN
    angle0Target := 5000;
END_IF;
IF angle1Target < -5000 THEN
    angle1Target := -5000;
ELSIF angle1Target > 5000 THEN
    angle1Target := 5000;
END_IF;

s3Home := (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024) <= 20) AND (ABS(D1025) <= 100);
s4Home := (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) AND (ABS(D1036) <= 20) AND (ABS(D1037) <= 100);

tCouple(IN := (state = 12) OR (state = 22) OR (state = 42) OR (state = 52) OR (state = 72) OR (state = 82), PT := T#500ms);

D2000 := 0;
D2001 := 900;
D2002 := 0;
Y40 := TRUE;
D2004 := 0;
D2005 := 900;
D2006 := 0;
Y41 := TRUE;
liftDesired := 40000;
D2009 := 900;
D2010 := 0;
Y42 := TRUE;
D2013 := 900;
D2014 := 0;
Y43 := TRUE;
D2016 := 0;
D2017 := 900;
D2018 := 0;
Y44 := TRUE;
D2020 := 0;
D2021 := 900;
D2022 := 0;
Y45 := TRUE;
D2024 := cwTarget;
D2025 := 900;
D2026 := 0;
Y46 := TRUE;
D2028 := 0;
D2029 := 900;
D2030 := 0;
Y47 := TRUE;
D2032 := 0;
D2033 := 900;
D2034 := 0;
Y48 := TRUE;
D2036 := 0;
D2037 := 900;
D2038 := 0;
Y49 := TRUE;
D80 := 0;
D81 := 0;
D82 := seq;
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
Y30 := FALSE;

CASE state OF
0:
    state := 1;
1:
    IF (D100 <> 0) AND NOT r0_done THEN
        curSlot := 0;
        curID := D100;
        curRecipe := D104;
        curCancelled := X31;
        IF (D101 = 1) OR (D101 = 2) THEN
            curOrigin := INT(D101);
        ELSE
            curOrigin := 1;
        END_IF;
        seqIssued := FALSE;
        state := 10;
    ELSIF (D120 <> 0) AND NOT r1_done THEN
        curSlot := 1;
        curID := D120;
        curRecipe := D124;
        curCancelled := X35;
        IF (D121 = 1) OR (D121 = 2) THEN
            curOrigin := INT(D121);
        ELSE
            curOrigin := 2;
        END_IF;
        seqIssued := FALSE;
        state := 10;
    END_IF;

10:
    IF curSlot = 0 THEN
        curCancelled := curCancelled OR X31;
    ELSE
        curCancelled := curCancelled OR X35;
    END_IF;
    D2000 := originX;
    liftDesired := liftHigh;
    D2004 := 0;
    liftAtDesired := (ABS(D1008 - liftHigh) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - liftHigh) <= 20) AND (ABS(D1013) <= 100);
    IF (ABS(D1000 - originX) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND liftAtDesired AND originReady THEN
        seqIssued := FALSE;
        state := 11;
    END_IF;

11:
    D2000 := originX;
    liftDesired := liftHigh;
    D2004 := 18000;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
        IF NOT seqIssued THEN
            seq := seq + 1;
            seqIssued := TRUE;
        END_IF;
        D82 := seq;
        D80 := 1;
        D81 := curOrigin;
        state := 12;
    END_IF;

12:
    D2000 := originX;
    liftDesired := liftHigh;
    D2004 := 18000;
    D80 := 1;
    D81 := curOrigin;
    D82 := seq;
    IF (D90 = curID) OR tCouple.Q THEN
        state := 13;
    END_IF;

13:
    D2000 := originX;
    liftDesired := liftHigh;
    D2004 := 0;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        state := 20;
    END_IF;

20:
    D2000 := D409;
    liftDesired := 40000;
    D2004 := 0;
    Y70 := TRUE;
    D700 := curRecipe;
    D701 := curID;
    D702 := 800;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X63 AND s3Home THEN
        seqIssued := FALSE;
        state := 21;
    END_IF;

21:
    D2000 := D409;
    D2004 := 18000;
    Y70 := TRUE;
    D700 := curRecipe;
    D701 := curID;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
        IF NOT seqIssued THEN
            seq := seq + 1;
            seqIssued := TRUE;
        END_IF;
        D82 := seq;
        D80 := 2;
        D81 := 3;
        state := 22;
    END_IF;

22:
    D2000 := D409;
    D2004 := 18000;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := curRecipe;
    D701 := curID;
    D80 := 2;
    D81 := 3;
    D82 := seq;
    IF (D410 = curID) OR tCouple.Q THEN
        state := 23;
    END_IF;

23:
    D2000 := D409;
    D2004 := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := curRecipe;
    D701 := curID;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        state := 30;
    END_IF;

30:
    D2000 := D409;
    D2004 := 0;
    D2016 := angle0Target;
    D2020 := angle1Target;
    D2024 := cwTarget;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := curRecipe;
    D701 := 1;
    D702 := 900;
    IF X70 AND (ABS(D1016 - angle0Target) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - angle1Target) <= 20) AND (ABS(D1021) <= 100) AND (ABS(momentNm) <= 1.0) THEN
        prevRecord := D527;
        IF prevRecord = 0 THEN
            prevRecord := D1016 + D1020;
        END_IF;
        state := 31;
    END_IF;

31:
    D2000 := D409;
    D2004 := 0;
    D2016 := 0;
    D2020 := 0;
    D2024 := cwTarget;
    Y71 := TRUE;
    IF s3Home THEN
        state := 40;
    END_IF;

40:
    D2000 := D409;
    D2004 := 0;
    D2016 := 0;
    D2020 := 0;
    D2024 := cwTarget;
    Y71 := TRUE;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X63 AND s3Home THEN
        seqIssued := FALSE;
        state := 41;
    END_IF;

41:
    D2000 := D409;
    D2004 := 18000;
    D2016 := 0;
    D2020 := 0;
    D2024 := cwTarget;
    Y71 := TRUE;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
        IF NOT seqIssued THEN
            seq := seq + 1;
            seqIssued := TRUE;
        END_IF;
        D82 := seq;
        D80 := 1;
        D81 := 3;
        state := 42;
    END_IF;

42:
    D2000 := D409;
    D2004 := 18000;
    Y71 := TRUE;
    D80 := 1;
    D81 := 3;
    D82 := seq;
    IF (D90 = curID) OR tCouple.Q THEN
        state := 43;
    END_IF;

43:
    D2000 := D409;
    D2004 := 0;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        state := 50;
    END_IF;

50:
    D2000 := D412;
    D2004 := 0;
    IF prevRecord < 0 THEN
        pocket := 1;
    ELSE
        pocket := 2;
    END_IF;
    D710 := pocket;
    D711 := pocket;
    Y75 := TRUE;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X64 AND s4Home THEN
        seqIssued := FALSE;
        state := 51;
    END_IF;

51:
    D2000 := D412;
    D2004 := 18000;
    Y75 := TRUE;
    D710 := pocket;
    D711 := pocket;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
        IF NOT seqIssued THEN
            seq := seq + 1;
            seqIssued := TRUE;
        END_IF;
        D82 := seq;
        D80 := 2;
        D81 := 4;
        state := 52;
    END_IF;

52:
    D2000 := D412;
    D2004 := 18000;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := pocket;
    D711 := pocket;
    D80 := 2;
    D81 := 4;
    D82 := seq;
    IF (D413 = curID) OR tCouple.Q THEN
        state := 53;
    END_IF;

53:
    D2000 := D412;
    D2004 := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := pocket;
    D711 := pocket;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        state := 60;
    END_IF;

60:
    D2000 := D412;
    D2004 := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := pocket;
    D711 := pocket;
    D712 := 900;
    pocketTarget := 70000;
    IF pocket = 1 THEN
        IF (D600 > 0) AND (D600 <= 100000) THEN
            pocketTarget := D600;
        END_IF;
        D2028 := pocketTarget;
        D2032 := 0;
        IF X75 AND (ABS(D1028 - pocketTarget) <= 20) AND (ABS(D1029) <= 100) AND (D1032 <= 8000) THEN
            state := 61;
        END_IF;
    ELSE
        IF (D601 > 0) AND (D601 <= 100000) THEN
            pocketTarget := D601;
        END_IF;
        D2028 := 0;
        D2032 := pocketTarget;
        IF X75 AND (ABS(D1032 - pocketTarget) <= 20) AND (ABS(D1033) <= 100) AND (D1028 <= 8000) THEN
            state := 61;
        END_IF;
    END_IF;
    D2036 := 0;

61:
    D2000 := D412;
    D2004 := 0;
    D2028 := 0;
    D2032 := 0;
    D2036 := 0;
    Y76 := TRUE;
    D710 := pocket;
    D711 := pocket;
    IF s4Home THEN
        state := 70;
    END_IF;

70:
    D2000 := D412;
    D2004 := 0;
    D2028 := 0;
    D2032 := 0;
    D2036 := 0;
    Y76 := TRUE;
    D710 := pocket;
    D711 := pocket;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X64 AND s4Home THEN
        seqIssued := FALSE;
        state := 71;
    END_IF;

71:
    D2000 := D412;
    D2004 := 18000;
    Y76 := TRUE;
    D710 := pocket;
    D711 := pocket;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
        IF NOT seqIssued THEN
            seq := seq + 1;
            seqIssued := TRUE;
        END_IF;
        D82 := seq;
        D80 := 1;
        D81 := 4;
        state := 72;
    END_IF;

72:
    D2000 := D412;
    D2004 := 18000;
    Y76 := TRUE;
    D710 := pocket;
    D711 := pocket;
    D80 := 1;
    D81 := 4;
    D82 := seq;
    IF (D90 = curID) OR tCouple.Q THEN
        state := 73;
    END_IF;

73:
    D2000 := D412;
    D2004 := 0;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        state := 80;
    END_IF;

80:
    D2000 := originX;
    D2004 := 0;
    liftDesired := liftHigh;
    liftAtDesired := (ABS(D1008 - liftHigh) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - liftHigh) <= 20) AND (ABS(D1013) <= 100);
    IF (ABS(D1000 - originX) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND liftAtDesired AND originReady THEN
        seqIssued := FALSE;
        state := 81;
    END_IF;

81:
    D2000 := originX;
    D2004 := 18000;
    liftDesired := liftHigh;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
        IF NOT seqIssued THEN
            seq := seq + 1;
            seqIssued := TRUE;
        END_IF;
        D82 := seq;
        D80 := 2;
        D81 := curOrigin;
        state := 82;
    END_IF;

82:
    D2000 := originX;
    D2004 := 18000;
    liftDesired := liftHigh;
    D80 := 2;
    D81 := curOrigin;
    D82 := seq;
    IF ((curOrigin = 1) AND (D404 = curID)) OR ((curOrigin = 2) AND (D407 = curID)) OR tCouple.Q THEN
        state := 83;
    END_IF;

83:
    D2000 := originX;
    D2004 := 0;
    liftDesired := 40000;
    liftAtDesired := (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100);
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND liftAtDesired THEN
        IF curSlot = 0 THEN
            r0_done := TRUE;
            IF curCancelled OR X31 THEN
                r0_status := 2;
            ELSE
                r0_status := 1;
            END_IF;
        ELSE
            r1_done := TRUE;
            IF curCancelled OR X35 THEN
                r1_status := 2;
            ELSE
                r1_status := 1;
            END_IF;
        END_IF;
        curID := 0;
        state := 1;
    END_IF;
ELSE
    state := 1;
END_CASE;

IF D2000 < -450000 THEN
    D2000 := -450000;
ELSIF D2000 > 450000 THEN
    D2000 := 450000;
END_IF;
IF D2004 < 0 THEN
    D2004 := 0;
ELSIF D2004 > 18000 THEN
    D2004 := 18000;
END_IF;

avgLift := (D1008 + D1012) / 2;
movingUp := liftDesired > avgLift;
cCmd := liftDesired;
dCmd := liftDesired;
IF D1008 > D1012 + 3000 THEN
    IF movingUp THEN
        IF cCmd > D1008 THEN
            cCmd := D1008;
        END_IF;
    ELSE
        IF dCmd < D1012 THEN
            dCmd := D1012;
        END_IF;
    END_IF;
ELSIF D1012 > D1008 + 3000 THEN
    IF movingUp THEN
        IF dCmd > D1012 THEN
            dCmd := D1012;
        END_IF;
    ELSE
        IF cCmd < D1008 THEN
            cCmd := D1008;
        END_IF;
    END_IF;
END_IF;
IF cCmd < 0 THEN
    cCmd := 0;
ELSIF cCmd > 120000 THEN
    cCmd := 120000;
END_IF;
IF dCmd < 0 THEN
    dCmd := 0;
ELSIF dCmd > 120000 THEN
    dCmd := 120000;
END_IF;
D2008 := cCmd;
D2012 := dCmd;

IF D2016 < -5000 THEN
    D2016 := -5000;
ELSIF D2016 > 5000 THEN
    D2016 := 5000;
END_IF;
IF D2020 < -5000 THEN
    D2020 := -5000;
ELSIF D2020 > 5000 THEN
    D2020 := 5000;
END_IF;
IF D2024 < -45000 THEN
    D2024 := -45000;
ELSIF D2024 > 45000 THEN
    D2024 := 45000;
END_IF;
IF D2028 < 0 THEN
    D2028 := 0;
ELSIF D2028 > 100000 THEN
    D2028 := 100000;
END_IF;
IF D2032 < 0 THEN
    D2032 := 0;
ELSIF D2032 > 100000 THEN
    D2032 := 100000;
END_IF;
IF D2036 < 0 THEN
    D2036 := 0;
ELSIF D2036 > 100000 THEN
    D2036 := 100000;
END_IF;

IF r0_done THEN
    D300 := r0_seen;
    D301 := r0_status;
ELSE
    D300 := 0;
    D301 := 0;
END_IF;
IF r1_done THEN
    D302 := r1_seen;
    D303 := r1_status;
ELSE
    D302 := 0;
    D303 := 0;
END_IF;

finalHome := X51 AND (state = 1) AND (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) AND s3Home AND s4Home;
tFinal(IN := finalHome, PT := T#100ms);
Y2 := tFinal.Q;
IF Y2 THEN
    Y30 := TRUE;
END_IF;

END_PROGRAM