PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    started : BOOL;
    firstDone : BOOL;
    secondDone : BOOL;
    stage : INT;
    firstReq : DINT;
    secondReq : DINT;
    depthReq : DINT;
    reachReq : DINT;
    safeB : DINT := 12000;
    zeroPos : DINT := 0;
    fullRate : DINT := 1000;
    posTol : DINT := 20;
    velTol : DINT := 100;
    aAtZero : BOOL;
    bAtZero : BOOL;
    cAtZero : BOOL;
    aAtFirst : BOOL;
    aAtSecond : BOOL;
    bAtDepth : BOOL;
    bAtSafe : BOOL;
    cAtReach : BOOL;
    cAtZero : BOOL;
END_VAR

IF (NOT started) AND X0 THEN
    started := TRUE;
    firstDone := FALSE;
    secondDone := FALSE;
    firstReq := D101;
    secondReq := D102;
    depthReq := D103;
    reachReq := D104;
    stage := 10;
END_IF;

aAtZero := (ABS(D10 - zeroPos) <= posTol) AND (ABS(D11) <= velTol);
bAtZero := (ABS(D12 - zeroPos) <= posTol) AND (ABS(D13) <= velTol);
cAtZero := (ABS(D14 - zeroPos) <= posTol) AND (ABS(D15) <= velTol);
aAtFirst := (ABS(D10 - firstReq) <= posTol) AND (ABS(D11) <= velTol);
aAtSecond := (ABS(D10 - secondReq) <= posTol) AND (ABS(D11) <= velTol);
bAtDepth := (ABS(D12 - depthReq) <= posTol) AND (ABS(D13) <= velTol);
bAtSafe := (ABS(D12 - safeB) <= posTol) AND (ABS(D13) <= velTol);
cAtReach := (ABS(D14 - reachReq) <= posTol) AND (ABS(D15) <= velTol);
cAtZero := (ABS(D14 - zeroPos) <= posTol) AND (ABS(D15) <= velTol);

D21 := fullRate;
D25 := fullRate;
D29 := fullRate;
Y2 := FALSE;

IF NOT started THEN
    D20 := zeroPos;
    D24 := zeroPos;
    D28 := zeroPos;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
ELSE
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;

    CASE stage OF
        10:
            D20 := zeroPos;
            D24 := safeB;
            D28 := zeroPos;
            IF aAtZero AND bAtSafe AND cAtZero THEN
                stage := 20;
            END_IF;

        20:
            D20 := firstReq;
            D24 := safeB;
            D28 := zeroPos;
            IF aAtFirst AND bAtSafe AND cAtZero THEN
                stage := 30;
            END_IF;

        30:
            D20 := firstReq;
            D24 := zeroPos;
            D28 := zeroPos;
            IF aAtFirst AND bAtZero AND cAtZero THEN
                firstDone := TRUE;
                stage := 40;
            END_IF;

        40:
            D20 := firstReq;
            D24 := safeB;
            D28 := zeroPos;
            IF aAtFirst AND bAtSafe AND cAtZero THEN
                stage := 50;
            END_IF;

        50:
            D20 := secondReq;
            D24 := safeB;
            D28 := reachReq;
            IF aAtSecond AND bAtSafe AND cAtReach THEN
                stage := 60;
            END_IF;

        60:
            D20 := secondReq;
            D24 := depthReq;
            D28 := reachReq;
            IF aAtSecond AND bAtDepth AND cAtReach THEN
                secondDone := TRUE;
                stage := 70;
            END_IF;

        70:
            D20 := secondReq;
            D24 := safeB;
            D28 := reachReq;
            IF aAtSecond AND bAtSafe AND cAtReach THEN
                stage := 80;
            END_IF;

        80:
            D20 := zeroPos;
            D24 := safeB;
            D28 := zeroPos;
            IF aAtZero AND bAtSafe AND cAtZero THEN
                stage := 85;
            END_IF;

        85:
            D20 := zeroPos;
            D24 := zeroPos;
            D28 := zeroPos;
            IF firstDone AND secondDone AND aAtZero AND bAtZero AND cAtZero THEN
                stage := 90;
            END_IF;

        90:
            D20 := zeroPos;
            D24 := zeroPos;
            D28 := zeroPos;
            Y2 := TRUE;

        ELSE
            D20 := zeroPos;
            D24 := zeroPos;
            D28 := zeroPos;
            stage := 10;
    END_CASE;
END_IF;

END_PROGRAM