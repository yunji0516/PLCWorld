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
    start_trig : R_TRIG;
    state : INT := 0;
    target_vol : INT := 0;
    settle_count : INT := 0;
END_VAR

start_trig(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF start_trig.Q THEN
            target_vol := D10;
            Y20 := TRUE;
            state := 1;
        END_IF;

    1:
        Y20 := TRUE;
        Y21 := FALSE;
        IF X20 THEN
            Y21 := TRUE;
            state := 2;
        END_IF;

    2:
        Y20 := TRUE;
        Y21 := TRUE;
        IF D20 >= target_vol THEN
            Y21 := FALSE;
            settle_count := 0;
            state := 3;
        END_IF;

    3:
        Y20 := TRUE;
        Y21 := FALSE;
        settle_count := settle_count + 1;
        IF settle_count >= 5 THEN
            Y20 := FALSE;
            state := 4;
        END_IF;

    4:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X21 THEN
            IF (D20 >= (target_vol - 2)) AND (D20 <= (target_vol + 2)) THEN
                Y2 := TRUE;
                state := 5;
            END_IF;
        END_IF;

    5:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
END_CASE;

END_PROGRAM