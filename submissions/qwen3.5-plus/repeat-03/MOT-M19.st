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

    state : INT;
    startEdge : R_TRIG;
    y2HoldTimer : TON;

    firstTarget : DINT;
    secondTarget : DINT;
    laneTarget : DINT;

    posTol : DINT := 20;
    speedTol : DINT := 100;
END_VAR

startEdge(CLK := X0);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;

        IF startEdge.Q THEN
            firstTarget := D101;
            secondTarget := D102;
            laneTarget := D103;
            state := 1;
        END_IF;

    1:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := TRUE;

        D28 := 0;
        D29 := 800;
        D32 := laneTarget;
        D33 := 800;

        IF (ABS(D14) <= posTol) AND (ABS(D15) <= speedTol)
           AND (ABS(D16 - laneTarget) <= posTol) AND (ABS(D17) <= speedTol) THEN
            state := 2;
        END_IF;

    2:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;

        D20 := firstTarget;
        D21 := 800;
        D24 := 7000;
        D25 := 800;
        D28 := 0;
        D29 := 800;
        D32 := laneTarget;
        D33 := 800;

        IF (ABS(D10 - firstTarget) <= posTol) AND (ABS(D11) <= speedTol)
           AND (ABS(D12 - 7000) <= posTol) AND (ABS(D13) <= speedTol) THEN
            state := 3;
        END_IF;

    3:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;

        D20 := secondTarget;
        D21 := 800;
        D24 := 7000;
        D25 := 800;
        D28 := 0;
        D29 := 800;
        D32 := laneTarget;
        D33 := 800;

        IF (D12 < 6000) OR (D12 > 7500) OR (ABS(D14) > posTol) OR (ABS(D16 - laneTarget) > posTol) THEN
            state := 1;
        ELSIF (ABS(D10 - secondTarget) <= posTol) AND (ABS(D11) <= speedTol) THEN
            state := 4;
        END_IF;

    4:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;

        D20 := secondTarget;
        D21 := 800;
        D24 := 7000;
        D25 := 800;
        D28 := 0;
        D29 := 800;
        D32 := laneTarget;
        D33 := 800;

        Y2 := TRUE;
        state := 5;

    5:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;

        D20 := secondTarget;
        D21 := 800;
        D24 := 7000;
        D25 := 800;
        D28 := 0;
        D29 := 800;
        D32 := laneTarget;
        D33 := 800;

        Y2 := TRUE;

        y2HoldTimer(IN := TRUE, PT := T#100ms);
        IF y2HoldTimer.Q THEN
            state := 6;
        END_IF;

    6:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;

        D20 := 6000;
        D21 := 800;
        D24 := 0;
        D25 := 800;
        D28 := 8000;
        D29 := 800;
        D32 := 0;
        D33 := 800;

        Y2 := TRUE;

        IF (ABS(D10 - 6000) <= posTol) AND (ABS(D11) <= speedTol)
           AND (ABS(D12 - 0) <= posTol) AND (ABS(D13) <= speedTol)
           AND (ABS(D14 - 8000) <= posTol) AND (ABS(D15) <= speedTol)
           AND (ABS(D16 - 0) <= posTol) AND (ABS(D17) <= speedTol) THEN
            state := 7;
        END_IF;

    7:
        Y2 := TRUE;

        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;

        D20 := 6000;
        D21 := 800;
        D24 := 0;
        D25 := 800;
        D28 := 8000;
        D29 := 800;
        D32 := 0;
        D33 := 800;
END_CASE;

END_PROGRAM