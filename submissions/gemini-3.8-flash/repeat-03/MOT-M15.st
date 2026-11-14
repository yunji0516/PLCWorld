PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;

    step : DINT := 0;
    req_side : DINT := 0;
    req_target : DINT := 0;
    req_stroke : DINT := 0;
END_VAR

CASE step OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF X0 THEN
            req_side := D101;
            req_target := D102;
            req_stroke := D103;
            step := 10;
        END_IF;

    10:
        IF req_side < 150 THEN
            Y20 := TRUE;
            D20 := 6000;
            D21 := 1000;
            IF (ABS(D10 - 6000) <= 20) AND (ABS(D11) <= 100) THEN
                step := 20;
            END_IF;
        ELSE
            Y21 := TRUE;
            D24 := 6000;
            D25 := 1000;
            IF (ABS(D12 - 6000) <= 20) AND (ABS(D13) <= 100) THEN
                step := 20;
            END_IF;
        END_IF;

    20:
        Y22 := TRUE;
        D28 := req_target;
        D29 := 1000;
        IF (ABS(D14 - req_target) <= 20) AND (ABS(D15) <= 100) THEN
            step := 30;
        END_IF;

    30:
        Y23 := TRUE;
        D32 := req_stroke;
        D33 := 1000;
        IF (ABS(D16 - req_stroke) <= 20) AND (ABS(D17) <= 100) THEN
            step := 40;
        END_IF;

    40:
        D32 := 0;
        D33 := 1000;
        IF (ABS(D16) <= 20) AND (ABS(D17) <= 100) THEN
            step := 50;
        END_IF;

    50:
        D28 := 0;
        D29 := 1000;
        IF (ABS(D14) <= 20) AND (ABS(D15) <= 100) THEN
            step := 60;
        END_IF;

    60:
        IF req_side < 150 THEN
            D20 := 0;
            D21 := 1000;
            IF (ABS(D10) <= 20) AND (ABS(D11) <= 100) THEN
                step := 70;
            END_IF;
        ELSE
            D24 := 0;
            D25 := 1000;
            IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
                step := 70;
            END_IF;
        END_IF;

    70:
        Y2 := TRUE;
END_CASE;

END_PROGRAM