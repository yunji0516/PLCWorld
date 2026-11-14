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
    initialized : BOOL;
    state : INT;
    prevState : INT;
    reqIndex : INT;
    currentID : DINT;
    originStation : INT;
    cancelledReq : BOOL;
    done0 : BOOL;
    done1 : BOOL;
    seq : DINT;
    connIssued : BOOL;
    waitScans : INT;
    targetA : DINT;
    targetB : DINT;
    targetC : DINT;
    targetD : DINT;
    targetS30 : DINT;
    targetS31 : DINT;
    targetS40 : DINT;
    targetS41 : DINT;
    targetS42 : DINT;
    portX : DINT;
    originReady : BOOL;
    atA : BOOL;
    atB0 : BOOL;
    atB180 : BOOL;
    cDock : BOOL;
    dDock : BOOL;
    cHome : BOOL;
    dHome : BOOL;
    liftDock : BOOL;
    liftHome : BOOL;
    s3Home : BOOL;
    s3Goal : BOOL;
    s4Home : BOOL;
    s4Goal : BOOL;
    connReady : BOOL;
    finalReady : BOOL;
    y2Latched : BOOL;
    closeExchangeGoal : BOOL;
    tFinal : TON;
END_VAR

IF NOT initialized THEN
    initialized := TRUE;
    seq := D91;
    D300 := 0;
    D301 := 0;
    D302 := 0;
    D303 := 0;
    state := 0;
    prevState := -1;
END_IF;

IF state <> prevState THEN
    connIssued := FALSE;
    waitScans := 0;
    prevState := state;
END_IF;

IF reqIndex = 0 THEN
    IF X31 THEN
        cancelledReq := TRUE;
    END_IF;
ELSIF reqIndex = 1 THEN
    IF X35 THEN
        cancelledReq := TRUE;
    END_IF;
END_IF;

targetA := 0;
targetB := 0;
targetC := 15000;
targetD := 15000;
targetS30 := -85000;
targetS31 := -85000;
targetS40 := -65000;
targetS41 := 65000;
targetS42 := 0;
D80 := 0;
D81 := 0;
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

IF originStation = 1 THEN
    portX := D403;
    originReady := X61;
ELSIF originStation = 2 THEN
    portX := D406;
    originReady := X62;
ELSE
    portX := D403;
    originReady := X61;
END_IF;

CASE state OF
0:
    IF (D100 <> 0) AND NOT done0 THEN
        currentID := D100;
        reqIndex := 0;
        cancelledReq := X31;
        IF (D101 = 1) OR (D101 = 2) THEN
            originStation := INT(D101);
        ELSE
            originStation := 1;
        END_IF;
        state := 100;
    ELSIF (D120 <> 0) AND NOT done1 THEN
        currentID := D120;
        reqIndex := 1;
        cancelledReq := X35;
        IF (D121 = 1) OR (D121 = 2) THEN
            originStation := INT(D121);
        ELSE
            originStation := 2;
        END_IF;
        state := 100;
    ELSIF X51 THEN
        state := 300;
    END_IF;

100:
    targetA := portX;
    targetB := 0;
    IF cancelledReq THEN
        state := 220;
    ELSE
        IF originStation = 1 THEN
            targetC := D92;
        ELSE
            targetD := D92;
        END_IF;
        IF (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND originReady THEN
            IF originStation = 1 THEN
                IF (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100) THEN
                    state := 110;
                END_IF;
            ELSE
                IF (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100) THEN
                    state := 110;
                END_IF;
            END_IF;
        END_IF;

110:
    targetA := portX;
    targetB := 0;
    IF originStation = 1 THEN
        targetC := D92;
    ELSE
        targetD := D92;
    END_IF;
    D80 := 1;
    D81 := DINT(originStation);
    atA := (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100);
    atB0 := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    IF originStation = 1 THEN
        liftDock := (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        liftDock := (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    connReady := atA AND atB0 AND liftDock AND originReady;
    IF connReady AND NOT connIssued THEN
        seq := seq + 1;
        connIssued := TRUE;
    END_IF;
    IF connIssued AND (D90 = currentID) THEN
        IF cancelledReq THEN
            state := 200;
        ELSE
            state := 120;
        END_IF;
    END_IF;

120:
    targetA := D409;
    targetB := 0;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X63 THEN
        state := 130;
    END_IF;

130:
    targetA := D409;
    targetB := 18000;
    targetS30 := -85000;
    targetS31 := -85000;
    D80 := 2;
    D81 := 3;
    atA := (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100);
    atB180 := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
    s3Home := (ABS(D1016 + 85000) <= 20) AND (ABS(D1017) <= 100) AND
              (ABS(D1020 + 85000) <= 20) AND (ABS(D1021) <= 100);
    connReady := atA AND atB180 AND s3Home AND X63;
    IF connReady AND NOT connIssued THEN
        seq := seq + 1;
        connIssued := TRUE;
    END_IF;
    IF connIssued AND (D90 <> currentID) THEN
        state := 135;
    END_IF;

135:
    targetA := D409;
    targetB := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 140;
    END_IF;

140:
    targetA := D409;
    targetB := 0;
    targetS30 := D500;
    targetS31 := D501;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := currentID;
    D701 := D526;
    D702 := 1000;
    IF X70 OR cancelledReq THEN
        state := 145;
    END_IF;

145:
    targetA := D409;
    targetB := 0;
    targetS30 := -85000;
    targetS31 := -85000;
    Y71 := TRUE;
    D700 := currentID;
    D701 := D526;
    D702 := 1000;
    IF (ABS(D1016 + 85000) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020 + 85000) <= 20) AND (ABS(D1021) <= 100) AND X63 THEN
        state := 150;
    END_IF;

150:
    targetA := D409;
    targetB := 0;
    targetS30 := -85000;
    targetS31 := -85000;
    Y71 := TRUE;
    D700 := currentID;
    D701 := D526;
    D702 := 1000;
    D80 := 1;
    D81 := 3;
    atA := (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100);
    atB0 := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    connReady := atA AND atB0 AND X63;
    IF connReady AND NOT connIssued THEN
        seq := seq + 1;
        connIssued := TRUE;
    END_IF;
    IF connIssued AND (D90 = currentID) THEN
        IF cancelledReq THEN
            state := 200;
        ELSE
            state := 160;
        END_IF;
    END_IF;

160:
    targetA := D412;
    targetB := 0;
    targetS40 := -65000;
    targetS41 := 65000;
    targetS42 := 0;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X64 THEN
        state := 170;
    END_IF;

170:
    targetA := D412;
    targetB := 18000;
    targetS40 := -65000;
    targetS41 := 65000;
    targetS42 := 0;
    D80 := 2;
    D81 := 4;
    atA := (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100);
    atB180 := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
    s4Home := (ABS(D1024 + 65000) <= 20) AND (ABS(D1025) <= 100) AND
              (ABS(D1028 - 65000) <= 20) AND (ABS(D1029) <= 100) AND
              (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);
    connReady := atA AND atB180 AND s4Home AND X64;
    IF connReady AND NOT connIssued THEN
        seq := seq + 1;
        connIssued := TRUE;
    END_IF;
    IF connIssued AND (D90 <> currentID) THEN
        state := 175;
    END_IF;

175:
    targetA := D412;
    targetB := 0;
    targetS40 := -65000;
    targetS41 := 65000;
    targetS42 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 180;
    END_IF;

180:
    targetA := D412;
    targetB := 0;
    closeExchangeGoal := ABS(D600 - D601) < 23000;
    IF closeExchangeGoal AND (D1032 < 21980) THEN
        targetS40 := -65000;
        targetS41 := 65000;
        targetS42 := 22000;
    ELSE
        targetS40 := D600;
        targetS41 := D601;
        targetS42 := D602;
        IF closeExchangeGoal AND (targetS42 < 22000) THEN
            targetS42 := 22000;
        END_IF;
    END_IF;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := currentID;
    D711 := D626;
    D712 := 1000;
    IF X75 OR cancelledReq THEN
        state := 185;
    END_IF;

185:
    targetA := D412;
    targetB := 0;
    IF ABS(D1024 - D1028) < 23000 THEN
        targetS40 := -65000;
        targetS41 := 65000;
        targetS42 := 22000;
    ELSE
        targetS40 := -65000;
        targetS41 := 65000;
        targetS42 := 0;
    END_IF;
    Y76 := TRUE;
    D710 := currentID;
    D711 := D626;
    D712 := 1000;
    IF (ABS(D1024 + 65000) <= 20) AND (ABS(D1025) <= 100) AND
       (ABS(D1028 - 65000) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) AND X64 THEN
        state := 190;
    END_IF;

190:
    targetA := D412;
    targetB := 0;
    targetS40 := -65000;
    targetS41 := 65000;
    targetS42 := 0;
    Y76 := TRUE;
    D710 := currentID;
    D711 := D626;
    D712 := 1000;
    D80 := 1;
    D81 := 4;
    atA := (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100);
    atB0 := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    connReady := atA AND atB0 AND X64;
    IF connReady AND NOT connIssued THEN
        seq := seq + 1;
        connIssued := TRUE;
    END_IF;
    IF connIssued AND (D90 = currentID) THEN
        state := 200;
    END_IF;

200:
    targetA := portX;
    targetB := 0;
    IF originStation = 1 THEN
        targetC := D92;
    ELSE
        targetD := D92;
    END_IF;
    IF (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND originReady THEN
        IF originStation = 1 THEN
            IF (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100) THEN
                state := 210;
            END_IF;
        ELSE
            IF (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100) THEN
                state := 210;
            END_IF;
        END_IF;
    END_IF;

210:
    targetA := portX;
    targetB := 18000;
    IF originStation = 1 THEN
        targetC := D92;
    ELSE
        targetD := D92;
    END_IF;
    D80 := 2;
    D81 := DINT(originStation);
    atA := (ABS(D1000 - portX) <= 20) AND (ABS(D1001) <= 100);
    atB180 := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
    IF originStation = 1 THEN
        liftDock := (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        liftDock := (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    connReady := atA AND atB180 AND liftDock AND originReady;
    IF connReady AND NOT connIssued THEN
        seq := seq + 1;
        connIssued := TRUE;
    END_IF;
    IF connIssued AND (D90 <> currentID) THEN
        state := 215;
    END_IF;

215:
    targetA := portX;
    targetB := 0;
    IF originStation = 1 THEN
        targetC := D92;
    ELSE
        targetD := D92;
    END_IF;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 220;
    END_IF;

220:
    targetA := portX;
    targetB := 0;
    targetC := 15000;
    targetD := 15000;
    IF originStation = 1 THEN
        liftHome := (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        liftHome := (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    IF liftHome AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF reqIndex = 0 THEN
            D300 := currentID;
            IF cancelledReq THEN
                D301 := 2;
            ELSE
                D301 := 1;
            END_IF;
            done0 := TRUE;
        ELSIF reqIndex = 1 THEN
            D302 := currentID;
            IF cancelledReq THEN
                D303 := 2;
            ELSE
                D303 := 1;
            END_IF;
            done1 := TRUE;
        END_IF;
        currentID := 0;
        reqIndex := -1;
        cancelledReq := FALSE;
        state := 0;
    END_IF;

300:
    targetA := 0;
    targetB := 0;
    targetC := 15000;
    targetD := 15000;
    targetS30 := -85000;
    targetS31 := -85000;
    targetS40 := -65000;
    targetS41 := 65000;
    targetS42 := 0;
ELSE
    state := 0;
END_CASE;

IF targetA < -450000 THEN targetA := -450000; END_IF;
IF targetA > 450000 THEN targetA := 450000; END_IF;
IF targetB < 0 THEN targetB := 0; END_IF;
IF targetB > 18000 THEN targetB := 18000; END_IF;
IF targetC < 0 THEN targetC := 0; END_IF;
IF targetC > 120000 THEN targetC := 120000; END_IF;
IF targetD < 0 THEN targetD := 0; END_IF;
IF targetD > 120000 THEN targetD := 120000; END_IF;
IF targetS30 < -95000 THEN targetS30 := -95000; END_IF;
IF targetS30 > 95000 THEN targetS30 := 95000; END_IF;
IF targetS31 < -95000 THEN targetS31 := -95000; END_IF;
IF targetS31 > 95000 THEN targetS31 := 95000; END_IF;
IF targetS40 < -90000 THEN targetS40 := -90000; END_IF;
IF targetS40 > 90000 THEN targetS40 := 90000; END_IF;
IF targetS41 < -90000 THEN targetS41 := -90000; END_IF;
IF targetS41 > 90000 THEN targetS41 := 90000; END_IF;
IF targetS42 < 0 THEN targetS42 := 0; END_IF;
IF targetS42 > 35000 THEN targetS42 := 35000; END_IF;

IF ABS(D1004) > 4000 THEN
    targetA := D1000;
END_IF;

D2000 := targetA;
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2004 := targetB;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

D2008 := targetC;
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

D2012 := targetD;
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2016 := targetS30;
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;

D2020 := targetS31;
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2024 := targetS40;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2028 := targetS41;
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

D2032 := targetS42;
D2033 := 1000;
D2034 := 0;
Y48 := TRUE;

D82 := seq;

finalReady := X51 AND
              (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
              (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
              (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
              (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND
              (ABS(D1016 + 85000) <= 20) AND (ABS(D1017) <= 100) AND
              (ABS(D1020 + 85000) <= 20) AND (ABS(D1021) <= 100) AND
              (ABS(D1024 + 65000) <= 20) AND (ABS(D1025) <= 100) AND
              (ABS(D1028 - 65000) <= 20) AND (ABS(D1029) <= 100) AND
              (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);

tFinal(IN := finalReady, PT := T#100ms);

IF tFinal.Q THEN
    y2Latched := TRUE;
END_IF;

Y2 := y2Latched AND finalReady;
Y30 := Y2;
END_PROGRAM