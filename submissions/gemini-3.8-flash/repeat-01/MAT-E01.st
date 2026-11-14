PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    started : BOOL;
    done : BOOL;
    ton_hold : TON;
END_VAR

IF NOT started THEN
    IF X10 THEN
        started := TRUE;
    END_IF;
END_IF;

IF started THEN
    Y20 := TRUE;
    ton_hold(IN := X20, PT := T#100ms);
    IF ton_hold.Q THEN
        done := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    ton_hold(IN := FALSE, PT := T#100ms);
END_IF;

IF done THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM