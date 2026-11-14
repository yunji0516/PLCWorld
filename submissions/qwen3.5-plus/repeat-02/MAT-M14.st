PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    D20 : INT;
    D21 : INT;
    
    start_edge : R_TRIG;
    pusher_timer : TON;
    
    state : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0: (* WAIT_START - wait for start request edge and product availability *)
        Y22 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF start_edge.Q AND D10 >= 1 THEN
            state := 1;
        END_IF;
        
    1: (* SUPPLY_FORWARD - advance supply finger to load product into launch nest *)
        Y22 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF X23 THEN
            state := 2;
        END_IF;
        
    2: (* SUPPLY_RETRACT - withdraw supply finger back to home *)
        Y22 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF X24 THEN
            state := 3;
        END_IF;
        
    3: (* WAIT_POCKET - wait for receiving pocket to approach within tolerance *)
        Y22 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF D20 <= 30 THEN
            pusher_timer(IN := TRUE, PT := T#1s);
            state := 4;
        END_IF;
        
    4: (* FIRE_PUSH - extend launch pusher for exactly 1.0 s *)
        Y22 := FALSE;
        Y20 := TRUE;
        Y21 := FALSE;
        pusher_timer(IN := TRUE, PT := T#1s);
        IF pusher_timer.Q THEN
            state := 5;
        END_IF;
        
    5: (* RETRACK - retract pusher for 1.0 s *)
        Y22 := FALSE;
        Y20 := FALSE;
        Y21 := TRUE;
        pusher_timer(IN := TRUE, PT := T#1s);
        IF pusher_timer.Q THEN
            state := 6;
        END_IF;
        
    6: (* RECEIVED - wait for pusher to reach home position *)
        Y22 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF X20 THEN
            state := 7;
        END_IF;
        
    7: (* COMPLETE - hold Y2 asserted *)
        Y2 := TRUE;
        Y22 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
END_CASE;

END_PROGRAM