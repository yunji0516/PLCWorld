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
    D14 : INT;
    D15 : INT;
    D16 : INT;
    D200 : INT;
    D201 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    started : BOOL;
    completeLatch : BOOL;
    orderGen : INT := 1;
    boxGen : INT := 1;
    aAcceptSent : BOOL;
    bAcceptSent : BOOL;
    aCloseSent : BOOL;
    bCloseSent : BOOL;
    aReleaseSent : BOOL;
    bReleaseSent : BOOL;
    aAckSent : BOOL;
    bAckSent : BOOL;
    packASent : BOOL;
    packBSent : BOOL;
    boxDispatchSent : BOOL;
    aAccepted : BOOL;
    bAccepted : BOOL;
    aNeed : BOOL;
    bNeed : BOOL;
    deckHas : BOOL;
    deckEmpty : BOOL;
    commandIssued : BOOL;
    desiredOp : INT;
    desiredPos : INT;
    navState : INT;
    navOp : INT;
    navPos : INT;
    navWait : INT;
    clampTimer : TON;
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
Y1A := FALSE;
Y1B := completeLatch;
Y1E := FALSE;
Y1F := FALSE;
commandIssued := FALSE;

IF NOT started THEN
    Y1C := FALSE;
    Y1D := FALSE;
    D200 := 1;
    D201 := 1;
    IF X0 THEN
        started := TRUE;
        orderGen := 1;
        boxGen := 1;
        D200 := 1;
        D201 := 1;
    END_IF;
ELSE
    IF completeLatch THEN
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
        Y1A := FALSE;
        Y1C := FALSE;
        Y1D := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        Y1B := TRUE;
    ELSE
        IF orderGen <= 2 THEN
            D201 := orderGen;
        ELSE
            D201 := boxGen;
        END_IF;

        aAccepted := aAcceptSent OR (X15 AND (D9 = orderGen));
        bAccepted := bAcceptSent OR (X16 AND (D10 = orderGen));
        aNeed := aAccepted AND X15 AND (D13 < 2) AND (D11 > 0);
        bNeed := bAccepted AND X16 AND (D14 < 2) AND (D12 > 0);
        deckHas := (D2 <> 0) OR (D1 <> 0) OR X12;
        deckEmpty := (D2 = 0) AND (NOT X12);

        CASE navState OF
            1:
                D200 := navPos;
                IF (NOT X11) AND (NOT X21) AND (D0 = navPos) THEN
                    navState := 2;
                END_IF;
            2:
                D200 := navPos;
                IF (NOT X11) AND (NOT X21) AND (D0 = navPos) THEN
                    IF navOp = 1 THEN
                        Y11 := TRUE;
                    ELSE
                        IF (navPos = 4) OR (navPos = 5) THEN
                            D201 := orderGen;
                        END_IF;
                        Y12 := TRUE;
                    END_IF;
                    commandIssued := TRUE;
                    navWait := 0;
                    navState := 3;
                END_IF;
            3:
                navWait := navWait + 1;
                IF X11 THEN
                    navState := 4;
                ELSIF navWait > 10 THEN
                    navState := 0;
                    navWait := 0;
                END_IF;
            4:
                IF NOT X11 THEN
                    navState := 0;
                    navWait := 0;
                END_IF;
            ELSE
                navState := 0;
        END_CASE;

        IF Y10 OR Y11 OR Y12 THEN
            commandIssued := TRUE;
        END_IF;

        IF (orderGen <= 2) AND (navState = 0) AND (NOT X11) AND (NOT X21) AND (NOT commandIssued) THEN
            IF (NOT aAcceptSent) AND X13 THEN
                D201 := orderGen;
                Y13 := TRUE;
                aAcceptSent := TRUE;
                commandIssued := TRUE;
            ELSIF (NOT bAcceptSent) AND X14 THEN
                D201 := orderGen;
                Y14 := TRUE;
                bAcceptSent := TRUE;
                commandIssued := TRUE;
            ELSIF aAccepted AND bAccepted AND (NOT aCloseSent) AND (D13 >= 2) THEN
                Y15 := TRUE;
                aCloseSent := TRUE;
                commandIssued := TRUE;
            ELSIF aAccepted AND bAccepted AND (NOT bCloseSent) AND (D14 >= 2) THEN
                Y16 := TRUE;
                bCloseSent := TRUE;
                commandIssued := TRUE;
            ELSIF aCloseSent AND X17 AND X19 AND (NOT aReleaseSent) THEN
                Y17 := TRUE;
                aReleaseSent := TRUE;
                commandIssued := TRUE;
            ELSIF bCloseSent AND X18 AND X1A AND (NOT bReleaseSent) THEN
                Y18 := TRUE;
                bReleaseSent := TRUE;
                commandIssued := TRUE;
            END_IF;
        END_IF;

        IF (orderGen <= 2) AND aAccepted AND bAccepted AND (navState = 0) AND (NOT X11) AND (NOT X21) AND (NOT commandIssued) THEN
            desiredOp := 0;
            desiredPos := 0;

            IF deckHas THEN
                IF aNeed AND (D2 = D11) THEN
                    desiredOp := 2;
                    desiredPos := 4;
                ELSIF bNeed AND (D2 = D12) THEN
                    desiredOp := 2;
                    desiredPos := 5;
                ELSIF D6 = 0 THEN
                    desiredOp := 2;
                    desiredPos := 2;
                ELSIF D8 = 0 THEN
                    desiredOp := 2;
                    desiredPos := 3;
                END_IF;
            ELSE
                IF (aNeed OR bNeed) THEN
                    IF X10 AND ((aNeed AND (D4 = D11)) OR (bNeed AND (D4 = D12))) THEN
                        desiredOp := 1;
                        desiredPos := 1;
                    ELSIF (D6 <> 0) AND ((aNeed AND (D6 = D11)) OR (bNeed AND (D6 = D12))) THEN
                        desiredOp := 1;
                        desiredPos := 2;
                    ELSIF (D8 <> 0) AND ((aNeed AND (D8 = D11)) OR (bNeed AND (D8 = D12))) THEN
                        desiredOp := 1;
                        desiredPos := 3;
                    ELSIF X10 AND ((D6 = 0) OR (D8 = 0)) THEN
                        desiredOp := 1;
                        desiredPos := 1;
                    END_IF;
                END_IF;
            END_IF;

            IF desiredOp <> 0 THEN
                navOp := desiredOp;
                navPos := desiredPos;
                D200 := desiredPos;
                IF D0 <> desiredPos THEN
                    Y10 := TRUE;
                    commandIssued := TRUE;
                    navState := 1;
                ELSE
                    navState := 2;
                END_IF;
            END_IF;
        END_IF;

        IF aReleaseSent AND bReleaseSent AND (NOT boxDispatchSent) THEN
            IF (NOT X1F) AND X1E AND (NOT X24) THEN
                D201 := boxGen;
                Y1C := TRUE;
            ELSE
                Y1C := FALSE;
            END_IF;
        ELSE
            Y1C := FALSE;
        END_IF;

        IF aReleaseSent AND bReleaseSent AND X1F AND (NOT X24) AND (NOT boxDispatchSent) THEN
            Y1D := TRUE;
        ELSE
            Y1D := FALSE;
        END_IF;

        clampTimer(IN := (Y1D AND X20 AND X1F), PT := T#300ms);

        IF aReleaseSent AND bReleaseSent AND X1F AND (D16 = boxGen) AND clampTimer.Q AND (navState = 0) AND (NOT X11) AND (NOT X21) AND (NOT commandIssued) AND (NOT boxDispatchSent) THEN
            IF (NOT packASent) AND X1B AND (D9 = boxGen) THEN
                Y1E := TRUE;
                packASent := TRUE;
                commandIssued := TRUE;
            ELSIF X22 AND (NOT aAckSent) THEN
                Y19 := TRUE;
                aAckSent := TRUE;
                commandIssued := TRUE;
            ELSIF (X22 OR aAckSent) AND (NOT packBSent) AND X1C AND (D10 = boxGen) THEN
                Y1F := TRUE;
                packBSent := TRUE;
                commandIssued := TRUE;
            ELSIF X23 AND (NOT bAckSent) THEN
                Y1A := TRUE;
                bAckSent := TRUE;
                commandIssued := TRUE;
            END_IF;
        ELSE
            clampTimer(IN := (Y1D AND X20 AND X1F), PT := T#300ms);
        END_IF;

        IF X24 THEN
            Y1D := FALSE;
            IF X25 AND (NOT boxDispatchSent) AND aAckSent AND bAckSent AND (NOT X21) AND (navState = 0) AND (NOT X11) AND (NOT commandIssued) THEN
                Y20 := TRUE;
                boxDispatchSent := TRUE;
                commandIssued := TRUE;
            END_IF;
        END_IF;

        IF boxDispatchSent AND (boxGen = 1) AND (NOT X1F) THEN
            orderGen := 2;
            boxGen := 2;
            aAcceptSent := FALSE;
            bAcceptSent := FALSE;
            aCloseSent := FALSE;
            bCloseSent := FALSE;
            aReleaseSent := FALSE;
            bReleaseSent := FALSE;
            aAckSent := FALSE;
            bAckSent := FALSE;
            packASent := FALSE;
            packBSent := FALSE;
            boxDispatchSent := FALSE;
            navState := 0;
            D201 := 2;
        END_IF;

        deckEmpty := (D2 = 0) AND (NOT X12);
        IF boxDispatchSent AND (boxGen = 2) AND X1D AND deckEmpty AND (navState = 0) AND (NOT X11) AND (NOT X21) THEN
            completeLatch := TRUE;
            Y1B := TRUE;
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
            Y1A := FALSE;
            Y1C := FALSE;
            Y1D := FALSE;
            Y1E := FALSE;
            Y1F := FALSE;
        END_IF;
    END_IF;
END_IF;

IF NOT completeLatch THEN
    Y1B := FALSE;
END_IF;

END_PROGRAM