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
    currentRequestID : DINT;
    currentPosition : DINT;
    targetPosition : DINT;
    shuttleIdle : BOOL := TRUE;
    liftAFinished : BOOL := FALSE;
    liftBFinished : BOOL := FALSE;
    cell3Finished : BOOL := FALSE;
    cell4Finished : BOOL := FALSE;
    taskCompleted : BOOL := FALSE;
    cycleCount : DINT := 0;
    delayCount : DINT := 0;
END_VAR

(* Main Program Logic *)
IF NOT taskCompleted THEN
    (* Handle Request 1 or Request 2 based on which is not cancelled and due earlier *)
    IF (X31 OR (D103 > D123 AND NOT X35)) THEN
        currentRequestID := D120;
    ELSE
        currentRequestID := D100;
    END_IF

    (* Handle the shuttle and lifts logic *)
    IF shuttleIdle THEN
        IF NOT liftAFinished THEN
            (* Prepare Lift A to pick the jig *)
            D2008 := 950 * 100; (* Lift A to docking height *)
            D2009 := 1000;  (* Set drive ratio for Lift A *)
            Y42 := TRUE;    (* Enable Lift A drive *)

            (* Check if lift A reached the target *)
            IF ABS(D1008 - D2008) <= 0.2 * 100 AND D1009 <= 1 * 100 THEN 
                liftAFinished := TRUE;
                Y42 := FALSE;
            END_IF
        END_IF

        IF liftAFinished AND NOT liftBFinished THEN
            (* Prepare Lift B for next position *)
            D2012 := 950 * 100; (* Lift B to docking height *)
            D2013 := 1000;  (* Set drive ratio for Lift B *)
            Y43 := TRUE;    (* Enable Lift B drive *)

            (* Check if lift B reached the target *)
            IF ABS(D1012 - D2012) <= 0.2 * 100 AND D1013 <= 1 * 100 THEN 
                liftBFinished := TRUE;
                Y43 := FALSE;
            END_IF
        END_IF
    END_IF

    (* Handle Cell 3 Logic *)
    IF liftAFinished AND liftBFinished AND NOT cell3Finished THEN
        (* Set targets for Cell 3 operations *)
        D2016 := D500;   (* Set Angle for s3_0 *)
        D2020 := D501;   (* Set Distance for s3_1 *)
        D2017 := 1000;   (* Drive ratio for s3_0 *)
        D2021 := 1000;   (* Drive ratio for s3_1 *)
        Y44 := TRUE;     (* Enable s3_0 drive *)
        Y45 := TRUE;     (* Enable s3_1 drive *)

        (* Check completion for Cell 3 *)
        IF ABS(D1016 - D2016) <= 0.2 * 100 AND ABS(D1020 - D2020) <= 0.2 * 100 THEN
            cell3Finished := TRUE;
            Y44 := FALSE;
            Y45 := FALSE;
        END_IF
    END_IF

    (* Handle Cell 4 Logic *)
    IF cell3Finished AND NOT cell4Finished THEN
        (* Set targets for Cell 4 operations *)
        D2024 := D600;   (* Set Angle for s4_0 *)
        D2028 := D601;   (* Set Distance for s4_1 *)
        D2032 := D602;   (* Set Distance for s4_2 *)
        D2025 := 1000;   (* Drive ratio for s4_0 *)
        D2029 := 1000;   (* Drive ratio for s4_1 *)
        D2033 := 1000;   (* Drive ratio for s4_2 *)
        Y46 := TRUE;     (* Enable s4_0 drive *)
        Y47 := TRUE;     (* Enable s4_1 drive *)
        Y48 := TRUE;     (* Enable s4_2 drive *)

        (* Check completion for Cell 4 *)
        IF ABS(D1024 - D2024) <= 0.2 * 100 AND ABS(D1028 - D2028) <= 0.2 * 100 AND ABS(D1032 - D2032) <= 0.2 * 100 THEN
            cell4Finished := TRUE;
            Y46 := FALSE;
            Y47 := FALSE;
            Y48 := FALSE;
        END_IF
    END_IF

    (* Finalizing the task *)
    IF cell4Finished THEN
        taskCompleted := TRUE;

        (* Respond with completion ID and status (1 for completion) *)
        IF currentRequestID = D100 THEN
            D300 := D100;
            D301 := 1;
        ELSE
            D302 := D120;
            D303 := 1;
        END_IF

        (* Maintain Y2 for 100ms *)
        IF cycleCount < 5 THEN
            Y2 := TRUE;
            cycleCount := cycleCount + 1;
        ELSE 
            Y2 := FALSE;
        END_IF
    END_IF
ELSE
    IF X51 THEN
        (* Reset state if all_done is triggered and task is completed *)
        taskCompleted := FALSE;
        cycleCount := 0;
        liftAFinished := FALSE;
        liftBFinished := FALSE;
        cell3Finished := FALSE;
        cell4Finished := FALSE;
        shuttleIdle := TRUE;
    END_IF
END_IF

END_PROGRAM