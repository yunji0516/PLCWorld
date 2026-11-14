PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* Internal state *)
    accepted   : BOOL := FALSE;   (* X10 request accepted/latched *)
    detected   : BOOL := FALSE;   (* obstacle detection latched *)
    openPos    : DINT := 0;       (* clamped requested open target, raw units *)
    posOk      : BOOL := FALSE;
    spdOk      : BOOL := FALSE;
    condOk     : BOOL := FALSE;
    holdTmr    : TON;             (* 30 ms continuous validity before first Y2 assert *)
    obsTmr     : TON;             (* 100 ms post-claim observation *)
    y2Set      : BOOL := FALSE;   (* latched: Y2 has been asserted *)
    cmdMax     : DINT := 200000;
    cmdMin     : DINT := -200000;
    posTol     : DINT := 20;      (* 0.2 mm in raw (x0.01) units *)
    spdTol     : DINT := 100;     (* 1 mm/s in raw (x0.01) units *)
END_VAR

(* Latch request acceptance *)
IF X10 THEN
    accepted := TRUE;
END_IF;

(* Latch obstacle detection *)
IF X11 THEN
    detected := TRUE;
END_IF;

(* Activation and command logic: only after request accepted AND detection observed *)
IF accepted AND detected THEN
    Y20 := TRUE;

    openPos := D10;
    IF openPos > cmdMax THEN
        openPos := cmdMax;
    ELSIF openPos < cmdMin THEN
        openPos := cmdMin;
    END_IF;

    D20 := openPos;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

(* Evaluate continuous validity of the open-result condition *)
IF accepted AND detected THEN
    posOk := ABS(D11 - D10) <= posTol;
    spdOk := ABS(D12) <= spdTol;
    condOk := posOk AND spdOk;
ELSE
    condOk := FALSE;
END_IF;

(* 30 ms continuous stability timer before first Y2 assertion *)
holdTmr(IN := condOk, PT := T#30ms);

IF holdTmr.Q THEN
    y2Set := TRUE;
END_IF;

(* Y2 output: once asserted, keep it TRUE (latched) *)
IF y2Set THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

(* 100 ms post-claim observation timer, started once Y2 first asserted *)
obsTmr(IN := y2Set, PT := T#100ms);

END_PROGRAM