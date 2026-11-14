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

    state : INT := 0;
    target_slot : INT := 0;
    target_coord : INT := 0;
    plate_received : BOOL := FALSE;
    r_trig_x10 : R_TRIG;
    settle_ton : TON;
    push_end_ton : TON;
END_VAR

r_trig_x10(CLK := X10);
settle_ton(IN := (state = 22), PT := T#50ms);
push_end_ton(IN := (state = 30 AND X23), PT := T#50ms);

IF X26 THEN
    plate_received := TRUE;
END_IF;

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        plate_received := FALSE;
        IF r_trig_x10.Q AND (D10 = 1) THEN
            target_slot := 0;
            state := 22;
        END_IF;

    20:
        target_slot := target_slot + 1;
        state := 21;

    21:
        target_coord := target_slot * 160;
        IF D20 < (target_coord - 1) THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSIF D20 > (target_coord + 1) THEN
            Y20 := FALSE;
            Y21 := TRUE;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
            state := 22;
        END_IF;

    22:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF settle_ton.Q THEN
            IF X25 THEN
                IF NOT X24 THEN
                    state := 30;
                ELSE
                    state := 20;
                END_IF;
            ELSE
                state := 21;
            END_IF;
        END_IF;

    30:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF push_end_ton.Q THEN
            Y22 := FALSE;
            state := 40;
        END_IF;

    40:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X22 THEN
            Y23 := FALSE;
            state := 50;
        END_IF;

    50:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := TRUE;
END_CASE;

IF NOT X22 THEN
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;

IF Y20 AND Y21 THEN
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;

IF Y22 AND Y23 THEN
    Y22 := FALSE;
    Y23 := FALSE;
END_IF;

END_PROGRAM