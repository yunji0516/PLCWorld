PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;
    D21 : INT;
    startEdge : R_TRIG;
    state : INT := 0;
    targetVol : INT := 0;
END_VAR

startEdge(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF startEdge.Q THEN
            state := 1;
            targetVol := D10;
        END_IF;
    1:
        Y20 := TRUE;
        Y21 := FALSE;
        IF X20 THEN
            state := 2;
        END_IF;
    2:
        Y20 := TRUE;
        Y21 := TRUE;
        IF D20 >= targetVol - 1 THEN
            state := 3;
        END_IF;
    3:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X21 THEN
            state := 4;
        END_IF;
    4:
        Y20 := FALSE;
        Y21 := FALSE;
        IF (D20 >= targetVol - 2) AND (D20 <= targetVol + 2) THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM