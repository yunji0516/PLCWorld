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
    pos1_verified : BOOL := FALSE;
    pos2_verified : BOOL := FALSE;
    dwell_count : INT := 0;
END_VAR

D21 := 1000;
D25 := 1000;

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        D20 := 0;
        D24 := 0;
        Y2 := FALSE;

        IF X0 THEN
            state := 10;
        END_IF;

    10:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y24 := TRUE;
        D20 := 0;
        Y25 := TRUE;
        D24 := 0;
        Y2 := FALSE;

        IF X2 AND X4 AND (ABS(D10) <= 20) AND (ABS(D11) <= 100) THEN
            dwell_count := dwell_count + 1;
            IF dwell_count >= 5 THEN
                pos1_verified := TRUE;
                dwell_count := 0;
                state := 20;
            END_IF;
        ELSE
            dwell_count := 0;
        END_IF;

    20:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := TRUE;
        D20 := 0;
        Y25 := TRUE;
        D24 := 0;
        Y2 := FALSE;

        IF X2 AND X3 THEN
            dwell_count := dwell_count + 1;
            IF dwell_count >= 5 THEN
                dwell_count := 0;
                state := 30;
            END_IF;
        ELSE
            dwell_count := 0;
        END_IF;

    30:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := TRUE;
        D20 := 0;
        Y25 := TRUE;
        D24 := 10000;
        Y2 := FALSE;

        IF X2 AND X3 AND X5 AND (ABS(D12 - 10000) <= 20) AND (ABS(D13) <= 100) THEN
            dwell_count := dwell_count + 1;
            IF dwell_count >= 5 THEN
                dwell_count := 0;
                state := 40;
            END_IF;
        ELSE
            dwell_count := 0;
        END_IF;

    40:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y25 := TRUE;
        D24 := 10000;
        Y24 := TRUE;
        D20 := 5000;
        Y2 := FALSE;

        IF (ABS(D10 - 5000) <= 20) AND (ABS(D11) <= 100) THEN
            dwell_count := dwell_count + 1;
            IF dwell_count >= 5 THEN
                pos2_verified := TRUE;
                dwell_count := 0;
                state := 50;
            END_IF;
        ELSE
            dwell_count := 0;
        END_IF;

    50:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y25 := TRUE;
        D24 := 10000;
        Y24 := TRUE;
        D20 := 0;
        Y2 := FALSE;

        IF (ABS(D10) <= 20) AND (ABS(D11) <= 100) THEN
            dwell_count := dwell_count + 1;
            IF dwell_count >= 5 THEN
                dwell_count := 0;
                state := 60;
            END_IF;
        ELSE
            dwell_count := 0;
        END_IF;

    60:
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := TRUE;
        D20 := 0;
        Y25 := TRUE;
        D24 := 0;
        Y2 := FALSE;

        IF X1 AND X3 AND (ABS(D10) <= 20) AND (ABS(D11) <= 100) AND (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
            IF pos1_verified AND pos2_verified THEN
                state := 70;
            END_IF;
        END_IF;

    70:
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := TRUE;
        D20 := 0;
        Y25 := TRUE;
        D24 := 0;
        Y2 := TRUE;

END_CASE;

END_PROGRAM