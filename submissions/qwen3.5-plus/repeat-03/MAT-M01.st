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
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;
    
    start_edge : R_TRIG;
    state : INT;
    target : INT;
    buffer_needed : INT;
    unwind_to : INT;
END_VAR

CASE state OF
    0: // WAIT_START
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        start_edge(CLK := X10);
        IF start_edge.Q THEN
            target := D10;
            buffer_needed := 80 + target;
            unwind_to := buffer_needed;
            IF unwind_to > 900 THEN
                unwind_to := 900;
            END_IF;
            IF D20 >= unwind_to THEN
                state := 4;
            ELSE
                state := 3;
            END_IF;
        END_IF;
        
    3: // UNWIND
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        IF D20 >= unwind_to THEN
            Y26 := FALSE;
            state := 4;
        ELSE
            Y26 := TRUE;
        END_IF;
        
    4: // CLOSE_GRIP
        Y22 := TRUE;
        Y23 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X22 THEN
            state := 5;
        END_IF;
        
    5: // FORWARD
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF D21 >= (target - 3) THEN
            Y20 := FALSE;
            state := 6;
        ELSE
            Y20 := TRUE;
        END_IF;
        
    6: // STOP_BEFORE_RECEIVER
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X21 AND (D21 >= (target - 3)) AND (D21 <= (target + 3)) THEN
            state := 7;
        END_IF;
        
    7: // CLOSE_RECEIVER
        Y24 := TRUE;
        Y25 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y26 := FALSE;
        IF X24 THEN
            state := 8;
        END_IF;
        
    8: // OPEN_GRIP_AFTER_RECEIVE
        Y23 := TRUE;
        Y22 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X23 THEN
            state := 9;
        END_IF;
        
    9: // REVERSE
        Y20 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X20 THEN
            Y21 := FALSE;
            state := 10;
        ELSE
            Y21 := TRUE;
        END_IF;
        
    10: // HOME
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X20 AND X21 THEN
            state := 11;
        END_IF;
        
    11: // COMPLETE
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
END_CASE;

END_PROGRAM