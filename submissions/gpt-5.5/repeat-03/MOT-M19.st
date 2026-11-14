PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;
    state : INT := 0;
    firstTarget : DINT := 0;
    secondTarget : DINT := 0;
    laneTarget : DINT := 0;
    posTol : DINT := 20;
    velTol : DINT := 100;
    fullRate : DINT := 1000;
    aHome : DINT := 6000;
    bRetract : DINT := 0;
    bEngageTarget : DINT := 7000;
    bEngageMin : DINT := 6000;
    bEngageMax : DINT := 7500;
    cWork : DINT := 0;
    cStandby : DINT := 8000;
    dHome : DINT := 0;
    aAtFirst : BOOL;
    aAtSecond : BOOL;
    aAtHome : BOOL;
    bAtRetract : BOOL;
    bAtEngage : BOOL;
    bInEngagement : BOOL;
    cAtWork : BOOL;
    cAtStandby : BOOL;
    dAtLane : BOOL;
    dAtHome : BOOL;
END_VAR

aAtFirst := (ABS(D10 - firstTarget) <= posTol) AND (ABS(D11) <= velTol);
aAtSecond := (ABS(D10 - secondTarget) <= posTol) AND (ABS(D11) <= velTol);
aAtHome := (ABS(D10 - aHome) <= posTol) AND (ABS(D11) <= velTol);

bAtRetract := (ABS(D12 - bRetract) <= posTol) AND (ABS(D13) <= velTol);
bAtEngage := (ABS(D12 - bEngageTarget) <= posTol) AND (ABS(D13) <= velTol);
bInEngagement := (D12 >= bEngageMin) AND (D12 <= bEngageMax);

cAtWork := (ABS(D14 - cWork) <= posTol) AND (ABS(D15) <= velTol);
cAtStandby := (ABS(D14 - cStandby) <= posTol) AND (ABS(D15) <= velTol);

dAtLane := (ABS(D16 - laneTarget) <= posTol) AND (ABS(D17) <= velTol);
dAtHome := (ABS(D16 - dHome) <= posTol) AND (ABS(D17) <= velTol);

CASE state OF
    0:
        D20 := aHome;
        D21 := fullRate;
        Y20 := FALSE;
        D24 := bRetract;
        D25 := fullRate;
        Y21 := FALSE;
        D28 := cWork;
        D29 := fullRate;
        Y22 := FALSE;
        D32 := D103;
        D33 := fullRate;
        Y23 := FALSE;
        Y2 := FALSE;

        IF X0 THEN
            firstTarget := D101;
            secondTarget := D102;
            laneTarget := D103;
            state := 10;
        END_IF;

    10:
        D20 := firstTarget;
        D21 := fullRate;
        Y20 := TRUE;
        D24 := bRetract;
        D25 := fullRate;
        Y21 := TRUE;
        D28 := cWork;
        D29 := fullRate;
        Y22 := TRUE;
        D32 := laneTarget;
        D33 := fullRate;
        Y23 := TRUE;
        Y2 := FALSE;

        IF aAtFirst AND bAtRetract AND cAtWork AND dAtLane THEN
            state := 20;
        END_IF;

    20:
        D20 := firstTarget;
        D21 := fullRate;
        Y20 := TRUE;
        D24 := bEngageTarget;
        D25 := fullRate;
        Y21 := TRUE;
        D28 := cWork;
        D29 := fullRate;
        Y22 := TRUE;
        D32 := laneTarget;
        D33 := fullRate;
        Y23 := TRUE;
        Y2 := FALSE;

        IF NOT (cAtWork AND dAtLane) THEN
            state := 10;
        ELSIF aAtFirst AND bAtEngage AND cAtWork AND dAtLane THEN
            state := 30;
        END_IF;

    30:
        D20 := secondTarget;
        D21 := fullRate;
        Y20 := TRUE;
        D24 := bEngageTarget;
        D25 := fullRate;
        Y21 := TRUE;
        D28 := cWork;
        D29 := fullRate;
        Y22 := TRUE;
        D32 := laneTarget;
        D33 := fullRate;
        Y23 := TRUE;
        Y2 := FALSE;

        IF NOT (bInEngagement AND cAtWork AND dAtLane) THEN
            state := 10;
        ELSIF aAtSecond AND bAtEngage AND cAtWork AND dAtLane THEN
            Y2 := TRUE;
            state := 40;
        END_IF;

    40:
        D20 := secondTarget;
        D21 := fullRate;
        Y20 := TRUE;
        D24 := bRetract;
        D25 := fullRate;
        Y21 := TRUE;
        D28 := cWork;
        D29 := fullRate;
        Y22 := TRUE;
        D32 := laneTarget;
        D33 := fullRate;
        Y23 := TRUE;
        Y2 := TRUE;

        IF bAtRetract THEN
            state := 50;
        END_IF;

    50:
        D20 := aHome;
        D21 := fullRate;
        Y20 := TRUE;
        D24 := bRetract;
        D25 := fullRate;
        Y21 := TRUE;
        D28 := cStandby;
        D29 := fullRate;
        Y22 := TRUE;
        D32 := dHome;
        D33 := fullRate;
        Y23 := TRUE;
        Y2 := TRUE;

        IF aAtHome AND bAtRetract AND cAtStandby AND dAtHome THEN
            state := 60;
        END_IF;

    60:
        D20 := aHome;
        D21 := fullRate;
        Y20 := TRUE;
        D24 := bRetract;
        D25 := fullRate;
        Y21 := TRUE;
        D28 := cStandby;
        D29 := fullRate;
        Y22 := TRUE;
        D32 := dHome;
        D33 := fullRate;
        Y23 := TRUE;
        Y2 := TRUE;

ELSE
    D20 := aHome;
    D21 := fullRate;
    Y20 := FALSE;
    D24 := bRetract;
    D25 := fullRate;
    Y21 := FALSE;
    D28 := cWork;
    D29 := fullRate;
    Y22 := FALSE;
    D32 := dHome;
    D33 := fullRate;
    Y23 := FALSE;
    Y2 := FALSE;
    state := 0;
END_CASE;

END_PROGRAM