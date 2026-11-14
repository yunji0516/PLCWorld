PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL;
    Y2 : BOOL;

    (* Internal variables *)
    pos_captured   : BOOL := FALSE;
    initial_pos    : DINT := 0;
    req_accepted   : BOOL := FALSE;
    cond_ok        : BOOL := FALSE;
    y2_latched     : BOOL := FALSE;
    pos_tol        : DINT := 20; (* 0.2 mm * 100 raw units *)

    cond_timer     : TON;
    hold_timer     : TON;
END_VAR

(* Capture the initial height on the very first scan, before any brake action *)
IF NOT pos_captured THEN
    initial_pos := D11;
    pos_captured := TRUE;
END_IF;

(* Latch request acceptance: never publish/activate the function before X10 is accepted *)
IF X10 THEN
    req_accepted := TRUE;
END_IF;

(* Engage the brake once the request has been accepted; retain it thereafter *)
IF req_accepted THEN
    Y20 := TRUE;
ELSE
    Y20 := FALSE;
END_IF;

(* Evaluate the maintained condition: brake actually engaged, external support released,
   and height held within +/-0.2 mm of the initial value *)
cond_ok := X11 AND (NOT X12) AND (ABS(D11 - initial_pos) <= pos_tol);

(* Require the condition to hold continuously for 30 ms before claiming success *)
cond_timer(IN := cond_ok, PT := T#30ms);

IF cond_timer.Q THEN
    y2_latched := TRUE;
END_IF;

(* Once claimed, run the 100 ms post-claim retention observation window *)
hold_timer(IN := y2_latched, PT := T#100ms);

(* Publish Y2 as the retained function result *)
Y2 := y2_latched;

END_PROGRAM