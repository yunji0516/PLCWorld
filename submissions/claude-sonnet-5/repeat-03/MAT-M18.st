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

    (* Internal state *)
    state       : INT := 0;
    target_len  : INT := 0;
    origin_pos  : INT := 100;
    start_trig  : R_TRIG;
END_VAR

start_trig(CLK := X0);

CASE state OF

0: (* IDLE - preserve initial physical state, wait for start *)
    Y10 := TRUE;      (* feed grip closed, holding leading edge *)
    Y11 := FALSE;     (* stopper open *)
    Y12 := FALSE;
    Y13 := FALSE;     (* blade up *)
    Y14 := FALSE;     (* pad up *)
    Y15 := FALSE;     (* pad at start *)
    Y16 := FALSE;     (* vacuum off *)
    Y17 := FALSE;
    D200 := origin_pos;
    IF start_trig.Q THEN
        target_len := D0;
        D200 := target_len;
        state := 1;
    END_IF;

1: (* FEED_TO_LENGTH *)
    Y10 := TRUE;
    D200 := target_len;
    IF X12 AND (NOT X14) THEN
        Y12 := TRUE;
    ELSE
        Y12 := FALSE;
    END_IF;
    IF X11 AND (D1 = target_len) THEN
        Y12 := FALSE;
        state := 2;
    END_IF;

2: (* CLAMP_STOCK *)
    Y12 := FALSE;
    Y11 := TRUE;
    IF X14 THEN
        state := 3;
    END_IF;

3: (* CUT_DESCEND *)
    Y12 := FALSE;
    Y13 := TRUE;
    IF X16 THEN
        state := 4;
    END_IF;

4: (* CUT_ASCEND *)
    Y12 := FALSE;
    Y13 := FALSE;
    IF X15 AND X17 THEN
        state := 5;
    END_IF;

5: (* RELEASE_GRIP - open feed grip before carriage return / extraction *)
    Y12 := FALSE;
    Y13 := FALSE;
    Y10 := FALSE;
    IF X13 THEN
        state := 6;
    END_IF;

6: (* CARRIAGE_RETURN to origin *)
    D200 := origin_pos;
    Y12 := TRUE;
    IF X10 AND X11 AND (D1 = origin_pos) THEN
        Y12 := FALSE;
        state := 7;
    END_IF;

7: (* PAD_DOWN_SOURCE *)
    Y12 := FALSE;
    Y15 := FALSE;
    Y14 := TRUE;
    IF X19 AND X1A THEN
        state := 8;
    END_IF;

8: (* VACUUM_ON_WAIT - stationary while retention forms *)
    Y14 := TRUE;
    Y16 := TRUE;
    IF X1C THEN
        state := 9;
    END_IF;

9: (* PAD_UP_AFTER_PICK *)
    Y16 := TRUE;
    Y14 := FALSE;
    IF X18 THEN
        state := 10;
    END_IF;

10: (* PAD_MOVE_TO_RECEIVER - horizontal motion at top *)
    Y14 := FALSE;
    Y16 := TRUE;
    Y15 := TRUE;
    IF X1B THEN
        state := 11;
    END_IF;

11: (* PAD_DOWN_RECEIVER *)
    Y16 := TRUE;
    Y14 := TRUE;
    IF X19 AND X1D THEN
        state := 12;
    END_IF;

12: (* RELEASE_VACUUM *)
    Y14 := TRUE;
    Y16 := FALSE;
    IF NOT X1C THEN
        state := 13;
    END_IF;

13: (* PAD_RAISE_AFTER_RELEASE *)
    Y16 := FALSE;
    Y14 := FALSE;
    IF X18 THEN
        state := 14;
    END_IF;

14: (* PAD_RETRACT to start *)
    Y16 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    IF X1A THEN
        state := 15;
    END_IF;

15: (* CHECK_AND_COMPLETE *)
    Y10 := FALSE;
    Y11 := TRUE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    D200 := origin_pos;
    IF ABS(D3 - target_len) <= 1 THEN
        state := 16;
    END_IF;

16: (* DONE - maintain final state, actuators off except completion *)
    Y10 := FALSE;
    Y11 := TRUE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := TRUE;
    D200 := origin_pos;

ELSE
    state := 0;

END_CASE;

END_PROGRAM