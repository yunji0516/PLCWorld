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
    (* Add internal variables here. *)
    start_edge : R_TRIG;
    pushing : BOOL := FALSE;
    retracting : BOOL := FALSE;
    operation_started : BOOL := FALSE;
    complete_holding_counter : INT := 0;
    task_completed : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

start_edge(CLK := X10);

IF start_edge.Q AND NOT operation_started THEN
    (* Start the operation *)
    operation_started := TRUE;
    pushing := TRUE;
    retracting := FALSE;
    Y2 := FALSE;
    complete_holding_counter := 0;
END_IF

IF operation_started THEN
    IF pushing THEN
        Y20 := TRUE;
        Y21 := FALSE;
        
        IF X21 THEN
            (* End position reached, start retracting *)
            pushing := FALSE;
            retracting := TRUE;
        END_IF
    ELSIF retracting THEN
        Y20 := FALSE;
        Y21 := TRUE;

        IF X20 THEN
            (* Home position reached, operation complete *)
            retracting := FALSE;
            task_completed := TRUE;
            Y2 := TRUE; (* Completion claim *)
            Y21 := FALSE;
        END_IF
    END_IF
END_IF

(* Completion holding logic *)
IF task_completed THEN
    IF complete_holding_counter < 50 THEN
        complete_holding_counter := complete_holding_counter + 1;
    ELSE
        (* Disable outputs after holding period *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF
END_IF

END_PROGRAM