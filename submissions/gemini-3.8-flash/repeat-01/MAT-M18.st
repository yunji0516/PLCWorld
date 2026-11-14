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

    step : INT := 0;
    ton_wait : TON;
    wait_time : TIME;
    wait_start : BOOL;
    start_trig : R_TRIG;
    req_len : INT;
END_VAR

start_trig(CLK := X0);

wait_start := FALSE;

CASE step OF
    0:
        (* Initial state: feed_grip holding, waiting for start *)
        Y10 := TRUE;  (* feed_grip holding leading edge initially *)
        Y11 := FALSE; (* stock_clamp open *)
        Y12 := FALSE; (* feed_move OFF *)
        Y13 := FALSE; (* blade up *)
        Y14 := FALSE; (* pad up *)
        Y15 := FALSE; (* pad at start *)
        Y16 := FALSE; (* vacuum OFF *)
        Y17 := FALSE; (* complete OFF *)
        D200 := 100;

        IF start_trig.Q THEN
            req_len := D0;
            D200 := req_len;
            step := 10;
        END_IF;

    10:
        (* Ensure feed grip is gripped and stock clamp is open before moving *)
        Y10 := TRUE;
        Y11 := FALSE;
        D200 := req_len;
        IF X12 AND (NOT X14) THEN
            Y12 := TRUE; (* feed_move ON *)
            step := 20;
        END_IF;

    20:
        (* Feeding tape to target length *)
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := TRUE;
        D200 := req_len;
        (* Check if carriage reached target and stopped *)
        IF (D1 >= req_len - 1) AND (D1 <= req_len + 1) AND X11 THEN
            Y12 := FALSE;
            step := 30;
        END_IF;

    30:
        (* Clamp stock before cutting so raw material does not retract *)
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        IF X14 THEN
            step := 40;
        END_IF;

    40:
        (* Descend blade to cut *)
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := TRUE; (* blade_down ON *)
        IF X16 THEN
            step := 50;
        END_IF;

    50:
        (* Ascend blade *)
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE; (* blade_down OFF *)
        IF X15 AND X17 THEN
            step := 60;
        END_IF;

    60:
        (* Descend pad at source to contact tape *)
        (* Blade is up, carriage is stopped *)
        Y10 := TRUE;
        Y11 := TRUE;
        Y14 := TRUE; (* pad_down ON *)
        IF X19 AND X1A THEN
            step := 70;
        END_IF;

    70:
        (* Turn on vacuum to acquire segment *)
        Y10 := TRUE;
        Y11 := TRUE;
        Y14 := TRUE;
        Y16 := TRUE; (* vacuum ON *)
        IF X1C THEN
            step := 80;
        END_IF;

    80:
        (* Release feed grip so segment is freed and carriage can return *)
        Y10 := FALSE; (* feed_grip OFF *)
        Y11 := TRUE;
        Y14 := TRUE;
        Y16 := TRUE;
        IF X13 THEN
            step := 90;
        END_IF;

    90:
        (* Lift pad to top before horizontal transfer *)
        Y10 := FALSE;
        Y11 := TRUE;
        Y14 := FALSE; (* pad_down OFF -> pad moves up *)
        Y16 := TRUE;
        IF X18 THEN
            step := 100;
        END_IF;

    100:
        (* Move pad horizontally to receiver *)
        (* Also command feed carriage to return to origin 100 mm *)
        Y10 := FALSE;
        Y11 := TRUE;
        Y14 := FALSE;
        Y15 := TRUE; (* pad_out ON *)
        Y16 := TRUE;

        D200 := 100;
        Y12 := TRUE; (* feed_move return *)

        IF X1B AND X18 THEN
            step := 110;
        END_IF;

    110:
        (* Pad is at receiver, descend pad to contact surface *)
        Y10 := FALSE;
        Y11 := TRUE;
        Y14 := TRUE; (* pad_down ON *)
        Y15 := TRUE;
        Y16 := TRUE;

        (* Keep returning feed carriage if not yet home *)
        IF X10 AND X11 THEN
            Y12 := FALSE;
        ELSE
            D200 := 100;
            Y12 := TRUE;
        END_IF;

        IF X19 AND X1B THEN
            step := 120;
        END_IF;

    120:
        (* Release vacuum to place segment on receiving support *)
        Y10 := FALSE;
        Y11 := TRUE;
        Y14 := TRUE;
        Y15 := TRUE;
        Y16 := FALSE; (* vacuum OFF *)

        IF X10 AND X11 THEN
            Y12 := FALSE;
        ELSE
            D200 := 100;
            Y12 := TRUE;
        END_IF;

        (* Wait for vacuum release and segment to settle / received_present *)
        IF (NOT X1C) AND X1D THEN
            step := 130;
        END_IF;

    130:
        (* Lift empty pad to top *)
        Y10 := FALSE;
        Y11 := TRUE;
        Y14 := FALSE; (* pad_down OFF *)
        Y15 := TRUE;
        Y16 := FALSE;

        IF X10 AND X11 THEN
            Y12 := FALSE;
        ELSE
            D200 := 100;
            Y12 := TRUE;
        END_IF;

        IF X18 THEN
            step := 140;
        END_IF;

    140:
        (* Move empty pad horizontally back to start *)
        Y10 := FALSE;
        Y11 := TRUE;
        Y14 := FALSE;
        Y15 := FALSE; (* pad_out OFF -> moves to start *)
        Y16 := FALSE;

        IF X10 AND X11 THEN
            Y12 := FALSE;
        ELSE
            D200 := 100;
            Y12 := TRUE;
        END_IF;

        IF X1A AND X18 THEN
            step := 150;
        END_IF;

    150:
        (* Ensure feed carriage is home and stopped *)
        Y10 := FALSE;
        Y11 := TRUE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;

        IF X10 AND X11 THEN
            Y12 := FALSE;
            step := 160;
        ELSE
            D200 := 100;
            Y12 := TRUE;
        END_IF;

    160:
        (* Final state: completion requirements:
           - remaining leading edge fixation (stock_clamp ON)
           - cutter at top (blade_up = X15)
           - open feed grip at origin (grip_open = X13, feed_home = X10, feed_stopped = X11)
           - empty pickup at top/start (pad_up = X18, pad_source = X1A, pad_held = FALSE)
           - vacuum release (vacuum = OFF)
           - received length error within +/- 1 mm
        *)
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        D200 := 100;

        IF X15 AND X18 AND X1A AND (NOT X1C) AND X10 AND X11 AND X13 AND X14 AND X1D THEN
            Y17 := TRUE; (* complete *)
        END_IF;

END_CASE;

ton_wait(IN := wait_start, PT := wait_time);

END_PROGRAM