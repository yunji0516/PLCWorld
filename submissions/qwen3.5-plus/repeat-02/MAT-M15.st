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
    
    forward_count : DINT;
    reverse_count : DINT;
    requested_count : INT;
    op_mode : INT;
    feed_enabled : BOOL;
    dispatch_enabled : BOOL;
    
    prev_state : INT;
    state : INT;
    fwd_phase : INT;
    rev_phase : INT;
    
END_VAR

start_edge(CLK := X10);

prev_state := state;
state := (INT(X20) * 1) + (INT(X21) * 2);

IF fwd_phase = 0 AND state = 1 THEN
    fwd_phase := 1;
ELSIF fwd_phase = 1 AND state = 2 THEN
    fwd_phase := 2;
ELSIF fwd_phase = 2 AND state = 3 THEN
    fwd_phase := 3;
ELSIF fwd_phase = 3 AND state = 0 THEN
    forward_count := forward_count + 1;
    fwd_phase := 0;
END_IF;

IF rev_phase = 0 AND state = 3 THEN
    rev_phase := 1;
ELSIF rev_phase = 1 AND state = 2 THEN
    rev_phase := 2;
ELSIF rev_phase = 2 AND state = 1 THEN
    rev_phase := 3;
ELSIF rev_phase = 3 AND state = 0 THEN
    reverse_count := reverse_count + 1;
    rev_phase := 0;
END_IF;

IF fwd_phase > 0 AND state = 0 AND NOT (prev_state = 3) THEN
    fwd_phase := 0;
END_IF;

IF rev_phase > 0 AND state = 0 AND NOT (prev_state = 1) THEN
    rev_phase := 0;
END_IF;

CASE op_mode OF
    0:
        IF start_edge.Q AND NOT X22 THEN
            requested_count := D10;
            forward_count := 0;
            reverse_count := 0;
            fwd_phase := 0;
            rev_phase := 0;
            op_mode := 1;
        END_IF;
        
    1:
        IF NOT X25 THEN
            IF (forward_count - reverse_count) >= requested_count THEN
                feed_enabled := FALSE;
                op_mode := 2;
            ELSE
                feed_enabled := TRUE;
                IF X22 THEN
                    feed_enabled := FALSE;
                    op_mode := 2;
                END_IF;
            END_IF;
        ELSE
            feed_enabled := FALSE;
            op_mode := 2;
        END_IF;
        
    2:
        IF NOT X22 THEN
            IF (forward_count - reverse_count) >= requested_count THEN
                IF X24 THEN
                    op_mode := 3;
                ELSE
                    op_mode := 1;
                END_IF;
            ELSE
                op_mode := 1;
            END_IF;
        END_IF;
        
    3:
        feed_enabled := FALSE;
        dispatch_enabled := TRUE;
        IF X25 THEN
            op_mode := 4;
        END_IF;
        
    4:
        feed_enabled := FALSE;
        dispatch_enabled := FALSE;
        Y2 := TRUE;
END_CASE;

Y20 := feed_enabled;
Y21 := dispatch_enabled;

END_PROGRAM