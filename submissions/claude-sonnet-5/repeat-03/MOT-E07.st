PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D10 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* Internal state *)
    reqLatch    : BOOL := FALSE;   (* X10 request accepted / retained *)
    claimed     : BOOL := FALSE;   (* completion claim made *)
    good        : BOOL := FALSE;   (* current scan meets sync tolerance *)
    ratio_real  : REAL := 0.0;
    vS          : REAL := 0.0;
    vU          : REAL := 0.0;
    velErr      : REAL := 0.0;
    cmd         : DINT := 0;

    stableTimer : TON;   (* 30 ms initial stability requirement *)
    postTimer   : TON;   (* 250 ms retention observation window *)
END_VAR

(* ---- Request acceptance / latch (do not activate before X10) ---- *)
IF X10 THEN
    reqLatch := TRUE;
END_IF;

(* ---- Activation / command output ---- *)
IF reqLatch THEN
    Y20 := TRUE;

    cmd := D10;
    IF cmd > 200000 THEN
        cmd := 200000;
    ELSIF cmd < -200000 THEN
        cmd := -200000;
    END_IF;
    D20 := cmd;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

(* ---- Error evaluation ---- *)
ratio_real := REAL(D10) / 1000.0;
vS := REAL(D12) / 100.0;
vU := REAL(D14) / 100.0;
velErr := ABS(vS - ratio_real * vU);

good := reqLatch AND (ABS(D17) <= 30) AND (velErr <= 2.0);

(* ---- 30 ms continuous stability before claiming success ---- *)
stableTimer(IN := good, PT := T#30ms);
IF stableTimer.Q AND NOT claimed THEN
    claimed := TRUE;
END_IF;

(* ---- Y2 retention once claimed ---- *)
Y2 := claimed;

(* ---- 250 ms post-claim retention observation ---- *)
postTimer(IN := claimed AND good, PT := T#250ms);

END_PROGRAM