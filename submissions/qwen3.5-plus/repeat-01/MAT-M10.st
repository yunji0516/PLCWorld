```st
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
    
    start_edge : R_TRIG;
    release_timer : TON;
    
    sel1 : BOOL;
    sel2 : BOOL;
    sel3 : BOOL;
    
    state : INT;
    start_accepted : BOOL;
END_VAR

// Edge detection for start signal
start_edge(CLK := X10);

// Reset all actuator outputs each scan
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

// State machine
CASE state OF
    0: // IDLE - wait for start signal
        IF start_edge.Q THEN
            start_accepted := TRUE;
            // Decode selection bits from D10
            sel1 := (D10 AND 1) <> 0;
            sel2 := (D10 AND 2) <> 0;
            sel3 := (D10 AND 4) <> 0;
            // If nothing is selected, all stay at source - already there
            IF NOT (sel1 OR sel2 OR sel3) THEN
                state := 8;
            ELSE
                state := 1;
            END_IF;
        END_IF;
        
    1: // GO_TARGET - travel forward to target position
        IF X21 THEN
            state := 2;
        ELSE
            Y20 := TRUE;
        END_IF;
        
    2: // LOWER_AT_TARGET - lower head to release height
        IF X23 THEN
            state := 3;
        ELSE
            Y23 := TRUE;
        END_IF;
        
    3: // RELEASE_SELECTED - release selected materials at target
        IF (sel1 OR sel2 OR sel3) THEN
            IF NOT release_timer.Q THEN
                // Activate release for selected materials only
                Y24 := sel1;
                Y25 := sel2;
                Y26 := sel3;
                release_timer(IN := TRUE, PT := T#120ms);
            ELSE
                // Release complete - deactivate all releases
                Y24 := FALSE;
                Y25 := FALSE;
                Y26 := FALSE;
                release_timer(IN := FALSE);
                state := 4;
            END_IF;
        ELSE
            state := 4;
        END_IF;
        
    4: // LIFT_AT_TARGET - lift head back to high position
        IF X22 THEN
            state := 5;
        ELSE
            Y22 := TRUE;
        END_IF;
        
    5: // RETURN_TO_SOURCE - travel back to source position
        IF X20 THEN
            state := 6;
        ELSE
            Y21 := TRUE;
        END_IF;
        
    6: // LOWER_AT_SOURCE - lower head to release height at source
        IF X23 THEN
            state := 7;
        ELSE
            Y23 := TRUE;
        END_IF;
        
    7: // RELEASE_UNSELECTED - release unselected materials at source
        IF (NOT sel1 OR NOT sel2 OR NOT sel3) THEN
            IF NOT release_timer.Q THEN
                // Activate release for unselected materials only
                Y24 := NOT sel1;
                Y25 := NOT sel2;
                Y26 := NOT sel3;
                release_timer(IN := TRUE, PT := T#120ms);
            ELSE
                // Release complete - deactivate all releases
                Y24 := FALSE;
                Y25 := FALSE;
                Y26 := FALSE;
                release_timer(IN := FALSE);
                state := 8;
            END_IF;
        ELSE
            state := 8;
        END_IF;
        
    8: // LIFT_AT_SOURCE - lift head back to upper position
        IF X22 THEN
            state := 9;
        ELSE
            Y22 := TRUE;
        END_IF;
        
    9: // DONE - completion state
        // Selection complete - all outputs OFF (release may remain)
        Y2 := TRUE;
        
END_CASE;

END_PROGRAM
```