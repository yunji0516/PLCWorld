PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    D15 : DINT;
    D16 : DINT;
    D18 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y2 : BOOL;
    
    (* Internal variables *)
    a_target : DINT;
    a_error : DINT;
    a_speed : DINT;
    a_acceleration : DINT;

    b_target : DINT;
    b_error : DINT;
    b_speed : DINT;
    b_acceleration : DINT;

    is_a_in_position : BOOL;
    is_b_in_position : BOOL;
    is_c_in_position : BOOL;
    
    completion_timer : TIME;
    stability_timer : TIME;

    task_active : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

IF X10 THEN
    (* Activate the task if not active *)
    IF NOT task_active THEN
        task_active := TRUE;
        completion_timer := T#0ms;
        stability_timer := T#0ms;
        Y2 := FALSE;
    END_IF

    (* Calculate the error for wire length and trolley position *)
    a_error := D10 - D11;
    b_error := D17 - D13;

    (* Calculate the speed for wire length and trolley position *)
    a_speed := abs(D12);
    b_speed := abs(D14);

    (* Check if the positions are in the target range *)
    is_a_in_position := ABS(a_error) <= 100 AND a_speed <= 100;
    is_b_in_position := ABS(b_error) <= 100 AND b_speed <= 100;
    is_c_in_position := ABS(D15) <= 20 AND ABS(D16) <= 100;

    IF is_a_in_position AND is_b_in_position AND is_c_in_position THEN
        (* Check for stability *)
        stability_timer := stability_timer + T#10ms;
        IF stability_timer >= T#30ms THEN
            Y2 := TRUE;
            completion_timer := completion_timer + T#10ms;
            (* Check completion condition *)
            IF completion_timer >= T#100ms THEN 
                task_active := FALSE; (* End execution as stabilization is complete *)
            END_IF
        END_IF
    ELSE
        stability_timer := T#0ms; (* Reset the stability timer if not stable *)
    END_IF

    (* Calculate new acceleration if not in position *)
    IF NOT is_a_in_position THEN
        a_acceleration := 35 * a_error + 70 * (-D12);
        a_acceleration := LIMIT(-400000, 400000, a_acceleration);
        D20 := a_acceleration;
        Y20 := TRUE;
    ELSE
        a_acceleration := 0;
        D20 := D11; (* Maintain current position if in target *)
    END_IF

    IF NOT is_b_in_position THEN
        b_acceleration := 35 * b_error + 70 * (-D14);
        b_acceleration := LIMIT(-400000, 400000, b_acceleration);
    ELSE
        b_acceleration := 0;
    END_IF
    
    (* Assign the acceleration values to the output *)
    D21 := a_acceleration;
    
ELSE
    (* Reset outputs when task is not requested *)
    task_active := FALSE;
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := D11;
    D21 := 0;
    stability_timer := T#0ms;
    completion_timer := T#0ms;
END_IF

END_PROGRAM