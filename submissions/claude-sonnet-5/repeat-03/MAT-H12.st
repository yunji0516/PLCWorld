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

    (* Internal variables *)
    running : BOOL := FALSE;
    run_trig : R_TRIG;

    a_await_discharge : BOOL := FALSE;
    b_await_discharge : BOOL := FALSE;
    a_done_trig : R_TRIG;
    b_done_trig : R_TRIG;

    can_start_a : BOOL;
    can_start_b : BOOL;
    start_a_trig : R_TRIG;
    start_b_trig : R_TRIG;

    eject_cond_a : BOOL;
    eject_cond_b : BOOL;
    edge_eject_a : R_TRIG;
    edge_eject_b : R_TRIG;

    swap_cond : BOOL;
    edge_swap : R_TRIG;

    takebin_cond : BOOL;
    edge_takebin : R_TRIG;

    good_trays_count : INT := 0;

    complete_cond : BOOL;
    complete_timer : TON;
    complete_latch : BOOL := FALSE;
END_VAR

(* ---- System enable latch (start pulse) ---- *)
run_trig(CLK := X0);
IF run_trig.Q THEN
    running := TRUE;
END_IF;

(* ---- Feed logic (level driven, only when press empty and not busy) ---- *)
Y13 := running AND X16 AND NOT X17 AND NOT X19;
Y16 := running AND X1C AND NOT X1D AND NOT X1F;

(* ---- Track "awaiting discharge of completed tray" state ---- *)
a_done_trig(CLK := X1A);
IF a_done_trig.Q THEN
    a_await_discharge := TRUE;
END_IF;

b_done_trig(CLK := X20);
IF b_done_trig.Q THEN
    b_await_discharge := TRUE;
END_IF;

(* ---- Batch acceptance (irreversible start), gated by capacity and docked bin ---- *)
can_start_a := running AND X17 AND NOT X19 AND NOT a_await_discharge
               AND ((D0 + D1 + D6) <= D3) AND X10;

can_start_b := running AND X1D AND NOT X1F AND NOT b_await_discharge
               AND ((D0 + D1 + D8) <= D3) AND X10;

start_a_trig(CLK := can_start_a);
Y14 := start_a_trig.Q;

start_b_trig(CLK := can_start_b);
Y17 := start_b_trig.Q;

(* ---- Eject logic: only when press done and exit clear ---- *)
eject_cond_a := X1A AND X1B;
edge_eject_a(CLK := eject_cond_a);
Y15 := edge_eject_a.Q;
IF edge_eject_a.Q THEN
    a_await_discharge := FALSE;
    good_trays_count := good_trays_count + 1;
END_IF;

eject_cond_b := X20 AND X21;
edge_eject_b(CLK := eject_cond_b);
Y18 := edge_eject_b.Q;
IF edge_eject_b.Q THEN
    b_await_discharge := FALSE;
    good_trays_count := good_trays_count + 1;
END_IF;

(* ---- Bin swap: only when pending=0, residuals present in docked bin,
        a spare exists, and retrieval spot is vacant and not already swapping ---- *)
swap_cond := running AND (D1 = 0) AND (D4 > 0) AND X12 AND NOT X13 AND NOT X11 AND X10;
edge_swap(CLK := swap_cond);
Y10 := edge_swap.Q;

(* ---- take_bin: request external acceptance when a bin waits at retrieval spot ---- *)
takebin_cond := running AND X13 AND NOT X14;
edge_takebin(CLK := takebin_cond);
Y11 := edge_takebin.Q;

(* ---- Completion: all 3 good trays out, all residuals conserved (all_received),
        current bin docked and stable, no pending swap/retrieval activity ---- *)
complete_cond := (good_trays_count >= 3) AND X15 AND X10 AND NOT X11 AND NOT X13 AND NOT X14;

complete_timer(IN := complete_cond, PT := T#500ms);
IF complete_timer.Q THEN
    complete_latch := TRUE;
END_IF;

Y12 := complete_latch;

END_PROGRAM