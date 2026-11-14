PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;

    (* Internal variables *)
    start_request_edge : R_TRIG;
    requested_volume : INT := 0;
    pump_started : BOOL := FALSE;
    command_received : BOOL := FALSE; 
    line_filled : INT := 20; (* Assuming initially filled with 0-20 mL. *)

END_VAR

(* Rising edge detector for start request *)
start_request_edge(CLK := X10);

(* Main control logic *)
IF start_request_edge.Q THEN
    requested_volume := D10;
    command_received := TRUE;
END_IF

IF command_received THEN
    (* Move nozzle down if not in lower position *)
    IF NOT X21 THEN
        Y20 := TRUE;
        Y21 := FALSE;
    ELSE
        Y20 := FALSE;
        Y21 := FALSE;

        (* Open valve if not already open *)
        IF NOT X22 THEN
            Y22 := TRUE;
        ELSE
            Y22 := FALSE;

            (* Start pump if volume to be transferred has not been reached *)
            IF (D20 < requested_volume) THEN
                Y23 := TRUE;
                pump_started := TRUE;
            ELSE
                Y23 := FALSE;
            END_IF
        END_IF
    END_IF

    (* Check completion and safety constraints *)
    IF (D20 >= requested_volume AND D20 <= requested_volume + 2) THEN
        (* Conditions met, completion achieved *)
        Y2 := TRUE;
        command_received := FALSE;
    END_IF

    (* Ensure no spillage *)
    IF (D20 > requested_volume + 2) THEN
        (* Safety constraint: zero spillage *)
        Y2 := FALSE;
    END_IF
END_IF

(* Ensure final states after completion *)
IF Y2 THEN
    (* Set all outputs to false, except Y2 *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
END_IF

END_PROGRAM