PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    (* Internal variables *)
    requested : BOOL := FALSE;
    synchronized : BOOL := FALSE;
    timeout_timer : TON;
    completion_timer : TON;
END_VAR

(* Implement the control logic here. *)

(* Using the synchronous functionality and fork insertion *)
IF X10 THEN
    IF NOT requested THEN
        requested := TRUE;
        timeout_timer(IN := TRUE, PT := T#3440ms);
        completion_timer(IN := FALSE);
    END_IF
END_IF

IF requested THEN
    IF (ABS(D13 - D11) <= DINT(20)) AND (ABS(D14 - D12) <= DINT(100)) THEN
        synchronized := TRUE;
    ELSE
        synchronized := FALSE;
    END_IF

    (* Set the output position and speed commands *)
    D20 := D13;
    D21 := D14;
    
    IF synchronized THEN
        Y20 := TRUE;
        Y21 := TRUE;   (* Fork insertion command *)
    ELSE
        Y20 := FALSE;
        Y21 := FALSE;  (* Fork retraction command if needed *)
    END_IF

    (* Monitor task completion *)
    IF X11 AND synchronized THEN
        completion_timer(IN := TRUE, PT := T#100ms);
    ELSE
        completion_timer(IN := FALSE);
    END_IF

    (* Output task completion signal *)
    IF completion_timer.Q THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF

    (* Timeout handling *)
    IF timeout_timer.Q THEN
        requested := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
    END_IF
ELSE
    (* Reset outputs and timers when no request *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    timeout_timer(IN := FALSE);
    completion_timer(IN := FALSE);
END_IF

END_PROGRAM