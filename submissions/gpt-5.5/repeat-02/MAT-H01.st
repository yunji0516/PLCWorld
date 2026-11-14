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
    state : INT;
    prevState : INT;
    scanState : INT;
    firstScan : BOOL;
    started : BOOL;
    moveIssued : BOOL;
    desiredPose : INT;
    jobIndex : INT;
    isAJob : BOOL;
    curToken : INT;
    goodPart : BOOL;
    outputPose : INT;
    rejectSel : INT;
    acceptedBefore : INT;
END_VAR

scanState := state;
firstScan := state <> prevState;

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

IF firstScan THEN
    moveIssued := FALSE;
END_IF;

CASE state OF
    0:
        IF X0 THEN
            started := TRUE;
            jobIndex := 0;
            state := 10;
        END_IF;

    10:
        IF jobIndex >= 4 THEN
            state := 90;
        ELSE
            IF (jobIndex = 0) OR (jobIndex = 2) THEN
                isAJob := TRUE;
            ELSE
                isAJob := FALSE;
            END_IF;
            state := 20;
        END_IF;

    20:
        IF isAJob THEN
            IF NOT X20 THEN
                IF NOT X21 THEN
                    Y15 := TRUE;
                END_IF;
                IF NOT X23 THEN
                    Y18 := TRUE;
                END_IF;
                IF X1E AND X21 AND X23 AND X25 AND X26 THEN
                    state := 30;
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
                IF X29 AND X2C AND X2E AND X30 AND X31 THEN
                    state := 30;
                END_IF;
            END_IF;
        END_IF;

    30:
        IF isAJob THEN
            desiredPose := 1;
        ELSE
            desiredPose := 2;
        END_IF;

        IF X13 THEN
            Y11 := TRUE;
        ELSIF NOT X11 THEN
            Y11 := TRUE;
        ELSIF (NOT X10) AND (D0 = desiredPose) THEN
            state := 31;
        ELSIF NOT moveIssued THEN
            IF (NOT X10) AND (D1 = D101) THEN
                D100 := desiredPose;
                D101 := D101 + 1;
                moveIssued := TRUE;
            END_IF;
        ELSE
            IF (NOT X10) AND (D1 = D101) AND (D0 = desiredPose) THEN
                state := 31;
            END_IF;
        END_IF;

    31:
        IF NOT X13 THEN
            Y10 := TRUE;
        ELSIF NOT X12 THEN
            Y10 := TRUE;
        ELSE
            curToken := D2;
            state := 32;
        END_IF;

    32:
        IF isAJob THEN
            desiredPose := 3;
            IF X21 AND X23 AND X25 AND X26 AND X1E AND X13 THEN
                IF (NOT X10) AND (D0 = desiredPose) THEN
                    state := 33;
                ELSIF NOT moveIssued THEN
                    IF (NOT X10) AND (D1 = D101) THEN
                        D100 := desiredPose;
                        D101 := D101 + 1;
                        moveIssued := TRUE;
                    END_IF;
                ELSE
                    IF (NOT X10) AND (D1 = D101) AND (D0 = desiredPose) THEN
                        state := 33;
                    END_IF;
                END_IF;
            END_IF;
        ELSE
            desiredPose := 4;
            IF X2C AND X2E AND X30 AND X31 AND X29 AND X13 THEN
                IF (NOT X10) AND (D0 = desiredPose) THEN
                    state := 33;
                ELSIF NOT moveIssued THEN
                    IF (NOT X10) AND (D1 = D101) THEN
                        D100 := desiredPose;
                        D101 := D101 + 1;
                        moveIssued := TRUE;
                    END_IF;
                ELSE
                    IF (NOT X10) AND (D1 = D101) AND (D0 = desiredPose) THEN
                        state := 33;
                    END_IF;
                END_IF;
            END_IF;
        END_IF;

    33:
        Y11 := TRUE;
        IF isAJob THEN
            IF X11 AND (NOT X13) AND X27 THEN
                state := 34;
            END_IF;
        ELSE
            IF X11 AND (NOT X13) AND X32 THEN
                state := 34;
            END_IF;
        END_IF;

    34:
        desiredPose := 0;
        IF (NOT X10) AND (D0 = desiredPose) THEN
            state := 35;
        ELSIF NOT moveIssued THEN
            IF (NOT X10) AND (D1 = D101) THEN
                D100 := desiredPose;
                D101 := D101 + 1;
                moveIssued := TRUE;
            END_IF;
        ELSE
            IF (NOT X10) AND (D1 = D101) AND (D0 = desiredPose) THEN
                state := 35;
            END_IF;
        END_IF;

    35:
        IF isAJob THEN
            IF X27 AND (NOT X20) AND (NOT X13) AND (D0 = 0) AND (NOT X10) THEN
                Y17 := TRUE;
                IF NOT X22 THEN
                    Y16 := TRUE;
                END_IF;
                IF X24 AND X22 AND X1D THEN
                    Y19 := TRUE;
                    state := 36;
                END_IF;
            END_IF;
        ELSE
            IF X32 AND (NOT X2B) AND (NOT X13) AND (D0 = 0) AND (NOT X10) THEN
                Y1C := TRUE;
                IF NOT X2D THEN
                    Y1B := TRUE;
                END_IF;
                IF X2F AND X2D AND X28 THEN
                    Y1E := TRUE;
                    state := 36;
                END_IF;
            END_IF;
        END_IF;

    36:
        IF isAJob THEN
            IF X20 OR (NOT X1F) THEN
                Y17 := TRUE;
            END_IF;
            IF X1F AND (NOT X20) THEN
                state := 37;
            END_IF;
        ELSE
            IF X2B OR (NOT X2A) THEN
                Y1C := TRUE;
            END_IF;
            IF X2A AND (NOT X2B) THEN
                state := 37;
            END_IF;
        END_IF;

    37:
        IF isAJob THEN
            IF NOT X20 THEN
                IF NOT X21 THEN
                    Y15 := TRUE;
                END_IF;
                IF NOT X23 THEN
                    Y18 := TRUE;
                END_IF;
                IF X21 AND X23 AND X25 AND X26 AND X27 THEN
                    state := 38;
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
                IF X2C AND X2E AND X30 AND X31 AND X32 THEN
                    state := 38;
                END_IF;
            END_IF;
        END_IF;

    38:
        IF isAJob THEN
            desiredPose := 3;
            IF X21 AND X23 AND X25 AND X26 AND X27 AND (NOT X13) THEN
                IF (NOT X10) AND (D0 = desiredPose) THEN
                    state := 39;
                ELSIF NOT moveIssued THEN
                    IF (NOT X10) AND (D1 = D101) THEN
                        D100 := desiredPose;
                        D101 := D101 + 1;
                        moveIssued := TRUE;
                    END_IF;
                ELSE
                    IF (NOT X10) AND (D1 = D101) AND (D0 = desiredPose) THEN
                        state := 39;
                    END_IF;
                END_IF;
            END_IF;
        ELSE
            desiredPose := 4;
            IF X2C AND X2E AND X30 AND X31 AND X32 AND (NOT X13) THEN
                IF (NOT X10) AND (D0 = desiredPose) THEN
                    state := 39;
                ELSIF NOT moveIssued THEN
                    IF (NOT X10) AND (D1 = D101) THEN
                        D100 := desiredPose;
                        D101 := D101 + 1;
                        moveIssued := TRUE;
                    END_IF;
                ELSE
                    IF (NOT X10) AND (D1 = D101) AND (D0 = desiredPose) THEN
                        state := 39;
                    END_IF;
                END_IF;
            END_IF;
        END_IF;

    39:
        IF NOT X13 THEN
            Y10 := TRUE;
        ELSIF NOT X12 THEN
            Y10 := TRUE;
        ELSE
            curToken := D2;
            state := 40;
        END_IF;

    40:
        desiredPose := 0;
        IF (NOT X10) AND (D0 = desiredPose) THEN
            state := 50;
        ELSIF NOT moveIssued THEN
            IF (NOT X10) AND (D1 = D101) THEN
                D100 := desiredPose;
                D101 := D101 + 1;
                moveIssued := TRUE;
            END_IF;
        ELSE
            IF (NOT X10) AND (D1 = D101) AND (D0 = desiredPose) THEN
                state := 50;
            END_IF;
        END_IF;

    50:
        desiredPose := 5;
        IF X13 AND X1C AND (NOT X14) AND (NOT X15) THEN
            IF (NOT X10) AND (D0 = desiredPose) THEN
                state := 51;
            ELSIF NOT moveIssued THEN
                IF (NOT X10) AND (D1 = D101) THEN
                    D100 := desiredPose;
                    D101 := D101 + 1;
                    moveIssued := TRUE;
                END_IF;
            ELSE
                IF (NOT X10) AND (D1 = D101) AND (D0 = desiredPose) THEN
                    state := 51;
                END_IF;
            END_IF;
        END_IF;

    51:
        Y11 := TRUE;
        IF X11 AND (NOT X13) AND X14 THEN
            state := 52;
        END_IF;

    52:
        desiredPose := 0;
        IF (NOT X10) AND (D0 = desiredPose) THEN
            state := 53;
        ELSIF NOT moveIssued THEN
            IF (NOT X10) AND (D1 = D101) THEN
                D100 := desiredPose;
                D101 := D101 + 1;
                moveIssued := TRUE;
            END_IF;
        ELSE
            IF (NOT X10) AND (D1 = D101) AND (D0 = desiredPose) THEN
                state := 53;
            END_IF;
        END_IF;

    53:
        IF X14 AND (NOT X15) AND (NOT X13) AND (D0 = 0) AND (NOT X10) THEN
            Y12 := TRUE;
            state := 54;
        END_IF;

    54:
        IF X16 AND (D3 = curToken) AND (NOT X15) THEN
            IF (D4 >= 5800) AND (D4 <= 6200) AND (D5 >= 5800) AND (D5 <= 6200) THEN
                goodPart := TRUE;
                outputPose := 7;
                acceptedBefore := D6;
            ELSE
                goodPart := FALSE;
                IF NOT X34 THEN
                    outputPose := 8;
                    rejectSel := 0;
                ELSIF NOT X35 THEN
                    outputPose := 9;
                    rejectSel := 1;
                ELSIF NOT X36 THEN
                    outputPose := 10;
                    rejectSel := 2;
                ELSE
                    outputPose := 11;
                    rejectSel := 3;
                END_IF;
            END_IF;
            state := 55;
        END_IF;

    55:
        desiredPose := 5;
        IF (NOT X15) AND X14 AND (NOT X13) THEN
            IF (NOT X10) AND (D0 = desiredPose) THEN
                state := 56;
            ELSIF NOT moveIssued THEN
                IF (NOT X10) AND (D1 = D101) THEN
                    D100 := desiredPose;
                    D101 := D101 + 1;
                    moveIssued := TRUE;
                END_IF;
            ELSE
                IF (NOT X10) AND (D1 = D101) AND (D0 = desiredPose) THEN
                    state := 56;
                END_IF;
            END_IF;
        END_IF;

    56:
        IF NOT X13 THEN
            Y10 := TRUE;
        ELSIF NOT X12 THEN
            Y10 := TRUE;
        ELSE
            curToken := D2;
            state := 57;
        END_IF;

    57:
        desiredPose := outputPose;
        IF goodPart THEN
            IF X1A AND X13 THEN
                IF (NOT X10) AND (D0 = desiredPose) THEN
                    state := 58;
                ELSIF NOT moveIssued THEN
                    IF (NOT X10) AND (D1 = D101) THEN
                        D100 := desiredPose;
                        D101 := D101 + 1;
                        moveIssued := TRUE;
                    END_IF;
                ELSE
                    IF (NOT X10) AND (D1 = D101) AND (D0 = desiredPose) THEN
                        state := 58;
                    END_IF;
                END_IF;
            END_IF;
        ELSE
            IF ((rejectSel = 0) AND (NOT X34)) OR ((rejectSel = 1) AND (NOT X35)) OR ((rejectSel = 2) AND (NOT X36)) OR ((rejectSel = 3) AND (NOT X37)) THEN
                IF (NOT X10) AND (D0 = desiredPose) THEN
                    state := 58;
                ELSIF NOT moveIssued THEN
                    IF (NOT X10) AND (D1 = D101) THEN
                        D100 := desiredPose;
                        D101 := D101 + 1;
                        moveIssued := TRUE;
                    END_IF;
                ELSE
                    IF (NOT X10) AND (D1 = D101) AND (D0 = desiredPose) THEN
                        state := 58;
                    END_IF;
                END_IF;
            END_IF;
        END_IF;

    58:
        Y11 := TRUE;
        IF X11 AND (NOT X13) THEN
            IF goodPart THEN
                state := 59;
            ELSE
                IF ((rejectSel = 0) AND X34) OR ((rejectSel = 1) AND X35) OR ((rejectSel = 2) AND X36) OR ((rejectSel = 3) AND X37) THEN
                    state := 59;
                END_IF;
            END_IF;
        END_IF;

    59:
        desiredPose := 0;
        IF (NOT X10) AND (D0 = desiredPose) THEN
            state := 60;
        ELSIF NOT moveIssued THEN
            IF (NOT X10) AND (D1 = D101) THEN
                D100 := desiredPose;
                D101 := D101 + 1;
                moveIssued := TRUE;
            END_IF;
        ELSE
            IF (NOT X10) AND (D1 = D101) AND (D0 = desiredPose) THEN
                state := 60;
            END_IF;
        END_IF;

    60:
        IF goodPart THEN
            IF D6 <> acceptedBefore THEN
                jobIndex := jobIndex + 1;
                state := 10;
            ELSE
                Y13 := TRUE;
            END_IF;
        ELSE
            jobIndex := jobIndex + 1;
            state := 10;
        END_IF;

    90:
        desiredPose := 0;
        IF X13 THEN
            Y11 := TRUE;
        ELSIF (NOT X10) AND (D0 = desiredPose) THEN
            IF X1B AND (NOT X20) AND (NOT X2B) AND (NOT X15) THEN
                Y14 := TRUE;
                state := 91;
            END_IF;
        ELSIF NOT moveIssued THEN
            IF (NOT X10) AND (D1 = D101) THEN
                D100 := desiredPose;
                D101 := D101 + 1;
                moveIssued := TRUE;
            END_IF;
        ELSE
            IF (NOT X10) AND (D1 = D101) AND (D0 = desiredPose) THEN
                IF X1B AND (NOT X20) AND (NOT X2B) AND (NOT X15) THEN
                    Y14 := TRUE;
                    state := 91;
                END_IF;
            END_IF;
        END_IF;

    91:
        Y14 := TRUE;

ELSE
    state := 0;
END_CASE;

prevState := scanState;

END_PROGRAM