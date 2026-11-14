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
    stage : INT;
    prevStage : INT;
    procStep : INT;
    curCh : INT;
    curId : DINT;
    curOrigin : INT;
    curStatus : DINT;
    lastAck0 : DINT;
    lastAck1 : DINT;
    cancelMode : BOOL;
    seq : DINT;
    targetA : DINT;
    targetB : DINT;
    targetC : DINT;
    targetD : DINT;
    targetS30 : DINT;
    targetS31 : DINT;
    targetS40 : DINT;
    targetS41 : DINT;
    targetS42 : DINT;
    targetS43 : DINT;
    originPort : DINT;
    originReady : BOOL;
    liftAtDock : BOOL;
    liftAtHome : BOOL;
    finalHome : BOOL;
    finalDeclared : BOOL;
    finalTimer : TON;
    g0 : DINT;
    g1 : DINT;
    g2 : DINT;
    g3 : DINT;
END_VAR

targetA := 0;
targetB := 0;
targetC := 15000;
targetD := 15000;
targetS30 := 0;
targetS31 := 5000;
targetS40 := -6500;
targetS41 := 0;
targetS42 := 6500;
targetS43 := 0;

D80 := 0;
D81 := 0;
D82 := seq;

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

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;
Y49 := TRUE;
Y30 := FALSE;

IF curOrigin = 2 THEN
    originPort := D406;
    originReady := X62;
ELSE
    originPort := D403;
    originReady := X61;
END_IF;

IF (stage >= 100) AND (stage < 210) AND NOT cancelMode THEN
    IF ((curCh = 0) AND X31) OR ((curCh = 1) AND X35) THEN
        cancelMode := TRUE;
        curStatus := 2;
        stage := 500;
    END_IF;
END_IF;

IF stage <> prevStage THEN
    IF (stage = 110) OR (stage = 130) OR (stage = 150) OR (stage = 170) OR (stage = 190) OR (stage = 200) THEN
        seq := seq + 1;
        IF seq <= 0 THEN
            seq := 1;
        END_IF;
    END_IF;
    IF (stage = 140) OR (stage = 145) OR (stage = 180) OR (stage = 185) THEN
        procStep := 0;
    END_IF;
    prevStage := stage;
END_IF;

IF finalDeclared THEN
    stage := 0;
END_IF;

CASE stage OF
0:
    cancelMode := FALSE;
    curId := 0;
    curStatus := 0;
    IF NOT finalDeclared THEN
        IF (D100 <> 0) AND (D100 <> lastAck0) THEN
            curCh := 0;
            curId := D100;
            IF D101 = 2 THEN
                curOrigin := 2;
            ELSE
                curOrigin := 1;
            END_IF;
            IF X31 THEN
                cancelMode := TRUE;
                curStatus := 2;
                stage := 500;
            ELSE
                curStatus := 1;
                stage := 100;
            END_IF;
        ELSIF (D120 <> 0) AND (D120 <> lastAck1) THEN
            curCh := 1;
            curId := D120;
            IF D121 = 2 THEN
                curOrigin := 2;
            ELSE
                curOrigin := 1;
            END_IF;
            IF X35 THEN
                cancelMode := TRUE;
                curStatus := 2;
                stage := 500;
            ELSE
                curStatus := 1;
                stage := 100;
            END_IF;
        END_IF;
    END_IF;

100:
    targetA := originPort;
    targetB := 0;
    IF curOrigin = 2 THEN
        targetD := D92;
    ELSE
        targetC := D92;
    END_IF;
    liftAtDock := (((curOrigin = 1) AND (ABS(D1008 - targetC) <= 20) AND (ABS(D1009) <= 100)) OR ((curOrigin = 2) AND (ABS(D1012 - targetD) <= 20) AND (ABS(D1013) <= 100)));
    IF (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND liftAtDock AND originReady THEN
        stage := 110;
    END_IF;

110:
    targetA := originPort;
    targetB := 18000;
    IF curOrigin = 2 THEN
        targetD := D92;
    ELSE
        targetC := D92;
    END_IF;
    D80 := 1;
    D81 := curOrigin;
    D82 := seq;
    IF (D90 = curId) AND (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 120;
    END_IF;

120:
    targetA := originPort;
    targetB := 0;
    IF curOrigin = 2 THEN
        targetD := D92;
    ELSE
        targetC := D92;
    END_IF;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF cancelMode THEN
            stage := 198;
        ELSE
            stage := 125;
        END_IF;
    END_IF;

125:
    targetA := D409;
    targetB := 0;
    IF (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100) AND X63 THEN
        stage := 130;
    END_IF;

130:
    targetA := D409;
    targetB := 18000;
    D80 := 2;
    D81 := 3;
    D82 := seq;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    IF (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND ((D90 <> curId) OR (D410 = curId)) THEN
        stage := 135;
    END_IF;

135:
    targetA := D409;
    targetB := 0;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 140;
    END_IF;

140:
    targetA := D409;
    targetB := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    D702 := 1000;
    g0 := D500;
    IF g0 < 0 THEN g0 := 0; END_IF;
    IF g0 > 27000 THEN g0 := 27000; END_IF;
    g1 := D501;
    IF g1 < 0 THEN g1 := 0; END_IF;
    IF g1 > 74000 THEN g1 := 74000; END_IF;
    IF procStep = 0 THEN
        targetS30 := D1016;
        IF D1020 > 50000 THEN
            targetS31 := 50000;
        ELSE
            targetS31 := 5000;
        END_IF;
        IF (D1020 <= 50000) AND (ABS(D1021) <= 100) THEN
            procStep := 1;
        END_IF;
    ELSIF procStep = 1 THEN
        targetS30 := g0;
        targetS31 := 5000;
        IF (ABS(D1016 - g0) <= 20) AND (ABS(D1017) <= 100) THEN
            procStep := 2;
        END_IF;
    ELSE
        targetS30 := g0;
        targetS31 := g1;
        IF X70 OR ((ABS(D1016 - g0) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - g1) <= 20) AND (ABS(D1021) <= 100)) THEN
            stage := 145;
        END_IF;
    END_IF;

145:
    targetA := D409;
    targetB := 0;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    IF procStep = 0 THEN
        targetS30 := D1016;
        IF D1020 > 50000 THEN
            targetS31 := 50000;
        ELSE
            targetS31 := 5000;
        END_IF;
        IF (D1020 <= 50000) AND (ABS(D1021) <= 100) THEN
            procStep := 1;
        END_IF;
    ELSE
        targetS30 := 0;
        targetS31 := 5000;
        IF (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - 5000) <= 20) AND (ABS(D1021) <= 100) AND X63 THEN
            stage := 150;
        END_IF;
    END_IF;

150:
    targetA := D409;
    targetB := 18000;
    D80 := 1;
    D81 := 3;
    D82 := seq;
    Y71 := TRUE;
    D700 := curId;
    D701 := D526;
    IF (D90 = curId) AND (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 160;
    END_IF;

160:
    targetA := D409;
    targetB := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF cancelMode THEN
            stage := 198;
        ELSE
            stage := 165;
        END_IF;
    END_IF;

165:
    targetA := D412;
    targetB := 0;
    IF (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100) AND X64 THEN
        stage := 170;
    END_IF;

170:
    targetA := D412;
    targetB := 18000;
    D80 := 2;
    D81 := 4;
    D82 := seq;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    IF (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND ((D90 <> curId) OR (D413 = curId)) THEN
        stage := 175;
    END_IF;

175:
    targetA := D412;
    targetB := 0;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 180;
    END_IF;

180:
    targetA := D412;
    targetB := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    D712 := 1000;
    g0 := D600;
    IF g0 < -9000 THEN g0 := -9000; END_IF;
    IF g0 > 9000 THEN g0 := 9000; END_IF;
    g1 := D601;
    IF g1 < 0 THEN g1 := 0; END_IF;
    IF g1 > 65000 THEN g1 := 65000; END_IF;
    g2 := D602;
    IF g2 < -9000 THEN g2 := -9000; END_IF;
    IF g2 > 9000 THEN g2 := 9000; END_IF;
    g3 := D603;
    IF g3 < 0 THEN g3 := 0; END_IF;
    IF g3 > 65000 THEN g3 := 65000; END_IF;
    IF procStep = 0 THEN
        targetS40 := D1024;
        targetS41 := 0;
        targetS42 := D1032;
        targetS43 := 0;
        IF (D1028 <= 8000) AND (D1036 <= 8000) AND (ABS(D1029) <= 100) AND (ABS(D1037) <= 100) THEN
            procStep := 1;
        END_IF;
    ELSIF procStep = 1 THEN
        targetS40 := g0;
        targetS41 := 0;
        targetS42 := g2;
        targetS43 := 0;
        IF (ABS(D1024 - g0) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1032 - g2) <= 20) AND (ABS(D1033) <= 100) THEN
            procStep := 2;
        END_IF;
    ELSE
        targetS40 := g0;
        targetS41 := g1;
        targetS42 := g2;
        targetS43 := g3;
        IF X75 OR ((ABS(D1024 - g0) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028 - g1) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - g2) <= 20) AND (ABS(D1033) <= 100) AND (ABS(D1036 - g3) <= 20) AND (ABS(D1037) <= 100)) THEN
            stage := 185;
        END_IF;
    END_IF;

185:
    targetA := D412;
    targetB := 0;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    IF procStep = 0 THEN
        targetS40 := D1024;
        targetS41 := 0;
        targetS42 := D1032;
        targetS43 := 0;
        IF (D1028 <= 8000) AND (D1036 <= 8000) AND (ABS(D1029) <= 100) AND (ABS(D1037) <= 100) THEN
            procStep := 1;
        END_IF;
    ELSE
        targetS40 := -6500;
        targetS41 := 0;
        targetS42 := 6500;
        targetS43 := 0;
        IF (ABS(D1024 + 6500) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - 6500) <= 20) AND (ABS(D1033) <= 100) AND (ABS(D1036) <= 20) AND (ABS(D1037) <= 100) AND X64 THEN
            stage := 190;
        END_IF;
    END_IF;

190:
    targetA := D412;
    targetB := 18000;
    D80 := 1;
    D81 := 4;
    D82 := seq;
    Y76 := TRUE;
    D710 := curId;
    D711 := D626;
    IF (D90 = curId) AND (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 195;
    END_IF;

195:
    targetA := D412;
    targetB := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 198;
    END_IF;

198:
    targetA := originPort;
    targetB := 0;
    IF curOrigin = 2 THEN
        targetD := D92;
    ELSE
        targetC := D92;
    END_IF;
    IF (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100) AND originReady THEN
        stage := 200;
    END_IF;

200:
    targetA := originPort;
    targetB := 18000;
    IF curOrigin = 2 THEN
        targetD := D92;
    ELSE
        targetC := D92;
    END_IF;
    D80 := 2;
    D81 := curOrigin;
    D82 := seq;
    IF (ABS(D1000 - targetA) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND ((D90 <> curId) OR ((curCh = 0) AND X30) OR ((curCh = 1) AND X34)) THEN
        stage := 205;
    END_IF;

205:
    targetA := originPort;
    targetB := 0;
    targetC := 15000;
    targetD := 15000;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        stage := 210;
    END_IF;

210:
    targetA := originPort;
    targetB := 0;
    targetC := 15000;
    targetD := 15000;
    liftAtHome := (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100);
    IF liftAtHome AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF curCh = 0 THEN
            D300 := curId;
            D301 := curStatus;
            lastAck0 := curId;
        ELSE
            D302 := curId;
            D303 := curStatus;
            lastAck1 := curId;
        END_IF;
        stage := 0;
    END_IF;

500:
    curStatus := 2;
    cancelMode := TRUE;
    targetB := 0;
    IF D90 = curId THEN
        stage := 198;
    ELSIF D413 = curId THEN
        stage := 185;
    ELSIF D410 = curId THEN
        stage := 145;
    ELSE
        stage := 205;
    END_IF;

ELSE
    stage := 0;
END_CASE;

IF targetA < -450000 THEN targetA := -450000; END_IF;
IF targetA > 730000 THEN targetA := 730000; END_IF;
IF targetB < 0 THEN targetB := 0; END_IF;
IF targetB > 18000 THEN targetB := 18000; END_IF;
IF targetC < 0 THEN targetC := 0; END_IF;
IF targetC > 120000 THEN targetC := 120000; END_IF;
IF targetD < 0 THEN targetD := 0; END_IF;
IF targetD > 120000 THEN targetD := 120000; END_IF;
IF targetS30 < 0 THEN targetS30 := 0; END_IF;
IF targetS30 > 27000 THEN targetS30 := 27000; END_IF;
IF targetS31 < 0 THEN targetS31 := 0; END_IF;
IF targetS31 > 74000 THEN targetS31 := 74000; END_IF;
IF targetS40 < -9000 THEN targetS40 := -9000; END_IF;
IF targetS40 > 9000 THEN targetS40 := 9000; END_IF;
IF targetS41 < 0 THEN targetS41 := 0; END_IF;
IF targetS41 > 65000 THEN targetS41 := 65000; END_IF;
IF targetS42 < -9000 THEN targetS42 := -9000; END_IF;
IF targetS42 > 9000 THEN targetS42 := 9000; END_IF;
IF targetS43 < 0 THEN targetS43 := 0; END_IF;
IF targetS43 > 65000 THEN targetS43 := 65000; END_IF;

finalHome := X51 AND (stage = 0) AND (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - 5000) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024 + 6500) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - 6500) <= 20) AND (ABS(D1033) <= 100) AND (ABS(D1036) <= 20) AND (ABS(D1037) <= 100);

finalTimer(IN := finalHome OR finalDeclared, PT := T#100ms);
IF finalTimer.Q THEN
    finalDeclared := TRUE;
END_IF;
Y2 := finalDeclared;

IF finalDeclared THEN
    targetA := 0;
    targetB := 0;
    targetC := 15000;
    targetD := 15000;
    targetS30 := 0;
    targetS31 := 5000;
    targetS40 := -6500;
    targetS41 := 0;
    targetS42 := 6500;
    targetS43 := 0;
    D80 := 0;
    D81 := 0;
    Y70 := FALSE;
    Y71 := FALSE;
    Y75 := FALSE;
    Y76 := FALSE;
END_IF;

D2000 := targetA;
D2001 := 1000;
D2002 := 0;
D2004 := targetB;
D2005 := 1000;
D2006 := 0;
D2008 := targetC;
D2009 := 1000;
D2010 := 0;
D2012 := targetD;
D2013 := 1000;
D2014 := 0;
D2016 := targetS30;
D2017 := 1000;
D2018 := 0;
D2020 := targetS31;
D2021 := 1000;
D2022 := 0;
D2024 := targetS40;
D2025 := 1000;
D2026 := 0;
D2028 := targetS41;
D2029 := 1000;
D2030 := 0;
D2032 := targetS42;
D2033 := 1000;
D2034 := 0;
D2036 := targetS43;
D2037 := 1000;
D2038 := 0;
D82 := seq;

END_PROGRAM