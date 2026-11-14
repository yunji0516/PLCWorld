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

    (* Internal state *)
    request_active : BOOL := FALSE;
    y20_armed      : BOOL := FALSE;
    captured       : BOOL := FALSE;

    capture_edge   : R_TRIG;
    hold_timer     : TON;
    obs_timer      : TON;
END_VAR

(* --- Request acceptance : only after X10 is asserted --- *)
IF X10 THEN
    request_active := TRUE;
END_IF;

(* --- Arm hardware capture once, only after request acceptance --- *)
IF request_active AND NOT y20_armed THEN
    Y20 := TRUE;        (* rising edge of Y20 arms the hardware capture *)
    y20_armed := TRUE;
END_IF;

(* --- Edge detect the validity flag for this arm --- *)
capture_edge(CLK := X11);

(* --- Capture the value exactly once, only for a NEW edge after arming --- *)
IF y20_armed AND (NOT captured) AND capture_edge.Q THEN
    D20 := LIMIT(-200000, D14, 200000);  (* keep within permitted raw command bounds *)
    Y21 := TRUE;
    captured := TRUE;
END_IF;

(* --- Hold / observation timing after a valid capture --- *)
hold_timer(IN := captured, PT := T#30ms);
obs_timer(IN := captured, PT := T#100ms);

IF hold_timer.Q THEN
    Y2 := TRUE;
END_IF;

(* D20 and Y21 remain unchanged once captured, satisfying the
   "no stale/late capture" and result-maintenance requirements. *)

END_PROGRAM