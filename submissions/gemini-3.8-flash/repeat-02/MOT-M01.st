PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D20 : DINT;
    Y20 : BOOL;
    D21 : DINT;
    Y21 : BOOL;
    D22 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    target_s : DINT := 0;
    target_u : DINT := 0;
    ton_raise : TON;
    ton_swap : TON;
    ton_lower : TON;
END_VAR

IF state = 0 THEN
    IF X10 THEN
        target_s := D10;
        target_u := D13;
        state := 1;
    ELSE
        D20 := D11;
        Y20 := FALSE;
        D21 := D14;
        Y21 := FALSE;
        D22 := D16;
        Y22 := FALSE;
        Y2 := FALSE;
    END_IF;
END_IF;

ton_raise(
    IN := (state = 1) AND (ABS(D16 - 45000) <= 20) AND (ABS(D17) <= 100),
    PT := T#40ms
);
IF (state = 1) AND ton_raise.Q THEN
    state := 2;
END_IF;

ton_swap(
    IN := (state = 2) AND
          (ABS(D11 - target_s) <= 20) AND (ABS(D12) <= 100) AND
          (ABS(D14 - target_u) <= 20) AND (ABS(D15) <= 100),
    PT := T#40ms
);
IF (state = 2) AND ton_swap.Q THEN
    state := 3;
END_IF;

ton_lower(
    IN := (state = 3) AND
          (ABS(D16) <= 20) AND (ABS(D17) <= 100) AND
          (ABS(D11 - target_s) <= 20) AND (ABS(D12) <= 100) AND
          (ABS(D14 - target_u) <= 20) AND (ABS(D15) <= 100),
    PT := T#40ms
);
IF (state = 3) AND ton_lower.Q THEN
    state := 4;
END_IF;

CASE state OF
    1:
        D20 := D11;
        Y20 := FALSE;
        D21 := D14;
        Y21 := FALSE;
        D22 := 45000;
        Y22 := TRUE;
        Y2 := FALSE;
    2:
        D20 := target_s;
        Y20 := TRUE;
        D21 := target_u;
        Y21 := TRUE;
        D22 := 45000;
        Y22 := TRUE;
        Y2 := FALSE;
    3:
        D20 := target_s;
        Y20 := TRUE;
        D21 := target_u;
        Y21 := TRUE;
        D22 := 0;
        Y22 := TRUE;
        Y2 := FALSE;
    4:
        D20 := target_s;
        Y20 := TRUE;
        D21 := target_u;
        Y21 := TRUE;
        D22 := 0;
        Y22 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM