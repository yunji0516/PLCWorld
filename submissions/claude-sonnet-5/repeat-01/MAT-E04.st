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

    (* internal variables *)
    state       : INT := 0;
    startTrig   : R_TRIG;
    rearmTimer  : TON;
END_VAR

startTrig(CLK := X10);

CASE state OF

0: (* IDLE - wait for a Start rising edge, all outputs off *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2  := FALSE;
    IF startTrig.Q THEN
        state := 1;
    END_IF;

1: (* REARM: hold Offer OFF continuously for a duration inside 0.12-1.5s
      to clear any stale Ack and rearm the current transaction *)
    Y21 := FALSE;
    rearmTimer(IN := TRUE, PT := T#300ms);
    IF rearmTimer.Q THEN
        rearmTimer(IN := FALSE, PT := T#300ms); (* reset for reuse safety *)
        state := 2;
    END_IF;

2: (* WAIT READY: keep Offer off until receiver reports ready *)
    Y21 := FALSE;
    IF X22 THEN
        Y21   := TRUE;   (* assert Offer with Ready true -> registers new transaction *)
        state := 3;
    END_IF;

3: (* OFFERED: wait for fresh Ack corresponding to this transaction *)
    Y21 := TRUE;
    IF X21 THEN
        state := 4;
    END_IF;

4: (* Valid current-transaction acceptance obtained: command release *)
    Y20   := TRUE;
    state := 5;

5: (* WAIT RELEASED: wait for sender to actually open *)
    IF X20 THEN
        state := 6;
    END_IF;

6: (* WAIT RECEIVED: wait for receiver to actually take ownership *)
    IF X23 THEN
        state := 7;
    END_IF;

7: (* Turn Offer off to let Ack settle back down, then finalize *)
    Y21 := FALSE;
    IF NOT X21 THEN
        state := 8;
    END_IF;

8: (* DONE: claim completion and hold the completed handoff state *)
    Y2  := TRUE;
    Y20 := TRUE;
    Y21 := FALSE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM