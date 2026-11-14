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
    targetPosition : DINT;
    difference : REAL;
    isActive : BOOL := FALSE;
    stableTime : TIME := T#0ms;
    completionTime : TIME := T#0ms;
    requestAccepted : BOOL := FALSE;
    boomRetracted : BOOL := FALSE;
    stableTimer : TON;
    completionTimer : TON;
END_VAR

(* Implement the control logic. *)
IF X10 THEN
    IF NOT requestAccepted THEN
        targetPosition := D10;
        requestAccepted := TRUE;
    END_IF

    difference := REAL(ABS(D11 - targetPosition));
    
    IF NOT isActive THEN
        isActive := TRUE;
        Y20 := TRUE;
    END_IF

    IF INT_TO_REAL(D12) <= 1.0 AND difference <= 0.2 THEN
        IF NOT boomRetracted THEN
            stableTimer(IN := TRUE, PT := T#30ms);
            IF stableTimer.Q THEN
                boomRetracted := TRUE;
                stableTime := T#0ms; (* Reset stable time once retracted *)
            END_IF
        END_IF
    ELSE
        boomRetracted := FALSE;
        stableTimer(IN := FALSE);
    END_IF

    IF boomRetracted THEN
        completionTimer(IN := TRUE, PT := T#100ms);
        IF completionTimer.Q THEN
            Y2 := TRUE;
        END_IF
    ELSE
        completionTimer(IN := FALSE);
    END_IF

ELSE
    requestAccepted := FALSE;
    isActive := FALSE;
    Y20 := FALSE;
    boomRetracted := FALSE;
    stableTimer(IN := FALSE);
    completionTimer(IN := FALSE);
    Y2 := FALSE;
END_IF

(* Control D20 to achieve the target position within allowable range *)
IF requestAccepted THEN
    IF D11 < targetPosition THEN
        D20 := MIN(200000, targetPosition - D11);
    ELSIF D11 > targetPosition THEN
        D20 := MAX(-200000, targetPosition - D11);
    ELSE
        D20 := 0;
    END_IF
ELSE
    D20 := 0;
END_IF

END_PROGRAM