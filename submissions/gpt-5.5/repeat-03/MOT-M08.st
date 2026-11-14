PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;
    stage : DINT;
    refEdge : R_TRIG;
    cfgTimer : TON;
    seenOff : BOOL;
    captureTarget : DINT;
    aShelfTarget : DINT;
    configPulse : BOOL;
    complete : BOOL;
    posTol : DINT := 20;
    velTol : DINT := 100;
END_VAR

refEdge(CLK := X34);
cfgTimer(IN := (stage = 4), PT := T#600ms);

configPulse := FALSE;

IF NOT X34 THEN
    seenOff := TRUE;
END_IF;

aShelfTarget := D90 + ((D102 * D101) / 100);

CASE stage OF
    0:
        complete := FALSE;
        IF X0 THEN
            stage := 1;
        END_IF;

    1:
        IF seenOff AND refEdge.Q THEN
            captureTarget := D10 + 300;
            IF captureTarget > 35000 THEN
                captureTarget := 35000;
            END_IF;
            stage := 2;
        END_IF;

    2:
        IF (ABS(D10 - captureTarget) <= posTol) AND (ABS(D11) <= velTol) THEN
            stage := 3;
        END_IF;

    3:
        configPulse := TRUE;
        stage := 4;

    4:
        IF cfgTimer.Q AND X35 THEN
            stage := 5;
        END_IF;

    5:
        aShelfTarget := D90 + ((D102 * D101) / 100);
        IF (ABS(D10 - aShelfTarget) <= posTol) AND (ABS(D11) <= velTol) THEN
            stage := 6;
        END_IF;

    6:
        IF (ABS(D12 - D103) <= posTol) AND (ABS(D13) <= velTol) THEN
            stage := 7;
        END_IF;

    7:
        IF (ABS(D12) <= posTol) AND (ABS(D13) <= velTol) THEN
            complete := TRUE;
            stage := 8;
        END_IF;

    8:
        complete := TRUE;

ELSE
    stage := 0;
END_CASE;

Y30 := configPulse;
Y2 := complete;

CASE stage OF
    0:
        D20 := 0;
        D21 := 100;
        Y20 := FALSE;
        D24 := 0;
        D25 := 1000;
        Y21 := FALSE;

    1:
        D20 := 12000;
        D21 := 100;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;

    2, 3, 4:
        D20 := captureTarget;
        D21 := 100;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;

    5:
        D20 := aShelfTarget;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;

    6:
        D20 := aShelfTarget;
        D21 := 1000;
        Y20 := TRUE;
        D24 := D103;
        D25 := 1000;
        Y21 := TRUE;

    7, 8:
        D20 := aShelfTarget;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;

ELSE
    D20 := 0;
    D21 := 100;
    Y20 := FALSE;
    D24 := 0;
    D25 := 1000;
    Y21 := FALSE;
END_CASE;

END_PROGRAM