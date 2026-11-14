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
    
    start_edge : R_TRIG;
    product_mass : INT;
    computed_left_load : INT;
    computed_right_load : INT;
    min_load_side : BOOL; (* TRUE for left, FALSE for right *)
    is_product_transferred : BOOL := FALSE;
    holding_counter : INT := 0;
END_VAR

(* Trigger detection on start request *)
start_edge(CLK := X10);

(* Decision logic based on start request *)
IF start_edge.Q AND D10 = 1 THEN
    product_mass := D20;

    (* Compute the potential load difference for left side *)
    computed_left_load := ABS((D21 + product_mass) - D22);

    (* Compute the potential load difference for right side *)
    computed_right_load := ABS(D21 - (D22 + product_mass));

    (* Decide which side to transfer by minimizing load difference *)
    IF (computed_left_load < computed_right_load AND X22) OR (NOT X23) THEN
        (* Transfer to the left if it's optimal or right is not available *)
        min_load_side := TRUE;
    ELSIF (computed_right_load < computed_left_load AND X23) OR (NOT X22) THEN
        (* Transfer to the right if it's optimal or left is not available *)
        min_load_side := FALSE;
    ELSE
        (* Default to left in case of strict equality or both sides available *)
        min_load_side := TRUE;
    END_IF;
    
    (* Initiate transfer command *)
    IF min_load_side THEN
        Y20 := TRUE;
    ELSE
        Y21 := TRUE;
    END_IF;
    
    is_product_transferred := TRUE;
END_IF;

(* Receipt detection and stop command *)
IF is_product_transferred THEN
    IF X20 THEN
        (* Received on left *)
        Y20 := FALSE;
        is_product_transferred := FALSE;
        Y2 := TRUE;
    ELSIF X21 THEN
        (* Received on right *)
        Y21 := FALSE;
        is_product_transferred := FALSE;
        Y2 := TRUE;
    END_IF;
END_IF;

(* Holding period for completion claim *)
IF Y2 THEN
    holding_counter := holding_counter + 1;
    IF holding_counter >= 50 THEN
        Y2 := FALSE;
    END_IF;
END_IF;

END_PROGRAM