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
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
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
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
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
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
    Y28 : BOOL;
    Y29 : BOOL;
    state : INT := 0;
    aAccepted : BOOL := FALSE;
    bAccepted : BOOL := FALSE;
    bTrimStarted : BOOL := FALSE;
    bTrimmed : BOOL := FALSE;
    activeRoll : BOOL := FALSE;
    coreCount : INT := 0;
    rollSlot : INT := 0;
    targetSnap : INT := 0;
    targetMet : BOOL := FALSE;
    cutsIssued : BOOL := FALSE;
    tapePrepIssued : BOOL := FALSE;
    tapeCutIssued : BOOL := FALSE;
    tapeApplyIssued : BOOL := FALSE;
    exitAckIssued : BOOL := FALSE;
    completeLatched : BOOL := FALSE;
    finalReady : BOOL := FALSE;
    completeTimer : TON;
    rollIds : ARRAY[1..3] OF INT;
    rollTargets : ARRAY[1..3] OF INT;
    rollReceived : ARRAY[1..3] OF INT;
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
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;
Y27 := FALSE;
Y28 := FALSE;
Y29 := FALSE;

IF targetSnap > 0 THEN
    targetMet := (D5 >= (targetSnap - 2));
ELSE
    targetMet := FALSE;
END_IF;

CASE state OF
    0:
        IF X0 THEN
            state := 10;
        END_IF;

    10:
        IF (NOT aAccepted) AND X10 AND X12 THEN
            Y10 := TRUE;
            aAccepted := TRUE;
        END_IF;

        IF (NOT bAccepted) AND X11 AND X13 THEN
            Y11 := TRUE;
            bAccepted := TRUE;
        END_IF;

        IF aAccepted AND bAccepted THEN
            state := 20;
        END_IF;

    20:
        IF bAccepted AND (NOT bTrimStarted) AND (NOT activeRoll) AND X25 THEN
            IF D2 < D0 THEN
                Y14 := TRUE;
            ELSE
                state := 30;
            END_IF;
        END_IF;

    30:
        Y13 := TRUE;
        IF X15 AND (D2 >= D0) AND (D0 > 0) AND (NOT bTrimStarted) THEN
            Y15 := TRUE;
            bTrimStarted := TRUE;
            state := 40;
        END_IF;

    40:
        Y13 := TRUE;
        IF bTrimStarted AND X16 AND X17 THEN
            Y16 := TRUE;
            bTrimmed := TRUE;
            state := 50;
        END_IF;

    50:
        IF aAccepted AND bTrimmed THEN
            IF coreCount >= 3 THEN
                state := 900;
            ELSE
                state := 100;
            END_IF;
        END_IF;

    100:
        Y24 := TRUE;
        IF NOT X2D THEN
            Y23 := TRUE;
        END_IF;

        IF (coreCount < 3) AND aAccepted AND bTrimmed AND (NOT activeRoll) AND X1D AND X2D AND X2E AND X18 AND (NOT X21) THEN
            Y23 := FALSE;
            Y17 := TRUE;
            activeRoll := TRUE;
            rollSlot := coreCount + 1;
            targetSnap := D4;
            IF rollSlot >= 1 AND rollSlot <= 3 THEN
                rollIds[rollSlot] := D3;
                rollTargets[rollSlot] := D4;
            END_IF;
            cutsIssued := FALSE;
            tapePrepIssued := FALSE;
            tapeCutIssued := FALSE;
            tapeApplyIssued := FALSE;
            exitAckIssued := FALSE;
            state := 110;
        END_IF;

    110:
        IF activeRoll AND X19 AND (NOT X1A) THEN
            state := 120;
        END_IF;

    120:
        IF activeRoll AND X19 AND (NOT X1A) THEN
            IF NOT X1E THEN
                Y1F := TRUE;
            ELSE
                state := 130;
            END_IF;
        END_IF;

    130:
        Y18 := TRUE;
        Y19 := TRUE;
        IF activeRoll AND X1E AND X1B AND X1C AND X24 THEN
            state := 140;
        END_IF;

    140:
        Y18 := TRUE;
        Y19 := TRUE;
        IF activeRoll AND X1E AND X1B AND X1C AND X24 THEN
            IF (targetSnap > 0) AND (D5 < targetSnap) THEN
                Y1A := TRUE;
            ELSE
                state := 150;
            END_IF;
        END_IF;

    150:
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        IF activeRoll AND X1E AND X14 AND X15 THEN
            state := 160;
        END_IF;

    160:
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        IF activeRoll AND X1E AND X14 AND X15 AND X28 AND (NOT X27) AND (NOT cutsIssued) THEN
            Y1C := TRUE;
            Y1D := TRUE;
            cutsIssued := TRUE;
            state := 170;
        END_IF;

    170:
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        IF cutsIssued AND X27 AND X28 THEN
            state := 180;
        END_IF;

    180:
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        IF activeRoll AND X1E AND X1B AND X1C AND X27 THEN
            IF NOT X26 THEN
                Y1A := TRUE;
            ELSE
                state := 190;
            END_IF;
        END_IF;

    190:
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        IF (NOT tapePrepIssued) AND (NOT X32) AND (NOT X31) AND (D9 >= 80) THEN
            Y25 := TRUE;
            tapePrepIssued := TRUE;
            state := 200;
        END_IF;

    200:
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        Y26 := TRUE;
        IF tapePrepIssued AND X30 AND X2F AND (NOT X32) THEN
            state := 210;
        END_IF;

    210:
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        Y26 := TRUE;
        IF tapePrepIssued AND X30 AND X2F AND (NOT X32) AND (NOT tapeCutIssued) THEN
            Y27 := TRUE;
            tapeCutIssued := TRUE;
            state := 220;
        END_IF;

    220:
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        Y26 := TRUE;
        IF tapeCutIssued AND X31 AND (NOT X32) THEN
            state := 230;
        END_IF;

    230:
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        Y26 := TRUE;
        IF activeRoll AND X31 AND X2A AND (NOT X32) AND X1E AND targetMet AND X26 AND X27 AND X14 AND X15 AND (NOT tapeApplyIssued) THEN
            Y28 := TRUE;
            tapeApplyIssued := TRUE;
            state := 240;
        END_IF;

    240:
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        IF tapeApplyIssued AND X33 AND (NOT X32) THEN
            state := 250;
        END_IF;

    250:
        Y1B := TRUE;
        IF activeRoll AND X1F THEN
            state := 260;
        END_IF;

    260:
        Y1B := TRUE;
        IF activeRoll AND X1F AND X27 AND X26 AND X33 AND (NOT X32) THEN
            IF NOT X1D THEN
                Y1E := TRUE;
            ELSE
                state := 270;
            END_IF;
        END_IF;

    270:
        Y1B := TRUE;
        IF activeRoll AND X1D AND X1F THEN
            Y20 := TRUE;
            IF X20 AND X34 AND X35 THEN
                state := 280;
            END_IF;
        END_IF;

    280:
        IF activeRoll AND X1D AND X20 AND X34 AND X35 THEN
            Y29 := TRUE;
            IF X22 THEN
                state := 290;
            END_IF;
        END_IF;

    290:
        IF X22 AND (NOT exitAckIssued) THEN
            Y21 := TRUE;
            exitAckIssued := TRUE;
            IF rollSlot >= 1 AND rollSlot <= 3 THEN
                rollReceived[rollSlot] := D8;
            END_IF;
            state := 300;
        END_IF;

    300:
        IF exitAckIssued AND X23 AND X20 AND (NOT X21) AND (NOT X32) THEN
            activeRoll := FALSE;
            coreCount := coreCount + 1;
            targetSnap := 0;
            state := 50;
        END_IF;

    900:
        IF completeLatched THEN
            Y22 := TRUE;
        END_IF;

ELSE
    state := 0;
END_CASE;

finalReady := (state = 900) AND (coreCount >= 3) AND X23 AND X20 AND X34 AND (NOT X21) AND (NOT X32) AND (D8 >= 3);
completeTimer(IN := finalReady, PT := T#100ms);
IF completeTimer.Q THEN
    completeLatched := TRUE;
END_IF;

IF completeLatched THEN
    Y22 := TRUE;
END_IF;

END_PROGRAM