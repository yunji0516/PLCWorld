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
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    D15 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT;
    D204 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    (* Add internal variables here. *)
    collect_a : BOOL := FALSE;
    collect_b : BOOL := FALSE;
    transfer_in_progress : BOOL := FALSE;
    pallet_supplied : BOOL := FALSE;
    a_order_completed : BOOL := FALSE;
    b_order_completed : BOOL := FALSE;
    current_thickness : INT := 0;
    r_trig_accept_a : R_TRIG;
    r_trig_accept_b : R_TRIG;
    r_trig_fork_insert : R_TRIG;
    timer_complete : TON;
END_VAR

(* Implement the control logic here. *)

(* Detect leading edge of accept commands *)
r_trig_accept_a(CLK := X10 AND NOT a_full);
r_trig_accept_b(CLK := X11 AND NOT b_full);

(* Handle accepting orders *)
IF r_trig_accept_a.Q THEN
    Y10 := TRUE; (* Accept A order *)
    collect_a := TRUE;
END_IF

IF r_trig_accept_b.Q THEN
    Y11 := TRUE; (* Accept B order *)
    collect_b := TRUE;
END_IF

(* Control the head picking logic *)
IF X12 = FALSE AND NOT transfer_in_progress THEN
    IF collect_a AND X1B THEN
        Y12 := TRUE; (* Pick the next A type plate *)
        D200 := 1;   (* Set kind for A *)
        D201 := 1;   (* Side 1 for A stack *)
        current_thickness := D2; (* Retain thickness of picked plate *)
        collect_a := FALSE;
    ELSIF collect_b AND X1C THEN
        Y12 := TRUE; (* Pick the next B type plate *)
        D200 := 2;   (* Set kind for B *)
        D201 := 2;   (* Side 2 for B stack *)
        current_thickness := D3; (* Retain thickness of picked plate *)
        collect_b := FALSE;
    END_IF
END_IF

(* Handle placement logic *)
IF X13 AND (a_order_completed OR b_order_completed) THEN
    Y13 := TRUE; (* Place the current plate *)
    D202 := current_thickness * 1000; (* Adjust place_mm based on thickness *)
END_IF

(* Manage fork insertion *)
r_trig_fork_insert(CLK := X15);
IF r_trig_fork_insert.Q THEN
    Y16 := TRUE; (* Insert fork *)
    IF NOT transfer_in_progress THEN
        IF X28 THEN
            Y17 := TRUE; (* Lift fork to 870 mm *)
        END_IF
        IF X29 THEN
             Y17 := TRUE; (* Lift fork to 870 mm *)
        END_IF
    END_IF
END_IF

(* Transfer logic *)
IF X16 AND NOT transfer_in_progress THEN
    IF X25 OR X26 THEN
        transfer_in_progress := TRUE;
        Y18 := TRUE; (* Transfer fork *)
    END_IF
END_IF

(* Completion logic *)
IF X1A THEN
    a_order_completed := TRUE;
    b_order_completed := TRUE;
END_IF

(* End of process management *)
IF a_order_completed AND b_order_completed AND X18 AND X19 THEN
    Y1B := TRUE; (* Mark process complete *)
    Y1A := TRUE; (* Acknowledge exit *)
    timer_complete(IN := TRUE, PT := T#500ms);
    IF timer_complete.Q THEN
        a_order_completed := FALSE;
        b_order_completed := FALSE;
        transfer_in_progress := FALSE;
    END_IF
END_IF

END_PROGRAM