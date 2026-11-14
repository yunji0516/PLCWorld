PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    diff : DINT;
    t_stable : TON;
    hold_done : BOOL;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, D10, 200000);

    diff := D12 - D10;
    IF diff < 0 THEN
        diff := -diff;
    END_IF;

    t_stable(IN := (diff <= 200), PT := T#30ms);
    IF t_stable.Q THEN
        hold_done := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
    t_stable(IN := FALSE, PT := T#30ms);
    hold_done := FALSE;
END_IF;

Y2 := hold_done;

END_PROGRAM