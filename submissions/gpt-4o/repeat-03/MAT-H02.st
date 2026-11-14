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
    D16 : INT;
    D200 : INT := 1;
    D201 : INT := 0;
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

    current_target : INT := 1;
    current_generation : INT := 1;
    kit_count_a : INT := 0;
    kit_count_b : INT := 0;
    ready_to_dispatch : BOOL := FALSE;
    complete_declaration : BOOL := FALSE;
    complete_timer : TON;
    dispatch_timer : TON;
    box_clamp_timer : TON;
    external_acquisition_delay : TON;
END_VAR

(* Control logic implementation. *)

(* Accept current generation request on rising edge of a_request or b_request *)
IF X13 AND NOT Y13 THEN
    Y13 := TRUE;
    D201 := D11; (* Accept A generation *)
ELSIF X14 AND NOT Y14 THEN
    Y14 := TRUE;
    D201 := D12; (* Accept B generation *)
END_IF

(* Dock and load/unload logic *)
IF NOT X11 THEN
    IF (X15 OR X16) AND (D0 = current_target) THEN
        IF X12 THEN
            IF X15 AND D1 = D3 THEN
                Y11 := TRUE; (* Load *)
            ELSIF X16 AND D1 = D4 THEN
                Y12 := TRUE; (* Unload *)
            END_IF
        ELSE
            Y10 := TRUE; (* Dock *)
        END_IF
    END_IF
END_IF

(* Update target based on the current operation *)
IF Y12 THEN
    IF D200 = 1 THEN
        current_target := 4;
    ELSE
        current_target := 5;
    END_IF
ELSIF Y11 THEN
    current_target := 2; (* Return to inbound after loading *)
END_IF

(* Unload conditions and load logic for generation match *)
IF Y12 THEN
    IF (D200 = 4 AND D9 = D11) OR (D200 = 5 AND D10 = D12) THEN
        unload_to := unload_to + 1;
        kit_count_a := kit_count_a + 1;
        IF kit_count_a = 2 THEN
            Y15 := TRUE; (* close_a *)
            Y17 := TRUE; (* release_a *)
            kit_count_a := 0;
        END_IF
    END_IF
ELSIF Y11 THEN
    (* Logic when loading the stock or needed part. *)
    Y19 := TRUE; (* Confirm acquisition *)
END_IF

(* Packing and box dispatch logic *)
IF X22 AND X23 THEN
    Y1E := TRUE;
    Y1F := TRUE;
    IF X24 THEN
        Y1D := FALSE; (* Release clamp *)
    END_IF
    IF X25 THEN
        Y20 := TRUE; (* Dispatch box *)
    END_IF
END_IF

(* Completion logic *)
IF (kit_count_a = 2 AND kit_count_b = 2) AND NOT complete_declaration THEN
    complete_declaration := TRUE;
    complete_timer(IN := TRUE, PT := T#500MS);
END_IF

IF complete_declaration AND complete_timer.Q THEN
    Y1B := TRUE; (* Set complete *)
    dispatch_timer(IN := TRUE, PT := T#500MS);
ELSE
    Y1B := FALSE;
    complete_timer(IN := FALSE);
END_IF

(* Reset logic, ensuring outputs are cleared and timers are reset. *)
IF NOT X0 OR X1D THEN
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y1A := FALSE;
    Y1B := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    complete_declaration := FALSE;
    dispatch_timer(IN := FALSE);
    box_clamp_timer(IN := FALSE);
    external_acquisition_delay(IN := FALSE);
END_IF

END_PROGRAM