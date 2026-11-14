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
    started : BOOL;
    extractState : INT;
    pendingSide : INT;
    pendingReq : INT;
    lastSide : INT;
    lastReq : INT;
    sentA : INT;
    sentB : INT;
    aAvail : BOOL;
    bAvail : BOOL;
    aClear : BOOL;
    bClear : BOOL;
    swapIssued : BOOL;
    takeIssued : BOOL;
    exchangeActive : BOOL;
    aAssembleIssued : BOOL;
    bAssembleIssued : BOOL;
    aReleaseIssued : BOOL;
    bReleaseIssued : BOOL;
    completeLatched : BOOL;
    completeCond : BOOL;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF D3 > sentA THEN
    sentA := D3;
END_IF;
IF D4 > sentB THEN
    sentB := D4;
END_IF;

Y10 := TRUE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;

IF NOT X1F THEN
    aAssembleIssued := FALSE;
    IF NOT X22 THEN
        aReleaseIssued := FALSE;
    END_IF;
END_IF;

IF NOT X25 THEN
    bAssembleIssued := FALSE;
    IF NOT X28 THEN
        bReleaseIssued := FALSE;
    END_IF;
END_IF;

IF started AND NOT completeLatched THEN
    IF X1F AND X20 AND NOT X21 AND NOT X22 AND NOT aAssembleIssued THEN
        Y16 := TRUE;
        aAssembleIssued := TRUE;
    END_IF;

    IF X25 AND X26 AND NOT X27 AND NOT X28 AND NOT bAssembleIssued THEN
        Y17 := TRUE;
        bAssembleIssued := TRUE;
    END_IF;

    IF X22 AND X23 AND NOT aReleaseIssued THEN
        Y18 := TRUE;
        aReleaseIssued := TRUE;
    END_IF;

    IF X28 AND X29 AND NOT bReleaseIssued THEN
        Y19 := TRUE;
        bReleaseIssued := TRUE;
    END_IF;
END_IF;

exchangeActive := swapIssued AND NOT (D0 = 202 AND X10 AND NOT X19);

IF started AND NOT completeLatched THEN
    IF NOT swapIssued AND (extractState = 0) AND (D0 = 201) AND (D1 = 0) AND X18 AND X14 AND X13 AND X1A AND X1B AND NOT X19 THEN
        Y14 := TRUE;
        swapIssued := TRUE;
        exchangeActive := TRUE;
    END_IF;

    IF swapIssued AND NOT takeIssued AND (D0 = 202) AND X10 AND X1B THEN
        Y15 := TRUE;
        takeIssued := TRUE;
    END_IF;
END_IF;

aClear := (NOT X1F) AND (NOT X21) AND (NOT X22) AND X23;
bClear := (NOT X25) AND (NOT X27) AND (NOT X28) AND X29;
aAvail := X1E AND aClear AND (sentA < 3);
bAvail := X24 AND bClear AND (sentB < 4);

IF started AND NOT completeLatched AND NOT exchangeActive AND (extractState = 0) THEN
    IF X16 AND X18 AND X11 AND X10 AND (D1 > 0) THEN
        IF aAvail AND ((NOT bAvail) OR (sentA <= sentB)) THEN
            pendingSide := 1;
            pendingReq := sentA + 1;
            extractState := 10;
        ELSIF bAvail THEN
            pendingSide := 2;
            pendingReq := sentB + 1;
            extractState := 10;
        ELSIF aAvail THEN
            pendingSide := 1;
            pendingReq := sentA + 1;
            extractState := 10;
        END_IF;
    END_IF;
END_IF;

IF completeLatched THEN
    extractState := 0;
    pendingSide := 0;
    pendingReq := 0;
ELSE
    CASE extractState OF
        0:
            Y10 := TRUE;
            Y11 := FALSE;
            Y12 := FALSE;

        10:
            Y10 := TRUE;
            Y11 := TRUE;
            Y12 := FALSE;
            IF X12 THEN
                extractState := 20;
            END_IF;

        20:
            Y10 := FALSE;
            Y11 := TRUE;
            Y12 := FALSE;
            IF X17 THEN
                extractState := 30;
            END_IF;

        30:
            Y10 := FALSE;
            Y11 := TRUE;
            Y12 := TRUE;
            IF X18 THEN
                extractState := 40;
            END_IF;

        40:
            Y11 := TRUE;
            Y12 := FALSE;
            IF X18 THEN
                Y10 := TRUE;
                IF X14 THEN
                    extractState := 50;
                END_IF;
            ELSE
                Y10 := FALSE;
            END_IF;

        50:
            Y10 := TRUE;
            Y11 := FALSE;
            Y12 := FALSE;
            IF X13 THEN
                extractState := 60;
            END_IF;

        60:
            Y10 := TRUE;
            Y11 := FALSE;
            Y12 := FALSE;
            IF pendingSide = 1 THEN
                IF aClear AND (sentA < 3) THEN
                    D200 := 1;
                    D201 := pendingReq;
                    lastSide := 1;
                    lastReq := pendingReq;
                    Y13 := TRUE;
                    sentA := sentA + 1;
                    pendingSide := 0;
                    pendingReq := 0;
                    extractState := 70;
                END_IF;
            ELSIF pendingSide = 2 THEN
                IF bClear AND (sentB < 4) THEN
                    D200 := 2;
                    D201 := pendingReq;
                    lastSide := 2;
                    lastReq := pendingReq;
                    Y13 := TRUE;
                    sentB := sentB + 1;
                    pendingSide := 0;
                    pendingReq := 0;
                    extractState := 70;
                END_IF;
            ELSE
                extractState := 70;
            END_IF;

        70:
            Y10 := TRUE;
            Y11 := FALSE;
            Y12 := FALSE;
            IF X16 AND X18 THEN
                extractState := 0;
            END_IF;

        ELSE
            extractState := 0;
            pendingSide := 0;
            pendingReq := 0;
    END_CASE;
END_IF;

IF exchangeActive THEN
    Y10 := TRUE;
    Y11 := FALSE;
    Y12 := FALSE;
END_IF;

completeCond := X1D AND (D3 >= 3) AND (D4 >= 4) AND (sentA >= 3) AND (sentB >= 4) AND (D0 = 202) AND X10 AND (D1 = 1) AND X16 AND X18 AND X14 AND X13 AND X1C AND NOT X19 AND (extractState = 0);

IF started AND completeCond THEN
    completeLatched := TRUE;
END_IF;

IF completeLatched THEN
    Y10 := TRUE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
END_IF;

IF pendingSide <> 0 THEN
    D200 := pendingSide;
    D201 := pendingReq;
ELSE
    D200 := lastSide;
    D201 := lastReq;
END_IF;

Y1A := completeLatched;

END_PROGRAM