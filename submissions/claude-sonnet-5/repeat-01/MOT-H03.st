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

    (* ---------- internal working variables ---------- *)
    cur          : INT := 0;   // 0 = processing req0, 1 = processing req1, 2 = both handled
    state        : INT := 0;
    seq          : DINT := 0;

    curId        : DINT;
    curLocation  : DINT;
    curCancelled : BOOL;
    curReturned  : BOOL;

    liftAxisIsC       : BOOL;
    liftStationCoord  : DINT;
    liftStationNum    : DINT;

    stationCoord3 : DINT := 230000;   // 2300 mm *100
    stationCoord4 : DINT := 990000;   // 9900 mm *100

    homeA   : DINT := 0;
    homeB   : DINT := 0;
    homeC   : DINT := 15000;
    homeD   : DINT := 15000;
    homeS3_0 : DINT := -50000;
    homeS3_1 : DINT := -50000;
    homeS3_2 : DINT := 0;
    homeS4_0 : DINT := 0;
    homeS4_1 : DINT := 0;

    posTolE   : DINT := 20;   // 0.2 mm/deg establish
    spdTolE   : DINT := 100;  // 1 mm/s or deg/s establish

    err0, err1, err2 : DINT;
    errA0, errA1     : DINT;
    masterMoving     : BOOL;
    masterMoving4    : BOOL;
    inTol3, inTol4   : BOOL;
    readyBit         : BOOL;

    cell3SyncTON  : TON;
    cell4SyncTON  : TON;
    completeTON   : TON;
    cell3Established : BOOL;
    cell4Established : BOOL;

    allHome           : BOOL;
    readyForCompletion : BOOL;
    y2Latched          : BOOL;
END_VAR

(* ================= default safe outputs each scan ================= *)
Y40 := FALSE; Y41 := FALSE; Y42 := FALSE; Y43 := FALSE;
Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE; Y48 := FALSE;

D2000 := D1000; D2001 := 0; D2002 := 0;
D2004 := D1004; D2005 := 0; D2006 := 0;
D2008 := D1008; D2009 := 0; D2010 := 0;
D2012 := D1012; D2013 := 0; D2014 := 0;
D2016 := D1016; D2017 := 0; D2018 := 0;
D2020 := D1020; D2021 := 0; D2022 := 0;
D2024 := D1024; D2025 := 0; D2026 := 0;
D2028 := D1028; D2029 := 0; D2030 := 0;
D2032 := D1032; D2033 := 0; D2034 := 0;

Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 6000;
Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 7200;

Y30 := TRUE;
D80 := 0; D81 := 0;

(* ================= copy the active request fields ================= *)
IF cur = 0 THEN
    curId := D100; curLocation := D101; curCancelled := X31; curReturned := X30;
ELSIF cur = 1 THEN
    curId := D120; curLocation := D121; curCancelled := X35; curReturned := X34;
ELSE
    curId := 0; curLocation := 0; curCancelled := FALSE; curReturned := TRUE;
END_IF;

IF curLocation = 1 THEN
    liftAxisIsC := TRUE; liftStationCoord := -360000; liftStationNum := 1;
ELSE
    liftAxisIsC := FALSE; liftStationCoord := -230000; liftStationNum := 2;
END_IF;

(* ================= main per-request state machine ================= *)
CASE state OF

0: // IDLE - start processing when request present and not yet returned
    IF cur < 2 AND NOT curReturned THEN
        seq := seq + 1;
        D82 := seq;
        state := 10;
    END_IF;

10: // RAISE_LIFT to docking height
    IF liftAxisIsC THEN
        D2008 := D92; D2009 := 1000; D2010 := 0; Y42 := TRUE;
        IF ABS(D1008 - D92) <= posTolE AND ABS(D1009) <= spdTolE THEN
            state := 20;
        END_IF;
    ELSE
        D2012 := D92; D2013 := 1000; D2014 := 0; Y43 := TRUE;
        IF ABS(D1012 - D92) <= posTolE AND ABS(D1013) <= spdTolE THEN
            state := 20;
        END_IF;
    END_IF;

20: // RELEASE_BRAKE before moving shuttle
    Y30 := FALSE;
    IF X53 THEN
        state := 30;
    END_IF;
    IF curCancelled THEN state := 90; END_IF;

30: // MOVE_TO_LIFT (shuttle to own lift station)
    Y30 := FALSE;
    D2000 := liftStationCoord; D2001 := 1000; D2002 := 0; Y40 := TRUE;
    IF ABS(D1000 - liftStationCoord) <= posTolE AND ABS(D1001) <= spdTolE THEN
        state := 40;
    END_IF;
    IF curCancelled THEN state := 90; END_IF;

40: // CONNECT_FORK (grip jig at lift)
    D80 := 2; D81 := liftStationNum;
    D2004 := 18000; D2005 := 1000; D2006 := 0; Y41 := TRUE;
    IF liftStationNum = 1 THEN readyBit := X61; ELSE readyBit := X62; END_IF;
    IF ABS(D1004 - 18000) <= posTolE AND ABS(D1005) <= spdTolE AND readyBit THEN
        IF curCancelled THEN
            state := 90;
        ELSE
            state := 50;
        END_IF;
    END_IF;

50: // MOVE_TO_CELL3
    D81 := 3;
    seq := seq + 1; D82 := seq;
    D2000 := stationCoord3; D2001 := 800; D2002 := 0; Y40 := TRUE;
    IF ABS(D1000 - stationCoord3) <= posTolE AND ABS(D1001) <= spdTolE AND X63 THEN
        state := 60;
        cell3Established := FALSE;
    END_IF;
    IF curCancelled THEN state := 90; END_IF;

60: // CELL3_SYNC - transfer synchronization interface (flying)
    Y70 := TRUE; Y71 := TRUE;
    D700 := 1000; D701 := D520; D702 := 6000;
    D2016 := D500; D2017 := 1000; D2018 := 0; Y44 := TRUE;
    D2020 := D501; D2021 := 1000; D2022 := 0; Y45 := TRUE;
    D2024 := D502; D2025 := 1000; D2026 := 0; Y46 := TRUE;

    err0 := ABS(D1016 - D500);
    err1 := ABS(D1020 - D501);
    err2 := ABS(D1024 - D502);
    masterMoving := ABS(D1001) > spdTolE;
    inTol3 := (err0 <= posTolE) AND (err1 <= posTolE) AND (err2 <= posTolE) AND masterMoving;

    cell3SyncTON(IN := inTol3, PT := T#50ms);
    IF cell3SyncTON.Q THEN
        cell3Established := TRUE;
    END_IF;

    IF cell3Established AND X70 THEN
        state := 70;
    END_IF;
    IF curCancelled THEN state := 90; END_IF;

70: // MOVE_TO_CELL4
    Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y70 := FALSE; Y71 := FALSE;
    D81 := 4;
    seq := seq + 1; D82 := seq;
    D2000 := stationCoord4; D2001 := 800; D2002 := 0; Y40 := TRUE;
    IF ABS(D1000 - stationCoord4) <= posTolE AND ABS(D1001) <= spdTolE AND X64 THEN
        state := 80;
        cell4Established := FALSE;
    END_IF;
    IF curCancelled THEN state := 90; END_IF;

80: // CELL4_SYNC - rotation synchronization section (gear)
    Y75 := TRUE; Y76 := TRUE;
    D710 := 1000; D711 := D620; D712 := 7200;
    D2028 := D600; D2029 := 1000; D2030 := 0; Y47 := TRUE;
    D2032 := D601; D2033 := 1000; D2034 := 0; Y48 := TRUE;

    errA0 := ABS(D1028 - D600);
    errA1 := ABS(D1032 - D601);
    masterMoving4 := ABS(D1001) > spdTolE;
    inTol4 := (errA0 <= posTolE) AND (errA1 <= posTolE) AND masterMoving4;

    cell4SyncTON(IN := inTol4, PT := T#50ms);
    IF cell4SyncTON.Q THEN
        cell4Established := TRUE;
    END_IF;

    IF cell4Established AND X75 THEN
        state := 90;
    END_IF;
    IF curCancelled THEN state := 90; END_IF;

90: // MOVE_BACK_TO_LIFT
    Y47 := FALSE; Y48 := FALSE; Y75 := FALSE; Y76 := FALSE;
    D81 := liftStationNum;
    seq := seq + 1; D82 := seq;
    D2000 := liftStationCoord; D2001 := 800; D2002 := 0; Y40 := TRUE;
    IF ABS(D1000 - liftStationCoord) <= posTolE AND ABS(D1001) <= spdTolE THEN
        state := 100;
    END_IF;

100: // DISCONNECT_FORK (release jig onto lift)
    D80 := 1; D81 := liftStationNum;
    D2004 := 0; D2005 := 1000; D2006 := 0; Y41 := TRUE;
    IF ABS(D1004 - 0) <= posTolE AND ABS(D1005) <= spdTolE THEN
        state := 110;
    END_IF;

110: // LOWER_LIFT to home
    IF liftAxisIsC THEN
        D2008 := homeC; D2009 := 1000; D2010 := 0; Y42 := TRUE;
        IF ABS(D1008 - homeC) <= posTolE AND ABS(D1009) <= spdTolE THEN
            state := 120;
        END_IF;
    ELSE
        D2012 := homeD; D2013 := 1000; D2014 := 0; Y43 := TRUE;
        IF ABS(D1012 - homeD) <= posTolE AND ABS(D1013) <= spdTolE THEN
            state := 120;
        END_IF;
    END_IF;

120: // ENGAGE_BRAKE, stop shuttle
    Y40 := FALSE;
    D2000 := D1000;
    Y30 := TRUE;
    IF X52 THEN
        state := 130;
    END_IF;

130: // RESPOND
    IF cur = 0 THEN
        D300 := curId;
        D301 := SEL(curCancelled, 1, 2);
    ELSE
        D302 := curId;
        D303 := SEL(curCancelled, 1, 2);
    END_IF;
    state := 140;

140: // move on to next request
    IF cur = 0 THEN
        cur := 1;
    ELSE
        cur := 2;
    END_IF;
    state := 0;

ELSE
    state := 0;
END_CASE;

(* ================= final completion / Y2 handling ================= *)
allHome := (ABS(D1000 - homeA) <= posTolE) AND
           (ABS(D1004 - homeB) <= posTolE) AND
           (ABS(D1008 - homeC) <= posTolE) AND
           (ABS(D1012 - homeD) <= posTolE) AND
           (ABS(D1016 - homeS3_0) <= posTolE) AND
           (ABS(D1020 - homeS3_1) <= posTolE) AND
           (ABS(D1024 - homeS3_2) <= posTolE) AND
           (ABS(D1028 - homeS4_0) <= posTolE) AND
           (ABS(D1032 - homeS4_1) <= posTolE);

readyForCompletion := (cur = 2) AND X51 AND allHome;

completeTON(IN := readyForCompletion, PT := T#100ms);

IF completeTON.Q THEN
    y2Latched := TRUE;
END_IF;

Y2 := y2Latched;

END_PROGRAM