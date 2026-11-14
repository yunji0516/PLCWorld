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
    
    start_edge : R_TRIG;
    state : INT := 0;
END_VAR

CASE state OF
    0: (* IDLE: Wait for X10 rising edge; all outputs OFF *)
        start_edge(CLK := X10);
        IF start_edge.Q THEN
            state := 1;
        END_IF;
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;

    1: (* RESET_ACK: Ensure Offer OFF; wait for any stale Ack to reset *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF NOT X23 THEN
            state := 2;
        END_IF;

    2: (* WAIT_READY: Wait for receiver Ready signal *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X24 THEN
            state := 3;
        END_IF;

    3: (* MOVE_FWD: Advance sender forward until docked *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X21 THEN
            state := 4;
        END_IF;

    4: (* OFFER_ASSERT: Assert Offer; wait for receiver Ack (clamping complete) *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X23 THEN
            state := 5;
        END_IF;

    5: (* RELEASE: Open sender grip after receiver has clamped *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := TRUE;
        IF X25 THEN
            state := 6;
        END_IF;

    6: (* RESET_OFFER: Deassert Offer; wait for Ack to reset *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF NOT X23 THEN
            state := 7;
        END_IF;

    7: (* MOVE_BACK: Return sender to home position *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF X20 THEN
            state := 8;
        END_IF;

    8: (* COMPLETE: Item at receiver, sender empty at home, grip open, offer reset *)
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
END_CASE;

END_PROGRAM