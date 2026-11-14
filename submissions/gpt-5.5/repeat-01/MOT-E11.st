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
    obstacleRemembered : BOOL;
    targetRaw : DINT;
    commandRaw : DINT;
    posErrorRaw : DINT;
    speedAbsRaw : DINT;
    stableSamples : INT;
    validFeedback : BOOL;
END_VAR

(* Accept and retain the request only after X10 is present. *)
IF (NOT requestAccepted) AND X10 THEN
    requestAccepted := TRUE;
    targetRaw := D10;
END_IF;

(* Remember the obstacle detection after request acceptance. *)
IF requestAccepted AND X11 THEN
    obstacleRemembered := TRUE;
END_IF;

(* Default safe inactive command value, kept within permitted raw bounds. *)
commandRaw := 0;

IF obstacleRemembered THEN
    commandRaw := targetRaw;
END_IF;

IF commandRaw > 200000 THEN
    commandRaw := 200000;
ELSIF commandRaw < -200000 THEN
    commandRaw := -200000;
END_IF;

Y20 := obstacleRemembered;
D20 := commandRaw;

(* Use stricter raw feedback limits to allow for 0.01-unit rounding. *)
posErrorRaw := D11 - targetRaw;
IF posErrorRaw < 0 THEN
    posErrorRaw := -posErrorRaw;
END_IF;

speedAbsRaw := D12;
IF speedAbsRaw < 0 THEN
    speedAbsRaw := -speedAbsRaw;
END_IF;

validFeedback := obstacleRemembered AND (posErrorRaw <= 19) AND (speedAbsRaw <= 99);

IF validFeedback THEN
    IF stableSamples < 4 THEN
        stableSamples := stableSamples + 1;
    END_IF;
ELSE
    stableSamples := 0;
END_IF;

IF obstacleRemembered AND (stableSamples >= 4) THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM