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
    step : INT := 0;
END_VAR

CASE step OF
    0:
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
        Y24 := FALSE; Y25 := FALSE; Y2 := FALSE;
        D20 := 0; D21 := 0; D24 := 0; D25 := 0;
        IF X0 THEN step := 1; END_IF;

    1:
        Y20 := TRUE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
        Y24 := FALSE; Y25 := FALSE; Y2 := FALSE;
        D20 := 0; D21 := 0; D24 := 0; D25 := 0;
        IF X2 THEN step := 2; END_IF;

    2:
        Y20 := TRUE; Y21 := FALSE; Y22 := TRUE; Y23 := FALSE;
        Y24 := FALSE; Y25 := FALSE; Y2 := FALSE;
        D20 := 0; D21 := 0; D24 := 0; D25 := 0;
        IF X4 THEN step := 3; END_IF;

    3:
        Y20 := TRUE; Y21 := FALSE; Y22 := TRUE; Y23 := FALSE;
        Y24 := TRUE; Y25 := TRUE; Y2 := FALSE;
        D20 := 5000; D21 := 1000; D24 := 10000; D25 := 1000;
        IF X5 AND (ABS(D10 - 5000) <= 20) AND (ABS(D11) <= 100) AND (ABS(D12 - 10000) <= 20) AND (ABS(D13) <= 100) THEN
            step := 4;
        END_IF;

    4:
        Y20 := TRUE; Y21 := FALSE; Y22 := TRUE; Y23 := FALSE;
        Y24 := TRUE; Y25 := TRUE; Y2 := FALSE;
        D20 := 0; D21 := 1000; D24 := 0; D25 := 1000;
        IF (ABS(D10) <= 20) AND (ABS(D11) <= 100) AND (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
            step := 5;
        END_IF;

    5:
        Y20 := FALSE; Y21 := TRUE; Y22 := FALSE; Y23 := TRUE;
        Y24 := TRUE; Y25 := TRUE; Y2 := FALSE;
        D20 := 0; D21 := 1000; D24 := 0; D25 := 1000;
        IF X1 AND X3 THEN
            step := 6;
        END_IF;

    6:
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
        Y24 := FALSE; Y25 := FALSE; Y2 := TRUE;
        D20 := 0; D21 := 0; D24 := 0; D25 := 0;
END_CASE;

END_PROGRAM