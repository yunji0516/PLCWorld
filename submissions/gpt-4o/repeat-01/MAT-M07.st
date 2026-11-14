```iecst
PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    Y24 : BOOL := FALSE;
    Y25 : BOOL := FALSE;
    Y26 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    D20 : INT;
    start_triggered : BOOL := FALSE;
    target_spacing : INT;
    state : INT := 0;
    edge_start : R_TRIG;
END_VAR

edge_start(CLK := X10);

IF edge_start.Q THEN
    start_triggered := TRUE;
    target_spacing := D10;
END_IF

IF start_triggered THEN
    CASE state OF
        0: (* Move down to low position to acquire materials *)
            IF NOT X23 THEN
                Y23 := TRUE; (* Command down *)
            ELSE
                Y23 := FALSE;
                state := 1; (* Proceed to next state *)
            END_IF

        1: (* Grip materials *)
            IF NOT X24 THEN
                Y24 := TRUE; (* Command grip ON *)
            ELSE
                Y24 := FALSE;
                state := 2; (* Proceed to next state *)
            END_IF
        
        2: (* Move up above 220 mm for clearance *)
            IF NOT X22 THEN
                Y22 := TRUE; (* Command up *)
            ELSE
                Y22 := FALSE;
                state := 3; (* Proceed to next state *)
            END_IF
        
        3: (* Adjust spacing to target_spacing *)
            IF D20 < target_spacing THEN
                Y25 := TRUE; (* Command widen *)
            ELSIF D20 > target_spacing THEN
                Y26 := TRUE; (* Command narrow *)
            ELSE
                Y25 := FALSE;
                Y26 := FALSE;
                state := 4; (* Proceed to next state *)
            END_IF
        
        4: (* Move forward to target *)
            IF NOT X21 THEN
                Y20 := TRUE; (* Command forward *)
            ELSE
                Y20 := FALSE;
                state := 5; (* Proceed to next state *)
            END_IF
        
        5: (* Move down to place materials at target *)
            IF NOT X23 THEN
                Y23 := TRUE; (* Command down *)
            ELSE
                Y23 := FALSE;
                state := 6; (* Proceed to next state *)
            END_IF

        6: (* Release materials *)
            IF NOT X25 THEN
                Y24 := FALSE; (* Command grip OFF *)
            ELSE
                state := 7; (* Proceed to next state *)
            END_IF
        
        7: (* Move up again above 220 mm for clearance *)
            IF NOT X22 THEN
                Y22 := TRUE; (* Command up *)
            ELSE
                Y22 := FALSE;
                state := 8; (* Proceed to next state *)
            END_IF
        
        8: (* Move back to source upper position *)
            IF NOT X20 THEN
                Y21 := TRUE; (* Command back *)
            ELSE
                Y21 := FALSE;
                Y2 := TRUE;   (* Set completion flag *)
                state := 9; (* Final state, maintain until end *)
            END_IF
        
        9: (* Idle state with completion held *)
            (* Maintain outputs for valid terminal result *)
            Y2 := TRUE;
    END_CASE
END_IF

END_PROGRAM
```