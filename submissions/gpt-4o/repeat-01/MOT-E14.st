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
    Y2 : BOOL;
    (* Add internal variables here. *)
    swayReductionActive : BOOL := FALSE;
    completionTimer : TON;
    retentionTimer : TON;
    requestAccepted : BOOL := FALSE;
    functionRequested : BOOL;
    swayPosition : REAL;
    swayVelocity : REAL;
    trolleyPosition : REAL;
    trolleySpeed : REAL;
    targetPosition : REAL;
END_VAR

(* Implement the control logic here. *)

(* Edge detection for function request. *)
functionRequested := X10 AND NOT requestAccepted;
requestAccepted := X10;

IF functionRequested THEN
    swayReductionActive := TRUE;
END_IF

IF swayReductionActive THEN
    (* Convert inputs from DINT to REAL for internal calculation. *)
    swayPosition := REAL(D15) * 0.01;
    swayVelocity := REAL(D16) * 0.01;
    trolleyPosition := REAL(D13) * 0.01;
    trolleySpeed := REAL(D14) * 0.01;
    targetPosition := REAL(D10) * 0.01;
    
    (* Sway reduction logic: reduce sway and stop trolley. *)
    IF ABS(swayPosition) <= 0.2 AND ABS(swayVelocity) <= 1.0 AND 
       ABS(trolleyPosition - targetPosition) <= 1.0 AND 
       ABS(trolleySpeed) <= 1.0 THEN
        (* Begin completion observation and retention countdown. *)
        completionTimer(IN := TRUE, PT := T#30ms);
        IF completionTimer.Q THEN
            retentionTimer(IN := TRUE, PT := T#100ms);
            IF retentionTimer.Q THEN
                Y2 := TRUE; (* Set function result retention true after observing result retention. *)
            END_IF
        END_IF
    ELSE
        (* Command calculations based on sway and speed, simplified example. *)
        D20 := 0; (* Set acceleration to zero once conditions are met. *)
    END_IF
END_IF

(* Ensure that the command respects bounds in every cycle. *)
D20 := LIMIT(-200000, D20, 200000);

(* Ensure Y2 is maintained after 30ms observation time. *)
IF NOT retentionTimer.Q THEN
    Y2 := FALSE;
END_IF

(* Reset logic when X10 goes low (function request off). *)
IF NOT X10 THEN
    swayReductionActive := FALSE;
    requestAccepted := FALSE;
    completionTimer(IN := FALSE);
    retentionTimer(IN := FALSE);
    Y2 := FALSE;
END_IF

END_PROGRAM