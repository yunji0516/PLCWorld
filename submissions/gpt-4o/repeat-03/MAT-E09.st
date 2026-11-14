PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;
    D21 : INT;
    (* Internal variables *)
    start_triggered : BOOL := FALSE;
    valve_opening : BOOL := FALSE;
    desired_volume : INT := 0;
    initial_pumped : INT := 0;
    completed : BOOL := FALSE;
    countdown : INT := 0;
    edge : R_TRIG;
END_VAR

(* Implement the control logic here. *)

(* Edge detection for start request *)
edge(CLK := X10);

IF edge.Q THEN
    start_triggered := TRUE;
    desired_volume := D10;
    initial_pumped := D21;
    completed := FALSE;
END_IF

(* Main delivery process control *)
IF start_triggered AND NOT completed THEN
    valve_opening := NOT X20 AND NOT X21;

    (* Activate the valve until it's fully open *)
    Y20 := NOT X20;

    (* Once the valve is fully open, start the pump *)
    IF X20 THEN
        Y21 := TRUE;
    ELSE
        Y21 := FALSE;
    END_IF

    (* Check the delivery completion with ±2 ml tolerance *)
    IF D20 >= desired_volume - 2 AND D20 <= desired_volume + 2 THEN
        Y21 := FALSE;    (* Stop the pump *)
        Y20 := FALSE;    (* Close the valve *)
        completed := TRUE;
        countdown := 50; (* Initiate hold countdown *)
    END_IF
END_IF

(* Completion conditions *)
IF completed THEN
    IF countdown > 0 THEN
        Y2 := TRUE;
        countdown := countdown - 1;
    ELSE
        Y2 := FALSE;
    END_IF
ELSE
    Y2 := FALSE;
END_IF

END_PROGRAM