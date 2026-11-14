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
    D20 : INT;
    D21 : INT;
    D22 : INT;

    start_edge : R_TRIG;
    state : INT := 0;
    target_len : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0: (* IDLE - Waiting for start *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF start_edge.Q THEN
            target_len := D10;
            state := 10;
        END_IF;

    10: (* PRE_CENTER - Center edge before feeding *)
        Y2 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF D20 > 1 THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSIF D20 < -1 THEN
            Y20 := FALSE;
            Y21 := TRUE;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
            state := 20;
        END_IF;

    20: (* FEEDING - Feed while maintaining edge corridor *)
        Y2 := FALSE;
        Y23 := FALSE;
        IF (D21 + 2) >= target_len THEN
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            state := 30;
        ELSE
            (* Safety check: pause feed if edge deviates significantly *)
            IF ABS(D20) >= 6 THEN
                Y22 := FALSE;
            ELSE
                Y22 := TRUE;
            END_IF;

            (* Active steering correction during feed *)
            IF D20 > 1 THEN
                Y20 := TRUE;
                Y21 := FALSE;
            ELSIF D20 < -1 THEN
                Y20 := FALSE;
                Y21 := TRUE;
            ELSE
                Y20 := FALSE;
                Y21 := FALSE;
            END_IF;
        END_IF;

    30: (* POST_CENTER - Final edge alignment before clamping *)
        Y2 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF D20 > 1 THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSIF D20 < -1 THEN
            Y20 := FALSE;
            Y21 := TRUE;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
            state := 40;
        END_IF;

    40: (* CLAMPING - Secure the receiver clamp *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X20 THEN
            state := 50;
        END_IF;

    50: (* DONE - Maintain clamp and assert completion *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM