PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    requestAccepted : BOOL;
    errOk : BOOL;
    spdOk : BOOL;
    stableCond : BOOL;
    stabilityTimer : TON;
    cmdRaw : DINT;
    minCmd : DINT := -200000;
    maxCmd : DINT := 200000;
END_VAR

// Latch request acceptance once X10 is asserted
IF X10 THEN
    requestAccepted := TRUE;
END_IF;

// Function activation/retention: only after request accepted, then held
IF requestAccepted THEN
    Y20 := TRUE;
ELSE
    Y20 := FALSE;
END_IF;

// Main command value: only published after request accepted, clamped to raw bounds
IF requestAccepted THEN
    cmdRaw := D10;
    IF cmdRaw > maxCmd THEN
        cmdRaw := maxCmd;
    ELSIF cmdRaw < minCmd THEN
        cmdRaw := minCmd;
    END_IF;
    D20 := cmdRaw;
ELSE
    D20 := 0;
END_IF;

// Completion conditions: position error <=0.2mm (raw units <=20), speed <=1mm/s (raw units <=100)
errOk := ABS(D11 - D10) <= 20;
spdOk := ABS(D12) <= 100;
stableCond := requestAccepted AND errOk AND spdOk;

// Require 30 ms of continuous stability before latching completion result
stabilityTimer(IN := stableCond, PT := T#30ms);

IF stabilityTimer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM