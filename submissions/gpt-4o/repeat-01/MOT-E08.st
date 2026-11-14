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
    (* Add internal variables here. *)
    requested_position : DINT;
    requested_velocity : DINT;
    position_error : REAL;
    velocity_error : REAL;
    reference_position : DINT;
    reference_velocity : DINT;
    position_met : BOOL;
    velocity_met : BOOL;
    retention_start_time : TIME;
    retention_met : BOOL;
    function_active : BOOL := FALSE;
    request_processed : BOOL := FALSE;
    trigger_edge : R_TRIG; (* To detect rising edge of X10 *)
END_VAR

(* Implement the control logic here. *)

trigger_edge(CLK := X10);

IF trigger_edge.Q THEN
    function_active := TRUE;
    request_processed := FALSE;
    retention_met := FALSE;
    position_met := FALSE;
    velocity_met := FALSE;
END_IF

IF function_active THEN
    (* Calculate the target command position and translational velocity *)
    reference_position := D13 + D10;
    reference_velocity := D12 + (D10 / 10);

    (* Ensure commanded values are within the permitted range *)
    requested_position := LIMIT(-200000, reference_position, 200000);
    requested_velocity := LIMIT(-200000, reference_velocity, 200000);

    (* Output command position and velocity *)
    D20 := requested_position;
    D21 := requested_velocity;

    (* Calculate the position and velocity errors *)
    position_error := ABS(INT_TO_REAL(D13) + D10 - INT_TO_REAL(D11)) * 0.01;
    velocity_error := ABS(INT_TO_REAL(D14) - requested_velocity * 0.01);

    (* Check if position and velocity requirements are met *)
    position_met := position_error <= 0.3;
    velocity_met := velocity_error <= 2;

    (* Activate the function and prepare for retention check *)
    IF position_met AND velocity_met THEN
        IF NOT retention_met THEN
            retention_start_time := TIME(); (* Current time tracking *)
            retention_met := TRUE;
        ELSE
            IF (TIME() - retention_start_time) >= T#30ms THEN
                Y20 := TRUE;
                Y2 := TRUE;
                IF (TIME() - retention_start_time) >= T#250ms THEN
                    function_active := FALSE;
                END_IF
            END_IF
        END_IF
    ELSE
        retention_met := FALSE;
    END_IF
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
END_IF

END_PROGRAM