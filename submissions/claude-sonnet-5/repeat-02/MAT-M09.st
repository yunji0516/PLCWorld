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
    resetTimer1 : TON;
    resetTimer2 : TON;
END_VAR

(* Detect start request edge every scan *)
startTrig(CLK := X10);

CASE state OF

0: (* IDLE: wait for accepted start request, no actuator commands yet *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF startTrig.Q AND (D10 = 1) THEN
        state := 1;
    END_IF;

1: (* Move sender forward to dock; grip stays closed (release OFF) *)
    Y20 := TRUE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF X21 THEN
        state := 2;
    END_IF;

2: (* Ensure Offer OFF long enough to reset any stale Ack and arm a fresh transaction *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    resetTimer1(IN := TRUE, PT := T#3500ms);
    IF resetTimer1.Q AND (NOT X23) THEN
        resetTimer1(IN := FALSE, PT := T#3500ms);
        state := 3;
    END_IF;

3: (* Docked, Offer asserted, wait for Ready *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := TRUE;
    IF X21 AND X24 THEN
        state := 4;
    END_IF;

4: (* Wait for freshly armed Ack -> physical clamping complete *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := TRUE;
    IF X23 THEN
        state := 5;
    END_IF;

5: (* Clamping complete: safe to open sender grip (release ON) *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := TRUE;
    IF X22 THEN
        state := 6;
    END_IF;

6: (* Wait for final receiver ownership feedback after sender release *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := TRUE;
    IF X25 THEN
        state := 7;
    END_IF;

7: (* Turn Offer OFF and wait for Ack to reset, per completion requirement *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := FALSE;
    resetTimer2(IN := TRUE, PT := T#3500ms);
    IF resetTimer2.Q AND (NOT X23) THEN
        resetTimer2(IN := FALSE, PT := T#3500ms);
        state := 8;
    END_IF;

8: (* Move sender back home; grip stays open (release ON) *)
    Y20 := FALSE;
    Y21 := TRUE;
    Y22 := TRUE;
    Y23 := FALSE;
    IF X20 THEN
        state := 9;
    END_IF;

9: (* Verify completion conditions and latch claim *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := FALSE;
    IF X20 AND X22 AND X25 AND (NOT Y23) AND (NOT X23) THEN
        Y2 := TRUE;
        state := 10;
    END_IF;

10: (* Terminal state: maintain claim and physical terminal result *)
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := FALSE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM