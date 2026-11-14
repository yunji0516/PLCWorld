PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;

    (* Internal state *)
    requested   : BOOL := FALSE;   (* remembers X10 request *)
    homeDone    : BOOL := FALSE;   (* latched once actual stop/home condition detected *)
    speedTolRaw : DINT := 100;     (* arrival speed tolerance 1 mm/s * 100 raw units *)
    rawStopCond : BOOL;
    actualCompleteCond : BOOL;

    stableTimer : TON;
END_VAR

(* Latch the work request; do not activate Y21 before this is accepted *)
IF X10 THEN
    requested := TRUE;
END_IF;

(* Detect the underlying physical stop / reference-set condition
   while Y21 is still asserted (drive reports X13 & X11 & near-zero speed) *)
rawStopCond := X13 AND X11 AND (ABS(D12) <= speedTolRaw);

IF (NOT homeDone) AND rawStopCond THEN
    homeDone := TRUE;
END_IF;

(* Drive Y21: active only while requested and not yet completed;
   turns OFF as part of the completion sequence once homeDone latches *)
Y21 := requested AND (NOT homeDone);

(* Actual completion condition: new reference valid, Home deactivated,
   and actual stop maintained *)
actualCompleteCond := homeDone AND (NOT Y21) AND X11 AND (ABS(D12) <= speedTolRaw);

(* Require the actual completion condition to be maintained for 30 ms *)
stableTimer(IN := actualCompleteCond, PT := T#30ms);

IF stableTimer.Q THEN
    Y2 := TRUE;
END_IF;

(* Once asserted, Y2 (result retention) is held TRUE for post-claim maintenance *)

END_PROGRAM