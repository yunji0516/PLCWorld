PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* Internal state *)
    requestAccepted : BOOL := FALSE;
    detected        : BOOL := FALSE;
    posDiffOk       : BOOL := FALSE;
    speedOk         : BOOL := FALSE;
    stableCond      : BOOL := FALSE;
    stableTimer     : TON;
    y2Latched       : BOOL := FALSE;
    holdTimer       : TON;
    scanCount       : DINT := 0;

    cmdRaw          : DINT := 0;
    minCmd          : DINT := -200000;
    maxCmd          : DINT := 200000;
END_VAR

(* scan bookkeeping *)
scanCount := scanCount + 1;

(* ---- request acceptance latch ---- *)
IF X10 THEN
    requestAccepted := TRUE;
END_IF;

(* ---- detection latch : sensors maintain detection, PLC also remembers it ---- *)
IF requestAccepted AND X11 THEN
    detected := TRUE;
END_IF;

(* ---- function activation / retention ---- *)
Y20 := detected;

(* ---- command value : only publish the open command after detection,
        before that keep command neutral (function not active) ---- *)
IF detected THEN
    cmdRaw := D10;
ELSE
    cmdRaw := 0;
END_IF;

(* clamp to permitted raw command bounds on every scan *)
IF cmdRaw > maxCmd THEN
    cmdRaw := maxCmd;
ELSIF cmdRaw < minCmd THEN
    cmdRaw := minCmd;
END_IF;

D20 := cmdRaw;

(* ---- completion evaluation ---- *)
posDiffOk := ABS(D11 - D10) <= 20;
speedOk   := ABS(D12) <= 100;

stableCond := detected AND posDiffOk AND speedOk;

stableTimer(IN := stableCond, PT := T#30ms);

IF (NOT y2Latched) AND stableTimer.Q THEN
    y2Latched := TRUE;
END_IF;

(* once asserted, Y2 is latched true and never retracted; door never closes again *)
Y2 := y2Latched;

(* post-claim 100 ms observation bookkeeping (no output action required beyond
   keeping Y2 and the physical result maintained) *)
holdTimer(IN := y2Latched, PT := T#100ms);

END_PROGRAM