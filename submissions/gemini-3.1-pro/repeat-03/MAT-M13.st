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
    
    start_edge : R_TRIG;
    state : INT := 0;
    target_id : INT := 0;
    eject_index : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q THEN
            target_id := D10;
            (* Check if the target is already at the reader upon starting *)
            IF X20 AND (D20 = target_id) THEN
                eject_index := (D21 + 2) MOD 4;
                state := 2;
            ELSE
                state := 1;
            END_IF
        END_IF
        
    1:
        (* Rotate and search for the target ID *)
        IF X20 THEN
            IF D20 = target_id THEN
                eject_index := (D21 + 2) MOD 4;
                state := 2;
            END_IF
        END_IF
        
    2:
        (* Rotate until the target pocket reaches the ejector (180 degrees offset) *)
        IF X20 AND (D21 = eject_index) THEN
            state := 21;
        END_IF
        
    21:
        (* 1-scan deadband to guarantee carousel has completely stopped before pushing *)
        state := 3;
        
    3:
        (* Push item into receiver *)
        IF X22 THEN
            state := 31;
        END_IF
        
    31:
        (* 1-scan deadband to ensure no opposing actuator commands overlap *)
        state := 4;
        
    4:
        (* Retract pusher back home *)
        IF X21 THEN
            state := 5;
        END_IF
        
    5:
        (* Sequence complete, maintain terminal result *)
        ; 
END_CASE

Y20 := (state = 1) OR (state = 2);
Y21 := FALSE;
Y22 := (state = 3);
Y23 := (state = 4);
Y2  := (state = 5);

END_PROGRAM