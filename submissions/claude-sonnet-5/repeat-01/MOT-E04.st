PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* internal variables *)
    errorRaw   : DINT;
    speedOK    : BOOL;
    stableTimer: TON;
    y2Latched  : BOOL;
    cmdRaw     : DINT;
END_VAR

(* --- Drive activation and command generation --- *)
IF X10 THEN
    Y20 := TRUE;

    (* clamp requested command to permitted raw command range *)
    cmdRaw := D10;
    IF cmdRaw > 200000 THEN
        cmdRaw := 200000;
    ELSIF cmdRaw < -200000 THEN
        cmdRaw := -200000;
    END_IF;

    D20 := cmdRaw;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

(* --- Speed error evaluation --- *)
errorRaw := ABS(D12 - D10);
speedOK  := (errorRaw <= 200); (* 2 deg/s in raw x0.01 units = 200 *)

(* --- Stability timer: require 30 ms of continuous tolerance while request active --- *)
stableTimer(IN := (speedOK AND X10), PT := T#30ms);

IF stableTimer.Q THEN
    y2Latched := TRUE;
END_IF;

Y2 := y2Latched;

END_PROGRAM