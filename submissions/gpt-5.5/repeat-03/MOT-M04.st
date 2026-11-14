PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    D15 : DINT;
    D16 : DINT;
    D18 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    requestedLatched : BOOL;
    completionLatched : BOOL;
    stableNow : BOOL;
    stableTimer : TON;

    targetA : DINT;
    targetB : DINT;
    targetC : DINT;

    posErr : REAL;
    velX : REAL;
    swayErr : REAL;
    swayVel : REAL;
    accMotion : REAL;
    accSway : REAL;
    accCmd : REAL;
    accScaled : REAL;

    kpPos : REAL := 3.0;
    kdPos : REAL := 3.5;
    kSwayPos : REAL := 110.0;
    kSwayVel : REAL := 75.0;
    motionLimit : REAL := 1000.0;
    swayLimit : REAL := 800.0;
    totalLimit : REAL := 1800.0;
END_VAR

stableNow := FALSE;

IF X10 THEN
    IF NOT requestedLatched THEN
        targetA := D10;
        IF targetA < 60000 THEN
            targetA := 60000;
        END_IF;
        IF targetA > 160000 THEN
            targetA := 160000;
        END_IF;

        targetB := D17;
        IF targetB < -130000 THEN
            targetB := -130000;
        END_IF;
        IF targetB > 130000 THEN
            targetB := 130000;
        END_IF;

        targetC := D18;
        completionLatched := FALSE;
        requestedLatched := TRUE;
    END_IF;

    D20 := targetA;
    Y20 := TRUE;

    posErr := REAL(targetB - D13) * 0.01;
    velX := REAL(D14) * 0.01;
    swayErr := REAL(D15 - targetC) * 0.01;
    swayVel := REAL(D16) * 0.01;

    accMotion := (kpPos * posErr) - (kdPos * velX);
    IF accMotion > motionLimit THEN
        accMotion := motionLimit;
    END_IF;
    IF accMotion < -motionLimit THEN
        accMotion := -motionLimit;
    END_IF;

    accSway := (kSwayPos * swayErr) + (kSwayVel * swayVel);
    IF accSway > swayLimit THEN
        accSway := swayLimit;
    END_IF;
    IF accSway < -swayLimit THEN
        accSway := -swayLimit;
    END_IF;

    accCmd := accMotion + accSway;

    IF D13 > 120000 THEN
        IF accCmd > -500.0 THEN
            accCmd := -500.0;
        END_IF;
    END_IF;
    IF D13 < -120000 THEN
        IF accCmd < 500.0 THEN
            accCmd := 500.0;
        END_IF;
    END_IF;

    IF accCmd > totalLimit THEN
        accCmd := totalLimit;
    END_IF;
    IF accCmd < -totalLimit THEN
        accCmd := -totalLimit;
    END_IF;

    accScaled := accCmd * 100.0;
    IF accScaled > 400000.0 THEN
        accScaled := 400000.0;
    END_IF;
    IF accScaled < -400000.0 THEN
        accScaled := -400000.0;
    END_IF;
    D21 := DINT(accScaled);

    stableNow := (ABS(D11 - targetA) <= 50) AND
                 (ABS(D12) <= 50) AND
                 (ABS(D13 - targetB) <= 50) AND
                 (ABS(D14) <= 50) AND
                 (ABS(D15 - targetC) <= 10) AND
                 (ABS(D16) <= 50);
ELSE
    requestedLatched := FALSE;
    completionLatched := FALSE;

    targetA := D11;
    IF targetA < 60000 THEN
        targetA := 60000;
    END_IF;
    IF targetA > 160000 THEN
        targetA := 160000;
    END_IF;

    D20 := targetA;
    D21 := 0;
    Y20 := FALSE;
END_IF;

stableTimer(IN := stableNow, PT := T#30ms);

IF X10 AND stableTimer.Q THEN
    completionLatched := TRUE;
END_IF;

Y2 := X10 AND completionLatched;

END_PROGRAM