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
    (* Internal Variables *)
    formIndexTimer : TON;
    tapePreparationTimer : TON;
    reelSwapTimer : TON;
    tapeApplyTimer : TON;
    formedBundles : INT := 0;
    transferStep : INT := 0;
    wrapping : BOOL := FALSE;
    tapeOrderReady : BOOL := FALSE;
    swapReel : BOOL := FALSE;
    atSourcePosition : BOOL := TRUE;
END_VAR

(* Control Logic *)

(* Forming Logic *)
IF X25 AND NOT X26 THEN
    Y1D := TRUE; (* Close form stop plate *)
    Y1C := TRUE; (* Signal unit feed ready *)
ELSIF X26 THEN
    Y1D := FALSE; (* Open form stop plate once indexed *)
END_IF;

IF X25 AND X28 THEN
    Y1C := FALSE; (* Stop unit feed if entrance is filled *)
END_IF;

(* Grip at Source *)
IF X10 THEN
    Y10 := TRUE; (* Engage grip *)
ELSE
    Y10 := FALSE;
END_IF;

(* Wrapping Logic *)
IF X19 AND X1B AND X18 THEN
    wrapping := TRUE;
    Y16 := TRUE; (* Start wrapping *)
ELSIF (D4 <= 0 OR NOT X1C OR swapReel) THEN
    wrapping := FALSE;
    Y16 := FALSE; (* Stop wrapping when film out/ready for swap *)
END_IF;

(* Prepare Tape Logic *)
IF X20 AND X21 THEN
    Y18 := TRUE; (* Prepare tape if ready and not applied *)
    tapePreparationTimer(IN := TRUE, PT := T#14s);
ELSE
    Y18 := FALSE;
    tapePreparationTimer(IN := FALSE);
END_IF;

(* Apply Tape Logic *)
IF X5 = D0 AND (D3 * D4 + tapeApplyTimer.Q) THEN
    Y19 := TRUE; (* Apply tape *)
    tapeApplyTimer(IN := TRUE, PT := T#2s);
ELSE
    Y19 := FALSE;
    tapeApplyTimer(IN := FALSE);
END_IF;

(* Transfer Logic *)
CASE transferStep OF
0:
    IF X12 THEN
        Y13 := TRUE; (* Move to wrap when at source *)
        atSourcePosition := FALSE;
        transferStep := 1;
    END_IF;
1:
    IF X13 THEN
        IF X1A AND X22 AND X23 THEN
            Y13 := FALSE;
            Y14 := FALSE;
            Y11 := TRUE; (* Clamp at wrap position *)
            transferStep := 2;
        END_IF;
    END_IF;
2:
    IF X19 THEN
        Y10 := FALSE; (* Release grip *)
        transferStep := 3;
        Y14 := TRUE; (* Move to exit when transfer is complete *)
    END_IF;
3:
    IF X14 THEN
        Y15 := FALSE;
        IF X23 THEN
            Y10 := FALSE; (* Release at exit *)
            atSourcePosition := TRUE;
            transferStep := 0;
        END_IF;
    END_IF;
END_CASE;

(* Reel Swap Logic *)
IF swapReel THEN
    reelSwapTimer(IN := TRUE, PT := T#7s);
    IF reelSwapTimer.Q THEN
        swapReel := FALSE; (* Reset swap *)
        Y17 := FALSE; 
    END_IF; 
ELSE
    IF NOT wrapping AND X1E AND NOT X1C THEN
        swapReel := TRUE;
        Y17 := TRUE; (* Swap the reel and prepare leading edge *)
    END_IF;
    reelSwapTimer(IN := FALSE);
END_IF;

(* Maintain Conditions *)
IF NOT wrapping THEN
    Y1B := TRUE; (* Declare complete when not wrapping *)
ELSE
    Y1B := FALSE;
END_IF;

END_PROGRAM