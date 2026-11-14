PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    Y24 : BOOL := FALSE;
    Y25 : BOOL := FALSE;
    Y26 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    Y2 : BOOL := FALSE;
    
    (* Internal variables *)
    start_request : BOOL := FALSE;
    task_started : BOOL := FALSE;
    align_x_done : BOOL := FALSE;
    align_z_done : BOOL := FALSE;
    move_complete : BOOL := FALSE;
    acquire_done : BOOL := FALSE;
    positioning_complete : BOOL := FALSE;

    start_trigger : R_TRIG;
    clear_fingers : BOOL := FALSE;
    
END_VAR

(* Detect rising edge on X10 *)
start_trigger(CLK := X10);
start_request := start_trigger.Q AND D10 = 1;

IF start_request THEN
    task_started := TRUE;
END_IF

IF task_started THEN
    
    (* Initial Grip Command *)
    IF NOT X24 THEN
        Y20 := TRUE; (* Grip command *)
    ELSE
        Y20 := FALSE;
    END_IF

    (* Move down to source level to acquire the workpiece *)
    IF X24 AND NOT X22 THEN
        Y24 := TRUE; (* Command to move down *)
    ELSIF X22 THEN
        Y24 := FALSE;
        acquire_done := TRUE; (* Acquisition position reached *)
    END_IF

    (* Check alignment and retract fingers when aligned *)
    IF acquire_done THEN
        IF NOT X31 THEN
            Y25 := TRUE; (* Align in X direction *)
        ELSE
            Y25 := FALSE;
            align_x_done := TRUE;
        END_IF

        IF NOT X32 THEN
            Y26 := TRUE; (* Align in Z direction *)
        ELSE
            Y26 := FALSE;
            align_z_done := TRUE;
        END_IF

        IF align_x_done AND align_z_done THEN
            clear_fingers := TRUE;
        END_IF
    END_IF
    
    (* Ensure Fingers are Clear *)
    IF clear_fingers THEN
        IF X29 THEN
            Y21 := FALSE; (* Hold horizontal movement *)
            clear_fingers := FALSE;
        ELSE
            Y21 := TRUE; (* Command to align complete *) 
        END_IF
    END_IF

    (* Move back to source with release *)
    IF align_x_done AND align_z_done AND X29 THEN
        IF NOT X23 THEN
            Y23 := TRUE; (* Move up to source *)
        ELSE
            Y23 := FALSE;
            move_complete := TRUE; (* Ready for horizontal travel *)
        END_IF
    END_IF

    (* Positioning complete, ready for move to receiver *)
    positioning_complete := move_complete;
END_IF

(* Completion and Terminal State *)
IF positioning_complete THEN
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
    task_started := FALSE; (* Reset start for next task cycle *)
END_IF

END_PROGRAM