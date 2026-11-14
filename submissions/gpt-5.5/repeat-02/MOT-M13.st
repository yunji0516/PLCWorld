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
    stage : INT := 0;
    started : BOOL := FALSE;
    reqAngle : DINT := 0;
    reqTarget : DINT := 0;
    reqReceive : DINT := 0;
    holdCount : INT := 0;
    fullRate : DINT := 1000;
    zeroPos : DINT := 0;
    aClear : DINT := 12000;
    aDock : DINT := 10000;
    posTol : DINT := 20;
    velTol : DINT := 100;
    aAt0 : BOOL;
    aAt120 : BOOL;
    aAt100 : BOOL;
    bAt0 : BOOL;
    bAtReq : BOOL;
    cAt0 : BOOL;
    cAtReq : BOOL;
    dAt0 : BOOL;
    dAtReq : BOOL;
END_VAR

IF (NOT started) AND X0 THEN
    started := TRUE;
    stage := 1;
    reqAngle := D101;
    reqTarget := D102;
    reqReceive := D103;
    holdCount := 0;
END_IF;

aAt0 := (ABS(D10 - zeroPos) <= posTol) AND (ABS(D11) <= velTol);
aAt120 := (ABS(D10 - aClear) <= posTol) AND (ABS(D11) <= velTol);
aAt100 := (ABS(D10 - aDock) <= posTol) AND (ABS(D11) <= velTol);
bAt0 := (ABS(D12 - zeroPos) <= posTol) AND (ABS(D13) <= velTol);
bAtReq := (ABS(D12 - reqAngle) <= posTol) AND (ABS(D13) <= velTol);
cAt0 := (ABS(D14 - zeroPos) <= posTol) AND (ABS(D15) <= velTol);
cAtReq := (ABS(D14 - reqTarget) <= posTol) AND (ABS(D15) <= velTol);
dAt0 := (ABS(D16 - zeroPos) <= posTol) AND (ABS(D17) <= velTol);
dAtReq := (ABS(D16 - reqReceive) <= posTol) AND (ABS(D17) <= velTol);

IF NOT started THEN
    stage := 0;
ELSE
    CASE stage OF
        1:
            IF aAt120 AND bAtReq THEN
                stage := 2;
            END_IF;
        2:
            IF aAt120 AND bAtReq AND cAtReq AND dAtReq THEN
                stage := 3;
            END_IF;
        3:
            IF aAt100 AND bAtReq AND cAtReq AND dAtReq THEN
                stage := 5;
                holdCount := 0;
            END_IF;
        5:
            holdCount := holdCount + 1;
            IF holdCount >= 15 THEN
                stage := 6;
            END_IF;
        6:
            IF aAt120 AND bAtReq AND cAtReq AND dAtReq THEN
                stage := 7;
            END_IF;
        7:
            IF aAt120 AND bAtReq AND cAt0 AND dAtReq THEN
                stage := 8;
            END_IF;
        8:
            IF aAt0 AND bAt0 AND cAt0 AND dAt0 THEN
                stage := 9;
            END_IF;
        9:
            stage := 9;
        ELSE
            stage := 0;
    END_CASE;
END_IF;

D21 := fullRate;
D25 := fullRate;
D29 := fullRate;
D33 := fullRate;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y2 := FALSE;
D20 := zeroPos;
D24 := zeroPos;
D28 := zeroPos;
D32 := zeroPos;

CASE stage OF
    0:
        D20 := zeroPos;
        D24 := zeroPos;
        D28 := zeroPos;
        D32 := zeroPos;
    1:
        D20 := aClear;
        D24 := reqAngle;
        D28 := zeroPos;
        D32 := reqReceive;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
    2:
        D20 := aClear;
        D24 := reqAngle;
        D28 := reqTarget;
        D32 := reqReceive;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
    3:
        D20 := aDock;
        D24 := reqAngle;
        D28 := reqTarget;
        D32 := reqReceive;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
    5:
        D20 := aDock;
        D24 := reqAngle;
        D28 := reqTarget;
        D32 := reqReceive;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
        Y2 := TRUE;
    6:
        D20 := aClear;
        D24 := reqAngle;
        D28 := reqTarget;
        D32 := reqReceive;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
    7:
        D20 := aClear;
        D24 := reqAngle;
        D28 := zeroPos;
        D32 := reqReceive;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
    8:
        D20 := zeroPos;
        D24 := zeroPos;
        D28 := zeroPos;
        D32 := zeroPos;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
    9:
        D20 := zeroPos;
        D24 := zeroPos;
        D28 := zeroPos;
        D32 := zeroPos;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
    ELSE
        D20 := zeroPos;
        D24 := zeroPos;
        D28 := zeroPos;
        D32 := zeroPos;
END_CASE;

END_PROGRAM