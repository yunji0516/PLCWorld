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
    state : INT := 0;
    start_edge : R_TRIG;
    vacuum_timer : TON;
    complete_stable : INT := 0;
END_VAR

start_edge(CLK := X0);

CASE state OF
    0: // IDLE - wait for start
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := TRUE;
        D200 := D0;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        IF start_edge.Q THEN
            state := 1;
        END_IF;

    1: // FEED_WAIT - wait for feed to reach D0 and stop
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := TRUE;
        D200 := D0;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        IF X11 THEN
            state := 2;
        END_IF;

    2: // STOCK_CLAMP - close stock clamp to hold supply side
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := TRUE;
        D200 := D0;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        state := 3;

    3: // STOCK_WAIT - wait for stock clamp closed
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := TRUE;
        D200 := D0;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        IF X14 THEN
            state := 4;
        END_IF;

    4: // BLADE_DOWN - lower blade to cut
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := TRUE;
        D200 := D0;
        Y13 := TRUE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        state := 5;

    5: // BLADE_WAIT - wait for blade at bottom (cut occurred at 97%)
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := TRUE;
        D200 := D0;
        Y13 := TRUE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        IF X16 THEN
            state := 6;
        END_IF;

    6: // BLADE_UP - raise blade
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := TRUE;
        D200 := D0;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        state := 7;

    7: // CUT_WAIT - wait for cut_complete (blade at top + separation)
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := TRUE;
        D200 := D0;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        IF X17 THEN
            state := 8;
        END_IF;

    8: // RELEASE_GRIP - open feed grip to release segment
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := TRUE;
        D200 := D0;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        state := 9;

    9: // GRIP_WAIT - wait for grip open
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := TRUE;
        D200 := D0;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        IF X13 THEN
            state := 10;
        END_IF;

    10: // FEED_RETURN - return feed carriage to home (100 mm)
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := TRUE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        state := 11;

    11: // FEED_RETURN_WAIT - wait for feed home
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := TRUE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        IF X10 THEN
            Y12 := FALSE;
            state := 12;
        END_IF;

    12: // PAD_DOWN - lower pad to cutting table contact height
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        state := 13;

    13: // PAD_DOWN_WAIT - wait for pad down
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        IF X19 THEN
            state := 14;
        END_IF;

    14: // VACUUM_ON - activate vacuum to grip segment
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := TRUE;
        Y17 := FALSE;
        vacuum_timer(IN := TRUE, PT := T#500ms);
        state := 15;

    15: // VACUUM_WAIT - wait for vacuum retention to form (0.25-0.50s)
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := TRUE;
        Y17 := FALSE;
        vacuum_timer(IN := TRUE, PT := T#500ms);
        IF vacuum_timer.Q THEN
            state := 16;
        END_IF;

    16: // PAD_UP - extract segment (safe now: cut done, blade up, grip open)
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := TRUE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        state := 17;

    17: // PAD_UP_WAIT - wait for pad up
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := TRUE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        IF X18 THEN
            state := 18;
        END_IF;

    18: // PAD_OUT - move pad to receiver position
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := TRUE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        state := 19;

    19: // PAD_OUT_WAIT - wait for pad at receiver
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := TRUE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        IF X1B THEN
            state := 20;
        END_IF;

    20: // PAD_DOWN_RECV - lower pad at receiving support
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := TRUE;
        Y16 := TRUE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        state := 21;

    21: // PAD_DOWN_RECV_WAIT - wait for pad down at receiver
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := TRUE;
        Y16 := TRUE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        IF X19 THEN
            state := 22;
        END_IF;

    22: // VACUUM_OFF - release segment from pad
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := TRUE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        state := 23;

    23: // VACUUM_RELEASE_WAIT - short wait for release
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := TRUE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := TRUE, PT := T#200ms);
        IF vacuum_timer.Q THEN
            state := 24;
        END_IF;

    24: // PAD_UP_RECV - raise pad after release
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        state := 25;

    25: // PAD_UP_RECV_WAIT - wait for pad up
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        IF X18 THEN
            state := 26;
        END_IF;

    26: // PAD_RETURN - return pad to start position
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        state := 27;

    27: // PAD_RETURN_WAIT - wait for pad at source
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);
        IF X1A THEN
            state := 28;
        END_IF;

    28: // CHECK_COMPLETE - verify all completion conditions
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        D200 := 100;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        vacuum_timer(IN := FALSE);

        IF (ABS(D3 - D0) <= 1) AND
           (D2 >= -302) AND
           X15 AND
           Y11 AND
           X10 AND
           NOT Y10 AND
           X18 AND
           X1A AND
           NOT Y16 THEN
            complete_stable := complete_stable + 1;
        ELSE
            complete_stable := 0;
        END_IF;

        IF complete_stable >= 51 THEN
            Y17 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM