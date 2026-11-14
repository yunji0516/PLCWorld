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
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* --- internal edge detectors --- *)
    r_batchready : R_TRIG;
    r_batchdone  : R_TRIG;
    r_aavail     : R_TRIG;
    r_bavail     : R_TRIG;
    r_splice     : R_TRIG;

    (* --- batch handling --- *)
    batchState : INT := 0;
    batchCount : INT := 0;

    (* --- feed hysteresis --- *)
    feedActive : BOOL := FALSE;

    (* --- piece / waste cutting cycle --- *)
    pieceState   : INT := 0;
    pieceCount   : INT := 0;
    wasteCount   : INT := 0;
    curSide      : INT := 0;
    curTarget    : INT := 0;
    curIsWaste   : BOOL := FALSE;
    curWasteReason : INT := 0;   (* 1 = length exceed, 2 = splice waste *)
    startPullEnc : INT := 0;
    tolerance    : INT := 2;

    holdTimer  : TON;
    bladeTimer : TON;

    (* --- splice sequence --- *)
    spliceState    : INT := 0;
    spliceBusy     : BOOL := FALSE;
    spliceCounted  : BOOL := FALSE;
    spliceCount    : INT := 0;
    spliceWasteDone : BOOL := FALSE;

    (* --- completion --- *)
    completeHoldTimer : TON;
    completeDeclared  : BOOL := FALSE;
END_VAR

(* =============== edge detectors =============== *)
r_batchready(CLK := X10);
r_batchdone(CLK := X12);
r_aavail(CLK := X13);
r_bavail(CLK := X14);
r_splice(CLK := X27);

IF r_splice.Q THEN
    spliceWasteDone := FALSE;
    spliceCounted := FALSE;
END_IF;

(* =============== reset one-scan pulse outputs =============== *)
Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y1A := FALSE;
Y22 := FALSE;

(* =============== order acceptance edges =============== *)
IF r_aavail.Q THEN
    Y12 := TRUE;
END_IF;
IF r_bavail.Q THEN
    Y13 := TRUE;
END_IF;

(* =============== batch handling =============== *)
CASE batchState OF
    0:
        IF r_batchready.Q THEN
            Y10 := TRUE;
            batchState := 1;
        END_IF;
    1:
        IF X11 THEN
            batchState := 2;
        END_IF;
    2:
        IF D1 = 0 THEN
            batchState := 3;
        END_IF;
    3:
        IF r_batchdone.Q THEN
            Y11 := TRUE;
            batchCount := batchCount + 1;
            batchState := 0;
        END_IF;
END_CASE;

(* =============== spare reel handling =============== *)
IF X20 THEN
    Y1C := TRUE;
END_IF;
IF X21 THEN
    Y1D := TRUE;
END_IF;

(* =============== splice sequence =============== *)
CASE spliceState OF
    0:
        IF X27 THEN
            Y20 := TRUE;
            spliceState := 1;
        END_IF;
    1:
        IF X25 THEN
            Y20 := FALSE;
        ELSE
            Y20 := TRUE;
        END_IF;
        IF X25 AND X22 THEN
            spliceState := 2;
        END_IF;
    2:
        Y1E := TRUE;
        Y1F := TRUE;
        IF X23 AND X24 THEN
            spliceState := 3;
        END_IF;
    3:
        Y1E := TRUE;
        Y1F := TRUE;
        Y21 := TRUE;
        IF X26 THEN
            spliceState := 4;
        END_IF;
    4:
        Y1E := FALSE;
        Y1F := FALSE;
        Y21 := FALSE;
        IF NOT spliceCounted THEN
            spliceCount := spliceCount + 1;
            spliceCounted := TRUE;
        END_IF;
        IF X28 THEN
            spliceState := 5;
        END_IF;
    5:
        spliceState := 6;
    6:
        ; (* done, remain latched *)
END_CASE;

spliceBusy := (spliceState >= 2) AND (spliceState <= 4);

(* =============== feed regulation (dancer storage) =============== *)
IF spliceBusy OR (batchState <> 2) OR (D1 <= 0) THEN
    feedActive := FALSE;
ELSE
    IF D2 <= 900 THEN
        feedActive := TRUE;
    END_IF;
    IF D2 >= 1300 THEN
        feedActive := FALSE;
    END_IF;
END_IF;
Y15 := feedActive;

(* =============== piece / waste production cycle =============== *)
CASE pieceState OF
    0: (* select next target: splice waste first, then length-exceed waste, then normal A/B *)
        IF X26 AND NOT spliceWasteDone AND NOT X29 THEN
            curIsWaste := TRUE;
            curWasteReason := 2;
            curTarget := D11;
            curSide := 3;
            pieceState := 1;
        ELSIF X15 AND (D5 > D10) THEN
            curIsWaste := TRUE;
            curWasteReason := 1;
            curTarget := D11;
            curSide := 3;
            pieceState := 1;
        ELSIF X15 THEN
            curIsWaste := FALSE;
            curWasteReason := 0;
            curTarget := D5;
            curSide := 1;
            pieceState := 1;
        ELSIF X16 AND (D6 > D10) THEN
            curIsWaste := TRUE;
            curWasteReason := 1;
            curTarget := D11;
            curSide := 3;
            pieceState := 1;
        ELSIF X16 THEN
            curIsWaste := FALSE;
            curWasteReason := 0;
            curTarget := D6;
            curSide := 2;
            pieceState := 1;
        END_IF;

    1: (* wait for empty slice position, then start *)
        IF X17 THEN
            D200 := curSide;
            startPullEnc := D4;
            IF curIsWaste THEN
                Y22 := TRUE;
            ELSE
                Y14 := TRUE;
            END_IF;
            pieceState := 2;
        END_IF;

    2: (* growing: pull only while holder fully open *)
        Y17 := FALSE;
        IF X1F THEN
            Y16 := TRUE;
        ELSE
            Y16 := FALSE;
        END_IF;
        IF D8 >= curTarget THEN
            Y16 := FALSE;
            pieceState := 3;
        END_IF;

    3: (* stop pull, close holder, wait 0.15s response *)
        Y16 := FALSE;
        Y17 := TRUE;
        holdTimer(IN := TRUE, PT := T#150ms);
        IF holdTimer.Q AND X1B THEN
            pieceState := 4;
        END_IF;

    4: (* verify stopped, closed, within +-2mm, then trigger cut *)
        Y17 := TRUE;
        holdTimer(IN := TRUE, PT := T#150ms);
        IF X1B AND (ABS(D8 - curTarget) <= tolerance) AND (NOT X18) AND (NOT X1A) THEN
            Y18 := TRUE;
            holdTimer(IN := FALSE, PT := T#150ms);
            bladeTimer(IN := TRUE, PT := T#600ms);
            pieceState := 5;
        END_IF;

    5: (* wait blade reciprocation 0.6s + physical separation *)
        bladeTimer(IN := TRUE, PT := T#600ms);
        IF bladeTimer.Q AND X19 AND (NOT X1A) THEN
            bladeTimer(IN := FALSE, PT := T#600ms);
            pieceState := 6;
        END_IF;

    6: (* open holder before release allowed *)
        Y17 := FALSE;
        IF X1F THEN
            pieceState := 7;
        END_IF;

    7: (* release rising edge only after separation, blade return, holder open *)
        IF X19 AND (NOT X1A) AND X1F THEN
            Y19 := TRUE;
            pieceState := 8;
        END_IF;

    8: (* wait receiving zone delay *)
        IF X1D THEN
            pieceState := 9;
        END_IF;

    9: (* ack exit and count *)
        Y1A := TRUE;
        IF curIsWaste THEN
            wasteCount := wasteCount + 1;
            IF curWasteReason = 2 THEN
                spliceWasteDone := TRUE;
            END_IF;
        ELSE
            pieceCount := pieceCount + 1;
        END_IF;
        curIsWaste := FALSE;
        pieceState := 0;
END_CASE;

(* =============== completion handling =============== *)
completeHoldTimer(IN := (batchCount >= 5) AND (pieceCount >= 6) AND (spliceCount >= 1) AND (wasteCount >= 1) AND X1E,
                   PT := T#500ms);

IF completeHoldTimer.Q THEN
    completeDeclared := TRUE;
END_IF;

Y1B := completeDeclared;

END_PROGRAM