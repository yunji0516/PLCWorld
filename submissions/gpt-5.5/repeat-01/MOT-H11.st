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
    state : INT;
    lastState : INT;
    seq : DINT;
    connIssued : BOOL;
    activeId : DINT;
    activeCh : INT;
    activeOrigin : INT;
    activeStatus : DINT;
    seen0 : DINT;
    seen1 : DINT;
    done0 : BOOL;
    done1 : BOOL;
    pending0 : BOOL;
    pending1 : BOOL;
    originX : DINT;
    nextX : DINT;
    desiredLift : DINT;
    liftCmd : DINT;
    initDone : BOOL;
    s3Goal0 : DINT;
    s3Goal1 : DINT;
    s4Goal0 : DINT;
    s4Goal1 : DINT;
    s4Goal2 : DINT;
END_VAR

IF NOT initDone THEN
    liftCmd := D1008;
    seen0 := D100;
    seen1 := D120;
    initDone := TRUE;
END_IF;

IF D100 <> seen0 THEN
    seen0 := D100;
    done0 := FALSE;
    D300 := 0;
    D301 := 0;
END_IF;

IF D120 <> seen1 THEN
    seen1 := D120;
    done1 := FALSE;
    D302 := 0;
    D303 := 0;
END_IF;

IF state <> lastState THEN
    connIssued := FALSE;
    lastState := state;
END_IF;

pending0 := (D100 <> 0) AND NOT done0 AND NOT X30;
pending1 := (D120 <> 0) AND NOT done1 AND NOT X34;

IF activeOrigin = 2 THEN
    originX := D406;
ELSE
    originX := D403;
END_IF;

s3Goal0 := D500;
IF s3Goal0 < 0 THEN s3Goal0 := 0; END_IF;
IF s3Goal0 > 27000 THEN s3Goal0 := 27000; END_IF;
s3Goal1 := D501;
IF s3Goal1 < 0 THEN s3Goal1 := 0; END_IF;
IF s3Goal1 > 74000 THEN s3Goal1 := 74000; END_IF;

s4Goal0 := D600;
IF s4Goal0 < 0 THEN s4Goal0 := 0; END_IF;
IF s4Goal0 > 27000 THEN s4Goal0 := 27000; END_IF;
s4Goal1 := D601;
IF s4Goal1 < 0 THEN s4Goal1 := 0; END_IF;
IF s4Goal1 > 4000 THEN s4Goal1 := 4000; END_IF;
s4Goal2 := D602;
IF s4Goal2 < 0 THEN s4Goal2 := 0; END_IF;
IF s4Goal2 > 4000 THEN s4Goal2 := 4000; END_IF;

D2000 := 0;
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2004 := 0;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

desiredLift := 40000;
D2009 := 500;
D2010 := 0;
Y42 := TRUE;
D2013 := 500;
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

D2024 := 0;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;
D2028 := 0;
D2029 := 1000;
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
D702 := 1000;
Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := 0;
D712 := 1000;

D80 := 0;
D81 := 0;
Y30 := FALSE;
Y2 := FALSE;

CASE state OF
0:
    D2000 := 0;
    D2004 := 0;
    IF pending0 OR pending1 THEN
        IF pending0 AND pending1 THEN
            IF D103 <= D123 THEN
                activeId := D100;
                activeCh := 0;
                IF D101 = 2 THEN activeOrigin := 2; ELSE activeOrigin := 1; END_IF;
                IF X31 THEN activeStatus := 2; ELSE activeStatus := 1; END_IF;
            ELSE
                activeId := D120;
                activeCh := 1;
                IF D121 = 2 THEN activeOrigin := 2; ELSE activeOrigin := 1; END_IF;
                IF X35 THEN activeStatus := 2; ELSE activeStatus := 1; END_IF;
            END_IF;
        ELSIF pending0 THEN
            activeId := D100;
            activeCh := 0;
            IF D101 = 2 THEN activeOrigin := 2; ELSE activeOrigin := 1; END_IF;
            IF X31 THEN activeStatus := 2; ELSE activeStatus := 1; END_IF;
        ELSE
            activeId := D120;
            activeCh := 1;
            IF D121 = 2 THEN activeOrigin := 2; ELSE activeOrigin := 1; END_IF;
            IF X35 THEN activeStatus := 2; ELSE activeStatus := 1; END_IF;
        END_IF;
        state := 10;
    END_IF;

10:
    IF activeOrigin = 2 THEN originX := D406; ELSE originX := D403; END_IF;
    desiredLift := D92;
    D2000 := originX;
    D2004 := 0;
    IF (ABS(D1008 - D92) <= 20) AND (ABS(D1012 - D92) <= 20) AND
       (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) AND
       (ABS(D1000 - originX) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (((activeOrigin = 1) AND X61) OR ((activeOrigin = 2) AND X62)) THEN
        state := 11;
    END_IF;

11:
    IF activeOrigin = 2 THEN originX := D406; ELSE originX := D403; END_IF;
    desiredLift := D92;
    D2000 := originX;
    D2004 := 0;
    D80 := 1;
    D81 := activeOrigin;
    IF NOT connIssued THEN
        seq := seq + 1;
        connIssued := TRUE;
    END_IF;
    IF D90 = activeId THEN
        state := 20;
    END_IF;

20:
    desiredLift := D92;
    D2000 := D409;
    D2004 := 0;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X63 AND
       (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020 - 5000) <= 20) AND (ABS(D1021) <= 100) THEN
        state := 21;
    END_IF;

21:
    desiredLift := D92;
    D2000 := D409;
    D2004 := 18000;
    D80 := 2;
    D81 := 3;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        IF NOT connIssued THEN
            seq := seq + 1;
            connIssued := TRUE;
        END_IF;
    END_IF;
    IF (D90 <> activeId) AND (D410 = activeId) THEN
        state := 22;
    END_IF;

22:
    desiredLift := D92;
    D2000 := D409;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 30;
    END_IF;

30:
    desiredLift := D92;
    D2000 := D409;
    D2004 := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := D520;
    D701 := D526;
    D702 := 1000;
    D2016 := s3Goal0;
    IF (ABS(D1016 - s3Goal0) <= 20) AND (ABS(D1017) <= 100) THEN
        D2020 := s3Goal1;
    ELSE
        D2020 := 50000;
    END_IF;
    IF X70 THEN
        state := 31;
    END_IF;

31:
    desiredLift := D92;
    D2000 := D409;
    D2004 := 0;
    D2016 := 0;
    D2020 := 5000;
    IF (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020 - 5000) <= 20) AND (ABS(D1021) <= 100) THEN
        state := 40;
    END_IF;

40:
    desiredLift := D92;
    D2000 := D409;
    D2004 := 0;
    D80 := 1;
    D81 := 3;
    IF NOT connIssued THEN
        seq := seq + 1;
        connIssued := TRUE;
    END_IF;
    IF D90 = activeId THEN
        state := 50;
    END_IF;

50:
    desiredLift := D92;
    D2000 := D412;
    D2004 := 0;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X64 AND
       (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
       (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
        state := 51;
    END_IF;

51:
    desiredLift := D92;
    D2000 := D412;
    D2004 := 18000;
    D80 := 2;
    D81 := 4;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        IF NOT connIssued THEN
            seq := seq + 1;
            connIssued := TRUE;
        END_IF;
    END_IF;
    IF (D90 <> activeId) AND (D413 = activeId) THEN
        state := 52;
    END_IF;

52:
    desiredLift := D92;
    D2000 := D412;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 60;
    END_IF;

60:
    desiredLift := D92;
    D2000 := D412;
    D2004 := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := D620;
    D711 := D626;
    D712 := 1000;
    D2024 := s4Goal0;
    IF (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) AND
       (ABS(D1024 - s4Goal0) <= 20) AND (ABS(D1025) <= 100) THEN
        D2028 := s4Goal1;
        D2032 := s4Goal2;
    ELSE
        D2028 := 0;
        D2032 := 0;
    END_IF;
    IF X75 THEN
        state := 61;
    END_IF;

61:
    desiredLift := D92;
    D2000 := D412;
    D2004 := 0;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    IF (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
       (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
        state := 70;
    END_IF;

70:
    desiredLift := D92;
    D2000 := D412;
    D2004 := 0;
    D80 := 1;
    D81 := 4;
    IF NOT connIssued THEN
        seq := seq + 1;
        connIssued := TRUE;
    END_IF;
    IF D90 = activeId THEN
        state := 80;
    END_IF;

80:
    IF activeOrigin = 2 THEN originX := D406; ELSE originX := D403; END_IF;
    desiredLift := D92;
    D2000 := originX;
    D2004 := 0;
    IF (ABS(D1008 - D92) <= 20) AND (ABS(D1012 - D92) <= 20) AND
       (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) AND
       (ABS(D1000 - originX) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (((activeOrigin = 1) AND X61) OR ((activeOrigin = 2) AND X62)) THEN
        state := 81;
    END_IF;

81:
    IF activeOrigin = 2 THEN originX := D406; ELSE originX := D403; END_IF;
    desiredLift := D92;
    D2000 := originX;
    D2004 := 18000;
    D80 := 2;
    D81 := activeOrigin;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        IF NOT connIssued THEN
            seq := seq + 1;
            connIssued := TRUE;
        END_IF;
    END_IF;
    IF (D90 <> activeId) AND
       (((activeOrigin = 1) AND (D404 = activeId)) OR ((activeOrigin = 2) AND (D407 = activeId))) THEN
        state := 82;
    END_IF;

82:
    IF activeOrigin = 2 THEN originX := D406; ELSE originX := D403; END_IF;
    desiredLift := D92;
    D2000 := originX;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 90;
    END_IF;

90:
    desiredLift := 40000;
    D2004 := 0;
    IF pending0 AND NOT (activeCh = 0) THEN
        IF D101 = 2 THEN D2000 := D406; ELSE D2000 := D403; END_IF;
    ELSIF pending1 AND NOT (activeCh = 1) THEN
        IF D121 = 2 THEN D2000 := D406; ELSE D2000 := D403; END_IF;
    ELSE
        D2000 := 0;
    END_IF;
    IF (ABS(D1008 - 40000) <= 20) AND (ABS(D1012 - 40000) <= 20) AND
       (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF activeCh = 0 THEN
            D300 := activeId;
            D301 := activeStatus;
            done0 := TRUE;
        ELSE
            D302 := activeId;
            D303 := activeStatus;
            done1 := TRUE;
        END_IF;
        activeId := 0;
        state := 0;
    END_IF;
ELSE
    state := 0;
END_CASE;

IF desiredLift < 0 THEN desiredLift := 0; END_IF;
IF desiredLift > 120000 THEN desiredLift := 120000; END_IF;

IF liftCmd < (desiredLift - 500) THEN
    liftCmd := liftCmd + 500;
ELSIF liftCmd > (desiredLift + 500) THEN
    liftCmd := liftCmd - 500;
ELSE
    liftCmd := desiredLift;
END_IF;

D2008 := liftCmd;
D2012 := liftCmd;

IF D2000 < -450000 THEN D2000 := -450000; END_IF;
IF D2000 > 450000 THEN D2000 := 450000; END_IF;
IF D2004 < 0 THEN D2004 := 0; END_IF;
IF D2004 > 18000 THEN D2004 := 18000; END_IF;
IF D2016 < 0 THEN D2016 := 0; END_IF;
IF D2016 > 27000 THEN D2016 := 27000; END_IF;
IF D2020 < 0 THEN D2020 := 0; END_IF;
IF D2020 > 74000 THEN D2020 := 74000; END_IF;
IF D2024 < 0 THEN D2024 := 0; END_IF;
IF D2024 > 27000 THEN D2024 := 27000; END_IF;
IF D2028 < 0 THEN D2028 := 0; END_IF;
IF D2028 > 4000 THEN D2028 := 4000; END_IF;
IF D2032 < 0 THEN D2032 := 0; END_IF;
IF D2032 > 4000 THEN D2032 := 4000; END_IF;

D82 := seq;

IF X51 AND (state = 0) AND NOT pending0 AND NOT pending1 AND
   (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
   (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
   (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
   (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) AND
   (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND
   (ABS(D1020 - 5000) <= 20) AND (ABS(D1021) <= 100) AND
   (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
   (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
   (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM