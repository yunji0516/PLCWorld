PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    startEdge : R_TRIG;
    active : BOOL;
    seenBlocked : BOOL;
    complete : BOOL;
END_VAR

startEdge(CLK := X10);

IF startEdge.Q AND (D10 = 1) AND NOT active AND NOT complete THEN
    active := TRUE;
    seenBlocked := FALSE;
END_IF;

IF active AND NOT complete THEN
    IF X20 THEN
        seenBlocked := TRUE;
    END_IF;

    IF seenBlocked AND NOT X20 THEN
        complete := TRUE;
        active := FALSE;
    END_IF;
END_IF;

IF complete THEN
    Y20 := FALSE;
    Y2 := TRUE;
ELSIF active THEN
    Y20 := TRUE;
    Y2 := FALSE;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
END_IF;

END_PROGRAM