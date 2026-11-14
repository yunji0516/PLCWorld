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
    swayReductionTimer : TON;
    resultRetentionTimer : TON;
    requestAccepted : BOOL;
    swayWithinLimit : BOOL;
    positionWithinLimit : BOOL;
    swayAngle : REAL;
    trolleySpeed : REAL;
END_VAR

(* Calculate the sway angle and trolley speed in real units. *)
swayAngle := REAL(D15) * 0.01; (* Convert from DINT deg*100 to deg *)
trolleySpeed := REAL(D14) * 0.01; (* Convert from DINT mm/s*100 to mm/s *)

(* Initialize the timers *)
swayReductionTimer(IN := FALSE, PT := T#30ms);
resultRetentionTimer(IN := FALSE, PT := T#100ms);

(* Process request acceptance *)
IF X10 THEN
    requestAccepted := TRUE;
END_IF

(* Control logic for the sway reduction and trolley positioning *)
IF requestAccepted THEN
    IF ABS(swayAngle) <= 0.2 AND ABS(REAL(D16) * 0.01) <= 1.0 THEN
        (* Sway is within limit, maintain current state *)
        swayWithinLimit := TRUE;
    ELSE
        (* Adjust acceleration to reduce sway *)
        IF swayAngle > 0 THEN
            D20 := DINT(-1800); (* Apply negative acceleration to counteract positive sway *)
        ELSE
            D20 := DINT(1800); (* Apply positive acceleration to counteract negative sway *)
        END_IF
        swayWithinLimit := FALSE;
    END_IF
    
    IF ABS(D13 - D10) <= 100 AND ABS(trolleySpeed) <= 1 THEN
        (* Position is within limit *)
        positionWithinLimit := TRUE;
    ELSE
        (* Adjust trolley position if necessary *)
        IF D13 > D10 THEN
            D20 := DINT(-1800); (* Move trolley left to reach target *)
        ELSE
            D20 := DINT(1800); (* Move trolley right to reach target *)
        END_IF
        positionWithinLimit := FALSE;
    END_IF
    
    (* Check if final conditions are met *)
    IF swayWithinLimit AND positionWithinLimit THEN
        (* Stop movement when conditions are met *)
        D20 := 0;
        swayReductionTimer(IN := TRUE);
    ELSE
        swayReductionTimer(IN := FALSE);
    END_IF
    
    IF swayReductionTimer.Q THEN
        (* Maintain result and start retention timer *)
        Y2 := TRUE;
        resultRetentionTimer(IN := TRUE);
    END_IF
ELSE
    (* Reset all actions if request is not accepted *)
    D20 := 0;
    Y2 := FALSE;
    swayReductionTimer(IN := FALSE);
    resultRetentionTimer(IN := FALSE);
END_IF

(* Observation of result retention *)
IF resultRetentionTimer.Q THEN
    (* End execution and maintain outputs *)
    Y2 := FALSE; (* Could adjust this based on further task requirements *)
    (* Additional logic may be implemented to reset state or proceed accordingly *)
END_IF

END_PROGRAM