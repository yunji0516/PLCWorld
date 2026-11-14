PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    D15 : DINT;
    D16 : DINT;
    D18 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    reqEdge : R_TRIG;
    stableTimer : TON;
    doneLatch : BOOL;
    moveStarted : BOOL;
    reqCount : DINT;
    startB : DINT;
    targetB : DINT;
    d20Cmd : DINT;
    posErrM : REAL;
    velMps : REAL;
    thetaRad : REAL;
    omegaRadps : REAL;
    accCmd : REAL;
    accCounts : DINT;
    stableCond : BOOL;
    hoistReady : BOOL;
END_VAR

(* Implement the control logic here. *)

reqEdge(CLK := X10);

IF reqEdge.Q THEN
    startB := D13;
    reqCount := 0;
    moveStarted := FALSE;
    doneLatch := FALSE;
END_IF;

IF X10 THEN
    IF reqCount < 1000000 THEN
        reqCount := reqCount + 1;
    END_IF;
ELSE
    reqCount := 0;
    moveStarted := FALSE;
    doneLatch := FALSE;
END_IF;

IF X10 THEN
    d20Cmd := D10;
    IF d20Cmd < 60000 THEN
        d20Cmd := 60000;
    ELSIF d20Cmd > 160000 THEN
        d20Cmd := 160000;
    END_IF;
    D20 := d20Cmd;
    Y20 := TRUE;
ELSE
    d20Cmd := D11;
    IF d20Cmd < 60000 THEN
        d20Cmd := 60000;
    ELSIF d20Cmd > 160000 THEN
        d20Cmd := 160000;
    END_IF;
    D20 := d20Cmd;
    Y20 := FALSE;
END_IF;

hoistReady := (ABS(D11 - D10) <= 500) AND (ABS(D12) <= 1000);

IF X10 AND ((reqCount >= 110) OR hoistReady) THEN
    moveStarted := TRUE;
END_IF;

IF X10 THEN
    IF moveStarted THEN
        targetB := D17;
    ELSE
        targetB := startB;
    END_IF;

    posErrM := REAL(targetB - D13) * 0.00001;
    velMps := REAL(D14) * 0.00001;
    thetaRad := REAL(D15 - D18) * 0.000174532925;
    omegaRadps := REAL(D16) * 0.000174532925;

    accCmd := (2.2 * posErrM) - (3.0 * velMps) + (8.0 * thetaRad) + (6.0 * omegaRadps);

    IF accCmd > 3.9 THEN
        accCmd := 3.9;
    ELSIF accCmd < -3.9 THEN
        accCmd := -3.9;
    END_IF;

    accCounts := DINT(accCmd * 100000.0);

    IF accCounts > 400000 THEN
        accCounts := 400000;
    ELSIF accCounts < -400000 THEN
        accCounts := -400000;
    END_IF;

    D21 := accCounts;
ELSE
    accCmd := 0.0;
    D21 := 0;
END_IF;

stableCond := X10
              AND moveStarted
              AND (ABS(D11 - D10) <= 100)
              AND (ABS(D12) <= 100)
              AND (ABS(D13 - D17) <= 100)
              AND (ABS(D14) <= 100)
              AND (ABS(D15 - D18) <= 20)
              AND (ABS(D16) <= 100)
              AND (ABS(accCmd) <= 0.10);

stableTimer(IN := stableCond, PT := T#30ms);

IF stableTimer.Q THEN
    doneLatch := TRUE;
END_IF;

Y2 := doneLatch;

END_PROGRAM