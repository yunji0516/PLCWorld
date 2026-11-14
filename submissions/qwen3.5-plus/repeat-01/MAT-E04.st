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
    
    start_edge : R_TRIG;
    reset_timer : TON;
    ack_reset_timer : TON;
    state : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0: (* IDLE - wait for Start rising edge *)
        Y21 := FALSE;
        Y20 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            state := 1;
            reset_timer(IN := TRUE, PT := T#200ms);
        END_IF;
        
    1: (* RESET_ACK - Offer OFF lowers stale Ack and rearms *)
        Y21 := FALSE;
        Y20 := FALSE;
        reset_timer(IN := TRUE, PT := T#200ms);
        IF reset_timer.Q AND NOT X21 THEN
            reset_timer(IN := FALSE);
            state := 2;
        END_IF;
        
    2: (* WAIT_READY - wait for Ready signal *)
        Y21 := FALSE;
        Y20 := FALSE;
        IF X22 THEN
            state := 3;
        END_IF;
        
    3: (* REQUEST - raise Offer to request receiver acceptance *)
        Y21 := TRUE;
        Y20 := FALSE;
        IF X21 THEN
            state := 4;
        END_IF;
        
    4: (* RELEASE - open sender to hand off to receiver *)
        Y21 := TRUE;
        Y20 := TRUE;
        IF X20 AND X23 THEN
            state := 5;
            ack_reset_timer(IN := TRUE, PT := T#200ms);
        END_IF;
        
    5: (* ACK_RESET - turn Offer OFF to reset Ack *)
        Y21 := FALSE;
        Y20 := TRUE;
        ack_reset_timer(IN := TRUE, PT := T#200ms);
        IF ack_reset_timer.Q AND NOT X21 THEN
            state := 6;
            ack_reset_timer(IN := FALSE);
        END_IF;
        
    6: (* DONE - completion claimed and maintained *)
        Y21 := FALSE;
        Y20 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM