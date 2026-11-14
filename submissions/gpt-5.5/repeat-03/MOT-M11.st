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
    (* Add internal variables here. *)
    state : INT := 0;
    firstTarget : DINT := 0;
    secondTarget : DINT := 0;
    depth1Target : DINT := 0;
    depth2Target : DINT := 0;
    aAtFirst : BOOL := FALSE;
    aAtSecond : BOOL := FALSE;
    bAtZero : BOOL := FALSE;
    cAtZero : BOOL := FALSE;
    bAtDepth : BOOL := FALSE;
    cAtDepth : BOOL := FALSE;
    bDone : BOOL := FALSE;
    cDone : BOOL := FALSE;
END_VAR

aAtFirst := (ABS(D10 - firstTarget) <= 20) AND (ABS(D11) <= 100);
aAtSecond := (ABS(D10 - secondTarget) <= 20) AND (ABS(D11) <= 100);
bAtZero := (ABS(D12) <= 20) AND (ABS(D13) <= 100);
cAtZero := (ABS(D14) <= 20) AND (ABS(D15) <= 100);
bAtDepth := (ABS(D12 - depth1Target) <= 20) AND (ABS(D13) <= 100);
cAtDepth := (ABS(D14 - depth2Target) <= 20) AND (ABS(D15) <= 100);

CASE state OF
    0:
        D20 := D101;
        D21 := 1000;
        Y20 := FALSE;
        D24 := 0;
        D25 := 1000;
        Y21 := FALSE;
        D28 := 0;
        D29 := 1000;
        Y22 := FALSE;
        Y2 := FALSE;
        bDone := FALSE;
        cDone := FALSE;

        IF X0 THEN
            firstTarget := D101;
            secondTarget := D102;
            depth1Target := D103;
            depth2Target := D104;
            state := 10;
        END_IF;

    10:
        D20 := firstTarget;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y22 := TRUE;
        Y2 := FALSE;

        IF aAtFirst AND bAtZero AND cAtZero THEN
            state := 20;
        END_IF;

    20:
        D20 := firstTarget;
        D21 := 1000;
        Y20 := TRUE;
        D24 := depth1Target;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y22 := TRUE;
        Y2 := FALSE;

        IF aAtFirst AND bAtDepth THEN
            bDone := TRUE;
            state := 30;
        END_IF;

    30:
        D20 := firstTarget;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y22 := TRUE;
        Y2 := FALSE;

        IF bAtZero THEN
            state := 40;
        END_IF;

    40:
        D20 := secondTarget;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y22 := TRUE;
        Y2 := FALSE;

        IF aAtSecond AND bAtZero AND cAtZero AND bDone THEN
            state := 50;
        END_IF;

    50:
        D20 := secondTarget;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := depth2Target;
        D29 := 1000;
        Y22 := TRUE;
        Y2 := FALSE;

        IF aAtSecond AND cAtDepth THEN
            cDone := TRUE;
            state := 60;
        END_IF;

    60:
        D20 := secondTarget;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y22 := TRUE;
        Y2 := FALSE;

        IF aAtSecond AND bAtZero AND cAtZero AND bDone AND cDone THEN
            state := 70;
        END_IF;

    70:
        D20 := secondTarget;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y22 := TRUE;
        Y2 := TRUE;

    ELSE
        D20 := secondTarget;
        D21 := 1000;
        Y20 := FALSE;
        D24 := 0;
        D25 := 1000;
        Y21 := FALSE;
        D28 := 0;
        D29 := 1000;
        Y22 := FALSE;
        Y2 := FALSE;
        state := 0;
END_CASE;

END_PROGRAM