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
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    
    start_trigger : R_TRIG;
    passage_count : INT := 0;
    net_forward_passages : INT := 0;
    batch_ready : BOOL := FALSE;
    feeding : BOOL := FALSE;
    dispatching : BOOL := FALSE;
    current_state : INT := 0;
    external_return_active : BOOL := FALSE;
    scan_count : INT := 0;
END_VAR

(* --- // Initialize Edge Detector for Start Button // --- *)
start_trigger(CLK := X10);

(* --- // Main Control Logic // --- *)
IF start_trigger.Q THEN
    current_state := 1;  (* Transition to feeding state *)
END_IF

CASE current_state OF
    0: (* Idle State *)
        Y20 := FALSE;  (* Feed OFF *)
        Y21 := FALSE;  (* Dispatch OFF *)
        IF X23 AND X24 AND NOT X22 THEN  (* All conditions met for completion *)
            Y2 := TRUE;  (* Hold completion claim *)
        ELSE
            Y2 := FALSE;
        END_IF

    1: (* Feeding State *)
        IF NOT dispatching AND NOT X22 THEN
            Y20 := TRUE;  (* Turn on feed *)
            feeding := TRUE;
        END_IF
        
        (* Check for complete forward passage *)
        IF feeding AND X21 AND NOT X20 THEN  (* Clear through B only, starting forward motion *)
            IF X22 THEN
                external_return_active := TRUE;  (* External return starts *)
                feeding := FALSE;
                Y20 := FALSE;  (* Stop feeding during external return *)
            ELSE
                passage_count := passage_count + 1;
                feeding := FALSE;
                Y20 := FALSE;  (* Turn off feed after passage is counted *)
                
                IF passage_count = D10 THEN  (* If requested batch count is reached *)
                    batch_ready := TRUE;
                    current_state := 2;  (* Move to dispatch state *)
                END_IF
            END_IF
        END_IF

    2: (* Dispatch State *)
        IF X24 AND NOT X23 AND batch_ready AND NOT X22 THEN
            dispatching := TRUE;
            Y21 := TRUE;  (* Turn on dispatch *)
        END_IF
        
        IF X25 THEN
            Y21 := FALSE;  (* Turn off dispatch when endpoint is reached *)
            dispatching := FALSE;
            current_state := 0;  (* Reset to idle state *)
        END_IF

END_CASE

(* Increment scan count up to the evaluation window limit *)
IF scan_count < 7000 THEN
    scan_count := scan_count + 1;
ELSE
    scan_count := 0;  (* reset or take appropriate action *)
END_IF

END_PROGRAM