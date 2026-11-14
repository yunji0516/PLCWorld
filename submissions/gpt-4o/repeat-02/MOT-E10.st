PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    requested_angle : REAL;
    actual_angle : REAL;
    actual_speed : REAL;
    target_angle : REAL;
    error : REAL;
    tolerance_reached : BOOL := FALSE;
    timer1 : TON;
    timer2 : TON;
END_VAR

(* Convert DINT to REAL for requested angle *)
requested_angle := REAL(D10) * 0.01;

(* Convert DINT to REAL for actual position and speed *)
actual_angle := REAL(D11) * 0.01;
actual_speed := REAL(D12) * 0.01;

(* Control logic *)
IF X10 THEN
    (* Apply the command with the function activation *)
    Y20 := TRUE;
    D20 := D10;

    (* Calculate error *)
    error := ABS(target_angle - actual_angle);
    
    (* Check if within tolerance *)
    IF (error <= 0.2) AND (ABS(actual_speed) <= 1.0) THEN
        tolerance_reached := TRUE;
        Y2 := TRUE;
    ELSE
        tolerance_reached := FALSE;
    END_IF

    (* Manage timers for completion *)
    timer1(IN := tolerance_reached, PT := T#30ms);
    timer2(IN := timer1.Q, PT := T#100ms);

    (* Check for sequence completion *)
    IF timer2.Q THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF
ELSE
    (* Deactivate function and reset outputs when request is not active *)
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    tolerance_reached := FALSE;
    timer1(IN := FALSE);
    timer2(IN := FALSE);
END_IF

END_PROGRAM