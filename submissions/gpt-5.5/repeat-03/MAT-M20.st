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
    X24 : BOOL;
    X25 : BOOL;
    D20 : INT;
    startEdge : R_TRIG;
    accepted : BOOL;
    requestValue : INT;
    state : INT;
END_VAR

startEdge(CLK := X10);

IF (NOT accepted) AND startEdge.Q THEN
    accepted := TRUE;
    requestValue := D10;
    IF D10 = 1 THEN
        state := 10;
    END_IF;
END_IF;

IF accepted AND (requestValue = 1) AND (state <> 100) THEN
    CASE state OF
        0:
            state := 10;

        10:
            IF X20 THEN
                state := 20;
            END_IF;

        20:
            IF X23 AND X25 AND (D20 >= 699) THEN
                state := 30;
            END_IF;

        30:
            IF X21 THEN
                state := 40;
            END_IF;

        40:
            IF X22 AND X21 AND (D20 >= 699) THEN
                state := 100;
            END_IF;

        ELSE
            state := 0;
    END_CASE;
END_IF;

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

IF state = 100 THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;

    IF accepted AND (requestValue = 1) THEN
        CASE state OF
            10:
                Y20 := TRUE;

            20:
                Y22 := TRUE;

            30:
                Y21 := TRUE;

            40:
                Y23 := TRUE;
        END_CASE;
    END_IF;
END_IF;

END_PROGRAM