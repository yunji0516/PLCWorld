PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    referenceLatched : BOOL := FALSE;
    stopDetected : BOOL := FALSE;
    motionComplete : BOOL := FALSE;
    a_targetPos, b_targetPos : DINT;
    a_targetRate, b_targetRate : DINT;
    configureEdge : BOOL;
    calculateShelfPosition : DINT;
    requestedApos : DINT;
    requestedBpos : DINT;
    refTrig : R_TRIG;
    startTrig : R_TRIG;
END_VAR

(* Implement the control logic here. *)
refTrig(CLK := X34);
startTrig(CLK := X0);

// Calculate the target A position based on the requested parameters
calculateShelfPosition := D90 + D102 * D101;
requestedApos := calculateShelfPosition * 100;
requestedBpos := D103 * 100;

// Detect reference edge condition and latch
IF refTrig.Q AND NOT referenceLatched THEN
    referenceLatched := TRUE;
    configureEdge := TRUE;
END_IF

// Ensure start request triggers enable sequence only once
IF startTrig.Q AND NOT motionComplete THEN
    // Calculate targets
    a_targetPos := requestedApos;
    b_targetPos := requestedBpos;

    // Enable Axes motion to target positions
    D20 := a_targetPos;
    D21 := 1000; // 100% rate
    Y20 := TRUE;

    D24 := b_targetPos;
    D25 := 1000; // 100% rate
    Y21 := TRUE;

    // Check for stop within position tolerances
    IF ABS(D10 - requestedApos) <= 2 AND ABS(D11) <= 1 AND referenceLatched THEN
        stopDetected := TRUE;
    END_IF

    // Completion condition for requesting configuration only after valid stop
    IF stopDetected AND configureEdge THEN
        // Activate configure signal for a valid stop within conditions
        Y30 := TRUE;
    ELSE
        Y30 := FALSE;
    END_IF

    // The condition for retracting b-axis
    IF stopDetected THEN
        // Retract b-axis back to 0
        D24 := 0 * 100;
        D25 := 1000; // 100% rate
    END_IF

    // Check for all completion conditions
    IF D12 = 0 AND D13 = 0 AND NOT Y30 THEN
        Y2 := TRUE;
        motionComplete := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF
ELSE
    Y20 := FALSE;
    D21 := 0;
    Y21 := FALSE;
    D25 := 0;
    Y30 := FALSE;
END_IF

END_PROGRAM