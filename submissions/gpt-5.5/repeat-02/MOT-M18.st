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
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;
    state : INT := 0;
    refEdge : R_TRIG;
    cfgTimer : TON;
    searchClk : BOOL;
    bAt0 : BOOL;
    cAt100 : BOOL;
    aAtBase : BOOL;
    aAtStop : BOOL;
    aAtFinal : BOOL;
    edgeRaw : DINT := 0;
    stopRaw : DINT := 0;
    finalRaw : DINT := 0;
    baseRaw : DINT := 2000;
    bZeroRaw : DINT := 0;
    cHighRaw : DINT := 10000;
    searchTargetRaw : DINT := 35000;
    fastRate : DINT := 1000;
    searchRate : DINT := 80;
    posTolRaw : DINT := 20;
    velTolRaw : DINT := 100;
END_VAR

IF (state = 0) AND X0 THEN
    state := 1;
END_IF;

searchClk := (state = 4) AND X34;
refEdge(CLK := searchClk);
cfgTimer(IN := (state = 6), PT := T#600ms);

bAt0 := (ABS(D12 - bZeroRaw) <= posTolRaw) AND (ABS(D13) <= velTolRaw);
cAt100 := (ABS(D14 - cHighRaw) <= posTolRaw) AND (ABS(D15) <= velTolRaw);
aAtBase := (ABS(D10 - baseRaw) <= posTolRaw) AND (ABS(D11) <= velTolRaw);
aAtStop := (ABS(D10 - stopRaw) <= posTolRaw) AND (ABS(D11) <= velTolRaw);
finalRaw := D90 + D101;
aAtFinal := (ABS(D10 - finalRaw) <= posTolRaw) AND (ABS(D11) <= velTolRaw);

D20 := 0;
D21 := 0;
Y20 := FALSE;
D24 := bZeroRaw;
D25 := 0;
Y21 := FALSE;
D28 := 0;
D29 := 0;
Y22 := FALSE;
Y30 := FALSE;
Y2 := FALSE;

CASE state OF
    0:
        D20 := 0;
        D21 := 0;
        Y20 := FALSE;
        D24 := bZeroRaw;
        D25 := 0;
        Y21 := FALSE;
        D28 := 0;
        D29 := 0;
        Y22 := FALSE;

    1:
        D20 := D10;
        D21 := 0;
        Y20 := FALSE;
        D24 := bZeroRaw;
        D25 := fastRate;
        Y21 := TRUE;
        D28 := 0;
        D29 := 0;
        Y22 := FALSE;

        IF bAt0 THEN
            state := 2;
        END_IF;

    2:
        D20 := D10;
        D21 := 0;
        Y20 := FALSE;
        D24 := bZeroRaw;
        D25 := fastRate;
        Y21 := TRUE;
        D28 := cHighRaw;
        D29 := fastRate;
        Y22 := TRUE;

        IF bAt0 AND cAt100 THEN
            state := 3;
        END_IF;

    3:
        D20 := baseRaw;
        D21 := fastRate;
        Y20 := TRUE;
        D24 := bZeroRaw;
        D25 := fastRate;
        Y21 := TRUE;
        D28 := cHighRaw;
        D29 := fastRate;
        Y22 := TRUE;

        IF aAtBase AND bAt0 AND cAt100 AND (NOT X34) THEN
            state := 4;
        END_IF;

    4:
        D20 := searchTargetRaw;
        D21 := searchRate;
        Y20 := TRUE;
        D24 := bZeroRaw;
        D25 := fastRate;
        Y21 := TRUE;
        D28 := cHighRaw;
        D29 := fastRate;
        Y22 := TRUE;

        IF refEdge.Q THEN
            edgeRaw := D10;
            stopRaw := D10 + 500;
            D20 := stopRaw;
            D21 := searchRate;
            state := 5;
        END_IF;

    5:
        D20 := stopRaw;
        D21 := searchRate;
        Y20 := TRUE;
        D24 := bZeroRaw;
        D25 := fastRate;
        Y21 := TRUE;
        D28 := cHighRaw;
        D29 := fastRate;
        Y22 := TRUE;

        IF aAtStop AND bAt0 AND cAt100 THEN
            state := 6;
        END_IF;

    6:
        D20 := stopRaw;
        D21 := searchRate;
        Y20 := TRUE;
        D24 := bZeroRaw;
        D25 := fastRate;
        Y21 := TRUE;
        D28 := cHighRaw;
        D29 := fastRate;
        Y22 := TRUE;
        Y30 := TRUE;

        IF cfgTimer.Q AND X35 AND (ABS(D90 - edgeRaw) <= 100) THEN
            state := 7;
        END_IF;

    7:
        D20 := finalRaw;
        D21 := fastRate;
        Y20 := TRUE;
        D24 := bZeroRaw;
        D25 := fastRate;
        Y21 := TRUE;
        D28 := cHighRaw;
        D29 := fastRate;
        Y22 := TRUE;

        IF aAtFinal AND bAt0 AND cAt100 THEN
            Y2 := TRUE;
            state := 8;
        END_IF;

    8:
        D20 := finalRaw;
        D21 := fastRate;
        Y20 := TRUE;
        D24 := bZeroRaw;
        D25 := fastRate;
        Y21 := TRUE;
        D28 := cHighRaw;
        D29 := fastRate;
        Y22 := TRUE;
        Y2 := TRUE;

ELSE
    D20 := 0;
    D21 := 0;
    Y20 := FALSE;
    D24 := bZeroRaw;
    D25 := 0;
    Y21 := FALSE;
    D28 := 0;
    D29 := 0;
    Y22 := FALSE;
END_CASE;

END_PROGRAM