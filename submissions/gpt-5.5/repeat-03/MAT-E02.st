PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    startEdge : R_TRIG;
    firstScan : BOOL := TRUE;
    startSeen : BOOL;
    releaseStarted : BOOL;
    completeLatch : BOOL;
END_VAR

startEdge(CLK := X10);

IF startEdge.Q THEN
    startSeen := TRUE;
END_IF;

IF firstScan THEN
    Y20 := TRUE;
    Y2 := FALSE;
    firstScan := FALSE;
ELSE
    IF startSeen THEN
        releaseStarted := TRUE;
    END_IF;

    IF releaseStarted THEN
        Y20 := FALSE;
    ELSE
        Y20 := TRUE;
    END_IF;

    IF releaseStarted AND (NOT X20) AND X21 AND X22 THEN
        completeLatch := TRUE;
    END_IF;

    Y2 := completeLatch;
END_IF;

END_PROGRAM