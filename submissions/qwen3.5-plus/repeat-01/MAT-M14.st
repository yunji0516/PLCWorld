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
    
    state : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:  (* IDLE - wait for start request *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF start_edge.Q AND D10 = 1 THEN
            state := 1;
        END_IF;
        
    1:  (* SUPPLY_OUT - advance supply finger into nest *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := X20;
        IF X23 AND X20 THEN
            state := 2;
        END_IF;
        
    2:  (* SUPPLY_IN - retract supply finger *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF X24 THEN
            state := 3;
        END_IF;
        
    3:  (* WAIT_POCKET - wait for correct pocket timing *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF D20 <= D21 + 30 THEN
            state := 4;
        END_IF;
        
    4:  (* FIRE - extend launch pusher *)
        Y2 := FALSE;
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF X21 THEN
            state := 5;
        END_IF;
        
    5:  (* WAIT_RECEIVED - wait for pocket to receive product *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF X22 THEN
            state := 6;
        END_IF;
        
    6:  (* RETRACT_PUSH - retract launch pusher *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        IF X20 THEN
            state := 7;
        END_IF;
        
    7:  (* DONE - all actuator outputs OFF, Y2 held *)
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
END_CASE;

END_PROGRAM