PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;

    requested_position : DINT;
    requested_velocity : DINT;
    position_error : REAL;
    velocity_error : REAL;
    activate_trigger : R_TRIG;
    position_maintained : BOOL := FALSE;
    velocity_maintained : BOOL := FALSE;
    timer : TON;
END_VAR

(* Implement the control logic here. *)
activate_trigger(CLK := X10);

IF activate_trigger.Q THEN
    (* Calculate requested position and velocity commands *)
    requested_position := D13 + D10;
    requested_velocity := D12; (* Assuming U axis feeds from S axis speed *)
    
    (* Ensure the commands are within permitted limits *)
    D20 := LIMIT(-200000, requested_position, 200000);
    D21 := LIMIT(-200000, requested_velocity, 200000);

    (* Activate function *)
    Y20 := TRUE;
    
    (* Calculate position and velocity errors *)
    position_error := ABS((D11 + D10) - D13) * 0.01; (* Convert to mm *)
    velocity_error := ABS(D12 - D14) * 0.01; (* Convert to mm/s *)

    (* Check maintenance conditions for position and velocity *)
    position_maintained := position_error <= 0.3;
    velocity_maintained := velocity_error <= 2;
    
    IF position_maintained AND velocity_maintained THEN
        (* Start a timer to observe result retention for 250 ms *)
        timer(IN := TRUE, PT := T#250ms);
    ELSE
        (* Reset timer if conditions are not met *)
        timer(IN := FALSE);
    END_IF;

    (* Check if the result retention time is satisfied *)
    IF timer.Q THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;
ELSE
    (* Reset outputs if the request is not active *)
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
END_IF;

END_PROGRAM