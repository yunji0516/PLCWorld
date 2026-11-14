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
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    (* Internal variables *)
    target_position_c : DINT;
    target_velocity_c : DINT;
    orientation_error : REAL;
    orientation_angle : REAL;
    wrist_enabled : BOOL := FALSE;
    stability_timer : TON;
    completed : BOOL := FALSE;
    scans : INT := 0;
END_VAR

(* Implement the control logic here. *)
stability_timer(IN := FALSE, PT := T#30ms);

(* Calculate the current tool orientation angle A+B+C *)
orientation_angle := REAL(D13 + D15 + D11) * 0.01;

(* Calculate orientation error in degrees *)
orientation_error := -orientation_angle;  (* Target orientation is 0 degrees *)

(* Enable function if request is accepted *)
IF X10 THEN
    wrist_enabled := TRUE;
END_IF

(* Maintain tool orientation using wrist command values when the function is enabled *)
IF wrist_enabled AND NOT completed THEN
    (* Calculate the target position and velocity to correct orientation error *)
    target_position_c := D11 + DINT(REAL_TO_INT(orientation_error * 100.0));
    target_velocity_c := -D12 - DINT(REAL_TO_INT((REAL(D14) + REAL(D16)) * 0.5));

    (* Ensure command values are within permitted range *)
    target_position_c := LIMIT(-200000, 200000, target_position_c);
    target_velocity_c := LIMIT(-200000, 200000, target_velocity_c);

    (* Publish wrist target and feedforward velocity *)
    D20 := target_position_c;
    D21 := target_velocity_c;

    (* Set function activation output *)
    Y20 := TRUE;

    (* Check if the orientation is within the ±2° range for stability *)
    IF ABS(orientation_error) <= 2.0 THEN
        stability_timer(IN := TRUE);
        IF stability_timer.Q THEN
            Y2 := TRUE;  (* Assert function result retention *)
            completed := TRUE;
        END_IF
    ELSE
        stability_timer(IN := FALSE);
    END_IF

    scans := scans + 1;
    IF scans >= (450 / 10) THEN (* Check for deadline violation *)
        wrist_enabled := FALSE;  (* Disable wrist if deadline is missed *)
    END_IF
ENDIF

(* Maintain result retention for observation interval *)
IF completed THEN
    IF scans >= ((450 + 1300) / 10) THEN
        Y20 := FALSE;  (* Disable wrist command *)
        Y2 := FALSE;
    ELSE
        Y2 := TRUE;  (* Maintain result retention *)
    END_IF
END_IF

END_PROGRAM