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
    D21 : INT;
    start_edge : R_TRIG;
    state : INT;
    request_ml : INT;
    completed : BOOL;
END_VAR

start_edge(CLK := X10);

IF completed THEN
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
ELSE
    Y2 := FALSE;

    CASE state OF
        0:
            Y20 := FALSE;
            Y21 := FALSE;

            IF start_edge.Q THEN
                request_ml := D10;
                state := 10;
                Y20 := TRUE;
            END_IF;

        10:
            Y20 := TRUE;
            Y21 := FALSE;

            IF X20 THEN
                state := 20;
            END_IF;

        20:
            Y20 := TRUE;

            IF D20 >= request_ml THEN
                Y21 := FALSE;
                Y20 := FALSE;
                state := 30;
            ELSE
                IF X20 THEN
                    Y21 := TRUE;
                ELSE
                    Y21 := FALSE;
                END_IF;
            END_IF;

        30:
            Y20 := FALSE;
            Y21 := FALSE;

            IF X21 AND (D20 >= (request_ml - 1)) AND (D20 <= (request_ml + 1)) THEN
                completed := TRUE;
                Y2 := TRUE;
            END_IF;

        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
            state := 0;
    END_CASE;
END_IF;

END_PROGRAM