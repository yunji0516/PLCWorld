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
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    start_triggered : BOOL := FALSE;
    pump_started : BOOL := FALSE;
    line_cleared : BOOL := FALSE;
    ready_to_route : BOOL := FALSE;
    branch_to_target : BOOL := FALSE;
    transferring : BOOL := FALSE;
END_VAR

(* Detect start request *)
IF NOT start_triggered THEN
    IF X10 THEN
        start_triggered := TRUE;
    END_IF
END_IF

(* Start transferring process after start request is accepted *)
IF start_triggered THEN
    (* Check if the source material ID matches the requested ID2 and no ID1 remains in line *)
    IF D10 = 2 AND NOT pump_started THEN
        (* Ensure all previous material is pumped to waste before routing to target *)
        IF NOT line_cleared THEN
            IF D20 = 1 THEN
                (* Ensure the branch is at waste before starting the pump *)
                IF X20 THEN
                    Y20 := TRUE; (* Turn on the pump *)
                    pump_started := TRUE;
                END_IF
            ELSE
                (* Line is cleared of previous material (ID1) *)
                Y20 := FALSE; (* Turn off the pump *)
                pump_started := FALSE;
                line_cleared := TRUE;
            END_IF
        END_IF
    END_IF

    (* Once line is cleared, prepare to route to target *)
    IF line_cleared AND NOT ready_to_route THEN
        (* Stop the pump before switching branch *)
        IF NOT Y20 THEN
            ready_to_route := TRUE;
        END_IF
    END_IF

    (* Route current material (ID2) to target if the branch is ready *)
    IF ready_to_route THEN
        IF X21 THEN
            (* Ensure branch is at the target *)
            branch_to_target := TRUE;
        END_IF

        IF branch_to_target AND D20 = 2 THEN
            (* Start pumping ID2 to the target *)
            Y20 := TRUE;
            transferring := TRUE;
        END_IF

        (* Check if source is empty and receiver has positive amount of ID2 *)
        IF transferring AND X22 THEN
            Y20 := FALSE; (* Turn off the pump *)
            IF D21 = 0 AND X23 THEN
                Y2 := TRUE; (* Completion claim *)
            END_IF
        END_IF
    END_IF
END_IF

END_PROGRAM