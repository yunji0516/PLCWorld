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
    
    (* Add internal variables here. *)
    start_triggered : BOOL := FALSE;
    previous_material_displaced : BOOL := FALSE;
    transfer_completed : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

IF NOT start_triggered THEN
    IF X10 THEN
        (* Rising edge of start request detected, accept request. *)
        start_triggered := TRUE;
    END_IF;
END_IF;

IF start_triggered AND NOT transfer_completed THEN
    (* Check if previous material is still in line *)
    IF D20 = 1 THEN
        (* Pump and branch to waste to displace previous material. *)
        Y20 := TRUE;    (* Turn ON pump *)
        Y21 := FALSE;   (* Ensure branch is set to waste *)
    ELSE
        (* All previous material displaced, transfer new material to target. *)
        previous_material_displaced := TRUE;
        IF previous_material_displaced AND D10 = 2 THEN
            IF NOT X21 THEN
                (* Wait for branch to reach target. *)
                Y20 := FALSE;  (* Stop pump while changing branch position *)
                Y21 := TRUE;   (* Command branch to target *)
            ELSE
                (* Branch in target position, continue pumping until source empty. *)
                Y20 := TRUE;  (* Turn ON pump *)
                IF X22 THEN
                    (* Source is empty, stop pump and declare completion. *)
                    Y20 := FALSE;
                    Y2 := TRUE;
                    transfer_completed := TRUE;
                END_IF;
            END_IF;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM