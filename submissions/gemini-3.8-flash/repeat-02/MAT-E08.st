PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;

    state : INT := 0;
    rtrig_start : R_TRIG;
    settle_timer : TON;
END_VAR

rtrig_start(CLK := X10);

IF state = 0 AND rtrig_start.Q THEN
    state := 10;
END_IF;

IF state = 10 THEN
    IF X20 THEN
        state := 20;
    END_IF;
END_IF;

IF state = 20 THEN
    IF NOT X20 THEN
        state := 30;
    END_IF;
END_IF;

settle_timer(IN := (state = 30), PT := T#100ms);
IF state = 30 AND settle_timer.Q THEN
    state := 40;
END_IF;

CASE state OF
    0:
        Y20 := FALSE;
        Y2 := FALSE;
    10, 20:
        Y20 := TRUE;
        Y2 := FALSE;
    30:
        Y20 := FALSE;
        Y2 := FALSE;
    40:
        Y20 := FALSE;
        Y2 := TRUE;
    ELSE
        Y20 := FALSE;
        Y2 := FALSE;
END_CASE;

END_PROGRAM