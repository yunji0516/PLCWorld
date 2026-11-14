PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D200 : INT;
    D201 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;

    // Internal variables
    extractionTimer : TON;
    extractTriggered : BOOL := FALSE;
    takeEmptyEdge : R_TRIG;
    releaseAEdge : R_TRIG;
    releaseBEdge : R_TRIG;
    swapTriggered : BOOL := FALSE;
    magazineExchangeActive : BOOL := FALSE;

    extractedItemsA : INT := 0;
    extractedItemsB : INT := 0;
    initialMagID : INT;
    magExchangeInitiated : BOOL := FALSE;
    completionDeclared : BOOL := FALSE;
    completionTimestamp : TIME := T#0s;
END_VAR

// Initialize edge detectors
takeEmptyEdge(CLK := NOT X1C);
releaseAEdge(CLK := X22 AND X23);
releaseBEdge(CLK := X28 AND X29);

// Extraction sequence
IF X16 AND X11 AND X12 THEN
    Y10 := FALSE; // Lower OFF
END_IF

IF X15 AND X17 AND NOT extractTriggered THEN
    Y12 := TRUE; // Extract ON
    extractionTimer(IN := TRUE, PT := T#650ms);
    extractTriggered := TRUE;
END_IF

IF extractionTimer.Q THEN
    Y12 := FALSE; // Extract OFF
    extractTriggered := FALSE;
END_IF

// Swapping sequence
IF X18 AND X14 AND X13 AND X1A AND X1B AND NOT swapTriggered THEN
    Y14 := TRUE; // Swap ON
    swapTriggered := TRUE;
END_IF

IF swapTriggered AND NOT X19 THEN
    Y14 := FALSE; // Swap OFF
    swapTriggered := FALSE;
    magazineExchangeActive := TRUE;
    magExchangeInitiated := TRUE;
    initialMagID := D0;
END_IF

// Empty magazine handling
IF magExchangeInitiated AND NOT magazineExchangeActive AND X1B THEN
    Y15 := takeEmptyEdge.Q; // Take empty rising edge
END_IF

// Assembly and release logic
IF extractedItemsA < 3 AND (extractedItemsA + D3) < 3 THEN
    IF X20 AND NOT X21 THEN
        Y16 := TRUE; // Assemble A
        extractedItemsA := extractedItemsA + 1;
    END_IF
    IF releaseAEdge.Q THEN
        Y18 := TRUE; // Release A
    END_IF
ELSE
    Y16 := FALSE;
END_IF

IF extractedItemsB < 4 AND (extractedItemsB + D4) < 4 THEN
    IF X26 AND NOT X27 THEN
        Y17 := TRUE; // Assemble B
        extractedItemsB := extractedItemsB + 1;
    END_IF
    IF releaseBEdge.Q THEN
        Y19 := TRUE; // Release B
    END_IF
ELSE
    Y17 := FALSE;
END_IF

// Completion checking
IF (extractedItemsA + D3) = 3 AND (extractedItemsB + D4) = 4 THEN
    IF NOT completionDeclared THEN
        completionDeclared := TRUE;
        completionTimestamp := completionTimestamp + T#500ms;
    END_IF
    IF NOW() >= completionTimestamp THEN
        Y1A := TRUE; // Maintain complete
    END_IF
ELSE
    Y1A := FALSE;
END_IF

END_PROGRAM