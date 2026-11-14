PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D18 : DINT;
    D19 : DINT;
    D101 : DINT;
    D102 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    D36 : DINT;
    D37 : DINT;
    Y24 : BOOL;
    Y2 : BOOL;

    state : DINT := 0;
    a_arrived : BOOL;
    b_arrived : BOOL;
    c_arrived : BOOL;
    d_arrived : BOOL;
    e_arrived : BOOL;
END_VAR

a_arrived := (ABS(D10 - D20) <= 20) AND (ABS(D11) <= 100);
b_arrived := (ABS(D12 - D24) <= 20) AND (ABS(D13) <= 100);
c_arrived := (ABS(D14 - D28) <= 20) AND (ABS(D15) <= 100);
d_arrived := (ABS(D16 - D32) <= 20) AND (ABS(D17) <= 100);
e_arrived := (ABS(D18 - D36) <= 20) AND (ABS(D19) <= 100);

IF NOT X0 THEN
    state := 0;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    D20 := 0; D21 := 0;
    D24 := 0; D25 := 0;
    D28 := 0; D29 := 0;
    D32 := 0; D33 := 0;
    D36 := 0; D37 := 0;
    Y2 := FALSE;
ELSE
    CASE state OF
        0:
            D20 := 10000; D21 := 1000; Y20 := TRUE;
            D24 := 10000; D25 := 1000; Y21 := TRUE;
            state := 1;
        1:
            IF a_arrived AND b_arrived THEN
                D28 := D101; D29 := 1000; Y22 := TRUE;
                state := 2;
            END_IF;
        2:
            IF c_arrived THEN
                D32 := 7000; D33 := 1000; Y23 := TRUE;
                state := 3;
            END_IF;
        3:
            IF d_arrived THEN
                D36 := D102; D37 := 1000; Y24 := TRUE;
                state := 4;
            END_IF;
        4:
            IF e_arrived THEN
                D36 := 0;
                state := 5;
            END_IF;
        5:
            IF e_arrived THEN
                D32 := 0;
                state := 6;
            END_IF;
        6:
            IF d_arrived THEN
                D28 := 0;
                state := 7;
            END_IF;
        7:
            IF c_arrived THEN
                D20 := 0;
                D24 := 0;
                state := 8;
            END_IF;
        8:
            IF a_arrived AND b_arrived THEN
                state := 9;
            END_IF;
        9:
            Y2 := TRUE;
    END_CASE;
END_IF;

END_PROGRAM