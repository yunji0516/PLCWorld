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
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    D20 : INT;
    
    state : INT := 0;
    sel1 : BOOL := FALSE;
    sel2 : BOOL := FALSE;
    sel3 : BOOL := FALSE;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0: // WAIT_START
        IF start_edge.Q THEN
            sel1 := (D10 MOD 2) = 1;
            sel2 := ((D10 DIV 2) MOD 2) = 1;
            sel3 := ((D10 DIV 4) MOD 2) = 1;
            state := 1;
        END_IF;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        
    1: // ENSURE_HIGH_AT_SOURCE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X22 THEN
            state := 2;
        END_IF;
        
    2: // MOVE_TO_TARGET (forward while high)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X21 THEN
            state := 3;
        END_IF;
        
    3: // GO_LOW_AT_TARGET
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X23 THEN
            state := 4;
        END_IF;
        
    4: // RELEASE_SELECTED_AT_TARGET
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := sel1;
        Y25 := sel2;
        Y26 := sel3;
        IF (NOT sel1 OR NOT X26) AND
           (NOT sel2 OR NOT X27) AND
           (NOT sel3 OR NOT X28) THEN
            state := 5;
        END_IF;
        
    5: // GO_HIGH_AT_TARGET
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X22 THEN
            state := 6;
        END_IF;
        
    6: // MOVE_TO_SOURCE (back while high)
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X20 THEN
            state := 7;
        END_IF;
        
    7: // GO_LOW_AT_SOURCE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X23 THEN
            state := 8;
        END_IF;
        
    8: // RELEASE_UNSELECTED_AT_SOURCE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := NOT sel1;
        Y25 := NOT sel2;
        Y26 := NOT sel3;
        IF (sel1 OR NOT X26) AND
           (sel2 OR NOT X27) AND
           (sel3 OR NOT X28) THEN
            state := 9;
        END_IF;
        
    9: // GO_HIGH_AT_SOURCE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X22 THEN
            state := 10;
        END_IF;
        
    10: // COMPLETE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        Y2 := TRUE;
        
END_CASE;

END_PROGRAM