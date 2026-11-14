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

    r_trig_start : R_TRIG;
    state : INT := 0;
    ton_adv : TON;
    ton_ret : TON;
END_VAR

r_trig_start(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        ton_adv(IN := FALSE, PT := T#500ms);
        ton_ret(IN := FALSE, PT := T#100ms);
        IF r_trig_start.Q AND (D10 = 1) THEN
            state := 10;
        END_IF;

    10:
        Y2 := FALSE;
        Y20 := TRUE;
        Y21 := TRUE;
        ton_adv(IN := TRUE, PT := T#500ms);
        IF ton_adv.Q AND X20 AND X21 THEN
            state := 20;
        END_IF;

    20:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        ton_ret(IN := X22 AND X20 AND X21, PT := T#100ms);
        IF ton_ret.Q THEN
            state := 30;
        END_IF;

    30:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
END_CASE;

END_PROGRAM