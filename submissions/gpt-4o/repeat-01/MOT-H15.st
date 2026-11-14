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
    (* Add internal variables here. *)
    activeRequestId : DINT := -1;
    previousPostureRecord : REAL := 0.0;
    newSequenceNumber : DINT := 0;
    taskDone : BOOL := FALSE;
    taskTimer : TON;
    balanceTimer : TON;
END_VAR

(* Implement the control logic here. *)

(* Evaluate and select which request to process *)
IF NOT taskDone THEN
    (* Process only if not all done *)
    IF X51 THEN
        (* All requests are marked done *)
        taskDone := TRUE;
        taskTimer(IN := TRUE, PT := T#100ms);
    ELSE
        (* Select active request based on return/completion status and IDs *)
        IF NOT X30 AND NOT X31 THEN
            activeRequestId := D100;
        ELSIF NOT X34 AND NOT X35 THEN
            activeRequestId := D120;
        ELSE
            activeRequestId := -1; (* No active request *)
        END_IF;
        
        IF activeRequestId >= 0 THEN
            (* Define target positions and configurations based on the request and previous posture *)
            IF activeRequestId = D100 THEN
                (* Process request 1 *)
                D2000 := D500; (* Set shuttle X position target *)
                D2004 := D501; (* Set connection fork position target *)
                D2008 := D502; (* Set lift A height target *)
                D2012 := D502; (* Set lift B height target *)
                m4_accel := 700; (* Set acceleration for a consistent task execution *)
            ELSE
                (* Process request 2 *)
                D2000 := D600; (* Set shuttle X position target *)
                D2004 := D601; (* Set connection fork position target *)
                D2008 := D602; (* Set lift A height target *)
                D2012 := D602; (* Set lift B height target *)
                m4_accel := 700; (* Set acceleration for a consistent task execution *)
            END_IF;
            
            (* Set enable flags for all axes *)
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
            
            (* Engage mechanical brake if open *)
            IF NOT X52 THEN
                Y30 := TRUE; (* Engage the brake *)
            END_IF;
            
            (* Determine previous combined posture to select return pocket *)
            IF previousPostureRecord < 0.0 THEN
                D81 := 1; (* Pocket 1 *)
            ELSE
                D81 := 2; (* Pocket 2 *)
            END_IF;
            
            (* Generate new sequence number for connection *)
            newSequenceNumber := newSequenceNumber + 1;
            D82 := newSequenceNumber;
            
            (* Check if balance condition is met *)
            balanceTimer(IN := TRUE, PT := T#80ms);
            IF ABS(225 * SIN(D1016) + 225 * SIN(D1020) + D1024) <= 1000 THEN
                IF balanceTimer.Q THEN
                    (* Update balance record *)
                    previousPostureRecord := D1020; (* Update with current posture s3_1 angle *)
                END_IF;
            ELSE
                balanceTimer(IN := FALSE);
            END_IF;
        END_IF;
    END_IF;
ELSE
    (* Task completion condition, all requests are finished *)
    IF taskTimer.Q THEN
        Y2 := TRUE; (* Signal that completion is maintained *)
    END_IF;
END_IF;

END_PROGRAM