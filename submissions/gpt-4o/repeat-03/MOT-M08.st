PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    (* Internal Variables *)
    ref_edge_detected : BOOL := FALSE;
    approached_shelf : BOOL := FALSE;
    retracted_b : BOOL := FALSE;
    completed : BOOL := FALSE;

    prev_X34 : BOOL := FALSE;
    timer : TON;
    retract_delay : TON;
    
    target_A : DINT := 0;
    target_B : DINT := 0;
    pitched_shelf : DINT := 0;
END_VAR

(* Calculate target A based on requested index and pitch *)
target_A := D90 + D102 * D101;

(* Detect rising edge on reference sensor X34 *)
IF X34 AND NOT prev_X34 THEN
    ref_edge_detected := TRUE;
END_IF
prev_X34 := X34;

(* Step 1: Enable A axis and move to the target position *)
IF X0 AND NOT approached_shelf AND ref_edge_detected THEN
    D20 := target_A * 100;       // Convert to correct scale
    D21 := 1000;                 // Full speed
    Y20 := TRUE;                 // Enable axis A
END_IF

(* Check if axis A arrives at target with tolerances *)
IF Y20 AND ABS(D10 - target_A * 100) <= 20 AND ABS(D11) <= 100 THEN
    approached_shelf := TRUE;
    Y20 := FALSE;                // Disable axis A
END_IF

(* Step 2: Enable B axis to approach *)
IF approached_shelf AND NOT retracted_b THEN
    D24 := D103 * 100;           // Convert reach to correct scale
    D25 := 1000;                 // Full speed
    Y21 := TRUE;                 // Enable axis B
END_IF

(* Check if axis B reaches the requested reach *)
IF Y21 AND ABS(D12 - D103 * 100) <= 20 AND ABS(D13) <= 100 THEN
    retracted_b := TRUE;
    Y21 := FALSE;                // Disable axis B
    retract_delay(IN := TRUE, PT := T#100ms); // Initiate retract wait time
END_IF

(* Step 3: Retract B axis to 0 *)
IF retract_delay.Q THEN
    D24 := 0;
    D25 := 1000;                 // Full speed for retract
    Y21 := TRUE;
END_IF

(* Check if axis B is fully retracted *)
IF retracted_b AND Y21 AND ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
    Y21 := FALSE;                // Disable axis B
    completed := TRUE;
END_IF

(* Assert completion *)
IF completed THEN
    Y2 := TRUE;
    timer(IN := TRUE, PT := T#100ms);
END_IF

(* Reset completion signal after 100ms *)
IF timer.Q THEN
    Y2 := FALSE;
END_IF

END_PROGRAM