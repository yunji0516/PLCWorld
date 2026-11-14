PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D200 : INT;

    (* internal *)
    step : INT := 0;
    startTrig : R_TRIG;
END_VAR

startTrig(CLK := X0);

CASE step OF

0: (* IDLE - hold initial physical configuration *)
    Y10 := TRUE;   (* feed grip closed, holding leading edge *)
    Y11 := FALSE;  (* stopper open *)
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    IF startTrig.Q THEN
        D200 := D0;
        step := 1;
    END_IF;

1: (* FEED_EXTEND: move carriage to set protrusion = requested length *)
    Y11 := FALSE; (* stopper must stay open during connected movement *)
    IF X12 AND NOT X14 THEN
        Y12 := TRUE;
    ELSE
        Y12 := FALSE;
    END_IF;
    IF X11 AND (ABS(D1 - D0) <= 0) THEN
        Y12 := FALSE;
        step := 2;
    END_IF;

2: (* CLAMP stopper to secure raw material side before cutting *)
    Y12 := FALSE;
    Y11 := TRUE;
    IF X14 THEN
        step := 3;
    END_IF;

3: (* CUT_DOWN: blade descends, feed must not move *)
    Y12 := FALSE;
    Y13 := TRUE;
    IF X16 THEN
        step := 4;
    END_IF;

4: (* CUT_UP: retract blade, wait for full retract + valid separation *)
    Y13 := FALSE;
    IF X15 AND X17 THEN
        step := 5;
    END_IF;

5: (* OPEN_GRIP: required before carriage return after separation *)
    Y10 := FALSE;
    IF X13 THEN
        step := 6;
    END_IF;

6: (* RETRACT_CARRIAGE to origin, grip must be open to move *)
    D200 := 100;
    IF X13 THEN
        Y12 := TRUE;
    ELSE
        Y12 := FALSE;
    END_IF;
    IF X10 THEN
        Y12 := FALSE;
        step := 7;
    END_IF;

7: (* PAD_DOWN at source to contact the segment on the cutting table *)
    Y15 := FALSE;
    Y14 := TRUE;
    IF X19 AND X1A THEN
        step := 8;
    END_IF;

8: (* VACUUM_ON: hold still until actual retention is confirmed *)
    Y16 := TRUE;
    IF X1C THEN
        step := 9;
    END_IF;

9: (* PAD_UP with segment: horizontal move only performed at actual top *)
    Y14 := FALSE;
    IF X18 THEN
        step := 10;
    END_IF;

10: (* PAD_OUT to receiver - segment already cut, blade up, grip open *)
    Y15 := TRUE;
    IF X18 AND X1B THEN
        step := 11;
    END_IF;

11: (* PAD_DOWN at receiver contact height *)
    Y14 := TRUE;
    IF X19 THEN
        step := 12;
    END_IF;

12: (* VACUUM_RELEASE only while at receiver contact height *)
    Y16 := FALSE;
    IF NOT X1C THEN
        step := 13;
    END_IF;

13: (* PAD_UP empty *)
    Y14 := FALSE;
    IF X18 THEN
        step := 14;
    END_IF;

14: (* PAD_RETURN to start, empty *)
    Y15 := FALSE;
    IF X1A THEN
        step := 15;
    END_IF;

15: (* COMPLETE_CHECK and hold *)
    IF (ABS(D3 - D0) <= 1) AND X15 AND X13 AND X10 AND X18 AND X1A AND (NOT Y16) THEN
        Y17 := TRUE;
    END_IF;
    (* maintain all outputs steady for post-claim stability *)

ELSE
    step := 0;

END_CASE;

END_PROGRAM