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
    speed_request : REAL;
    actual_speed : REAL;
    acceleration_limit : REAL := 1800.0;
    response_coefficient : REAL := 1.0;
    error_margin : REAL := 2.0;
    time_counter : TIME := T#0ms;
    hold_time : TIME := T#250ms;
    within_error : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)
speed_request := REAL(D10) * 0.01;
actual_speed := REAL(D12) * 0.01;

// Check if the function is requested
IF X10 THEN
    // Calculate speed difference and apply acceleration limits
    IF ABS(speed_request - actual_speed) > error_margin THEN
        IF speed_request > actual_speed THEN
            actual_speed := actual_speed + MIN(acceleration_limit * response_coefficient * 0.01, ABS(speed_request - actual_speed));
        ELSE
            actual_speed := actual_speed - MIN(acceleration_limit * response_coefficient * 0.01, ABS(actual_speed - speed_request));
        END_IF
    ELSE
        within_error := TRUE;
    END_IF

    // Set outputs based on calculated speed and constraints
    D20 := DINT(actual_speed * 100);
    Y20 := TRUE;

    // Maintain the Y2 if within error margin for a minimum observe time
    IF within_error THEN
        time_counter := ADD_TIME(time_counter, T#10ms);
        IF time_counter >= hold_time THEN
            Y2 := TRUE;
        END_IF
    ELSE
        time_counter := T#0ms;
    END_IF
ELSE
    // Reset outputs when no function request
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    time_counter := T#0ms;
    within_error := FALSE;
END_IF

END_PROGRAM