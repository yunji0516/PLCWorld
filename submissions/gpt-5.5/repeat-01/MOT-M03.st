PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    started : BOOL;
    extend_latched : BOOL;
    completed : BOOL;
    pos_err : DINT;
    spd_err : DINT;
    abs_pos_err : DINT;
    abs_spd_err : DINT;
    correction : DINT;
    target_pos : DINT;
    target_spd : DINT;
    align_tight : BOOL;
    align_result : BOOL;
    result_condition : BOOL;
    align_stable_timer : TON;
    result_timer : TON;
END_VAR

IF X10 THEN
    started := TRUE;
END_IF;

pos_err := D13 - D11;
spd_err := D14 - D12;
abs_pos_err := ABS(pos_err);
abs_spd_err := ABS(spd_err);

align_tight := (abs_pos_err <= 10) AND (abs_spd_err <= 50);
align_result := (abs_pos_err <= 15) AND (abs_spd_err <= 80);

align_stable_timer(IN := started AND align_tight, PT := T#50ms);

IF align_stable_timer.Q THEN
    extend_latched := TRUE;
END_IF;

result_condition := started AND extend_latched AND X11 AND align_result;
result_timer(IN := result_condition AND NOT completed, PT := T#30ms);

IF result_timer.Q THEN
    completed := TRUE;
END_IF;

IF started THEN
    correction := (pos_err * 3) + (spd_err / 5);

    IF correction > 80000 THEN
        correction := 80000;
    ELSIF correction < -80000 THEN
        correction := -80000;
    END_IF;

    target_pos := D13 + correction;

    IF target_pos > 100000 THEN
        target_pos := 100000;
    ELSIF target_pos < -100000 THEN
        target_pos := -100000;
    END_IF;

    target_spd := D14;

    IF target_spd > 30000 THEN
        target_spd := 30000;
    ELSIF target_spd < -30000 THEN
        target_spd := -30000;
    END_IF;

    D20 := target_pos;
    D21 := target_spd;
    Y20 := TRUE;
    Y21 := extend_latched;
    Y2 := completed;
ELSE
    D20 := D11;
    D21 := 0;
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
END_IF;

END_PROGRAM