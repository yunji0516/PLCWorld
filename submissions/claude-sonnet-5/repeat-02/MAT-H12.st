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

    (* Internal helper signals *)
    feed_a_cond   : BOOL;
    feed_b_cond   : BOOL;
    start_cond_a  : BOOL;
    start_cond_b  : BOOL;
    eject_ready_a : BOOL;
    eject_ready_b : BOOL;
    swap_cond     : BOOL;
    takebin_cond  : BOOL;
    complete_cond : BOOL;

    good_count         : INT := 0;
    completion_declared : BOOL := FALSE;

    (* Edge detectors *)
    r_start_a  : R_TRIG;
    r_start_b  : R_TRIG;
    r_eject_a  : R_TRIG;
    r_eject_b  : R_TRIG;
    r_swap     : R_TRIG;
    r_takebin  : R_TRIG;

    (* Stability timer for completion *)
    complete_timer : TON;
END_VAR

(* ---------------------------------------------------------------
   FEED LOGIC : feed_a/b are level-driven, on while a source batch
   is available and the corresponding press is empty and not busy.
   Once the batch arrives (a_present/b_present goes TRUE) the
   feed signal naturally drops because the "not present" condition
   becomes FALSE.
   --------------------------------------------------------------- *)
feed_a_cond := X0 AND X16 AND (NOT X17) AND (NOT X19);
feed_b_cond := X0 AND X1C AND (NOT X1D) AND (NOT X1F);

Y13 := feed_a_cond;
Y16 := feed_b_cond;

(* ---------------------------------------------------------------
   START (IRREVERSIBLE ACCEPTANCE) LOGIC
   Only request start when:
     - a batch is present and waiting
     - the press is not busy / not holding a finished tray
     - a receiving bin is currently docked (bin_ready)
     - reserving capacity for the whole new batch keeps
       occupied + pending + new_batch_size <= 6
   Generated as a single rising-edge pulse.
   --------------------------------------------------------------- *)
start_cond_a := X0 AND X17 AND (NOT X19) AND (NOT X1A) AND X10 AND
                ((D0 + D1 + D6) <= 6);

start_cond_b := X0 AND X1D AND (NOT X1F) AND (NOT X20) AND X10 AND
                ((D0 + D1 + D8) <= 6);

r_start_a(CLK := start_cond_a);
r_start_b(CLK := start_cond_b);

Y14 := r_start_a.Q;
Y17 := r_start_b.Q;

(* ---------------------------------------------------------------
   EJECT LOGIC
   Eject only when the local good-tray completion is asserted AND
   the corresponding exit is clear (never while occupied/in transit).
   --------------------------------------------------------------- *)
eject_ready_a := X1A AND X1B;
eject_ready_b := X20 AND X21;

r_eject_a(CLK := eject_ready_a);
r_eject_b(CLK := eject_ready_b);

Y15 := r_eject_a.Q;
Y18 := r_eject_b.Q;

IF r_eject_a.Q THEN
    good_count := good_count + 1;
END_IF;

IF r_eject_b.Q THEN
    good_count := good_count + 1;
END_IF;

(* ---------------------------------------------------------------
   SWAP LOGIC
   Rising edge only when: no residuals still pending (in transit),
   the docked bin actually holds received residuals, a spare bin
   is ready, the retrieval spot is vacant (no bin waiting and no
   retrieval currently busy), and no other swap is already running.
   --------------------------------------------------------------- *)
swap_cond := (D1 = 0) AND (D4 > 0) AND X12 AND
             (NOT X13) AND (NOT X14) AND (NOT X11);

r_swap(CLK := swap_cond);
Y10 := r_swap.Q;

(* ---------------------------------------------------------------
   TAKE_BIN LOGIC
   Rising edge of return_ready (bin waiting at retrieval spot) while
   the retrieval path is not already busy requests external pickup.
   --------------------------------------------------------------- *)
takebin_cond := X13 AND (NOT X14);
r_takebin(CLK := takebin_cond);
Y11 := r_takebin.Q;

(* ---------------------------------------------------------------
   COMPLETION LOGIC
   All 3 good trays ejected, all residuals received (all_received),
   nothing still pending/in transit, previous bin fully retrieved
   (retrieval spot vacant, retrieval not busy) and a bin currently
   docked. Must be stable for >= 0.5 s before being declared, and
   is then latched and maintained.
   --------------------------------------------------------------- *)
complete_cond := (good_count >= 3) AND X15 AND (D1 = 0) AND
                 (NOT X13) AND (NOT X14) AND X10;

complete_timer(IN := complete_cond, PT := T#500ms);

IF complete_timer.Q THEN
    completion_declared := TRUE;
END_IF;

IF completion_declared THEN
    Y12 := TRUE;
ELSE
    Y12 := FALSE;
END_IF;

END_PROGRAM