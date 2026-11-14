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
    D20 : INT;
    D21 : INT;
    D22 : INT;
    D23 : INT;
    D24 : INT;
    D25 : INT;
    D26 : INT;

    start_triggered : BOOL := FALSE;
    loaded_left : INT := 0;
    loaded_right : INT := 0;
    current_index : INT := 0;
    weights : ARRAY[1..4] OF INT;
    total_loads : INT := 0;
    
    load_left : BOOL := FALSE;
    load_right : BOOL := FALSE;
    
    edge_x10 : R_TRIG;
END_VAR

(* Function to determine placement side based on current load balance *)
FUNCTION BalancePlacement : BOOL
VAR
BEGIN
    IF (D24 + weights[D26 + 1] <= D25) THEN
        RETURN TRUE;  (* Place the next item on the left if it maintains or achieves balance *)
    ELSE
        RETURN FALSE; (* Place on the right otherwise *)
    END_IF;
END_FUNCTION

(* Initialization of weights array *)
weights[1] := D20;
weights[2] := D21;
weights[3] := D22;
weights[4] := D23;

(* Edge detection for start request *)
edge_x10(CLK := X10);
IF edge_x10.Q AND NOT start_triggered THEN
    start_triggered := TRUE;
    Y2 := FALSE;         (* Reset completion claim *)
    current_index := 0;  (* Reset index *)
    total_loads := 0;    (* Reset total loads *)
    loaded_left := 0;
    loaded_right := 0;
END_IF

(* Loading control logic *)
IF start_triggered AND NOT Y2 THEN
    IF X20 AND current_index < 4 THEN
        (* Determine which side to load next based on balance *)
        IF BalancePlacement THEN
            load_left := TRUE;
            load_right := FALSE;
        ELSE
            load_left := FALSE;
            load_right := TRUE;
        END_IF
        
        (* Command the appropriate placement *)
        IF load_left THEN
            Y20 := TRUE;
            IF X22 THEN
                Y20 := FALSE;
                loaded_left := loaded_left + 1;
                current_index := current_index + 1;
            END_IF
        ELSIF load_right THEN
            Y21 := TRUE;
            IF X22 THEN
                Y21 := FALSE;
                loaded_right := loaded_right + 1;
                current_index := current_index + 1;
            END_IF
        END_IF
    END_IF
    
    (* Check if all four materials are loaded in balance *)
    IF loaded_left + loaded_right = 4 THEN
        IF ABS(D24 - D25) <= 1 THEN
            (* Command departure once balanced loading is achieved *)
            Y22 := TRUE;
        ELSE
            (* Rebalance loads if necessary *)
            // (Additional rebalancing logic could be placed here)
        END_IF
    ELSE
        Y22 := FALSE;
    END_IF
    
    (* Completion condition check *)
    IF X23 THEN
        Y22 := FALSE;
        IF ABS(D24 - D25) <= 1 AND X20 THEN
            Y2 := TRUE;  (* Declare completion claim *)
        ELSE
            Y2 := FALSE;
        END_IF
    END_IF
END_IF

END_PROGRAM