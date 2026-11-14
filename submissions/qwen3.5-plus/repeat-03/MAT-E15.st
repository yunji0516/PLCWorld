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
    opened : BOOL;
    done : BOOL;
END_VAR

Y20 := TRUE;
Y21 := TRUE;

start_trig(CLK := X10);

IF NOT done THEN
    IF start_trig.Q THEN
        opened := TRUE;
    END_IF;
    
    IF opened AND D20 < D10 THEN
        Y22 := TRUE;
        Y23 := FALSE;
    ELSE
        Y22 := FALSE;
        Y23 := FALSE;
    END_IF;
    
    IF opened AND D20 >= D10 AND X20 AND X21 THEN
        done := TRUE;
    END_IF;
ELSE
    Y22 := FALSE;
    Y23 := FALSE;
END_IF;

Y2 := done;

END_PROGRAM