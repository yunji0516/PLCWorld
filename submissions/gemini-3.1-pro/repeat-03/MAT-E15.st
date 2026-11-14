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
    
    started : BOOL;
    x10_prev : BOOL;
    completed : BOOL;
END_VAR

(* Maintain both vacuum commands ON from the first scan *)
Y20 := TRUE;
Y21 := TRUE;

(* Detect start request *)
IF X10 AND NOT x10_prev THEN
    started := TRUE;
END_IF;
x10_prev := X10;

(* Execute opening operation *)
IF started AND NOT completed THEN
    IF D20 >= D10 AND X20 AND X21 THEN
        completed := TRUE;
    ELSE
        Y22 := TRUE;
        Y23 := FALSE;
    END_IF;
END_IF;

(* Maintain completion state or initial safe state *)
IF completed THEN
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := TRUE;
ELSIF NOT started THEN
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := FALSE;
END_IF;

END_PROGRAM