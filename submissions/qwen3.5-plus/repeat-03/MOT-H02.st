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

    (* Internal state variables *)
    req0_active : BOOL := FALSE;
    req0_stage : DINT := 0;
    req0_cancelled : BOOL := FALSE;
    req0_done : BOOL := FALSE;

    req1_active : BOOL := FALSE;
    req1_stage : DINT := 0;
    req1_cancelled : BOOL := FALSE;
    req1_done : BOOL := FALSE;

    active_req : DINT := -1;
    new_seq : DINT := 0;
    configured : BOOL := FALSE;

    stall_timer : TON;
    complete_timer : TON;
END_VAR

(* Constants *)
VAR CONSTANT
    POS_S1 : DINT := -405000;
    POS_S2 : DINT := -185000;
    POS_S3 : DINT := 0;
    POS_S4 : DINT := 470000;
    FORK_RETRACT : DINT := 0;
    FORK_CONNECT : DINT := 18000;
    LIFT_HOME : DINT := 0;
    LIFT_DOCK : DINT := 95000;
    CELL3_HOME0 : DINT := -60000;
    CELL3_HOME1 : DINT := -60000;
    CELL4_HOME0 : DINT := -60000;
    CELL4_HOME1 : DINT := -60000;
    TOL_POS : DINT := 20;
    TOL_SPD : DINT := 100;
    RATE_STD : DINT := 500;
    HOME_S30 : DINT := -60000;
    HOME_S31 : DINT := -60000;
    HOME_S40 : DINT := -60000;
    HOME_S41 : DINT := -60000;
END_VAR

(* --- Request detection --- *)
IF req0_active = FALSE AND X30 = FALSE AND X31 = FALSE AND D100 > 0 THEN
    req0_active := TRUE;
    req0_stage := 0;
    req0_cancelled := FALSE;
    req0_done := FALSE;
END_IF;

IF req1_active = FALSE AND X34 = FALSE AND X35 = FALSE AND D120 > 0 THEN
    req1_active := TRUE;
    req1_stage := 0;
    req1_cancelled := FALSE;
    req1_done := FALSE;
END_IF;

(* --- Cancellation detection --- *)
IF req0_active = TRUE AND X31 = TRUE AND req0_done = FALSE THEN
    req0_cancelled := TRUE;
END_IF;

IF req1_active = TRUE AND X35 = TRUE AND req1_done = FALSE THEN
    req1_cancelled := TRUE;
END_IF;

(* --- Select which request to process --- *)
IF req0_active = TRUE AND req0_done = FALSE THEN
    active_req := 0;
ELSIF req1_active = TRUE AND req1_done = FALSE THEN
    active_req := 1;
ELSE
    active_req := -1;
END_IF;

(* --- Helper: position arrived check --- *)
(* We check if axis is within tolerance of target and speed is low *)

(* --- Request state machine --- *)
IF active_req = 0 THEN
    CASE req0_stage OF
        0: (* Move shuttle to station 3, fork retracted, lifts home *)
            D2000 := POS_S3;
            D2001 := RATE_STD;
            Y40 := TRUE;
            D2002 := 0;

            D2004 := FORK_RETRACT;
            D2005 := RATE_STD;
            Y41 := TRUE;
            D2006 := 0;

            D2008 := LIFT_HOME;
            D2009 := RATE_STD;
            Y42 := TRUE;
            D2010 := 0;

            D2012 := LIFT_HOME;
            D2013 := RATE_STD;
            Y43 := TRUE;
            D2014 := 0;

            IF ABS(D1000 - POS_S3) <= TOL_POS AND ABS(D1001) <= TOL_SPD THEN
                req0_stage := 1;
            END_IF;

        1: (* Connect: fork extended, lifts to dock height *)
            D2000 := POS_S3;
            D2001 := RATE_STD;
            Y40 := TRUE;
            D2002 := 0;

            D2004 := FORK_CONNECT;
            D2005 := RATE_STD;
            Y41 := TRUE;
            D2006 := 0;

            D2008 := LIFT_DOCK;
            D2009 := RATE_STD;
            Y42 := TRUE;
            D2010 := 0;

            D2012 := LIFT_DOCK;
            D2013 := RATE_STD;
            Y43 := TRUE;
            D2014 := 0;

            new_seq := new_seq + 1;
            D82 := new_seq;
            D80 := 1;
            D81 := 2;

            IF ABS(D1004 - FORK_CONNECT) <= TOL_POS AND ABS(D1005) <= TOL_SPD
               AND ABS(D1008 - LIFT_DOCK) <= TOL_POS AND ABS(D1009) <= TOL_SPD
               AND ABS(D1012 - LIFT_DOCK) <= TOL_POS AND ABS(D1013) <= TOL_SPD THEN
                req0_stage := 2;
            END_IF;

        2: (* Cell 3 processing - shuttle stays, lift docked *)
            D2000 := POS_S3;
            D2001 := RATE_STD;
            Y40 := TRUE;
            D2002 := 0;

            D2004 := FORK_CONNECT;
            D2005 := RATE_STD;
            Y41 := TRUE;
            D2006 := 0;

            D2008 := LIFT_DOCK;
            D2009 := RATE_STD;
            Y42 := TRUE;
            D2010 := 0;

            D2012 := LIFT_DOCK;
            D2013 := RATE_STD;
            Y43 := TRUE;
            D2014 := 0;

            (* Gantry targets from request *)
            D2016 := D500;
            D2017 := RATE_STD;
            Y44 := TRUE;
            D2018 := 0;
            D2020 := D501;
            D2021 := RATE_STD;
            Y45 := TRUE;
            D2022 := 0;

            D700 := D101;
            D701 := D104;
            D702 := 700;
            Y71 := TRUE;

            IF req0_cancelled = TRUE THEN
                req0_stage := 5;
            ELSIF D102 >= 2 THEN
                req0_stage := 3;
            END_IF;

        3: (* Move shuttle to station 4, fork retract, lifts home *)
            D2000 := POS_S4;
            D2001 := RATE_STD;
            Y40 := TRUE;
            D2002 := 0;

            D2004 := FORK_RETRACT;
            D2005 := RATE_STD;
            Y41 := TRUE;
            D2006 := 0;

            D2008 := LIFT_HOME;
            D2009 := RATE_STD;
            Y42 := TRUE;
            D2010 := 0;

            D2012 := LIFT_HOME;
            D2013 := RATE_STD;
            Y43 := TRUE;
            D2014 := 0;

            (* Keep gantry at target until clear *)
            D2016 := D500;
            D2017 := RATE_STD;
            Y44 := TRUE;
            D2018 := 0;
            D2020 := D501;
            D2021 := RATE_STD;
            Y45 := TRUE;
            D2022 := 0;

            IF ABS(D1000 - POS_S4) <= TOL_POS AND ABS(D1001) <= TOL_SPD THEN
                req0_stage := 4;
            END_IF;

        4: (* Cell 4 processing - configure reference if needed *)
            D2000 := POS_S4;
            D2001 := RATE_STD;
            Y40 := TRUE;
            D2002 := 0;

            D2004 := FORK_RETRACT;
            D2005 := RATE_STD;
            Y41 := TRUE;
            D2006 := 0;

            D2008 := LIFT_HOME;
            D2009 := RATE_STD;
            Y42 := TRUE;
            D2010 := 0;

            D2012 := LIFT_HOME;
            D2013 := RATE_STD;
            Y43 := TRUE;
            D2014 := 0;

            (* Frame axes to request targets *)
            D2024 := D600;
            D2025 := RATE_STD;
            Y46 := TRUE;
            D2026 := 0;
            D2028 := D601;
            D2029 := RATE_STD;
            Y47 := TRUE;
            D2030 := 0;

            D710 := D121;
            D711 := D124;
            D712 := 700;

            (* Configure reference while axes stopped *)
            IF ABS(D1024) <= 100 AND ABS(D1025) <= 100
               AND ABS(D1028) <= 100 AND ABS(D1029) <= 100 THEN
                Y75 := TRUE;
            ELSE
                Y75 := FALSE;
            END_IF;
            Y76 := TRUE;

            IF req0_cancelled = TRUE THEN
                req0_stage := 5;
            ELSIF D122 >= 2 THEN
                req0_stage := 5;
            END_IF;

        5: (* Return to station 2, fork connect, lifts to dock *)
            D2000 := POS_S2;
            D2001 := RATE_STD;
            Y40 := TRUE;
            D2002 := 0;

            D2004 := FORK_CONNECT;
            D2005 := RATE_STD;
            Y41 := TRUE;
            D2006 := 0;

            D2008 := LIFT_DOCK;
            D2009 := RATE_STD;
            Y42 := TRUE;
            D2010 := 0;

            D2012 := LIFT_DOCK;
            D2013 := RATE_STD;
            Y43 := TRUE;
            D2014 := 0;

            IF ABS(D1000 - POS_S2) <= TOL_POS AND ABS(D1001) <= TOL_SPD THEN
                req0_stage := 6;
            END_IF;

        6: (* Final return: shuttle to station 1, fork retract, lifts home *)
            D2000 := POS_S1;
            D2001 := RATE_STD;
            Y40 := TRUE;
            D2002 := 0;

            D2004 := FORK_RETRACT;
            D2005 := RATE_STD;
            Y41 := TRUE;
            D2006 := 0;

            D2008 := LIFT_HOME;
            D2009 := RATE_STD;
            Y42 := TRUE;
            D2010 := 0;

            D2012 := LIFT_HOME;
            D2013 := RATE_STD;
            Y43 := TRUE;
            D2014 := 0;

            IF ABS(D1000 - POS_S1) <= TOL_POS AND ABS(D1001) <= TOL_SPD
               AND ABS(D1004 - FORK_RETRACT) <= TOL_POS AND ABS(D1005) <= TOL_SPD
               AND ABS(D1008 - LIFT_HOME) <= TOL_POS AND ABS(D1009) <= TOL_SPD
               AND ABS(D1012 - LIFT_HOME) <= TOL_POS AND ABS(D1013) <= TOL_SPD THEN
                IF req0_cancelled = TRUE THEN
                    D300 := D100;
                    D301 := 2;
                ELSE
                    D300 := D100;
                    D301 := 1;
                END_IF;
                req0_done := TRUE;
            END_IF;
    END_CASE;

ELSIF active_req = 1 THEN
    CASE req1_stage OF
        0:
            D2000 := POS_S3;
            D2001 := RATE_STD;
            Y40 := TRUE;
            D2002 := 0;

            D2004 := FORK_RETRACT;
            D2005 := RATE_STD;
            Y41 := TRUE;
            D2006 := 0;

            D2008 := LIFT_HOME;
            D2009 := RATE_STD;
            Y42 := TRUE;
            D2010 := 0;

            D2012 := LIFT_HOME;
            D2013 := RATE_STD;
            Y43 := TRUE;
            D2014 := 0;

            IF ABS(D1000 - POS_S3) <= TOL_POS AND ABS(D1001) <= TOL_SPD THEN
                req1_stage := 1;
            END_IF;

        1:
            D2000 := POS_S3;
            D2001 := RATE_STD;
            Y40 := TRUE;
            D2002 := 0;

            D2004 := FORK_CONNECT;
            D2005 := RATE_STD;
            Y41 := TRUE;
            D2006 := 0;

            D2008 := LIFT_DOCK;
            D2009 := RATE_STD;
            Y42 := TRUE;
            D2010 := 0;

            D2012 := LIFT_DOCK;
            D2013 := RATE_STD;
            Y43 := TRUE;
            D2014 := 0;

            new_seq := new_seq + 1;
            D82 := new_seq;
            D80 := 1;
            D81 := 2;

            IF ABS(D1004 - FORK_CONNECT) <= TOL_POS AND ABS(D1005) <= TOL_SPD
               AND ABS(D1008 - LIFT_DOCK) <= TOL_POS AND ABS(D1009) <= TOL_SPD
               AND ABS(D1012 - LIFT_DOCK) <= TOL_POS AND ABS(D1013) <= TOL_SPD THEN
                req1_stage := 2;
            END_IF;

        2:
            D2000 := POS_S3;
            D2001 := RATE_STD;
            Y40 := TRUE;
            D2002 := 0;

            D2004 := FORK_CONNECT;
            D2005 := RATE_STD;
            Y41 := TRUE;
            D2006 := 0;

            D2008 := LIFT_DOCK;
            D2009 := RATE_STD;
            Y42 := TRUE;
            D2010 := 0;

            D2012 := LIFT_DOCK;
            D2013 := RATE_STD;
            Y43 := TRUE;
            D2014 := 0;

            D2016 := D500;
            D2017 := RATE_STD;
            Y44 := TRUE;
            D2018 := 0;
            D2020 := D501;
            D2021 := RATE_STD;
            Y45 := TRUE;
            D2022 := 0;

            D700 := D121;
            D701 := D124;
            D702 := 700;
            Y71 := TRUE;

            IF req1_cancelled = TRUE THEN
                req1_stage := 5;
            ELSIF D122 >= 2 THEN
                req1_stage := 3;
            END_IF;

        3:
            D2000 := POS_S4;
            D2001 := RATE_STD;
            Y40 := TRUE;
            D2002 := 0;

            D2004 := FORK_RETRACT;
            D2005 := RATE_STD;
            Y41 := TRUE;
            D2006 := 0;

            D2008 := LIFT_HOME;
            D2009 := RATE_STD;
            Y42 := TRUE;
            D2010 := 0;

            D2012 := LIFT_HOME;
            D2013 := RATE_STD;
            Y43 := TRUE;
            D2014 := 0;

            D2016 := D500;
            D2017 := RATE_STD;
            Y44 := TRUE;
            D2018 := 0;
            D2020 := D501;
            D2021 := RATE_STD;
            Y45 := TRUE;
            D2022 := 0;

            IF ABS(D1000 - POS_S4) <= TOL_POS AND ABS(D1001) <= TOL_SPD THEN
                req1_stage := 4;
            END_IF;

        4:
            D2000 := POS_S4;
            D2001 := RATE_STD;
            Y40 := TRUE;
            D2002 := 0;

            D2004 := FORK_RETRACT;
            D2005 := RATE_STD;
            Y41 := TRUE;
            D2006 := 0;

            D2008 := LIFT_HOME;
            D2009 := RATE_STD;
            Y42 := TRUE;
            D2010 := 0;

            D2012 := LIFT_HOME;
            D2013 := RATE_STD;
            Y43 := TRUE;
            D2014 := 0;

            D2024 := D600;
            D2025 := RATE_STD;
            Y46 := TRUE;
            D2026 := 0;
            D2028 := D601;
            D2029 := RATE_STD;
            Y47 := TRUE;
            D2030 := 0;

            D710 := D121;
            D711 := D124;
            D712 := 700;

            IF ABS(D1024) <= 100 AND ABS(D1025) <= 100
               AND ABS(D1028) <= 100 AND ABS(D1029) <= 100 THEN
                Y75 := TRUE;
            ELSE
                Y75 := FALSE;
            END_IF;
            Y76 := TRUE;

            IF req1_cancelled = TRUE THEN
                req1_stage := 5;
            ELSIF D122 >= 2 THEN
                req1_stage := 5;
            END_IF;

        5:
            D2000 := POS_S2;
            D2001 := RATE_STD;
            Y40 := TRUE;
            D2002 := 0;

            D2004 := FORK_CONNECT;
            D2005 := RATE_STD;
            Y41 := TRUE;
            D2006 := 0;

            D2008 := LIFT_DOCK;
            D2009 := RATE_STD;
            Y42 := TRUE;
            D2010 := 0;

            D2012 := LIFT_DOCK;
            D2013 := RATE_STD;
            Y43 := TRUE;
            D2014 := 0;

            IF ABS(D1000 - POS_S2) <= TOL_POS AND ABS(D1001) <= TOL_SPD THEN
                req1_stage := 6;
            END_IF;

        6:
            D2000 := POS_S1;
            D2001 := RATE_STD;
            Y40 := TRUE;
            D2002 := 0;

            D2004 := FORK_RETRACT;
            D2005 := RATE_STD;
            Y41 := TRUE;
            D2006 := 0;

            D2008 := LIFT_HOME;
            D2009 := RATE_STD;
            Y42 := TRUE;
            D2010 := 0;

            D2012 := LIFT_HOME;
            D2013 := RATE_STD;
            Y43 := TRUE;
            D2014 := 0;

            IF ABS(D1000 - POS_S1) <= TOL_POS AND ABS(D1001) <= TOL_SPD
               AND ABS(D1004 - FORK_RETRACT) <= TOL_POS AND ABS(D1005) <= TOL_SPD
               AND ABS(D1008 - LIFT_HOME) <= TOL_POS AND ABS(D1009) <= TOL_SPD
               AND ABS(D1012 - LIFT_HOME) <= TOL_POS AND ABS(D1013) <= TOL_SPD THEN
                IF req1_cancelled = TRUE THEN
                    D302 := D120;
                    D303 := 2;
                ELSE
                    D302 := D120;
                    D303 := 1;
                END_IF;
                req1_done := TRUE;
            END_IF;
    END_CASE;
END_IF;

(* --- When no active request, ensure home positions --- *)
IF active_req < 0 THEN
    D2000 := POS_S3;
    D2001 := RATE_STD;
    Y40 := TRUE;
    D2002 := 0;

    D2004 := FORK_RETRACT;
    D2005 := RATE_STD;
    Y41 := TRUE;
    D2006 := 0;

    D2008 := LIFT_HOME;
    D2009 := RATE_STD;
    Y42 := TRUE;
    D2010 := 0;

    D2012 := LIFT_HOME;
    D2013 := RATE_STD;
    Y43 := TRUE;
    D2014 := 0;

    (* Home cell axes *)
    D2016 := HOME_S30;
    D2017 := RATE_STD;
    Y44 := TRUE;
    D2018 := 0;
    D2020 := HOME_S31;
    D2021 := RATE_STD;
    Y45 := TRUE;
    D2022 := 0;
    Y71 := FALSE;
    Y70 := FALSE;

    D2024 := HOME_S40;
    D2025 := RATE_STD;
    Y46 := TRUE;
    D2026 := 0;
    D2028 := HOME_S41;
    D2029 := RATE_STD;
    Y47 := TRUE;
    D2030 := 0;
    Y75 := FALSE;
    Y76 := FALSE;
END_IF;

(* --- Completion check --- *)
IF (req0_done = TRUE OR req0_active = FALSE) AND (req1_done = TRUE OR req1_active = FALSE) THEN
    (* Check all axes at home positions *)
    IF ABS(D1000 - POS_S3) <= TOL_POS AND ABS(D1004 - FORK_RETRACT) <= TOL_POS
       AND ABS(D1008 - LIFT_HOME) <= TOL_POS AND ABS(D1012 - LIFT_HOME) <= TOL_POS
       AND ABS(D1016 - HOME_S30) <= TOL_POS AND ABS(D1020 - HOME_S31) <= TOL_POS
       AND ABS(D1024 - HOME_S40) <= TOL_POS AND ABS(D1028 - HOME_S41) <= TOL_POS
       AND ABS(D1001) <= TOL_SPD AND ABS(D1005) <= TOL_SPD
       AND ABS(D1009) <= TOL_SPD AND ABS(D1013) <= TOL_SPD
       AND ABS(D1017) <= TOL_SPD AND ABS(D1021) <= TOL_SPD
       AND ABS(D1025) <= TOL_SPD AND ABS(D1029) <= TOL_SPD THEN

        complete_timer(IN := TRUE, PT := T#100ms);
        IF complete_timer.Q = TRUE THEN
            Y2 := TRUE;
        END_IF;
    ELSE
        complete_timer(IN := FALSE);
        Y2 := FALSE;
    END_IF;
ELSE
    complete_timer(IN := FALSE);
    Y2 := FALSE;
END_IF;

(* --- Safety: brake management --- *)
Y30 := X52;

END_PROGRAM