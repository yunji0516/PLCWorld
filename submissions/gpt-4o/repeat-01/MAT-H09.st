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
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
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
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    
    pump_a_delay : TIME := T#0s;
    pump_b_delay : TIME := T#0s;
    cap_a_request : BOOL := FALSE;
    cap_b_request : BOOL := FALSE;
    tank_refill : BOOL := FALSE;
    swap_requested : BOOL := FALSE;
    pump_a_active : BOOL := FALSE;
    pump_b_active : BOOL := FALSE;
    valve_a_delay : TIME := T#0s;
    valve_b_delay : TIME := T#0s;
    nozzle_a_up : BOOL := TRUE;
    nozzle_b_up : BOOL := TRUE;
    
    timer : TON;
    edge : R_TRIG;
END_VAR

(* Implement the control logic here. *)

(* Handle Start Logic *)
IF X0 THEN
    (* Clear all systems to initial start state *)
    pump_a_delay := T#0s;
    pump_b_delay := T#0s;
    cap_a_request := FALSE;
    cap_b_request := FALSE;
    tank_refill := FALSE;
    swap_requested := FALSE;
    pump_a_active := FALSE;
    pump_b_active := FALSE;
    valve_a_delay := T#0s;
    valve_b_delay := T#0s;
    nozzle_a_up := TRUE;
    nozzle_b_up := TRUE;
END_IF

(* Tank Refill Logic *)
IF D0 < 1600 AND X2F THEN
    tank_refill := TRUE;
    IF tank_refill THEN
        Y10 := TRUE;
    ELSE
        Y10 := FALSE;
    END_IF
END_IF

(* Swap Logic *)
edge(CLK := X30);
IF edge.Q AND NOT X2F THEN
    swap_requested := TRUE;
END_IF
IF swap_requested AND NOT swap_busy THEN
    Y11 := TRUE; (* Request swap *)
ELSE
    Y11 := FALSE;
END_IF

(* Line A Logic *)
IF X10 AND NOT X12 AND NOT X14 THEN
    Y15 := TRUE; (* Clamp *)
END_IF
IF X13 AND NOT X14 THEN
    Y15 := FALSE; (* Release Clamp *)
END_IF

(* Check for A valve ready to open *)
IF X17 AND nozzle_a_up = TRUE THEN
    timer(IN := TRUE, PT := T#150ms);
    IF timer.Q THEN
        Y17 := TRUE; (* Open Valve *)
        nozzle_a_up := FALSE;
    END_IF
ELSE
    Y17 := FALSE;
END_IF

(* Line B Logic *)
IF X1E AND NOT X20 AND NOT X22 THEN
    Y1C := TRUE; (* Clamp *)
END_IF
IF X21 AND NOT X22 THEN
    Y1C := FALSE; (* Release Clamp *)
END_IF

(* Check for B valve ready to open *)
IF X25 AND nozzle_b_up = TRUE THEN
    timer(IN := TRUE, PT := T#150ms);
    IF timer.Q THEN
        Y1E := TRUE; (* Open Valve *)
        nozzle_b_up := FALSE;
    END_IF
ELSE
    Y1E := FALSE;
END_IF

(* Pump Logic *)
IF X16 AND X15 AND NOT X18 THEN
    Y18 := TRUE; (* Pump A ON *)
ELSE
    Y18 := FALSE;
END_IF
IF X24 AND X23 AND NOT X26 THEN
    Y1F := TRUE; (* Pump B ON *)
ELSE
    Y1F := FALSE;
END_IF

(* Capping Logic *)
IF X1A AND NOT X1B AND NOT X2C THEN
    Y12 := TRUE; (* Cap A *)
ELSE
    Y12 := FALSE;
END_IF

IF X28 AND NOT X29 AND NOT X2C THEN
    Y13 := TRUE; (* Cap B *)
ELSE
    Y13 := FALSE;
END_IF

(* Exit Logic *)
IF X1C AND X1D AND NOT X19 THEN
    Y19 := TRUE; (* Move to Exit A *)
ELSE
    Y19 := FALSE;
END_IF

IF X2A AND X2B AND NOT X27 THEN
    Y20 := TRUE; (* Move to Exit B *)
ELSE
    Y20 := FALSE;
END_IF

(* Finalization Logic *)
IF X32 AND D3 = 6 THEN
    Y22 := TRUE; (* Complete condition *)
ELSE
    Y22 := FALSE;
END_IF

END_PROGRAM