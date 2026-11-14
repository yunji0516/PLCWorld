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

(* Capture the Start request edge *)
start_edge(CLK := X10);

(* Timer to guarantee Offer OFF continuously for > 1.5s to rearm the transaction *)
rearm_timer(IN := (state = 1), PT := T#1600ms);

CASE state OF
    0: (* Wait for Start *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            state := 1;
        END_IF;

    1: (* Rearm: Hold Offer OFF, Wait for Timer, Ready signal, and Ack reset *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF rearm_timer.Q AND X22 AND NOT X21 THEN
            state := 2;
        END_IF;

    2: (* Offer product to the receiver *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := FALSE;
        IF X21 THEN (* Wait for valid acknowledgement of the current transaction *)
            state := 3;
        END_IF;

    3: (* Release sender and lower Offer to reset Ack *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := FALSE;
        (* Wait until sender is physically released, receiver has ownership, and Ack has reset *)
        IF X20 AND X23 AND NOT X21 THEN
            state := 4;
        END_IF;

    4: (* Evaluation Endpoint / Result Maintenance *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM