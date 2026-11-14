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
    startEdge : R_TRIG;
    state : INT;
    extendCount : INT;
    returnCount : INT;
    origKey : INT;
    reqKey : INT;
    takeRoute : BOOL;
    placedSeen : BOOL;
    emptiedSeen : BOOL;
END_VAR

startEdge(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF startEdge.Q THEN
            origKey := D20;
            reqKey := D10;
            takeRoute := (D20 = D10);
            extendCount := 0;
            returnCount := 0;
            placedSeen := FALSE;
            emptiedSeen := FALSE;
            state := 5;
        END_IF;

    5:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF X20 THEN
            extendCount := 0;
            returnCount := 0;
            placedSeen := FALSE;
            emptiedSeen := FALSE;
            takeRoute := (origKey = reqKey);
            state := 10;
        END_IF;

    10:
        Y2 := FALSE;
        IF takeRoute THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSE
            Y20 := FALSE;
            Y21 := TRUE;
        END_IF;

        IF extendCount < 30000 THEN
            extendCount := extendCount + 1;
        END_IF;

        IF X21 THEN
            placedSeen := TRUE;
        END_IF;

        IF (extendCount >= 50) AND (D20 = 0) THEN
            emptiedSeen := TRUE;
        END_IF;

        IF takeRoute THEN
            IF (extendCount >= 55) AND placedSeen AND emptiedSeen THEN
                returnCount := 0;
                state := 20;
            END_IF;
        ELSE
            IF (extendCount >= 55) AND emptiedSeen THEN
                returnCount := 0;
                state := 20;
            END_IF;
        END_IF;

    20:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;

        IF returnCount < 30000 THEN
            returnCount := returnCount + 1;
        END_IF;

        IF X21 THEN
            placedSeen := TRUE;
        END_IF;

        IF D20 = 0 THEN
            emptiedSeen := TRUE;
        END_IF;

        IF (returnCount >= 55) AND X20 THEN
            IF takeRoute THEN
                IF placedSeen AND emptiedSeen THEN
                    Y2 := TRUE;
                    state := 30;
                END_IF;
            ELSE
                IF emptiedSeen THEN
                    Y2 := TRUE;
                    state := 30;
                END_IF;
            END_IF;
        END_IF;

    30:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;

ELSE
    Y2 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    state := 0;
END_CASE;

END_PROGRAM