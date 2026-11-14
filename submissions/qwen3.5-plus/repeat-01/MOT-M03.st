PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    state : INT := 0;
END_VAR

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        D20 := 0;
        D21 := 0;
        IF X10 THEN
            state := 1;
        END_IF;
    1:
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := FALSE;
        D20 := D13;
        D21 := D14;
        IF ABS(D11 - D13) <= 20 AND ABS(D12 - D14) <= 100 THEN
            state := 2;
        END_IF;
    2:
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := FALSE;
        D20 := D13;
        D21 := D14;
        IF X11 THEN
            state := 3;
        END_IF;
    3:
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := TRUE;
        D20 := D13;
        D21 := D14;
        IF NOT X10 THEN
            state := 0;
        END_IF;
END_CASE;

END_PROGRAM