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
    D20 : INT;

    state : INT := 0;
    trig_start : R_TRIG;
    hold_count : INT := 0;
END_VAR

trig_start(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF trig_start.Q AND (D10 = 1) THEN
            Y20 := TRUE;
            state := 1;
        END_IF;

    1:
        Y20 := TRUE;
        Y21 := FALSE;
        IF X22 THEN
            Y20 := FALSE;
            state := 2;
        END_IF;

    2:
        Y20 := FALSE;
        Y21 := FALSE;
        state := 3;

    3:
        Y20 := FALSE;
        Y21 := TRUE;
        IF X20 THEN
            Y21 := FALSE;
            hold_count := 0;
            state := 4;
        END_IF;

    4:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X20 AND X22 THEN
            hold_count := hold_count + 1;
            IF hold_count >= 5 THEN
                Y2 := TRUE;
                state := 5;
            END_IF;
        ELSE
            hold_count := 0;
        END_IF;

    5:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM