PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    
    step : DINT := 0;
    target_a : DINT := 0;
    target_b : DINT := 0;
    target_c : DINT := 0;
    en_a : BOOL := FALSE;
    en_b : BOOL := FALSE;
    en_c : BOOL := FALSE;
END_VAR

IF step > 0 THEN
    D21 := 1000;
    D25 := 1000;
    D29 := 1000;
END_IF;

CASE step OF
    0:
        IF X0 THEN
            step := 1;
        END_IF;
        
    1:
        target_b := 11000;
        en_b := TRUE;
        IF ABS(D12 - 11000) <= 20 AND ABS(D13) <= 100 THEN
            step := 2;
        END_IF;
        
    2:
        target_a := D101;
        target_c := 0;
        en_a := TRUE;
        en_c := TRUE;
        IF ABS(D10 - D101) <= 20 AND ABS(D11) <= 100 AND
           ABS(D14 - 0) <= 20 AND ABS(D15) <= 100 AND
           ABS(D12 - 11000) <= 20 AND ABS(D13) <= 100 THEN
            step := 3;
        END_IF;
        
    3:
        target_b := 0;
        IF ABS(D10 - D101) <= 20 AND ABS(D11) <= 100 AND
           ABS(D14 - 0) <= 20 AND ABS(D15) <= 100 AND
           ABS(D12 - 0) <= 20 AND ABS(D13) <= 100 THEN
            step := 4;
        END_IF;
        
    4:
        target_b := 11000;
        IF ABS(D10 - D101) <= 20 AND ABS(D11) <= 100 AND
           ABS(D14 - 0) <= 20 AND ABS(D15) <= 100 AND
           ABS(D12 - 11000) <= 20 AND ABS(D13) <= 100 THEN
            step := 5;
        END_IF;
        
    5:
        target_a := D102;
        target_c := D104;
        IF ABS(D10 - D102) <= 20 AND ABS(D11) <= 100 AND
           ABS(D14 - D104) <= 20 AND ABS(D15) <= 100 AND
           ABS(D12 - 11000) <= 20 AND ABS(D13) <= 100 THEN
            step := 6;
        END_IF;
        
    6:
        target_b := D103;
        IF ABS(D10 - D102) <= 20 AND ABS(D11) <= 100 AND
           ABS(D14 - D104) <= 20 AND ABS(D15) <= 100 AND
           ABS(D12 - D103) <= 20 AND ABS(D13) <= 100 THEN
            step := 7;
        END_IF;
        
    7:
        target_b := 11000;
        IF ABS(D10 - D102) <= 20 AND ABS(D11) <= 100 AND
           ABS(D14 - D104) <= 20 AND ABS(D15) <= 100 AND
           ABS(D12 - 11000) <= 20 AND ABS(D13) <= 100 THEN
            step := 8;
        END_IF;
        
    8:
        target_a := 0;
        target_c := 0;
        IF ABS(D10 - 0) <= 20 AND ABS(D11) <= 100 AND
           ABS(D14 - 0) <= 20 AND ABS(D15) <= 100 AND
           ABS(D12 - 11000) <= 20 AND ABS(D13) <= 100 THEN
            step := 9;
        END_IF;
        
    9:
        target_b := 0;
        IF ABS(D10 - 0) <= 20 AND ABS(D11) <= 100 AND
           ABS(D14 - 0) <= 20 AND ABS(D15) <= 100 AND
           ABS(D12 - 0) <= 20 AND ABS(D13) <= 100 THEN
            step := 10;
        END_IF;
        
    10:
        Y2 := TRUE;
        
END_CASE;

D20 := target_a;
D24 := target_b;
D28 := target_c;
Y20 := en_a;
Y21 := en_b;
Y22 := en_c;

END_PROGRAM