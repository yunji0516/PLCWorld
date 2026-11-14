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

    state : INT := 0;
    beam_pos_cmd : DINT := 0;
    diff : DINT := 0;
    t_dock_settle : TON;
    t_latch : TON;
    t_cart_settle : TON;
    t_release : TON;
    t_origin_settle : TON;
END_VAR

CASE state OF
    0: (* Wait for start *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y31 := FALSE;
        Y2 := FALSE;
        D20 := 0;
        D21 := 0;
        D24 := 0;
        D25 := 0;
        D28 := 10000;
        D29 := 0;
        IF X0 THEN
            beam_pos_cmd := 0;
            state := 10;
        END_IF;

    10: (* Move beam to dock *)
        Y20 := TRUE;
        Y21 := TRUE;
        D21 := 1000;
        D25 := 1000;
        Y22 := FALSE;
        Y30 := FALSE;
        Y31 := FALSE;
        Y2 := FALSE;

        (* Advance synchronized profile *)
        IF beam_pos_cmd < D101 THEN
            IF MIN(D10, D12) >= (beam_pos_cmd - 200) THEN
                beam_pos_cmd := MIN(D101, beam_pos_cmd + 100);
            END_IF;
        END_IF;

        (* Cross-coupling compensation *)
        diff := D10 - D12;
        IF beam_pos_cmd < D101 THEN
            D20 := LIMIT(0, 50000, beam_pos_cmd - diff / 2);
            D24 := LIMIT(0, 50000, beam_pos_cmd + diff / 2);
        ELSE
            D20 := D101;
            D24 := D101;
        END_IF;

        (* Arrival check *)
        IF (beam_pos_cmd = D101) AND (ABS(D10 - D101) <= 20) AND (ABS(D12 - D101) <= 20)
           AND (ABS(D11) <= 100) AND (ABS(D13) <= 100) AND X4 THEN
            t_dock_settle(IN := TRUE, PT := T#50ms);
            IF t_dock_settle.Q THEN
                t_dock_settle(IN := FALSE, PT := T#50ms);
                state := 20;
            END_IF;
        ELSE
            t_dock_settle(IN := FALSE, PT := T#50ms);
        END_IF;

    20: (* Engage latch *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y30 := TRUE;
        Y31 := FALSE;
        Y2 := FALSE;

        t_latch(IN := (X2 AND NOT X3), PT := T#100ms);
        IF t_latch.Q THEN
            t_latch(IN := FALSE, PT := T#100ms);
            state := 30;
        END_IF;

    30: (* Transfer cart to park position *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y30 := TRUE;
        Y31 := FALSE;
        Y2 := FALSE;
        Y22 := TRUE;
        D28 := D102;
        D29 := 1000;

        IF (ABS(D14 - D102) <= 20) AND (ABS(D15) <= 100) AND X5 THEN
            t_cart_settle(IN := TRUE, PT := T#100ms);
            IF t_cart_settle.Q THEN
                t_cart_settle(IN := FALSE, PT := T#100ms);
                state := 40;
            END_IF;
        ELSE
            t_cart_settle(IN := FALSE, PT := T#100ms);
        END_IF;

    40: (* Disconnect latch *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y30 := FALSE;
        Y31 := TRUE;
        Y2 := FALSE;
        Y22 := TRUE;
        D28 := D102;
        D29 := 1000;

        t_release(IN := (X1 AND NOT X2), PT := T#100ms);
        IF t_release.Q THEN
            t_release(IN := FALSE, PT := T#100ms);
            beam_pos_cmd := D101;
            state := 50;
        END_IF;

    50: (* Return empty beam to origin *)
        Y30 := FALSE;
        Y31 := FALSE;
        Y2 := FALSE;
        Y22 := TRUE;
        D28 := D102;
        D29 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        D21 := 1000;
        D25 := 1000;

        (* Advance synchronized profile toward 0 *)
        IF beam_pos_cmd > 0 THEN
            IF MAX(D10, D12) <= (beam_pos_cmd + 200) THEN
                IF beam_pos_cmd >= 100 THEN
                    beam_pos_cmd := beam_pos_cmd - 100;
                ELSE
                    beam_pos_cmd := 0;
                END_IF;
            END_IF;
        END_IF;

        (* Cross-coupling compensation *)
        diff := D10 - D12;
        IF beam_pos_cmd > 0 THEN
            D20 := LIMIT(0, 50000, beam_pos_cmd - diff / 2);
            D24 := LIMIT(0, 50000, beam_pos_cmd + diff / 2);
        ELSE
            D20 := 0;
            D24 := 0;
        END_IF;

        (* Arrival check at origin *)
        IF (beam_pos_cmd = 0) AND (ABS(D10) <= 20) AND (ABS(D12) <= 20)
           AND (ABS(D11) <= 100) AND (ABS(D13) <= 100) THEN
            t_origin_settle(IN := TRUE, PT := T#50ms);
            IF t_origin_settle.Q THEN
                t_origin_settle(IN := FALSE, PT := T#50ms);
                state := 60;
            END_IF;
        ELSE
            t_origin_settle(IN := FALSE, PT := T#50ms);
        END_IF;

    60: (* Completion hold *)
        Y2 := TRUE;
        Y30 := FALSE;
        Y31 := FALSE;
        Y22 := TRUE;
        D28 := D102;
        D29 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 0;
        D24 := 0;
        D21 := 1000;
        D25 := 1000;
END_CASE;

END_PROGRAM