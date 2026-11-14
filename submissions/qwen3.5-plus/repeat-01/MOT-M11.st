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
    step : INT := 0;
    tol_pos : DINT := 20;
    tol_vel : DINT := 100;
END_VAR

CASE step OF
    0:
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE;
        D20 := 0; D21 := 0; D24 := 0; D25 := 0; D28 := 0; D29 := 0;
        Y2 := FALSE;
        IF X0 THEN
            step := 1;
        END_IF;
    1:
        D20 := D101; D21 := 1000; Y20 := TRUE;
        D24 := 0; D25 := 0; Y21 := FALSE;
        D28 := 0; D29 := 0; Y22 := FALSE;
        Y2 := FALSE;
        IF ABS(D10 - D101) <= tol_pos AND ABS(D11) <= tol_vel THEN
            step := 2;
        END_IF;
    2:
        D20 := D101; D21 := 1000; Y20 := TRUE;
        D24 := D103; D25 := 1000; Y21 := TRUE;
        D28 := 0; D29 := 0; Y22 := FALSE;
        Y2 := FALSE;
        IF ABS(D12 - D103) <= tol_pos AND ABS(D13) <= tol_vel THEN
            step := 3;
        END_IF;
    3:
        D20 := D101; D21 := 1000; Y20 := TRUE;
        D24 := 0; D25 := 1000; Y21 := TRUE;
        D28 := 0; D29 := 0; Y22 := FALSE;
        Y2 := FALSE;
        IF ABS(D12) <= tol_pos AND ABS(D13) <= tol_vel THEN
            step := 4;
        END_IF;
    4:
        D20 := D102; D21 := 1000; Y20 := TRUE;
        D24 := 0; D25 := 0; Y21 := FALSE;
        D28 := 0; D29 := 0; Y22 := FALSE;
        Y2 := FALSE;
        IF ABS(D10 - D102) <= tol_pos AND ABS(D11) <= tol_vel THEN
            step := 5;
        END_IF;
    5:
        D20 := D102; D21 := 1000; Y20 := TRUE;
        D24 := 0; D25 := 0; Y21 := FALSE;
        D28 := D104; D29 := 1000; Y22 := TRUE;
        Y2 := FALSE;
        IF ABS(D14 - D104) <= tol_pos AND ABS(D15) <= tol_vel THEN
            step := 6;
        END_IF;
    6:
        D20 := D102; D21 := 1000; Y20 := TRUE;
        D24 := 0; D25 := 0; Y21 := FALSE;
        D28 := 0; D29 := 1000; Y22 := TRUE;
        Y2 := FALSE;
        IF ABS(D14) <= tol_pos AND ABS(D15) <= tol_vel THEN
            step := 7;
        END_IF;
    7:
        D20 := D102; D21 := 1000; Y20 := TRUE;
        D24 := 0; D25 := 0; Y21 := FALSE;
        D28 := 0; D29 := 0; Y22 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM