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

    step : INT;
    req_angle : INT;
    plate_init_angle : INT;
    head_acq_angle : INT;
    target_head_angle : INT;
    diff : INT;
    rot_dir : INT;
    rot_done : BOOL;
    r_trig_start : R_TRIG;
END_VAR

r_trig_start(CLK := X10);

CASE step OF
    0: // IDLE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        Y2 := FALSE;
        IF r_trig_start.Q THEN
            req_angle := D10;
            plate_init_angle := D20;
            step := 1;
        END_IF;

    1: // DOWN_TO_SOURCE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF NOT X22 THEN
            Y24 := TRUE;
        ELSE
            Y24 := FALSE;
            IF X28 THEN
                head_acq_angle := D21;
                step := 2;
            END_IF;
        END_IF;

    2: // GRIP
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X24 THEN
            diff := req_angle - plate_init_angle;
            IF diff > 180 THEN
                diff := diff - 360;
            ELSIF diff < -180 THEN
                diff := diff + 360;
            END_IF;
            target_head_angle := head_acq_angle + diff;
            IF target_head_angle > head_acq_angle THEN
                rot_dir := 1;
            ELSIF target_head_angle < head_acq_angle THEN
                rot_dir := -1;
            ELSE
                rot_dir := 0;
            END_IF;
            rot_done := FALSE;
            step := 3;
        END_IF;

    3: // LIFT_FROM_SOURCE
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF NOT X23 THEN
            Y23 := TRUE;
        ELSE
            Y23 := FALSE;
            IF X28 THEN
                step := 4;
            END_IF;
        END_IF;

    4: // ROTATE
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        IF rot_dir = 1 THEN
            IF NOT rot_done THEN
                IF D21 >= target_head_angle THEN
                    Y25 := FALSE;
                    rot_done := TRUE;
                ELSE
                    Y25 := TRUE;
                END_IF;
            ELSE
                Y25 := FALSE;
                IF X28 THEN
                    step := 5;
                END_IF;
            END_IF;
        ELSIF rot_dir = -1 THEN
            IF NOT rot_done THEN
                IF D21 <= target_head_angle THEN
                    Y26 := FALSE;
                    rot_done := TRUE;
                ELSE
                    Y26 := TRUE;
                END_IF;
            ELSE
                Y26 := FALSE;
                IF X28 THEN
                    step := 5;
                END_IF;
            END_IF;
        ELSE
            step := 5;
        END_IF;

    5: // ADVANCE_TO_TARGET
        Y20 := TRUE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF NOT X21 THEN
            Y21 := TRUE;
        ELSE
            Y21 := FALSE;
            IF X28 THEN
                step := 6;
            END_IF;
        END_IF;

    6: // DOWN_TO_TARGET
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF NOT X22 THEN
            Y24 := TRUE;
        ELSE
            Y24 := FALSE;
            IF X28 THEN
                step := 7;
            END_IF;
        END_IF;

    7: // RELEASE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF X25 AND (NOT X24) THEN
            step := 8;
        END_IF;

    8: // LIFT_FROM_TARGET
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF NOT X23 THEN
            Y23 := TRUE;
        ELSE
            Y23 := FALSE;
            IF X28 THEN
                step := 9;
            END_IF;
        END_IF;

    9: // RETURN_TO_SOURCE
        Y20 := FALSE;
        Y21 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        IF NOT X20 THEN
            Y22 := TRUE;
        ELSE
            Y22 := FALSE;
            IF X28 AND X23 AND X20 AND X25 THEN
                step := 10;
            END_IF;
        END_IF;

    10: // DONE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        Y2 := TRUE;
END_CASE;

IF NOT X23 THEN
    Y21 := FALSE;
    Y22 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
END_IF;

IF Y21 AND Y22 THEN
    Y21 := FALSE;
    Y22 := FALSE;
END_IF;

IF Y23 AND Y24 THEN
    Y23 := FALSE;
    Y24 := FALSE;
END_IF;

IF Y25 AND Y26 THEN
    Y25 := FALSE;
    Y26 := FALSE;
END_IF;

END_PROGRAM