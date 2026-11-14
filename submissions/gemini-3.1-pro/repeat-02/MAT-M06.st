PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    
    state : INT := 0;
    target_vol : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q THEN
    IF state = 0 THEN
        target_vol := D10;
        state := 1;
    END_IF;
END_IF;

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        
    1: (* Move nozzle down to receiving position *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X21 THEN
            state := 2;
        END_IF;
        
    2: (* Open valve *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF X22 THEN
            state := 3;
        END_IF;
        
    3: (* Turn on pump and fill vessel *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := TRUE;
        IF D20 >= target_vol THEN
            state := 4;
        END_IF;
        
    4: (* Stop pump and close valve *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X23 THEN
            state := 5;
        END_IF;
        
    5: (* Move nozzle up to initial position *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X20 THEN
            state := 6;
        END_IF;
        
    6: (* Complete and maintain terminal state *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM