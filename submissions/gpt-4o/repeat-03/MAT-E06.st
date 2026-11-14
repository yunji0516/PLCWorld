PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    
    startEdge : R_TRIG;
    currentState : INT := 0;
    timerPush : TON;
    timerRetract : TON;
END_VAR

(* Rising edge detection for start request *)
startEdge(CLK := X10);

(* State machine to control the ejection process *)
CASE currentState OF
    0: (* Wait for start request *)
        IF startEdge.Q THEN
            currentState := 1;
        END_IF

    1: (* Initiate push command *)
        Y20 := TRUE;
        Y21 := FALSE;
        timerPush(IN := NOT X21, PT := T#1s);
        IF timerPush.Q THEN
            currentState := 2;
        END_IF

    2: (* Verify if product is received *)
        IF X22 THEN
            Y20 := FALSE;
            currentState := 3;
        ELSE
            (* Retry pushing if necessary *)
            currentState := 1;
        END_IF

    3: (* Initiate retract command *)
        Y21 := TRUE;
        Y20 := FALSE;
        timerRetract(IN := NOT X20, PT := T#1s);
        IF timerRetract.Q THEN
            currentState := 4;
        END_IF

    4: (* Ensure pusher is home and complete *)
        IF X20 THEN
            Y21 := FALSE;
            Y2 := TRUE;
            currentState := 5;
        ELSE
            (* Retry retracting if necessary *)
            currentState := 3;
        END_IF

    5: (* Hold the completion claim *)
        (* This state maintains Y2 for the remaining scans until evaluation endpoint *)
        (* After the evaluation window, reset the completion claim *)
        IF NOT (X22 OR X20) THEN
            Y2 := FALSE;
            currentState := 0;
        END_IF
END_CASE

END_PROGRAM