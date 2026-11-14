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
    
    start_req : BOOL;
    dispatch_cmd : BOOL;
    completed : BOOL;
    
    current_ab : INT;
    last_ab : INT;
    origin : INT;
    net_count : INT;
    
    retreat_in_progress : BOOL;
    
    settle_timer : TON;
    r_trig_x10 : R_TRIG;
END_VAR

r_trig_x10(CLK := X10);
IF r_trig_x10.Q THEN
    start_req := TRUE;
END_IF;

IF X20 AND NOT X21 THEN
    current_ab := 1;
ELSIF X20 AND X21 THEN
    current_ab := 2;
ELSIF NOT X20 AND X21 THEN
    current_ab := 3;
ELSE
    current_ab := 0;
END_IF;

IF current_ab <> last_ab THEN
    IF current_ab = 1 AND last_ab = 0 THEN
        origin := -1;
    ELSIF current_ab = 3 AND last_ab = 0 THEN
        origin := 1;
    END_IF;
    
    IF current_ab = 0 THEN
        IF last_ab = 3 AND origin = -1 THEN
            net_count := net_count + 1;
        ELSIF last_ab = 1 AND origin = 1 THEN
            net_count := net_count - 1;
        END_IF;
        
        IF last_ab = 1 THEN
            retreat_in_progress := TRUE;
        END_IF;
        
        origin := 0;
    END_IF;
    
    last_ab := current_ab;
END_IF;

IF NOT X22 THEN
    retreat_in_progress := FALSE;
END_IF;

IF start_req AND (net_count < D10) AND NOT dispatch_cmd AND NOT completed THEN
    IF X23 THEN
        IF (X22 AND (net_count > 0)) OR retreat_in_progress THEN
            Y20 := FALSE;
        ELSE
            Y20 := TRUE;
        END_IF;
    ELSE
        IF origin = 1 THEN
            Y20 := FALSE;
        ELSE
            Y20 := TRUE;
        END_IF;
    END_IF;
ELSE
    Y20 := FALSE;
END_IF;

settle_timer(IN := (net_count = D10) AND X23 AND NOT X22 AND X24, PT := T#6000ms);

IF start_req AND (net_count = D10) AND settle_timer.Q THEN
    dispatch_cmd := TRUE;
END_IF;

IF dispatch_cmd AND X25 THEN
    dispatch_cmd := FALSE;
    completed := TRUE;
END_IF;

Y21 := dispatch_cmd;
Y2 := completed;

END_PROGRAM