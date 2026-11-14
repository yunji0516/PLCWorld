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
    
    state : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

(* Default outputs to OFF to ensure no simultaneous assertion *)
Y20 := FALSE;
Y21 := FALSE;
Y2 := FALSE;

CASE state OF
    0:
        (* Wait for start request *)
        IF start_edge.Q THEN
            state := 1;
        END_IF;
        
    1:
        (* Push product until full forward travel is reached *)
        IF X21 THEN
            state := 2;
            Y21 := TRUE;
        ELSE
            Y20 := TRUE;
        END_IF;
        
    2:
        (* Retract pusher until it returns home *)
        IF X20 THEN
            state := 3;
            Y2 := TRUE;
        ELSE
            Y21 := TRUE;
        END_IF;
        
    3:
        (* Hold completion claim *)
        Y2 := TRUE;
END_CASE;

END_PROGRAM