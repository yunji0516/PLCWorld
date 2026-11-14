PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D90 : DINT;
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
    Y30 : BOOL;
    Y31 : BOOL;
    Y2 : BOOL;
    
    state : INT;
    dock_pos : DINT;
    park_pos : DINT;
END_VAR

VAR
    pos_tol : DINT := 20;
    vel_tol : DINT := 100;
END_VAR

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y31 := FALSE;
        Y2 := FALSE;
        D21 := 0;
        D25 := 0;
        D29 := 0;
        D20 := D10;
        D24 := D12;
        D28 := D14;
        
        IF X0 THEN
            dock_pos := D101;
            park_pos := D102;
            state := 1;
        END_IF;
        
    1:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y31 := FALSE;
        Y2 := FALSE;
        D20 := dock_pos;
        D24 := dock_pos;
        D21 := 1000;
        D25 := 1000;
        D28 := D14;
        D29 := 0;
        
        IF ABS(D10 - dock_pos) <= pos_tol AND ABS(D11) <= vel_tol AND
           ABS(D12 - dock_pos) <= pos_tol AND ABS(D13) <= vel_tol THEN
            state := 2;
        END_IF;
        
    2:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y31 := FALSE;
        Y2 := FALSE;
        D20 := dock_pos;
        D24 := dock_pos;
        D21 := 1000;
        D25 := 1000;
        D28 := D14;
        D29 := 0;
        
        IF X4 THEN
            state := 3;
        END_IF;
        
    3:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y30 := TRUE;
        Y31 := FALSE;
        Y2 := FALSE;
        D20 := dock_pos;
        D24 := dock_pos;
        D21 := 1000;
        D25 := 1000;
        D28 := D14;
        D29 := 0;
        
        IF X2 THEN
            state := 4;
        END_IF;
        
    4:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y30 := TRUE;
        Y31 := FALSE;
        Y2 := FALSE;
        D20 := dock_pos;
        D24 := dock_pos;
        D21 := 1000;
        D25 := 1000;
        D28 := park_pos;
        D29 := 1000;
        
        IF ABS(D14 - park_pos) <= pos_tol AND ABS(D15) <= vel_tol THEN
            state := 5;
        END_IF;
        
    5:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y30 := TRUE;
        Y31 := FALSE;
        Y2 := FALSE;
        D20 := dock_pos;
        D24 := dock_pos;
        D21 := 1000;
        D25 := 1000;
        D28 := park_pos;
        D29 := 1000;
        
        IF X5 THEN
            state := 6;
        END_IF;
        
    6:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y30 := FALSE;
        Y31 := TRUE;
        Y2 := FALSE;
        D20 := dock_pos;
        D24 := dock_pos;
        D21 := 1000;
        D25 := 1000;
        D28 := park_pos;
        D29 := 1000;
        
        IF X1 THEN
            state := 7;
        END_IF;
        
    7:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y30 := FALSE;
        Y31 := TRUE;
        Y2 := FALSE;
        D20 := 0;
        D24 := 0;
        D21 := 1000;
        D25 := 1000;
        D28 := park_pos;
        D29 := 1000;
        
        IF ABS(D10) <= pos_tol AND ABS(D11) <= vel_tol AND
           ABS(D12) <= pos_tol AND ABS(D13) <= vel_tol THEN
            state := 8;
        END_IF;
        
    8:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y30 := FALSE;
        Y31 := TRUE;
        Y2 := TRUE;
        D20 := 0;
        D24 := 0;
        D21 := 1000;
        D25 := 1000;
        D28 := park_pos;
        D29 := 1000;
        
END_CASE;

END_PROGRAM