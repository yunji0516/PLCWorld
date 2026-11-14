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
    D20 : INT;
    
    start_flag : BOOL;
    prev_X10 : BOOL;
    completed : BOOL;
END_VAR

(* Maintain both vacuum commands ON from the first scan *)
Y20 := TRUE;
Y21 := TRUE;

(* Close command is never asserted *)
Y23 := FALSE;

(* Detect rising edge on Start request *)
IF X10 AND NOT prev_X10 THEN
    start_flag := TRUE;
END_IF;
prev_X10 := X10;

(* Control opening actuator *)
IF start_flag AND NOT completed THEN
    IF D20 < D10 THEN
        Y22 := TRUE;
    ELSE
        Y22 := FALSE;
        completed := TRUE;
    END_IF;
ELSE
    Y22 := FALSE;
END_IF;

(* Assert completion claim once target width is achieved and actuators are stopped *)
Y2 := completed;

END_PROGRAM