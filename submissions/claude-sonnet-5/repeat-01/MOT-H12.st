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

    (* internal state *)
    st : INT := 0;
    cur : INT := -1;
    oldSt : INT := 0;
    reqId : DINT := 0;
    reqLoc : DINT := 0;
    lastAckedId0 : DINT := 0;
    lastAckedId1 : DINT := 0;
    cancelFlag : BOOL := FALSE;
    curCancelled : BOOL := FALSE;
    curReturned : BOOL := FALSE;
    originPos : DINT := 0;
    portReadyOrigin : BOOL := FALSE;
    seqCounter : DINT := 0;

    moveTimer : TON;
    holdTimer : TON;

    (* tolerances (raw x0.01 units) *)
    posTol : DINT := 20;
    velTol : DINT := 100;
    moveRate : DINT := 300;

    (* home / fixed raw positions *)
    a_home : DINT := 0;
    b_home : DINT := 0;
    b_connect : DINT := 18000;
    c_home : DINT := 15000;
    d_home : DINT := 15000;
    s3_home : DINT := -85000;
    s4_0_home : DINT := -65000;
    s4_1_home : DINT := 65000;
    s4_2_home : DINT := 0;

    (* working targets *)
    a_t : DINT := 0;
    b_t : DINT := 0;
    c_t : DINT := 15000;
    d_t : DINT := 15000;
    s3_0_t : DINT := -85000;
    s3_1_t : DINT := -85000;
    s4_0_t : DINT := -65000;
    s4_1_t : DINT := 65000;
    s4_2_t : DINT := 0;

    allAxesHome : BOOL := FALSE;
END_VAR

(* ---------------- request dispatch when idle ---------------- *)
IF cur = -1 THEN
    IF (D100 <> 0) AND (D100 <> lastAckedId0) THEN
        cur := 0;
        reqId := D100;
        reqLoc := D101;
        st := 1;
        cancelFlag := FALSE;
    ELSIF (D120 <> 0) AND (D120 <> lastAckedId1) THEN
        cur := 1;
        reqId := D120;
        reqLoc := D121;
        st := 1;
        cancelFlag := FALSE;
    END_IF;
END_IF;

IF cur = -1 THEN
    (* park all axes at home, cells released *)
    a_t := a_home;
    b_t := b_home;
    c_t := c_home;
    d_t := d_home;
    s3_0_t := s3_home;
    s3_1_t := s3_home;
    s4_0_t := s4_0_home;
    s4_1_t := s4_1_home;
    s4_2_t := s4_2_home;
    Y70 := FALSE;
    Y71 := FALSE;
    Y75 := FALSE;
    Y76 := FALSE;
    D80 := 0;
    D81 := 0;
    D700 := 0;
    D701 := 0;
    D702 := 0;
    D710 := 0;
    D711 := 0;
    D712 := 0;
ELSE
    IF cur = 0 THEN
        curCancelled := X31;
        curReturned := X30;
    ELSE
        curCancelled := X35;
        curReturned := X34;
    END_IF;
    IF curCancelled THEN
        cancelFlag := TRUE;
    END_IF;

    originPos := SEL(reqLoc = 1, D406, D403);
    portReadyOrigin := SEL(reqLoc = 1, X62, X61);

    D700 := reqId;
    D701 := D526;
    D702 := 500;
    D710 := reqId;
    D711 := D626;
    D712 := 500;

    oldSt := st;

    CASE st OF
    1: (* move to origin lift, raise relevant lift to dock height *)
        a_t := originPos;
        b_t := b_home;
        IF reqLoc = 1 THEN
            c_t := D92;
            d_t := d_home;
        ELSE
            c_t := c_home;
            d_t := D92;
        END_IF;
        moveTimer(IN := (ABS(D1000 - a_t) <= posTol AND ABS(D1001) <= velTol AND
                          ABS(D1008 - c_t) <= posTol AND ABS(D1009) <= velTol AND
                          ABS(D1012 - d_t) <= posTol AND ABS(D1013) <= velTol),
                   PT := T#30ms);
        IF moveTimer.Q THEN
            st := 2;
        END_IF;

    2: (* connect fork at origin *)
        b_t := b_connect;
        D80 := 2;
        D81 := reqLoc;
        moveTimer(IN := (ABS(D1004 - b_t) <= posTol AND ABS(D1005) <= velTol AND portReadyOrigin),
                   PT := T#30ms);
        IF moveTimer.Q THEN
            st := 3;
        END_IF;

    3: (* retrieve jig onto shuttle *)
        b_t := b_home;
        D80 := 1;
        D81 := reqLoc;
        moveTimer(IN := (ABS(D1004 - b_t) <= posTol AND ABS(D1005) <= velTol),
                   PT := T#30ms);
        IF moveTimer.Q THEN
            st := 4;
        END_IF;

    4: (* lower both lifts *)
        c_t := c_home;
        d_t := d_home;
        moveTimer(IN := (ABS(D1008 - c_t) <= posTol AND ABS(D1009) <= velTol AND
                          ABS(D1012 - d_t) <= posTol AND ABS(D1013) <= velTol),
                   PT := T#30ms);
        IF moveTimer.Q THEN
            IF cancelFlag THEN
                st := 13;
            ELSE
                st := 5;
            END_IF;
        END_IF;

    5: (* move to cross *)
        a_t := D409;
        moveTimer(IN := (ABS(D1000 - a_t) <= posTol AND ABS(D1001) <= velTol),
                   PT := T#30ms);
        IF moveTimer.Q THEN
            st := 6;
        END_IF;

    6: (* connect fork at cross *)
        b_t := b_connect;
        D80 := 2;
        D81 := 3;
        Y70 := TRUE;
        Y71 := TRUE;
        moveTimer(IN := (ABS(D1004 - b_t) <= posTol AND ABS(D1005) <= velTol AND X63),
                   PT := T#30ms);
        IF moveTimer.Q THEN
            st := 7;
        END_IF;

    7: (* cross work *)
        s3_0_t := D500;
        s3_1_t := D501;
        IF (X70 OR cancelFlag) THEN
            st := 8;
        END_IF;

    8: (* retrieve from cross, actual retreat before releasing cross space *)
        b_t := b_home;
        s3_0_t := s3_home;
        s3_1_t := s3_home;
        D80 := 1;
        D81 := 3;
        moveTimer(IN := (ABS(D1004 - b_t) <= posTol AND ABS(D1005) <= velTol AND
                          ABS(D1016 - s3_0_t) <= posTol AND ABS(D1017) <= velTol AND
                          ABS(D1020 - s3_1_t) <= posTol AND ABS(D1021) <= velTol),
                   PT := T#30ms);
        IF moveTimer.Q THEN
            Y70 := FALSE;
            Y71 := FALSE;
            IF cancelFlag THEN
                st := 13;
            ELSE
                st := 9;
            END_IF;
        END_IF;

    9: (* move to exchange *)
        a_t := D412;
        moveTimer(IN := (ABS(D1000 - a_t) <= posTol AND ABS(D1001) <= velTol),
                   PT := T#30ms);
        IF moveTimer.Q THEN
            st := 10;
        END_IF;

    10: (* connect fork at exchange *)
        b_t := b_connect;
        D80 := 2;
        D81 := 4;
        Y75 := TRUE;
        Y76 := TRUE;
        moveTimer(IN := (ABS(D1004 - b_t) <= posTol AND ABS(D1005) <= velTol AND X64),
                   PT := T#30ms);
        IF moveTimer.Q THEN
            st := 11;
        END_IF;

    11: (* exchange work *)
        s4_0_t := D600;
        s4_1_t := D601;
        s4_2_t := D602;
        IF (X75 OR cancelFlag) THEN
            st := 12;
        END_IF;

    12: (* retrieve from exchange *)
        b_t := b_home;
        s4_0_t := s4_0_home;
        s4_1_t := s4_1_home;
        s4_2_t := s4_2_home;
        D80 := 1;
        D81 := 4;
        moveTimer(IN := (ABS(D1004 - b_t) <= posTol AND ABS(D1005) <= velTol AND
                          ABS(D1024 - s4_0_t) <= posTol AND ABS(D1025) <= velTol AND
                          ABS(D1028 - s4_1_t) <= posTol AND ABS(D1029) <= velTol AND
                          ABS(D1032 - s4_2_t) <= posTol AND ABS(D1033) <= velTol),
                   PT := T#30ms);
        IF moveTimer.Q THEN
            Y75 := FALSE;
            Y76 := FALSE;
            st := 13;
        END_IF;

    13: (* move back to origin lift *)
        a_t := originPos;
        moveTimer(IN := (ABS(D1000 - a_t) <= posTol AND ABS(D1001) <= velTol),
                   PT := T#30ms);
        IF moveTimer.Q THEN
            st := 14;
        END_IF;

    14: (* connect and raise relevant lift to receive jig *)
        b_t := b_connect;
        D80 := 2;
        D81 := reqLoc;
        IF reqLoc = 1 THEN
            c_t := D92;
            d_t := d_home;
        ELSE
            c_t := c_home;
            d_t := D92;
        END_IF;
        moveTimer(IN := (ABS(D1004 - b_t) <= posTol AND ABS(D1005) <= velTol AND
                          ABS(D1008 - c_t) <= posTol AND ABS(D1009) <= velTol AND
                          ABS(D1012 - d_t) <= posTol AND ABS(D1013) <= velTol AND
                          portReadyOrigin),
                   PT := T#30ms);
        IF moveTimer.Q THEN
            st := 15;
        END_IF;

    15: (* disengage shuttle from placed jig *)
        b_t := b_home;
        D80 := 1;
        D81 := reqLoc;
        moveTimer(IN := (ABS(D1004 - b_t) <= posTol AND ABS(D1005) <= velTol),
                   PT := T#30ms);
        IF moveTimer.Q THEN
            st := 16;
        END_IF;

    16: (* lift descends home with jig, confirm return, ack *)
        c_t := c_home;
        d_t := d_home;
        moveTimer(IN := (ABS(D1008 - c_t) <= posTol AND ABS(D1009) <= velTol AND
                          ABS(D1012 - d_t) <= posTol AND ABS(D1013) <= velTol AND
                          curReturned),
                   PT := T#30ms);
        IF moveTimer.Q THEN
            IF cur = 0 THEN
                D300 := reqId;
                D301 := SEL(cancelFlag, 1, 2);
                lastAckedId0 := reqId;
            ELSE
                D302 := reqId;
                D303 := SEL(cancelFlag, 1, 2);
                lastAckedId1 := reqId;
            END_IF;
            cur := -1;
            st := 0;
            cancelFlag := FALSE;
        END_IF;

    ELSE
        st := 1;
    END_CASE;

    IF (st <> oldSt) AND (st = 2 OR st = 6 OR st = 10 OR st = 14) THEN
        seqCounter := seqCounter + 1;
        D82 := seqCounter;
    END_IF;
END_IF;

Y30 := (cur = -1);

(* ---------------- output application with range clamps ---------------- *)
D2000 := LIMIT(-450000, a_t, 450000);
D2001 := moveRate;
D2002 := 0;
Y40 := TRUE;

D2004 := LIMIT(0, b_t, 18000);
D2005 := moveRate;
D2006 := 0;
Y41 := TRUE;

D2008 := LIMIT(0, c_t, 120000);
D2009 := moveRate;
D2010 := 0;
Y42 := TRUE;

D2012 := LIMIT(0, d_t, 120000);
D2013 := moveRate;
D2014 := 0;
Y43 := TRUE;

D2016 := LIMIT(-95000, s3_0_t, 95000);
D2017 := moveRate;
D2018 := 0;
Y44 := TRUE;

D2020 := LIMIT(-95000, s3_1_t, 95000);
D2021 := moveRate;
D2022 := 0;
Y45 := TRUE;

D2024 := LIMIT(-90000, s4_0_t, 90000);
D2025 := moveRate;
D2026 := 0;
Y46 := TRUE;

D2028 := LIMIT(-90000, s4_1_t, 90000);
D2029 := moveRate;
D2030 := 0;
Y47 := TRUE;

D2032 := LIMIT(0, s4_2_t, 35000);
D2033 := moveRate;
D2034 := 0;
Y48 := TRUE;

(* ---------------- final completion latch ---------------- *)
allAxesHome := (ABS(D1000 - a_home) <= posTol) AND (ABS(D1004 - b_home) <= posTol) AND
               (ABS(D1008 - c_home) <= posTol) AND (ABS(D1012 - d_home) <= posTol) AND
               (ABS(D1016 - s3_home) <= posTol) AND (ABS(D1020 - s3_home) <= posTol) AND
               (ABS(D1024 - s4_0_home) <= posTol) AND (ABS(D1028 - s4_1_home) <= posTol) AND
               (ABS(D1032 - s4_2_home) <= posTol) AND
               (ABS(D1001) <= velTol) AND (ABS(D1005) <= velTol) AND (ABS(D1009) <= velTol) AND
               (ABS(D1013) <= velTol) AND (ABS(D1017) <= velTol) AND (ABS(D1021) <= velTol) AND
               (ABS(D1025) <= velTol) AND (ABS(D1029) <= velTol) AND (ABS(D1033) <= velTol);

holdTimer(IN := (X51 AND allAxesHome AND (cur = -1)), PT := T#100ms);

IF holdTimer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM