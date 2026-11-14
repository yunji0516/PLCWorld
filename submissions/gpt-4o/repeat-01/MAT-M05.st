```iecst
PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    Y24 : BOOL := FALSE;
    Y26 : BOOL := FALSE;
    Y27 : BOOL := FALSE;
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
    D20 : INT;
    D22 : INT;
    requestAccepted : BOOL := FALSE;
    layerOrder : ARRAY[1..4] OF INT;
    currentLayer : INT := 0;
    stackComplete : BOOL := FALSE;
    gripEdge : R_TRIG;
    receiptEdge : R_TRIG;
END_VAR

gripEdge(CLK := X10);
receiptEdge(CLK := X28);

IF gripEdge.Q THEN
    requestAccepted := TRUE;
    layerOrder[1] := D11;
    layerOrder[2] := D12;
    layerOrder[3] := D13;
    layerOrder[4] := D14;
    currentLayer := 1;
END_IF

IF requestAccepted AND NOT stackComplete THEN
    CASE currentLayer OF
        1..4:
            // Move to source position
            IF layerOrder[currentLayer] = 0 AND NOT X20 THEN
                Y21 := TRUE; // Command left to source A
            ELSIF layerOrder[currentLayer] = 1 AND NOT X21 THEN
                Y22 := TRUE; // Command right to source B
            END_IF

            // Move to pickup position
            IF (X20 OR X21) AND NOT X23 THEN
                Y23 := TRUE; // Move up for pickup
            ELSIF X23 AND NOT X25 AND X27 THEN
                Y20 := TRUE; // Grip ON
            END_IF

            // Move to stack position
            IF X25 AND NOT X22 THEN
                Y21 := FALSE; Y22 := FALSE; // Stop horizontal movement
                Y23 := TRUE; // Ensure moved up
                Y21 := FALSE; Y22 := FALSE; // Clear horizontal commands
                Y26 := TRUE; // Command table down if necessary
                Y24 := TRUE; // Command down to stack
            ELSIF X22 THEN
                Y23 := FALSE; // Stop vertical movement
                Y26 := FALSE; // Stop table movement
                Y20 := FALSE; // Grip OFF and drop plate
            END_IF

            // Confirm placement
            IF receiptEdge.Q THEN
                Y24 := FALSE; // Stop down command
                currentLayer := currentLayer + 1;
            END_IF

        ELSE
            stackComplete := TRUE;
            Y20 := FALSE;
            Y23 := FALSE;
            Y24 := FALSE;
            Y26 := FALSE;
            Y27 := FALSE;
    END_CASE
END_IF

IF stackComplete THEN
    IF NOT X20 THEN
        Y21 := FALSE; Y22 := TRUE; // Return to A
    ELSE
        Y2 := TRUE; // Completion claim
    END_IF
END_IF

// Ensure actuators are not opposing
IF (Y21 AND Y22) OR (Y23 AND Y24) OR (Y26 AND Y27) THEN
    Y21 := FALSE; Y22 := FALSE;
    Y23 := FALSE; Y24 := FALSE;
    Y26 := FALSE; Y27 := FALSE;
END_IF

END_PROGRAM
```