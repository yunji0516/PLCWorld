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

    start_trig : R_TRIG;
    started : BOOL;
    opened : BOOL;
    completed : BOOL;
END_VAR

Y20 := TRUE;
Y21 := TRUE;
Y23 := FALSE;

start_trig(CLK := X10);
IF start_trig.Q THEN
    started := TRUE;
END_IF;

IF started AND NOT opened THEN
    IF (D20 >= (D10 + 2)) OR X22 THEN
        opened := TRUE;
        Y22 := FALSE;
    ELSE
        Y22 := TRUE;
    END_IF;
ELSE
    Y22 := FALSE;
END_IF;

IF opened AND NOT completed THEN
    IF (D20 >= D10) AND X20 AND X21 THEN
        completed := TRUE;
    END_IF;
END_IF;

IF completed THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM