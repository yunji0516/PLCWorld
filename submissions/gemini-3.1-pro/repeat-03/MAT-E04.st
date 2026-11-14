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
    X23 : BOOL;
    
    state : INT := 0;
    start_edge : R_TRIG;
    rearm_timer : TON;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q THEN
            state := 1;
        END_IF;
        
    1:
        (* Ensure Offer is OFF for at least 1.6s to guarantee transaction rearming. 
           Wait until Ack has lowered and receiver is Ready. *)
        IF rearm_timer.Q AND NOT X21 AND X22 THEN
            state := 2;
        END_IF;
        
    2:
        (* Offer the product and wait for a fresh Ack. *)
        IF X21 THEN
            state := 3;
        END_IF;
        
    3:
        (* Valid transaction acceptance. Release the sender and wait for physical handoff. *)
        IF X20 AND X23 THEN
            state := 4;
        END_IF;
        
    4:
        (* End the transaction by lowering Offer. Wait for Ack to be reset. *)
        IF NOT X21 THEN
            state := 5;
        END_IF;
        
    5:
        (* Handoff complete. Hold state and completion claim. *)
        ;
END_CASE;

(* Map state to physical outputs *)
Y2  := (state = 5);
Y20 := (state >= 3);
Y21 := (state = 2) OR (state = 3);

rearm_timer(IN := (state = 1), PT := T#1600ms);

END_PROGRAM