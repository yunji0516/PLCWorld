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
    (* Add internal variables here. *)
    startEdge : R_TRIG;
    state : INT;
    originalKey : INT;
    requestedKey : INT;
    takeSelected : BOOL;
    extendCount : INT;
    returnCount : INT;
END_VAR

startEdge(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        extendCount := 0;
        returnCount := 0;
        IF startEdge.Q THEN
            state := 1;
        END_IF;

    1:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        extendCount := 0;
        returnCount := 0;
        IF X20 THEN
            originalKey := D20;
            requestedKey := D10;
            takeSelected := (D20 = D10);
            state := 2;
        END_IF;

    2:
        Y2 := FALSE;
        IF takeSelected THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSE
            Y20 := FALSE;
            Y21 := TRUE;
        END_IF;

        IF extendCount < 1000 THEN
            extendCount := extendCount + 1;
        END_IF;

        IF extendCount >= 60 THEN
            returnCount := 0;
            state := 3;
        END_IF;

    3:
        Y20 := FALSE;
        Y21 := FALSE;

        IF returnCount < 1000 THEN
            returnCount := returnCount + 1;
        END_IF;

        IF (returnCount >= 60) AND X20 THEN
            IF takeSelected THEN
                IF X21 THEN
                    Y2 := TRUE;
                    state := 4;
                ELSE
                    Y2 := FALSE;
                END_IF;
            ELSE
                Y2 := TRUE;
                state := 4;
            END_IF;
        ELSE
            Y2 := FALSE;
        END_IF;

    4:
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