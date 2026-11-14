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
    step : INT;
    wait_cnt : INT;
    extraction_checked : BOOL;
    jig_checked : BOOL;
END_VAR

IF step = 0 AND X0 THEN
    step := 10;
    wait_cnt := 0;
END_IF;

CASE step OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        D20 := 0;
        D21 := 1000;
        Y24 := FALSE;
        D24 := 0;
        D25 := 1000;
        Y25 := FALSE;
        Y2 := FALSE;

    10:
        // Move to extraction position: A=40 (extended), B=180 (extended), C=0, D=0
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        D20 := 0;
        D21 := 1000;
        Y24 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y25 := TRUE;
        Y2 := FALSE;

        IF X2 AND X4 AND (D10 >= -20) AND (D10 <= 20) AND (D11 >= -100) AND (D11 <= 100) AND (D12 >= -20) AND (D12 <= 20) AND (D13 >= -100) AND (D13 <= 100) THEN
            wait_cnt := wait_cnt + 1;
            IF wait_cnt >= 10 THEN
                extraction_checked := TRUE;
                wait_cnt := 0;
                step := 20;
            END_IF;
        ELSE
            wait_cnt := 0;
        END_IF;

    20:
        // Retract B to 0 while keeping A at 40
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        D20 := 0;
        D21 := 1000;
        Y24 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y25 := TRUE;
        Y2 := FALSE;

        IF X2 AND X3 THEN
            wait_cnt := wait_cnt + 1;
            IF wait_cnt >= 5 THEN
                wait_cnt := 0;
                step := 30;
            END_IF;
        ELSE
            wait_cnt := 0;
        END_IF;

    30:
        // Move D to 100 mm (jig transfer axis)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        D20 := 0;
        D21 := 1000;
        Y24 := TRUE;
        D24 := 10000;
        D25 := 1000;
        Y25 := TRUE;
        Y2 := FALSE;

        IF X2 AND X3 AND X5 AND (D12 >= 9980) AND (D12 <= 10020) AND (D13 >= -100) AND (D13 <= 100) THEN
            wait_cnt := wait_cnt + 1;
            IF wait_cnt >= 5 THEN
                wait_cnt := 0;
                step := 40;
            END_IF;
        ELSE
            wait_cnt := 0;
        END_IF;

    40:
        // Single jig approach: C descends to 50 mm
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        D20 := 5000;
        D21 := 1000;
        Y24 := TRUE;
        D24 := 10000;
        D25 := 1000;
        Y25 := TRUE;
        Y2 := FALSE;

        IF X2 AND X3 AND X5 AND (D10 >= 4980) AND (D10 <= 5020) AND (D11 >= -100) AND (D11 <= 100) AND (D12 >= 9980) AND (D12 <= 10020) AND (D13 >= -100) AND (D13 <= 100) THEN
            wait_cnt := wait_cnt + 1;
            IF wait_cnt >= 10 THEN
                jig_checked := TRUE;
                wait_cnt := 0;
                step := 50;
            END_IF;
        ELSE
            wait_cnt := 0;
        END_IF;

    50:
        // Ascend C back to 0 mm
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        D20 := 0;
        D21 := 1000;
        Y24 := TRUE;
        D24 := 10000;
        D25 := 1000;
        Y25 := TRUE;
        Y2 := FALSE;

        IF (D10 >= -20) AND (D10 <= 20) AND (D11 >= -100) AND (D11 <= 100) THEN
            wait_cnt := wait_cnt + 1;
            IF wait_cnt >= 5 THEN
                wait_cnt := 0;
                step := 60;
            END_IF;
        ELSE
            wait_cnt := 0;
        END_IF;

    60:
        // Return all axes to origin: A=0, B=0, C=0, D=0
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := TRUE;
        D20 := 0;
        D21 := 1000;
        Y24 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y25 := TRUE;
        Y2 := FALSE;

        IF X1 AND X3 AND (D10 >= -20) AND (D10 <= 20) AND (D11 >= -100) AND (D11 <= 100) AND (D12 >= -20) AND (D12 <= 20) AND (D13 >= -100) AND (D13 <= 100) THEN
            wait_cnt := wait_cnt + 1;
            IF wait_cnt >= 10 THEN
                wait_cnt := 0;
                step := 70;
            END_IF;
        ELSE
            wait_cnt := 0;
        END_IF;

    70:
        // Complete and hold origins
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := TRUE;
        D20 := 0;
        D21 := 1000;
        Y24 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y25 := TRUE;
        Y2 := extraction_checked AND jig_checked;
END_CASE;

END_PROGRAM