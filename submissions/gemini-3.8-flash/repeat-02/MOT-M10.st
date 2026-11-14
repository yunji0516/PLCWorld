PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y2 : BOOL;

    step : INT := 0;
    req_target : DINT := 0;
END_VAR

CASE step OF
0:
    Y20 := FALSE;
    Y21 := FALSE;
    D20 := 20000;
    D21 := 0;
    D24 := 0;
    D25 := 0;
    Y2 := FALSE;
    IF X0 THEN
        req_target := D101;
        step := 10;
    END_IF;

10:
    Y20 := TRUE;
    D20 := 50000;
    D21 := 1000;
    Y21 := TRUE;
    D24 := 0;
    D25 := 1000;
    IF ABS(D10 - 50000) <= 20 AND ABS(D11) <= 100 THEN
        step := 20;
    END_IF;

20:
    Y20 := TRUE;
    D20 := 50000;
    D21 := 1000;
    Y21 := TRUE;
    D24 := 9000;
    D25 := 1000;
    IF ABS(D12 - 9000) <= 20 AND ABS(D13) <= 100 THEN
        step := 30;
    END_IF;

30:
    Y20 := TRUE;
    D20 := req_target;
    D21 := 1000;
    Y21 := TRUE;
    D24 := 9000;
    D25 := 1000;
    IF ABS(D10 - req_target) <= 20 AND ABS(D11) <= 100 THEN
        step := 40;
    END_IF;

40:
    Y20 := TRUE;
    D20 := 50000;
    D21 := 1000;
    Y21 := TRUE;
    D24 := 9000;
    D25 := 1000;
    IF ABS(D10 - 50000) <= 20 AND ABS(D11) <= 100 THEN
        step := 50;
    END_IF;

50:
    Y20 := TRUE;
    D20 := 50000;
    D21 := 1000;
    Y21 := TRUE;
    D24 := 0;
    D25 := 1000;
    IF ABS(D12 - 0) <= 20 AND ABS(D13) <= 100 THEN
        step := 60;
    END_IF;

60:
    Y20 := TRUE;
    D20 := 20000;
    D21 := 1000;
    Y21 := TRUE;
    D24 := 0;
    D25 := 1000;
    IF ABS(D10 - 20000) <= 20 AND ABS(D11) <= 100 THEN
        step := 70;
    END_IF;

70:
    Y20 := TRUE;
    D20 := 20000;
    D21 := 1000;
    Y21 := TRUE;
    D24 := 0;
    D25 := 1000;
    Y2 := TRUE;

END_CASE;

END_PROGRAM