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
    
    start_edge : R_TRIG;
    state : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        (* Wait for Start request *)
        IF start_edge.Q THEN
            state := 1;
        END_IF;
        
    1:
        (* Push to eject the product *)
        IF X21 THEN
            state := 2;
        END_IF;
        
    2:
        (* Retract the pusher home *)
        IF X20 THEN
            state := 3;
        END_IF;
        
    3:
        (* Completed, hold the result state *)
        ;
END_CASE;

(* Mutually exclusive actuator commands and completion claim *)
Y20 := (state = 1);
Y21 := (state = 2);
Y2 := (state = 3);

END_PROGRAM