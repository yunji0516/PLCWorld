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
    Y10 : BOOL := FALSE;
    Y11 : BOOL := FALSE;
    Y12 : BOOL := FALSE;
    Y13 : BOOL := FALSE;
    Y14 : BOOL := FALSE;
    Y15 : BOOL := FALSE;
    Y16 : BOOL := FALSE;
    Y17 : BOOL := FALSE;
    Y18 : BOOL := FALSE;
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

    a_start_requested : BOOL := FALSE;
    b_start_requested : BOOL := FALSE;
    bin_swap_pending : BOOL := FALSE;
    complete_declared : BOOL := FALSE;

    start_edge : R_TRIG;
    eject_a_edge : R_TRIG;
    eject_b_edge : R_TRIG;
    swap_edge : R_TRIG;
    take_bin_edge : R_TRIG;

    bin_hold_timer : TON;
    complete_hold_timer : TON;

    total_occupied_and_pending : INT;
    max_bin_capacity : INT := 6;

END_VAR

(* Implement the control logic here. *)

total_occupied_and_pending := D0 + D1;

(* Check if we can start a new batch for A *)
IF X16 AND NOT a_start_requested THEN
    IF X17 AND NOT X19 AND total_occupied_and_pending + 3 <= max_bin_capacity THEN
        Y14 := TRUE;
        a_start_requested := TRUE;
    ELSE
        Y14 := FALSE;
    END_IF;
END_IF;

(* Check if we can start a new batch for B *)
IF X1C AND NOT b_start_requested THEN
    IF X1D AND NOT X1F AND total_occupied_and_pending + 2 <= max_bin_capacity THEN
        Y17 := TRUE;
        b_start_requested := TRUE;
    ELSE
        Y17 := FALSE;
    END_IF;
END_IF;

(* Handle tray ejection for A *)
IF X1A AND X1B THEN
    eject_a_edge(CLK := TRUE);
    IF eject_a_edge.Q THEN
        Y15 := TRUE;
    END_IF;
ELSE
    Y15 := FALSE;
END_IF;

(* Handle tray ejection for B *)
IF X20 AND X21 THEN
    eject_b_edge(CLK := TRUE);
    IF eject_b_edge.Q THEN
        Y18 := TRUE;
    END_IF;
ELSE
    Y18 := FALSE;
END_IF;

(* Handle bin swap *)
swap_edge(CLK := X10 AND NOT bin_swap_pending AND NOT X11 AND X12 AND X15);
IF swap_edge.Q THEN
    IF D1 = 0 AND D4 > 0 THEN
        Y10 := TRUE;
        bin_swap_pending := TRUE;
        bin_hold_timer(IN := TRUE, PT := T#3s);
    END_IF;
END_IF;

(* Complete bin swap sequence *)
IF bin_hold_timer.Q THEN
    Y10 := FALSE;
    bin_swap_pending := FALSE;
    bin_hold_timer(IN := FALSE, PT := T#3s);
END_IF;

(* Handle take_bin sequence *)
take_bin_edge(CLK := X13 AND NOT X14);
IF take_bin_edge.Q THEN
    Y11 := TRUE;
END_IF;

(* Declare completion *)
IF (D5 = 0 AND D7 = 0 AND D1 = 0 AND NOT complete_declared) OR X0 THEN
    Y12 := TRUE;
    complete_declared := TRUE;
    complete_hold_timer(IN := TRUE, PT := T#500ms);
END_IF;

(* Maintain complete for at least 0.5s *)
IF complete_hold_timer.Q THEN
    Y12 := FALSE;
    complete_hold_timer(IN := FALSE, PT := T#500ms);
END_IF;

END_PROGRAM