PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL;
    Y2 : BOOL;
    
    initial_position : DINT;
    maintenance_count : INT;
    retention_count : INT;
    state : INT;
    request_edge : R_TRIG;
END_VAR

request_edge(CLK := X10);

CASE state OF
    0:
        IF request_edge.Q THEN
            initial_position := D11;
            Y20 := TRUE;
            state := 1;
        END_IF;
        
    1:
        Y20 := TRUE;
        IF X11 AND NOT X12 THEN
            state := 2;
            maintenance_count := 0;
        END_IF;
        
    2:
        Y20 := TRUE;
        IF ABS(D11 - initial_position) <= 20 THEN
            maintenance_count := maintenance_count + 1;
        ELSE
            maintenance_count := 0;
        END_IF;
        
        IF maintenance_count >= 3 THEN
            state := 3;
            retention_count := 0;
            Y2 := TRUE;
        END_IF;
        
    3:
        Y20 := TRUE;
        Y2 := TRUE;
        IF ABS(D11 - initial_position) > 20 THEN
            state := 2;
            Y2 := FALSE;
            maintenance_count := 0;
        ELSE
            IF retention_count < 10 THEN
                retention_count := retention_count + 1;
            END_IF;
        END_IF;
END_CASE;

IF state = 0 THEN
    Y20 := FALSE;
END_IF;

END_PROGRAM