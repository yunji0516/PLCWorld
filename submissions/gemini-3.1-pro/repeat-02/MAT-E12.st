PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    D20 : INT;
    D21 : INT;
    
    start_edge : R_TRIG;
    state : INT := 0;
END_VAR

start_edge(CLK := X10);

IF state = 0 THEN
    IF start_edge.Q THEN
        state := 1;
    END_IF;
ELSIF state = 1 THEN
    IF D20 = D10 THEN
        state := 2;
    END_IF;
END_IF;

Y20 := (state = 1);
Y2 := (state = 2);

END_PROGRAM