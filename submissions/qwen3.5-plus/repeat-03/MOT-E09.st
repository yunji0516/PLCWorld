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
    
    stabilityTimer : TON;
    observationTimer : TON;
    
    functionActive : BOOL;
    observationStarted : BOOL;
    observationComplete : BOOL;
END_VAR

// Activate function on request (X10 is retained from scan 3)
IF X10 AND NOT functionActive THEN
    functionActive := TRUE;
    Y20 := TRUE;
END_IF;

// Calculate wrist target position: C = -(A + B) to maintain A+B+C = 0°
// In raw units (×0.01): D20 = -(D13 + D15)
D20 := -(D13 + D15);
IF D20 > 200000 THEN D20 := 200000; END_IF;
IF D20 < -200000 THEN D20 := -200000; END_IF;

// Calculate feedforward velocity: dC/dt = -(dA/dt + dB/dt)
// D21 = -(D14 + D16) in raw units (deg/s ×0.01)
D21 := -(D14 + D16);
IF D21 > 200000 THEN D21 := 200000; END_IF;
IF D21 < -200000 THEN D21 := -200000; END_IF;

// Stability check: |A + B + C| <= 2° → |D13 + D15 + D11| <= 200 (raw units)
// Accumulate 30 ms of continuous tolerance before claiming completion
IF functionActive AND ABS(D13 + D15 + D11) <= 200 THEN
    stabilityTimer(IN := TRUE, PT := T#30ms);
ELSE
    stabilityTimer(IN := FALSE, PT := T#30ms);
END_IF;

// Once stable for 30 ms, assert Y2 and begin observation period
IF stabilityTimer.Q AND NOT observationStarted THEN
    observationStarted := TRUE;
    Y2 := TRUE;
END_IF;

// Maintain Y2 and count the 1300 ms post-claim observation interval
IF observationStarted AND NOT observationComplete THEN
    observationTimer(IN := TRUE, PT := T#1300ms);
    IF observationTimer.Q THEN
        observationComplete := TRUE;
    END_IF;
END_IF;

END_PROGRAM