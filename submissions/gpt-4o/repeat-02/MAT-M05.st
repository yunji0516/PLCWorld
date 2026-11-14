PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    Y24 : BOOL := FALSE;
    Y26 : BOOL := FALSE;
    Y27 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    D20 : INT;
    D22 : INT;
    (* Internal Variables *)
    start_request_edge : BOOL := FALSE;
    current_layer : INT := 0;
    layers : ARRAY[1..4] OF INT;
    target_position : INT := 0;
    stack_height : INT := 0;
    move_completed : BOOL := FALSE;

    (* Function block instances *)
    start_edge_detector : R_TRIG;
    hold_timer : TON;
END_VAR

(* Detect rising edge of start request *)
start_edge_detector(CLK := X10);
start_request_edge := start_edge_detector.Q;

(* Only start processing on the rising edge *)
IF start_request_edge THEN
    (* Accept recipe and start request *)
    layers[1] := D11;
    layers[2] := D12;
    layers[3] := D13;
    layers[4] := D14;
    current_layer := 1;  (* Start processing from first layer *)
END_IF

(* Check if a valid start request was accepted *)
IF current_layer > 0 AND current_layer <= 4 THEN
    (* Current target layer *)
    IF layers[current_layer] = 0 AND NOT X20 THEN
        (* Move to Source A *)
        Y21 := TRUE;
    ELSIF layers[current_layer] = 1 AND NOT X21 THEN
        (* Move to Source B *)
        Y22 := TRUE;
    ELSE
        (* At the correct source *)
        Y21 := FALSE;
        Y22 := FALSE;
        
        (* Ensure source is present and ready to grip *)
        IF X27 AND NOT X25 AND NOT Y20 THEN
            Y20 := TRUE;  (* Grip Command *)
        END_IF
        
        (* Wait for physically holding the plate *)
        IF X25 THEN
            Y20 := FALSE;  (* Stop gripping command after acquiring the plate *)
            
            (* Move up if not high enough for side movement *)
            IF D22 < 450 THEN
                Y23 := TRUE;
            ELSE
                Y23 := FALSE;
                
                (* Move to stack position *)
                IF NOT X22 THEN
                    Y21 := TRUE;
                ELSE
                    Y21 := FALSE;
                    
                    (* Ensure correct height for stacking, if needed descend *)
                    IF NOT X24 THEN
                        Y24 := TRUE;
                    ELSE
                        Y24 := FALSE;
                        
                        (* Release the plate when positioned correctly *)
                        IF X22 AND NOT Y20 THEN
                            Y20 := FALSE;
                            hold_timer(IN := X25, PT := T#0.2s);
                            IF hold_timer.Q THEN
                                Y20 := FALSE;  (* Release Command *)
                                IF X26 AND stack_height = (25 * current_layer) THEN
                                    current_layer := current_layer + 1;  (* Move to next layer *)
                                END_IF
                            END_IF
                        END_IF
                        
                    END_IF
                END_IF
            END_IF
        END_IF
        
    END_IF
END_IF

(* Check for task completion *)
IF current_layer > 4 THEN
    (* All layers placed, move back to initial position at A upper position *)
    IF NOT X20 THEN
        Y21 := TRUE;
    ELSE
        Y21 := FALSE;
    END_IF
    
    IF X23 THEN
        move_completed := TRUE;
    ELSE
        Y23 := TRUE;
    END_IF

    (* Completion claim if all layers are correctly stacked and position reset *)
    IF move_completed AND (stack_height = (25 * 4)) THEN
        Y2 := TRUE;
    END_IF
END_IF

END_PROGRAM