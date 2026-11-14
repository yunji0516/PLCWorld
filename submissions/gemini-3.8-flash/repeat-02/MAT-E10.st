PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    D20 : INT;
    started : BOOL;
    done : BOOL;
END_VAR

IF NOT started THEN
    IF X10 THEN
        started := TRUE;
    END_IF;
END_IF;

IF started THEN
    IF X20 OR done THEN
        done := TRUE;
        Y20 := FALSE;
        Y2 := TRUE;
    ELSE
        IF D20 <= 400 THEN
            Y20 := TRUE;
        ELSIF D20 >= 500 THEN
            Y20 := FALSE;
        END_IF;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
END_IF;

END_PROGRAM