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
    init_count : DINT := 0;
    started_busy : BOOL := FALSE;
    module_done_latched : BOOL := FALSE;
END_VAR

CASE state OF
    0:
        IF X0 THEN
            init_count := D95;
            started_busy := FALSE;
            module_done_latched := FALSE;
            D20 := D101;
            D21 := 1000;
            Y20 := TRUE;
            D24 := D102;
            D25 := 1000;
            Y21 := TRUE;
            Y30 := FALSE;
            Y2 := FALSE;
            state := 1;
        ELSE
            D20 := 0;
            D21 := 0;
            Y20 := FALSE;
            D24 := 0;
            D25 := 0;
            Y21 := FALSE;
            Y30 := FALSE;
            Y2 := FALSE;
        END_IF;

    1:
        D20 := D101;
        D21 := 1000;
        Y20 := TRUE;
        D24 := D102;
        D25 := 1000;
        Y21 := TRUE;
        Y30 := FALSE;
        Y2 := FALSE;

        IF (ABS(D10 - D101) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D12 - D102) <= 20) AND (ABS(D13) <= 100) AND (NOT X34) THEN
            Y30 := TRUE;
            state := 2;
        END_IF;

    2:
        D20 := D101;
        D21 := 1000;
        Y20 := TRUE;
        D24 := D102;
        D25 := 1000;
        Y21 := TRUE;
        Y30 := FALSE;
        Y2 := FALSE;

        IF X34 THEN
            started_busy := TRUE;
        END_IF;
        state := 3;

    3:
        D20 := D101;
        D21 := 1000;
        Y20 := TRUE;
        D24 := D102;
        D25 := 1000;
        Y21 := TRUE;
        Y30 := FALSE;
        Y2 := FALSE;

        IF X34 THEN
            started_busy := TRUE;
        END_IF;
        IF X35 AND (started_busy OR (D95 > init_count)) THEN
            module_done_latched := TRUE;
        END_IF;

        IF (started_busy OR (D95 > init_count)) AND
           (module_done_latched OR X35 OR (D95 > init_count)) AND
           (NOT X34) AND (ABS(D94) <= 20) THEN
            state := 4;
        END_IF;

    4:
        D20 := D101;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        Y30 := FALSE;
        Y2 := FALSE;

        IF (ABS(D10 - D101) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
            state := 5;
        END_IF;

    5:
        D20 := D101;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        Y30 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM