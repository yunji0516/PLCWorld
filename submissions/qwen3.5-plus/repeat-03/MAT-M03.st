PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
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
    X29 : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    Y2 : BOOL;
    
    startEdge : R_TRIG;
    state : INT;
    
    IDLE : INT := 0;
    APPROACH : INT := 1;
    GRIP : INT := 2;
    LIFT : INT := 3;
    TRAVEL : INT := 4;
    APPROACH_TGT : INT := 5;
    PLACE : INT := 6;
    ALIGN : INT := 7;
    RETRACT : INT := 8;
    RETURN : INT := 9;
    LIFT_SRC : INT := 10;
    COMPLETE : INT := 11;
END_VAR

startEdge(CLK := X10);

CASE state OF
    IDLE:
        IF startEdge.Q THEN
            state := APPROACH;
        END_IF;
        
    APPROACH:
        Y21 := TRUE;
        IF X22 THEN
            state := GRIP;
        END_IF;
        
    GRIP:
        Y20 := TRUE;
        IF X24 THEN
            state := LIFT;
        END_IF;
        
    LIFT:
        Y23 := TRUE;
        IF X23 AND X29 THEN
            state := TRAVEL;
        END_IF;
        
    TRAVEL:
        Y21 := TRUE;
        IF X21 THEN
            state := APPROACH_TGT;
        END_IF;
        
    APPROACH_TGT:
        Y24 := TRUE;
        IF X22 THEN
            state := PLACE;
        END_IF;
        
    PLACE:
        Y20 := FALSE;
        IF X25 THEN
            state := ALIGN;
        END_IF;
        
    ALIGN:
        Y25 := TRUE;
        Y26 := TRUE;
        IF X30 THEN
            state := RETRACT;
        END_IF;
        
    RETRACT:
        Y25 := FALSE;
        Y26 := FALSE;
        IF X29 THEN
            state := RETURN;
        END_IF;
        
    RETURN:
        Y22 := TRUE;
        IF X20 THEN
            state := LIFT_SRC;
        END_IF;
        
    LIFT_SRC:
        Y23 := TRUE;
        IF X23 THEN
            state := COMPLETE;
        END_IF;
        
    COMPLETE:
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