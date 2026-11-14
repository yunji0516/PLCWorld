PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    (* Add internal variables here. *)
    start_triggered : BOOL := FALSE;
    product_position : REAL := -250.0;
    speed : REAL := 400.0; (* Assuming a middle speed for calculation purposes *)
    product_moving : BOOL := FALSE;
    evaluation_count : INT := 0;
    holding_count : INT := 0;
    scanning : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)
IF NOT start_triggered AND X10 THEN
    start_triggered := TRUE;
END_IF

IF start_triggered AND NOT scanning THEN
    (* Start the conveyor when start is triggered *)
    Y20 := TRUE;
    product_moving := TRUE;
    scanning := TRUE;
END_IF

IF product_moving THEN
    (* Simulate the product movement *)
    product_position := product_position + speed * 0.01; (* Convert speed to mm per scan *)
    
    (* Check if the whole product has passed x=120 *)
    IF (product_position - 90.0 > 120.0) THEN
        (* Stop the conveyor *)
        Y20 := FALSE;
        product_moving := FALSE;
        
        (* Start holding phase *)
        Y2 := TRUE;
        holding_count := 0;
    END_IF
END_IF

(* Holding phase *)
IF Y2 THEN
    holding_count := holding_count + 1;
    IF holding_count >= 50 THEN
        (* Completed 50 scans of holding *)
        IF evaluation_count < 1550 THEN
            evaluation_count := evaluation_count + 1;
        ELSE
            (* Evaluation period exceeded *)
            Y2 := FALSE;
            scanning := FALSE;
        END_IF
    END_IF
END_IF

END_PROGRAM