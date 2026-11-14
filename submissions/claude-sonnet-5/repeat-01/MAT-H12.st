PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;

    (* Internal state *)
    a_awaiting_eject : BOOL := FALSE;
    b_awaiting_eject : BOOL := FALSE;

    a_done_trig : R_TRIG;
    b_done_trig : R_TRIG;
    a_start_trig : R_TRIG;
    b_start_trig : R_TRIG;
    a_eject_trig : R_TRIG;
    b_eject_trig : R_TRIG;
    swap_trig : R_TRIG;

    startA_cond : BOOL;
    startB_cond : BOOL;
    ejectA_cond : BOOL;
    ejectB_cond : BOOL;
    swap_cond : BOOL;

    take_requested : BOOL := FALSE;

    total_good_trays : INT := 0;
    residual_captured_before_swap : INT := 0;
    retrieval_pending : BOOL := FALSE;
    prev_bin_retrieved : BOOL := TRUE;
    prev_return_busy : BOOL := FALSE;

    completion_conditions : BOOL;
    completion_timer : TON;
    complete_latched : BOOL := FALSE;

    cap_limit : INT;
END_VAR

(* -------------------------------------------------------------- *)
(* Capacity limit to use (falls back to 6 if capacity input is 0) *)
IF D3 > 0 THEN
    cap_limit := D3;
ELSE
    cap_limit := 6;
END_IF;

(* -------------------------------------------------------------- *)
(* Detect press-local completion (done) -> mark awaiting eject    *)
a_done_trig(CLK := X1A);
IF a_done_trig.Q THEN
    a_awaiting_eject := TRUE;
END_IF;

b_done_trig(CLK := X20);
IF b_done_trig.Q THEN
    b_awaiting_eject := TRUE;
END_IF;

(* -------------------------------------------------------------- *)
(* Eject completed goods to exit only when exit is clear          *)
ejectA_cond := a_awaiting_eject AND X1B;
a_eject_trig(CLK := ejectA_cond);
Y15 := a_eject_trig.Q;
IF a_eject_trig.Q THEN
    a_awaiting_eject := FALSE;
    total_good_trays := total_good_trays + 1;
END_IF;

ejectB_cond := b_awaiting_eject AND X21;
b_eject_trig(CLK := ejectB_cond);
Y18 := b_eject_trig.Q;
IF b_eject_trig.Q THEN
    b_awaiting_eject := FALSE;
    total_good_trays := total_good_trays + 1;
END_IF;

(* -------------------------------------------------------------- *)
(* Feed prepared lead into an empty, idle press (level output)    *)
Y13 := X0 AND X16 AND (NOT X17) AND (NOT X19) AND (NOT a_awaiting_eject);
Y16 := X0 AND X1C AND (NOT X1D) AND (NOT X1F) AND (NOT b_awaiting_eject);

(* -------------------------------------------------------------- *)
(* Irreversible batch acceptance: only when press empty/idle,     *)
(* not awaiting discharge, docked bin ready, and capacity fits.   *)
startA_cond := X0 AND X17 AND (NOT X19) AND (NOT X18) AND (NOT a_awaiting_eject)
               AND X10 AND ((D0 + D1 + D6) <= cap_limit);
a_start_trig(CLK := startA_cond);
Y14 := a_start_trig.Q;

startB_cond := X0 AND X1D AND (NOT X1F) AND (NOT X1E) AND (NOT b_awaiting_eject)
               AND X10 AND ((D0 + D1 + D8) <= cap_limit);
b_start_trig(CLK := startB_cond);
Y17 := b_start_trig.Q;

(* -------------------------------------------------------------- *)
(* Bin exchange: only when pending=0, residuals docked, spare      *)
(* available, retrieval spot vacant, and not already swapping.     *)
swap_cond := (D1 = 0) AND (D4 > 0) AND X12 AND (NOT X13) AND (NOT X14) AND (NOT X11);
swap_trig(CLK := swap_cond);
Y10 := swap_trig.Q;
IF swap_trig.Q THEN
    residual_captured_before_swap := residual_captured_before_swap + D4;
    retrieval_pending := TRUE;
    prev_bin_retrieved := FALSE;
END_IF;

(* -------------------------------------------------------------- *)
(* Request external acceptance of the bin waiting at retrieval    *)
IF X13 AND (NOT take_requested) THEN
    Y11 := TRUE;
    take_requested := TRUE;
ELSE
    Y11 := FALSE;
END_IF;
IF NOT X13 THEN
    take_requested := FALSE;
END_IF;

(* -------------------------------------------------------------- *)
(* Detect completion of external retrieval (return_busy falling)  *)
IF prev_return_busy AND (NOT X14) THEN
    IF retrieval_pending THEN
        prev_bin_retrieved := TRUE;
        retrieval_pending := FALSE;
    END_IF;
END_IF;
prev_return_busy := X14;

(* -------------------------------------------------------------- *)
(* Completion evaluation: 3 good trays, no pending residuals,     *)
(* all 8 residuals conserved across both bins, previous bin        *)
(* docking and external retrieval complete. Must hold >= 0.5 s.   *)
completion_conditions := (total_good_trays = 3)
                          AND (D1 = 0)
                          AND prev_bin_retrieved
                          AND ((residual_captured_before_swap + D4) = 8);

completion_timer(IN := completion_conditions, PT := T#500ms);
IF completion_timer.Q THEN
    complete_latched := TRUE;
END_IF;

Y12 := complete_latched;

END_PROGRAM