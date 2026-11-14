PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    trigX34 : R_TRIG;
    edge_pos : DINT := 0;
    target_A_raw : DINT := 0;
    target_B_raw : DINT := 0;
END_VAR

trigX34(CLK := X34);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        D20 := 0; D21 := 0;
        D24 := 0; D25 := 0;
        IF X0 THEN
            state := 1;
        END_IF;

    1:
        Y20 := TRUE;
        D21 := 1000;
        D20 := 10000;
        IF trigX34.Q THEN
            edge_pos := D10;
            state := 2;
        END_IF;

    2:
        D20 := edge_pos + 500;
        D21 := 500;
        IF (ABS(D11) <= 100) AND (D10 >= edge_pos) AND (D10 <= edge_pos + 1000) THEN
            state := 3;
        END_IF;

    3:
        Y30 := TRUE;
        state := 4;

    4:
        Y30 := FALSE;
        IF X35 THEN
            target_A_raw := DINT((D90 / 100.0 + (D102 / 100.0) * (D101 / 100.0)) * 100.0 + 0.5);
            target_B_raw := D103;
            state := 5;
        END_IF;

    5:
        Y20 := TRUE;
        D21 := 1000;
        D20 := target_A_raw;
        IF (ABS(D10 - target_A_raw) <= 20) AND (ABS(D11) <= 100) THEN
            state := 6;
        END_IF;

    6:
        Y20 := TRUE;
        Y21 := TRUE;
        D25 := 1000;
        D24 := target_B_raw;
        IF (ABS(D12 - target_B_raw) <= 20) AND (ABS(D13) <= 100) THEN
            state := 7;
        END_IF;

    7:
        Y21 := TRUE;
        D25 := 1000;
        D24 := 0;
        IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
            state := 8;
        END_IF;

    8:
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM