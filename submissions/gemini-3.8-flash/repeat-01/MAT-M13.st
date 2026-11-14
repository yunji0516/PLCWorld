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
    D20 : INT;
    D21 : INT;

    r_trig_start : R_TRIG;
    state : INT := 0;
    req_id : INT := 0;
    target_detent : INT := 0;
END_VAR

r_trig_start(CLK := X10);

IF (state = 0) AND r_trig_start.Q THEN
    req_id := D10;
    state := 1;
END_IF;

CASE state OF
    0: (* IDLE - Awaiting Start *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;

    1: (* CHECK_READER - Inspect pocket at reader *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X20 THEN
            IF D20 = req_id THEN
                target_detent := (D21 + 2) MOD 4;
                state := 10;
            ELSE
                target_detent := (D21 + 1) MOD 4;
                state := 2;
            END_IF;
        END_IF;

    2: (* ROTATE_ONE_STEP - Advance 1 pocket CW *)
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X21 THEN
            Y20 := TRUE;
        ELSE
            Y20 := FALSE;
        END_IF;
        IF X20 AND (D21 = target_detent) THEN
            Y20 := FALSE;
            state := 1;
        END_IF;

    10: (* ROTATE_TO_EJECTOR - Advance 2 pockets CW to ejector *)
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X21 THEN
            Y20 := TRUE;
        ELSE
            Y20 := FALSE;
        END_IF;
        IF X20 AND (D21 = target_detent) THEN
            Y20 := FALSE;
            state := 20;
        END_IF;

    20: (* PUSH - Extend pusher to eject item *)
        Y20 := FALSE;
        Y21 := FALSE;
        IF X20 THEN
            Y22 := TRUE;
            Y23 := FALSE;
        ELSE
            Y22 := FALSE;
            Y23 := FALSE;
        END_IF;
        IF X22 THEN
            Y22 := FALSE;
            Y23 := TRUE;
            state := 21;
        END_IF;

    21: (* RETRACT - Retract pusher back to home *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X21 THEN
            Y23 := FALSE;
            state := 30;
        END_IF;

    30: (* VERIFY_COMPLETE - Confirm all terminal conditions *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X23 AND X21 AND X20 THEN
            Y2 := TRUE;
            state := 40;
        END_IF;

    40: (* DONE - Maintain completion claim and hold state *)
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
END_CASE;

(* Safety interlocks *)
IF NOT X21 THEN
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;

IF NOT X20 THEN
    Y22 := FALSE;
END_IF;

END_PROGRAM