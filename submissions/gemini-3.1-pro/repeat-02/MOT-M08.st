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
    x34_edge : R_TRIG;
END_VAR

x34_edge(CLK := X34);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        IF X0 THEN
            state := 1;
            D20 := 12000;
            D21 := 200;
            Y20 := TRUE;
        END_IF;

    1:
        IF x34_edge.Q THEN
            Y20 := FALSE;
            state := 2;
        END_IF;

    2:
        IF ABS(D11) <= 1 THEN
            Y30 := TRUE;
            state := 3;
        END_IF;

    3:
        IF X35 THEN
            Y30 := FALSE;
            D20 := D90 + (D102 / 100) * D101;
            D21 := 500;
            Y20 := TRUE;
            state := 4;
        END_IF;

    4:
        IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 1 THEN
            D24 := D103;
            D25 := 500;
            Y21 := TRUE;
            state := 5;
        END_IF;

    5:
        IF ABS(D12 - D24) <= 20 AND ABS(D13) <= 1 THEN
            D24 := 0;
            state := 6;
        END_IF;

    6:
        IF ABS(D12) <= 20 AND ABS(D13) <= 1 THEN
            Y2 := TRUE;
            state := 7;
        END_IF;

    7:
        Y2 := TRUE;
END_CASE;

END_PROGRAM