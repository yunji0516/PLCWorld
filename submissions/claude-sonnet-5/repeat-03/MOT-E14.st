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
    D20 : DINT;
    Y2 : BOOL;

    (* Internal state *)
    edgeX10        : R_TRIG;
    requestAccepted: BOOL := FALSE;
    targetPos      : REAL := 0.0;

    posA           : REAL := 0.0;
    velA           : REAL := 0.0;
    angle          : REAL := 0.0;
    angVel         : REAL := 0.0;
    posErr         : REAL := 0.0;

    accelCmd       : REAL := 0.0;
    rawCmd         : DINT := 0;

    Kp : REAL := 25.0;   (* mm/s^2 per mm of position error *)
    Kd : REAL := 10.0;   (* mm/s^2 per mm/s of trolley speed *)
    Kt : REAL := 40.0;   (* mm/s^2 per deg of sway angle *)
    Kw : REAL := 60.0;   (* mm/s^2 per deg/s of angular velocity *)

    maxAccel   : REAL := 1800.0;   (* physical acceleration bound mm/s^2 *)
    maxRaw     : DINT := 180000;   (* raw bound matching maxAccel *100 *)
    permMax    : DINT := 200000;   (* published raw command bound *)

    conditionsMet  : BOOL := FALSE;
    stableTimer    : TON;
    resultLatched  : BOOL := FALSE;
END_VAR

(* Detect first acceptance of X10 request and capture hold position *)
edgeX10(CLK := X10);

IF edgeX10.Q AND NOT requestAccepted THEN
    requestAccepted := TRUE;
    targetPos := REAL(D13) * 0.01 + REAL(D10) * 0.01;
END_IF;

IF NOT requestAccepted THEN
    (* Function not yet accepted: keep outputs safely off/idle *)
    D20 := 0;
    conditionsMet := FALSE;
    stableTimer(IN := FALSE, PT := T#30ms);
    resultLatched := FALSE;
    Y2 := FALSE;
ELSE
    (* Read scaled plant feedback *)
    posA   := REAL(D13) * 0.01;
    velA   := REAL(D14) * 0.01;
    angle  := REAL(D15) * 0.01;
    angVel := REAL(D16) * 0.01;

    posErr := posA - targetPos;

    (* Anti-sway + position hold control law *)
    accelCmd := (-Kp * posErr) - (Kd * velA) + (Kt * angle) + (Kw * angVel);

    (* Clamp to physical acceleration bound *)
    IF accelCmd > maxAccel THEN
        accelCmd := maxAccel;
    ELSIF accelCmd < -maxAccel THEN
        accelCmd := -maxAccel;
    END_IF;

    rawCmd := DINT(accelCmd * 100.0);

    (* Enforce raw bounds on every scan *)
    IF rawCmd > maxRaw THEN
        rawCmd := maxRaw;
    ELSIF rawCmd < -maxRaw THEN
        rawCmd := -maxRaw;
    END_IF;

    IF rawCmd > permMax THEN
        rawCmd := permMax;
    ELSIF rawCmd < -permMax THEN
        rawCmd := -permMax;
    END_IF;

    D20 := rawCmd;

    (* Completion condition check *)
    conditionsMet := (ABS(posErr) <= 1.0) AND
                      (ABS(velA) <= 1.0) AND
                      (ABS(angle) <= 0.2) AND
                      (ABS(angVel) <= 1.0);

    stableTimer(IN := conditionsMet, PT := T#30ms);

    IF stableTimer.Q THEN
        resultLatched := TRUE;
    END_IF;

    Y2 := resultLatched;
END_IF;

END_PROGRAM