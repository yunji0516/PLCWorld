PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;
    D21 : INT;

    r_trig_start : R_TRIG;
    target_vol : INT := 0;
    state : INT := 0;
END_VAR

r_trig_start(CLK := X10);

CASE state OF
    0: (* IDLE *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF r_trig_start.Q THEN
            target_vol := D10;
            Y20 := TRUE;
            state := 1;
        END_IF;

    1: (* WAIT_VALVE_OPEN *)
        Y2 := FALSE;
        Y20 := TRUE;
        Y21 := FALSE;
        IF X20 THEN
            Y21 := TRUE;
            state := 2;
        END_IF;

    2: (* PUMPING *)
        Y2 := FALSE;
        Y20 := TRUE;
        Y21 := TRUE;
        IF D20 >= target_vol THEN
            Y21 := FALSE;
            Y20 := FALSE;
            state := 3;
        END_IF;

    3: (* WAIT_VALVE_CLOSED *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF X21 THEN
            Y2 := TRUE;
            state := 4;
        END_IF;

    4: (* COMPLETED *)
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
END_CASE;

END_PROGRAM