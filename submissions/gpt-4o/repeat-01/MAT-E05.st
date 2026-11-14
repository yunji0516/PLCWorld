PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    (* Internal variables *)
    start_trigger : R_TRIG;
    align_x_done : BOOL := FALSE;
    align_z_done : BOOL := FALSE;
    retract_x : BOOL := FALSE;
    retract_z : BOOL := FALSE;
    fingers_retracted : BOOL := FALSE;
    completed : BOOL := FALSE;
    scan_counter : INT := 0;
END_VAR

(* Rising edge detection for start command *)
start_trigger(CLK := X10);

IF start_trigger.Q THEN
    scan_counter := 0; (* Reset scan counter on start *)
    align_x_done := FALSE; (* Reset alignment states *)
    align_z_done := FALSE;
    retract_x := FALSE;
    retract_z := FALSE;
    fingers_retracted := FALSE;
    completed := FALSE;
END_IF

IF D10 = 1 THEN
    IF NOT align_x_done THEN
        Y20 := TRUE;
        IF X20 THEN
            Y20 := FALSE;
            align_x_done := TRUE;
            retract_x := TRUE;
        END_IF
    ELSIF retract_x THEN
        Y20 := FALSE;
        retract_x := FALSE;
    END_IF
    
    IF NOT align_z_done THEN
        Y21 := TRUE;
        IF X21 THEN
            Y21 := FALSE;
            align_z_done := TRUE;
            retract_z := TRUE;
        END_IF
    ELSIF retract_z THEN
        Y21 := FALSE;
        retract_z := FALSE;
    END_IF
    
    fingers_retracted := X22;
    
    IF align_x_done AND align_z_done AND fingers_retracted THEN
        completed := TRUE;
    END_IF
END_IF

IF completed THEN
    scan_counter := scan_counter + 1;
    Y2 := TRUE;
    IF scan_counter >= 1600 THEN
        completed := FALSE; (* Reset completion state after evaluation window *)
    END_IF
ELSE
    Y2 := FALSE;
END_IF

END_PROGRAM