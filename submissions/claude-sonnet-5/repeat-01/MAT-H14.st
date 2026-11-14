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
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT;
    D204 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;

    (* internal state machines *)
    preState  : INT := 0;
    postState : INT := 0;

    preLane   : INT := 0;
    postLane  : INT := 0;

    seqPreGen  : INT := 0;
    seqPostGen : INT := 0;

    curPreId  : INT := 0;
    curPostId : INT := 0;

    tare      : ARRAY[1..8] OF INT;
    tareValid : ARRAY[1..8] OF BOOL;

    netMass   : INT := 0;
    routeSel  : INT := 0;

    dispatchCount : INT := 0;

    completeCond    : BOOL := FALSE;
    completeLatched : BOOL := FALSE;
    completeTimer   : TON;
END_VAR

(* -------- default outputs each scan (level actuators reset, will be
   re-asserted below where their state remains active) -------- *)
Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y17 := FALSE;
Y18 := FALSE;

(* ============================================================
   PRE (inbound) SIDE STATE MACHINE
   ============================================================ *)
CASE preState OF

0: (* idle - wait for source ready and empty scale *)
    IF X10 AND (NOT X11) THEN
        preState := 1;
    END_IF;

1: (* feed the lead onto the empty inbound scale *)
    Y10 := TRUE;
    IF X11 THEN
        preState := 2;
    END_IF;

2: (* raise support - measurement only possible when supported *)
    Y17 := TRUE;
    IF X1E THEN
        preState := 3;
    END_IF;

3: (* request measurement only if scale not busy *)
    Y17 := TRUE;
    IF NOT X12 THEN
        seqPreGen := seqPreGen + 1;
        D202 := seqPreGen;
        Y11 := TRUE;
        curPreId := D0;
        preState := 4;
    END_IF;

4: (* wait for matching response (check seq, ignore stale) *)
    Y17 := TRUE;
    IF D4 = seqPreGen THEN
        IF (curPreId >= 1) AND (curPreId <= 8) THEN
            tare[curPreId] := D2;
            tareValid[curPreId] := TRUE;
        END_IF;
        preState := 5;
    END_IF;

5: (* lower support - forbidden while measuring *)
    IF NOT X15 THEN
        Y17 := FALSE;
        IF X1F THEN
            preState := 6;
        END_IF;
    ELSE
        Y17 := TRUE;
    END_IF;

6: (* pick a free lane *)
    IF X17 THEN
        preLane := 1;
        preState := 7;
    ELSIF X19 THEN
        preLane := 2;
        preState := 7;
    END_IF;

7: (* transfer to chosen lane - only after support lowered, not measuring *)
    IF (NOT X15) THEN
        D200 := preLane;
        Y12 := TRUE;
        preState := 8;
    END_IF;

8: (* wait for the tray to actually leave the inbound scale *)
    IF NOT X11 THEN
        preState := 0;
    END_IF;

ELSE
    preState := 0;
END_CASE;

(* ============================================================
   POST (finished) SIDE STATE MACHINE
   ============================================================ *)
CASE postState OF

0: (* idle - wait for a finished workstation, scale must be empty *)
    IF X18 AND (NOT X13) THEN
        postLane := 1;
        postState := 1;
    ELSIF X1A AND (NOT X13) THEN
        postLane := 2;
        postState := 1;
    END_IF;

1: (* command transfer of the completed kit to the shared post scale *)
    D201 := postLane;
    Y13 := TRUE;
    postState := 2;

2: (* wait for actual arrival *)
    IF X13 THEN
        curPostId := D1;
        postState := 3;
    END_IF;

3: (* raise support - measurement only possible when supported *)
    Y18 := TRUE;
    IF X20 THEN
        postState := 4;
    END_IF;

4: (* request measurement only if scale not busy *)
    Y18 := TRUE;
    IF NOT X14 THEN
        seqPostGen := seqPostGen + 1;
        D203 := seqPostGen;
        Y14 := TRUE;
        postState := 5;
    END_IF;

5: (* wait for matching response, compute route from same-tray tare *)
    Y18 := TRUE;
    IF D5 = seqPostGen THEN
        IF (curPostId >= 1) AND (curPostId <= 8) AND tareValid[curPostId] THEN
            netMass := D3 - tare[curPostId];
            IF (netMass >= 95) AND (netMass <= 105) THEN
                routeSel := 1;
            ELSE
                routeSel := 2;
            END_IF;
        ELSE
            (* no valid actual tare for this tray - never export as accepted *)
            routeSel := 2;
        END_IF;
        postState := 6;
    END_IF;

6: (* lower support - forbidden while measuring *)
    IF NOT X16 THEN
        Y18 := FALSE;
        IF X21 THEN
            postState := 7;
        END_IF;
    ELSE
        Y18 := TRUE;
    END_IF;

7: (* wait until the target exit accumulation actually has room *)
    IF (routeSel = 1) AND X1B THEN
        postState := 8;
    ELSIF (routeSel = 2) AND X1C THEN
        postState := 8;
    END_IF;

8: (* dispatch to the matched exit - only after actual measurement, not measuring *)
    IF (NOT X16) THEN
        D204 := routeSel;
        Y15 := TRUE;
        postState := 9;
    END_IF;

9: (* wait for the tray to actually leave the post scale before clearing *)
    IF NOT X13 THEN
        dispatchCount := dispatchCount + 1;
        IF (curPostId >= 1) AND (curPostId <= 8) THEN
            tareValid[curPostId] := FALSE;
        END_IF;
        postState := 0;
    END_IF;

ELSE
    postState := 0;
END_CASE;

(* ============================================================
   COMPLETION LOGIC
   ============================================================ *)
completeCond := (dispatchCount >= 4) AND (NOT X11) AND (NOT X13)
                 AND X17 AND X19
                 AND (preState = 0) AND (postState = 0);

completeTimer(IN := completeCond AND (NOT completeLatched), PT := T#500ms);

IF completeTimer.Q THEN
    completeLatched := TRUE;
END_IF;

Y16 := completeLatched;

END_PROGRAM