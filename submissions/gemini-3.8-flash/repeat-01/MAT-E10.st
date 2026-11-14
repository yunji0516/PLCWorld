PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    D20 : INT;
    state : INT := 0;
    done_count : INT := 0;
END_VAR

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        IF X10 THEN
            state := 1;
            IF D20 <= 400 THEN
                Y20 := TRUE;
            ELSE
                Y20 := FALSE;
            END_IF;
        END_IF;

    1:
        IF X20 THEN
            Y20 := FALSE;
            done_count := 0;
            state := 2;
        ELSE
            IF D20 <= 400 THEN
                Y20 := TRUE;
            ELSIF D20 >= 500 THEN
                Y20 := FALSE;
            END_IF;
        END_IF;

    2:
        Y20 := FALSE;
        done_count := done_count + 1;
        IF done_count >= 5 THEN
            state := 3;
            Y2 := TRUE;
        END_IF;

    3:
        Y20 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM