PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;

    start_trig : R_TRIG;
    hold_timer : TON;
    state : INT := 0;
    sel1 : BOOL := FALSE;
    sel2 : BOOL := FALSE;
    sel3 : BOOL := FALSE;
    release_done : BOOL := FALSE;
END_VAR

start_trig(CLK := X10);

CASE state OF
    0:
        IF start_trig.Q THEN
            sel1 := (D10 AND 1) <> 0;
            sel2 := (D10 AND 2) <> 0;
            sel3 := (D10 AND 4) <> 0;
            state := 1;
        END_IF;

    1:
        release_done := (NOT sel1 OR NOT X20) AND (NOT sel2 OR NOT X21) AND (NOT sel3 OR NOT X22);
        hold_timer(IN := release_done, PT := T#400ms);
        IF hold_timer.Q THEN
            state := 2;
        END_IF;

    2:
        (* Retain completed state and holding through evaluation *)
        Y2 := TRUE;
END_CASE;

IF state >= 1 THEN
    Y20 := sel1;
    Y21 := sel2;
    Y22 := sel3;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_IF;

IF state = 2 THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM