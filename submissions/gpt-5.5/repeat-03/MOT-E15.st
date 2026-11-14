PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    activeLatch : BOOL;
    resultLatch : BOOL;
    initDone : BOOL;
    stableCond : BOOL;
    stableTon : TON;
    pi : REAL := 3.14159265;
    degToRad : REAL := 0.0174532925;
    scanTime : REAL := 0.01;
    leadTime : REAL := 0.038;
    halfLeadTimeSq : REAL := 0.000722;
    feedbackGainMmPerNm : REAL := 2.0;
    aDeg : REAL;
    aVelDeg : REAL;
    aAccDeg : REAL;
    aPredDeg : REAL;
    aPredVelDeg : REAL;
    aPredRad : REAL;
    bCmdMm : REAL;
    bCmdVel : REAL;
    momentNm : REAL;
    momentCalc : REAL;
    bActualMm : REAL;
    bActualVel : REAL;
    cmdRaw : DINT;
    auxRaw : DINT;
    absD17 : DINT;
    absMomentCalc : REAL;
    prevAVelDeg : REAL;
END_VAR

aDeg := REAL(D13) * 0.01;
aVelDeg := REAL(D14) * 0.01;
bActualMm := REAL(D11) * 0.01;
bActualVel := REAL(D12) * 0.01;
momentNm := REAL(D17) * 0.01;

IF NOT initDone THEN
    prevAVelDeg := aVelDeg;
    initDone := TRUE;
END_IF;

aAccDeg := (aVelDeg - prevAVelDeg) / scanTime;
IF aAccDeg > 350.0 THEN
    aAccDeg := 350.0;
ELSIF aAccDeg < -350.0 THEN
    aAccDeg := -350.0;
END_IF;

IF X10 THEN
    activeLatch := TRUE;
END_IF;

IF activeLatch THEN
    aPredDeg := aDeg + (aVelDeg * leadTime) + (aAccDeg * halfLeadTimeSq);
    aPredVelDeg := aVelDeg + (aAccDeg * leadTime);
    aPredRad := aPredDeg * degToRad;

    bCmdMm := -450.0 * SIN(aPredRad);
    bCmdVel := -450.0 * COS(aPredRad) * aPredVelDeg * degToRad;

    bCmdMm := bCmdMm - (feedbackGainMmPerNm * momentNm);

    IF bCmdMm > 1500.0 THEN
        bCmdMm := 1500.0;
    ELSIF bCmdMm < -1500.0 THEN
        bCmdMm := -1500.0;
    END_IF;

    IF bCmdVel > 1000.0 THEN
        bCmdVel := 1000.0;
    ELSIF bCmdVel < -1000.0 THEN
        bCmdVel := -1000.0;
    END_IF;

    cmdRaw := DINT(bCmdMm * 100.0);
    auxRaw := DINT(bCmdVel * 100.0);

    IF cmdRaw > 150000 THEN
        cmdRaw := 150000;
    ELSIF cmdRaw < -150000 THEN
        cmdRaw := -150000;
    END_IF;

    IF auxRaw > 100000 THEN
        auxRaw := 100000;
    ELSIF auxRaw < -100000 THEN
        auxRaw := -100000;
    END_IF;

    D20 := cmdRaw;
    D21 := auxRaw;
ELSE
    cmdRaw := D11;
    IF cmdRaw > 150000 THEN
        cmdRaw := 150000;
    ELSIF cmdRaw < -150000 THEN
        cmdRaw := -150000;
    END_IF;

    D20 := cmdRaw;
    D21 := 0;
END_IF;

IF D17 < 0 THEN
    absD17 := -D17;
ELSE
    absD17 := D17;
END_IF;

momentCalc := (88.29 * SIN(aDeg * degToRad)) + (0.1962 * bActualMm);
absMomentCalc := ABS(momentCalc);

stableCond := activeLatch AND (absD17 <= 80) AND (absMomentCalc <= 0.8);
stableTon(IN := stableCond, PT := T#30ms);

IF activeLatch AND stableTon.Q THEN
    resultLatch := TRUE;
END_IF;

Y20 := activeLatch;
Y2 := resultLatch;

prevAVelDeg := aVelDeg;

END_PROGRAM