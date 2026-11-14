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
    step : INT := 0;
    target_depth : DINT := 0;
END_VAR

CASE step OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        D20 := 0;
        D21 := 0;
        D24 := 0;
        D25 := 0;
        D28 := 0;
        D29 := 0;
        D32 := 0;
        D33 := 0;
        IF X0 THEN
            target_depth := D101;
            step := 10;
        END_IF;

    10:
        (* Move guide A to 100 mm *)
        Y20 := TRUE;
        D20 := 10000;
        D21 := 1000;
        IF (ABS(D10 - 10000) <= 20) AND (ABS(D11) <= 100) THEN
            step := 20;
        END_IF;

    20:
        (* Extend locking pins B and C to 60 mm *)
        Y20 := TRUE;
        D20 := 10000;
        D21 := 1000;
        Y21 := TRUE;
        D24 := 6000;
        D25 := 1000;
        Y22 := TRUE;
        D28 := 6000;
        D29 := 1000;
        IF (ABS(D12 - 6000) <= 20) AND (ABS(D13) <= 100) AND
           (ABS(D14 - 6000) <= 20) AND (ABS(D15) <= 100) THEN
            step := 30;
        END_IF;

    30:
        (* Move access axis D to request depth *)
        Y20 := TRUE;
        D20 := 10000;
        D21 := 1000;
        Y21 := TRUE;
        D24 := 6000;
        D25 := 1000;
        Y22 := TRUE;
        D28 := 6000;
        D29 := 1000;
        Y23 := TRUE;
        D32 := target_depth;
        D33 := 1000;
        IF (ABS(D16 - target_depth) <= 20) AND (ABS(D17) <= 100) THEN
            step := 40;
        END_IF;

    40:
        (* Retract access axis D to 0 *)
        Y20 := TRUE;
        D20 := 10000;
        D21 := 1000;
        Y21 := TRUE;
        D24 := 6000;
        D25 := 1000;
        Y22 := TRUE;
        D28 := 6000;
        D29 := 1000;
        Y23 := TRUE;
        D32 := 0;
        D33 := 1000;
        IF (ABS(D16) <= 20) AND (ABS(D17) <= 100) THEN
            step := 50;
        END_IF;

    50:
        (* Retract locking pins B and C to 0 *)
        Y20 := TRUE;
        D20 := 10000;
        D21 := 1000;
        Y21 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y22 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y23 := TRUE;
        D32 := 0;
        D33 := 1000;
        IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) AND
           (ABS(D14) <= 20) AND (ABS(D15) <= 100) THEN
            step := 60;
        END_IF;

    60:
        (* Retract guide A to 0 *)
        Y20 := TRUE;
        D20 := 0;
        D21 := 1000;
        Y21 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y22 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y23 := TRUE;
        D32 := 0;
        D33 := 1000;
        IF (ABS(D10) <= 20) AND (ABS(D11) <= 100) THEN
            step := 70;
        END_IF;

    70:
        (* Maintain origin and assert completion *)
        Y20 := TRUE;
        D20 := 0;
        D21 := 1000;
        Y21 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y22 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y23 := TRUE;
        D32 := 0;
        D33 := 1000;
        Y2 := TRUE;
END_CASE;

END_PROGRAM