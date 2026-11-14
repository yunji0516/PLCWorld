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
    request_accepted : BOOL;
    captured : BOOL;
    capTimer : TON;
END_VAR

(* Latch acceptance of the function request once X10 is seen true. *)
IF X10 THEN
    request_accepted := TRUE;
END_IF;

(* Only after request acceptance may the local function (Y20) be activated.
   Y20 starts FALSE and this transition to TRUE forms the required rising edge
   that arms the hardware capture. Retained thereafter. *)
IF request_accepted THEN
    Y20 := TRUE;
END_IF;

(* Capture exactly once: only take the first valid detection after arming.
   Any later X11 pulses (past/stale captures) are ignored to avoid failure. *)
IF request_accepted AND Y20 AND NOT captured AND X11 THEN
    D20 := LIMIT(-200000, D14, 200000);
    Y21 := TRUE;
    captured := TRUE;
END_IF;

(* Observation/hold timing starts once the result has been captured/latched. *)
capTimer(IN := captured, PT := T#100ms);

(* After the actual result has been maintained (stable/latched) for 30 ms,
   raise Y2 and keep it retained. *)
IF captured AND capTimer.ET >= T#30ms THEN
    Y2 := TRUE;
END_IF;

(* Keep the command word within the stated raw bounds on every scan. *)
D20 := LIMIT(-200000, D20, 200000);

END_PROGRAM