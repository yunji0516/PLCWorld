PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D94 : DINT;
    D95 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    target_a : DINT := 0;
    target_b : DINT := 0;
    init_d95 : DINT := 0;
    saw_busy : BOOL := FALSE;
    saw_done : BOOL := FALSE;
END_VAR

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        D20 := 0;
        D21 := 0;
        D24 := 0;
        D25 := 0;
        Y30 := FALSE;
        Y2 := FALSE;
        IF X0 THEN
            target_a := LIMIT(0, D101, 30000);
            target_b := LIMIT(0, D102, 12000);
            init_d95 := D95;
            state := 1;
        END_IF;

    1:
        Y20 := TRUE;
        D20 := target_a;
        D21 := 1000;
        Y21 := TRUE;
        D24 := target_b;
        D25 := 1000;
        Y30 := FALSE;
        Y2 := FALSE;
        IF (ABS(D10 - target_a) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D12 - target_b) <= 20) AND (ABS(D13) <= 100) AND
           (NOT X34) AND (ABS(D94) <= 20) THEN
            state := 2;
        END_IF;

    2:
        Y20 := TRUE;
        D20 := target_a;
        D21 := 1000;
        Y21 := TRUE;
        D24 := target_b;
        D25 := 1000;
        Y30 := TRUE;
        Y2 := FALSE;
        saw_busy := FALSE;
        saw_done := FALSE;
        state := 3;

    3:
        Y20 := TRUE;
        D20 := target_a;
        D21 := 1000;
        Y21 := TRUE;
        D24 := target_b;
        D25 := 1000;
        Y30 := FALSE;
        Y2 := FALSE;

        IF X34 THEN
            saw_busy := TRUE;
        END_IF;
        IF saw_busy AND (X35 OR (D95 > init_d95)) THEN
            saw_done := TRUE;
        END_IF;
        IF D95 > init_d95 THEN
            saw_busy := TRUE;
            saw_done := TRUE;
        END_IF;

        IF saw_busy AND saw_done AND (NOT X34) AND (ABS(D94) <= 20) THEN
            state := 4;
        END_IF;

    4:
        Y20 := TRUE;
        D20 := target_a;
        D21 := 1000;
        Y21 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y30 := FALSE;
        Y2 := FALSE;

        IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) AND
           (ABS(D10 - target_a) <= 20) AND (ABS(D11) <= 100) THEN
            state := 5;
        END_IF;

    5:
        Y20 := TRUE;
        D20 := target_a;
        D21 := 1000;
        Y21 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y30 := FALSE;
        Y2 := TRUE;

    ELSE
        state := 0;
END_CASE;

END_PROGRAM