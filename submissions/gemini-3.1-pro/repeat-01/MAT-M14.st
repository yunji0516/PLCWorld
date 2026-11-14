PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    D20 : INT;
    D21 : INT;

    start_edge : R_TRIG;
    state : INT := 0;
    start_requested : BOOL := FALSE;
    ready_to_fire : BOOL := FALSE;
    received_latched : BOOL := FALSE;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q THEN
    start_requested := TRUE;
    received_latched := FALSE;
    ready_to_fire := FALSE;
END_IF;

IF (state >= 4) AND X22 THEN
    received_latched := TRUE;
END_IF;

CASE state OF
    0:
        IF start_requested AND X20 THEN
            start_requested := FALSE;
            Y22 := TRUE;
            state := 1;
        END_IF;
        
    1:
        IF X23 THEN
            Y22 := FALSE;
            state := 2;
        END_IF;
        
    2:
        IF X24 THEN
            state := 3;
        END_IF;
        
    3:
        IF D20 > (D21 + 50) THEN
            ready_to_fire := TRUE;
        END_IF;
        
        IF ready_to_fire AND (D20 <= D21) THEN
            Y20 := TRUE;
            state := 4;
        END_IF;
        
    4:
        IF X21 THEN
            Y20 := FALSE;
            Y21 := TRUE;
            state := 5;
        END_IF;
        
    5:
        IF X20 THEN
            Y21 := FALSE;
            state := 6;
        END_IF;
        
    6:
        IF received_latched THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM