PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;
    
    startEdge : R_TRIG;
    state : INT;
    originalKey : INT;
    isTake : BOOL;
END_VAR

startEdge(CLK := X10);

CASE state OF
    0: (* IDLE - wait for start edge *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF startEdge.Q THEN
            state := 1;
        END_IF;
        
    1: (* WAIT_HOME - wait until module is ready *)
        Y20 := FALSE;
        Y21 := FALSE;
        IF X20 THEN
            state := 2;
        END_IF;
        
    2: (* READ_KEY - capture original product key at home *)
        originalKey := D20;
        isTake := (originalKey = D10);
        state := 3;
        
    3: (* MOVE - activate correct actuator, wait for delivery *)
        IF isTake THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSE
            Y20 := FALSE;
            Y21 := TRUE;
        END_IF;
        IF D20 = 0 THEN
            state := 4;
        END_IF;
        
    4: (* RETURN_HOME - both outputs OFF, wait for ready *)
        Y20 := FALSE;
        Y21 := FALSE;
        IF X20 THEN
            state := 5;
        END_IF;
        
    5: (* COMPLETE - hold completion claim *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
        
END_CASE;

END_PROGRAM