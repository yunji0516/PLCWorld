PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    D20 : INT;
    D21 : INT;
    (* Internal variables *)
    start_edge : R_TRIG;
    outlet_ID : INT := 0;
    previous_source_mL : INT := 0;
    new_material_start : BOOL := FALSE;
    old_material_complete : BOOL := FALSE;
    scans_since_completion : INT := 0;
END_VAR

(* Initialize the rising edge detection for the start signal *)
start_edge(CLK := X10);

(* Control logic *)
IF start_edge.Q THEN
    (* Start the pump to displace old material *)
    Y20 := TRUE;
END_IF

IF Y20 THEN
    (* Monitor the outlet ID and source to determine phase progress *)
    
    (* Capture the initial state of the source material *)
    IF NOT new_material_start AND D21 <= 40 THEN
        previous_source_mL := D21;
        new_material_start := TRUE;
    END_IF
    
    (* Check if the old material has been completely displaced *)
    IF D20 = 2 THEN
        old_material_complete := TRUE;
        Y20 := FALSE; (* Stop the pump *)
    END_IF
END_IF

(* Completion condition *)
IF old_material_complete THEN
    (* Ensure no more than 1 mL of new material has been sent to recovery *)
    IF previous_source_mL - D21 <= 41 THEN
        Y2 := TRUE;
    END_IF
    
    (* Accumulate scans since completion for holding the result *)
    IF Y2 THEN
        scans_since_completion := scans_since_completion + 1;
    END_IF
END_IF

(* Maintain result holding for at least 50 scans post-completion *)
IF scans_since_completion >= 50 THEN
    Y2 := TRUE;
END_IF

END_PROGRAM