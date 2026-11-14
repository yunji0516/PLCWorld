PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL;
    Y2 : BOOL;

    (* Internal variables *)
    requestAccepted : BOOL := FALSE;
    brakeEngaged : BOOL := FALSE;
    heightMaintained : BOOL := FALSE;
    initialHeight : DINT := 0;
    maintainTime : TIME := T#0ms;
    resultTime : TIME := T#0ms;

    engagementEdge : R_TRIG;
    maintainTimer : TON;
    resultTimer : TON;
END_VAR

(* Implement the control logic here *)

(* Detection of function request acceptance *)
IF X10 THEN
    requestAccepted := TRUE;
    initialHeight := D11; (* Capture the initial height *)
END_IF

(* Start engaging the brake when the function is requested *)
IF requestAccepted THEN
    Y20 := TRUE; (* Activate brake engagement *)

    (* Check for brake engagement and loss of external torque support *)
    IF X11 AND NOT X12 THEN
        brakeEngaged := TRUE;
        (* Monitor the maintenance of height within ±0.2mm *)
        IF ABS(D11 - initialHeight) <= 20 THEN
            IF NOT heightMaintained THEN
                maintainTimer(IN := TRUE, PT := T#30ms);
                heightMaintained := maintainTimer.Q;
            END_IF
        ELSE
            heightMaintained := FALSE; (* Reset if height is not maintained within the range *)
            maintainTimer(IN := FALSE);
        END_IF
    ELSE
        brakeEngaged := FALSE;
        heightMaintained := FALSE;
        maintainTimer(IN := FALSE);
    END_IF

    (* Confirm overall function result retention *)
    IF heightMaintained AND brakeEngaged THEN
        IF NOT Y2 THEN
            resultTimer(IN := TRUE, PT := T#100ms);
            Y2 := resultTimer.Q;
        END_IF
    ELSE
        Y2 := FALSE;
        resultTimer(IN := FALSE);
    END_IF
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    requestAccepted := FALSE;
    brakeEngaged := FALSE;
    heightMaintained := FALSE;
    maintainTimer(IN := FALSE);
    resultTimer(IN := FALSE);
END_IF

END_PROGRAM