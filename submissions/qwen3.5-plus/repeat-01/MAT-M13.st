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
    
    startEdge : R_TRIG;
    alignedEdge : R_TRIG;
    targetID : INT := 0;
    state : INT := 0;
    positionsLeft : INT := 0;
    waitingForMisalign : BOOL := FALSE;
END_VAR

startEdge(CLK := X10);
alignedEdge(CLK := X20);

CASE state OF
    0:  (* IDLE - wait for start request *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        
        IF startEdge.Q THEN
            targetID := D10;
            state := 1;
        END_IF;
        
    1:  (* FINDING - rotate CW until target ID is at the reader *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        
        IF X20 AND (D20 = targetID) THEN
            Y20 := FALSE;
            state := 2;
            positionsLeft := 2;
            waitingForMisalign := TRUE;
        END_IF;
        
    2:  (* ROTATE_TO_EJECT - rotate CW 2 positions to bring target to ejector station *)
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        
        IF waitingForMisalign THEN
            Y20 := TRUE;
            Y21 := FALSE;
            IF NOT X20 THEN
                waitingForMisalign := FALSE;
            END_IF;
        ELSE
            Y20 := TRUE;
            Y21 := FALSE;
            
            IF alignedEdge.Q THEN
                positionsLeft := positionsLeft - 1;
                IF positionsLeft <= 0 THEN
                    Y20 := FALSE;
                    state := 3;
                END_IF;
            END_IF;
        END_IF;
        
    3:  (* PUSH - extend pusher to eject item at ejector station *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y2 := FALSE;
        
        IF X22 THEN
            Y22 := FALSE;
            state := 4;
        END_IF;
        
    4:  (* RETRACT - retract pusher back to home position *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y2 := FALSE;
        
        IF X21 THEN
            Y23 := FALSE;
            state := 5;
        END_IF;
        
    5:  (* DONE - claim completion, all actuators OFF *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := TRUE;
        
END_CASE;

END_PROGRAM