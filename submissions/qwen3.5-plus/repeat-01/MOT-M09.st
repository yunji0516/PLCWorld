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
    
    step : INT := 0;
    a_tgt : DINT := 0;
    b_tgt : DINT := 0;
    c_tgt : DINT := 0;
    d_tgt : DINT := 0;
    a_ok : BOOL;
    b_ok : BOOL;
    c_ok : BOOL;
    d_ok : BOOL;
END_VAR

a_ok := ABS(D10 - a_tgt) <= 20 AND ABS(D11) <= 100;
b_ok := ABS(D12 - b_tgt) <= 20 AND ABS(D13) <= 100;
c_ok := ABS(D14 - c_tgt) <= 20 AND ABS(D15) <= 100;
d_ok := ABS(D16 - d_tgt) <= 20 AND ABS(D17) <= 100;

CASE step OF
    0:
        IF X0 THEN
            step := 1;
            a_tgt := 10000;
            b_tgt := 6000;
            c_tgt := 6000;
            d_tgt := 0;
            D21 := 1000;
            D25 := 1000;
            D29 := 1000;
            D33 := 1000;
        END_IF;
    1:
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := FALSE;
        D20 := a_tgt; D24 := b_tgt; D28 := c_tgt; D32 := d_tgt;
        IF a_ok AND b_ok AND c_ok THEN
            step := 2;
            d_tgt := D101;
            D32 := d_tgt;
            Y23 := TRUE;
        END_IF;
    2:
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE;
        D20 := a_tgt; D24 := b_tgt; D28 := c_tgt; D32 := d_tgt;
        IF d_ok THEN
            step := 3;
            d_tgt := 0;
            D32 := d_tgt;
        END_IF;
    3:
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE;
        D20 := a_tgt; D24 := b_tgt; D28 := c_tgt; D32 := d_tgt;
        IF d_ok THEN
            step := 4;
            b_tgt := 0;
            c_tgt := 0;
            D24 := b_tgt;
            D28 := c_tgt;
        END_IF;
    4:
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE;
        D20 := a_tgt; D24 := b_tgt; D28 := c_tgt; D32 := d_tgt;
        IF b_ok AND c_ok THEN
            step := 5;
            a_tgt := 0;
            D20 := a_tgt;
        END_IF;
    5:
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE;
        D20 := a_tgt; D24 := b_tgt; D28 := c_tgt; D32 := d_tgt;
        IF a_ok THEN
            step := 6;
            Y2 := TRUE;
            Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
        END_IF;
    6:
        Y2 := TRUE;
END_CASE;
END_PROGRAM