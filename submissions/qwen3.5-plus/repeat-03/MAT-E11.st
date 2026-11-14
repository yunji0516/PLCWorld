PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;
    
    start_edge : R_TRIG;
    state : INT := 0;
    edge_ok : BOOL := TRUE;
    complete : BOOL := FALSE;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        edge_ok := TRUE;
        complete := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF start_edge.Q THEN
            state := 1;
        END_IF;
        
    1:
        IF D20 > 10 THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSIF D20 < -10 THEN
            Y20 := FALSE;
            Y21 := TRUE;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
        END_IF;
        
        IF D20 > 12 OR D20 < -12 THEN
            edge_ok := FALSE;
        END_IF;
        
        IF X20 THEN
            state := 2;
            Y20 := FALSE;
            Y21 := FALSE;
            IF edge_ok AND (D20 >= -12) AND (D20 <= 12) THEN
                complete := TRUE;
            ELSE
                complete := FALSE;
            END_IF;
        END_IF;
        
    2:
        Y20 := FALSE;
        Y21 := FALSE;
END_CASE;

Y2 := complete;

END_PROGRAM