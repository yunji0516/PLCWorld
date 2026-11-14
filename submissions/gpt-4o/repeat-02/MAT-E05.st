PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;

    (* Internal variables *)
    start_edge : R_TRIG;
    scan_counter : INT := 0;
    aligning : BOOL := FALSE;
    alignment_finished : BOOL := FALSE;
    holding_result : BOOL := FALSE;
END_VAR

(* Detect rising edge of the start request *)
start_edge(CLK := X10);

(* Main control logic *)
IF start_edge.Q AND (D10 = 1) AND NOT holding_result THEN
    aligning := TRUE;
    alignment_finished := FALSE;
    holding_result := FALSE;
    scan_counter := 0;
END_IF;

IF aligning THEN
    (* Align in the x direction *)
    IF NOT X20 THEN
        Y20 := TRUE; (* Extend x align finger *)
    ELSE
        Y20 := FALSE; (* Retract x align finger *)
    END_IF;
    
    (* Align in the z direction *)
    IF NOT X21 THEN
        Y21 := TRUE; (* Extend z align finger *)
    ELSE
        Y21 := FALSE; (* Retract z align finger *)
    END_IF;
    
    (* Check if alignment is finished *)
    IF X20 AND X21 THEN
        alignment_finished := TRUE;
        aligning := FALSE;
    END_IF;
END_IF;

(* After alignment and check both fingers are cleared *)
IF alignment_finished AND X22 THEN
    holding_result := TRUE;
    Y2 := TRUE; (* Claim completion *)
END_IF;

(* Hold the result for at least 50 scans, ensuring Y2 remains TRUE *)
IF holding_result THEN
    scan_counter := scan_counter + 1;
    
    IF scan_counter >= 50 THEN
        Y2 := FALSE; (* Reset completion claim after holding period *)
        holding_result := FALSE;
    END_IF;
END_IF;

(* Safety: Ensure commands are not active after alignment is confirmed *)
IF NOT aligning THEN
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;

END_PROGRAM