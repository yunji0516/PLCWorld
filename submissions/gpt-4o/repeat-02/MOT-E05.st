PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    D14 : DINT;
    X12 : BOOL;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    D20 : DINT := 0;
    Y2 : BOOL := FALSE;
    captureReadyEdge : R_TRIG;
    validCaptureEdge : R_TRIG;
    captureTime : TIME := T#0ms;
    holdTime : TIME := T#0ms;
    captureInProgress : BOOL := FALSE;
    resultConfirmed : BOOL := FALSE;
    executionStartTime : TIME := T#0ms;
END_VAR

(* Implement the control logic here. *)

captureReadyEdge(CLK := X10);
validCaptureEdge(CLK := X11);

IF captureReadyEdge.Q THEN
    Y20 := TRUE;
    executionStartTime := TIME(); // Store the time when capture process starts
    captureInProgress := TRUE;
    resultConfirmed := FALSE;
END_IF

IF captureInProgress THEN
    IF validCaptureEdge.Q THEN
        D20 := D14;
        Y21 := TRUE;
        captureTime := TIME(); // Record the time the capture was valid
        holdTime := TIME() - captureTime; // Calculate the time since capture
        resultConfirmed := TRUE;
    END_IF

    IF resultConfirmed AND (holdTime >= T#30ms) THEN
        Y2 := TRUE;
    END_IF

    IF (TIME() - executionStartTime >= T#1650ms) OR (TIME() - captureTime >= T#100ms) THEN
        Y20 := FALSE; // Reset function activation/output retention
        Y21 := FALSE;
        Y2 := FALSE;
        captureInProgress := FALSE;
    END_IF
END_IF

END_PROGRAM