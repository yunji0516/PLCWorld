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
    D12 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;

    (* internal state *)
    aPos : INT;
    aPhase : INT;
    aGenUsed : INT;
    aLoadedProduct : INT;

    bPos : INT;
    bPhase : INT;
    bGenUsed : INT;
    bLoadedProduct : INT;

    leftLiftJig : INT;
    rightLiftJig : INT;
    leftLiftHeight : BOOL;   (* TRUE = up *)
    rightLiftHeight : BOOL;  (* TRUE = up *)

    reqMoveA : BOOL;
    reqMoveB : BOOL;
    moveTargetA : INT;
    moveTargetB : INT;

    transferPending : BOOL;
    transferOwner : INT;
    moveSeenBusy : BOOL;
    moveDoneA : BOOL;
    moveDoneB : BOOL;

    admittedCount : INT;
    exitCount : INT;
    parkedUpperJig : INT;
    completeLatched : BOOL;
    completeCond : BOOL;

    scanCount : DINT;

    exitRecvTrig : R_TRIG;
END_VAR

(* ---- default output reset (edge-pulse style outputs) ---- *)
Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;

scanCount := scanCount + 1;

(* ---- one-time initialization ---- *)
IF scanCount = 1 THEN
    aPos := 0; aPhase := 3;
    leftLiftJig := 101; leftLiftHeight := TRUE;

    bPos := 4; bPhase := 29;
    rightLiftJig := 0; rightLiftHeight := FALSE;

    admittedCount := 0;
    exitCount := 0;
    parkedUpperJig := 0;
    completeLatched := FALSE;

    reqMoveA := FALSE; reqMoveB := FALSE;
    transferPending := FALSE; transferOwner := 0;
    moveSeenBusy := FALSE;
    moveDoneA := FALSE; moveDoneB := FALSE;
END_IF;

(* ---- shared horizontal transfer channel arbiter ---- *)
moveDoneA := FALSE;
moveDoneB := FALSE;

IF transferPending THEN
    IF X11 THEN
        moveSeenBusy := TRUE;
    END_IF;
    IF moveSeenBusy AND (NOT X11) THEN
        transferPending := FALSE;
        moveSeenBusy := FALSE;
        IF transferOwner = 101 THEN
            moveDoneA := TRUE;
        ELSE
            moveDoneB := TRUE;
        END_IF;
        transferOwner := 0;
    END_IF;
ELSE
    IF NOT X11 THEN
        IF reqMoveA THEN
            D200 := 101;
            D201 := moveTargetA;
            Y13 := TRUE;
            transferPending := TRUE;
            transferOwner := 101;
            moveSeenBusy := FALSE;
            reqMoveA := FALSE;
        ELSIF reqMoveB THEN
            D200 := 102;
            D201 := moveTargetB;
            Y13 := TRUE;
            transferPending := TRUE;
            transferOwner := 102;
            moveSeenBusy := FALSE;
            reqMoveB := FALSE;
        END_IF;
    END_IF;
END_IF;

(* ================= JIG A (101) STATE MACHINE ================= *)
CASE aPhase OF
    0:
        IF leftLiftHeight THEN
            aPhase := 3;
        ELSE
            aPhase := 1;
        END_IF;

    1:
        IF X1F AND (NOT X11) AND (NOT transferPending) THEN
            Y14 := TRUE;
            aPhase := 2;
        END_IF;

    2:
        IF X17 THEN
            leftLiftHeight := TRUE;
            aPhase := 3;
        END_IF;

    3:
        IF admittedCount >= 6 THEN
            aPhase := 100;
            parkedUpperJig := 101;
        ELSIF X10 THEN
            aPhase := 4;
        END_IF;

    4:
        Y10 := TRUE;
        aPhase := 5;

    5:
        IF X12 THEN
            aPhase := 6;
        END_IF;

    6:
        IF NOT X12 THEN
            aLoadedProduct := D5;
            admittedCount := admittedCount + 1;
            aPhase := 7;
        END_IF;

    7:
        reqMoveA := TRUE;
        moveTargetA := 1;
        aPhase := 8;

    8:
        IF moveDoneA THEN
            aPos := 1;
            leftLiftJig := 0;
            aPhase := 9;
        END_IF;

    9:
        IF NOT X14 THEN
            aPhase := 10;
        END_IF;

    10:
        D202 := D8;
        aGenUsed := D8;
        Y11 := TRUE;
        aPhase := 11;

    11:
        IF X14 THEN
            aPhase := 12;
        END_IF;

    12:
        IF NOT X14 THEN
            IF (D9 = aLoadedProduct) AND (D10 = aGenUsed) THEN
                aPhase := 13;
            END_IF;
        END_IF;

    13:
        reqMoveA := TRUE;
        moveTargetA := 2;
        aPhase := 14;

    14:
        IF moveDoneA THEN
            aPos := 2;
            aPhase := 15;
        END_IF;

    15:
        IF X15 THEN
            aPhase := 16;
        END_IF;

    16:
        IF NOT X13 THEN
            aPhase := 17;
        END_IF;

    17:
        Y12 := TRUE;
        aPhase := 18;

    18:
        IF X13 THEN
            aPhase := 19;
        END_IF;

    19:
        IF NOT X13 THEN
            aPhase := 20;
        END_IF;

    20:
        IF rightLiftJig = 0 THEN
            IF NOT rightLiftHeight THEN
                aPhase := 21;
            ELSE
                aPhase := 23;
            END_IF;
        END_IF;

    21:
        IF X1E AND (NOT X11) AND (NOT transferPending) THEN
            Y16 := TRUE;
            aPhase := 22;
        END_IF;

    22:
        IF X19 THEN
            rightLiftHeight := TRUE;
            aPhase := 23;
        END_IF;

    23:
        reqMoveA := TRUE;
        moveTargetA := 3;
        aPhase := 24;

    24:
        IF moveDoneA THEN
            aPos := 3;
            rightLiftJig := 101;
            aPhase := 25;
        END_IF;

    25:
        IF X1E AND (NOT X11) AND (NOT transferPending) THEN
            Y17 := TRUE;
            aPhase := 26;
        END_IF;

    26:
        IF X1A THEN
            rightLiftHeight := FALSE;
            aPhase := 27;
        END_IF;

    27:
        reqMoveA := TRUE;
        moveTargetA := 4;
        aPhase := 28;

    28:
        IF moveDoneA THEN
            aPos := 4;
            rightLiftJig := 0;
            aPhase := 29;
        END_IF;

    29:
        IF (admittedCount >= 6) AND (parkedUpperJig <> 0) AND (parkedUpperJig <> 101) THEN
            aPhase := 101;
        ELSE
            IF leftLiftJig = 0 THEN
                IF leftLiftHeight THEN
                    aPhase := 30;
                ELSE
                    aPhase := 32;
                END_IF;
            END_IF;
        END_IF;

    30:
        IF X1F AND (NOT X11) AND (NOT transferPending) THEN
            Y15 := TRUE;
            aPhase := 31;
        END_IF;

    31:
        IF X18 THEN
            leftLiftHeight := FALSE;
            aPhase := 32;
        END_IF;

    32:
        reqMoveA := TRUE;
        moveTargetA := 0;
        aPhase := 33;

    33:
        IF moveDoneA THEN
            aPos := 0;
            leftLiftJig := 101;
            leftLiftHeight := FALSE;
            aPhase := 0;
        END_IF;

    100: ;
    101: ;
    ELSE
        ;
END_CASE;

(* ================= JIG B (102) STATE MACHINE ================= *)
CASE bPhase OF
    0:
        IF leftLiftHeight THEN
            bPhase := 3;
        ELSE
            bPhase := 1;
        END_IF;

    1:
        IF X1F AND (NOT X11) AND (NOT transferPending) THEN
            Y14 := TRUE;
            bPhase := 2;
        END_IF;

    2:
        IF X17 THEN
            leftLiftHeight := TRUE;
            bPhase := 3;
        END_IF;

    3:
        IF admittedCount >= 6 THEN
            bPhase := 100;
            parkedUpperJig := 102;
        ELSIF X10 THEN
            bPhase := 4;
        END_IF;

    4:
        Y10 := TRUE;
        bPhase := 5;

    5:
        IF X12 THEN
            bPhase := 6;
        END_IF;

    6:
        IF NOT X12 THEN
            bLoadedProduct := D5;
            admittedCount := admittedCount + 1;
            bPhase := 7;
        END_IF;

    7:
        reqMoveB := TRUE;
        moveTargetB := 1;
        bPhase := 8;

    8:
        IF moveDoneB THEN
            bPos := 1;
            leftLiftJig := 0;
            bPhase := 9;
        END_IF;

    9:
        IF NOT X14 THEN
            bPhase := 10;
        END_IF;

    10:
        D202 := D8;
        bGenUsed := D8;
        Y11 := TRUE;
        bPhase := 11;

    11:
        IF X14 THEN
            bPhase := 12;
        END_IF;

    12:
        IF NOT X14 THEN
            IF (D9 = bLoadedProduct) AND (D10 = bGenUsed) THEN
                bPhase := 13;
            END_IF;
        END_IF;

    13:
        reqMoveB := TRUE;
        moveTargetB := 2;
        bPhase := 14;

    14:
        IF moveDoneB THEN
            bPos := 2;
            bPhase := 15;
        END_IF;

    15:
        IF X15 THEN
            bPhase := 16;
        END_IF;

    16:
        IF NOT X13 THEN
            bPhase := 17;
        END_IF;

    17:
        Y12 := TRUE;
        bPhase := 18;

    18:
        IF X13 THEN
            bPhase := 19;
        END_IF;

    19:
        IF NOT X13 THEN
            bPhase := 20;
        END_IF;

    20:
        IF rightLiftJig = 0 THEN
            IF NOT rightLiftHeight THEN
                bPhase := 21;
            ELSE
                bPhase := 23;
            END_IF;
        END_IF;

    21:
        IF X1E AND (NOT X11) AND (NOT transferPending) THEN
            Y16 := TRUE;
            bPhase := 22;
        END_IF;

    22:
        IF X19 THEN
            rightLiftHeight := TRUE;
            bPhase := 23;
        END_IF;

    23:
        reqMoveB := TRUE;
        moveTargetB := 3;
        bPhase := 24;

    24:
        IF moveDoneB THEN
            bPos := 3;
            rightLiftJig := 102;
            bPhase := 25;
        END_IF;

    25:
        IF X1E AND (NOT X11) AND (NOT transferPending) THEN
            Y17 := TRUE;
            bPhase := 26;
        END_IF;

    26:
        IF X1A THEN
            rightLiftHeight := FALSE;
            bPhase := 27;
        END_IF;

    27:
        reqMoveB := TRUE;
        moveTargetB := 4;
        bPhase := 28;

    28:
        IF moveDoneB THEN
            bPos := 4;
            rightLiftJig := 0;
            bPhase := 29;
        END_IF;

    29:
        IF (admittedCount >= 6) AND (parkedUpperJig <> 0) AND (parkedUpperJig <> 102) THEN
            bPhase := 101;
        ELSE
            IF leftLiftJig = 0 THEN
                IF leftLiftHeight THEN
                    bPhase := 30;
                ELSE
                    bPhase := 32;
                END_IF;
            END_IF;
        END_IF;

    30:
        IF X1F AND (NOT X11) AND (NOT transferPending) THEN
            Y15 := TRUE;
            bPhase := 31;
        END_IF;

    31:
        IF X18 THEN
            leftLiftHeight := FALSE;
            bPhase := 32;
        END_IF;

    32:
        reqMoveB := TRUE;
        moveTargetB := 0;
        bPhase := 33;

    33:
        IF moveDoneB THEN
            bPos := 0;
            leftLiftJig := 102;
            leftLiftHeight := FALSE;
            bPhase := 0;
        END_IF;

    100: ;
    101: ;
    ELSE
        ;
END_CASE;

(* ---- external product reception acknowledgement ---- *)
exitRecvTrig(CLK := X16);
IF exitRecvTrig.Q THEN
    Y18 := TRUE;
    exitCount := exitCount + 1;
END_IF;

(* ---- completion determination ---- *)
completeCond := ((aPhase = 100) OR (aPhase = 101)) AND
                ((bPhase = 100) OR (bPhase = 101)) AND
                (exitCount >= 6) AND
                (NOT X11) AND (NOT X12) AND (NOT X13) AND (NOT X14) AND
                (NOT transferPending);

IF completeCond THEN
    completeLatched := TRUE;
END_IF;

Y19 := completeLatched;

END_PROGRAM