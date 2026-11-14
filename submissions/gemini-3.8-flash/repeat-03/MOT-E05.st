PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    D14 : DINT;
    X12 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    captured : BOOL;
    captured_val : DINT;
    timer_confirm : TON;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    IF NOT captured THEN
        IF X11 THEN
            captured := TRUE;
            captured_val := D14;
        END_IF;
    END_IF;
    IF captured THEN
        D20 := captured_val;
        Y21 := TRUE;
    ELSE
        D20 := 0;
        Y21 := FALSE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    D20 := 0;
    captured := FALSE;
    captured_val := 0;
END_IF;

timer_confirm(IN := (X10 AND captured), PT := T#30ms);
IF timer_confirm.Q THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM