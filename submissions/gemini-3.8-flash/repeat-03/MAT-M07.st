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

    trig_start : R_TRIG;
    state : INT := 0;
    target_pitch : INT := 0;
    pitch_dir : INT := 0;
    pitch_done : BOOL := FALSE;
END_VAR

trig_start(CLK := X10);

CASE state OF
    0: (* Idle: wait for start request *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;

        IF trig_start.Q THEN
            target_pitch := D10;
            pitch_dir := 0;
            pitch_done := FALSE;
            state := 10;
        END_IF;

    10: (* Lower tool at source *)
        Y23 := TRUE;
        IF X23 THEN
            Y23 := FALSE;
            state := 20;
        END_IF;

    20: (* Grip materials *)
        Y24 := TRUE;
        IF X24 THEN
            state := 30;
        END_IF;

    30: (* Lift held materials to high position *)
        Y24 := TRUE;
        Y22 := TRUE;
        IF X22 THEN
            Y22 := FALSE;
            state := 40;
        END_IF;

    40: (* Advance horizontally to target and adjust pitch *)
        Y24 := TRUE;

        IF NOT X21 THEN
            Y20 := TRUE;
        ELSE
            Y20 := FALSE;
        END_IF;

        IF NOT pitch_done THEN
            IF pitch_dir = 0 THEN
                IF target_pitch > D20 THEN
                    pitch_dir := 1;
                ELSIF target_pitch < D20 THEN
                    pitch_dir := -1;
                ELSE
                    pitch_done := TRUE;
                END_IF;
            END_IF;

            IF pitch_dir = 1 THEN
                IF D20 >= target_pitch THEN
                    pitch_done := TRUE;
                    Y25 := FALSE;
                ELSE
                    Y25 := TRUE;
                END_IF;
            ELSIF pitch_dir = -1 THEN
                IF D20 <= target_pitch THEN
                    pitch_done := TRUE;
                    Y26 := FALSE;
                ELSE
                    Y26 := TRUE;
                END_IF;
            END_IF;
        ELSE
            Y25 := FALSE;
            Y26 := FALSE;
        END_IF;

        IF X21 AND pitch_done THEN
            Y20 := FALSE;
            Y25 := FALSE;
            Y26 := FALSE;
            state := 50;
        END_IF;

    50: (* Lower held materials to target nests *)
        Y24 := TRUE;
        Y23 := TRUE;
        IF X23 THEN
            Y23 := FALSE;
            state := 60;
        END_IF;

    60: (* Release materials at target nests *)
        Y24 := FALSE;
        IF X25 THEN
            state := 70;
        END_IF;

    70: (* Lift empty tool to high position *)
        Y22 := TRUE;
        IF X22 THEN
            Y22 := FALSE;
            state := 80;
        END_IF;

    80: (* Return empty tool back to source *)
        IF NOT X20 THEN
            Y21 := TRUE;
        ELSE
            Y21 := FALSE;
            state := 90;
        END_IF;

    90: (* Terminal state: maintain completion claim *)
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