PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    start_edge : R_TRIG;
    aligning : BOOL := FALSE;
    scan_counter : DINT := 0;
    alignment_complete : BOOL := FALSE;
    hold_counter : DINT := 0;
END_VAR

(* Initialize rising edge detection for start signal *)
start_edge(CLK := X10);

(* Control logic *)
IF start_edge.Q AND D10 = 1 THEN
    aligning := TRUE;
    scan_counter := 0;
    Y20 := TRUE; (* Start alignment for x axis *)
    Y21 := TRUE; (* Start alignment for z axis *)
END_IF

IF aligning THEN
    scan_counter := scan_counter + 1;

    (* Check if datum conditions are met *)
    IF X20 THEN
        Y20 := FALSE; (* Stop x alignment *)
    END_IF
    IF X21 THEN
        Y21 := FALSE; (* Stop z alignment *)
    END_IF

    (* Check if both datums have been met *)
    IF X20 AND X21 THEN
        IF X22 THEN (* Check if fingers are clear *)
            alignment_complete := TRUE;
            Y2 := TRUE; (* Completion claim *)
            aligning := FALSE;
        END_IF
    END_IF

    (* Timeout check for safety *)
    IF scan_counter >= 1550 THEN
        aligning := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF
END_IF

(* Hold the completion state for at least 50 scans once alignment is completed *)
IF alignment_complete THEN
    hold_counter := hold_counter + 1;
    IF hold_counter >= 50 THEN
        Y2 := FALSE;
    END_IF
END_IF

END_PROGRAM