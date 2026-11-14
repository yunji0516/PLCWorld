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

    (* internal *)
    state : INT := 0;
    startTrig : R_TRIG;
    reqValue : INT := 0;
END_VAR

startTrig(CLK := X10);

CASE state OF

0: (* IDLE - wait for accepted start, no actuator commands *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF startTrig.Q THEN
        reqValue := D10;
        state := 1;
    END_IF;

1: (* RESET_ACK_INITIAL - ensure stale Ack is cleared before offering, keep Offer OFF *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF NOT X23 THEN
        state := 2;
    END_IF;

2: (* MOVE_FORWARD - travel toward receiver, sender holds item, receiver empty, safe to move *)
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y20 := TRUE;
    IF X21 THEN
        Y20 := FALSE;
        state := 3;
    END_IF;

3: (* WAIT_READY - docked, hold position, wait receiver ready *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF X24 THEN
        state := 4;
    END_IF;

4: (* OFFER_WAIT_ACK - docked + ready + reset interface armed -> assert Offer, wait Ack (clamping complete) *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := TRUE;
    IF X23 THEN
        state := 5;
    END_IF;

5: (* RELEASE_WAIT - clamping confirmed by Ack, now safe to open sender grip; wait released and ownership transferred *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y23 := TRUE;
    Y22 := TRUE;
    IF X22 AND X25 THEN
        state := 6;
    END_IF;

6: (* RESET_OFFER_WAIT - turn Offer OFF to reset Ack, wait for Ack reset confirmation *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := FALSE;
    IF NOT X23 THEN
        state := 7;
    END_IF;

7: (* MOVE_BACK - empty sender returns home, grip open, no material constrained *)
    Y22 := TRUE;
    Y23 := FALSE;
    Y20 := FALSE;
    Y21 := TRUE;
    IF X20 THEN
        Y21 := FALSE;
        state := 8;
    END_IF;

8: (* DONE - maintain terminal state: travel outputs OFF, release may remain ON, Offer OFF, Ack reset, ownership at receiver *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := FALSE;
    Y2 := TRUE;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    state := 0;

END_CASE;

END_PROGRAM