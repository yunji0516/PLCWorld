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
    startEdge : R_TRIG;
    started : BOOL;
    targetReached : BOOL;
    requiredReading : INT;
END_VAR

Y20 := TRUE;
Y21 := TRUE;
Y23 := FALSE;

startEdge(CLK := X10);

IF startEdge.Q THEN
    started := TRUE;
END_IF;

requiredReading := D10 + 1;

IF started AND X20 AND X21 AND (D20 >= requiredReading) THEN
    targetReached := TRUE;
END_IF;

IF started AND NOT targetReached THEN
    Y22 := TRUE;
ELSE
    Y22 := FALSE;
END_IF;

IF targetReached AND X20 AND X21 THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM