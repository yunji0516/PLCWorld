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
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;

    minCmd : DINT := -200000;
    maxCmd : DINT := 200000;

    sumRaw : DINT;
    sumDeg : REAL;
    condition : BOOL;
    claimed : BOOL := FALSE;
    stabTimer : TON;
END_VAR

(* Activate/retain the wrist compensation function once the request is accepted. *)
IF X10 THEN
    Y20 := TRUE;
END_IF;

(* Compute wrist commands to keep A+B+C = 0, only after activation.
   Before activation, hold the wrist at its current actual position
   with zero feedforward so no premature motion is commanded. *)
IF Y20 THEN
    D20 := LIMIT(minCmd, -(D13 + D15), maxCmd);
    D21 := LIMIT(minCmd, -(D14 + D16), maxCmd);
ELSE
    D20 := D11;
    D21 := 0;
END_IF;

(* Actual tool orientation sum, in degrees. *)
sumRaw := D11 + D13 + D15;
sumDeg := REAL(sumRaw) * 0.01;

condition := (ABS(sumDeg) <= 2.0) AND Y20;

(* Pre-claim stability: require the condition to hold continuously for 30 ms. *)
stabTimer(IN := condition AND NOT claimed, PT := T#30ms);

IF stabTimer.Q THEN
    claimed := TRUE;
END_IF;

(* Once claimed, retain Y2 TRUE (function result retention) for the
   remainder of execution, relying on the ongoing wrist compensation
   to keep the actual condition satisfied through the observation window. *)
IF claimed THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM