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
    count_state : INT := 0;
    forward_count : INT := 0;
    reverse_count : INT := 0;
    net_count : INT := 0;
    requested_count : INT := 0;
    main_state : INT := 0;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q AND main_state = 0 THEN
    requested_count := D10;
    main_state := 1;
END_IF;

CASE count_state OF
    0:
        IF X20 AND NOT X21 THEN
            count_state := 1;
        ELSIF NOT X20 AND X21 THEN
            count_state := 4;
        END_IF;
    1:
        IF X20 AND X21 THEN
            count_state := 2;
        ELSIF NOT X20 AND NOT X21 THEN
            count_state := 0;
        END_IF;
    2:
        IF NOT X20 AND X21 THEN
            count_state := 3;
        ELSIF X20 AND NOT X21 THEN
            count_state := 1;
        END_IF;
    3:
        IF NOT X20 AND NOT X21 THEN
            forward_count := forward_count + 1;
            count_state := 0;
        END_IF;
    4:
        IF X20 AND X21 THEN
            count_state := 5;
        ELSIF NOT X20 AND NOT X21 THEN
            count_state := 0;
        END_IF;
    5:
        IF X20 AND NOT X21 THEN
            count_state := 6;
        ELSIF NOT X20 AND X21 THEN
            count_state := 4;
        END_IF;
    6:
        IF NOT X20 AND NOT X21 THEN
            reverse_count := reverse_count + 1;
            count_state := 0;
        END_IF;
END_CASE;

net_count := forward_count - reverse_count;

CASE main_state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
    1:
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF net_count >= requested_count THEN
            Y20 := FALSE;
            main_state := 2;
        END_IF;
    2:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF X23 AND NOT X22 THEN
            main_state := 3;
        END_IF;
    3:
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := FALSE;
        IF X25 THEN
            Y21 := FALSE;
            main_state := 4;
        END_IF;
    4:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM