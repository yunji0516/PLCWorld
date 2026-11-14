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
    D200 : INT;
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
    Y1F : BOOL;
    (* Add internal variables here. *)
    mState : INT;
    bundleNo : INT;
    selectedCount : INT;
    currentBundleCount : INT;
    targetLen : INT;
    indexLatched : BOOL;
    tapePrepared : BOOL;
    seenSwapBusy : BOOL;
    started : BOOL;
END_VAR

IF D10 > 0 THEN
    selectedCount := D10;
ELSE
    CASE bundleNo OF
        1:
            selectedCount := 2;
        2:
            selectedCount := 3;
        3:
            selectedCount := 4;
    ELSE
        selectedCount := 4;
    END_CASE;
END_IF;

IF currentBundleCount <= 0 THEN
    currentBundleCount := selectedCount;
END_IF;

IF D3 > 0 THEN
    targetLen := D3;
ELSE
    CASE currentBundleCount OF
        2:
            targetLen := 1192;
        3:
            targetLen := 1472;
        4:
            targetLen := 1752;
    ELSE
        targetLen := 1192;
    END_CASE;
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
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

CASE mState OF
    0:
        IF X0 THEN
            started := TRUE;
            bundleNo := 1;
            currentBundleCount := 0;
            indexLatched := FALSE;
            tapePrepared := FALSE;
            seenSwapBusy := FALSE;
            mState := 10;
        END_IF;

    10:
        indexLatched := FALSE;
        tapePrepared := FALSE;
        seenSwapBusy := FALSE;
        IF NOT X2E THEN
            Y21 := TRUE;
            IF X2C THEN
                Y22 := FALSE;
            END_IF;
        ELSE
            Y22 := FALSE;
            Y21 := FALSE;
            IF X2D AND X2B THEN
                mState := 20;
            END_IF;
        END_IF;

    20:
        Y1D := TRUE;
        IF selectedCount < 1 THEN
            selectedCount := 2;
        END_IF;

        IF D9 >= selectedCount THEN
            Y1F := TRUE;
            Y1C := FALSE;
            IF X29 AND X2D AND X2E THEN
                currentBundleCount := selectedCount;
                indexLatched := FALSE;
                mState := 30;
            END_IF;
        ELSE
            Y1F := FALSE;
            IF X27 OR X28 THEN
                indexLatched := FALSE;
            END_IF;

            IF X25 AND X28 AND X26 AND (NOT X27) AND X2D AND X2E AND X2B THEN
                Y1C := TRUE;
            END_IF;

            IF (NOT X28) AND (NOT X27) AND (NOT indexLatched) AND X2D AND X2E AND X2B THEN
                Y1E := TRUE;
                indexLatched := TRUE;
            END_IF;
        END_IF;

    30:
        Y1D := TRUE;
        Y1F := TRUE;
        Y20 := TRUE;
        IF X2A THEN
            mState := 40;
        END_IF;

    40:
        Y20 := TRUE;
        Y21 := TRUE;
        IF X2C THEN
            mState := 50;
        END_IF;

    50:
        Y20 := TRUE;
        Y21 := TRUE;
        IF X30 THEN
            Y22 := TRUE;
            IF X2F THEN
                mState := 60;
            END_IF;
        END_IF;

    60:
        Y20 := TRUE;
        Y22 := TRUE;
        Y21 := FALSE;
        IF X2D THEN
            mState := 70;
        END_IF;

    70:
        Y20 := FALSE;
        Y22 := TRUE;
        Y21 := FALSE;
        IF X2B THEN
            mState := 80;
        END_IF;

    80:
        Y20 := FALSE;
        Y22 := TRUE;
        Y21 := TRUE;
        IF X2C THEN
            mState := 90;
        END_IF;

    90:
        Y22 := TRUE;
        Y21 := TRUE;
        IF X10 THEN
            Y23 := FALSE;
            mState := 100;
        ELSE
            IF X32 AND X2C AND X33 AND (NOT X12) AND X17 AND (NOT X15) THEN
                Y23 := TRUE;
            END_IF;
        END_IF;

    100:
        Y22 := TRUE;
        Y21 := TRUE;
        IF NOT X12 THEN
            Y13 := TRUE;
            IF X10 AND X33 THEN
                Y24 := TRUE;
            END_IF;
        ELSE
            IF X10 THEN
                Y10 := TRUE;
                IF X16 AND (D1 <> 0) THEN
                    mState := 110;
                END_IF;
            END_IF;
        END_IF;

    110:
        Y22 := TRUE;
        Y21 := TRUE;
        Y10 := TRUE;
        Y14 := TRUE;
        IF X13 AND X11 THEN
            mState := 120;
        END_IF;

    120:
        Y22 := TRUE;
        Y21 := TRUE;
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := TRUE;
        IF X19 THEN
            mState := 130;
        END_IF;

    130:
        Y22 := TRUE;
        Y21 := TRUE;
        Y11 := TRUE;
        Y12 := TRUE;
        Y10 := FALSE;
        IF X17 THEN
            mState := 140;
        END_IF;

    140:
        Y22 := TRUE;
        Y21 := TRUE;
        Y11 := TRUE;
        Y12 := TRUE;
        IF NOT X18 THEN
            Y13 := TRUE;
        ELSE
            mState := 200;
        END_IF;

    200:
        Y11 := TRUE;
        Y12 := TRUE;
        IF NOT X18 THEN
            Y13 := TRUE;
        END_IF;

        IF D0 <> 0 THEN
            D200 := D0;
        ELSE
            D200 := bundleNo;
        END_IF;
        Y18 := TRUE;
        tapePrepared := TRUE;
        mState := 210;

    210:
        Y11 := TRUE;
        Y12 := TRUE;
        IF NOT X18 THEN
            Y13 := TRUE;
        END_IF;

        IF D2 >= targetLen THEN
            Y16 := FALSE;
            mState := 230;
        ELSE
            IF D4 <= 6 THEN
                Y16 := FALSE;
                mState := 220;
            ELSE
                IF X19 AND X1B AND X18 AND X1C AND (NOT X1D) THEN
                    Y16 := TRUE;
                END_IF;
            END_IF;
        END_IF;

    220:
        Y11 := TRUE;
        Y12 := TRUE;
        Y16 := FALSE;
        IF X19 AND X1B AND X18 AND (NOT X1D) THEN
            Y17 := TRUE;
            seenSwapBusy := FALSE;
            mState := 221;
        END_IF;

    221:
        Y11 := TRUE;
        Y12 := TRUE;
        Y16 := FALSE;
        IF X1D THEN
            seenSwapBusy := TRUE;
        END_IF;
        IF (NOT X1D) AND X1C AND (D4 > 20) AND (seenSwapBusy OR X1E) THEN
            seenSwapBusy := FALSE;
            mState := 210;
        END_IF;

    230:
        Y11 := TRUE;
        Y12 := TRUE;
        Y16 := FALSE;

        IF D0 <> 0 THEN
            D200 := D0;
        END_IF;

        IF (D5 <> D0) AND (D0 <> 0) AND (NOT tapePrepared) THEN
            Y18 := TRUE;
            tapePrepared := TRUE;
        END_IF;

        IF X21 THEN
            mState := 240;
        ELSE
            IF X20 AND ((D5 = D0) OR (D0 = 0)) AND X19 AND X1B AND (D2 >= targetLen) THEN
                Y19 := TRUE;
            END_IF;
        END_IF;

    240:
        Y11 := TRUE;
        Y12 := TRUE;
        Y16 := FALSE;
        IF X22 THEN
            mState := 300;
        ELSE
            IF X19 AND X1B AND X21 AND (D2 >= targetLen) THEN
                Y1A := TRUE;
            END_IF;
        END_IF;

    300:
        Y11 := TRUE;
        Y12 := TRUE;
        Y14 := TRUE;
        IF X13 AND X11 THEN
            Y10 := TRUE;
        END_IF;
        IF X16 THEN
            mState := 310;
        END_IF;

    310:
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := FALSE;
        IF X1A AND X22 AND X23 THEN
            mState := 320;
        END_IF;

    320:
        Y10 := TRUE;
        Y15 := TRUE;
        IF X14 THEN
            mState := 330;
        END_IF;

    330:
        Y10 := FALSE;
        IF X17 THEN
            mState := 340;
        END_IF;

    340:
        IF bundleNo >= 3 THEN
            IF X24 AND X17 AND X1A THEN
                mState := 900;
            END_IF;
        ELSE
            IF X23 THEN
                bundleNo := bundleNo + 1;
                currentBundleCount := 0;
                indexLatched := FALSE;
                tapePrepared := FALSE;
                seenSwapBusy := FALSE;
                mState := 10;
            END_IF;
        END_IF;

    900:
        Y1B := TRUE;

ELSE
    mState := 0;
END_CASE;

END_PROGRAM