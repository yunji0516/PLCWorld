PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y24 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y25 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    check1_done : BOOL := FALSE;
    check2_done : BOOL := FALSE;

    t10 : TON;
    t20 : TON;
    t30 : TON;
    t40 : TON;
    t50 : TON;
END_VAR

IF state = 0 THEN
    IF X0 THEN
        state := 10;
    END_IF;
END_IF;

t10(IN := (state = 10) AND X2 AND X4 AND (ABS(D10) <= 20) AND (ABS(D11) <= 100) AND (ABS(D12) <= 20) AND (ABS(D13) <= 100), PT := T#50ms);
IF (state = 10) AND t10.Q THEN
    check1_done := TRUE;
    state := 20;
END_IF;

t20(IN := (state = 20) AND X2 AND X3 AND X5 AND (ABS(D12 - 10000) <= 20) AND (ABS(D13) <= 100) AND (ABS(D10) <= 20) AND (ABS(D11) <= 100), PT := T#50ms);
IF (state = 20) AND t20.Q THEN
    state := 30;
END_IF;

t30(IN := (state = 30) AND (ABS(D10 - 5000) <= 20) AND (ABS(D11) <= 100) AND X2 AND X3 AND X5 AND (ABS(D12 - 10000) <= 20), PT := T#50ms);
IF (state = 30) AND t30.Q THEN
    check2_done := TRUE;
    state := 40;
END_IF;

t40(IN := (state = 40) AND (ABS(D10) <= 20) AND (ABS(D11) <= 100), PT := T#50ms);
IF (state = 40) AND t40.Q THEN
    state := 50;
END_IF;

t50(IN := (state = 50) AND X1 AND X3 AND (ABS(D10) <= 20) AND (ABS(D11) <= 100) AND (ABS(D12) <= 20) AND (ABS(D13) <= 100), PT := T#50ms);
IF (state = 50) AND t50.Q AND check1_done AND check2_done THEN
    state := 60;
END_IF;

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        D20 := 0;
        D21 := 1000;
        Y25 := FALSE;
        D24 := 0;
        D25 := 1000;
        Y2 := FALSE;

    10:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y24 := TRUE;
        D20 := 0;
        D21 := 1000;
        Y25 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y2 := FALSE;

    20:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := TRUE;
        D20 := 0;
        D21 := 1000;
        Y25 := TRUE;
        D24 := 10000;
        D25 := 1000;
        Y2 := FALSE;

    30:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := TRUE;
        D20 := 5000;
        D21 := 1000;
        Y25 := TRUE;
        D24 := 10000;
        D25 := 1000;
        Y2 := FALSE;

    40:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := TRUE;
        D20 := 0;
        D21 := 1000;
        Y25 := TRUE;
        D24 := 10000;
        D25 := 1000;
        Y2 := FALSE;

    50:
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := TRUE;
        D20 := 0;
        D21 := 1000;
        Y25 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y2 := FALSE;

    60:
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := TRUE;
        D20 := 0;
        D21 := 1000;
        Y25 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y2 := TRUE;
END_CASE;

END_PROGRAM