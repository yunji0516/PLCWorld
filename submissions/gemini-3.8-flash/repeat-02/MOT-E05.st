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

    state : INT := 0;
    captured_val : DINT := 0;
    timer_hold : TON;
END_VAR

CASE state OF
    0:
        IF X10 THEN
            Y20 := TRUE;
            state := 1;
        END_IF;

    1:
        IF X11 THEN
            captured_val := D14;
            D20 := captured_val;
            Y21 := TRUE;
            state := 2;
        END_IF;

    2:
        IF timer_hold.Q THEN
            Y2 := TRUE;
            state := 3;
        END_IF;

    3:
        Y2 := TRUE;
END_CASE;

IF state >= 1 THEN
    Y20 := TRUE;
END_IF;

IF state >= 2 THEN
    D20 := captured_val;
    Y21 := TRUE;
END_IF;

timer_hold(IN := (state >= 2), PT := T#30ms);

IF timer_hold.Q AND (state >= 2) THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM