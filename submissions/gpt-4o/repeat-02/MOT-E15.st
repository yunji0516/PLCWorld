PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;

    (* Internal variables *)
    M : REAL;
    head_angle_rad : REAL;
    counterweight_mm : REAL;
    target_position : REAL;
    error_tolerance : DINT := 100; (* Tolerance for maintaining M within limits *)
    maintain_counter : INT := 0;

    request_accepted : BOOL := FALSE;
    function_active : BOOL := FALSE;
    stability_timer : TIME := T#0ms;

    edge_X10 : R_TRIG;
    stability_end : TIME := T#30ms;
    completion_end : TIME := T#1400ms;

END_VAR

(* Determine whether the function can be activated based on the input request signal *)
edge_X10(CLK := X10);

IF edge_X10.Q THEN
    request_accepted := TRUE;
END_IF

(* Activate function and start operation if request is accepted *)
IF request_accepted THEN
    Y20 := TRUE;
    function_active := TRUE;
END_IF

(* Calculate the current support moment M based on the head angle and counterweight position *)
head_angle_rad := REAL(D13) * 0.01 * 3.14159265359 / 180.0; (* Convert to radians *)
counterweight_mm := REAL(D11) * 0.01; (* Convert from DINT to REAL, mm units *)

M := 30 * 9.81 * 0.3 * SIN(head_angle_rad) + 20 * 9.81 * (counterweight_mm / 1000);

(* Continuously update target position to counterbalance the head, ensuring M within limits *)
target_position := - ((30 * 9.81 * 0.3 * SIN(head_angle_rad)) / (20 * 9.81)) * 1000; (* Target mm *)

(* Command the counterweight position and feedforward speed *)
D20 := DINT(LIMIT(-200000, target_position * 100, 200000)); (* Convert target to command range *)
D21 := 0; (* Feedforward speed not utilized here *)

(* Check stability of M for completion condition and retain function results *)
IF function_active AND ABS(M) < 1 THEN
    maintain_counter := maintain_counter + 1;
	IF maintain_counter = (stability_end / T#10ms) THEN
        Y2 := TRUE;
		stability_timer := stability_end;
    END_IF
END_IF

(* Check for completion and deactivate if observed retention stability is reached *)
IF Y2 THEN
    stability_timer := stability_timer + T#10ms;
    IF stability_timer > completion_end THEN
        function_active := FALSE;
        Y20 := FALSE;
    END_IF
ELSE
    maintain_counter := 0;
END_IF

(* Safety constraint: Ensure |M| does not exceed 25 Nm at any point *)
IF ABS(M) > 25 THEN
    Y20 := FALSE;
    Y2 := FALSE;
ENDIF

END_PROGRAM