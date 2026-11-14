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

    (* internal state *)
    state : INT := 0;
    startTrig : R_TRIG;
    ackTrig : R_TRIG;
    rearmTimer : TON;
END_VAR

startTrig(CLK := X10);
ackTrig(CLK := X21);

CASE state OF

0: (* IDLE: wait for Start rising edge, do not initiate before it *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF startTrig.Q THEN
        state := 1;
    END_IF;

1: (* Rearm current transaction: hold Offer OFF for 0.12-1.5 s to lower any stale Ack *)
    Y21 := FALSE;
    Y20 := FALSE;
    rearmTimer(IN := TRUE, PT := T#200ms);
    IF rearmTimer.Q THEN
        rearmTimer(IN := FALSE, PT := T#200ms);
        state := 2;
    END_IF;

2: (* Wait for Ready before turning Offer ON *)
    Y21 := FALSE;
    Y20 := FALSE;
    IF X22 THEN
        Y21 := TRUE;
        state := 3;
    END_IF;

3: (* Rearmed + Ready + Offer true : wait for valid Ack of current transaction *)
    Y21 := TRUE;
    Y20 := FALSE;
    IF ackTrig.Q THEN
        state := 4;
    END_IF;

4: (* Valid acceptance obtained: release the sender *)
    Y20 := TRUE;
    IF X20 THEN
        state := 5;
    END_IF;

5: (* Wait for receiver to take physical ownership *)
    IF X23 THEN
        state := 6;
    END_IF;

6: (* Turn Offer OFF continuously to reset Ack per handoff completion *)
    Y21 := FALSE;
    IF NOT X21 THEN
        state := 7;
    END_IF;

7: (* Completion: received, released, Offer OFF, Ack reset - hold result *)
    Y21 := FALSE;
    Y20 := TRUE;
    Y2 := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM