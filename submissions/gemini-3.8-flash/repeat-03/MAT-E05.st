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

    state : INT := 0;
    r_trig_start : R_TRIG;
    ton_aligned : TON;
    ton_retract : TON;
END_VAR

r_trig_start(CLK := X10);
ton_aligned(IN := (state = 10) AND X20 AND X21, PT := T#100ms);
ton_retract(IN := (state = 20) AND X22, PT := T#50ms);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF r_trig_start.Q THEN
            state := 10;
        END_IF;

    10:
        Y2 := FALSE;
        Y20 := TRUE;
        Y21 := TRUE;
        IF ton_aligned.Q THEN
            state := 20;
        END_IF;

    20:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF ton_retract.Q THEN
            state := 30;
        END_IF;

    30:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
END_CASE;

END_PROGRAM