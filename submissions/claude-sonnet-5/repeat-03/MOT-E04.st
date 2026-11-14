PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* internal *)
    error       : DINT;
    cond1       : BOOL;   (* enabled and within tolerance *)
    cond2       : BOOL;   (* stable_ok and still within tolerance *)
    stable_ok   : BOOL;
    stab_timer  : TON;
    hold_timer  : TON;
    tol         : DINT := 200;   (* 2 deg/s * 100 scale *)
    cmd_max     : DINT := 200000;
    cmd_min     : DINT := -200000;
END_VAR

(* Enable drive only after request is accepted (X10 TRUE) *)
Y20 := X10;

(* Command pass-through with clamping to permitted raw command bounds.
   When not requested, command drops to zero so the shaft decelerates. *)
IF X10 THEN
    IF D10 > cmd_max THEN
        D20 := cmd_max;
    ELSIF D10 < cmd_min THEN
        D20 := cmd_min;
    ELSE
        D20 := D10;
    END_IF;
ELSE
    D20 := 0;
END_IF;

(* Compute actual speed error against the requested speed *)
error := D12 - D10;
IF error < 0 THEN
    error := -error;
END_IF;

(* Condition: drive active and speed within tolerance *)
cond1 := X10 AND (error <= tol);

(* First phase: require 30 ms of continuous stability *)
stab_timer(IN := cond1, PT := T#30ms);
IF stab_timer.Q THEN
    stable_ok := TRUE;
END_IF;

(* Second phase: once stabilized, require continued stability for the
   250 ms completion-observation window before declaring completion *)
cond2 := stable_ok AND cond1;
hold_timer(IN := cond2, PT := T#250ms);

IF hold_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM