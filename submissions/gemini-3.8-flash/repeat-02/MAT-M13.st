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
    trig_start : R_TRIG;
    state : INT;
    req_id : INT;
    search_count : INT;
    target_index : INT;
    eject_steps_remaining : INT;
END_VAR

trig_start(CLK := X10);

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

CASE state OF
    0:
        IF trig_start.Q THEN
            req_id := D10;
            search_count := 0;
            state := 1;
        END_IF;

    1:
        IF D20 = req_id THEN
            eject_steps_remaining := 2;
            state := 10;
        ELSE
            search_count := search_count + 1;
            IF search_count < 4 THEN
                state := 2;
            ELSE
                state := 99;
            END_IF;
        END_IF;

    2:
        target_index := (D21 + 1) MOD 4;
        state := 3;

    3:
        IF X21 THEN
            Y20 := TRUE;
        END_IF;
        IF D21 = target_index AND X20 THEN
            Y20 := FALSE;
            state := 1;
        END_IF;

    10:
        target_index := (D21 + 1) MOD 4;
        state := 11;

    11:
        IF X21 THEN
            Y20 := TRUE;
        END_IF;
        IF D21 = target_index AND X20 THEN
            Y20 := FALSE;
            eject_steps_remaining := eject_steps_remaining - 1;
            IF eject_steps_remaining <= 0 THEN
                state := 4;
            ELSE
                state := 10;
            END_IF;
        END_IF;

    4:
        IF X20 THEN
            Y22 := TRUE;
        END_IF;
        IF X22 THEN
            Y22 := FALSE;
            state := 5;
        END_IF;

    5:
        Y23 := TRUE;
        IF X21 THEN
            Y23 := FALSE;
            state := 6;
        END_IF;

    6:
        IF X20 AND X21 AND X23 THEN
            Y2 := TRUE;
            state := 7;
        END_IF;

    7:
        Y2 := TRUE;

    99:
        ;
END_CASE;

END_PROGRAM