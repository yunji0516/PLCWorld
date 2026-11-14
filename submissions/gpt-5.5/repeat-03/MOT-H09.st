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
    job_id : ARRAY[0..1] OF DINT;
    job_state : ARRAY[0..1] OF INT;
    job_origin : ARRAY[0..1] OF DINT;
    job_done : ARRAY[0..1] OF BOOL;
    job_cancel : ARRAY[0..1] OF BOOL;
    job_status : ARRAY[0..1] OF DINT;
    current : INT;
    srcStation : DINT;
    srcPortX : DINT;
    srcPortId : DINT;
    srcReady : BOOL;
    cmdA : DINT;
    cmdB : DINT;
    cmdC : DINT;
    cmdD : DINT;
    cmdS30 : DINT;
    cmdS31 : DINT;
    cmdS32 : DINT;
    cmdS40 : DINT;
    cmdS41 : DINT;
    desiredAction : DINT;
    desiredStation : DINT;
    desiredKey : DINT;
    seqNo : DINT;
    lastKey : DINT;
    atA : BOOL;
    atB : BOOL;
    atC : BOOL;
    atD : BOOL;
    atS30 : BOOL;
    atS31 : BOOL;
    atS32 : BOOL;
    atS40 : BOOL;
    atS41 : BOOL;
    activePocket : DINT;
    allJobsDone : BOOL;
    finalHome : BOOL;
    completionLatched : BOOL;
    sourceDockCmd : DINT;
END_VAR

IF (D100 <> 0) AND (D100 <> job_id[0]) THEN
    job_id[0] := D100;
    job_state[0] := 5;
    job_done[0] := FALSE;
    job_cancel[0] := FALSE;
    job_status[0] := 0;
    IF (D101 = 2) THEN
        job_origin[0] := 2;
    ELSE
        job_origin[0] := 1;
    END_IF;
END_IF;

IF (D120 <> 0) AND (D120 <> job_id[1]) THEN
    job_id[1] := D120;
    job_state[1] := 5;
    job_done[1] := FALSE;
    job_cancel[1] := FALSE;
    job_status[1] := 0;
    IF (D121 = 2) THEN
        job_origin[1] := 2;
    ELSE
        job_origin[1] := 1;
    END_IF;
END_IF;

IF X31 AND (job_id[0] <> 0) AND (NOT job_done[0]) THEN
    job_cancel[0] := TRUE;
END_IF;
IF X35 AND (job_id[1] <> 0) AND (NOT job_done[1]) THEN
    job_cancel[1] := TRUE;
END_IF;

current := -1;
IF (job_id[0] <> 0) AND (NOT job_done[0]) THEN
    current := 0;
ELSIF (job_id[1] <> 0) AND (NOT job_done[1]) THEN
    current := 1;
END_IF;

cmdA := 0;
cmdB := 0;
cmdC := 15000;
cmdD := 15000;
cmdS30 := 0;
cmdS31 := 0;
cmdS32 := 0;
cmdS40 := 0;
cmdS41 := 5000;
desiredAction := 0;
desiredStation := 0;
desiredKey := 0;
Y70 := FALSE;
Y71 := FALSE;
D700 := 1;
D701 := D526;
D702 := 1000;
Y75 := FALSE;
Y76 := FALSE;
D710 := D620;
D711 := D626;
D712 := 1000;

sourceDockCmd := LIMIT(0, D92, 120000);

IF current >= 0 THEN
    srcStation := job_origin[current];
    IF srcStation = 2 THEN
        srcPortX := D406;
        srcPortId := D407;
        srcReady := X62;
    ELSE
        srcStation := 1;
        srcPortX := D403;
        srcPortId := D404;
        srcReady := X61;
    END_IF;

    IF D520 = 0 THEN
        activePocket := 1;
    ELSE
        activePocket := 2;
    END_IF;

    CASE job_state[current] OF
    5:
        cmdA := srcPortX;
        cmdB := 0;
        IF srcStation = 1 THEN
            cmdC := sourceDockCmd;
            cmdD := 15000;
        ELSE
            cmdC := 15000;
            cmdD := sourceDockCmd;
        END_IF;

        atA := (ABS(D1000 - cmdA) <= 20) AND (ABS(D1001) <= 100);
        atB := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
        atC := ((srcStation = 1) AND (ABS(D1008 - cmdC) <= 20) AND (ABS(D1009) <= 100)) OR (srcStation = 2);
        atD := ((srcStation = 2) AND (ABS(D1012 - cmdD) <= 20) AND (ABS(D1013) <= 100)) OR (srcStation = 1);

        IF D90 = job_id[current] THEN
            IF job_cancel[current] THEN
                job_state[current] := 80;
            ELSE
                job_state[current] := 20;
            END_IF;
        ELSIF atA AND atB AND atC AND atD AND srcReady AND (srcPortId = job_id[current]) THEN
            desiredAction := 1;
            desiredStation := srcStation;
            desiredKey := DINT(current) * 1000 + 5;
        END_IF;

    20:
        Y70 := TRUE;
        Y71 := TRUE;
        D700 := activePocket;
        D701 := D526;
        D702 := 1000;
        cmdA := D409;
        cmdB := 18000;
        cmdS30 := 0;
        cmdS31 := 0;
        cmdS32 := 0;
        IF job_cancel[current] THEN
            job_state[current] := 80;
        ELSE
            atA := (ABS(D1000 - cmdA) <= 20) AND (ABS(D1001) <= 100);
            atB := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
            atS30 := (ABS(D1016) <= 20) AND (ABS(D1017) <= 100);
            atS31 := (ABS(D1020) <= 20) AND (ABS(D1021) <= 100);
            atS32 := (ABS(D1024) <= 20) AND (ABS(D1025) <= 100);
            IF (D90 <> job_id[current]) AND (D410 = job_id[current]) THEN
                job_state[current] := 30;
            ELSIF atA AND atB AND atS30 AND atS31 AND atS32 AND X63 THEN
                desiredAction := 2;
                desiredStation := 3;
                desiredKey := DINT(current) * 1000 + 20;
            END_IF;
        END_IF;

    30:
        Y70 := TRUE;
        Y71 := TRUE;
        D700 := activePocket;
        D701 := D526;
        D702 := 1000;
        cmdB := 0;
        IF activePocket = 1 THEN
            cmdS31 := LIMIT(0, D501, 100000);
            cmdS32 := 0;
        ELSE
            cmdS31 := 0;
            cmdS32 := LIMIT(0, D502, 100000);
        END_IF;
        cmdS30 := 0;

        IF job_cancel[current] THEN
            job_state[current] := 35;
        ELSIF X70 THEN
            job_state[current] := 35;
        END_IF;

    35:
        Y70 := TRUE;
        Y71 := TRUE;
        D700 := activePocket;
        D701 := D526;
        D702 := 1000;
        cmdB := 0;
        cmdS30 := 0;
        cmdS31 := 0;
        cmdS32 := 0;
        IF (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND
           (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
           (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) THEN
            job_state[current] := 40;
        END_IF;

    40:
        Y70 := TRUE;
        Y71 := TRUE;
        D700 := activePocket;
        D701 := D526;
        D702 := 1000;
        cmdA := D409;
        cmdB := 0;
        cmdS30 := 0;
        cmdS31 := 0;
        cmdS32 := 0;
        atA := (ABS(D1000 - cmdA) <= 20) AND (ABS(D1001) <= 100);
        atB := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
        atS30 := (ABS(D1016) <= 20) AND (ABS(D1017) <= 100);
        atS31 := (ABS(D1020) <= 20) AND (ABS(D1021) <= 100);
        atS32 := (ABS(D1024) <= 20) AND (ABS(D1025) <= 100);
        IF D90 = job_id[current] THEN
            Y71 := FALSE;
            IF job_cancel[current] THEN
                job_state[current] := 80;
            ELSE
                job_state[current] := 50;
            END_IF;
        ELSIF atA AND atB AND atS30 AND atS31 AND atS32 AND X63 AND (D410 = job_id[current]) THEN
            desiredAction := 1;
            desiredStation := 3;
            desiredKey := DINT(current) * 1000 + 40;
        END_IF;

    50:
        Y75 := TRUE;
        Y76 := TRUE;
        D710 := D620;
        D711 := D626;
        D712 := 1000;
        cmdA := D412;
        cmdB := 18000;
        cmdS40 := 0;
        cmdS41 := 5000;
        IF job_cancel[current] THEN
            job_state[current] := 80;
        ELSE
            atA := (ABS(D1000 - cmdA) <= 20) AND (ABS(D1001) <= 100);
            atB := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
            atS40 := (ABS(D1028) <= 20) AND (ABS(D1029) <= 100);
            atS41 := (ABS(D1032 - 5000) <= 20) AND (ABS(D1033) <= 100);
            IF (D90 <> job_id[current]) AND (D413 = job_id[current]) THEN
                job_state[current] := 60;
            ELSIF atA AND atB AND atS40 AND atS41 AND X64 THEN
                desiredAction := 2;
                desiredStation := 4;
                desiredKey := DINT(current) * 1000 + 50;
            END_IF;
        END_IF;

    60:
        Y75 := TRUE;
        Y76 := TRUE;
        D710 := D620;
        D711 := D626;
        D712 := 1000;
        cmdB := 0;
        cmdS40 := LIMIT(0, D600, 27000);
        cmdS41 := 5000;
        IF job_cancel[current] THEN
            job_state[current] := 65;
        ELSIF (ABS(D1028 - cmdS40) <= 20) AND (ABS(D1029) <= 100) AND (D1032 <= 50000) THEN
            job_state[current] := 61;
        END_IF;

    61:
        Y75 := TRUE;
        Y76 := TRUE;
        D710 := D620;
        D711 := D626;
        D712 := 1000;
        cmdB := 0;
        cmdS40 := LIMIT(0, D600, 27000);
        cmdS41 := LIMIT(0, D601, 74000);
        IF X75 THEN
            job_state[current] := 65;
        END_IF;

    65:
        Y75 := TRUE;
        Y76 := TRUE;
        D710 := D620;
        D711 := D626;
        D712 := 1000;
        cmdB := 0;
        cmdS40 := 0;
        cmdS41 := 5000;
        IF (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
           (ABS(D1032 - 5000) <= 20) AND (ABS(D1033) <= 100) THEN
            job_state[current] := 70;
        END_IF;

    70:
        Y75 := TRUE;
        Y76 := TRUE;
        D710 := D620;
        D711 := D626;
        D712 := 1000;
        cmdA := D412;
        cmdB := 0;
        cmdS40 := 0;
        cmdS41 := 5000;
        atA := (ABS(D1000 - cmdA) <= 20) AND (ABS(D1001) <= 100);
        atB := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
        atS40 := (ABS(D1028) <= 20) AND (ABS(D1029) <= 100);
        atS41 := (ABS(D1032 - 5000) <= 20) AND (ABS(D1033) <= 100);
        IF D90 = job_id[current] THEN
            Y76 := FALSE;
            job_state[current] := 80;
        ELSIF atA AND atB AND atS40 AND atS41 AND X64 AND (D413 = job_id[current]) THEN
            desiredAction := 1;
            desiredStation := 4;
            desiredKey := DINT(current) * 1000 + 70;
        END_IF;

    80:
        cmdA := srcPortX;
        cmdB := 18000;
        IF srcStation = 1 THEN
            cmdC := sourceDockCmd;
            cmdD := 15000;
        ELSE
            cmdC := 15000;
            cmdD := sourceDockCmd;
        END_IF;
        atA := (ABS(D1000 - cmdA) <= 20) AND (ABS(D1001) <= 100);
        atB := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
        atC := ((srcStation = 1) AND (ABS(D1008 - cmdC) <= 20) AND (ABS(D1009) <= 100)) OR (srcStation = 2);
        atD := ((srcStation = 2) AND (ABS(D1012 - cmdD) <= 20) AND (ABS(D1013) <= 100)) OR (srcStation = 1);
        IF (D90 <> job_id[current]) AND (srcPortId = job_id[current]) THEN
            job_state[current] := 85;
        ELSIF atA AND atB AND atC AND atD AND srcReady THEN
            desiredAction := 2;
            desiredStation := srcStation;
            desiredKey := DINT(current) * 1000 + 80;
        END_IF;

    85:
        cmdA := 0;
        cmdB := 0;
        IF srcStation = 1 THEN
            cmdC := 15000;
            cmdD := 15000;
            atC := (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100);
        ELSE
            cmdC := 15000;
            cmdD := 15000;
            atC := (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100);
        END_IF;
        IF atC THEN
            IF job_cancel[current] THEN
                job_status[current] := 2;
            ELSE
                job_status[current] := 1;
            END_IF;
            job_done[current] := TRUE;
            job_state[current] := 90;
        END_IF;

    ELSE
        cmdA := 0;
        cmdB := 0;
        cmdC := 15000;
        cmdD := 15000;
    END_CASE;
END_IF;

IF desiredAction <> 0 THEN
    IF desiredKey <> lastKey THEN
        seqNo := seqNo + 1;
        lastKey := desiredKey;
    END_IF;
    D80 := desiredAction;
    D81 := desiredStation;
ELSE
    D80 := 0;
    D81 := 0;
END_IF;
D82 := seqNo;

D2000 := LIMIT(-450000, cmdA, 1461300);
D2004 := LIMIT(0, cmdB, 18000);
D2008 := LIMIT(0, cmdC, 120000);
D2012 := LIMIT(0, cmdD, 120000);
D2016 := LIMIT(0, cmdS30, 100000);
D2020 := LIMIT(0, cmdS31, 100000);
D2024 := LIMIT(0, cmdS32, 100000);
D2028 := LIMIT(0, cmdS40, 27000);
D2032 := LIMIT(0, cmdS41, 74000);

D2001 := 900;
D2005 := 900;
D2009 := 900;
D2013 := 900;
D2017 := 850;
D2021 := 850;
D2025 := 850;
D2029 := 800;
D2033 := 850;

D2002 := 0;
D2006 := 0;
D2010 := 0;
D2014 := 0;
D2018 := 0;
D2022 := 0;
D2026 := 0;
D2030 := 0;
D2034 := 0;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;

IF (current >= 0) OR (NOT completionLatched) THEN
    Y30 := FALSE;
ELSE
    Y30 := TRUE;
END_IF;

IF job_done[0] THEN
    D300 := job_id[0];
    D301 := job_status[0];
ELSE
    D300 := 0;
    D301 := 0;
END_IF;

IF job_done[1] THEN
    D302 := job_id[1];
    D303 := job_status[1];
ELSE
    D302 := 0;
    D303 := 0;
END_IF;

allJobsDone := ((job_id[0] = 0) OR job_done[0]) AND ((job_id[1] = 0) OR job_done[1]);

finalHome := X51 AND allJobsDone AND
             (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
             (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
             (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
             (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND
             (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND
             (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
             (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
             (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
             (ABS(D1032 - 5000) <= 20) AND (ABS(D1033) <= 100) AND
             (D90 = 0);

IF finalHome THEN
    completionLatched := TRUE;
END_IF;

Y2 := completionLatched;

IF completionLatched THEN
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := 0;
    D2020 := 0;
    D2024 := 0;
    D2028 := 0;
    D2032 := 5000;
    Y70 := FALSE;
    Y71 := FALSE;
    Y75 := FALSE;
    Y76 := FALSE;
    D80 := 0;
    D81 := 0;
    Y30 := TRUE;
END_IF;

END_PROGRAM