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

    state : INT := 0;
    a_dest : DINT := 0;
    b_dest : DINT := 0;
    c_dest : DINT := 0;
    d_dest : DINT := 0;
    a_done : BOOL;
    b_done : BOOL;
    c_done : BOOL;
    d_done : BOOL;
END_VAR

CASE state OF
    0:
        Y20 := FALSE; D20 := 0; D21 := 0;
        Y21 := FALSE; D24 := 0; D25 := 0;
        Y22 := FALSE; D28 := 0; D29 := 0;
        Y23 := FALSE; D32 := 0; D33 := 0;
        Y2 := FALSE;
        
        IF X0 THEN
            IF D101 = 100 THEN
                a_dest := 6000;
                b_dest := 0;
            ELSE
                a_dest := 0;
                b_dest := 6000;
            END_IF;
            c_dest := D102;
            d_dest := D103;
            state := 1;
        END_IF;
        
    1:
        Y20 := TRUE; D20 := a_dest; D21 := 1000;
        Y21 := TRUE; D24 := b_dest; D25 := 1000;
        
        a_done := (ABS(D10 - a_dest) <= 20) AND (ABS(D11) <= 100);
        b_done := (ABS(D12 - b_dest) <= 20) AND (ABS(D13) <= 100);
        
        IF a_done AND b_done THEN
            state := 2;
        END_IF;
        
    2:
        Y20 := TRUE; D20 := a_dest; D21 := 1000;
        Y21 := TRUE; D24 := b_dest; D25 := 1000;
        Y22 := TRUE; D28 := c_dest; D29 := 1000;
        
        c_done := (ABS(D14 - c_dest) <= 20) AND (ABS(D15) <= 100);
        
        IF c_done THEN
            state := 3;
        END_IF;
        
    3:
        Y20 := TRUE; D20 := a_dest; D21 := 1000;
        Y21 := TRUE; D24 := b_dest; D25 := 1000;
        Y22 := TRUE; D28 := c_dest; D29 := 1000;
        Y23 := TRUE; D32 := d_dest; D33 := 1000;
        
        d_done := (ABS(D16 - d_dest) <= 20) AND (ABS(D17) <= 100);
        
        IF d_done THEN
            state := 4;
        END_IF;
        
    4:
        Y20 := TRUE; D20 := a_dest; D21 := 1000;
        Y21 := TRUE; D24 := b_dest; D25 := 1000;
        Y22 := TRUE; D28 := c_dest; D29 := 1000;
        Y23 := TRUE; D32 := 0; D33 := 1000;
        
        d_done := (ABS(D16) <= 20) AND (ABS(D17) <= 100);
        
        IF d_done THEN
            state := 5;
        END_IF;
        
    5:
        Y20 := TRUE; D20 := a_dest; D21 := 1000;
        Y21 := TRUE; D24 := b_dest; D25 := 1000;
        Y22 := TRUE; D28 := 0; D29 := 1000;
        Y23 := FALSE; D32 := 0; D33 := 0;
        
        c_done := (ABS(D14) <= 20) AND (ABS(D15) <= 100);
        
        IF c_done THEN
            state := 6;
        END_IF;
        
    6:
        Y20 := TRUE; D20 := 0; D21 := 1000;
        Y21 := TRUE; D24 := 0; D25 := 1000;
        Y22 := FALSE; D28 := 0; D29 := 0;
        Y23 := FALSE; D32 := 0; D33 := 0;
        
        a_done := (ABS(D10) <= 20) AND (ABS(D11) <= 100);
        b_done := (ABS(D12) <= 20) AND (ABS(D13) <= 100);
        
        IF a_done AND b_done THEN
            state := 7;
        END_IF;
        
    7:
        Y20 := FALSE; D20 := 0; D21 := 0;
        Y21 := FALSE; D24 := 0; D25 := 0;
        Y22 := FALSE; D28 := 0; D29 := 0;
        Y23 := FALSE; D32 := 0; D33 := 0;
        Y2 := TRUE;
END_CASE;

END_PROGRAM