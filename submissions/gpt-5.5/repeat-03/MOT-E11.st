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
    (* Add internal variables here. *)
    requestAccepted : BOOL;
    obstacleSeen : BOOL;
    stableCond : BOOL;
    errRaw : DINT;
    absErrRaw : DINT;
    absSpeedRaw : DINT;
    cmdRaw : DINT;
    stableTimer : TON;
END_VAR

(* Accept and retain the request. *)
IF X10 THEN
    requestAccepted := TRUE;
END_IF;

(* Remember the approaching object only after request acceptance. *)
IF requestAccepted AND X11 THEN
    obstacleSeen := TRUE;
END_IF;

(* Default command remains a closing command until obstacle detection. *)
cmdRaw := 0;

IF obstacleSeen THEN
    cmdRaw := D10;
END_IF;

(* Keep command word within the permitted raw bounds. *)
IF cmdRaw > 200000 THEN
    cmdRaw := 200000;
ELSIF cmdRaw < -200000 THEN
    cmdRaw := -200000;
END_IF;

D20 := cmdRaw;
Y20 := obstacleSeen;

(* Use tighter raw feedback limits to account for 0.01-unit feedback quantization. *)
errRaw := D11 - D10;
absErrRaw := ABS(errRaw);
absSpeedRaw := ABS(D12);

stableCond := obstacleSeen AND (absErrRaw <= 19) AND (absSpeedRaw <= 99);

stableTimer(IN := stableCond, PT := T#30ms);

IF stableTimer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM