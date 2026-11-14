PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D20 : DINT;
    Y20 : BOOL;
    D21 : DINT;
    Y21 : BOOL;
    D22 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;

    (* Internal variables *)
    reqTrig     : R_TRIG;
    state       : INT := 0;      // 0=idle,1=raise A,2=swap X,3=lower A,4=done/hold
    requestActive : BOOL := FALSE;
    targetA     : DINT := 0;
    targetB     : DINT := 0;

    tolPos      : DINT := 20;     // 0.2 mm  * 100 (D scale 0.01mm)
    tolSpd      : DINT := 100;    // 1 mm/s  * 100 (D scale 0.01mm/s)
    raiseElev   : DINT := 40000;  // 400 mm  * 100

    doneTimer   : TON;
    completeCond : BOOL := FALSE;
END_VAR

(* ---- Edge detect single task request ---- *)
reqTrig(CLK := X10);

IF reqTrig.Q AND NOT requestActive THEN
    targetA := D10;
    targetB := D13;
    requestActive := TRUE;
    state := 1;
END_IF;

(* ---- Motion state machine ---- *)
CASE state OF

0: // Idle - motion not activated before request acceptance
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    D20 := D11;
    D21 := D14;
    D22 := D16;

1: // Raise A elevation to secure vertical clearance before crossing X
    D20 := D11;
    Y20 := TRUE;
    D21 := D14;
    Y21 := TRUE;
    D22 := raiseElev;
    Y22 := TRUE;

    IF (ABS(D16 - raiseElev) <= tolPos) AND (ABS(D17) <= tolSpd) THEN
        state := 2;
    END_IF;

2: // Swap horizontal positions while A remains elevated
    D20 := targetA;
    Y20 := TRUE;
    D21 := targetB;
    Y21 := TRUE;
    D22 := raiseElev;
    Y22 := TRUE;

    IF (ABS(D11 - targetA) <= tolPos) AND (ABS(D12) <= tolSpd) AND
       (ABS(D14 - targetB) <= tolPos) AND (ABS(D15) <= tolSpd) THEN
        state := 3;
    END_IF;

3: // Lower A back to working height (0 mm)
    D20 := targetA;
    Y20 := TRUE;
    D21 := targetB;
    Y21 := TRUE;
    D22 := 0;
    Y22 := TRUE;

    IF (ABS(D16 - 0) <= tolPos) AND (ABS(D17) <= tolSpd) THEN
        state := 4;
    END_IF;

4: // Hold final commanded positions
    D20 := targetA;
    Y20 := TRUE;
    D21 := targetB;
    Y21 := TRUE;
    D22 := 0;
    Y22 := TRUE;

ELSE
    state := 0;

END_CASE;

(* ---- Completion evaluation ---- *)
completeCond := (state = 4) AND
                (ABS(D11 - targetA) <= tolPos) AND (ABS(D12) <= tolSpd) AND
                (ABS(D14 - targetB) <= tolPos) AND (ABS(D15) <= tolSpd) AND
                (ABS(D16 - 0) <= tolPos) AND (ABS(D17) <= tolSpd);

doneTimer(IN := completeCond, PT := T#30ms);
Y2 := doneTimer.Q;

END_PROGRAM