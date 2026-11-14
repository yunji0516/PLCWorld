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
    req_match : BOOL := FALSE;
    trig_start : R_TRIG;
    ton_adv : TON;
    ton_ret : TON;
END_VAR

trig_start(CLK := X10);

ton_adv(IN := (state = 10), PT := T#600ms);
ton_ret(IN := (state = 20), PT := T#600ms);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF trig_start.Q THEN
            req_match := (D20 = D10);
            state := 10;
        END_IF;

    10:
        IF req_match THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSE
            Y20 := FALSE;
            Y21 := TRUE;
        END_IF;
        Y2 := FALSE;
        IF ton_adv.Q THEN
            state := 20;
        END_IF;

    20:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF ton_ret.Q AND X20 THEN
            state := 30;
        END_IF;

    30:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM