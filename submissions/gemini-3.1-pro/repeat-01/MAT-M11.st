PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    D21 : INT;

    state : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q AND state = 0 AND D10 = 1 THEN
    state := 1;
END_IF;

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        
    1:
        Y20 := TRUE;
        Y21 := TRUE;
        IF X20 AND X21 THEN
            state := 2;
        END_IF;
        
    2:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        IF D20 >= 150 AND X22 THEN
            state := 3;
        END_IF;
        
    3:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y24 := TRUE;
        IF X24 AND X25 THEN
            state := 4;
        END_IF;
        
    4:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y24 := FALSE;
        Y25 := TRUE;
        (* Retract until tool clears the entrance (tool front <= -200) *)
        IF D21 <= 633 THEN
            state := 5;
        END_IF;
        
    5:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y25 := TRUE;
        IF X23 THEN
            state := 6;
        END_IF;
        
    6:
        Y25 := FALSE;
        IF X26 THEN
            state := 7;
        END_IF;
        
    7:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
END_CASE;

END_PROGRAM