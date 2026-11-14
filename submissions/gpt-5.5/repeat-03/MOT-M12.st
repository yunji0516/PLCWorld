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
    started : BOOL;
    checked_extract : BOOL;
    checked_approach : BOOL;
    done : BOOL;
    c_origin : BOOL;
    c_at_50 : BOOL;
    d_origin : BOOL;
    d_at_100 : BOOL;
END_VAR

c_origin := (ABS(D10) <= 19) AND (ABS(D11) <= 99);
c_at_50 := (ABS(D10 - 5000) <= 19) AND (ABS(D11) <= 99);
d_origin := (ABS(D12) <= 19) AND (ABS(D13) <= 99);
d_at_100 := (ABS(D12 - 10000) <= 19) AND (ABS(D13) <= 99);

IF (NOT started) AND X0 THEN
    started := TRUE;
    step := 10;
END_IF;

D20 := 0;
D21 := 200;
Y24 := FALSE;
D24 := 0;
D25 := 200;
Y25 := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

CASE step OF
0:
    D20 := 0;
    D24 := 0;

10:
    D20 := 0;
    D24 := 0;
    Y24 := TRUE;
    Y25 := TRUE;
    Y20 := TRUE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := FALSE;

    IF X2 AND X4 AND c_origin THEN
        checked_extract := TRUE;
        step := 20;
    END_IF;

20:
    D20 := 0;
    D24 := 0;
    Y24 := TRUE;
    Y25 := TRUE;
    Y20 := TRUE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := TRUE;

    IF X2 AND X3 THEN
        step := 30;
    END_IF;

30:
    D20 := 0;
    D24 := 10000;
    Y24 := TRUE;
    Y25 := TRUE;
    Y20 := TRUE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := TRUE;

    IF X2 AND X3 AND X5 AND d_at_100 AND c_origin THEN
        step := 40;
    END_IF;

40:
    D20 := 5000;
    D24 := 10000;
    Y24 := TRUE;
    Y25 := TRUE;
    Y20 := TRUE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := TRUE;

    IF X2 AND X3 AND X5 AND d_at_100 AND c_at_50 THEN
        checked_approach := TRUE;
        step := 50;
    END_IF;

50:
    D20 := 0;
    D24 := 10000;
    Y24 := TRUE;
    Y25 := TRUE;
    Y20 := TRUE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := TRUE;

    IF c_origin THEN
        step := 60;
    END_IF;

60:
    D20 := 0;
    D24 := 0;
    Y24 := TRUE;
    Y25 := TRUE;
    Y20 := TRUE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := TRUE;

    IF d_origin THEN
        step := 70;
    END_IF;

70:
    D20 := 0;
    D24 := 0;
    Y24 := TRUE;
    Y25 := TRUE;
    Y20 := FALSE;
    Y21 := TRUE;
    Y22 := FALSE;
    Y23 := TRUE;

    IF checked_extract AND checked_approach AND X1 AND X3 AND c_origin AND d_origin THEN
        done := TRUE;
        step := 80;
    END_IF;

80:
    D20 := 0;
    D24 := 0;
    Y24 := TRUE;
    Y25 := TRUE;
    Y20 := FALSE;
    Y21 := TRUE;
    Y22 := FALSE;
    Y23 := TRUE;

ELSE
    step := 0;
END_CASE;

Y2 := done;

END_PROGRAM