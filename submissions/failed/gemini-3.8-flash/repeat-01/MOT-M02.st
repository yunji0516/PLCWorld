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

    step : INT := 0;
    diff : DINT := 0;
    target_a_calc : DINT := 0;
    target_b_calc : DINT := 0;
END_VAR

IF NOT X0 AND (step = 0) THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y30 := FALSE;
    Y31 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    D21 := 1000;
    D24 := 0;
    D25 := 1000;
    D28 := 10000;
    D29 := 1000;
ELSE
    CASE step OF
        0:
            IF X0 THEN
                step := 1;
            END_IF;

        1:
            (* Synchronized beam advance to dock *)
            Y20 := TRUE;
            Y21 := TRUE;
            Y22 := FALSE;
            Y30 := FALSE;
            Y31 := FALSE;
            Y2 := FALSE;
            D21 := 1000;
            D25 := 1000;
            D28 := 10000;
            D29 := 1000;

            diff := D10 - D12;
            IF diff > 350 THEN
                target_a_calc := D10;
                target_b_calc := D10 + 400;
            ELSIF diff < -350 THEN
                target_a_calc := D12 + 400;
                target_b_calc := D12;
            ELSE
                target_a_calc := D12 + 400;
                target_b_calc := D10 + 400;
            END_IF;

            IF target_a_calc > D101 THEN
                target_a_calc := D101;
            END_IF;
            IF target_b_calc > D101 THEN
                target_b_calc := D101;
            END_IF;
            IF target_a_calc < 0 THEN
                target_a_calc := 0;
            END_IF;
            IF target_b_calc < 0 THEN
                target_b_calc := 0;
            END_IF;

            D20 := target_a_calc;
            D24 := target_b_calc;

            IF (ABS(D10 - D101) <= 20) AND (ABS(D11) <= 100) AND
               (ABS(D12 - D101) <= 20) AND (ABS(D13) <= 100) AND X4 THEN
                step := 2;
            END_IF;

        2:
            (* Engage latch *)
            Y20 := TRUE;
            Y21 := TRUE;
            Y22 := FALSE;
            Y30 := TRUE;
            Y31 := FALSE;
            Y2 := FALSE;
            D20 := D101;
            D21 := 1000;
            D24 := D101;
            D25 := 1000;
            D28 := 10000;
            D29 := 1000;

            IF X2 AND NOT X3 THEN
                step := 3;
            END_IF;

        3:
            (* Transfer cart to park *)
            Y20 := TRUE;
            Y21 := TRUE;
            Y22 := TRUE;
            Y30 := TRUE;
            Y31 := FALSE;
            Y2 := FALSE;
            D20 := D101;
            D21 := 1000;
            D24 := D101;
            D25 := 1000;
            D28 := D102;
            D29 := 1000;

            IF (ABS(D14 - D102) <= 20) AND (ABS(D15) <= 100) AND X5 THEN
                step := 4;
            END_IF;

        4:
            (* Release latch *)
            Y20 := TRUE;
            Y21 := TRUE;
            Y22 := TRUE;
            Y30 := FALSE;
            Y31 := TRUE;
            Y2 := FALSE;
            D20 := D