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
    
    (* Internal state for edge detection *)
    prev_start_a_cond : BOOL;
    prev_start_b_cond : BOOL;
    prev_eject_a_cond : BOOL;
    prev_eject_b_cond : BOOL;
    prev_swap_cond : BOOL;
    prev_take_bin_cond : BOOL;
    
    start_a_cond : BOOL;
    start_b_cond : BOOL;
    eject_a_cond : BOOL;
    eject_b_cond : BOOL;
    swap_cond : BOOL;
    take_bin_cond : BOOL;
    
    (* Accumulator for total residuals from all started batches *)
    total_residuals_produced : INT;
    
    (* Completion latch and timer *)
    complete_latched : BOOL;
    complete_timer : TON;
    
END_VAR

(* ============================================================ *)
(* Feed outputs - level triggered                                *)
(* Feed a source batch into an empty, idle press when bin docked *)
(* ============================================================ *)
Y13 := X16 AND (D5 = 0) AND NOT X19 AND X10 AND NOT X17;
Y16 := X1C AND (D7 = 0) AND NOT X1F AND X10 AND NOT X1D;

(* ============================================================ *)
(* Start conditions - rising edge pulses                          *)
(* Accept batch only when press has a loaded batch, is not busy,  *)
(* is not done, capacity check passes, and bin is docked          *)
(* ============================================================ *)
start_a_cond := X17 AND (D5 <> 0) AND NOT X19 AND NOT X1A
                AND (D0 + D1 + D6 <= 6) AND X10;
start_b_cond := X1D AND (D7 <> 0) AND NOT X1F AND NOT X20
                AND (D0 + D1 + D8 <= 6) AND X10;

IF start_a_cond AND NOT prev_start_a_cond THEN
    Y14 := TRUE;
    total_residuals_produced := total_residuals_produced + D6;
ELSE
    Y14 := FALSE;
END_IF;
prev_start_a_cond := start_a_cond;

IF start_b_cond AND NOT prev_start_b_cond THEN
    Y17 := TRUE;
    total_residuals_produced := total_residuals_produced + D8;
ELSE
    Y17 := FALSE;
END_IF;
prev_start_b_cond := start_b_cond;

(* ============================================================ *)
(* Eject conditions - rising edge pulses                          *)
(* Eject completed good tray only when press done AND exit clear  *)
(* ============================================================ *)
eject_a_cond := X1A AND X1B;
eject_b_cond := X20 AND X21;

IF eject_a_cond AND NOT prev_eject_a_cond THEN
    Y15 := TRUE;
ELSE
    Y15 := FALSE;
END_IF;
prev_eject_a_cond := eject_a_cond;

IF eject_b_cond AND NOT prev_eject_b_cond THEN
    Y18 := TRUE;
ELSE
    Y18 := FALSE;
END_IF;
prev_eject_b_cond := eject_b_cond;

(* ============================================================ *)
(* Swap condition - rising edge pulse                             *)
(* Exchange docked bin for spare when:                            *)
(*   pending = 0, residuals in docked bin, spare available,       *)
(*   swap not busy, return not in progress, bin docked            *)
(* ============================================================ *)
swap_cond := (D1 = 0) AND (D3 > 0) AND X12 AND NOT X11 AND NOT X14 AND X10;

IF swap_cond AND NOT prev_swap_cond THEN
    Y10 := TRUE;
ELSE
    Y10 := FALSE;
END_IF;
prev_swap_cond := swap_cond;

(* ============================================================ *)
(* Take bin - rising edge pulse when return_ready                *)
(* ============================================================ *)
take_bin_cond := X13;

IF take_bin_cond AND NOT prev_take_bin_cond THEN
    Y11 := TRUE;
ELSE
    Y11 := FALSE;
END_IF;
prev_take_bin_cond := take_bin_cond;

(* ============================================================ *)
(* Completion:                                                  *)
(*   3 good trays received (D4 >= 3)                            *)
(*   No residuals in transit (D1 = 0)                           *)
(*   All 8 residuals produced by started batches                *)
(*   Bin docked (X10)                                           *)
(* Maintain for at least 0.5 s via timer                        *)
(* ============================================================ *)
IF NOT complete_latched THEN
    complete_timer(IN := (D4 >= 3) AND (D1 = 0)
                   AND (total_residuals_produced >= 8) AND X10,
                   PT := T#500ms);
    IF complete_timer.Q THEN
        complete_latched := TRUE;
    END_IF;
END_IF;

Y12 := complete_latched;

END_PROGRAM