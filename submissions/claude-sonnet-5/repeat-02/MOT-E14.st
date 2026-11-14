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
    activated   : BOOL := FALSE;
    target_pos  : REAL := 0.0;

    posA        : REAL;
    velA        : REAL;
    angleC      : REAL;
    omegaC      : REAL;
    posErr      : REAL;
    accCmd      : REAL;
    cmdRaw      : DINT;
    cond_ok     : BOOL;

    stableTimer : TON;

    (* Control gains *)
    Kx   : REAL := 2.0;
    Kdx  : REAL := 3.0;
    Kth  : REAL := 5.0;
    Kv   : REAL := 15.0;

    (* Bounds *)
    maxAcc     : REAL := 1800.0;
    maxCmdRaw  : DINT := 180000;
END_VAR

(* Latch activation and hold-target position on first accepted request *)
IF X10 AND NOT activated THEN
    activated  := TRUE;
    target_pos := REAL(D13) * 0.01 + REAL(D10) * 0.01;
END_IF;

IF activated THEN
    posA   := REAL(D13) * 0.01;
    velA   := REAL(D14) * 0.01;
    angleC := REAL(D15) * 0.01;
    omegaC := REAL(D16) * 0.01;

    posErr := posA - target_pos;

    (* PD position hold + swing-damping feedback *)
    accCmd := (-Kx * posErr) - (Kdx * velA) + (Kth * angleC) + (Kv * omegaC);

    (* Clamp acceleration to physical maximum *)
    IF accCmd > maxAcc THEN
        accCmd := maxAcc;
    ELSIF accCmd < -maxAcc THEN
        accCmd := -maxAcc;
    END_IF;

    cmdRaw := DINT(ROUND(accCmd * 100.0));

    (* Clamp raw command word *)
    IF cmdRaw > maxCmdRaw THEN
        cmdRaw := maxCmdRaw;
    ELSIF cmdRaw < -maxCmdRaw THEN
        cmdRaw := -maxCmdRaw;
    END_IF;

    D20 := cmdRaw;

    (* Completion condition on actual physical state *)
    cond_ok := (ABS(posErr) <= 1.0) AND (ABS(velA) <= 1.0)
               AND (ABS(angleC) <= 0.2) AND (ABS(omegaC) <= 1.0);
ELSE
    (* Not yet activated: keep command neutral, no function published *)
    D20 := 0;
    cond_ok := FALSE;
END_IF;

(* Stability timer: 30 ms continuous satisfaction of completion thresholds *)
stableTimer(IN := cond_ok, PT := T#30ms);

IF stableTimer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM