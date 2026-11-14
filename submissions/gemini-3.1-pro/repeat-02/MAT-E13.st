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
    
    start_edge : R_TRIG;
    state : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q THEN
            IF D20 = D10 THEN
                state := 1;
            ELSE
                state := 2;
            END_IF;
        END_IF;
        
    1:
        IF D20 = 0 THEN
            state := 3;
        END_IF;
        
    2:
        IF D20 = 0 THEN
            state := 3;
        END_IF;
        
    3:
        IF X20 THEN
            state := 4;
        END_IF;
        
    4:
        (* Task complete; maintain result *)
        ;
END_CASE;

Y20 := (state = 1);
Y21 := (state = 2);
Y2  := (state = 4);

END_PROGRAM