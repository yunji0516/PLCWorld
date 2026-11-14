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
    startEdge : R_TRIG;
    state : INT := 0;
END_VAR

startEdge(CLK := X10);

CASE state OF
    0: (* IDLE: Wait for Start request *)
        Y21 := FALSE;
        Y20 := FALSE;
        Y2 := FALSE;
        IF startEdge.Q THEN
            state := 1;
        END_IF;
    1: (* CLEAR_ACK: Lower stale Ack by turning Offer OFF *)
        Y21 := FALSE;
        Y20 := FALSE;
        Y2 := FALSE;
        IF NOT X21 THEN
            state := 2;
        END_IF;
    2: (* WAIT_READY: Wait for Ready signal *)
        Y21 := FALSE;
        Y20 := FALSE;
        Y2 := FALSE;
        IF X22 THEN
            state := 3;
        END_IF;
    3: (* OFFER: Apply Offer to trigger new transaction Ack *)
        Y21 := TRUE;
        Y20 := FALSE;
        Y2 := FALSE;
        IF X21 THEN
            state := 4;
        END_IF;
    4: (* RELEASE: Open sender *)
        Y21 := TRUE;
        Y20 := TRUE;
        Y2 := FALSE;
        IF X20 THEN
            state := 5;
        END_IF;
    5: (* RECEIVED: Wait for receiver ownership confirmation *)
        Y21 := TRUE;
        Y20 := TRUE;
        Y2 := FALSE;
        IF X23 THEN
            state := 6;
        END_IF;
    6: (* COMPLETE: Claim completion, reset Offer/Ack, hold result *)
        Y2 := TRUE;
        Y21 := FALSE;
        Y20 := FALSE;
END_CASE;

END_PROGRAM