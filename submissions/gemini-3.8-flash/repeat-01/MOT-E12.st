PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    r_trig_x10 : R_TRIG;
    ton_stab : TON;
    cmd_pos : DINT;
    cond_met : BOOL;
    latched_done : BOOL;
END_VAR

r_trig_x10(CLK := X10);

IF NOT X10 THEN
    Y20 := FALSE;
    Y2 := FALSE;
    cmd_pos := D11;
    D20 := D11;
    latched_done := FALSE;
    ton_stab(IN := FALSE, PT := T#30ms);
ELSE
    IF r_trig_x10.Q THEN
        cmd_pos := D11;
    END_IF;

    Y20 := TRUE;

    IF cmd_pos < D10 THEN
        cmd_pos := cmd_pos + 700;
        IF cmd_pos > D10 THEN
            cmd_pos := D10;
        END_IF;
    ELSIF cmd_pos > D10 THEN
        cmd_pos := cmd_pos - 700;
        IF cmd_pos < D10 THEN
            cmd_pos := D10;
        END_IF;
    END_IF;

    D20 := LIMIT(-200000, cmd_pos, 200000);

    cond_met := (ABS(D11 - D10) <= 20) AND (ABS(D12) <= 100);
    ton_stab(IN := cond_met, PT := T#30ms);

    IF ton_stab.Q THEN
        latched_done := TRUE;
    END_IF;

    Y2 := latched_done;
END_IF;

END_PROGRAM