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

    (* internal state *)
    started        : BOOL := FALSE;
    step           : INT := 0;
    totalExtracted : INT := 0;
    aSent          : INT := 0;
    bSent          : INT := 0;
    mag1Recovered  : BOOL := FALSE;
    isLast         : BOOL := FALSE;
    waitingReturn  : BOOL := FALSE;
    leftHome       : BOOL := FALSE;
    swapCondMet    : BOOL := FALSE;

    aAssembleCond  : BOOL;
    bAssembleCond  : BOOL;
    releaseACond   : BOOL;
    releaseBCond   : BOOL;

    allDone        : BOOL := FALSE;
    completeLatch  : BOOL := FALSE;

    startTrig      : R_TRIG;
    assembleATrig  : R_TRIG;
    assembleBTrig  : R_TRIG;
    releaseATrig   : R_TRIG;
    releaseBTrig   : R_TRIG;

    stableTimer    : TON;
END_VAR

startTrig(CLK := X0);

IF NOT started THEN
    Y10 := TRUE;
    Y11 := TRUE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;

    IF startTrig.Q AND X10 AND X11 AND X12 AND X14 THEN
        started := TRUE;
        step := 10;
    END_IF;
ELSE
    (* default resets for pulse-type outputs; level outputs (Y10,Y11) hold *)
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;

    CASE step OF

    10: (* decide next action *)
        IF totalExtracted >= 7 THEN
            step := 100;
        ELSIF D1 = 0 THEN
            step := 50;
        ELSIF X16 AND X11 AND X12 THEN
            step := 20;
        END_IF;

    20: (* release lower to drop lowest item onto shuttle *)
        Y10 := FALSE;
        IF X17 THEN
            step := 30;
        END_IF;

    30: (* extract *)
        Y12 := TRUE;
        IF X18 THEN
            step := 35;
        END_IF;

    35: (* restore lower support *)
        Y10 := TRUE;
        IF X14 THEN
            isLast := (totalExtracted = 6);
            IF isLast THEN
                Y11 := FALSE; (* release upper permanently, nothing left to retain *)
                step := 38;
            ELSE
                step := 36;
            END_IF;
        END_IF;

    36: (* open upper to let next item descend *)
        Y11 := FALSE;
        IF X13 THEN
            step := 37;
        END_IF;

    37: (* re-close upper to retain remaining stack *)
        Y11 := TRUE;
        IF X12 THEN
            step := 38;
        END_IF;

    38: (* assign side/request for this extracted item *)
        IF aSent < 3 THEN
            D200 := 1;
            D201 := aSent + 1;
            aSent := aSent + 1;
        ELSE
            D200 := 2;
            D201 := bSent + 1;
            bSent := bSent + 1;
        END_IF;
        totalExtracted := totalExtracted + 1;
        waitingReturn := TRUE;
        leftHome := FALSE;
        step := 39;

    39: (* pulse send *)
        Y13 := TRUE;
        step := 40;

    40: (* wait shuttle to leave home then return before next cycle *)
        IF waitingReturn THEN
            IF NOT X16 THEN
                leftHome := TRUE;
            END_IF;
            IF leftHome AND X16 THEN
                waitingReturn := FALSE;
                leftHome := FALSE;
                step := 10;
            END_IF;
        ELSE
            step := 10;
        END_IF;

    50: (* swap prep: ensure lower closed and extractor clear *)
        Y12 := FALSE;
        Y10 := TRUE;
        IF X14 THEN
            step := 51;
        END_IF;

    51: (* open upper - must stay open for entire exchange *)
        Y11 := FALSE;
        IF X13 THEN
            step := 52;
        END_IF;

    52: (* wait for all swap conditions *)
        swapCondMet := X18 AND X14 AND X13 AND X1A AND X10;
        IF swapCondMet THEN
            step := 53;
        END_IF;

    53: (* pulse swap *)
        Y11 := FALSE;
        Y14 := TRUE;
        step := 54;

    54: (* wait swap started *)
        Y11 := FALSE;
        IF X19 THEN
            step := 55;
        END_IF;

    55: (* wait swap completed *)
        Y11 := FALSE;
        IF NOT X19 THEN
            step := 56;
        END_IF;

    56: (* wait return_ready *)
        Y11 := FALSE;
        IF X1B THEN
            step := 57;
        END_IF;

    57: (* pulse take_empty *)
        Y11 := FALSE;
        Y15 := TRUE;
        step := 58;

    58: (* wait empty confirmed removed *)
        Y11 := FALSE;
        IF X1C THEN
            mag1Recovered := TRUE;
            step := 59;
        END_IF;

    59: (* close upper again to resume retention for new magazine *)
        Y11 := TRUE;
        IF X12 THEN
            step := 10;
        END_IF;

    100: (* all required extractions/exchanges complete: hold final state *)
        Y10 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        (* Y11 remains FALSE (open) as left by the last-item branch *)
        step := 100;

    ELSE
        step := 10;
    END_CASE;
END_IF;

(* ---- Independent assembly / release logic ---- *)
aAssembleCond := X1F AND X20 AND (NOT X21);
assembleATrig(CLK := aAssembleCond);
Y16 := assembleATrig.Q;

bAssembleCond := X25 AND X26 AND (NOT X27);
assembleBTrig(CLK := bAssembleCond);
Y17 := assembleBTrig.Q;

releaseACond := X22 AND X23;
releaseATrig(CLK := releaseACond);
Y18 := releaseATrig.Q;

releaseBCond := X28 AND X29;
releaseBTrig(CLK := releaseBCond);
Y19 := releaseBTrig.Q;

(* ---- Completion monitoring ---- *)
allDone := (totalExtracted >= 7) AND (D3 >= 3) AND (D4 >= 4) AND mag1Recovered
           AND (D0 = 202) AND (D1 = 1) AND X16 AND X14 AND Y10
           AND X13 AND (NOT Y11);

stableTimer(IN := allDone, PT := T#500ms);
IF stableTimer.Q THEN
    completeLatch := TRUE;
END_IF;

Y1A := completeLatch;

END_PROGRAM