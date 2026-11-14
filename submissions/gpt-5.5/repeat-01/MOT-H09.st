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
    st0 : INT;
    st1 : INT;
    id0 : DINT;
    id1 : DINT;
    orig0 : DINT;
    orig1 : DINT;
    cancel0 : BOOL;
    cancel1 : BOOL;
    doneStatus0 : DINT;
    doneStatus1 : DINT;
    cur : INT;
    cur_st : INT;
    cur_id : DINT;
    cur_orig : DINT;
    cur_cancel : BOOL;
    seqCounter : DINT;
    opIssued : BOOL;
    opChan : INT := -2;
    opState : INT := -2;
    opAction : DINT;
    opStation : DINT;
    ready : BOOL;
    finalReady : BOOL;
    finalTimer : TON;
    tA : DINT;
    tB : DINT;
    tC : DINT;
    tD : DINT;
    tS30 : DINT;
    tS31 : DINT;
    tS32 : DINT;
    tS40 : DINT;
    tS41 : DINT;
    s3Home : BOOL;
    s4Home : BOOL;
    selectedPocket : DINT := 1;
    slidePhase : INT;
    tmp : DINT;
    forkSafe : BOOL;
    liftReady : BOOL;
END_VAR

IF D100 <> id0 THEN
    id0 := D100;
    cancel0 := FALSE;
    doneStatus0 := 0;
    IF D100 > 0 THEN
        st0 := 1;
        IF D101 = 2 THEN
            orig0 := 2;
        ELSE
            orig0 := 1;
        END_IF;
    ELSE
        st0 := 0;
        orig0 := 1;
    END_IF;
END_IF;

IF D120 <> id1 THEN
    id1 := D120;
    cancel1 := FALSE;
    doneStatus1 := 0;
    IF D120 > 0 THEN
        st1 := 1;
        IF D121 = 2 THEN
            orig1 := 2;
        ELSE
            orig1 := 1;
        END_IF;
    ELSE
        st1 := 0;
        orig1 := 2;
    END_IF;
END_IF;

IF X31 AND (st0 > 0) AND (st0 <> 9) THEN
    cancel0 := TRUE;
END_IF;
IF X35 AND (st1 > 0) AND (st1 <> 9) THEN
    cancel1 := TRUE;
END_IF;

D300 := 0;
D301 := 0;
D302 := 0;
D303 := 0;
IF st0 = 9 THEN
    D300 := id0;
    D301 := doneStatus0;
END_IF;
IF st1 = 9 THEN
    D302 := id1;
    D303 := doneStatus1;
END_IF;

D2001 := 1000;
D2005 := 1000;
D2009 := 1000;
D2013 := 1000;
D2017 := 1000;
D2021 := 1000;
D2025 := 1000;
D2029 := 1000;
D2033 := 1000;

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

tA := 0;
tB := 0;
tC := 15000;
tD := 15000;
tS30 := 0;
tS31 := 0;
tS32 := 0;
tS40 := 0;
tS41 := 5000;

Y70 := FALSE;
Y71 := FALSE;
D701 := 0;
D702 := 1000;
Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := 0;
D712 := 1000;

D80 := 0;
D81 := 0;

s3Home := (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024) <= 20) AND (ABS(D1025) <= 100);
s4Home := (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - 5000) <= 20) AND (ABS(D1033) <= 100);
forkSafe := D1004 <= 4000;

cur := -1;
IF (st0 > 0) AND (st0 <> 9) THEN
    cur := 0;
ELSIF (st1 > 0) AND (st1 <> 9) THEN
    cur := 1;
END_IF;

IF cur = 0 THEN
    cur_st := st0;
    cur_id := id0;
    cur_orig := orig0;
    cur_cancel := cancel0;
ELSIF cur = 1 THEN
    cur_st := st1;
    cur_id := id1;
    cur_orig := orig1;
    cur_cancel := cancel1;
ELSE
    cur_st := 0;
    cur_id := 0;
    cur_orig := 1;
    cur_cancel := FALSE;
END_IF;

IF (cur <> opChan) OR (cur_st <> opState) THEN
    opIssued := FALSE;
    opChan := cur;
    opState := cur_st;
END_IF;

IF cur <> -1 THEN
    IF cur_cancel THEN
        IF cur_st = 1 THEN
            cur_st := 10;
        ELSIF (cur_st = 2) OR (cur_st = 5) THEN
            cur_st := 8;
        END_IF;
    END_IF;

    CASE cur_st OF
    1:
        IF cur_orig = 1 THEN
            tA := D403;
            tC := D92;
            liftReady := X61 AND (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
            ready := liftReady AND (ABS(D1000 - D403) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
        ELSE
            tA := D406;
            tD := D92;
            liftReady := X62 AND (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
            ready := liftReady AND (ABS(D1000 - D406) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
        END_IF;
        tB := 0;
        IF ready THEN
            IF NOT opIssued THEN
                seqCounter := seqCounter + 1;
                opIssued := TRUE;
                opAction := 1;
                opStation := cur_orig;
            END_IF;
            D80 := opAction;
            D81 := opStation;
        END_IF;
        IF D90 = cur_id THEN
            cur_st := 2;
            opIssued := FALSE;
        END_IF;

    2:
        tA := D409;
        tB := 18000;
        tS30 := 0;
        tS31 := 0;
        tS32 := 0;
        ready := X63 AND s3Home AND (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
        IF ready THEN
            IF NOT opIssued THEN
                seqCounter := seqCounter + 1;
                opIssued := TRUE;
                opAction := 2;
                opStation := 3;
            END_IF;
            D80 := opAction;
            D81 := opStation;
        END_IF;
        IF (D90 <> cur_id) AND (D410 = cur_id) THEN
            cur_st := 3;
            opIssued := FALSE;
        END_IF;

    3:
        tA := D409;
        tB := 0;
        Y71 := TRUE;
        IF cur_cancel THEN
            tS30 := 0;
            tS31 := 0;
            tS32 := 0;
            IF forkSafe AND s3Home THEN
                cur_st := 4;
            END_IF;
        ELSE
            IF forkSafe THEN
                IF s3Home THEN
                    IF cur_orig = 1 THEN
                        selectedPocket := 1;
                    ELSE
                        selectedPocket := 2;
                    END_IF;
                END_IF;
                Y70 := TRUE;
                D701 := D526;
                D702 := 1000;
                tS30 := 0;
                tS31 := 0;
                tS32 := 0;
                IF selectedPocket = 1 THEN
                    tmp := D501;
                    IF tmp < 0 THEN
                        tmp := 0;
                    ELSIF tmp > 100000 THEN
                        tmp := 100000;
                    END_IF;
                    tS31 := tmp;
                ELSE
                    tmp := D502;
                    IF tmp < 0 THEN
                        tmp := 0;
                    ELSIF tmp > 100000 THEN
                        tmp := 100000;
                    END_IF;
                    tS32 := tmp;
                END_IF;
                IF X70 THEN
                    cur_st := 4;
                END_IF;
            ELSE
                tS30 := 0;
                tS31 := 0;
                tS32 := 0;
            END_IF;
        END_IF;

    4:
        tA := D409;
        tB := 0;
        Y71 := TRUE;
        tS30 := 0;
        tS31 := 0;
        tS32 := 0;
        ready := X63 AND s3Home AND (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
        IF ready THEN
            IF NOT opIssued THEN
                seqCounter := seqCounter + 1;
                opIssued := TRUE;
                opAction := 1;
                opStation := 3;
            END_IF;
            D80 := opAction;
            D81 := opStation;
        END_IF;
        IF D90 = cur_id THEN
            opIssued := FALSE;
            IF cur_cancel THEN
                cur_st := 8;
            ELSE
                cur_st := 5;
            END_IF;
        END_IF;

    5:
        tA := D412;
        tB := 18000;
        tS40 := 0;
        tS41 := 5000;
        ready := X64 AND s4Home AND (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
        IF ready THEN
            IF NOT opIssued THEN
                seqCounter := seqCounter + 1;
                opIssued := TRUE;
                opAction := 2;
                opStation := 4;
            END_IF;
            D80 := opAction;
            D81 := opStation;
        END_IF;
        IF (D90 <> cur_id) AND (D413 = cur_id) THEN
            cur_st := 6;
            slidePhase := 0;
            opIssued := FALSE;
        END_IF;

    6:
        tA := D412;
        tB := 0;
        Y76 := TRUE;
        IF cur_cancel THEN
            tS40 := 0;
            tS41 := 5000;
            IF forkSafe AND s4Home THEN
                cur_st := 7;
            END_IF;
        ELSE
            IF forkSafe THEN
                Y75 := TRUE;
                D710 := cur_orig;
                D711 := D626;
                D712 := 1000;
                tmp := D600;
                IF tmp < 0 THEN
                    tmp := 0;
                ELSIF tmp > 27000 THEN
                    tmp := 27000;
                END_IF;
                tS40 := tmp;
                IF slidePhase = 0 THEN
                    tS41 := 50000;
                    IF (ABS(D1028 - tmp) <= 20) AND (ABS(D1029) <= 100) AND (D1032 <= 50020) AND (ABS(D1033) <= 100) THEN
                        slidePhase := 1;
                    END_IF;
                ELSE
                    tS41 := 70000;
                    IF X75 THEN
                        cur_st := 7;
                    END_IF;
                END_IF;
            ELSE
                tS40 := 0;
                tS41 := 5000;
            END_IF;
        END_IF;

    7:
        tA := D412;
        tB := 0;
        Y76 := TRUE;
        tS40 := 0;
        tS41 := 5000;
        ready := X64 AND s4Home AND (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
        IF ready THEN
            IF NOT opIssued THEN
                seqCounter := seqCounter + 1;
                opIssued := TRUE;
                opAction := 1;
                opStation := 4;
            END_IF;
            D80 := opAction;
            D81 := opStation;
        END_IF;
        IF D90 = cur_id THEN
            cur_st := 8;
            opIssued := FALSE;
        END_IF;

    8:
        IF cur_orig = 1 THEN
            tA := D403;
            tC := D92;
            ready := X61 AND (ABS(D1000 - D403) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
        ELSE
            tA := D406;
            tD := D92;
            ready := X62 AND (ABS(D1000 - D406) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
        END_IF;
        tB := 18000;
        IF ready THEN
            IF NOT opIssued THEN
                seqCounter := seqCounter + 1;
                opIssued := TRUE;
                opAction := 2;
                opStation := cur_orig;
            END_IF;
            D80 := opAction;
            D81 := opStation;
        END_IF;
        IF D90 <> cur_id THEN
            cur_st := 10;
            opIssued := FALSE;
        END_IF;

    10:
        tB := 0;
        IF cur_orig = 1 THEN
            tA := D403;
            IF forkSafe THEN
                tC := 15000;
            ELSE
                tC := D92;
            END_IF;
            IF forkSafe AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) THEN
                IF cur_cancel THEN
                    doneStatus0 := 2;
                END_IF;
                cur_st := 9;
            END_IF;
        ELSE
            tA := D406;
            IF forkSafe THEN
                tD := 15000;
            ELSE
                tD := D92;
            END_IF;
            IF forkSafe AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) THEN
                cur_st := 9;
            END_IF;
        END_IF;

    ELSE
        cur_st := 9;
    END_CASE;
END_IF;

IF cur = 0 THEN
    st0 := cur_st;
    IF cur_st = 9 THEN
        IF cancel0 THEN
            doneStatus0 := 2;
        ELSE
            doneStatus0 := 1;
        END_IF;
    END_IF;
ELSIF cur = 1 THEN
    st1 := cur_st;
    IF cur_st = 9 THEN
        IF cancel1 THEN
            doneStatus1 := 2;
        ELSE
            doneStatus1 := 1;
        END_IF;
    END_IF;
END_IF;

IF tA < -450000 THEN
    tA := -450000;
ELSIF tA > 1461300 THEN
    tA := 1461300;
END_IF;
IF tB < 0 THEN
    tB := 0;
ELSIF tB > 18000 THEN
    tB := 18000;
END_IF;
IF tC < 0 THEN
    tC := 0;
ELSIF tC > 120000 THEN
    tC := 120000;
END_IF;
IF tD < 0 THEN
    tD := 0;
ELSIF tD > 120000 THEN
    tD := 120000;
END_IF;
IF tS30 < 0 THEN
    tS30 := 0;
ELSIF tS30 > 100000 THEN
    tS30 := 100000;
END_IF;
IF tS31 < 0 THEN
    tS31 := 0;
ELSIF tS31 > 100000 THEN
    tS31 := 100000;
END_IF;
IF tS32 < 0 THEN
    tS32 := 0;
ELSIF tS32 > 100000 THEN
    tS32 := 100000;
END_IF;
IF tS40 < 0 THEN
    tS40 := 0;
ELSIF tS40 > 27000 THEN
    tS40 := 27000;
END_IF;
IF tS41 < 0 THEN
    tS41 := 0;
ELSIF tS41 > 74000 THEN
    tS41 := 74000;
END_IF;

D2000 := tA;
D2004 := tB;
D2008 := tC;
D2012 := tD;
D2016 := tS30;
D2020 := tS31;
D2024 := tS32;
D2028 := tS40;
D2032 := tS41;

D700 := selectedPocket;
D82 := seqCounter;

Y30 := FALSE;

finalReady := X51 AND ((st0 = 0) OR (st0 = 9)) AND ((st1 = 0) OR (st1 = 9)) AND
              (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
              (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
              (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
              (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND
              s3Home AND s4Home;

finalTimer(IN := finalReady, PT := T#100ms);
Y2 := finalTimer.Q;

IF Y2 THEN
    Y30 := TRUE;
END_IF;

END_PROGRAM