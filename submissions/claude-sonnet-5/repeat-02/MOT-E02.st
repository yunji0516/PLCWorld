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

    (* Internal memory *)
    requested   : BOOL := FALSE;   (* latched X10 acceptance *)
    stableCond  : BOOL := FALSE;   (* reference valid, home deactivated, actual stop *)
    stableTimer : TON;
    completed   : BOOL := FALSE;   (* latched completion, drives Y2 permanently *)
    speedTolRaw : DINT := 100;     (* 1 mm/s * 100 (D12 is x0.01 units) *)
END_VAR

(* Latch the work request so Home retention persists across scans *)
IF X10 THEN
    requested := TRUE;
END_IF;

(* Do not activate Home before request acceptance. Once accepted,
   keep Y21 asserted continuously: releasing it interrupts the search. *)
Y21 := requested;

(* Determine the physical completion condition:
   new reference set (X11), Home in-progress deactivated (NOT X12),
   and actual stop (speed within published arrival tolerance). *)
stableCond := X11 AND (NOT X12) AND (D12 <= speedTolRaw) AND (D12 >= -speedTolRaw);

(* Require the completion condition to hold stably for 30 ms *)
stableTimer(IN := stableCond, PT := T#30ms);

IF stableTimer.Q THEN
    completed := TRUE;
END_IF;

(* Once completion is claimed, maintain Y2 TRUE permanently
   (post-claim maintenance requirement). *)
IF completed THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM