PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    D20 : INT;
    D21 : INT;

    start_triggered : BOOL := FALSE;
    product_supplied : BOOL := FALSE;
    pusher_extended : BOOL := FALSE;
    
    launch_ready : BOOL;
    launch_timing_ok : BOOL;
    
    fire_edge : R_TRIG;
    retract_edge : R_TRIG;
    
END_VAR

fire_edge(CLK := X23 AND X24 AND NOT Y21);
retract_edge(CLK := X22);

launch_ready := X23 AND X24 AND NOT Y21;

(* Main Control Logic *)
IF X10 AND NOT start_triggered THEN
    start_triggered := TRUE;
END_IF

IF start_triggered THEN
    (* Supply the product *)
    IF NOT product_supplied AND X20 AND D10 = 1 THEN
        Y22 := TRUE;
        IF X23 THEN
            product_supplied := TRUE;
            Y22 := FALSE;
        END_IF
    END_IF
    
    (* Launch the product *)
    IF product_supplied AND launch_ready THEN
        IF D20 <= 30 THEN
            IF NOT Y20 THEN
                Y20 := TRUE;
            END_IF
        END_IF
        
        IF fire_edge.Q THEN
            Y20 := FALSE;
            Y21 := TRUE;
        END_IF
        
        IF retract_edge.Q THEN
            Y21 := FALSE;
            product_supplied := FALSE;
            pusher_extended := FALSE;
            
            (* Check if product is received and all actuators are off *)
            IF X22 AND X20 AND X24 THEN
                Y2 := TRUE;
            END_IF
        END_IF
    END_IF
END_IF

END_PROGRAM