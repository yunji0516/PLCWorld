PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    targetPosition : INT;
    done : BOOL := FALSE;
    withinError : BOOL := FALSE;
    withinSpeed : BOOL := FALSE;
    targetAcceptedTime : TIME;
    observationStartTime : TIME;
    timer : TON;
END_VAR

(* Implement the control logic here. *)
targetPosition := D10; (* Convert request multiplied by 0.01 to position in mm *)

(* Activate function if request is accepted *)
IF X10 AND NOT done THEN
    Y20 := TRUE;
    
    (* Calculate difference between actual and target position *)
    IF ABS(D11 - targetPosition) <= 20 THEN (* 0.2 mm error tolerance converted to 0.01 units *)
        withinError := TRUE;
    ELSE
        withinError := FALSE;
    END_IF;
    
    (* Check speed condition *)
    IF D12 <= 100 THEN (* 1 mm/s speed tolerance converted to 0.01 units *)
        withinSpeed := TRUE;
    ELSE
        withinSpeed := FALSE;
    END_IF;
    
    (* Command the boom *)
    IF NOT withinError THEN
        D20 := DINT(targetPosition) * 100; (* Convert from mm to 0.01 units *)
    ELSE
        D20 := 0;
    END_IF;

    (* Check if conditions are met and start observation *)
    IF withinError AND withinSpeed THEN
        IF observationStartTime = TIME#0s THEN
            observationStartTime := TIME_TO_INT(TIME()); (* Start observation timer *)
        END_IF;

        (* Track maintained condition duration *)
        IF TIME() - observationStartTime >= T#30ms THEN
            Y2 := TRUE;  (* Set result retention after 30ms of meeting conditions *)
        END_IF;
    ELSE
        observationStartTime := TIME#0s; 
        Y2 := FALSE;
    END_IF;

    (* Finish if conditions are held for 100ms *)
    IF Y2 THEN
        IF TIME() - observationStartTime >= T#100ms THEN
            done := TRUE;
            Y20 := FALSE;
        END_IF;
    END_IF;

END_IF;

(* Safety constraint: if the function is not active, ensure outputs are safe *)
IF NOT X10 THEN
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    observationStartTime := TIME#0s;
    done := FALSE;
END_IF;

END_PROGRAM