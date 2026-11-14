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
    start_req : BOOL;
    state : INT;
    take_selected : BOOL;
    skip_selected : BOOL;
END_VAR

start_edge(CLK := X10);
IF start_edge.Q THEN
    start_req := TRUE;
END_IF;

CASE state OF
    0:
        IF start_req AND X20 THEN
            IF D20 = D10 THEN
                take_selected := TRUE;
                skip_selected := FALSE;
            ELSE
                take_selected := FALSE;
                skip_selected := TRUE;
            END_IF;
            state := 1;
            start_req := FALSE;
        END_IF;
        
    1:
        IF D20 = 0 THEN
            take_selected := FALSE;
            skip_selected := FALSE;
            state := 2;
        END_IF;
        
    2:
        IF X20 THEN
            state := 3;
        END_IF;
        
    3:
        (* Completion state, maintaining Y2 and outputs OFF *)
        ;
END_CASE;

Y20 := take_selected;
Y21 := skip_selected;
Y2 := (state = 3);

END_PROGRAM