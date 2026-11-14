PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* internal variables *)
    posPhys      : REAL;
    velPhys      : REAL;
    limPhys      : REAL;
    distance     : REAL;
    reqDecel     : REAL;
    rawDecel     : DINT;

    activated    : BOOL := FALSE;
    initSign     : INT  := 0;

    limitOk      : BOOL;
    speedOk      : BOOL;
    resultOk     : BOOL;

    y2Latch      : BOOL := FALSE;

    stableTimer  : TON;
END_VAR

(* Convert raw ×0.01 values to physical units *)
posPhys := REAL(D11) * 0.01;
velPhys := REAL(D12) * 0.01;
limPhys := REAL(D13) * 0.01;

(* Latch activation only after X10 request accepted *)
IF (NOT activated) AND X10 THEN
    activated := TRUE;
    IF velPhys > 0.0 THEN
        initSign := 1;
    ELSIF velPhys < 0.0 THEN
        initSign := -1;
    ELSE
        initSign := 0;
    END_IF;
END_IF;

IF activated THEN
    Y20 := TRUE;

    (* Compute required deceleration magnitude to stop before the limit *)
    IF initSign >= 0 THEN
        distance := limPhys - posPhys; (* moving toward positive limit *)
        IF distance > 0.0 THEN
            reqDecel := (velPhys * velPhys) / (2.0 * distance);
        ELSE
            reqDecel := 4000.0; (* already at/beyond limit direction - use max *)
        END_IF;
    ELSE
        distance := posPhys - limPhys; (* moving toward negative limit *)
        IF distance > 0.0 THEN
            reqDecel := (velPhys * velPhys) / (2.0 * distance);
        ELSE
            reqDecel := 4000.0;
        END_IF;
    END_IF;

    (* Once stopped, no further deceleration command required *)
    IF ABS(velPhys) <= 1.0 THEN
        reqDecel := 0.0;
    END_IF;

    rawDecel := DINT(reqDecel * 100.0);
    IF rawDecel < 0 THEN
        rawDecel := 0;
    END_IF;
    IF rawDecel > 400000 THEN
        rawDecel := 400000;
    END_IF;

    D20 := rawDecel;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

(* Evaluate actual result: speed at/below 1 mm/s and limit not exceeded *)
IF initSign >= 0 THEN
    limitOk := posPhys <= limPhys;
ELSE
    limitOk := posPhys >= limPhys;
END_IF;

speedOk  := ABS(velPhys) <= 1.0;
resultOk := speedOk AND limitOk;

stableTimer(IN := (resultOk AND activated), PT := T#30ms);

IF stableTimer.Q THEN
    y2Latch := TRUE;
END_IF;

Y2 := y2Latch;

END_PROGRAM