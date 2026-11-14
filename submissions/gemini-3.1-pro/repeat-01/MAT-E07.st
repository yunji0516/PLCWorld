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
    D20 : INT;
    
    state : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q THEN
            state := 1;
        END_IF;
        
    1:
        IF X22 THEN
            state := 2;
        END_IF;
        
    2:
        IF X20 THEN
            state := 3;
        END_IF;
        
    3:
        (* Hold completion state *)
        ;
END_CASE;

(* Safely assign outputs, ensuring mutually exclusive direction commands *)
Y20 := FALSE;
Y21 := FALSE;
Y2 := FALSE;

CASE state OF
    1:
        Y20 := TRUE;
    2:
        Y21 := TRUE;
    3:
        Y2 := TRUE;
END_CASE;

END_PROGRAM