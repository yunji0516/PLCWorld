PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    detected : BOOL;
    done : BOOL;
    in_pos : BOOL;
    timer : TON;
END_VAR

IF X10 THEN
    IF X11 THEN
        detected := TRUE;
    END_IF;

    IF detected THEN
        Y20 := TRUE;
        D20 := D10;

        in_pos := (ABS(D11 - D10) <= 18) AND (ABS(D12) <= 80);
        timer(IN := in_pos, PT := T#40ms);

        IF timer.Q THEN
            done := TRUE;
        END_IF;
    ELSE
        Y20 := FALSE;
        D20 := 0;
        timer(IN := FALSE, PT := T#40ms);
    END_IF;

    Y2 := done;
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    detected := FALSE;
    done := FALSE;
    timer(IN := FALSE, PT := T#40ms);
END_IF;

END_PROGRAM