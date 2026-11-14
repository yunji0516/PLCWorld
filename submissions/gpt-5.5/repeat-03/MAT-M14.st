PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    D20 : INT;
    D21 : INT;
    start_edge : R_TRIG;
    state : INT;
    diff : INT;
    received_seen : BOOL;
END_VAR

start_edge(CLK := X10);

IF (state >= 40) AND X22 THEN
    received_seen := TRUE;
END_IF;

IF NOT Y2 THEN
    CASE state OF
        0:
            IF start_edge.Q AND (D10 = 1) THEN
                state := 5;
            END_IF;

        5:
            IF X20 AND X24 THEN
                state := 10;
            END_IF;

        10:
            IF X23 THEN
                state := 20;
            END_IF;

        20:
            IF X24 THEN
                state := 30;
            END_IF;

        30:
            diff := D20 - D21;
            IF X23 AND X24 AND X20 AND (diff >= 8) AND (diff <= 22) THEN
                state := 40;
            END_IF;

        40:
            IF X21 THEN
                IF received_seen THEN
                    state := 50;
                ELSE
                    state := 45;
                END_IF;
            END_IF;

        45:
            IF received_seen THEN
                state := 50;
            END_IF;

        50:
            IF X20 THEN
                state := 60;
            END_IF;

        60:
            IF X20 AND X24 AND received_seen THEN
                Y2 := TRUE;
                state := 100;
            END_IF;

        100:
            Y2 := TRUE;

        ELSE
            state := 0;
    END_CASE;

    IF (state = 60) AND X20 AND X24 AND received_seen THEN
        Y2 := TRUE;
        state := 100;
    END_IF;
END_IF;

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;

IF NOT Y2 THEN
    CASE state OF
        10:
            IF X20 AND (NOT X23) THEN
                Y22 := TRUE;
            END_IF;

        40:
            IF X23 AND X24 THEN
                Y20 := TRUE;
            END_IF;

        50:
            IF NOT X20 THEN
                Y21 := TRUE;
            END_IF;

        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
    END_CASE;
END_IF;

END_PROGRAM