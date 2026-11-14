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
    Y27 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    D20 : INT;
    D21 : INT;
    startEdge : R_TRIG;
    started : BOOL;
    complete : BOOL;
    state : INT;
    reqValue : INT;
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
Y27 := FALSE;

IF (NOT started) AND (NOT complete) THEN
    IF startEdge.Q THEN
        reqValue := D10;
        IF reqValue = 1 THEN
            started := TRUE;
            state := 10;
        END_IF;
    END_IF;
END_IF;

IF complete THEN
    Y2 := TRUE;
    Y21 := TRUE;
ELSIF started THEN
    CASE state OF
        10:
            Y21 := TRUE;
            IF X28 AND X21 THEN
                state := 20;
            END_IF;

        20:
            Y21 := TRUE;
            IF X27 THEN
                state := 30;
            ELSE
                Y26 := TRUE;
            END_IF;

        30:
            Y21 := TRUE;
            IF X22 AND X25 THEN
                state := 40;
            ELSIF X22 THEN
                Y24 := TRUE;
            ELSE
                Y22 := TRUE;
            END_IF;

        40:
            Y21 := TRUE;
            IF X25 THEN
                IF X23 THEN
                    state := 50;
                ELSE
                    Y23 := TRUE;
                END_IF;
            ELSE
                IF X22 THEN
                    Y24 := TRUE;
                ELSE
                    Y22 := TRUE;
                END_IF;
            END_IF;

        50:
            Y21 := TRUE;
            Y20 := TRUE;
            IF X25 AND X23 AND X20 THEN
                state := 60;
            END_IF;

        60:
            Y21 := TRUE;
            Y20 := TRUE;
            IF X22 THEN
                state := 70;
            ELSE
                Y22 := TRUE;
            END_IF;

        70:
            Y21 := TRUE;
            Y20 := TRUE;
            IF X22 AND X24 THEN
                state := 80;
            ELSIF X22 THEN
                Y25 := TRUE;
            ELSE
                Y22 := TRUE;
            END_IF;

        80:
            Y21 := TRUE;
            Y20 := TRUE;
            IF X24 THEN
                IF X23 THEN
                    state := 90;
                ELSE
                    Y23 := TRUE;
                END_IF;
            ELSE
                IF X22 THEN
                    Y25 := TRUE;
                ELSE
                    Y22 := TRUE;
                END_IF;
            END_IF;

        90:
            Y21 := TRUE;
            IF X24 AND X23 AND X26 AND (NOT X20) THEN
                state := 100;
            END_IF;

        100:
            Y21 := TRUE;
            IF X22 THEN
                state := 110;
            ELSE
                Y22 := TRUE;
            END_IF;

        110:
            Y21 := TRUE;
            IF X22 AND X24 AND X26 AND X27 AND X21 AND (NOT X20) THEN
                complete := TRUE;
                Y2 := TRUE;
                state := 120;
            END_IF;

        120:
            complete := TRUE;
            Y2 := TRUE;
            Y21 := TRUE;

        ELSE
            Y21 := TRUE;
    END_CASE;
END_IF;

END_PROGRAM