PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    Y20 : BOOL := FALSE;
    D20 : DINT := 0;
    Y2 : BOOL := FALSE;
    (* Add internal variables here. *)
    stop_requested : BOOL := FALSE;
    deceleration_started : BOOL := FALSE;
    target_reached : BOOL := FALSE;
    hold_timer : TON;
    stop_timer : TON;
END_VAR

(* Implement the control logic here. *)

(* Detect function request signal *)
IF X10 THEN
    Y20 := TRUE;

    (* Check for stop request *)
    IF X10 AND NOT stop_requested THEN
        stop_requested := TRUE;
        deceleration_started := FALSE;
        hold_timer(IN := FALSE, PT := T#30ms);
        stop_timer(IN := FALSE, PT := T#100ms);
    END_IF

    (* Begin deceleration if stop is requested and not yet started *)
    IF stop_requested AND NOT deceleration_started THEN
        IF D12 > 10 OR D12 < -10 THEN (* Speed > 0.1 mm/s *)
            deceleration_started := TRUE;
            (* Calculate deceleration needed to stop before the limit *)
            IF D12 > 0 THEN
                D20 := MIN(600000, (D12 * D12) / (2 * (D13 - D11)));
            ELSE
                D20 := MIN(600000, (D12 * D12) / (2 * (D11 - D13)));
            END_IF
        ELSE
            D20 := 0;
        END_IF
    END_IF

    (* Maintain deceleration command if within safe bounds *)
    IF deceleration_started THEN
        IF (D11 >= D13 AND D12 >= 0) OR (D11 <= D13 AND D12 <= 0) OR ABS(D12) <= 10 THEN
            D20 := 0;
            target_reached := TRUE;
        END_IF
    END_IF

    (* Monitor if the target is reached and maintain speed <= 1mm/s for at least 30ms *)
    IF target_reached THEN
        hold_timer(IN := TRUE);
        IF hold_timer.Q THEN
            stop_timer(IN := TRUE);
        END_IF
    END_IF

    (* Completion condition: Maintain result hold for 100ms *)
    IF stop_timer.Q THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF

ELSE
    (* Reset all outputs when canceling request *)
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    stop_requested := FALSE;
    deceleration_started := FALSE;
    target_reached := FALSE;
    hold_timer(IN := FALSE);
    stop_timer(IN := FALSE);
END_IF

END_PROGRAM