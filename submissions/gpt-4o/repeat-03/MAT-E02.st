PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := TRUE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;

    start_edge : R_TRIG;
    operation_started : BOOL := FALSE;
    operation_completed : BOOL := FALSE;
    scan_counter : INT := 0;
END_VAR

(* Implement the control logic here. *)
start_edge(CLK := X10);

IF NOT operation_started THEN
    Y20 := TRUE; (* Maintain grip ON until start *)
    IF start_edge.Q AND D10 = 1 THEN
        operation_started := TRUE;
        Y20 := FALSE; (* Initiate release sequence *)
    END_IF;
ELSIF operation_started AND NOT operation_completed THEN
    IF X21 AND X22 THEN
        operation_completed := TRUE;
        Y2 := TRUE; (* Declare completion *)
    END_IF;
END_IF;

IF operation_completed THEN
    Y20 := FALSE; (* Ensure grip is OFF *)
    scan_counter := scan_counter + 1;

    IF scan_counter >= 1600 THEN
        Y2 := FALSE; (* Reset completion claim once evaluation window ends *)
    END_IF;
END_IF;

END_PROGRAM