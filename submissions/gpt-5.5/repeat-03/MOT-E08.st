PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    accepted : BOOL;
    reqRaw : DINT;
    cmdPosRaw : DINT;
    cmdVelRaw : DINT;
    desiredPosRaw : DINT;
    posErrRaw : DINT;
    velErrRaw : DINT;
    absPosErrRaw : DINT;
    absVelErrRaw : DINT;
    stableCond : BOOL;
    stableTimer : TON;
END_VAR

IF (NOT accepted) AND X10 THEN
    accepted := TRUE;
    reqRaw := D10;
END_IF;

IF accepted THEN
    Y20 := TRUE;

    cmdPosRaw := D13 + reqRaw;
    IF cmdPosRaw > 200000 THEN
        D20 := 200000;
    ELSIF cmdPosRaw < -200000 THEN
        D20 := -200000;
    ELSE
        D20 := cmdPosRaw;
    END_IF;

    cmdVelRaw := D14;
    IF cmdVelRaw > 200000 THEN
        D21 := 200000;
    ELSIF cmdVelRaw < -200000 THEN
        D21 := -200000;
    ELSE
        D21 := cmdVelRaw;
    END_IF;

    desiredPosRaw := D13 + reqRaw;
    posErrRaw := D11 - desiredPosRaw;
    velErrRaw := D12 - D14;

    IF posErrRaw < 0 THEN
        absPosErrRaw := -posErrRaw;
    ELSE
        absPosErrRaw := posErrRaw;
    END_IF;

    IF velErrRaw < 0 THEN
        absVelErrRaw := -velErrRaw;
    ELSE
        absVelErrRaw := velErrRaw;
    END_IF;

    stableCond := (absPosErrRaw <= 30) AND (absVelErrRaw <= 200);
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
    stableCond := FALSE;
END_IF;

stableTimer(IN := stableCond, PT := T#30ms);

IF accepted AND stableTimer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM