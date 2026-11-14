PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    // Internal variables
    startRequestDetected : BOOL := FALSE;
    ejectPreviousMaterial : BOOL := FALSE;
    pumpDuration : INT := 0; // Duration in milliseconds to eject previous material
    currentVolumeToEject : INT := 0;
    edgeDetector : R_TRIG;
    pumpTimer : TON;
    targetMaterial : INT := 2;
END_VAR

(* Implement the control logic here. *)
edgeDetector(CLK := X10);

// Process start request
IF edgeDetector.Q THEN
    IF D10 = targetMaterial THEN
        startRequestDetected := TRUE;
        currentVolumeToEject := DINT(D21); // Assume full source initially with current material
        IF currentVolumeToEject > 20 THEN
            pumpDuration := (20 * 1000) / 10; // Time in ms to eject initial material in the line, assuming 10 mL/s
        ELSE
            pumpDuration := (currentVolumeToEject * 1000) / 10;
        END_IF
    END_IF
END_IF

// Eject previous material
IF startRequestDetected THEN
    // Move branch to waste if it's not already there
    IF NOT X20 THEN
        Y21 := FALSE;
    ELSIF NOT X22 AND D20 = 1 THEN
        // Start pumping if source is not empty and previous material is at the outlet
        Y20 := TRUE;
        IF NOT ejectPreviousMaterial THEN
            ejectPreviousMaterial := TRUE;
            // Start the pump duration timer
            pumpTimer(IN := TRUE, PT := TIME(pumpDuration));
        END_IF
    END_IF
END_IF

// Check if the previous material has been ejected
IF ejectPreviousMaterial AND pumpTimer.Q THEN
    Y20 := FALSE;
    ejectPreviousMaterial := FALSE;
    startRequestDetected := FALSE;
    
    // Move branch to target
    Y21 := TRUE;
    // Start pumping to transfer current material
    Y20 := TRUE;
END_IF

// Check conditions for completion
IF X21 AND X22 AND D20 = 2 AND X23 THEN
    // Stop the pump when all conditions are satisfied
    Y20 := FALSE;
    Y2 := TRUE; // Completion claim
END_IF

END_PROGRAM