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
    Y2  : BOOL;

    (* internal *)
    wn          : REAL := 35.0;
    zeta        : REAL := 1.0;
    accel_limit : REAL := 4000.0;   (* mm/s^2, matches permitted command range /100 *)
    pi_const    : REAL := 3.14159265;

    Kp_sway : REAL := 4.0;
    Kd_sway : REAL := 4.0;

    aTargetMM, aActualMM, aActualSpeed : REAL;
    bTargetMM, bActualMM, bActualSpeed : REAL;
    cTargetDeg, cActualDeg, cActualSpeed : REAL;

    posErrB, velErrB, accelPD : REAL;
    swayRad, swayRateRad, Lmm, swayCorr, accelTotal : REAL;

    accelOutRaw : DINT;

    allOk : BOOL;
    stableTimer : TON;
    completedLatch : BOOL;

    aTargetClamped : DINT;
END_VAR

(* ---- unit conversions (physical units) ---- *)
aActualMM    := REAL(D11) / 100.0;
aActualSpeed := REAL(D12) / 100.0;
aTargetMM    := REAL(D10) / 100.0;

bActualMM    := REAL(D13) / 100.0;
bActualSpeed := REAL(D14) / 100.0;
bTargetMM    := REAL(D17) / 100.0;

cActualDeg   := REAL(D15) / 100.0;
cActualSpeed := REAL(D16) / 100.0;
cTargetDeg   := REAL(D18) / 100.0;

(* ---- trolley (axis b) outer acceleration controller ---- *)
posErrB := bTargetMM - bActualMM;
velErrB := 0.0 - bActualSpeed;
accelPD := (wn * wn * posErrB) + (2.0 * zeta * wn * velErrB);

(* active sway damping/restoring correction, feeds through trolley acceleration *)
swayRad     := (cActualDeg - cTargetDeg) * pi_const / 180.0;
swayRateRad := cActualSpeed * pi_const / 180.0;
Lmm         := aActualMM;
swayCorr    := (Kp_sway * swayRad + Kd_sway * swayRateRad) * Lmm;

accelTotal := accelPD + swayCorr;

IF accelTotal > accel_limit THEN
    accelTotal := accel_limit;
ELSIF accelTotal < -accel_limit THEN
    accelTotal := -accel_limit;
END_IF;

accelOutRaw := DINT(ROUND(accelTotal * 100.0));
accelOutRaw := LIMIT(-400000, accelOutRaw, 400000);

(* ---- hoist (axis a) position request pass-through ---- *)
aTargetClamped := LIMIT(60000, D10, 160000);

IF X10 THEN
    D20  := aTargetClamped;
    Y20  := TRUE;
    D21  := accelOutRaw;
ELSE
    D20  := D11;   (* hold current wire length target while idle *)
    Y20  := FALSE;
    D21  := 0;
END_IF;

(* ---- completion evaluation ---- *)
allOk := X10 AND
         (ABS(D10 - D11) <= 100) AND
         (ABS(D17 - D13) <= 100) AND
         (ABS(D18 - D15) <= 20)  AND
         (ABS(D12) <= 100) AND
         (ABS(D14) <= 100) AND
         (ABS(D16) <= 100);

stableTimer(IN := allOk, PT := T#30ms);

IF stableTimer.Q THEN
    completedLatch := TRUE;
END_IF;

Y2 := completedLatch;

END_PROGRAM