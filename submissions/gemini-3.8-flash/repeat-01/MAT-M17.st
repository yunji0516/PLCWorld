PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    start_trig : R_TRIG;
    state : INT;
    req_id : INT;
    wait_count : INT;
END_VAR

start_trig(CLK := X10);

CASE state OF
    0: (* IDLE *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        wait_count := 0;
        IF start_trig.Q THEN
            req_id := D10;
            IF D20 = 2 THEN
                state := 20;
            ELSE
                state := 10;
            END_IF;
        END_IF;

    10: (* PURGE_WASTE *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF D20 = 2 THEN
            Y20 := FALSE;
            wait_count := 0;
            state := 15;
        END_IF;

    15: (* WAIT_PUMP_STOP *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        wait_count := wait_count + 1;
        IF wait_count >= 2 THEN
            wait_count := 0;
            state := 20;
        END_IF;

    20: (* SWITCH_TO_TARGET *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := FALSE;
        IF X21 THEN
            state := 30;
        END_IF;

    30: (* PUMP_TO_TARGET *)
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := FALSE;
        IF X22 THEN
            Y20 := FALSE;
            wait_count := 0;
            state := 35;
        END_IF;

    35: (* WAIT_PUMP_OFF_BEFORE_CLAIM *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := FALSE;
        wait_count := wait_count + 1;
        IF wait_count >= 2 THEN
            wait_count := 0;
            state := 40;
        END_IF;

    40: (* DONE *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := TRUE;

END_CASE;

END_PROGRAM