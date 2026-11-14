PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    requested_speed : DINT := 0;
    speed_difference : DINT;
    target_speed : DINT;
    reached_speed_accuracy : BOOL := FALSE;
    target_achieved_timer : TON;
    result_hold_timer : TON;
    edge_trigger : R_TRIG;
END_VAR

(* Edge detection for function request *)
edge_trigger(CLK := X10);

(* Calculate requested speed from D10 (commanded speed) *)
IF X10 THEN
    target_speed := D10;
    Y20 := TRUE;
ELSE
    target_speed := 0;
    Y20 := FALSE;
END_IF

(* Limit the desired speed to within command boundaries *)
target_speed := LIMIT(-200000, 200000, target_speed);

(* Calculate speed difference and response *)
speed_difference := target_speed - D12;

(* Acceleration limited to 1800 deg/s² scaled down *)
IF speed_difference > 0 THEN
    requested_speed := D12 + MIN(DINT(1800 * 0.75), speed_difference);
ELSIF speed_difference < 0 THEN
    requested_speed := D12 + MAX(DINT(-1800 * 0.75), speed_difference);
END_IF

(* Set the D20 to the calculated next speed *)
D20 := requested_speed;

(* Check if the actual speed is within ±2 deg/s of requested speed *)
reached_speed_accuracy := ABS(speed_difference) <= 200;

(* Maintain stability after achieving the target speed *)
target_achieved_timer(IN := reached_speed_accuracy, PT := T#30ms);
IF target_achieved_timer.Q THEN
    IF NOT Y2 THEN
        result_hold_timer(IN := TRUE, PT := T#250ms);
    END_IF
    Y2 := result_hold_timer.Q;
ELSE
    result_hold_timer(IN := FALSE);
    result_hold_timer.Q := FALSE;
    Y2 := FALSE;
END_IF

END_PROGRAM