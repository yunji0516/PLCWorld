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
    (* Add internal variables here. *)
    left_speed_command : REAL;
    right_speed_command : REAL;
    target_position : REAL;
    actual_position : REAL;
    actual_heading : REAL;
    error_x : REAL;
    error_z : REAL;
    error_heading : REAL;
    integrated_time : TIME;
    stable_time : TIME;
    max_wheel_command : DINT := 200000;
    gain_left : REAL := 1.0;
    gain_right : REAL := 0.98;
    scan_time : TIME := T#10ms;
    control_speed : REAL;
    control_heading : REAL;
    completion_time : TIME;
    result_retention_time : TIME;
    is_stable : BOOL;
    request_accepted : BOOL;
END_VAR

(* Implement the control logic here. *)
actual_position := REAL(D11) / 100.0;
actual_heading := REAL(D15) / 100.0;
target_position := REAL(D10) / 100.0;

error_x := target_position - actual_position;
error_z := REAL(D13) / 100.0;
error_heading := actual_heading;

IF X10 AND NOT request_accepted THEN
    request_accepted := TRUE;
    integrated_time := T#0ms;
    stable_time := T#0ms;
    Y2 := FALSE;
ENDIF

IF request_accepted THEN
    (* Compute control signals based on errors *)
    control_speed := error_x;
    control_heading := -error_heading;

    (* Calculate the wheel speed commands *)
    left_speed_command := control_speed - (control_heading * 300.0);
    right_speed_command := control_speed + (control_heading * 300.0);

    (* Apply gain and ensure the commands are within permitted bounds *)
    left_speed_command := gain_left * left_speed_command;
    right_speed_command := gain_right * right_speed_command;

    left_speed_command := LIMIT(left_speed_command, -REAL(max_wheel_command), REAL(max_wheel_command));
    right_speed_command := LIMIT(right_speed_command, -REAL(max_wheel_command), REAL(max_wheel_command));

    (* Update wheel speed commands *)
    D20 := DINT(left_speed_command * 100.0);
    D21 := DINT(right_speed_command * 100.0);

    (* Check if conditions for stability are met *)
    IF ABS(error_x) <= 1.0 AND ABS(error_z) <= 2.0 AND ABS(error_heading) <= 0.3 THEN
        IF ABS(REAL(D12) / 100.0) <= 2.0 AND ABS(REAL(D16) / 100.0) <= 1.0 THEN
            stable_time := stable_time + scan_time;
            IF stable_time >= T#30ms THEN
                is_stable := TRUE;
            END_IF
        ELSE
            stable_time := T#0ms;
            is_stable := FALSE;
        END_IF
    ELSE
        stable_time := T#0ms;
        is_stable := FALSE;
    END_IF

    (* If stable for 30ms, start result retention *)
    IF is_stable THEN
        Y2 := TRUE;
    END_IF

    (* Maintain the result retention condition for 100 ms *)
    IF Y2 THEN
        completion_time := completion_time + scan_time;
        IF completion_time >= T#100ms THEN
            request_accepted := FALSE;
        END_IF
    ELSE
        completion_time := T#0ms;
    END_IF
ELSE
    (* Release outputs if function request is not accepted *)
    D20 := 0;
    D21 := 0;
END_IF

END_PROGRAM