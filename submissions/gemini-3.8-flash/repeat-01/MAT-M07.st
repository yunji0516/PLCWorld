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

    start_trig : R_TRIG;
    state : INT := 0;
    req_pitch : INT := 0;
    pitch_adj : INT := 0;
    pitch_done : BOOL := FALSE;
END_VAR

start_trig(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF start_trig.Q THEN
            req_pitch := D10;
            state := 10;
        END_IF;

    10:
        Y23 := TRUE;
        IF X23 THEN
            Y23 := FALSE;
            state := 20;
        END_IF;

    20:
        Y24 := TRUE;
        IF X24 THEN
            state := 30;
        END_IF;

    30:
        Y24 := TRUE;
        Y22 := TRUE;
        IF X22 THEN
            Y22 := FALSE;
            IF D20 < req_pitch THEN
                pitch_adj := 1;
                pitch_done := FALSE;
            ELSIF D20 > req_pitch THEN
                pitch_adj := 2;
                pitch_done := FALSE;
            ELSE
                pitch_adj := 0;
                pitch_done := TRUE;
            END_IF;
            state := 40;
        END_IF;

    40:
        Y24 := TRUE;

        IF NOT X21 THEN
            Y20 := TRUE;
        ELSE
            Y20 := FALSE;
        END_IF;

        IF pitch_adj = 1 THEN
            IF D20 >= req_pitch THEN
                Y25 := FALSE;
                pitch_adj := 0;
                pitch_done := TRUE;
            ELSE
                Y25 := TRUE;
                Y26 := FALSE;
            END_IF;
        ELSIF pitch_adj = 2 THEN
            IF D20 <= req_pitch THEN
                Y26 := FALSE;
                pitch_adj := 0;
                pitch_done := TRUE;
            ELSE
                Y26 := TRUE;
                Y25 := FALSE;
            END_IF;
        ELSE
            Y25 := FALSE;
            Y26 := FALSE;
            pitch_done := TRUE;
        END_IF;

        IF X21 AND pitch_done THEN
            Y20 := FALSE;
            Y25 := FALSE;
            Y26 := FALSE;
            state := 50;
        END_IF;

    50:
        Y24 := TRUE;
        Y23 := TRUE;
        IF X23 THEN
            Y23 := FALSE;
            state := 60;
        END_IF;

    60:
        Y24 := FALSE;
        IF X25 THEN
            state := 70;
        END_IF;

    70:
        Y22 := TRUE;
        IF X22 THEN
            Y22 := FALSE;
            state := 80;
        END_IF;

    80:
        Y21 := TRUE;
        IF X20 THEN
            Y21 := FALSE;
            state := 90;
        END_IF;

    90:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
END_CASE;

END_PROGRAM