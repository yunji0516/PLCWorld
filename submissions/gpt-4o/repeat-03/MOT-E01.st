PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    (* Add internal variables here. *)
    target_position : DINT;
    position_error : DINT;
    speed : DINT;
    stabilized_timer : TON;
    observation_timer : TON;
    request_accepted : BOOL := FALSE;
    command_active : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)
IF X10 THEN
    (* Accept request and compute target position *)
    target_position := D10;
    
    (* Validate command range *)
    IF (target_position >= -350 * 100) AND (target_position <= 450 * 100) THEN
        request_accepted := TRUE;
    ELSE
        request_accepted := FALSE;
    END_IF;
END_IF;

IF request_accepted THEN
    (* Calculate position error and speed *)
    position_error := ABS(D11 - target_position);
    speed := D12;
    
    (* Activate the drive only if command range is valid *)
    IF NOT command_active THEN
        Y20 := TRUE;
        command_active := TRUE;
    END_IF;
    
    (* Provide main command to move to the target position *)
    D20 := target_position;
    
    (* Check conditions to maintain position and speed within limits *)
    IF (position_error <= 20) AND (speed <= 100) THEN
        stabilized_timer(IN := TRUE, PT := T#30ms);
    ELSE
        stabilized_timer(IN := FALSE);
    END_IF;

    IF stabilized_timer.Q THEN
        Y2 := TRUE;
        observation_timer(IN := TRUE, PT := T#100ms);
    ELSE
        observation_timer(IN := FALSE);
    END_IF;

    (* Complete the execution when observation timer reaches the PT *)
    IF observation_timer.Q THEN
        Y20 := FALSE;
        command_active := FALSE;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
END_IF;

END_PROGRAM