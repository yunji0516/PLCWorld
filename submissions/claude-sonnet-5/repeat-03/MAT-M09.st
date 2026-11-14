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

    step : INT := 0;
    startReq : R_TRIG;
    armTimer : TON;
END_VAR

startReq(CLK := X10);

CASE step OF

0: (* Wait for start request; no actuator command before acceptance *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2  := FALSE;
    IF startReq.Q THEN
        step := 1;
    END_IF;

1: (* Move sender forward toward receiver until docked *)
    Y20 := TRUE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2  := FALSE;
    IF X21 THEN
        step := 2;
    END_IF;

2: (* Docked: keep Offer OFF long enough to reset any stale Ack and arm a fresh
      transaction; also wait for Ready before offering *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2  := FALSE;
    armTimer(IN := TRUE, PT := T#3500MS);
    IF armTimer.Q AND (NOT X23) AND X24 THEN
        step := 3;
    END_IF;

3: (* Assert Offer on the docked, ready, freshly-armed transaction; wait for
      receiver to physically finish clamping (Ack rises) *)
    armTimer(IN := FALSE, PT := T#3500MS);
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := TRUE;
    Y2  := FALSE;
    IF X23 THEN
        step := 4;
    END_IF;

4: (* Clamping confirmed by Ack: safe to release sender grip; wait for released
      feedback and final ownership transfer *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := TRUE;
    Y2  := FALSE;
    IF X22 AND X25 THEN
        step := 5;
    END_IF;

5: (* Sender empty and open: safe to travel back to source/home *)
    Y20 := FALSE;
    Y21 := TRUE;
    Y22 := TRUE;
    Y23 := TRUE;
    Y2  := FALSE;
    IF X20 THEN
        step := 6;
    END_IF;

6: (* Turn Offer OFF and wait for Ack to reset *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := FALSE;
    Y2  := FALSE;
    IF NOT X23 THEN
        step := 7;
    END_IF;

7: (* Terminal: claim completion and maintain result for remainder of run *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := FALSE;
    Y2  := TRUE;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2  := FALSE;
    step := 0;

END_CASE;

END_PROGRAM