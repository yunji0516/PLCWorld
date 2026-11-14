PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X31 : BOOL;
    Y2 : BOOL;
    D20 : INT;
    D21 : INT;
    
    start_edge : R_TRIG;
    state : INT := 0;
    target_angle : INT;
    err : INT;
END_VAR

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;
Y2 := FALSE;

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q THEN
            state := 1;
            target_angle := D10;
        END_IF;
        
    1:
        Y24 := TRUE;
        IF X22 THEN
            state := 2;
        END_IF;
        
    2:
        Y20 := TRUE;
        IF X24 THEN
            state := 3;
        END_IF;
        
    3:
        Y23 := TRUE;
        IF X23 THEN
            state := 4;
        END_IF;
        
    4:
        err := D21 - target_angle;
        WHILE err > 180 DO
            err := err - 360;
        END_WHILE;
        WHILE err < -180 DO
            err := err + 360;
        END_WHILE;
        
        IF err > 2 THEN
            Y25 := FALSE;
            Y26 := TRUE;
        ELSIF err < -2 THEN
            Y25 := TRUE;
            Y26 := FALSE;
        ELSE
            Y25 := FALSE;
            Y26 := FALSE;
        END_IF;
        
        IF Y25 = FALSE AND Y26 = FALSE AND X28 THEN
            state := 5;
        END_IF;
        
    5:
        Y21 := TRUE;
        IF X21 THEN
            state := 6;
        END_IF;
        
    6:
        Y24 := TRUE;
        IF X22 THEN
            state := 7;
        END_IF;
        
    7:
        Y20 := FALSE;
        IF X25 THEN
            state := 8;
        END_IF;
        
    8:
        Y23 := TRUE;
        IF X23 THEN
            state := 9;
        END_IF;
        
    9:
        Y22 := TRUE;
        IF X20 THEN
            state := 10;
        END_IF;
        
    10:
        Y2 := TRUE;
END_CASE;

END_PROGRAM