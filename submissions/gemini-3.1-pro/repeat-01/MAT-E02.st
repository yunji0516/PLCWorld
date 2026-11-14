PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;

    init : BOOL := FALSE;
    started : BOOL := FALSE;
    start_edge : R_TRIG;
END_VAR

(* Preserve initial holding from the first scan *)
IF NOT init THEN
    Y20 := TRUE;
    init := TRUE;
END_IF

(* Check for start request *)
start_edge(CLK := X10);

IF start_edge.Q THEN
    started := TRUE;
END_IF

(* Execute release operation *)
IF started THEN
    Y20 := FALSE;
END_IF

(* Evaluate completion conditions: product received, gripper open and not holding *)
IF started AND NOT X20 AND X21 AND X22 THEN
    Y2 := TRUE;
END_IF

END_PROGRAM