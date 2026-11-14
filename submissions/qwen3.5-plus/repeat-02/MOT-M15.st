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
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
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
    Y2 : BOOL;
    
    state : INT;
    side_val : DINT;
    tgt_val : DINT;
    stk_val : DINT;
    a_arrived : BOOL;
    b_arrived : BOOL;
    c_arrived : BOOL;
    d_arrived : BOOL;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X0);

CASE state OF
    0:
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
        D20 := 0; D21 := 0; D24 := 0; D25 := 0; D28 := 0; D29 := 0; D32 := 0; D33 := 0;
        Y2 := FALSE;
        IF start_edge.Q THEN
            state := 1;
            side_val := D101 / 100;
            tgt_val := D102;
            stk_val := D103;
            IF side_val = 1 THEN
                D20 := 6000;
                D24 := 0;
            ELSIF side_val = 2 THEN
                D20 := 0;
                D24 := 6000;
            END_IF;
            D28 := 0;
            D32 := 0;
            D21 := 500;
            D25 := 500;
            D29 := 500;
            D33 := 500;
        END_IF;

    1:
        Y20 := TRUE; Y21 := TRUE; Y22 := FALSE; Y23 := FALSE;
        D21 := 500; D25 := 500;
        a_arrived := ABS(D10 - D20) <= 20 AND ABS(D11) <= 100;
        b_arrived := ABS(D12 - D24) <= 20 AND ABS(D13) <= 100;
        IF a_arrived AND b_arrived THEN
            state := 2;
        END_IF;

    2:
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := FALSE;
        D28 := tgt_val;
        D29 := 500;
        c_arrived := ABS(D14 - D28) <= 20 AND ABS(D15) <= 100;
        IF c_arrived THEN
            state := 3;
        END_IF;

    3:
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE;
        D32 := stk_val;
        D33 := 500;
        d_arrived := ABS(D16 - D32) <= 20 AND ABS(D17) <= 100;
        IF d_arrived THEN
            state := 4;
        END_IF;

    4:
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE;
        D32 := 0;
        d_arrived := ABS(D16 - D32) <= 20 AND ABS(D17) <= 100;
        IF d_arrived THEN
            state := 5;
        END_IF;

    5:
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := FALSE;
        D28 := 0;
        c_arrived := ABS(D14 - D28) <= 20 AND ABS(D15) <= 100;
        IF c_arrived THEN
            state := 6;
        END_IF;

    6:
        Y20 := TRUE; Y21 := TRUE; Y22 := FALSE; Y23 := FALSE;
        D20 := 0;
        D24 := 0;
        a_arrived := ABS(D10 - D20) <= 20 AND ABS(D11) <= 100;
        b_arrived := ABS(D12 - D24) <= 20 AND ABS(D13) <= 100;
        IF a_arrived AND b_arrived THEN
            state := 7;
        END_IF;

    7:
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
        D20 := 0; D24 := 0; D28 := 0; D32 := 0;
        D21 := 0; D25 := 0; D29 := 0; D33 := 0;
        Y2 := TRUE;
END_CASE;

END_PROGRAM