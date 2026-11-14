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
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF start_edge.Q THEN
            state := 1;
        END_IF
        
    1:
        (* Ensure Offer is OFF to lower a potentially stale Ack and rearm the transaction. 
           Wait for Ack to drop and Ready to be true. *)
        Y21 := FALSE;
        IF NOT X21 AND X22 THEN
            state := 2;
        END_IF
        
    2:
        (* Assert Offer and wait for a valid current-transaction acceptance (Ack). *)
        Y21 := TRUE;
        IF X21 THEN
            state := 3;
        END_IF
        
    3:
        (* Valid acceptance received. Release the sender and turn off Offer. *)
        Y20 := TRUE;
        Y21 := FALSE;
        (* Wait for actual ownership transfer, physical release, and Ack reset. *)
        IF X23 AND X20 AND NOT X21 THEN
            state := 4;
        END_IF
        
    4:
        (* Completion: maintain handoff state and assert Y2 completion claim. *)
        Y2 := TRUE;
        Y20 := TRUE;
        Y21 := FALSE;
END_CASE

END_PROGRAM