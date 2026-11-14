PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    
    state : INT := 0;
    target_id : INT := 0;
    target_index : INT := 0;
    next_index : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0: (* Wait for start request *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF start_edge.Q THEN
            target_id := D10;
            state := 1;
        END_IF;
        
    1: (* Evaluate current pocket at reader (station 0) *)
        Y20 := FALSE;
        IF X20 AND X21 THEN
            IF D20 = target_id THEN
                (* Target found at reader. Ejector is at station 2, which is 2 index steps away. *)
                target_index := (D21 + 2) MOD 4;
                state := 3;
            ELSE
                (* Target not found, setup scan for the next index. *)
                next_index := (D21 + 1) MOD 4;
                state := 2;
            END_IF;
        END_IF;
        
    2: (* Rotate CW to next index to continue scanning *)
        IF D21 = next_index AND X20 THEN
            Y20 := FALSE;
            state := 1;
        ELSE
            Y20 := TRUE;
        END_IF;
        
    3: (* Rotate CW to position target item at the ejector (station 2) *)
        IF D21 = target_index AND X20 THEN
            Y20 := FALSE;
            state := 4;
        ELSE
            Y20 := TRUE;
        END_IF;
        
    4: (* Push item *)
        IF X22 THEN
            Y22 := FALSE;
            state := 5;
        ELSE
            Y22 := TRUE;
            Y23 := FALSE;
        END_IF;
        
    5: (* Retract pusher *)
        IF X21 THEN
            Y23 := FALSE;
            state := 6;
        ELSE
            Y22 := FALSE;
            Y23 := TRUE;
        END_IF;
        
    6: (* Task completed, maintain terminal state *)
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
END_CASE;

END_PROGRAM