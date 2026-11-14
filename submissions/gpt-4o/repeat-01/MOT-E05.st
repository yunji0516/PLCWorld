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

    // Internal variables
    markDetected : BOOL := FALSE;
    captureReady : BOOL := FALSE;
    positionCaptured : BOOL := FALSE;
    holdCounter : INT := 0;
    
    edgeMark : R_TRIG;
    edgeRequest : R_TRIG;
    timerHold : TON;
END_VAR

(* Implement the control logic here. *)

edgeMark(CLK := X12);
edgeRequest(CLK := X10);

IF edgeRequest.Q THEN
    captureReady := TRUE;
    Y20 := TRUE;
END_IF

IF captureReady AND edgeMark.Q THEN
    markDetected := TRUE;
    Y20 := FALSE;
END_IF

IF markDetected AND X11 THEN
    D20 := D14;
    Y21 := TRUE;
    positionCaptured := TRUE;
    markDetected := FALSE;
END_IF

IF positionCaptured THEN
    timerHold(IN := TRUE, PT := T#30ms);
    IF timerHold.Q THEN
        Y2 := TRUE;
        positionCaptured := FALSE;
        Y21 := FALSE;
    END_IF
END_IF

IF Y2 THEN
    holdCounter := holdCounter + 1;
    IF holdCounter >= 10 THEN
        Y2 := FALSE;
        captureReady := FALSE;
        holdCounter := 0;
    END_IF
END_IF

END_PROGRAM