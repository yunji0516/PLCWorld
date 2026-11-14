PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    startPrev : BOOL;
    startEdge : BOOL;
    requested : BOOL;
    mask : INT;
    sel1 : BOOL;
    sel2 : BOOL;
    sel3 : BOOL;
    resultOK : BOOL;
END_VAR

startEdge := X10 AND NOT startPrev;

IF startEdge AND NOT requested THEN
    requested := TRUE;
    mask := D10;

    sel1 := (mask = 1) OR (mask = 3) OR (mask = 5) OR (mask = 7);
    sel2 := (mask = 2) OR (mask = 3) OR (mask = 6) OR (mask = 7);
    sel3 := (mask = 4) OR (mask = 5) OR (mask = 6) OR (mask = 7);
END_IF;

startPrev := X10;

IF requested THEN
    Y20 := sel1;
    Y21 := sel2;
    Y22 := sel3;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_IF;

resultOK := requested
            AND (((sel1 AND NOT X20) OR ((NOT sel1) AND X20)))
            AND (((sel2 AND NOT X21) OR ((NOT sel2) AND X21)))
            AND (((sel3 AND NOT X22) OR ((NOT sel3) AND X22)));

IF resultOK THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM