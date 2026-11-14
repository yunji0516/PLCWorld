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
    D20 : INT;
    
    start_edge : R_TRIG;
    spacing_timer : TON;
    timer : TON;
    start_accepted : BOOL := FALSE;
    accepted_D10 : INT := 0;
    state : INT := 0;
END_VAR

// State machine for material placement sequence
// 0: IDLE - wait for start request
// 1: FWD1 - move forward to target position (pickup location)
// 2: DOWN1 - move down to acquire materials
// 3: GRIP - close grips to hold materials
// 4: UP1 - move up with materials (clearance height)
// 5: SPACING - adjust head separation to requested D10
// 6: FWD2 - move forward to release position
// 7: DOWN2 - move down for release
// 8: RELEASE - open grips to release materials
// 9: UP2 - move up to clearance height
// 10: BACK - return to source home position
// 11: COMPLETE - task finished, maintain completion signal

CASE state OF
    0:  (* IDLE: Wait for start request rising edge *)
        start_edge(CLK := X10);
        IF start_edge.Q AND NOT start_accepted THEN
            start_accepted := TRUE;
            accepted_D10 := D10;
            state := 1;
        END_IF;
        
    1:  (* FWD1: Move forward to target for pickup *)
        Y24 := TRUE;
        Y20 := TRUE;
        timer(IN := TRUE, PT := T#1000ms);
        IF X21 OR timer.Q THEN
            state := 2;
        END_IF;
        
    2:  (* DOWN1: Move down to acquire materials *)
        Y24 := TRUE;
        Y20 := FALSE;
        Y23 := TRUE;
        IF X23 THEN
            state := 3;
        END_IF;
        
    3:  (* GRIP: Close grips to hold materials *)
        Y24 := TRUE;
        Y23 := FALSE;
        timer(IN := TRUE, PT := T#500ms);
        IF timer.Q OR X24 THEN
            state := 4;
        END_IF;
        
    4:  (* UP1: Move up to clearance height *)
        Y24 := TRUE;
        Y22 := TRUE;
        IF X22 THEN
            state := 5;
        END_IF;
        
    5:  (* SPACING: Adjust head separation to requested D10 *)
        Y24 := TRUE;
        Y22 := TRUE;
        IF ABS(D20 - accepted_D10) <= 5 THEN
            state := 6;
        ELSE
            IF D20 < accepted_D10 THEN
                Y25 := TRUE;
            ELSE
                Y26 := TRUE;
            END_IF;
            spacing_timer(IN := TRUE, PT := T#5000ms);
            IF spacing_timer.Q THEN
                state := 6;
            END_IF;
        END_IF;
        
    6:  (* FWD2: Move forward to release position at target *)
        Y25 := FALSE;
        Y26 := FALSE;
        Y24 := TRUE;
        Y20 := TRUE;
        timer(IN := TRUE, PT := T#1000ms);
        IF X21 OR timer.Q THEN
            state := 7;
        END_IF;
        
    7:  (* DOWN2: Move down to release position *)
        Y24 := TRUE;
        Y20 := FALSE;
        Y23 := TRUE;
        IF X23 THEN
            state := 8;
        END_IF;
        
    8:  (* RELEASE: Open grips to release materials *)
        Y24 := FALSE;
        Y23 := FALSE;
        timer(IN := TRUE, PT := T#500ms);
        IF timer.Q OR X25 THEN
            state := 9;
        END_IF;
        
    9:  (* UP2: Move up to clearance height *)
        Y24 := FALSE;
        Y22 := TRUE;
        IF X22 THEN
            state := 10;
        END_IF;
        
    10: (* BACK: Return to source home position *)
        Y24 := FALSE;
        Y22 := TRUE;
        Y21 := TRUE;
        timer(IN := TRUE, PT := T#5000ms);
        IF X20 OR timer.Q THEN
            state := 11;
        END_IF;
        
    11: (* COMPLETE: Task finished, maintain completion signal *)
        Y2 := TRUE;
        IF NOT Y20 AND NOT Y21 AND NOT Y22 AND NOT Y23 AND NOT Y24 
           AND NOT Y25 AND NOT Y26 THEN
            (* Completion signal maintained, all actuators off *)
        END_IF;
        
END_CASE;

END_PROGRAM