PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    D20 : INT;

    (* Internal variables *)
    start_edge   : R_TRIG;
    started      : BOOL := FALSE;
    ext_done_latched : BOOL := FALSE;
    violation    : BOOL := FALSE;
    completed    : BOOL := FALSE;
    scan_count   : DINT := 0;

    low_thresh   : INT := 350;   (* turn unwind ON when buffer at/below this *)
    high_thresh  : INT := 600;   (* turn unwind OFF when buffer at/above this *)

    deadline_scans : DINT := 1550;
END_VAR

(* --- scan bookkeeping --- *)
scan_count := scan_count + 1;

(* --- start edge detection --- *)
start_edge(CLK := X10);
IF start_edge.Q THEN
    started := TRUE;
END_IF;

(* --- main control --- *)
IF NOT started THEN
    (* Safety: never initiate before Start *)
    Y20 := FALSE;
ELSE
    IF NOT ext_done_latched THEN
        (* hysteresis feedback control of unwind based on buffer level *)
        IF D20 <= low_thresh THEN
            Y20 := TRUE;
        ELSIF D20 >= high_thresh THEN
            Y20 := FALSE;
        END_IF;
        (* else: maintain previous Y20 state *)

        (* band violation monitoring, valid throughout withdrawal *)
        IF (D20 < 200) OR (D20 > 700) THEN
            violation := TRUE;
        END_IF;

        (* detect end of external withdrawal *)
        IF X20 THEN
            ext_done_latched := TRUE;
            Y20 := FALSE;
        END_IF;
    ELSE
        (* withdrawal ended: keep unwind OFF *)
        Y20 := FALSE;
    END_IF;
END_IF;

(* --- completion evaluation --- *)
IF (NOT completed) AND started AND ext_done_latched AND (NOT violation) THEN
    IF scan_count <= deadline_scans THEN
        completed := TRUE;
    END_IF;
END_IF;

IF completed THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM