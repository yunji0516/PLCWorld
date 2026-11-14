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
    posMm : REAL;
    velMmS : REAL;
    targetMm : REAL;
    errMm : REAL;
    cmdMm : REAL;
    cmdRawReal : REAL;
    integMm : REAL;
    absErrRaw : DINT;
    absSpeedRaw : DINT;
    stableCond : BOOL;
    stableTimer : TON;
    kp : REAL := 2.5;
    kd : REAL := 0.20;
    kiStep : REAL := 0.10;
END_VAR

(* Implement the control logic here. *)

IF NOT accepted THEN
    IF X10 THEN
        accepted := TRUE;
        targetRaw := D10;
        IF targetRaw < 10000 THEN
            targetRaw := 10000;
        END_IF;
        IF targetRaw > 15000 THEN
            targetRaw := 15000;
        END_IF;
        integMm := 0.0;
        Y2 := FALSE;
    END_IF;
END_IF;

IF accepted THEN
    Y20 := TRUE;

    posMm := REAL(D11) * 0.01;
    velMmS := REAL(D12) * 0.01;
    targetMm := REAL(targetRaw) * 0.01;
    errMm := targetMm - posMm;

    IF (ABS(errMm) < 120.0) AND (ABS(velMmS) < 500.0) AND (ABS(errMm) > 0.05) THEN
        integMm := integMm + (errMm * kiStep);
    END_IF;

    IF integMm > 80.0 THEN
        integMm := 80.0;
    END_IF;
    IF integMm < -60.0 THEN
        integMm := -60.0;
    END_IF;

    cmdMm := posMm + (kp * errMm) - (kd * velMmS) + integMm;

    IF cmdMm > 1200.0 THEN
        cmdMm := 1200.0;
    END_IF;
    IF cmdMm < 0.0 THEN
        cmdMm := 0.0;
    END_IF;

    cmdRawReal := cmdMm * 100.0;

    IF cmdRawReal > 200000.0 THEN
        D20 := 200000;
    ELSIF cmdRawReal < -200000.0 THEN
        D20 := -200000;
    ELSE
        D20 := DINT(cmdRawReal);
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := 0;
END_IF;

IF D11 >= targetRaw THEN
    absErrRaw := D11 - targetRaw;
ELSE
    absErrRaw := targetRaw - D11;
END_IF;

IF D12 >= 0 THEN
    absSpeedRaw := D12;
ELSE
    absSpeedRaw := -D12;
END_IF;

stableCond := accepted AND (absErrRaw <= 10) AND (absSpeedRaw <= 50);

stableTimer(IN := stableCond, PT := T#30ms);

IF stableTimer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM