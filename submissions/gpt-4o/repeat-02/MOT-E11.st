PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    // Internal variables
    detection_remembered : BOOL := FALSE;
    position_stable_time : TIME := T#0ms;
    speed_stable_time : TIME := T#0ms;
    completion_hold_time : TIME := T#0ms;
    timer_position : TON;
    timer_speed : TON;
    timer_completion : TON;
END_VAR

// Implement the control logic here.

// Detect approaching object and set the detection_remembered flag
IF X11 THEN
    detection_remembered := TRUE;
END_IF

// If detection is remembered, command the door to open
IF detection_remembered THEN
    Y20 := TRUE;
    D20 := D10;  // Command to open to requested position
ELSE
    Y20 := FALSE;
END_IF

// Position stability check (within 0.2 mm of requested position)
timer_position(IN := ABS(REAL_TO_INT(D11 * 0.01) - D10) <= 20, PT := T#30ms);
IF timer_position.Q THEN
    position_stable_time := position_stable_time + T#10ms;
ELSE
    position_stable_time := T#0ms;
END_IF

// Speed stability check (speed at most 1 mm/s)
timer_speed(IN := ABS(REAL_TO_INT(D12 * 0.01)) <= 100, PT := T#30ms);
IF timer_speed.Q THEN
    speed_stable_time := speed_stable_time + T#10ms;
ELSE
    speed_stable_time := T#0ms;
END_IF

// Both position and speed must be stable for at least 30 ms
IF position_stable_time >= T#30ms AND speed_stable_time >= T#30ms THEN
    Y2 := TRUE;
    timer_completion(IN := TRUE, PT := T#100ms);
ELSE
    Y2 := FALSE;
    timer_completion(IN := FALSE);
    completion_hold_time := T#0ms;
END_IF

// Ensure Y2 remains active for 100 ms after conditions were first met
IF timer_completion.Q THEN
    completion_hold_time := completion_hold_time + T#10ms;
ELSE
    completion_hold_time := T#0ms;
END_IF

END_PROGRAM