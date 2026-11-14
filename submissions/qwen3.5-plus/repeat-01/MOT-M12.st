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
    c_arr : BOOL;
    d_arr : BOOL;
END_VAR

IF step = 0 THEN
    IF X0 THEN
        step := 1;
        Y20 := TRUE; Y21 := FALSE;
        Y22 := TRUE; Y23 := FALSE;
        D20 := 0; D21 := 0; Y24 := FALSE;
        D24 := 0; D25 := 0; Y25 := FALSE;
        Y2 := FALSE;
    ELSE
        Y20 := FALSE; Y21 := FALSE;
        Y22 := FALSE; Y23 := FALSE;
        D20 := 0; D21 := 0; Y24 := FALSE;
        D24 := 0; D25 := 0; Y25 := FALSE;
        Y2 := FALSE;
    END_IF;
ELSIF step = 1 THEN
    Y20 := TRUE; Y21 := FALSE;
    Y22 := TRUE; Y23 := FALSE;
    D20 := 0; D21 := 0; Y24 := FALSE;
    D24 := 0; D25 := 0; Y25 := FALSE;
    Y2 := FALSE;
    IF X2 AND X4 THEN
        step := 2;
        Y20 := FALSE; Y21 := TRUE;
        Y22 := FALSE; Y23 := TRUE;
    END_IF;
ELSIF step = 2 THEN
    Y20 := FALSE; Y21 := TRUE;
    Y22 := FALSE; Y23 := TRUE;
    D20 := 0; D21 := 0; Y24 := FALSE;
    D24 := 0; D25 := 0; Y25 := FALSE;
    Y2 := FALSE;
    IF X1 AND X3 THEN
        step := 3;
        D24 := 10000; D25 := 200; Y25 := TRUE;
        D20 := 0; D21 := 0; Y24 := FALSE;
    END_IF;
ELSIF step = 3 THEN
    Y20 := FALSE; Y21 := FALSE;
    Y22 := FALSE; Y23 := FALSE;
    D20 := 0; D21 := 0; Y24 := FALSE;
    D24 := 10000; D25 := 200; Y25 := TRUE;
    Y2 := FALSE;
    IF X5 THEN
        step := 4;
        D20 := 5000; D21 := 200; Y24 := TRUE;
        D24 := 10000; D25 := 200; Y25 := TRUE;
    END_IF;
ELSIF step = 4 THEN
    Y20 := FALSE; Y21 := FALSE;
    Y22 := FALSE; Y23 := FALSE;
    D20 := 5000; D21 := 200; Y24 := TRUE;
    D24 := 10000; D25 := 200; Y25 := TRUE;
    Y2 := FALSE;
    c_arr := (ABS(D10 - 5000) <= 20) AND (ABS(D11) <= 100);
    IF c_arr THEN
        step := 5;
        D20 := 0;
    END_IF;
ELSIF step = 5 THEN
    Y20 := FALSE; Y21 := FALSE;
    Y22 := FALSE; Y23 := FALSE;
    D20 := 0; D21 := 200; Y24 := TRUE;
    D24 := 10000; D25 := 200; Y25 := TRUE;
    Y2 := FALSE;
    c_arr := (ABS(D10) <= 20) AND (ABS(D11) <= 100);
    IF c_arr THEN
        step := 6;
        D24 := 0;
    END_IF;
ELSIF step = 6 THEN
    Y20 := FALSE; Y21 := FALSE;
    Y22 := FALSE; Y23 := FALSE;
    D20 := 0; D21 := 200; Y24 := TRUE;
    D24 := 0; D25 := 200; Y25 := TRUE;
    Y2 := FALSE;
    d_arr := (ABS(D12) <= 20) AND (ABS(D13) <= 100);
    IF d_arr THEN
        step := 7;
        Y2 := TRUE;
        D21 := 0; D25 := 0;
        Y24 := FALSE; Y25 := FALSE;
    END_IF;
ELSIF step = 7 THEN
    Y2 := TRUE;
    Y20 := FALSE; Y21 := FALSE;
    Y22 := FALSE; Y23 := FALSE;
    D20 := 0; D21 := 0; Y24 := FALSE;
    D24 := 0; D25 := 0; Y25 := FALSE;
END_IF;

END_PROGRAM