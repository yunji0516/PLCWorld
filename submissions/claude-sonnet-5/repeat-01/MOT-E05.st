PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    D14 : DINT;
    X12 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* Internal variables *)
    x10_trig     : R_TRIG;
    armed        : BOOL := FALSE;
    captured     : BOOL := FALSE;
    capture_timer: TON;
    observe_timer: TON;
    done         : BOOL := FALSE;
END_VAR

(* Detect acceptance of the external request *)
x10_trig(CLK := X10);

(* On accepted request, raise Y20 to arm the hardware capture.
   This is only ever done after X10 has been accepted. *)
IF x10_trig.Q THEN
    Y20   := TRUE;
    armed := TRUE;
END_IF;

(* Capture the value exactly once, only after arming, and only
   from a fresh (valid) detection - never re-write afterward. *)
IF armed AND (NOT captured) AND X11 THEN
    D20      := D14;   (* record raw capture value directly, no rescaling *)
    captured := TRUE;
    Y21      := TRUE;  (* confirm capture result *)
END_IF;

(* Keep the recorded command word within permitted raw bounds on every scan *)
IF D20 > 200000 THEN
    D20 := 200000;
ELSIF D20 < -200000 THEN
    D20 := -200000;
END_IF;

(* Stability timer: 30 ms of maintained result before asserting Y2 *)
capture_timer(IN := captured, PT := T#30ms);
IF capture_timer.Q THEN
    Y2 := TRUE;
END_IF;

(* Observation timer: 100 ms hold observation completes execution *)
observe_timer(IN := captured, PT := T#100ms);
IF observe_timer.Q THEN
    done := TRUE;
END_IF;

END_PROGRAM