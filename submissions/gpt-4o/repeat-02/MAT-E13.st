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
    (* Add internal variables here. *)
    start_edge : R_TRIG;
    key_to_check : INT := 0;
    product_in_progress : BOOL := FALSE;
    key_matched : BOOL := FALSE;
    scan_counter : INT := 0;
    holding_phase : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

start_edge(CLK := X10);

(* Check for start request and capture the key. *)
IF start_edge.Q AND NOT product_in_progress THEN
    key_to_check := D20;
    key_matched := (key_to_check = D10);
    product_in_progress := TRUE;
END_IF

(* Routing logic based on key match. *)
IF product_in_progress THEN
    IF X20 THEN
        IF key_matched THEN
            Y20 := TRUE;  (* Take command *)
            Y21 := FALSE;
        ELSE
            Y20 := FALSE;
            Y21 := TRUE;  (* Skip command *)
        END_IF
    ELSIF X21 THEN
        (* Product has been delivered; reset process variables. *)
        Y20 := FALSE;
        Y21 := FALSE;
        product_in_progress := FALSE;
        holding_phase := TRUE;
        scan_counter := 0;
    END_IF
END_IF

(* Hold the result and complete the task. *)
IF holding_phase THEN
    Y2 := TRUE;
    scan_counter := scan_counter + 1;
    IF scan_counter >= 50 THEN
        holding_phase := FALSE;
        Y2 := FALSE;
    END_IF
END_IF

END_PROGRAM