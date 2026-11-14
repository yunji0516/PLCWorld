PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;

    (* Internal variables *)
    start_trig : R_TRIG;
    started : BOOL := FALSE;
    completed : BOOL := FALSE;
    edge_bad : BOOL := FALSE;
    scan_since_start : DINT := 0;
    deadband : INT := 2;
END_VAR

(* Detect the single rising edge Start request *)
start_trig(CLK := X10);
IF start_trig.Q THEN
    started := TRUE;
END_IF;

(* Count scans since the operation was started *)
IF started THEN
    scan_since_start := scan_since_start + 1;
END_IF;

(* Monitor corridor violation throughout the feed / observation *)
IF started AND (ABS(D20) > 12) THEN
    edge_bad := TRUE;
END_IF;

(* Steering control law - never assert both directions at once *)
IF NOT started THEN
    (* Do not initiate before Start *)
    Y20 := FALSE;
    Y21 := FALSE;
ELSIF X20 THEN
    (* Feed physically finished: both steering commands OFF *)
    Y20 := FALSE;
    Y21 := FALSE;
ELSE
    IF D20 > deadband THEN
        Y20 := TRUE;
        Y21 := FALSE;
    ELSIF D20 < -deadband THEN
        Y20 := FALSE;
        Y21 := TRUE;
    ELSE
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF;
END_IF;

(* Completion evaluation *)
IF (NOT completed) AND started AND X20 AND (NOT Y20) AND (NOT Y21)
   AND (NOT edge_bad) AND (ABS(D20) <= 12) AND (scan_since_start <= 1550) THEN
    completed := TRUE;
END_IF;

(* Retain the completion claim through the remaining execution budget *)
Y2 := completed;

END_PROGRAM