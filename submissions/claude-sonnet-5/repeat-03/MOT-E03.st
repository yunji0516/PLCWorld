PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* internal state *)
    reqLatch    : BOOL := FALSE;   (* function activation latch, only set after X10 accepted *)
    dirCaptured : BOOL := FALSE;
    dir         : INT  := 1;       (* +1 or -1, direction of original travel *)

    posMM       : REAL := 0.0;
    spdMM       : REAL := 0.0;
    limMM       : REAL := 0.0;
    distSigned  : REAL := 0.0;
    reqDecel    : REAL := 0.0;

    okCond      : BOOL := FALSE;
    y2Latched   : BOOL := FALSE;

    stableTimer : TON;

    maxDecel    : REAL := 4000.0;   (* mm/s^2 physical, matches raw 400000 *)
    margin      : REAL := 1.05;
END_VAR

(* ---- activation / retention ---- *)
IF X10 THEN
    reqLatch := TRUE;
END_IF;
Y20 := reqLatch;

(* capture the direction of travel once, right when function is accepted *)
IF reqLatch AND NOT dirCaptured THEN
    IF D12 >= 0 THEN
        dir := 1;
    ELSE
        dir := -1;
    END_IF;
    dirCaptured := TRUE;
END_IF;

(* scale raw values to physical units *)
posMM := REAL(D11) / 100.0;
spdMM := REAL(D12) / 100.0;
limMM := REAL(D13) / 100.0;

IF dirCaptured THEN
    distSigned := (limMM - posMM) * REAL(dir);
ELSE
    distSigned := 0.0;
END_IF;

(* compute required deceleration to stop before the limit *)
IF reqLatch AND (ABS(spdMM) > 1.0) THEN
    IF distSigned > 0.0001 THEN
        reqDecel := (spdMM * spdMM) / (2.0 * distSigned) * margin;
    ELSE
        reqDecel := maxDecel; (* fallback: no margin left, command maximum *)
    END_IF;
ELSE
    reqDecel := 0.0;
END_IF;

(* clamp to physical / command bounds *)
IF reqDecel > maxDecel THEN
    reqDecel := maxDecel;
END_IF;
IF reqDecel < 0.0 THEN
    reqDecel := 0.0;
END_IF;

D20 := DINT(ROUND(reqDecel * 100.0));
IF D20 > 400000 THEN
    D20 := 400000;
END_IF;
IF D20 < 0 THEN
    D20 := 0;
END_IF;

(* completion condition: near-zero speed and not past the limit in travel direction *)
okCond := reqLatch AND (ABS(spdMM) <= 1.0) AND
          ( (dir = 1  AND posMM <= limMM) OR
            (dir = -1 AND posMM >= limMM) );

stableTimer(IN := okCond, PT := T#30ms);

IF stableTimer.Q THEN
    y2Latched := TRUE;
END_IF;

Y2 := y2Latched;

END_PROGRAM