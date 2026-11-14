PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D94 : DINT;
    D95 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    initial_count : DINT := 0;
    req_target : DINT := 0;
    req_depth : DINT := 0;
    done_latched : BOOL := FALSE;
END_VAR

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        IF X0 THEN
            req_target := D101;
            req_depth := D102;
            initial_count := D95;
            D20 := req_target;
            D21 := 1000;
            Y20 := TRUE;
            D24 := req_depth;
            D25 := 1000;
            Y21 := TRUE;
            state := 1;
        END_IF;

    1:
        D20 := req_target;
        D21 := 1000;
        Y20 := TRUE;
        D24 := req_depth;
        D25 := 1000;
        Y21 := TRUE;
        Y30 := FALSE;
        IF (ABS(D10 - req_target) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D12 - req_depth) <= 20) AND (ABS(D13) <= 100) AND
           (NOT X34) THEN
            Y30 := TRUE;
            state := 2;
        END_IF;

    2:
        D20 := req_target;
        D21 := 1000;
        Y20 := TRUE;
        D24 := req_depth;
        D25 := 1000;
        Y21 := TRUE;
        Y30 := TRUE;
        IF X34 OR X35 OR (D95 > initial_count) THEN
            Y30 := FALSE;
            IF X35 OR (D95 > initial_count) THEN
                done_latched := TRUE;
            END_IF;
            state := 3;
        END_IF;

    3:
        D20 := req_target;
        D21 := 1000;
        Y20 := TRUE;
        D24 := req_depth;
        D25 := 1000;
        Y21 := TRUE;
        Y30 := FALSE;
        IF X35 OR (D95 > initial_count) THEN
            done_latched := TRUE;
        END_IF;
        IF done_latched AND (NOT X34) AND (D94 <= 20) THEN
            state := 4;
        END_IF;

    4:
        D20 := req_target;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        Y30 := FALSE;
        IF (ABS(D10 - req_target) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
            state := 5;
        END_IF;

    5:
        D20 := req_target;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        Y30 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM