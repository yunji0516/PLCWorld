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
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
    X36 : BOOL;
    X37 : BOOL;
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
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D100 : INT;
    D101 : INT;
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
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    initialized : BOOL;
    started : BOOL;
    state : INT;
    partType : INT;
    aCount : INT;
    bCount : INT;
    deliveredCount : INT;
    cmdSeq : INT;
    desiredTarget : INT;
    nextAfterMove : INT;
    requestMove : BOOL;
    movePending : BOOL;
    sourceTarget : INT;
    cellTarget : INT;
    partToken : INT;
    deliverTarget : INT;
    expectedAccepted : INT;
    cycleSawBusy : BOOL;
    inspSawBusy : BOOL;
    goodDepth : BOOL;
    pocketReady : BOOL;
END_VAR

IF NOT initialized THEN
    cmdSeq := D1;
    D101 := cmdSeq;
    D100 := D0;
    initialized := TRUE;
END_IF;

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
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;

requestMove := FALSE;
pocketReady := FALSE;
D101 := cmdSeq;

IF X0 THEN
    started := TRUE;
END_IF;

CASE state OF
    0:
        IF started THEN
            state := 1;
        END_IF;

    1:
        IF deliveredCount >= 4 THEN
            state := 900;
        ELSIF aCount < 2 THEN
            partType := 1;
            sourceTarget := 1;
            cellTarget := 3;
            state := 10;
        ELSIF bCount < 2 THEN
            partType := 2;
            sourceTarget := 2;
            cellTarget := 4;
            state := 10;
        END_IF;

    10:
        IF NOT X13 THEN
            desiredTarget := sourceTarget;
            nextAfterMove := 11;
            requestMove := TRUE;
        END_IF;

    11:
        IF NOT X13 THEN
            Y10 := TRUE;
        END_IF;
        IF X12 AND X13 THEN
            partToken := D2;
            IF partType = 1 THEN
                IF partToken = 0 THEN
                    partToken := D7;
                END_IF;
            ELSE
                IF partToken = 0 THEN
                    partToken := D9;
                END_IF;
            END_IF;
            state := 12;
        END_IF;

    12:
        IF partType = 1 THEN
            IF (NOT X20) AND X25 THEN
                IF NOT X21 THEN
                    Y15 := TRUE;
                END_IF;
                IF NOT X23 THEN
                    Y18 := TRUE;
                END_IF;
                IF X21 AND X23 AND X1E AND X26 AND X13 THEN
                    desiredTarget := 3;
                    nextAfterMove := 13;
                    requestMove := TRUE;
                END_IF;
            END_IF;
        ELSE
            IF (NOT X2B) AND X30 THEN
                IF NOT X2C THEN
                    Y1A := TRUE;
                END_IF;
                IF NOT X2E THEN
                    Y1D := TRUE;
                END_IF;
                IF X2C AND X2E AND X29 AND X31 AND X13 THEN
                    desiredTarget := 4;
                    nextAfterMove := 13;
                    requestMove := TRUE;
                END_IF;
            END_IF;
        END_IF;

    13:
        IF X13 THEN
            Y11 := TRUE;
        END_IF;
        IF X11 AND (NOT X13) THEN
            IF partType = 1 THEN
                IF X27 THEN
                    state := 14;
                END_IF;
            ELSE
                IF X32 THEN
                    state := 14;
                END_IF;
            END_IF;
        END_IF;

    14:
        desiredTarget := 0;
        nextAfterMove := 15;
        requestMove := TRUE;

    15:
        IF partType = 1 THEN
            IF X26 AND X27 AND (NOT X20) THEN
                IF NOT X24 THEN
                    Y17 := TRUE;
                ELSIF NOT X22 THEN
                    Y16 := TRUE;
                ELSE
                    state := 16;
                END_IF;
            END_IF;
        ELSE
            IF X31 AND X32 AND (NOT X2B) THEN
                IF NOT X2F THEN
                    Y1C := TRUE;
                ELSIF NOT X2D THEN
                    Y1B := TRUE;
                ELSE
                    state := 16;
                END_IF;
            END_IF;
        END_IF;

    16:
        cycleSawBusy := FALSE;
        IF partType = 1 THEN
            IF X27 AND (NOT X20) AND X22 AND X24 THEN
                Y17 := TRUE;
                Y19 := TRUE;
                state := 17;
            END_IF;
        ELSE
            IF X32 AND (NOT X2B) AND X2D AND X2F THEN
                Y1C := TRUE;
                Y1E := TRUE;
                state := 17;
            END_IF;
        END_IF;

    17:
        IF partType = 1 THEN
            Y17 := TRUE;
            IF X20 THEN
                cycleSawBusy := TRUE;
            END_IF;
            IF (NOT X20) AND X1F THEN
                state := 18;
            END_IF;
        ELSE
            Y1C := TRUE;
            IF X2B THEN
                cycleSawBusy := TRUE;
            END_IF;
            IF (NOT X2B) AND X2A THEN
                state := 18;
            END_IF;
        END_IF;

    18:
        IF partType = 1 THEN
            IF NOT X20 THEN
                IF NOT X21 THEN
                    Y15 := TRUE;
                END_IF;
                IF NOT X23 THEN
                    Y18 := TRUE;
                END_IF;
                IF X21 AND X23 THEN
                    state := 19;
                END_IF;
            END_IF;
        ELSE
            IF NOT X2B THEN
                IF NOT X2C THEN
                    Y1A := TRUE;
                END_IF;
                IF NOT X2E THEN
                    Y1D := TRUE;
                END_IF;
                IF X2C AND X2E THEN
                    state := 19;
                END_IF;
            END_IF;
        END_IF;

    19:
        IF NOT X13 THEN
            IF partType = 1 THEN
                IF X21 AND X23 AND (NOT X20) AND X25 AND X27 THEN
                    desiredTarget := 3;
                    nextAfterMove := 20;
                    requestMove := TRUE;
                END_IF;
            ELSE
                IF X2C AND X2E AND (NOT X2B) AND X30 AND X32 THEN
                    desiredTarget := 4;
                    nextAfterMove := 20;
                    requestMove := TRUE;
                END_IF;
            END_IF;
        END_IF;

    20:
        IF NOT X13 THEN
            Y10 := TRUE;
        END_IF;
        IF X12 AND X13 THEN
            partToken := D2;
            IF partType = 1 THEN
                aCount := aCount + 1;
            ELSE
                bCount := bCount + 1;
            END_IF;
            state := 50;
        END_IF;

    50:
        IF (NOT X14) AND (NOT X15) AND X1C AND X13 THEN
            desiredTarget := 5;
            nextAfterMove := 51;
            requestMove := TRUE;
        END_IF;

    51:
        IF X13 THEN
            Y11 := TRUE;
        END_IF;
        IF X11 AND (NOT X13) AND X14 THEN
            partToken := D11;
            state := 52;
        END_IF;

    52:
        desiredTarget := 0;
        nextAfterMove := 53;
        requestMove := TRUE;

    53:
        IF X14 AND (NOT X15) AND X1C AND X17 THEN
            Y12 := TRUE;
            inspSawBusy := FALSE;
            state := 54;
        END_IF;

    54:
        IF X15 THEN
            inspSawBusy := TRUE;
        END_IF;
        IF inspSawBusy AND (NOT X15) AND X16 AND ((D3 = partToken) OR (D3 = D11)) THEN
            goodDepth := (D4 >= 5800) AND (D4 <= 6200) AND (D5 >= 5800) AND (D5 <= 6200);
            state := 55;
        END_IF;

    55:
        IF X14 AND (NOT X15) THEN
            desiredTarget := 5;
            nextAfterMove := 56;
            requestMove := TRUE;
        END_IF;

    56:
        IF X14 AND (NOT X15) AND (NOT X13) THEN
            Y10 := TRUE;
        END_IF;
        IF X12 AND X13 THEN
            partToken := D2;
            IF goodDepth THEN
                deliverTarget := 7;
                state := 60;
            ELSE
                IF NOT X34 THEN
                    deliverTarget := 8;
                    state := 60;
                ELSIF NOT X35 THEN
                    deliverTarget := 9;
                    state := 60;
                ELSIF NOT X36 THEN
                    deliverTarget := 10;
                    state := 60;
                ELSIF NOT X37 THEN
                    deliverTarget := 11;
                    state := 60;
                END_IF;
            END_IF;
        END_IF;

    60:
        IF deliverTarget = 7 THEN
            IF X1A AND X13 THEN
                desiredTarget := 7;
                nextAfterMove := 61;
                requestMove := TRUE;
            END_IF;
        ELSE
            IF deliverTarget = 8 THEN
                pocketReady := NOT X34;
            ELSIF deliverTarget = 9 THEN
                pocketReady := NOT X35;
            ELSIF deliverTarget = 10 THEN
                pocketReady := NOT X36;
            ELSIF deliverTarget = 11 THEN
                pocketReady := NOT X37;
            END_IF;
            IF pocketReady AND X13 THEN
                desiredTarget := deliverTarget;
                nextAfterMove := 61;
                requestMove := TRUE;
            END_IF;
        END_IF;

    61:
        IF deliverTarget = 7 THEN
            IF X1A AND X13 THEN
                Y11 := TRUE;
            END_IF;
            IF X11 AND (NOT X13) THEN
                expectedAccepted := D6 + 1;
                state := 62;
            END_IF;
        ELSE
            IF deliverTarget = 8 THEN
                pocketReady := NOT X34;
            ELSIF deliverTarget = 9 THEN
                pocketReady := NOT X35;
            ELSIF deliverTarget = 10 THEN
                pocketReady := NOT X36;
            ELSIF deliverTarget = 11 THEN
                pocketReady := NOT X37;
            ELSE
                pocketReady := FALSE;
            END_IF;
            IF pocketReady AND X13 THEN
                Y11 := TRUE;
            END_IF;
            IF X11 AND (NOT X13) THEN
                state := 62;
            END_IF;
        END_IF;

    62:
        desiredTarget := 0;
        nextAfterMove := 63;
        requestMove := TRUE;

    63:
        IF deliverTarget = 7 THEN
            Y13 := TRUE;
            IF D6 >= expectedAccepted THEN
                Y13 := FALSE;
                deliveredCount := deliveredCount + 1;
                state := 1;
            END_IF;
        ELSIF deliverTarget = 8 THEN
            IF X34 THEN
                deliveredCount := deliveredCount + 1;
                state := 1;
            END_IF;
        ELSIF deliverTarget = 9 THEN
            IF X35 THEN
                deliveredCount := deliveredCount + 1;
                state := 1;
            END_IF;
        ELSIF deliverTarget = 10 THEN
            IF X36 THEN
                deliveredCount := deliveredCount + 1;
                state := 1;
            END_IF;
        ELSIF deliverTarget = 11 THEN
            IF X37 THEN
                deliveredCount := deliveredCount + 1;
                state := 1;
            END_IF;
        END_IF;

    900:
        IF X1B AND (NOT X13) AND (NOT X10) AND (D0 = 0) AND (NOT X15) AND (NOT X20) AND (NOT X2B) THEN
            Y14 := TRUE;
        END_IF;

ELSE
    state := 0;
END_CASE;

IF requestMove THEN
    IF (NOT X10) AND (D0 = desiredTarget) THEN
        movePending := FALSE;
        state := nextAfterMove;
    ELSE
        IF NOT movePending THEN
            IF NOT X10 THEN
                cmdSeq := cmdSeq + 1;
                D100 := desiredTarget;
                D101 := cmdSeq;
                movePending := TRUE;
            END_IF;
        ELSE
            IF (NOT X10) AND (D1 = cmdSeq) AND (D0 = desiredTarget) THEN
                movePending := FALSE;
                state := nextAfterMove;
            END_IF;
        END_IF;
    END_IF;
ELSE
    movePending := FALSE;
END_IF;

END_PROGRAM