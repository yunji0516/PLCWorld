PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    D14 : DINT;
    X12 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    edgeMarkDetection : R_TRIG;
    requestProcessed : BOOL := FALSE;
    captureConfirmed: BOOL := FALSE;
    holdCounter: INT := 0;
    resultHoldCounter: INT := 0;
END_VAR

(* Implement the control logic here. *)
edgeMarkDetection(CLK := X12);

IF X10 THEN
    (* Start Function Activation *)
    Y20 := TRUE;
    
    IF edgeMarkDetection.Q THEN
        requestProcessed := FALSE;
    END_IF

    IF NOT requestProcessed THEN
        IF X11 THEN
            (* Capture Valid, Record position and confirm *)
            D20 := D14;
            Y21 := TRUE;
            captureConfirmed := TRUE;
            requestProcessed := TRUE;
            holdCounter := 0; (* Reset hold counter *)
        END_IF
    END_IF

    IF captureConfirmed THEN
        holdCounter := holdCounter + 1;
        
        IF holdCounter = 3 THEN (* After maintaining for 30 ms *)
            Y2 := TRUE;
        END_IF

        IF Y2 THEN
            resultHoldCounter := resultHoldCounter + 1;
            
            IF resultHoldCounter = 10 THEN (* After 100 ms of observation *)
                (* End execution by resetting outputs *)
                Y20 := FALSE;
                Y21 := FALSE;
                captureConfirmed := FALSE;
                Y2 := FALSE;
                resultHoldCounter := 0;
            END_IF
        END_IF
    END_IF

ELSE
    (* Reset functionality if no request *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    requestProcessed := FALSE;
    captureConfirmed := FALSE;
    holdCounter := 0;
    resultHoldCounter := 0;
END_IF

END_PROGRAM