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

    state : INT := 0;
    take_sel : BOOL := FALSE;
    trig_start : R_TRIG;
    t_adv : TON;
    t_ret : TON;
END_VAR

trig_start(CLK := X10);

IF state = 0 THEN
    Y2 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    IF trig_start.Q THEN
        IF D20 = D10 THEN
            take_sel := TRUE;
        ELSE
            take_sel := FALSE;
        END_IF;
        state := 1;
    END_IF;
END_IF;

IF state = 1 THEN
    IF take_sel THEN
        Y20 := TRUE;
        Y21 := FALSE;
    ELSE
        Y20 := FALSE;
        Y21 := TRUE;
    END_IF;
    IF t_adv.Q THEN
        state := 2;
    END_IF;
END_IF;

IF state = 2 THEN
    Y20 := FALSE;
    Y21 := FALSE;
    IF X20 AND t_ret.Q THEN
        state := 3;
    END_IF;
END_IF;

IF state = 3 THEN
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;

t_adv(IN := (state = 1), PT := T#600ms);
t_ret(IN := (state = 2), PT := T#550ms);

END_PROGRAM