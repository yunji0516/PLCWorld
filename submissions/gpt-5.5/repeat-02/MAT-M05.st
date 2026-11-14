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
    (* Add internal variables here. *)
    startEdge : R_TRIG;
    active : BOOL;
    state : INT;
    layerIndex : INT;
    recipe : ARRAY[1..4] OF INT;
    reqValue : INT;
END_VAR

startEdge(CLK := X10);

IF Y2 THEN
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y26 := FALSE;
    Y27 := FALSE;

ELSIF NOT active THEN
    Y2 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y26 := FALSE;
    Y27 := FALSE;

    IF startEdge.Q THEN
        reqValue := D10;
        recipe[1] := D11;
        recipe[2] := D12;
        recipe[3] := D13;
        recipe[4] := D14;

        IF reqValue = 4 THEN
            active := TRUE;
            layerIndex := 1;
            state := 10;
        END_IF;
    END_IF;

ELSE
    Y2 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y26 := FALSE;
    Y27 := FALSE;

    CASE state OF
        10:
            IF D22 > 700 THEN
                Y26 := TRUE;
            ELSE
                state := 20;
            END_IF;

        20:
            IF NOT X23 THEN
                Y23 := TRUE;
            ELSE
                IF recipe[layerIndex] = 0 THEN
                    IF X20 THEN
                        state := 30;
                    ELSE
                        Y21 := TRUE;
                    END_IF;
                ELSE
                    IF X21 THEN
                        state := 30;
                    ELSE
                        Y22 := TRUE;
                    END_IF;
                END_IF;
            END_IF;

        30:
            IF NOT X23 THEN
                Y23 := TRUE;
            ELSE
                IF recipe[layerIndex] = 0 THEN
                    IF NOT X20 THEN
                        state := 20;
                    ELSIF X27 AND X26 THEN
                        state := 31;
                    END_IF;
                ELSE
                    IF NOT X21 THEN
                        state := 20;
                    ELSIF X27 AND X26 THEN
                        state := 31;
                    END_IF;
                END_IF;
            END_IF;

        31:
            IF NOT X24 THEN
                Y24 := TRUE;
            ELSE
                state := 32;
            END_IF;

        32:
            Y20 := TRUE;
            IF X25 THEN
                state := 33;
            END_IF;

        33:
            Y20 := TRUE;
            IF NOT X23 THEN
                Y23 := TRUE;
            ELSE
                state := 40;
            END_IF;

        40:
            Y20 := TRUE;
            IF NOT X23 THEN
                Y23 := TRUE;
            ELSIF X22 THEN
                state := 50;
            ELSE
                IF D20 < 0 THEN
                    Y22 := TRUE;
                ELSE
                    Y21 := TRUE;
                END_IF;
            END_IF;

        50:
            Y20 := TRUE;
            IF NOT X23 THEN
                Y23 := TRUE;
            ELSIF NOT X22 THEN
                state := 40;
            ELSIF D22 > 700 THEN
                Y26 := TRUE;
            ELSE
                state := 51;
            END_IF;

        51:
            Y20 := TRUE;
            IF NOT X24 THEN
                Y24 := TRUE;
            ELSE
                state := 52;
            END_IF;

        52:
            IF X28 AND X26 THEN
                state := 53;
            END_IF;

        53:
            IF NOT X23 THEN
                Y23 := TRUE;
            ELSE
                IF layerIndex < 4 THEN
                    state := 60;
                ELSE
                    state := 70;
                END_IF;
            END_IF;

        60:
            IF D22 > 700 THEN
                Y26 := TRUE;
            ELSE
                layerIndex := layerIndex + 1;
                state := 20;
            END_IF;

        70:
            IF NOT X23 THEN
                Y23 := TRUE;
            ELSIF NOT X20 THEN
                Y21 := TRUE;
            ELSE
                state := 80;
            END_IF;

        80:
            IF X20 AND X23 AND X26 AND X29 THEN
                Y2 := TRUE;
                active := FALSE;
            END_IF;

        ELSE
            state := 80;
    END_CASE;
END_IF;

END_PROGRAM