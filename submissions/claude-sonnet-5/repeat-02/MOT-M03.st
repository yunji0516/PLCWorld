PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;

    (* Internal state *)
    requestActive : BOOL := FALSE;
    aligned       : BOOL := FALSE;
    completionLatch : BOOL := FALSE;

    posTolCounts   : DINT := 20;   (* 0.20 mm * 100 counts/mm *)
    speedTolCounts : DINT := 100;  (* 1 mm/s * 100 counts/(mm/s) *)

    insertTimer : TON;
END_VAR

(* ---- Latch the request (sticky, survives transient pulses) ---- *)
IF X10 THEN
    requestActive := TRUE;
END_IF;

(* ---- Movement reference following ---- *)
Y20 := requestActive;

IF requestActive THEN
    (* Feed the S drive with the current measured leader (U) position/speed
       so that S tracks U's linear motion within this scan. *)
    D20 := D13;
    D21 := D14;
ELSE
    (* Keep S commanded at its own current actual position with zero
       feedforward speed so it stays put until a request arrives. *)
    D20 := D11;
    D21 := 0;
END_IF;

(* ---- Alignment check: relative position and speed within tolerance ---- *)
aligned := (ABS(D11 - D13) <= posTolCounts) AND (ABS(D12 - D14) <= speedTolCounts);

(* ---- Fork insertion command: extend once synchronized, and retain ---- *)
IF requestActive AND aligned THEN
    Y21 := TRUE;
END_IF;

(* Once inserted/latched, keep the fork inserted (retention) *)
IF Y21 THEN
    Y21 := TRUE;
END_IF;

(* ---- Completion: alignment maintained AND fork actually inserted,
        continuously for 100 ms, then latch and retain Y2 ---- *)
insertTimer(IN := (aligned AND X11 AND Y21), PT := T#100ms);

IF insertTimer.Q THEN
    completionLatch := TRUE;
END_IF;

Y2 := completionLatch;

END_PROGRAM