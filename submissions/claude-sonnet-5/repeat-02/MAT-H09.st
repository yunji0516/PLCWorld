PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* internal *)
    started      : BOOL := FALSE;
    startTrig    : R_TRIG;

    aState       : INT := 0;
    bState       : INT := 0;
    aPushing     : BOOL := FALSE;
    bPushing     : BOOL := FALSE;
    aRequested   : BOOL := FALSE;
    bRequested   : BOOL := FALSE;

    valveDelayA  : TON;
    settleA      : TON;
    trimA        : TON;
    valveDelayB  : TON;
    settleB      : TON;
    trimB        : TON;

    margin_units : INT := 290;   (* worst case in-flight, ~29.0 mL *)
    tol_units    : INT := 5;     (* 0.5 mL tolerance *)
    shortfallA   : INT := 0;
    shortfallB   : INT := 0;

    LOW_THRESH   : INT := 100;   (* 10 mL *)
    tankLow      : BOOL := FALSE;
    allowA       : BOOL := TRUE;
    allowB       : BOOL := TRUE;

    swapReq      : BOOL := FALSE;
    swapTrig     : R_TRIG;

    wantA        : BOOL := FALSE;
    wantB        : BOOL := FALSE;

    completionOK   : BOOL := FALSE;
    completeStable : TON;
END_VAR

(* ---- Start latch ---- *)
startTrig(CLK := X0);
IF startTrig.Q THEN
    started := TRUE;
END_IF;

(* ---- Tank / batch refill and swap ---- *)
IF started THEN
    Y10 := X2F AND (D0 < 1600) AND NOT X30;
ELSE
    Y10 := FALSE;
END_IF;

swapReq := started AND (NOT X2F) AND X31 AND NOT X30 AND NOT Y10;
swapTrig(CLK := swapReq);
Y11 := swapTrig.Q;

(* ---- Tank-low pump arbitration ---- *)
tankLow := D0 <= LOW_THRESH;
IF tankLow AND (aState = 5) AND (bState = 5) THEN
    allowA := TRUE;
    allowB := FALSE;
ELSE
    allowA := TRUE;
    allowB := TRUE;
END_IF;

(* ---- Reset states if not started ---- *)
IF NOT started THEN
    aState := 0;
    bState := 0;
    aPushing := FALSE;
    bPushing := FALSE;
END_IF;

(* ---- Line A timers ---- *)
valveDelayA(IN := (aState = 4), PT := T#150ms);
settleA(IN := (aState = 6), PT := T#1800ms);
trimA(IN := (aState = 7), PT := T#200ms);

(* ---- Line A sequence ---- *)
CASE aState OF
    0:
        IF started AND X11 AND NOT X10 THEN
            aState := 1;
        END_IF;
    1:
        IF X10 THEN
            aState := 2;
        END_IF;
    2:
        IF X14 THEN
            aState := 3;
        END_IF;
    3:
        IF X13 THEN
            aState := 4;
        END_IF;
    4:
        IF valveDelayA.Q AND X16 THEN
            aState := 5;
        END_IF;
    5:
        IF D4 >= (D5 - margin_units) THEN
            aState := 6;
        END_IF;
    6:
        IF settleA.Q THEN
            shortfallA := D5 - D4;
            IF shortfallA > tol_units THEN
                aState := 7;
            ELSE
                aState := 8;
            END_IF;
        END_IF;
    7:
        IF trimA.Q THEN
            aState := 6;
        END_IF;
    8:
        IF X17 THEN
            aState := 9;
        END_IF;
    9:
        IF X12 AND X15 THEN
            aState := 10;
        END_IF;
    10:
        IF (NOT X1A) AND (NOT aPushing) THEN
            aPushing := TRUE;
        END_IF;
        IF aPushing AND X1A THEN
            aPushing := FALSE;
            aState := 11;
        END_IF;
    11:
        aState := 0;
    ELSE
        aState := 0;
END_CASE;

Y14 := (aState = 1);
Y15 := (aState >= 2) AND (aState <= 8);
Y16 := (aState >= 3) AND (aState <= 8);
Y17 := (aState >= 4) AND (aState <= 7);
Y18 := ((aState = 5) OR (aState = 7)) AND allowA;
Y19 := (aState = 10) AND aPushing;

(* ---- Line B timers ---- *)
valveDelayB(IN := (bState = 4), PT := T#150ms);
settleB(IN := (bState = 6), PT := T#1800ms);
trimB(IN := (bState = 7), PT := T#200ms);

(* ---- Line B sequence ---- *)
CASE bState OF
    0:
        IF started AND X1F AND NOT X1E THEN
            bState := 1;
        END_IF;
    1:
        IF X1E THEN
            bState := 2;
        END_IF;
    2:
        IF X22 THEN
            bState := 3;
        END_IF;
    3:
        IF X21 THEN
            bState := 4;
        END_IF;
    4:
        IF valveDelayB.Q AND X24 THEN
            bState := 5;
        END_IF;
    5:
        IF D9 >= (D10 - margin_units) THEN
            bState := 6;
        END_IF;
    6:
        IF settleB.Q THEN
            shortfallB := D10 - D9;
            IF shortfallB > tol_units THEN
                bState := 7;
            ELSE
                bState := 8;
            END_IF;
        END_IF;
    7:
        IF trimB.Q THEN
            bState := 6;
        END_IF;
    8:
        IF X25 THEN
            bState := 9;
        END_IF;
    9:
        IF X20 AND X23 THEN
            bState := 10;
        END_IF;
    10:
        IF (NOT X28) AND (NOT bPushing) THEN
            bPushing := TRUE;
        END_IF;
        IF bPushing AND X28 THEN
            bPushing := FALSE;
            bState := 11;
        END_IF;
    11:
        bState := 0;
    ELSE
        bState := 0;
END_CASE;

Y1B := (bState = 1);
Y1C := (bState >= 2) AND (bState <= 8);
Y1D := (bState >= 3) AND (bState <= 8);
Y1E := (bState >= 4) AND (bState <= 7);
Y1F := ((bState = 5) OR (bState = 7)) AND allowB;
Y20 := (bState = 10) AND bPushing;

(* ---- Common capping head arbitration ---- *)
wantA := X1A AND NOT X1B AND NOT X2C AND NOT aRequested;
wantB := X28 AND NOT X29 AND NOT X2C AND NOT bRequested;

Y12 := FALSE;
Y13 := FALSE;
IF wantA THEN
    Y12 := TRUE;
    aRequested := TRUE;
ELSIF wantB THEN
    Y13 := TRUE;
    bRequested := TRUE;
END_IF;

IF NOT X1A THEN
    aRequested := FALSE;
END_IF;
IF NOT X28 THEN
    bRequested := FALSE;
END_IF;

(* ---- Release to exit accumulation ---- *)
Y1A := X1B AND X1C;
Y21 := X29 AND X2A;

(* ---- Completion ---- *)
completionOK := X32 AND (NOT Y10) AND (NOT Y18) AND (NOT Y1F) AND (NOT Y17) AND (NOT Y1E)
                AND X17 AND X25 AND X12 AND X20
                AND (NOT X2C) AND (NOT X30) AND (NOT Y11);

completeStable(IN := completionOK, PT := T#500ms);
Y22 := completeStable.Q;

END_PROGRAM