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
    c_arrived : BOOL;
    d_arrived : BOOL;
    c_target_internal : DINT := 0;
    d_target_internal : DINT := 0;
END_VAR

D21 := 200;
D25 := 200;
Y24 := TRUE;
Y25 := TRUE;

c_arrived := (ABS(D10 - c_target_internal) <= 20) AND (ABS(D11) <= 100);
d_arrived := (ABS(D12 - d_target_internal) <= 20) AND (ABS(D13) <= 100);

IF step = 0 AND X0 THEN
    step := 1;
END_IF;

CASE step OF
    1:
        IF X2 AND X4 AND c_arrived AND d_arrived THEN
            step := 2;
        END_IF;
    2:
        IF X2 AND X3 AND X5 AND c_arrived AND d_arrived THEN
            step := 3;
        END_IF;
    3:
        IF c_arrived THEN
            step := 4;
        END_IF;
    4:
        IF c_arrived THEN
            step := 5;
        END_IF;
    5:
        IF X1 AND X3 AND c_arrived AND d_arrived THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

CASE step OF
    0:
        c_target_internal := 0;
        d_target_internal := 0;
        Y20 := FALSE; Y21 := TRUE;
        Y22 := FALSE; Y23 := TRUE;
    1:
        c_target_internal := 0;
        d_target_internal := 0;
        Y20 := TRUE; Y21 := FALSE;
        Y22 := TRUE; Y23 := FALSE;
    2:
        c_target_internal := 0;
        d_target_internal := 10000;
        Y20 := TRUE; Y21 := FALSE;
        Y22 := FALSE; Y23 := TRUE;
    3:
        c_target_internal := 5000;
        d_target_internal := 10000;
        Y20 := TRUE; Y21 := FALSE;
        Y22 := FALSE; Y23 := TRUE;
    4:
        c_target_internal := 0;
        d_target_internal := 10000;
        Y20 := TRUE; Y21 := FALSE;
        Y22 := FALSE; Y23 := TRUE;
    5:
        c_target_internal := 0;
        d_target_internal := 0;
        Y20 := FALSE; Y21 := TRUE;
        Y22 := FALSE; Y23 := TRUE;
END_CASE;

D20 := c_target_internal;
D24 := d_target_internal;

END_PROGRAM