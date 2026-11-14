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
    Y10 : BOOL := FALSE;
    Y11 : BOOL := FALSE;
    Y12 : BOOL := FALSE;
    Y13 : BOOL := FALSE;
    Y14 : BOOL := FALSE;
    Y15 : BOOL := FALSE;
    Y16 : BOOL := FALSE;
    Y17 : BOOL := FALSE;
    Y18 : BOOL := FALSE;
    Y19 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
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
    D200 : INT := 0;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL := FALSE;
    Y1B : BOOL := FALSE;
    Y1C : BOOL := FALSE;
    Y1D : BOOL := FALSE;
    Y1E : BOOL := FALSE;
    Y1F : BOOL := FALSE;
    (* Internal variables *)
    feed_level : INT := 100; (* Default feed level in mm/s *)
    pull_level : INT := 100; (* Default pull level in mm/s *)
    order_started_a : BOOL := FALSE;
    order_started_b : BOOL := FALSE;
    waste_piece_started : BOOL := FALSE;
    timer : TON;
    piece_complete : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

(* Accept batch if batch_ready is true *)
IF X10 AND NOT Y10 THEN
    Y10 := TRUE;
ELSIF NOT X10 THEN
    Y10 := FALSE;
END_IF

(* Acknowledge batch completion if batch_done is true *)
IF X12 THEN
    Y11 := TRUE;
ELSE
    Y11 := FALSE;
END_IF

(* Accept order A or B based on availability and targets *)
IF X13 AND NOT order_started_a THEN
    Y12 := TRUE;
    order_started_a := TRUE;
    D200 := 1; (* Set side to A *)
ELSIF X14 AND NOT order_started_b THEN
    Y13 := TRUE;
    order_started_b := TRUE;
    D200 := 2; (* Set side to B *)
END_IF

(* Start piece if piece is idle and order is active *)
IF X17 AND (order_started_a OR order_started_b) AND X0 THEN
    Y14 := TRUE;
ELSE
    Y14 := FALSE;
END_IF

(* Manage feed and pull *)
Y15 := X10 AND (D2 > 0); (* Feed only if batch is ready and stored material is positive *)
Y16 := X1F; (* Pull only if holder is open *)

(* Manage blade cutting and release *)
IF X19 THEN
    Y18 := TRUE;
    Y19 := TRUE;
ELSE
    Y18 := FALSE;
    Y19 := FALSE;
END_IF

(* Thread leading end and fix with splices *)
IF X25 AND X22 AND X21 THEN
    Y20 := TRUE;
    Y21 := TRUE;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
END_IF

(* Start waste if splice needed and order length exceeds safe length *)
IF X27 AND (D5 > D10 OR D6 > D10) AND NOT waste_piece_started THEN
    Y22 := TRUE;
    waste_piece_started := TRUE;
ELSIF waste_piece_started AND X1C THEN
    Y22 := FALSE;
    waste_piece_started := FALSE;
END_IF

(* Acknowledge exit after receiving is done *)
IF X1D THEN
    Y1A := TRUE;
ELSE
    Y1A := FALSE;
END_IF

(* Completion logic *)
IF X1E THEN
    timer(IN := TRUE, PT := T#500ms);
    IF timer.Q THEN
        Y1B := TRUE; (* Indicate process completion *)
    END_IF
ELSE
    timer(IN := FALSE);
    Y1B := FALSE;
END_IF

END_PROGRAM