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
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    state : INT := 0;
    toolState : INT := 0;
    productCount : INT := 0;
    currentId : INT := 0;
    currentType : INT := 0;
    currentWidth : INT := 160;
    sourceTool : INT := 1;
    sourceWidth : INT := 160;
    currentTool : INT := 1;
    requestTool : BOOL := FALSE;
    requestToolNumber : INT := 1;
    toolTarget : INT := 1;
    toolReady : BOOL := FALSE;
    completeDeclared : BOOL := FALSE;
    currentAComplete : BOOL := FALSE;
END_VAR

Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y1A := FALSE;
Y1B := FALSE;
Y1C := completeDeclared;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

IF D10 = 2 THEN
    sourceTool := 2;
    sourceWidth := 120;
ELSE
    sourceTool := 1;
    sourceWidth := 160;
END_IF;

IF currentType = 2 THEN
    currentTool := 2;
    currentWidth := 120;
ELSIF currentType = 1 THEN
    currentTool := 1;
    currentWidth := 160;
ELSE
    currentTool := sourceTool;
    currentWidth := sourceWidth;
END_IF;

IF state = 5 THEN
    D201 := sourceWidth;
ELSE
    D201 := currentWidth;
END_IF;
D202 := currentWidth;

toolReady := (toolState = 0) AND (D8 = sourceTool) AND X2B AND (NOT X29) AND (NOT X11) AND X13 AND (NOT X12);
requestTool := FALSE;
requestToolNumber := sourceTool;

IF state = 0 THEN
    IF X0 THEN
        state := 5;
    END_IF;

ELSIF state = 3 THEN
    IF (NOT X1B) AND (NOT X17) THEN
        Y15 := TRUE;
        state := 4;
    END_IF;

ELSIF state = 4 THEN
    IF (NOT X1A) AND (NOT X1B) THEN
        state := 5;
    END_IF;

ELSIF state = 5 THEN
    IF X1A AND (NOT X17) AND (NOT X1B) THEN
        state := 3;
    ELSE
        IF X10 THEN
            Y23 := NOT X28;
            requestTool := TRUE;
            requestToolNumber := sourceTool;
            IF X28 AND toolReady AND (NOT X14) AND (NOT X17) AND (NOT X1C) AND (NOT X1A) THEN
                currentId := D0;
                currentType := sourceTool;
                currentAComplete := FALSE;
                state := 10;
            END_IF;
        END_IF;
    END_IF;

ELSIF state = 10 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    Y10 := TRUE;
    state := 11;

ELSIF state = 11 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    IF X14 AND (D1 = currentId) AND X13 AND (NOT X11) AND (NOT X12) THEN
        state := 12;
    END_IF;

ELSIF state = 12 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    IF X14 AND (D1 = currentId) AND X2C AND (NOT X16) AND X13 AND (NOT X11) AND (NOT X12) THEN
        Y11 := TRUE;
        state := 13;
    END_IF;

ELSIF state = 13 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    IF X15 AND X14 AND (D1 = currentId) THEN
        currentAComplete := TRUE;
        state := 20;
    END_IF;

ELSIF state = 20 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    IF currentAComplete AND X15 AND X14 AND (D1 = currentId) AND (NOT X17) AND (NOT X1B) AND (NOT X1A) AND (NOT X11) AND (NOT X29) AND (D8 = currentTool) AND X2B THEN
        Y12 := TRUE;
        state := 21;
    END_IF;

ELSIF state = 21 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    IF X17 AND (D2 = currentId) AND X12 AND (D4 = currentId) AND (NOT X11) THEN
        state := 22;
    END_IF;

ELSIF state = 22 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    Y13 := TRUE;
    IF X18 AND X17 AND (D2 = currentId) THEN
        state := 23;
    END_IF;

ELSIF state = 23 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    Y14 := TRUE;
    state := 24;

ELSIF state = 24 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    IF X17 AND X18 AND (D2 = currentId) AND X13 AND (NOT X11) AND (NOT X12) THEN
        state := 25;
    END_IF;

ELSIF state = 25 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    IF (NOT X1B) AND X17 AND X18 THEN
        Y15 := TRUE;
        state := 26;
    END_IF;

ELSIF state = 26 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    IF X1A AND (NOT X1B) AND X17 AND (D2 = currentId) THEN
        state := 27;
    END_IF;

ELSIF state = 27 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    IF (NOT X11) AND (NOT X29) AND X13 AND (NOT X12) AND X17 AND X1A THEN
        Y16 := TRUE;
        state := 28;
    END_IF;

ELSIF state = 28 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    IF X12 AND (D4 = currentId) AND (NOT X11) THEN
        state := 29;
    END_IF;

ELSIF state = 29 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    Y17 := TRUE;
    IF X19 AND X12 AND (D4 = currentId) THEN
        state := 30;
    END_IF;

ELSIF state = 30 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    IF X19 AND X12 AND (D4 = currentId) AND (NOT X11) AND (NOT X1B) THEN
        state := 31;
    END_IF;

ELSIF state = 31 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    Y18 := TRUE;
    state := 32;

ELSIF state = 32 THEN
    IF currentType <> 0 THEN
        Y24 := NOT X2D;
    END_IF;
    IF X1C AND (D3 = currentId) AND X27 AND X13 AND (NOT X11) AND (NOT X12) AND X2D THEN
        state := 33;
    END_IF;

ELSIF state = 33 THEN
    Y1D := TRUE;
    IF X23 AND X1C AND (D3 = currentId) AND X27 AND X2D THEN
        state := 34;
    END_IF;

ELSIF state = 34 THEN
    Y1D := TRUE;
    Y1E := TRUE;
    IF X1C AND (D3 = currentId) AND currentAComplete AND X22 AND X23 AND X25 AND X26 AND X2D AND (NOT X1E) AND (NOT X29) AND (D8 = currentTool) AND X2B THEN
        Y19 := TRUE;
        state := 35;
    END_IF;

ELSIF state = 35 THEN
    Y1D := TRUE;
    Y1E := TRUE;
    IF X1D AND X1C AND (D3 = currentId) AND (NOT X1E) THEN
        state := 36;
    END_IF;

ELSIF state = 36 THEN
    Y1E := TRUE;
    IF X24 AND X25 AND X1F AND X1D AND X1C AND (D3 = currentId) THEN
        state := 37;
    END_IF;

ELSIF state = 37 THEN
    Y1E := TRUE;
    Y1A := TRUE;
    state := 38;

ELSIF state = 38 THEN
    Y1E := TRUE;
    Y1A := TRUE;
    IF X20 AND (D7 = currentId) THEN
        Y1B := TRUE;
        productCount := productCount + 1;
        state := 39;
    END_IF;

ELSIF state = 39 THEN
    Y1E := TRUE;
    IF X20 THEN
        Y1B := TRUE;
    END_IF;
    IF (NOT X20) AND X1F AND (NOT X1C) THEN
        currentId := 0;
        currentType := 0;
        currentAComplete := FALSE;
        IF productCount >= 4 THEN
            state := 100;
        ELSE
            state := 5;
        END_IF;
    END_IF;

ELSIF state = 100 THEN
    IF (productCount >= 4) AND X21 AND X13 AND (NOT X11) AND (NOT X12) AND (NOT X14) AND (NOT X16) AND (NOT X17) AND (NOT X1B) AND (NOT X1C) AND (NOT X1E) AND (NOT X20) AND (NOT X29) AND (NOT X2A) THEN
        completeDeclared := TRUE;
    END_IF;

END_IF;

IF (toolState = 0) AND requestTool AND (NOT toolReady) AND X13 AND (NOT X11) AND (NOT X12) AND (NOT X29) THEN
    toolTarget := requestToolNumber;
    IF D8 = 0 THEN
        toolState := 30;
    ELSIF D8 = requestToolNumber THEN
        toolState := 30;
    ELSE
        toolState := 10;
    END_IF;
END_IF;

IF toolState = 10 THEN
    D200 := D8;
    IF X13 AND (NOT X11) AND (NOT X12) AND (NOT X29) AND (D8 <> 0) THEN
        Y22 := TRUE;
        toolState := 11;
    END_IF;

ELSIF toolState = 11 THEN
    D200 := D8;
    IF X2A AND (NOT X29) THEN
        toolState := 12;
    END_IF;

ELSIF toolState = 12 THEN
    D200 := D8;
    IF X2A AND (NOT X29) AND (NOT X12) THEN
        Y20 := TRUE;
        toolState := 13;
    END_IF;

ELSIF toolState = 13 THEN
    D200 := toolTarget;
    IF (D8 = 0) AND (NOT X2B) AND (NOT X29) THEN
        toolState := 30;
    END_IF;

ELSIF toolState = 30 THEN
    D200 := toolTarget;
    IF X13 AND (NOT X11) AND (NOT X12) AND (NOT X29) THEN
        Y1F := TRUE;
        toolState := 31;
    END_IF;

ELSIF toolState = 31 THEN
    D200 := toolTarget;
    IF X2A AND (NOT X29) THEN
        toolState := 32;
    END_IF;

ELSIF toolState = 32 THEN
    D200 := toolTarget;
    IF X2A AND (NOT X29) THEN
        Y21 := TRUE;
        toolState := 33;
    END_IF;

ELSIF toolState = 33 THEN
    D200 := toolTarget;
    IF (D8 = toolTarget) AND X2B AND (NOT X29) THEN
        toolState := 34;
    END_IF;

ELSIF toolState = 34 THEN
    D200 := toolTarget;
    IF (D8 = toolTarget) AND X2B AND (NOT X29) THEN
        Y22 := TRUE;
        toolState := 35;
    END_IF;

ELSIF toolState = 35 THEN
    D200 := toolTarget;
    IF (NOT X29) AND X13 AND (NOT X11) AND (NOT X2A) AND (D8 = toolTarget) AND X2B THEN
        toolState := 0;
    END_IF;
END_IF;

IF completeDeclared THEN
    Y1C := TRUE;
END_IF;

END_PROGRAM