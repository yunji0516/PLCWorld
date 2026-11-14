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
    step : INT := 0;
    target_s : DINT;
    target_u : DINT;
    timer_compl : TON;
END_VAR

timer_compl(IN := step = 4, PT := T#100ms);

CASE step OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        IF X10 THEN
            target_s := D10;
            target_u := D13;
            step := 1;
        END_IF;
    1:
        D22 := 40000;
        Y22 := TRUE;
        IF (D16 >= 39980) AND (ABS(D17) <= 100) THEN
            step := 2;
        END_IF;
    2:
        D20 := target_s;
        Y20 := TRUE;
        D21 := target_u;
        Y21 := TRUE;
        D22 := 40000;
        Y22 := TRUE;
        IF (ABS(D11 - target_s) <= 20) AND (ABS(D14 - target_u) <= 20) AND (ABS(D12) <= 100) AND (ABS(D15) <= 100) THEN
            step := 3;
        END_IF;
    3:
        D22 := 0;
        Y22 := TRUE;
        IF (ABS(D16) <= 20) AND (ABS(D17) <= 100) THEN
            step := 4;
        END_IF;
    4:
        D20 := target_s;
        D21 := target_u;
        D22 := 0;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        IF timer_compl.Q THEN
            Y2 := TRUE;
            step := 5;
        END_IF;
    5:
        Y2 := TRUE;
END_CASE;

END_PROGRAM