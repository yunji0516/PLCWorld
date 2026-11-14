PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D90 : DINT;
    D101 : DINT;
    D102 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y31 : BOOL;
    Y2 : BOOL;

    start_edge : R_TRIG;
    latch_timer : TON;
    state : INT := 0;
END_VAR

CASE state OF
    0: (* WAIT_START *)
        start_edge(CLK := X0);
        latch_timer(IN := FALSE, PT := T#250ms);

        D20 := 0; D21 := 0; Y20 := FALSE;
        D24 := 0; D25 := 0; Y21 := FALSE;
        D28 := 0; D29 := 0; Y22 := FALSE;
        Y30 := FALSE; Y31 := FALSE; Y2 := FALSE;

        IF start_edge.Q THEN
            state := 1;
        END_IF;

    1: (* MOVE_A_B_TO_DOCK - align beams to requested dock *)
        start_edge(CLK := X0);
        latch_timer(IN := FALSE, PT := T#250ms);

        D20 := D101; D21 := 1000; Y20 := TRUE;
        D24 := D101; D25 := 1000; Y21 := TRUE;
        D28 := 0; D29 := 0; Y22 := FALSE;
        Y30 := FALSE; Y31 := FALSE; Y2 := FALSE;

        IF X4 THEN
            state := 2;
        END_IF;

    2: (* ENGAGE_LATCH - latch beam to dock *)
        start_edge(CLK := X0);
        latch_timer(IN := TRUE, PT := T#250ms);

        D20 := D101; D21 := 1000; Y20 := TRUE;
        D24 := D101; D25 := 1000; Y21 := TRUE;
        D28 := 0; D29 := 0; Y22 := FALSE;
        Y30 := TRUE; Y31 := FALSE; Y2 := FALSE;

        IF latch_timer.Q AND X2 THEN
            latch_timer(IN := FALSE, PT := T#250ms);
            state := 3;
        END_IF;

    3: (* MOVE_CART_TO_PARK - transfer cart to fixed rail *)
        start_edge(CLK := X0);
        latch_timer(IN := FALSE, PT := T#250ms);

        D20 := D101; D21 := 1000; Y20 := TRUE;
        D24 := D101; D25 := 1000; Y21 := TRUE;
        D28 := D102; D29 := 1000; Y22 := TRUE;
        Y30 := FALSE; Y31 := FALSE; Y2 := FALSE;

        IF ABS(D14 - D102) <= 20 AND ABS(D15) <= 100 THEN
            state := 4;
        END_IF;

    4: (* RELEASE_LATCH - disconnect beam from dock *)
        start_edge(CLK := X0);
        latch_timer(IN := TRUE, PT := T#250ms);

        D20 := D101; D21 := 1000; Y20 := TRUE;
        D24 := D101; D25 := 1000; Y21 := TRUE;
        D28 := D102; D29 := 0; Y22 := FALSE;
        Y30 := FALSE; Y31 := TRUE; Y2 := FALSE;

        IF latch_timer.Q AND X1 THEN
            latch_timer(IN := FALSE, PT := T#250ms);
            state := 5;
        END_IF;

    5: (* RETURN_BEAM_TO_ORIGIN - move A and B back to 0 *)
        start_edge(CLK := X0);
        latch_timer(IN := FALSE, PT := T#250ms);

        D20 := 0; D21 := 1000; Y20 := TRUE;
        D24 := 0; D25 := 1000; Y21 := TRUE;
        D28 := D102; D29 := 0; Y22 := FALSE;
        Y30 := FALSE; Y31 := FALSE; Y2 := FALSE;

        IF ABS(D10) <= 20 AND ABS(D11) <= 100 AND ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            state := 6;
        END_IF;

    6: (* COMPLETE - claim task done *)
        start_edge(CLK := X0);
        latch_timer(IN := FALSE, PT := T#250ms);

        Y2 := TRUE;
        D20 := 0; D21 := 0; Y20 := FALSE;
        D24 := 0; D25 := 0; Y21 := FALSE;
        D28 := 0; D29 := 0; Y22 := FALSE;
        Y30 := FALSE; Y31 := FALSE;

    ELSE
        state := 0;
END_CASE;

END_PROGRAM