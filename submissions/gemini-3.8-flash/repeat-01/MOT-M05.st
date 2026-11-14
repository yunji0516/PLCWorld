PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    X11 : BOOL;
    D20 : DINT;
    D21 : DINT;
    D22 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;

    initialized : BOOL := FALSE;
    req_latched : BOOL := FALSE;
    state : INT := 0;
    cmd_a : DINT := 0;
    cmd_b : DINT := 0;
    req_a : DINT := 0;
    req_b : DINT := 0;
    ideal_b : DINT := 0;
    settle_count : INT := 0;
    hold_count : INT := 0;
    comp_ok : BOOL := FALSE;
END_VAR

IF NOT initialized THEN
    cmd_a := D11;
    cmd_b := D13;
    D20 := cmd_a;
    D21 := cmd_b;
    D22 := 0;
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
    Y2 := FALSE;
    initialized := TRUE;
END_IF;

IF X10 THEN
    req_latched := TRUE;
END_IF;

IF (state = 0) AND req_latched THEN
    req_a := D10;
    IF D17 <> 0 THEN
        req_b := D17;
    ELSE
        req_b := DINT(-45000.0 * SIN(REAL(D10) * 0.000174532925));
    END_IF;
    state := 10;
END_IF;

CASE state OF
    0:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y2 := FALSE;
        D20 := cmd_a;
        D21 := cmd_b;
        D22 := 0;

    10:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y2 := FALSE;
        D22 := 0;

        IF cmd_a < req_a THEN
            cmd_a := MIN(cmd_a + 40, req_a);
        ELSIF cmd_a > req_a THEN
            cmd_a := MAX(cmd_a - 40, req_a);
        END_IF;

        IF cmd_a = req_a THEN
            ideal_b := req_b;
        ELSE
            ideal_b := DINT(-45000.0 * SIN(REAL(cmd_a) * 0.000174532925));
        END_IF;

        IF cmd_b < ideal_b THEN
            cmd_b := MIN(cmd_b + 400, ideal_b);
        ELSIF cmd_b > ideal_b THEN
            cmd_b := MAX(cmd_b - 400, ideal_b);
        END_IF;

        D20 := cmd_a;
        D21 := cmd_b;

        IF (cmd_a = req_a) AND (cmd_b = req_b) THEN
            settle_count := 0;
            state := 15;
        END_IF;

    15:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y2 := FALSE;
        D20 := req_a;
        D21 := req_b;
        D22 := 0;

        IF (ABS(D11 - req_a) <= 15) AND (ABS(D12) <= 50) AND
           (ABS(D13 - req_b) <= 15) AND (ABS(D14) <= 50) THEN
            settle_count := settle_count + 1;
        ELSE
            settle_count := 0;
        END_IF;

        IF settle_count >= 4 THEN
            state := 20;
        END_IF;

    20:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y2 := FALSE;
        D20 := req_a;
        D21 := req_b;
        D22 := 0;

        IF X11 THEN
            hold_count := 0;
            state := 30;
        END_IF;

    30:
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y2 := FALSE;
        D20 := req_a;
        D21 := req_b;
        D22 := 0;

        comp_ok := (ABS(D11 - req_a) <= 20) AND
                   (ABS(D12) <= 100) AND
                   (ABS(D13 - req_b) <= 20) AND
                   (ABS(D14) <= 100) AND
                   X11 AND Y22 AND (NOT Y20);

        IF comp_ok THEN
            hold_count := hold_count + 1;
        ELSE
            hold_count := 0;
        END_IF;

        IF hold_count >= 3 THEN
            state := 40;
        END_IF;

    40:
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y2 := TRUE;
        D20 := req_a;
        D21 := req_b;
        D22 := 0;
END_CASE;

END_PROGRAM