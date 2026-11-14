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
    r_trig_x10 : R_TRIG;
    state : INT := 0;
    req_id : INT := 0;
    target_detent : INT := 0;
    settle_count : INT := 0;
END_VAR

r_trig_x10(CLK := X10);

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

CASE state OF
    0:
        Y2 := FALSE;
        IF r_trig_x10.Q THEN
            req_id := D10;
            state := 1;
        END_IF;

    1:
        Y2 := FALSE;
        IF D20 = req_id THEN
            target_detent := (D21 + 2) MOD 4;
            state := 4;
        ELSE
            target_detent := (D21 + 1) MOD 4;
            state := 2;
        END_IF;

    2:
        Y2 := FALSE;
        Y20 := TRUE;
        IF (D21 = target_detent) AND X20 THEN
            Y20 := FALSE;
            settle_count := 0;
            state := 3;
        END_IF;

    3:
        Y2 := FALSE;
        settle_count := settle_count + 1;
        IF (settle_count >= 2) AND X20 THEN
            settle_count := 0;
            state := 1;
        END_IF;

    4:
        Y2 := FALSE;
        Y20 := TRUE;
        IF (D21 = target_detent) AND X20 THEN
            Y20 := FALSE;
            settle_count := 0;
            state := 5;
        END_IF;

    5:
        Y2 := FALSE;
        settle_count := settle_count + 1;
        IF (settle_count >= 2) AND X20 AND X21 THEN
            settle_count := 0;
            state := 6;
        END_IF;

    6:
        Y2 := FALSE;
        Y22 := TRUE;
        IF X22 THEN
            Y22 := FALSE;
            state := 7;
        END_IF;

    7:
        Y2 := FALSE;
        Y23 := TRUE;
        IF X21 THEN
            Y23 := FALSE;
            state := 8;
        END_IF;

    8:
        Y2 := FALSE;
        IF X23 AND X21 AND X20 THEN
            Y2 := TRUE;
            state := 9;
        END_IF;

    9:
        Y2 := TRUE;
END_CASE;

END_PROGRAM