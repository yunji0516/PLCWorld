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
    X34_prev : BOOL := FALSE;
    stop_target : DINT := 0;
END_VAR

CASE state OF
    0:
        IF X0 THEN
            state := 1;
        END_IF;
        
    1:
        Y20 := TRUE;
        D20 := 11000;
        D21 := 200;
        IF X34 AND NOT X34_prev THEN
            stop_target := D10 + 500;
            state := 2;
        END_IF;
        
    2:
        Y20 := TRUE;
        D20 := stop_target;
        D21 := 1000;
        IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 THEN
            Y30 := TRUE;
            state := 3;
        END_IF;
        
    3:
        Y20 := TRUE;
        Y30 := TRUE;
        IF X35 THEN
            Y30 := FALSE;
            D20 := D90 + (D102 * D101) / 100;
            D21 := 1000;
            state := 4;
        END_IF;
        
    4:
        Y20 := TRUE;
        Y30 := FALSE;
        IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 THEN
            Y21 := TRUE;
            D24 := D103;
            D25 := 1000;
            state := 5;
        END_IF;
        
    5:
        Y20 := TRUE;
        Y21 := TRUE;
        IF ABS(D12 - D24) <= 20 AND ABS(D13) <= 100 THEN
            D24 := 0;
            D25 := 1000;
            state := 6;
        END_IF;
        
    6:
        Y20 := TRUE;
        Y21 := TRUE;
        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            state := 7;
        END_IF;
        
    7:
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := TRUE;
END_CASE;

X34_prev := X34;

END_PROGRAM