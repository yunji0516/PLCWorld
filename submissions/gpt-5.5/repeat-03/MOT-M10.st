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
    state : INT := 0;
    reqTarget : DINT := 84000;
    atA200 : BOOL;
    atA500 : BOOL;
    atAReq : BOOL;
    atB0 : BOOL;
    atB90 : BOOL;
END_VAR

atA200 := (ABS(D10 - 20000) <= 20) AND (ABS(D11) <= 100);
atA500 := (ABS(D10 - 50000) <= 20) AND (ABS(D11) <= 100);
atAReq := (ABS(D10 - reqTarget) <= 20) AND (ABS(D11) <= 100);
atB0 := (ABS(D12 - 0) <= 20) AND (ABS(D13) <= 100);
atB90 := (ABS(D12 - 9000) <= 20) AND (ABS(D13) <= 100);

CASE state OF
    0:
        D20 := 50000;
        D21 := 1000;
        Y20 := FALSE;
        D24 := 0;
        D25 := 1000;
        Y21 := FALSE;

        IF X0 THEN
            reqTarget := D101;
            IF reqTarget < 84000 THEN
                reqTarget := 84000;
            END_IF;
            IF reqTarget > 85000 THEN
                reqTarget := 85000;
            END_IF;
            state := 10;
        END_IF;

    10:
        D20 := 50000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;

        IF atA500 AND atB0 THEN
            state := 20;
        END_IF;

    20:
        D20 := 50000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 9000;
        D25 := 1000;
        Y21 := TRUE;

        IF atA500 AND atB90 THEN
            state := 30;
        END_IF;

    30:
        D20 := reqTarget;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 9000;
        D25 := 1000;
        Y21 := TRUE;

        IF atAReq AND atB90 THEN
            state := 40;
        END_IF;

    40:
        D20 := 50000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 9000;
        D25 := 1000;
        Y21 := TRUE;

        IF atA500 AND atB90 THEN
            state := 50;
        END_IF;

    50:
        D20 := 50000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;

        IF atA500 AND atB0 THEN
            state := 60;
        END_IF;

    60:
        D20 := 20000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;

        IF atA200 AND atB0 THEN
            state := 70;
        END_IF;

    70:
        D20 := 20000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;

    ELSE
        state := 0;
        D20 := 50000;
        D21 := 1000;
        Y20 := FALSE;
        D24 := 0;
        D25 := 1000;
        Y21 := FALSE;
END_CASE;

Y2 := (state = 70);

END_PROGRAM