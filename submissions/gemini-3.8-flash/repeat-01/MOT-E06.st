PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL;
    Y2 : BOOL;

    init_captured : BOOL;
    init_pos : DINT;
    cond_met : BOOL;
    claim_done : BOOL;
    stable_timer : TON;
END_VAR

IF NOT X10 THEN
    init_captured := FALSE;
    claim_done := FALSE;
    Y20 := FALSE;
    Y2 := FALSE;
    stable_timer(IN := FALSE, PT := T#30ms);
ELSE
    IF NOT init_captured THEN
        init_captured := TRUE;
        init_pos := D11;
    END_IF;

    Y20 := TRUE;

    cond_met := X11 AND (NOT X12) AND (ABS(D11 - init_pos) <= 20);

    stable_timer(IN := cond_met, PT := T#30ms);

    IF stable_timer.Q THEN
        claim_done := TRUE;
    END_IF;

    Y2 := claim_done;
END_IF;

END_PROGRAM