PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    D20 : INT;
    D21 : INT;
    startEdge : R_TRIG;
    pumpActive : BOOL := FALSE;
    oldMaterialVolume : INT := 20; (* Assume maximum possible old material based on range 4-20 mL *)
    residueRemoved : BOOL := FALSE;
    newMaterialRecovered : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

startEdge(CLK := X10);

IF startEdge.Q AND D10 = 2 THEN
    pumpActive := TRUE;
END_IF

IF pumpActive THEN
    IF oldMaterialVolume > 0 THEN
        Y20 := TRUE;
        oldMaterialVolume := oldMaterialVolume - 1; (* Pumping 10 mL/s reduces 1 mL per 10ms scan *)
    ELSE
        residueRemoved := TRUE;
    END_IF
    
    (* Check if the new material has reached the outlet *)
    IF residueRemoved THEN
        IF D20 = 2 THEN
            Y20 := FALSE;
            pumpActive := FALSE;
            newMaterialRecovered := TRUE;
        ELSIF D21 < 40 THEN
            Y20 := TRUE;
        ELSE
            Y20 := FALSE;
        END_IF
    END_IF 
END_IF

(* Completion logic *)
IF residueRemoved AND newMaterialRecovered THEN
    Y2 := TRUE;
END_IF

END_PROGRAM