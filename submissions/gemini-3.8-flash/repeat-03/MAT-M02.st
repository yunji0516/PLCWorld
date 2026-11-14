PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
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
    X28 : BOOL;
    X31 : BOOL;
    Y2 : BOOL;
    D20 : INT;
    D21 : INT;

    start_trig : R_TRIG;
    step : INT := 0;
    target_plate : INT := 0;
    plate_init : INT := 0;
    delta : INT := 0;
    head_init : INT := 0;
    target_head : INT := 0;
END_VAR

start_trig(CLK := X10);

CASE step OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        Y2 := FALSE;

        IF start_trig.Q THEN
            target_plate := D10;
            plate_init := D20;
            delta := target_plate - plate_init;
            IF delta > 180 THEN
                delta := delta - 360;
            ELSIF delta < -180 THEN
                delta := delta + 360;
            END_IF;
            step := 1;
        END_IF;

    1:
        (* Move down at source *)
        Y24 := TRUE;
        IF X22 THEN
            Y24 := FALSE;
            head_init := D21;
            target_head := head_init + delta;
            step := 2;
        END_IF;

    2:
        (* Grip plate *)
        Y20 := TRUE;
        IF X24 THEN
            step := 3;
        END_IF;

    3:
        (* Lift to upper position *)
        Y20 := TRUE;
        Y23 := TRUE;
        IF X23 THEN
            Y23 := FALSE;
            step := 4;
        END_IF;

    4:
        (* Rotate head to target orientation *)
        Y20 := TRUE;
        IF delta > 0 THEN
            IF D21 >= target_head THEN
                Y25 := FALSE;
                step := 5;
            ELSE
                Y25 := TRUE;
            END_IF;
        ELSIF delta < 0 THEN
            IF D21 <= target_head THEN
                Y26 := FALSE;
                step := 5;
            ELSE
                Y26 := TRUE;
            END_IF;
        ELSE
            step := 5;
        END_IF;

    5:
        (* Advance horizontally to receiver *)
        Y20 := TRUE;
        Y21 := TRUE;
        IF X21 THEN
            Y21 := FALSE;
            step := 6;
        END_IF;

    6:
        (* Move down at receiver *)
        Y20 := TRUE;
        Y24 := TRUE;
        IF X22 THEN
            Y24 := FALSE;
            step := 7;
        END_IF;

    7:
        (* Release plate onto receiver *)
        Y20 := FALSE;
        IF X25 AND (NOT X24) AND X27 THEN
            step := 8;
        END_IF;

    8:
        (* Lift empty tool to upper position *)
        Y23 := TRUE;
        IF X23 THEN
            Y23 := FALSE;
            step := 9;
        END_IF;

    9:
        (* Return horizontally to source *)
        Y22 := TRUE;
        IF X20 THEN
            Y22 := FALSE;
            step := 10;
        END_IF;

    10:
        (* Maintain completed state and assert completion claim *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X20 AND X23 AND X25 AND X27 THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM