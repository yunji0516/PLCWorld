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
    completion_count : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X0);

CASE step OF
    0: (* Wait for start command *)
        IF start_edge.Q THEN
            step := 1;
            D200 := D0;
            Y12 := TRUE;   (* feed_move ON *)
            Y10 := TRUE;   (* feed_grip closed *)
            Y11 := FALSE;  (* stock_clamp open *)
        END_IF;

    1: (* Feed to target position, wait for stop *)
        IF X11 THEN
            Y12 := FALSE;
            step := 2;
            Y11 := TRUE;   (* close stock clamp *)
        END_IF;

    2: (* Wait for stock clamped, then start cut *)
        IF X14 THEN
            step := 3;
            Y13 := TRUE;   (* blade down *)
        END_IF;

    3: (* Wait for blade fully down, then raise blade *)
        IF X16 THEN
            step := 4;
            Y13 := FALSE;  (* blade ascend *)
        END_IF;

    4: (* Wait for cut complete (blade at top, separation established) *)
        IF X17 THEN
            step := 5;
            Y10 := FALSE;  (* release feed grip *)
        END_IF;

    5: (* Wait for feed grip open, then lower pad *)
        IF X13 THEN
            step := 6;
            Y14 := TRUE;   (* pad down *)
        END_IF;

    6: (* Wait for pad at contact, engage vacuum *)
        IF X19 THEN
            step := 7;
            Y16 := TRUE;   (* vacuum ON *)
        END_IF;

    7: (* Wait for vacuum retention formed *)
        IF X1C THEN
            step := 8;
            Y14 := FALSE;  (* pad up *)
        END_IF;

    8: (* Wait for pad at top, move to receiver *)
        IF X18 THEN
            step := 9;
            Y15 := TRUE;   (* pad out to receiver *)
        END_IF;

    9: (* Wait for pad at receiver, lower to release height *)
        IF X1B THEN
            step := 10;
            Y14 := TRUE;   (* pad down at receiver *)
        END_IF;

    10: (* Wait for pad down at receiver, release vacuum *)
        IF X19 THEN
            step := 11;
            Y16 := FALSE;  (* vacuum OFF - release segment *)
        END_IF;

    11: (* Wait for segment received on support *)
        IF D3 >= D0 - 1 AND D3 <= D0 + 1 THEN
            step := 12;
            Y14 := FALSE;  (* pad up empty *)
        END_IF;

    12: (* Wait for pad up, return pad to source *)
        IF X18 THEN
            step := 13;
            Y15 := FALSE;  (* pad in *)
        END_IF;

    13: (* Wait for pad at source, return feed to origin *)
        IF X1A THEN
            step := 14;
            D200 := 100;
            Y12 := TRUE;   (* feed_move to origin *)
        END_IF;

    14: (* Wait for feed stopped at home position *)
        IF X11 AND X10 THEN
            Y12 := FALSE;
            step := 15;
        END_IF;

    15: (* Completion verification *)
        IF X14 AND X15 AND X10 AND X13 AND X18 AND X1A AND X1D AND
           D3 >= D0 - 1 AND D3 <= D0 + 1 AND
           NOT Y10 AND NOT Y13 AND NOT Y14 AND NOT Y15 AND NOT Y16 THEN
            Y17 := TRUE;
            IF completion_count < 51 THEN
                completion_count := completion_count + 1;
            END_IF;
        ELSE
            Y17 := FALSE;
            completion_count := 0;
        END_IF;

ELSE
    step := 0;
END_CASE;

END_PROGRAM