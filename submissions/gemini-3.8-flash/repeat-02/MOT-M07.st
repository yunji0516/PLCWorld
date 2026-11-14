PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    req_first : DINT := 0;
    req_second : DINT := 0;
    req_depth : DINT := 0;
    req_reach : DINT := 0;
    dwell_in : BOOL := FALSE;
    dwell_timer : TON;
END_VAR

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        D20 := 0;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;
        D28 := 0;
        D29 := 1000;
        dwell_in := FALSE;

        IF X0 THEN
            req_first := D101;
            req_second := D102;
            req_depth := D103;
            req_reach := D104;
            Y20 := TRUE;
            Y21 := TRUE;
            Y22 := TRUE;
            state := 10;
        END_IF;

    10:
        // Raise B to safe transfer height (110 mm)
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := 0;
        D21 := 1000;
        D24 := 11000;
        D25 := 1000;
        D28 := 0;
        D29 := 1000;

        IF (ABS(D12 - 11000) <= 20) AND (ABS(D13) <= 100) THEN
            state := 20;
        END_IF;

    20:
        // Move A to first port position, C remains at 0
        D20 := req_first;
        D24 := 11000;
        D28 := 0;

        IF (ABS(D10 - req_first) <= 20) AND (ABS(D11) <= 100) AND (ABS(D14) <= 20) AND (ABS(D15) <= 100) THEN
            state := 30;
        END_IF;

    30:
        // Lower B to 0 (access first port)
        D20 := req_first;
        D24 := 0;
        D28 := 0;

        IF (ABS(D10 - req_first) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D12) <= 20) AND (ABS(D13) <= 100) AND
           (ABS(D14) <= 20) AND (ABS(D15) <= 100) THEN
            dwell_in := TRUE;
            IF dwell_timer.Q THEN
                dwell_in := FALSE;
                state := 40;
            END_IF;
        ELSE
            dwell_in := FALSE;
        END_IF;

    40:
        // Retract B to safe transfer height (110 mm)
        D20 := req_first;
        D24 := 11000;
        D28 := 0;

        IF (ABS(D12 - 11000) <= 20) AND (ABS(D13) <= 100) THEN
            state := 50;
        END_IF;

    50:
        // Move A to second port position, deploy C to reach
        D20 := req_second;
        D24 := 11000;
        D28 := req_reach;

        IF (ABS(D10 - req_second) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D14 - req_reach) <= 20) AND (ABS(D15) <= 100) THEN
            state := 60;
        END_IF;

    60:
        // Lower B to depth (access second port)
        D20 := req_second;
        D24 := req_depth;
        D28 := req_reach;

        IF (ABS(D10 - req_second) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D12 - req_depth) <= 20) AND (ABS(D13) <= 100) AND
           (ABS(D14 - req_reach) <= 20) AND (ABS(D15) <= 100) THEN
            dwell_in := TRUE;
            IF dwell_timer.Q THEN
                dwell_in := FALSE;
                state := 70;
            END_IF;
        ELSE
            dwell_in := FALSE;
        END_IF;

    70:
        // Retract B to safe transfer height (110 mm)
        D20 := req_second;
        D24 := 11000;
        D28 := req_reach;

        IF (ABS(D12 - 11000) <= 20) AND (ABS(D13) <= 100) THEN
            state := 80;
        END_IF;

    80:
        // Retract A to 0, retract C to 0
        D20 := 0;
        D24 := 11000;
        D28 := 0;

        IF (ABS(D10) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D14) <= 20) AND (ABS(D15) <= 100) THEN
            state := 90;
        END_IF;

    90:
        // Lower B to 0 (final position A=0, B=0, C=0)
        D20 := 0;
        D24 := 0;
        D28 := 0;

        IF (ABS(D10) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D12) <= 20) AND (ABS(D13) <= 100) AND
           (ABS(D14) <= 20) AND (ABS(D15) <= 100) THEN
            dwell_in := TRUE;
            IF dwell_timer.Q THEN
                dwell_in := FALSE;
                state := 100;
            END_IF;
        ELSE
            dwell_in := FALSE;
        END_IF;

    100:
        // Operation complete
        D20 := 0;
        D24 := 0;
        D28 := 0;
        Y2 := TRUE;
END_CASE;

dwell_timer(IN := dwell_in, PT := T#50ms);

END_PROGRAM