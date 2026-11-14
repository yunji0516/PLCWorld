PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    
    start_edge : R_TRIG;
    state : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        (* Preserve initial holding until Start *)
        Y20 := TRUE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            state := 1;
        END_IF;
        
    1:
        (* Release the product *)
        Y20 := FALSE;
        Y2 := FALSE;
        (* Check if the gripper is fully open, no longer holds the product, 
           and the product is received and supported *)
        IF X21 AND NOT X20 AND X22 THEN
            state := 2;
        END_IF;
        
    2:
        (* Completed: Keep grip OFF and retain completion claim *)
        Y20 := FALSE;
        Y2 := TRUE;
        
END_CASE;

END_PROGRAM