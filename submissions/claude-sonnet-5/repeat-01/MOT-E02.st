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
    request_latched : BOOL := FALSE;   (* remembers X10 acceptance *)
    home_done       : BOOL := FALSE;   (* latches once Home complete (X13) observed *)
    completion_condition : BOOL := FALSE;
    speed_tol_raw   : DINT := 100;     (* 1 mm/s arrival speed tolerance, x0.01 units *)

    stableTimer : TON;
END_VAR

(* -------- 1. Latch the work request -------- *)
IF X10 THEN
    request_latched := TRUE;
END_IF;

(* -------- 2. Latch Home completion once observed -------- *)
IF X13 THEN
    home_done := TRUE;
END_IF;

(* -------- 3. Drive Y21 (Home execution/retention) --------
   Activate only after request acceptance, hold Home until
   Home complete (X13) is latched, then deactivate. If X10 was
   never accepted, Y21 stays off. *)
IF request_latched AND (NOT home_done) THEN
    Y21 := TRUE;
ELSE
    Y21 := FALSE;
END_IF;

(* -------- 4. Evaluate actual completion condition --------
   Reference valid, Home deactivated, and actual stop
   (speed within arrival speed tolerance). *)
completion_condition := X11 AND (NOT Y21) AND (ABS(D12) <= speed_tol_raw);

(* -------- 5. Stability timer: 30 ms continuous hold -------- *)
stableTimer(IN := completion_condition, PT := T#30ms);

IF stableTimer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM