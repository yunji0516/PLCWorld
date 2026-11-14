PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    accepted : BOOL;
    initial_pos : DINT;
    pos_error : DINT;
    stable_condition : BOOL;
    stable_timer : TON;
END_VAR

(* Implement the control logic here. *)

IF (NOT accepted) AND X10 THEN
    accepted := TRUE;
    initial_pos := D11;
END_IF;

IF accepted THEN
    Y20 := TRUE;
ELSE
    Y20 := FALSE;
END_IF;

pos_error := D11 - initial_pos;
IF pos_error < 0 THEN
    pos_error := -pos_error;
END_IF;

stable_condition := accepted AND Y20 AND X11 AND (NOT X12) AND (pos_error <= 20);

stable_timer(IN := stable_condition, PT := T#30ms);

IF stable_timer.Q THEN
    Y2 := TRUE;
END_IF;

IF NOT accepted THEN
    Y2 := FALSE;
END_IF;

END_PROGRAM