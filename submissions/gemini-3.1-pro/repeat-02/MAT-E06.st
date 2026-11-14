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
    start_trig : R_TRIG;
END_VAR

start_trig(CLK := X10);

CASE state OF
    0:
        IF start_trig.Q THEN
            state := 1;
        END_IF;
        
    1:
        (* Push forward until the end of the stroke is reached *)
        IF X21 THEN
            state := 2;
        END_IF;
        
    2:
        (* Retract until the pusher is back to the home position *)
        IF X20 THEN
            state := 3;
        END_IF;
        
    3:
        (* Operation complete, hold state *)
        ;
END_CASE;

(* 
   Assign outputs based on the current state.
   This guarantees that opposed direction commands (Y20 and Y21) 
   are never asserted simultaneously.
*)
Y20 := (state = 1);
Y21 := (state = 2);
Y2  := (state = 3);

END_PROGRAM