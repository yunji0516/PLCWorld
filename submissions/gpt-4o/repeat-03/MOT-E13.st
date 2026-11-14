PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    (* Internal variables *)
    target_x : DINT;
    x_position : DINT;
    x_velocity : DINT;
    z_position : DINT;
    heading : DINT;
    heading_velocity : DINT;
    left_speed_command : REAL;
    right_speed_command : REAL;
    forward_speed : REAL;
    yaw_rate : REAL;
    completion_timer : TIME;
    completed : BOOL;
END_VAR

(* Initialize variables *)
target_x := D10 / 100;
x_position := D11 / 100;
x_velocity := D12 / 100;
z_position := D13 / 100;
heading := D15 / 100;
heading_velocity := D16 / 100;
completion_timer := T#0ms;
completed := FALSE;

(* Control logic *)
IF X10 THEN
    (* Compute control commands *)
    left_speed_command := REAL_TO_INT(3000.0 * (DINT(target_x) - DINT(x_position)) - DINT(z_position));
    right_speed_command := REAL_TO_INT(3000.0 * (DINT(target_x) - DINT(x_position)) + DINT(z_position));

    (* Limit the speed commands to prevent excessive outputs *)
    left_speed_command := LIMIT(-200000, INT(left_speed_command), 200000);
    right_speed_command := LIMIT(-200000, INT(right_speed_command), 200000);

    (* Calculate forward speed and yaw rate *)
    forward_speed := (left_speed_command + right_speed_command) / 2.0;
    yaw_rate := (right_speed_command - left_speed_command) / 600.0;

    (* Issue speed commands to wheels *)
    D20 := DINT(left_speed_command);
    D21 := DINT(right_speed_command);
    
    (* Check completion conditions *)
    IF (ABS(DINT(target_x) - x_position) <= 1) AND 
       (ABS(z_position) <= 2) AND 
       (ABS(heading) <= 0.3) AND 
       (ABS(x_velocity) <= 2) AND 
       (ABS(heading_velocity) <= 1) THEN
       
       (* Count time in completion state *)
       completion_timer := completion_timer + T#10ms;
       
       IF completion_timer >= T#30ms THEN
           completed := TRUE;
       END_IF
    ELSE
       completion_timer := T#0ms;
    END_IF

    (* Set function result retention state *)
    IF completed AND (completion_timer >= T#30ms) THEN
        Y2 := TRUE;
    END_IF
ELSE
    (* Ensure outputs are safe when not requested *)
    D20 := 0;
    D21 := 0;
    completion_timer := T#0ms;
    completed := FALSE;
    Y2 := FALSE;
END_IF

END_PROGRAM