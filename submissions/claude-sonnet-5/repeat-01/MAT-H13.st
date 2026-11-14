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

    (* internal state machines *)
    mainState   : INT := 0;
    liftState   : INT := 0;
    wrapSub     : INT := 0;
    bundlesDone : INT := 0;

    started         : BOOL := FALSE;
    chuck_occupied  : BOOL := FALSE;
    wrapDone        : BOOL := FALSE;

    swapping            : BOOL := FALSE;
    swapPulseDone       : BOOL := FALSE;
    tapePrepDone        : BOOL := FALSE;
    tapePrepPulseDone   : BOOL := FALSE;
    swapNeededCalc      : BOOL := FALSE;

    idxCond      : BOOL := FALSE;
    completeCond : BOOL := FALSE;

    startEdge : R_TRIG;
    idxEdge   : R_TRIG;

    swap_tmr     : TON;
    tape_tmr     : TON;
    cut_tmr      : TON;
    completeTmr  : TON;
END_VAR

(* ---------- start latch ---------- *)
startEdge(CLK := X0);
IF startEdge.Q THEN
    started := TRUE;
END_IF;

(* ---------- forming entrance feed / align / index ---------- *)
Y1D := X25;
Y1C := X25 AND X28 AND NOT X27;
Y1F := (D9 >= D10) AND (liftState = 0);

idxCond := (NOT X28) AND (D9 < D10) AND (NOT Y1F) AND (NOT X27) AND (NOT X15);
idxEdge(CLK := idxCond);
Y1E := idxEdge.Q;

(* ---------- source belt advance guard against source_under_head ---------- *)
Y23 := (liftState = 5) AND X32 AND X2C AND (mainState <> 1) AND (mainState <> 2);

(* ---------- forming gripper : lift / transfer to fixed supply ---------- *)
CASE liftState OF
0:
    IF X29 AND (D9 = D10) THEN
        Y20 := TRUE;
        liftState := 1;
    END_IF;

1:
    IF X2A THEN
        liftState := 2;
    END_IF;

2:
    Y21 := TRUE;
    IF X2C THEN
        liftState := 3;
    END_IF;

3:
    IF X30 THEN
        Y22 := TRUE;
    END_IF;
    IF X2F THEN
        liftState := 4;
    END_IF;

4:
    Y20 := FALSE;
    IF X2B THEN
        liftState := 5;
    END_IF;

5:
    IF X10 THEN
        liftState := 6;
    END_IF;

6:
    Y22 := FALSE;
    IF X2E THEN
        liftState := 7;
    END_IF;

7:
    Y21 := FALSE;
    IF X2D THEN
        liftState := 0;
    END_IF;

ELSE
    liftState := 0;
END_CASE;

(* ---------- transfer gripper / chuck / exit sequence ---------- *)
CASE mainState OF
0:
    IF started THEN
        Y13 := TRUE;
    END_IF;
    IF X33 THEN
        mainState := 1;
    END_IF;

1:
    IF X10 THEN
        Y24 := TRUE;
    END_IF;
    IF X12 THEN
        mainState := 2;
    END_IF;

2:
    IF X11 THEN
        Y10 := TRUE;
    END_IF;
    IF X16 THEN
        mainState := 3;
    END_IF;

3:
    Y24 := FALSE;
    Y13 := FALSE;
    IF NOT X12 THEN
        mainState := 4;
    END_IF;

4:
    IF (NOT chuck_occupied) AND X18 AND (D1 <> 0) THEN
        Y14 := TRUE;
    END_IF;
    IF X13 AND X16 AND (D1 <> 0) THEN
        mainState := 5;
    END_IF;

5:
    IF X11 THEN
        Y11 := TRUE;
    END_IF;
    IF X19 THEN
        mainState := 6;
    END_IF;

6:
    Y10 := FALSE;
    Y12 := TRUE;
    Y14 := FALSE;
    chuck_occupied := TRUE;
    IF X17 THEN
        mainState := 7;
    END_IF;

7:
    IF wrapDone THEN
        mainState := 8;
    END_IF;

8:
    IF X18 THEN
        Y14 := TRUE;
    END_IF;
    IF X13 THEN
        Y10 := TRUE;
    END_IF;
    IF X16 THEN
        mainState := 9;
    END_IF;

9:
    Y11 := FALSE;
    Y12 := FALSE;
    IF (NOT X19) AND X1A THEN
        mainState := 10;
    END_IF;

10:
    IF X22 AND X23 AND (NOT X19) AND X1A THEN
        Y15 := TRUE;
    END_IF;
    IF X14 THEN
        mainState := 11;
    END_IF;

11:
    Y10 := FALSE;
    Y14 := FALSE;
    IF X17 THEN
        Y15 := FALSE;
        chuck_occupied := FALSE;
        bundlesDone := bundlesDone + 1;
        wrapDone := FALSE;
        wrapSub := 0;
        mainState := 12;
    END_IF;

12:
    IF bundlesDone < 3 THEN
        mainState := 0;
    ELSE
        mainState := 13;
    END_IF;

13:
    ; (* all bundles delivered - idle *)

ELSE
    mainState := 0;
END_CASE;

(* ---------- wrap / swap / tape / cut sequence ---------- *)
CASE wrapSub OF
0:
    swapping := FALSE;
    swapPulseDone := FALSE;
    tapePrepDone := FALSE;
    tapePrepPulseDone := FALSE;
    IF X19 AND Y12 AND X18 AND X1C THEN
        Y16 := TRUE;
        wrapSub := 1;
    END_IF;

1:
    IF D4 >= D3 THEN
        Y16 := FALSE;
        wrapSub := 2;
    END_IF;

2:
    swapNeededCalc := (NOT X1C) AND X1E AND X19 AND Y12 AND X18 AND (NOT Y16);
    IF NOT swapping THEN
        IF swapNeededCalc THEN
            swapping := TRUE;
        ELSE
            wrapSub := 3;
        END_IF;
    END_IF;
    IF swapping THEN
        IF NOT swapPulseDone THEN
            Y17 := TRUE;
            swapPulseDone := TRUE;
        ELSE
            Y17 := FALSE;
        END_IF;
        swap_tmr(IN := TRUE, PT := T#7s);
        IF swap_tmr.Q THEN
            swapping := FALSE;
            swap_tmr(IN := FALSE, PT := T#7s);
            wrapSub := 3;
        END_IF;
    END_IF;

3:
    IF NOT tapePrepDone THEN
        D200 := D6;
        IF NOT tapePrepPulseDone THEN
            Y18 := TRUE;
            tapePrepPulseDone := TRUE;
        ELSE
            Y18 := FALSE;
        END_IF;
        tape_tmr(IN := TRUE, PT := T#14s);
        IF X20 OR tape_tmr.Q THEN
            tapePrepDone := TRUE;
            tape_tmr(IN := FALSE, PT := T#14s);
            wrapSub := 4;
        END_IF;
    END_IF;

4:
    IF (D5 = D0) AND (D4 >= D3) AND X19 THEN
        Y19 := TRUE;
        IF X21 THEN
            Y19 := FALSE;
            wrapSub := 5;
        END_IF;
    END_IF;

5:
    IF X19 AND Y12 AND (D4 >= D3) AND X21 THEN
        Y1A := TRUE;
        cut_tmr(IN := TRUE, PT := T#800ms);
        IF X22 THEN
            Y1A := FALSE;
            cut_tmr(IN := FALSE, PT := T#800ms);
            wrapSub := 6;
        END_IF;
    END_IF;

6:
    wrapDone := TRUE;

ELSE
    wrapSub := 0;
END_CASE;

(* ---------- completion latch ---------- *)
completeCond := (bundlesDone >= 3) AND (mainState = 13) AND (liftState = 0) AND
    (NOT Y10) AND (NOT Y11) AND (NOT Y12) AND (NOT Y13) AND (NOT Y14) AND
    (NOT Y15) AND (NOT Y16) AND (NOT Y17) AND (NOT Y18) AND (NOT Y19) AND
    (NOT Y20) AND (NOT Y21) AND (NOT Y22) AND (NOT Y23) AND (NOT Y24) AND
    (NOT Y1A) AND (NOT Y1C) AND (NOT Y1D) AND (NOT Y1E) AND (NOT Y1F) AND
    X22 AND X21 AND X17 AND X23;

completeTmr(IN := completeCond, PT := T#500ms);
IF completeTmr.Q THEN
    Y1B := TRUE;
END_IF;

END_PROGRAM