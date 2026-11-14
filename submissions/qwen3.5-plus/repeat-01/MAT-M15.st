PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    
    start_edge : R_TRIG;
    pass_state : INT := 0;
    net_count : INT := 0;
    target_count : INT := 0;
    started : BOOL := FALSE;
    dispatching : BOOL := FALSE;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q THEN
    started := TRUE;
    target_count := D10;
    net_count := 0;
    pass_state := 0;
    dispatching := FALSE;
END_IF;

IF pass_state = 0 THEN
    IF X20 AND NOT X21 THEN pass_state := 1;
    ELSIF NOT X20 AND X21 THEN pass_state := 3;
    END_IF;
ELSIF pass_state = 1 THEN
    IF X20 AND X21 THEN pass_state := 2;
    ELSIF NOT X20 AND NOT X21 THEN pass_state := 0; net_count := net_count - 1;
    END_IF;
ELSIF pass_state = 2 THEN
    IF NOT X20 AND X21 THEN pass_state := 3;
    ELSIF X20 AND NOT X21 THEN pass_state := 1;
    END_IF;
ELSIF pass_state = 3 THEN
    IF NOT X20 AND NOT X21 THEN pass_state := 0; net_count := net_count + 1;
    ELSIF X20 AND X21 THEN pass_state := 2;
    END_IF;
END_IF;

IF NOT started THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
ELSIF NOT dispatching THEN
    IF net_count < target_count THEN
        Y20 := TRUE;
    ELSE
        Y20 := FALSE;
    END_IF;
    
    Y21 := FALSE;
    Y2 := FALSE;
    
    IF net_count == target_count AND X23 AND X24 AND NOT X22 THEN
        dispatching := TRUE;
        Y21 := TRUE;
    END_IF;
ELSE
    Y21 := TRUE;
    Y20 := FALSE;
    
    IF X25 THEN
        Y21 := FALSE;
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM