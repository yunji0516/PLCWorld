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

    state : INT := 0;
    req_spacing : INT := 0;
    pitch_dir : INT := 0;
    trig_start : R_TRIG;
    timer_grip : TON;
    timer_release : TON;
END_VAR

trig_start(CLK := X10);
timer_grip(IN := (state = 20 AND X24), PT := T#100ms);
timer_release(IN := (state = 70 AND X25), PT := T#100ms);

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

CASE state OF
    0:
        IF trig_start.Q THEN
            req_spacing := D10;
            state := 10;
        END_IF;

    10:
        Y23 := TRUE;
        IF X23 THEN
            state := 20;
        END_IF;

    20:
        Y24 := TRUE;
        IF timer_grip.Q THEN
            state := 30;
        END_IF;

    30:
        Y24 := TRUE;
        Y22 := TRUE;
        IF X22 THEN
            IF D20 < req_spacing THEN
                pitch_dir := 1;
            ELSIF D20 > req_spacing THEN
                pitch_dir := -1;
            ELSE
                pitch_dir := 0;
            END_IF;
            state := 40;
        END_IF;

    40:
        Y24 := TRUE;
        IF pitch_dir = 1 THEN
            IF D20 >= req_spacing THEN
                state := 50;
            ELSE
                Y25 := TRUE;
            END_IF;
        ELSIF pitch_dir = -1 THEN
            IF D20 <= req_spacing THEN
                state := 50;
            ELSE
                Y26 := TRUE;
            END_IF;
        ELSE
            state := 50;
        END_IF;

    50:
        Y24 := TRUE;
        Y20 := TRUE;
        IF X21 THEN
            state := 60;
        END_IF;

    60:
        Y24 := TRUE;
        Y23 := TRUE;
        IF X23 THEN
            state := 70;
        END_IF;

    70:
        IF timer_release.Q THEN
            state := 80;
        END_IF;

    80:
        Y22 := TRUE;
        IF X22 THEN
            state := 90;
        END_IF;

    90:
        Y21 := TRUE;
        IF X20 THEN
            state := 100;
        END_IF;

    100:
        Y2 := TRUE;
END_CASE;

END_PROGRAM