PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    
    // Internal Variables
    startRequest : BOOL := FALSE;
    targetVolume : INT := 0;
    lastX10 : BOOL := FALSE;
    fillLineOffset : INT := 20; // 20 mL line offset
    requestedVolume : INT := 0;
    isComplete : BOOL := FALSE;
    
END_VAR

// Rising edge detection function
FUNCTION RisingEdge(VAR signal: BOOL; VAR lastSignal: BOOL): BOOL
VAR
    edgeDetected : BOOL := FALSE;
END_VAR
    IF signal AND NOT lastSignal THEN
        edgeDetected := TRUE;
    END_IF;
    lastSignal := signal;
    RETURN edgeDetected;
END_FUNCTION

// Main program
IF NOT isComplete THEN
    // Detect start request
    startRequest := RisingEdge(X10, lastX10);

    // Handle the start request
    IF startRequest THEN
        targetVolume := D10;
        requestedVolume := D20; // Record the initial volume
    END_IF;

    // Move nozzle to the correct position
    IF NOT X21 THEN // If not at lower position
        Y20 := TRUE; // Command nozzle down
        Y21 := FALSE;
    ELSE
        Y20 := FALSE;
    END_IF;

    // Open valve and start pump if nozzle is in position and valve is not open yet
    IF X21 THEN
        IF NOT X22 THEN
            Y22 := TRUE; // Open valve
        ELSE
            Y23 := TRUE; // Start pump
        END_IF;
    END_IF;

    // Stop the pump when the target volume is reached (considering the 20 mL line)
    IF (D20 - requestedVolume) >= (targetVolume + fillLineOffset) THEN
        Y23 := FALSE; // Stop pump
    END_IF;

    // Close valve when pump stops
    IF (NOT Y23) AND X22 THEN
        Y22 := FALSE; // Close valve
    END_IF;

    // Move nozzle to the upper position if transfer is complete
    IF NOT Y23 AND X23 AND X22 AND X21 THEN
        Y21 := TRUE; // Command nozzle up
    ELSE
        Y21 := FALSE;
    END_IF;

    // Check if the transfer process is completed correctly
    IF (D20 - requestedVolume) >= targetVolume AND X21 AND X23 AND NOT Y23 THEN
        isComplete := TRUE;
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM