PROGRAM Main
VAR
    X10 : BOOL; (* Function request. *)
    D11 : DINT; (* S actual position · mm ×0.01. *)
    D12 : DINT; (* S actual speed · mm/s ×0.01. *)
    D13 : DINT; (* Stop limit position ×0.01. *)
    Y20 : BOOL; (* Function activation/retention. *)
    D20 : DINT; (* Deceleration command ×0.01 mm/s². *)
    Y2 : BOOL;  (* Function result retention. *)

    (* Internal variables *)
    current_position : REAL;
    current_speed : REAL;
    stop_limit : REAL;
    deceleration_rate : REAL;
    speed_limit_reached : BOOL := FALSE;
    stop_timer : TON;
    maintain_timer : TON;
    init : BOOL := TRUE;
END_VAR

(* Convert fixed-point values to real for calculations *)
current_position := REAL(D11) * 0.01;
current_speed := REAL(D12) * 0.01;
stop_limit := REAL(D13) * 0.01;

(* Main logic *)
IF X10 THEN
    IF init THEN
        Y20 := TRUE;
        deceleration_rate := 60.0; (* Example deceleration, must be tuned *)
        D20 := DINT(deceleration_rate * 100.0); (* Convert to output scaling *)
        init := FALSE;
    END_IF

    IF current_speed <= 1.0 THEN
        speed_limit_reached := TRUE;
    ELSE
        speed_limit_reached := FALSE;
    END_IF
    
    IF speed_limit_reached THEN
        stop_timer(IN := TRUE, PT := T#30ms);
    ELSE
        stop_timer(IN := FALSE);
    END_IF
    
    IF stop_timer.Q THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF
    
    IF Y2 THEN
        maintain_timer(IN := TRUE, PT := T#100ms);
    ELSE
        maintain_timer(IN := FALSE);
    END_IF

    IF maintain_timer.Q THEN
        Y20 := FALSE;
        D20 := 0; (* Stop deceleration command *)
    END_IF
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    init := TRUE;
END_IF

END_PROGRAM