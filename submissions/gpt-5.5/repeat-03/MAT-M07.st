PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    D20 : INT;
    startEdge : R_TRIG;
    step : INT;
    targetPitch : INT;
    pitchError : INT;
    pitchOk : BOOL;
END_VAR

startEdge(CLK := X10);

Y2 := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

pitchError := D20 - targetPitch;
pitchOk := (pitchError >= -2) AND (pitchError <= 2);

IF (step = 0) AND startEdge.Q THEN
    targetPitch := D10;
    IF targetPitch < 280 THEN
        targetPitch := 280;
    ELSIF targetPitch > 560 THEN
        targetPitch := 560;
    END_IF;
    step := 10;
END_IF;

CASE step OF
    0:
        Y2 := FALSE;

    10:
        IF X23 THEN
            step := 20;
        ELSE
            Y23 := TRUE;
        END_IF;

    20:
        Y24 := TRUE;
        IF X24 THEN
            step := 30;
        END_IF;

    30:
        Y24 := TRUE;
        IF X22 THEN
            step := 40;
        ELSE
            Y22 := TRUE;
        END_IF;

    40:
        Y24 := TRUE;
        IF X22 THEN
            IF NOT X21 THEN
                Y20 := TRUE;
            END_IF;

            IF D20 < (targetPitch - 2) THEN
                Y25 := TRUE;
            ELSIF D20 > (targetPitch + 2) THEN
                Y26 := TRUE;
            END_IF;

            IF X21 AND pitchOk THEN
                step := 50;
            END_IF;
        ELSE
            Y22 := TRUE;
        END_IF;

    50:
        Y24 := TRUE;
        IF (NOT X21) OR (NOT pitchOk) THEN
            step := 40;
        ELSIF X23 THEN
            step := 60;
        ELSE
            Y23 := TRUE;
        END_IF;

    60:
        IF X23 AND X21 THEN
            IF X25 THEN
                step := 70;
            END_IF;
        ELSE
            Y23 := TRUE;
        END_IF;

    70:
        IF X22 THEN
            step := 80;
        ELSE
            Y22 := TRUE;
        END_IF;

    80:
        IF X22 THEN
            IF X20 THEN
                step := 100;
            ELSE
                Y21 := TRUE;
            END_IF;
        ELSE
            Y22 := TRUE;
        END_IF;

    100:
        Y2 := TRUE;

ELSE
    step := 0;
END_CASE;

END_PROGRAM