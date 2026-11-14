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
    
    (* Internal variables *)
    start_edge : R_TRIG;
    move_timer : TON;
    state : INT;
    latched_key : INT;
    is_match : BOOL;
END_VAR

(* Update edge detector for Start signal *)
start_edge(CLK := X10);

CASE state OF
    0: 
        (* State 0: Idle / Home *)
        (* Wait for Start request rising edge and confirm module is home *)
        IF start_edge.Q AND X20 THEN
            (* Latch the product key while at home (before D20 becomes 0 at extension) *)
            latched_key := D20;
            (* Determine if key matches request *)
            is_match := (latched_key = D10);
            (* Transition to extending state *)
            state := 1;
        END_IF;
        
    1: 
        (* State 1: Extending / Delivery *)
        IF is_match THEN
            (* Key matches: Route to Accepted Pocket (Take) *)
            Y20 := TRUE;
            Y21 := FALSE;
            
            (* Wait for product placement confirmation *)
            IF X21 THEN
                (* Product placed, turn off actuator to return home *)
                Y20 := FALSE;
                state := 2;
            END_IF;
        ELSE
            (* Key mismatch: Route to Bypass (Skip) *)
            Y20 := FALSE;
            Y21 := TRUE;
            
            (* Hold Skip output for 0.5s to reach full extension *)
            move_timer(IN := TRUE, PT := T#500ms);
            
            (* Wait for timer to elapse *)
            IF move_timer.Q THEN
                (* Reached extension, turn off actuator to return home *)
                Y21 := FALSE;
                move_timer(IN := FALSE, PT := T#500ms); (* Reset timer *)
                state := 2;
            END_IF;
        END_IF;
        
    2: 
        (* State 2: Returning Home *)
        (* Ensure actuators are OFF to trigger return motion *)
        Y20 := FALSE;
        Y21 := FALSE;
        
        (* Wait for home sensor confirmation *)
        IF X20 THEN
            (* Module is home, delivery complete *)
            state := 3;
        END_IF;
        
    3: 
        (* State 3: Completion *)
        (* Claim completion *)
        Y2 := TRUE;
        (* Outputs Y20/Y21 remain OFF from State 2 *)
        
END_CASE;

END_PROGRAM