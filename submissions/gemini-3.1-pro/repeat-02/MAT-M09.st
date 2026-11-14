PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    
    state : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

(* State machine for transfer sequence *)
CASE state OF
    0:
        (* Wait for start request *)
        IF start_edge.Q AND D10 = 1 THEN
            state := 1;
        END_IF;
        
    1:
        (* Move sender to dock *)
        IF X21 THEN
            state := 2;
        END_IF;
        
    2:
        (* Docked. Wait for receiver to be ready and armed (Ack reset) *)
        IF X24 AND NOT X23 THEN
            state := 3;
        END_IF;
        
    3:
        (* Assert Offer. Wait for Ack, meaning physical clamping is complete *)
        IF X23 THEN
            state := 4;
        END_IF;
        
    4:
        (* Release sender grip. Wait for final receiver ownership feedback *)
        IF X25 THEN
            state := 5;
        END_IF;
        
    5:
        (* Return sender to source and reset Offer *)
        IF X20 THEN
            state := 6;
        END_IF;
        
    6:
        (* Wait for Ack to reset after Offer is withdrawn *)
        IF NOT X23 THEN
            state := 7;
        END_IF;
        
    7:
        (* Sequence complete *)
        ;
END_CASE;

(* Concurrently map active state to outputs *)
Y20 := (state = 1);
Y21 := (state = 5);
Y22 := (state >= 4);
Y23 := (state = 3) OR (state = 4);
Y2  := (state = 7);

END_PROGRAM