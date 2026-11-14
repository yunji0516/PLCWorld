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
    detectedObstacle : BOOL := FALSE;
    openCommand : DINT := 100000;  // Equivalent to 1000 * 100 for output scaling
    closeCommand : DINT := -40000; // Initial closing command
    inPosition : BOOL := FALSE;
    inSpeed : BOOL := FALSE;
    validReopening : BOOL := FALSE;
    timer : TON;
    observationTimer : TON;
    requestAccepted : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)
IF X10 THEN
    requestAccepted := TRUE;
END_IF

IF requestAccepted THEN
    IF X11 THEN
        detectedObstacle := TRUE;
    END_IF

    IF detectedObstacle THEN
        Y20 := TRUE;  // Activate function retention
        D20 := openCommand;  // Command the open position

        // Check position and speed for valid reopening
        inPosition := (ABS(DINT(REAL(D11) * 0.01) - 1000) <= 0.2);
        inSpeed := (ABS(DINT(REAL(D12) * 0.01)) <= 1.0);

        validReopening := inPosition AND inSpeed;

        IF validReopening THEN
            timer(IN := TRUE, PT := T#30ms);

            IF timer.Q THEN
                Y2 := TRUE;  // Assert function result

                // Start observation timer for completion condition
                observationTimer(IN := TRUE, PT := T#100ms);

                IF observationTimer.Q THEN
                    // Maintain state after completion observation
                    Y2 := TRUE;
                END_IF
            END_IF
        ELSE
            // Reset timers if condition fails
            timer(IN := FALSE);
            observationTimer(IN := FALSE);
        END_IF
    ELSE
        // If no detection, close the door
        D20 := closeCommand;
    END_IF
ELSE
    // Keep outputs off if request has not been accepted
    Y20 := FALSE;
    Y2 := FALSE;
END_IF

END_PROGRAM