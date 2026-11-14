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
    req_first : DINT := 0;
    req_second : DINT := 0;
    req_depth : DINT := 0;
    req_reach : DINT := 0;
END_VAR

CASE step OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        D20 := 0;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;
        D28 := 0;
        D29 := 1000;

        IF X0 THEN
            req_first := D101;
            req_second := D102;
            req_depth := D103;
            req_reach := D104;
            step := 1;
        END_IF;

    1:
        (* Raise B above deck level before horizontal moves *)
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := 0;
        D21 := 1000;
        D24 := 11000;
        D25 := 1000;
        D28 := 0;
        D29 := 1000;

        IF ABS(D12 - 11000) <= 20 AND ABS(D13) <= 100 THEN
            step := 2;
        END_IF;

    2:
        (* Align A to first port, C at 0 *)
        D20 := req_first;
        D24 := 11000;
        D28 := 0;

        IF ABS(D10 - req_first) <= 20 AND ABS(D11) <= 100 AND
           ABS(D14) <= 20 AND ABS(D15) <= 100 THEN
            step := 3;
        END_IF;

    3:
        (* Lower B into first opening: A=first, B=0, C=0 *)
        D20 := req_first;
        D24 := 0;
        D28 := 0;

        IF ABS(D10 - req_first) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12) <= 20 AND ABS(D13) <= 100 AND
           ABS(D14) <= 20 AND ABS(D15) <= 100 THEN
            step := 4;
        END_IF;

    4:
        (* Retract B back above deck *)
        D20 := req_first;
        D24 := 11000;
        D28 := 0;

        IF ABS(D12 - 11000) <= 20 AND ABS(D13) <= 100 THEN
            step := 5;
        END_IF;

    5:
        (* Simultaneous lateral transfer and deployment: A=second, C=reach *)
        D20 := req_second;
        D24 := 11000;
        D28 := req_reach;

        IF ABS(D10 - req_second) <= 20 AND ABS(D11) <= 100 AND
           ABS(D14 - req_reach) <= 20 AND ABS(D15) <= 100 THEN
            step := 6;
        END_IF;

    6:
        (* Lower B into second opening: A=second, B=depth, C=reach *)
        D20 := req_second;
        D24 := req_depth;
        D28 := req_reach;

        IF ABS(D10 - req_second) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12 - req_depth) <= 20 AND ABS(D13) <= 100 AND
           ABS(D14 - req_reach) <= 20 AND ABS(D15) <= 100 THEN
            step := 7;
        END_IF;

    7:
        (* Retract B back above deck *)
        D20 := req_second;
        D24 := 11000;
        D28 := req_reach;

        IF ABS(D12 - 11000) <= 20 AND ABS(D13) <= 100 THEN
            step := 8;
        END_IF;

    8:
        (* Return A and C to 0 above deck *)
        D20 := 0;
        D24 := 11000;
        D28 := 0;

        IF ABS(D10) <= 20 AND ABS(D11) <= 100 AND
           ABS(D14) <= 20 AND ABS(D15) <= 100 THEN
            step := 9;
        END_IF;

    9:
        (* Lower B to final position: A=B=C=0 *)
        D20 := 0;
        D24 := 0;
        D28 := 0;

        IF ABS(D10) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12) <= 20 AND ABS(D13) <= 100 AND
           ABS(D14) <= 20 AND ABS(D15) <= 100 THEN
            step := 10;
        END_IF;

    10:
        (* Completed: assert Y2 and hold A=B=C=0 *)
        D20 := 0;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y22 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM