PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;
    D21 : INT;
    start_edge : R_TRIG;
    state : INT := 0;
    target_vol : INT;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            target_vol := D10;
            state := 1;
        END_IF;
        
    1:
        Y20 := TRUE;
        Y21 := FALSE;
        IF X20 THEN
            state := 2;
        END_IF;
        
    2:
        Y20 := TRUE;
        Y21 := TRUE;
        state := 3;
        
    3:
        Y20 := TRUE;
        Y21 := TRUE;
        IF D20 >= target_vol - 1 THEN
            Y21 := FALSE;
            state := 4;
        END_IF;
        
    4:
        Y20 := FALSE;
        Y21 := FALSE;
        state := 5;
        
    5:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X21 THEN
            state := 6;
        END_IF;
        
    6:
        Y20 := FALSE;
        Y21 := FALSE;
        IF D20 >= (target_vol - 2) AND D20 <= (target_vol + 2) THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM