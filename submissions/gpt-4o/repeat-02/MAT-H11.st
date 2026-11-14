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
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
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
    D200 : INT;
    D201 : INT;
    D202 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    (* Add internal variables here. *)
    current_width : INT := 200;
    tool_ready : BOOL := FALSE;
    head_available : BOOL := FALSE;
    product_ready : BOOL := FALSE;
    a_completed : BOOL := FALSE;
    b_completed : BOOL := FALSE;
    process_timer : TIME := T#0s;
    complete_timer : TIME := T#0s;
    process_start : BOOL := FALSE;
    complete_signal : BOOL := FALSE;
    head_edge : R_TRIG;
END_VAR

(* Implement the control logic here. *)

(* Process logic for A side *)
IF X14 AND NOT X16 THEN
    IF source_fixture_ready THEN
        Y23 := TRUE;
        D201 := 160;
    ELSE
        Y23 := FALSE;
    END_IF;
    IF a_fixture_ready THEN
        Y10 := TRUE;
        Y11 := TRUE;
    ELSE
        Y10 := FALSE;
        Y11 := FALSE;
    END_IF;
    IF Y11 AND NOT X15 THEN
        a_completed := TRUE;
    END_IF;
END_IF;

(* Process logic for cradle transfer and inversion *)
IF a_completed AND X17 AND NOT X11 THEN
    Y12 := TRUE; (* to_cradle *)
END_IF;
IF X19 THEN
    Y13 := TRUE; (* cradle_lock *)
END_IF;
IF X18 THEN
    Y14 := TRUE; (* head_release *)
END_IF;
IF X13 AND NOT X19 THEN
    Y15 := TRUE; (* rotate *)
END_IF;

(* Process logic for B side *)
IF Y15 AND X1A THEN
    IF X1C AND NOT X1E THEN
        Y18 := TRUE;
        Y24 := TRUE;
        D202 := 120;
    ELSE
        Y18 := FALSE;
        Y24 := FALSE;
    END_IF;
    IF b_fixture_ready THEN
        Y19 := TRUE;
    ELSE
        Y19 := FALSE;
    END_IF;
    IF X1D THEN
        b_completed := TRUE;
    END_IF;
END_IF;

(* Tool handling logic *)
IF X2A AND NOT X2B THEN
    Y21 := TRUE; (* tool_lock *)
    tool_ready := TRUE;
ELSE
    Y21 := FALSE;
END_IF;
IF tool_ready AND NOT X11 THEN
    Y20 := TRUE; (* tool_unlock *)
END_IF;
IF Y20 AND X2B THEN
    Y22 := TRUE; (* tool_return *)
END_IF;

(* Completion logic *)
IF a_completed AND b_completed AND X1F THEN
    complete_signal := TRUE;
    process_start := FALSE;
END_IF;

IF complete_signal THEN
    IF complete_timer < T#500ms THEN
        complete_timer := complete_timer + T#10ms;
        Y1C := TRUE;
    ELSE
        Y1C := FALSE;
        complete_signal := FALSE;
    END_IF;
ELSE
    complete_timer := T#0s;
END_IF;

END_PROGRAM