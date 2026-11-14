PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    
    X10_prev : BOOL;
    Req_ID : INT;
    State : INT := 0;
END_VAR

IF X10 AND NOT X10_prev THEN
    IF State = 0 THEN
        Req_ID := D10;
        State := 1;
    END_IF;
END_IF;
X10_prev := X10;

CASE State OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        
    1:
        IF D20 = Req_ID THEN
            Y20 := FALSE;
            Y21 := FALSE;
            State := 3;
        ELSE
            Y21 := FALSE;
            IF X20 THEN
                Y20 := TRUE;
                State := 2;
            END_IF;
        END_IF;
        
    2:
        Y21 := FALSE;
        IF D20 = Req_ID THEN
            Y20 := FALSE;
            State := 3;
        ELSE
            Y20 := TRUE;
        END_IF;
        
    3:
        Y20 := FALSE;
        Y21 := FALSE;
        State := 31;
        
    31:
        Y20 := FALSE;
        Y21 := TRUE;
        State := 4;
        
    4:
        Y20 := FALSE;
        Y21 := TRUE;
        IF X21 THEN
            State := 5;
        END_IF;
        
    5:
        Y21 := TRUE;
        IF X22 THEN
            Y20 := FALSE;
            State := 6;
        ELSE
            Y20 := TRUE;
        END_IF;
        
    6:
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM