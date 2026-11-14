PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;
    (* Internal variables *)
    start_edge : R_TRIG;
    current_side : BOOL; (* TRUE = left, FALSE = right *)
    operation_done : BOOL := FALSE;
    load_diff_left : INT;
    load_diff_right : INT;
    product_transferred : BOOL := FALSE;
    scan_count : INT := 0;
END_VAR

(* Execute start edge detection *)
start_edge(CLK := X10);

(* Calculate load differences if a start request is detected *)
IF start_edge.Q AND D10 = 1 THEN
    load_diff_left := ABS((D21 + D20) - D22);
    load_diff_right := ABS(D21 - (D22 + D20));

    (* Determine the best side to transfer the product *)
    IF X22 AND (load_diff_left <= load_diff_right) THEN
        current_side := TRUE; (* Choosing to transfer to left *)
    ELSIF X23 THEN
        current_side := FALSE; (* Choosing to transfer to right *)
    END_IF;

    IF current_side THEN
        Y20 := TRUE; (* Activate left feed *)
        Y21 := FALSE; (* Ensure right feed is off *)
    ELSE
        Y20 := FALSE; (* Ensure left feed is off *)
        Y21 := TRUE; (* Activate right feed *)
    END_IF;
END_IF;

(* Check if the product is received and stop the feed *)
IF current_side AND X20 THEN
    Y20 := FALSE;
    product_transferred := TRUE;
ELSIF NOT current_side AND X21 THEN
    Y21 := FALSE;
    product_transferred := TRUE;
END_IF;

(* Completion logic *)
IF product_transferred THEN
    operation_done := TRUE;
    product_transferred := FALSE;
END_IF;

(* Evaluation window and completion claim *)
IF operation_done THEN
    Y2 := TRUE; (* Set completion claim *)
    scan_count := scan_count + 1;
    IF scan_count >= 1600 THEN
        Y2 := FALSE; (* Reset completion claim after evaluation window *)
        operation_done := FALSE;
        scan_count := 0;
    END_IF;
END_IF;

END_PROGRAM