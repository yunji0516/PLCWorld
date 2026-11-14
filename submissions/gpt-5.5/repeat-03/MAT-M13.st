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
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    (* Add internal variables here. *)
    startEdge : R_TRIG;
    state : INT := 0;
    requestId : INT := 0;
    targetIndex : INT := 0;
    stepsLeft : INT := 0;
    afterMove : INT := 0;
END_VAR

startEdge(CLK := X10);

Y2 := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

IF state = 0 THEN
    IF startEdge.Q THEN
        requestId := D10;
        state := 10;
    END_IF;
END_IF;

CASE state OF
    0:
        Y2 := FALSE;

    10:
        IF X20 THEN
            targetIndex := D21 + 1;
            IF targetIndex >= 4 THEN
                targetIndex := targetIndex - 4;
            END_IF;

            IF (D20 = requestId) AND (requestId <> 0) THEN
                stepsLeft := 2;
                afterMove := 1;
            ELSE
                stepsLeft := 1;
                afterMove := 0;
            END_IF;

            state := 20;
        END_IF;

    20:
        IF X20 AND (D21 = targetIndex) THEN
            stepsLeft := stepsLeft - 1;

            IF stepsLeft <= 0 THEN
                IF afterMove = 0 THEN
                    state := 10;
                ELSE
                    state := 30;
                END_IF;
            ELSE
                targetIndex := targetIndex + 1;
                IF targetIndex >= 4 THEN
                    targetIndex := targetIndex - 4;
                END_IF;
            END_IF;
        ELSE
            IF X21 THEN
                Y20 := TRUE;
            END_IF;
        END_IF;

    30:
        IF X20 THEN
            IF X22 THEN
                state := 40;
            ELSE
                Y22 := TRUE;
            END_IF;
        END_IF;

    40:
        IF X21 THEN
            IF X20 AND X23 THEN
                state := 50;
            END_IF;
        ELSE
            Y23 := TRUE;
        END_IF;

    50:
        Y2 := TRUE;

    ELSE
        state := 0;
END_CASE;

IF state = 50 THEN
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
END_IF;

END_PROGRAM