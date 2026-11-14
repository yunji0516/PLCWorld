PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    
    // Internal variables
    homeRequested : BOOL := FALSE;
    completionTimer : TON;
    observationTimer : TON;
    observationComplete : BOOL := FALSE;
END_VAR

(* Home Return and Coordinate Validity Maintenance logic *)

IF X10 THEN
    // Start the home process if a work request is received
    IF NOT X11 THEN
        homeRequested := TRUE;
    END_IF;
END_IF;

IF homeRequested THEN
    // Execute home return
    Y21 := TRUE;
    
    // Check if Home complete and reference valid
    IF X13 AND X11 THEN
        homeRequested := FALSE;
        Y21 := FALSE;
        
        // Start completion timer
        completionTimer(IN := TRUE, PT := T#30ms);
        IF completionTimer.Q THEN
            Y2 := TRUE;
            completionTimer(IN := FALSE);
            
            // Start observation timer
            observationTimer(IN := TRUE, PT := T#100ms);
        END_IF;
    END_IF;
    
    // If the origin dog is reached during Home (X14 becomes true), stop the search
    IF NOT X12 THEN
        Y21 := FALSE; // Interruption or stop
    END_IF;
END_IF;

// Check observation timer after completion
IF observationTimer.Q THEN
    observationComplete := TRUE;
    observationTimer(IN := FALSE);
END_IF;

// Maintain the result retention if completion and observation are successful
IF Y2 AND observationComplete THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM