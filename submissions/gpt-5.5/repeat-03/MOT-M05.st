PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    X11 : BOOL;
    D20 : DINT;
    D21 : DINT;
    D22 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;
    stage : INT := 0;
    active : BOOL := FALSE;
    completeLatch : BOOL := FALSE;
    reqA : DINT := 0;
    reqB : DINT := 0;
    holdA : DINT := 0;
    balActual : DINT := 0;
    balHold : DINT := 0;
    bDesired : DINT := 0;
    bErr : DINT := 0;
    bTrim : DINT := 0;
    bTrimStep : DINT := 0;
    bCommand : DINT := 0;
    brakeBCmd : DINT := 0;
    aCmdPath : DINT := 0;
    stepA : DINT := 60;
    cmdA : DINT := 0;
    cmdB : DINT := 0;
    cmdY20 : BOOL := FALSE;
    cmdY21 : BOOL := FALSE;
    cmdY22 : BOOL := FALSE;
    useFrozenB : BOOL := FALSE;
    angleRadActual : REAL := 0.0;
    momentNm : REAL := 0.0;
    degCountToRad : REAL := 0.000001745329252;
    stableHold : BOOL := FALSE;
    stableFinal : BOOL := FALSE;
    compCond : BOOL := FALSE;
    tSettle : TON;
    tComplete : TON;
END_VAR

angleRadActual := REAL(D11) * degCountToRad;
momentNm := 88.29 * SIN(angleRadActual) + 0.001962 * REAL(D13);
balActual := DINT(ROUND(-45000.0 * SIN(angleRadActual)));
balHold := DINT(ROUND(-45000.0 * SIN(REAL(holdA) * degCountToRad)));
reqB := DINT(ROUND(-45000.0 * SIN(REAL(reqA) * degCountToRad)));

stableHold := (ABS(D11 - holdA) <= 20) AND (ABS(D12) <= 100) AND (ABS(D13 - balHold) <= 20) AND (ABS(D14) <= 100) AND (ABS(momentNm) <= 1.0);
stableFinal := (ABS(D11 - reqA) <= 20) AND (ABS(D12) <= 100) AND (ABS(D13 - reqB) <= 20) AND (ABS(D14) <= 100) AND (ABS(momentNm) <= 1.0);

useFrozenB := FALSE;
cmdA := D11;
bDesired := balActual;
cmdY20 := TRUE;
cmdY21 := TRUE;
cmdY22 := FALSE;

CASE stage OF
    0:
        cmdA := D11;
        bDesired := balActual;
        cmdY20 := TRUE;
        cmdY21 := TRUE;
        cmdY22 := FALSE;
    10:
        cmdA := holdA;
        aCmdPath := holdA;
        bDesired := balHold;
        cmdY20 := TRUE;
        cmdY21 := TRUE;
        cmdY22 := FALSE;
    20:
        IF ABS(momentNm) > 10.0 THEN
            aCmdPath := D11;
        ELSE
            IF aCmdPath < (reqA - stepA) THEN
                aCmdPath := aCmdPath + stepA;
            ELSIF aCmdPath > (reqA + stepA) THEN
                aCmdPath := aCmdPath - stepA;
            ELSE
                aCmdPath := reqA;
            END_IF;
        END_IF;
        cmdA := aCmdPath;
        bDesired := balActual;
        cmdY20 := TRUE;
        cmdY21 := TRUE;
        cmdY22 := FALSE;
    25:
        cmdA := reqA;
        aCmdPath := reqA;
        bDesired := reqB;
        cmdY20 := TRUE;
        cmdY21 := TRUE;
        cmdY22 := FALSE;
    30:
        cmdA := reqA;
        bDesired := reqB;
        useFrozenB := TRUE;
        cmdY20 := TRUE;
        cmdY21 := TRUE;
        cmdY22 := TRUE;
    40:
        cmdA := reqA;
        bDesired := reqB;
        useFrozenB := TRUE;
        cmdY20 := FALSE;
        cmdY21 := TRUE;
        cmdY22 := TRUE;
ELSE
        stage := 0;
        active := FALSE;
        cmdA := D11;
        bDesired := balActual;
        cmdY20 := TRUE;
        cmdY21 := TRUE;
        cmdY22 := FALSE;
END_CASE;

bErr := bDesired - D13;

IF NOT useFrozenB THEN
    IF ABS(bErr) > 5 THEN
        bTrimStep := DINT(REAL(bErr) * 0.125);
        bTrimStep := LIMIT(-300, bTrimStep, 300);
        IF ABS(D14) <= 20000 THEN
            bTrim := LIMIT(-90000, bTrim + bTrimStep, 90000);
        END_IF;
    END_IF;
    bCommand := LIMIT(-180000, bDesired + (bErr * 4) + bTrim, 180000);
    cmdB := bCommand;
ELSE
    cmdB := brakeBCmd;
END_IF;

D20 := LIMIT(-180000, cmdA, 180000);
D21 := LIMIT(-180000, cmdB, 180000);
D22 := 0;
Y20 := cmdY20;
Y21 := cmdY21;
Y22 := cmdY22;
Y2 := completeLatch;

tSettle(IN := ((stage = 25) AND stableFinal), PT := T#30ms);

IF (NOT active) AND X10 THEN
    active := TRUE;
    completeLatch := FALSE;
    stage := 10;
    reqA := LIMIT(-5500, D10, 6500);
    reqB := DINT(ROUND(-45000.0 * SIN(REAL(reqA) * degCountToRad)));
    holdA := D11;
    aCmdPath := D11;
ELSIF active THEN
    IF (stage = 10) AND stableHold THEN
        aCmdPath := holdA;
        stage := 20;
    ELSIF (stage = 20) AND (aCmdPath = reqA) AND (ABS(D11 - reqA) <= 20) AND (ABS(D12) <= 100) THEN
        stage := 25;
    ELSIF (stage = 25) AND tSettle.Q THEN
        brakeBCmd := bCommand;
        stage := 30;
    ELSIF (stage = 30) AND X11 THEN
        stage := 40;
    END_IF;
END_IF;

compCond := active AND X11 AND (NOT Y20) AND (ABS(D11 - reqA) <= 20) AND (ABS(D12) <= 100) AND (ABS(D13 - reqB) <= 20) AND (ABS(D14) <= 100) AND (ABS(momentNm) <= 1.0);
tComplete(IN := compCond, PT := T#30ms);

IF tComplete.Q THEN
    completeLatch := TRUE;
    Y2 := TRUE;
END_IF;

END_PROGRAM