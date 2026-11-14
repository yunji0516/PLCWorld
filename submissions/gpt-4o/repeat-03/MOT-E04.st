PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    (* Internal variables *)
    requestedSpeed : REAL;
    actualSpeed : REAL;
    speedError : REAL;
    targetSpeed : REAL;
    maintainedTime : TIME;
    responseCoefficient : REAL := 1.0;
    timerY2 : TON;
    timerCompletion : TON;
    triggerY2 : R_TRIG;
    isRequestValid : BOOL;
END_VAR

(* Implement the control logic here. *)

IF X10 THEN
    (* Calculate the requested speed in real terms *)
    requestedSpeed := REAL(D10) / 100.0;
    
    (* Limit the target speed to the allowed range *)
    IF requestedSpeed < -300.0 THEN
        targetSpeed := -300.0;
    ELSIF requestedSpeed > 480.0 THEN
        targetSpeed := 480.0;
    ELSE
        targetSpeed := requestedSpeed;
    END_IF;
    
    (* Enable the shaft drive command *)
    Y20 := TRUE;
    
    (* Calculate actual speed *)
    actualSpeed := REAL(D12) / 100.0;
    
    (* Calculate speed error *)
    speedError := ABS(actualSpeed - targetSpeed);
    
    (* Check if the speed error is within acceptable limits *)
    isRequestValid := (speedError <= 2.0);
    
    IF isRequestValid THEN
        (* Enable function result retention timer *)
        triggerY2(CLK := isRequestValid);
        IF triggerY2.Q THEN
            timerY2(IN := TRUE, PT := T#30ms);
        ELSE
            timerY2(IN := FALSE);
        END_IF;
        
        (* Check if the speed is maintained for the required duration *)
        IF timerY2.Q THEN
            Y2 := TRUE;
            timerCompletion(IN := TRUE, PT := T#250ms);
        ELSE
            Y2 := FALSE;
            timerCompletion(IN := FALSE);
        END_IF;
    ELSE
        Y2 := FALSE;
        timerY2(IN := FALSE);
        timerCompletion(IN := FALSE);
    END_IF;
    
    (* Set the command speed considering response coefficient *)
    D20 := DINT(targetSpeed * responseCoefficient * 100.0);
    
ELSE
    (* If the function request is not active, reset drive and outputs *)
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    timerY2(IN := FALSE);
    timerCompletion(IN := FALSE);
END_IF;

END_PROGRAM