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
    X26 : BOOL;
    D20 : INT;
    rStart : R_TRIG;
    accepted : BOOL;
    completed : BOOL;
    state : INT;
    slotIndex : INT;
    targetMM : INT;
    diffMM : INT;
    absDiff : INT;
    requestValue : INT;
END_VAR

rStart(CLK := X10);

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

IF completed THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;

    IF NOT accepted THEN
        IF rStart.Q AND (D10 = 1) THEN
            accepted := TRUE;
            requestValue := D10;
            slotIndex := 0;
            state := 10;
        END_IF;
    END_IF;

    IF accepted AND NOT completed THEN
        CASE state OF
            10:
                IF X22 THEN
                    state := 20;
                ELSE
                    Y23 := TRUE;
                END_IF;

            20:
                IF slotIndex > 3 THEN
                    state := 90;
                ELSE
                    targetMM := slotIndex * 160;
                    diffMM := D20 - targetMM;
                    absDiff := ABS(diffMM);

                    IF X25 AND (absDiff <= 8) THEN
                        IF NOT X24 THEN
                            state := 30;
                        ELSE
                            slotIndex := slotIndex + 1;
                        END_IF;
                    ELSE
                        IF X22 THEN
                            IF D20 < (targetMM - 3) THEN
                                IF NOT X21 THEN
                                    Y20 := TRUE;
                                END_IF;
                            ELSIF D20 > (targetMM + 3) THEN
                                IF NOT X20 THEN
                                    Y21 := TRUE;
                                END_IF;
                            ELSE
                                IF D20 <= targetMM THEN
                                    IF NOT X21 THEN
                                        Y20 := TRUE;
                                    END_IF;
                                ELSE
                                    IF NOT X20 THEN
                                        Y21 := TRUE;
                                    END_IF;
                                END_IF;
                            END_IF;
                        ELSE
                            Y23 := TRUE;
                        END_IF;
                    END_IF;

            30:
                targetMM := slotIndex * 160;
                diffMM := D20 - targetMM;
                absDiff := ABS(diffMM);

                IF X22 AND X25 AND (absDiff <= 8) AND (NOT X24) THEN
                    Y22 := TRUE;
                    state := 40;
                ELSIF NOT X22 THEN
                    Y23 := TRUE;
                ELSIF (X25 AND (absDiff <= 8) AND X24) THEN
                    slotIndex := slotIndex + 1;
                    state := 20;
                ELSE
                    state := 20;
                END_IF;

            40:
                IF X26 THEN
                    state := 50;
                ELSE
                    Y22 := TRUE;
                END_IF;

            50:
                IF X22 AND X26 THEN
                    completed := TRUE;
                    state := 60;
                    Y2 := TRUE;
                ELSE
                    Y23 := TRUE;
                END_IF;

            60:
                completed := TRUE;
                Y2 := TRUE;

            90:
                Y20 := FALSE;
                Y21 := FALSE;
                Y22 := FALSE;
                Y23 := FALSE;

            ELSE
                state := 10;
        END_CASE;
    END_IF;

    IF completed THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM