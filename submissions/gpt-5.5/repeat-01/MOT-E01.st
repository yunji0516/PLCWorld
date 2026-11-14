PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    (* Add internal variables here. *)
    accepted : BOOL;
    targetRaw : DINT;
    posErr : DINT;
    absErr : DINT;
    absSpeed : DINT;
    iTerm : DINT;
    cmdRaw : DINT;
    stableCond : BOOL;
    stableTimer : TON;
END_VAR

(* Implement the control logic here. *)

IF NOT accepted THEN
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    iTerm := 0;
    targetRaw := D10;
    stableTimer(IN := FALSE, PT := T#30ms);

    IF X10 THEN
        accepted := TRUE;
        targetRaw := D10;
        iTerm := 0;
    END_IF;
END_IF;

IF accepted THEN
    Y20 := TRUE;

    posErr := targetRaw - D11;
    absErr := ABS(posErr);
    absSpeed := ABS(D12);

    IF NOT Y2 THEN
        IF (absErr <= 20000) AND (absSpeed <= 30000) THEN
            iTerm := iTerm + (posErr / 20);
        END_IF;
    END_IF;

    IF iTerm > 80000 THEN
        iTerm := 80000;
    ELSIF iTerm < -80000 THEN
        iTerm := -80000;
    END_IF;

    cmdRaw := targetRaw + (posErr * 2) - (D12 / 2) + iTerm;

    IF cmdRaw > 80000 THEN
        cmdRaw := 80000;
    ELSIF cmdRaw < -80000 THEN
        cmdRaw := -80000;
    END_IF;

    D20 := cmdRaw;

    stableCond := (absErr <= 15) AND (absSpeed <= 80);

    IF NOT Y2 THEN
        stableTimer(IN := stableCond, PT := T#30ms);
        IF stableTimer.Q THEN
            Y2 := TRUE;
        END_IF;
    ELSE
        Y2 := TRUE;
        stableTimer(IN := FALSE, PT := T#30ms);
    END_IF;
END_IF;

END_PROGRAM