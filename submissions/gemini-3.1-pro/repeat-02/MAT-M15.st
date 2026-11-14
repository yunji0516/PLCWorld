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
    
    active : BOOL;
    net_count : INT;
    ab_state : INT;
    passage_state : INT;
    start_edge : R_TRIG;
    dispatching : BOOL;
    dispatched_done : BOOL;
END_VAR

start_edge(CLK := X10);
IF start_edge.Q THEN
    active := TRUE;
END_IF;

ab_state := 0;
IF X20 THEN ab_state := ab_state + 1; END_IF;
IF X21 THEN ab_state := ab_state + 2; END_IF;

CASE passage_state OF
    0:
        IF ab_state = 1 THEN 
            passage_state := 1;
        ELSIF ab_state = 2 THEN 
            passage_state := -1;
        END_IF;
    1:
        IF ab_state = 3 THEN 
            passage_state := 2;
        ELSIF ab_state = 0 THEN 
            passage_state := 0;
        END_IF;
    2:
        IF ab_state = 2 THEN 
            passage_state := 3;
        ELSIF ab_state = 1 THEN 
            passage_state := 1;
        END_IF;
    3:
        IF ab_state = 0 THEN 
            net_count := net_count + 1; 
            passage_state := 0;
        ELSIF ab_state = 3 THEN 
            passage_state := 2;
        END_IF;
    -1:
        IF ab_state = 3 THEN 
            passage_state := -2;
        ELSIF ab_state = 0 THEN 
            passage_state := 0;
        END_IF;
    -2:
        IF ab_state = 1 THEN 
            passage_state := -3;
        ELSIF ab_state = 2 THEN 
            passage_state := -1;
        END_IF;
    -3:
        IF ab_state = 0 THEN 
            net_count := net_count - 1; 
            passage_state := 0;
        ELSIF ab_state = 3 THEN 
            passage_state := -2;
        END_IF;
END_CASE;

Y20 := active AND (net_count < D10) AND NOT dispatching AND NOT dispatched_done;

IF active AND NOT dispatched_done THEN
    IF (net_count = D10) AND X23 AND X24 AND NOT X22 AND NOT Y20 THEN
        dispatching := TRUE;
    END_IF;
END_IF;

IF dispatching AND X25 THEN
    dispatching := FALSE;
    dispatched_done := TRUE;
END_IF;

Y21 := dispatching;
Y2 := dispatched_done;

END_PROGRAM