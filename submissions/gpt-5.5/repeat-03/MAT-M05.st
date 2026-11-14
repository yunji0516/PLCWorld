PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
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
    X29 : BOOL;
    D20 : INT;
    D22 : INT;
    startEdge : R_TRIG;
    started : BOOL;
    done : BOOL;
    state : INT;
    layer : INT;
    acceptedRequest : INT;
    recipe : ARRAY[1..4] OF INT;
END_VAR

startEdge(CLK := X10);

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y26 := FALSE;
Y27 := FALSE;

IF (NOT started) AND (NOT done) THEN
    IF startEdge.Q THEN
        acceptedRequest := D10;
        recipe[1] := D11;
        recipe[2] := D12;
        recipe[3] := D13;
        recipe[4] := D14;
        IF acceptedRequest = 4 THEN
            layer := 1;
            state := 10;
            started := TRUE;
        END_IF;
    END_IF;
END_IF;

IF started AND (NOT done) THEN
    CASE state OF
        10:
            IF recipe[layer] = 0 THEN
                IF NOT X23 THEN
                    Y23 := TRUE;
                ELSIF X20 THEN
                    IF X27 AND X29 THEN
                        state := 20;
                    END_IF;
                ELSE
                    Y21 := TRUE;
                END_IF;
            ELSE
                IF NOT X23 THEN
                    Y23 := TRUE;
                ELSIF X21 THEN
                    IF X27 AND X29 THEN
                        state := 20;
                    END_IF;
                ELSE
                    Y22 := TRUE;
                END_IF;
            END_IF;

        20:
            IF X24 THEN
                state := 30;
            ELSE
                Y24 := TRUE;
            END_IF;

        30:
            Y20 := TRUE;
            IF X25 THEN
                state := 40;
            END_IF;

        40:
            Y20 := TRUE;
            IF X23 THEN
                state := 50;
            ELSE
                Y23 := TRUE;
            END_IF;

        50:
            Y20 := TRUE;
            IF NOT X23 THEN
                Y23 := TRUE;
            ELSIF X22 THEN
                IF X29 THEN
                    state := 60;
                END_IF;
            ELSE
                IF recipe[layer] = 0 THEN
                    Y22 := TRUE;
                ELSE
                    Y21 := TRUE;
                END_IF;
            END_IF;

        60:
            Y20 := TRUE;
            IF NOT X23 THEN
                Y23 := TRUE;
            ELSIF D22 > 700 THEN
                Y26 := TRUE;
            ELSIF D22 < 700 THEN
                Y27 := TRUE;
            ELSIF X29 THEN
                state := 70;
            END_IF;

        70:
            Y20 := TRUE;
            IF X24 THEN
                state := 80;
            ELSE
                Y24 := TRUE;
            END_IF;

        80:
            IF X26 AND X28 THEN
                state := 90;
            END_IF;

        90:
            IF X23 THEN
                state := 100;
            ELSE
                Y23 := TRUE;
            END_IF;

        100:
            IF D22 > 700 THEN
                Y26 := TRUE;
            ELSIF D22 < 700 THEN
                Y27 := TRUE;
            ELSIF X29 THEN
                IF layer >= 4 THEN
                    state := 110;
                ELSE
                    layer := layer + 1;
                    state := 10;
                END_IF;
            END_IF;

        110:
            IF NOT X23 THEN
                Y23 := TRUE;
            ELSIF X20 THEN
                IF X29 AND X26 THEN
                    started := FALSE;
                    done := TRUE;
                    state := 120;
                END_IF;
            ELSE
                Y21 := TRUE;
            END_IF;

        120:
            started := FALSE;
            done := TRUE;

        ELSE
            state := 10;
    END_CASE;
END_IF;

IF done THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y26 := FALSE;
    Y27 := FALSE;
END_IF;

Y2 := done;

END_PROGRAM