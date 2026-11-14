```iec
PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    target_reached : BOOL := FALSE;
    rotation_angle : DINT := 90;
    second_rotation_angle : DINT := 270;
    return_target : DINT := 200;
    safety_zone_1_start_x : DINT := -200;
    safety_zone_1_end_x : DINT := 350;
    safety_zone_1_start_y : DINT := -45;
    safety_zone_1_end_y : DINT := 45;
    safety_zone_2_start_x : DINT := 350;
    safety_zone_2_end_x : DINT := 650;
    safety_zone_2_start_y : DINT := -150;
    safety_zone_2_end_y : DINT := 150;
    safety_zone_3_start_x : DINT := 455;
    safety_zone_3_end_x : DINT := 545;
    safety_zone_3_start_y : DINT := 150;
    safety_zone_3_end_y : DINT := 650;

    timer : TON;
    motion_disable_edge : R_TRIG;
END_VAR

(* Enable Modules only when start signal X0 is true *)
IF X0 THEN
    Y20 := TRUE;
    Y21 := TRUE;
    CASE state OF
        0: (* Move to requested target and rotate to 90 degrees *)
            D20 := D101;
            D21 := 1000; (* 100% speed *)
            D24 := rotation_angle * 100; (* Convert degree to scaled value *)
            D25 := 1000; (* 100% speed *)
            
            IF ABS(D10 - D101) <= 20 AND ABS(D11) <= 100 THEN
                target_reached := TRUE;
            END_IF
            
            IF target_reached AND ABS(D12 - rotation_angle * 100) <= 20 AND ABS(D13) <= 100 THEN
                target_reached := FALSE;
                state := 1;
            END_IF

        1: (* Return to start position and rotate to 0 degrees *)
            D20 := return_target;
            D21 := 1000; (* 100% speed *)
            D24 := 0;
            D25 := 1000; (* 100% speed *)

            IF ABS(D10 - return_target) <= 20 AND ABS(D11) <= 100 THEN
                target_reached := TRUE;
            END_IF

            IF target_reached AND ABS(D12 - 0) <= 20 AND ABS(D13) <= 100 THEN
                target_reached := FALSE;
                state := 2;
            END_IF

        2: (* Maintain completion and validate time condition *)
            Y2 := TRUE;
            timer(IN := TRUE, PT := T#1500ms);
            IF timer.Q THEN
                Y20 := FALSE;
                Y21 := FALSE;
                Y2 := FALSE;
                state := 0;
            END_IF
    END_CASE;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    state := 0;
END_IF

(* Safety checks for keeping the head inside permitted zones *)
motion_disable_edge(CLK := NOT Edge_on_safety_vector_violation(D10, D12, D101));
IF motion_disable_edge.Q THEN
    Y20 := FALSE;
    Y21 := FALSE;
END_IF

FUNCTION Edge_on_safety_vector_violation : BOOL
VAR_INPUT
    pos_a : DINT;
    pos_b : DINT;
    req_tgt : DINT;
END_VAR
BEGIN
    (* Check if head center falls outside permitted zones *)
    Edge_on_safety_vector_violation := 
        (pos_a < safety_zone_1_start_x OR pos_a > safety_zone_1_end_x OR
         (pos_a <= 500 AND ((safety_zone_1_start_y <= 0) AND (0 <= safety_zone_1_end_y))) OR
         ((pos_a > 500) AND (safety_zone_2_start_x <= pos_a - 500) AND 
         (pos_a - 500 <= safety_zone_2_end_x) AND NOT 
         ((safety_zone_2_start_y <= pos_b) AND (pos_b <= safety_zone_2_end_y)))) OR
        ((pos_a > 500) AND (safety_zone_3_start_x <= pos_a) AND 
         (pos_a <= safety_zone_3_end_x) AND NOT 
         (safety_zone_3_start_y <= pos_b) AND (pos_b <= safety_zone_3_end_y));
END_FUNCTION

END_PROGRAM
```