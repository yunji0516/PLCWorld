```iecst
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
    dock_pos : DINT := 40000;
    park_pos : DINT := 80000;
    cmd_a : DINT := 0;
    cmd_b : DINT := 0;

    align_ton : TON;
    latch_ton : TON;
    park_ton : TON;
    release_ton : TON;
    origin_ton : TON;
END_VAR

IF D101 > 0 THEN
    dock_pos := D101;
END_IF;

IF D102 > 0 THEN
    park_pos := D102;
END_IF;

align_ton(
    IN := (state = 10) AND X4 AND (ABS(D10 - dock_pos) <= 20) AND (ABS(D12 - dock_pos) <= 20) AND (ABS(D11) <= 100) AND (ABS(D13) <= 100),
    PT := T#100ms
);

latch_ton(
    IN := (state = 20) AND X2 AND (NOT X3),
    PT := T#300ms
);

park_ton(
    IN := (state = 30) AND X5 AND (ABS(D14 - park_pos) <= 20) AND (ABS(D15) <= 100),
    PT := T#100ms
);

release_ton(
    IN := (state = 40) AND X1 AND (NOT X2),
    PT := T#300ms
);

origin_ton(
    IN := (state = 50) AND (ABS(D10) <= 20) AND (ABS(D12) <= 20) AND (ABS(D11) <= 100) AND (ABS(D13) <= 100),
    PT := T#100ms
);

CASE state OF
    0:
        IF X0 THEN
            state := 10;
        END_IF;

    10:
        IF align_ton.Q THEN
            state := 20;
        END_IF;

    20:
        IF latch_ton.Q THEN
            state := 30;
        END_IF;

    30:
        IF park_ton.Q THEN
            state := 40;
        END_IF;

    40:
        IF release_ton.Q THEN
            state := 50;
        END_IF;

    50:
        IF origin_ton.Q THEN
            state := 60;
        END_IF;

    60:
        ;
END_CASE;

CASE state OF
    0:
        Y20 := FALSE;
        D20 := 0;
        D21 := 0;
        Y21 := FALSE;
        D24 := 0;
        D25 := 0;
        Y22 := FALSE;
        D28 := 10000;
        D29 := 0;
        Y30 := FALSE;
        Y31 := FALSE;
        Y2 := FALSE;

    10:
        cmd_a := D12 + 400;
        cmd_b := D10 + 400;
        D20 := LIMIT(0, cmd_a, dock_pos);
        D24 := LIMIT(0, cmd_b, dock_pos);
        D21 := 1000;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 0;
        Y22 := FALSE;
        Y30 := FALSE;
        Y31 := FALSE;
        Y2 := FALSE;

    20:
        D20 := dock_pos;
        D24 := dock_pos;
        D21 := 1000;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 0;
        Y22 := FALSE;
        Y30 := TRUE;
        Y31 := FALSE;
        Y2 := FALSE;

    30:
        D20 := dock_pos;
        D24