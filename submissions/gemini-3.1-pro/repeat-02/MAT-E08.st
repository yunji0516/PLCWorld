PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    
    start_edge : R_TRIG;
    state : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q THEN
            state := 1;
        END_IF;
        
    1:
        (* Moving forward, waiting for the leading edge to block the photoeye at x=120 mm *)
        IF X20 THEN
            state := 2;
        END_IF;
        
    2:
        (* Photoeye is blocked, waiting for the trailing edge to pass and clear it *)
        IF NOT X20 THEN
            state := 3;
        END_IF;
        
    3:
        (* Product has passed the boundary and remains fully supported on the conveyor; keep state *)
        ;
END_CASE;

(* Conveyor motor command *)
Y20 := (state = 1) OR (state = 2);

(* Completion claim *)
Y2 := (state = 3);

END_PROGRAM