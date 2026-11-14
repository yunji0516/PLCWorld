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
        (* Completion state; maintain outputs *)
        ;
END_CASE;

Y20 := (state = 1);
Y21 := (state = 2);
Y2 := (state = 3);

END_PROGRAM