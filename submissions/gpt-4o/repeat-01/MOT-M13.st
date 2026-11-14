PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;
    
    (* Internal variables *)
    state : INT := 0; (* Control state variable *)
    targetAngle : DINT;
    targetC : DINT;
    targetD : DINT;
    
    aArrived : BOOL;
    bArrived : BOOL;
    cArrived : BOOL;
    dArrived : BOOL;
    
    startTrig : R_TRIG;
    
    dockingAllowed : BOOL := FALSE;
    completionTimer : TON;
    
END_VAR

(* Device parameters and initial conditions *)
targetAngle := D101; (* Angle request *)
targetC := D102;     (* Target C request *)
targetD := D103;     (* D target request / receiving lift position *)

startTrig(CLK := X0);

IF startTrig.Q THEN
    state := 1; (* Trigger start condition *)
END_IF

CASE state OF
    0: (* Idle state, wait for start signal *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        
    1: (* Move loader to angle and horizontal target *)
        Y20 := TRUE;
        Y21 := TRUE;
        
        (* Command for loader height (A) and tilt angle (B) *)
        D20 := 12000; (* Target A = 120 mm -> 12000 scaled value *)
        D21 := 1000;  (* 100% rate *)
        
        D24 := targetAngle * 100; (* Set target angle in scaled units *)
        D25 := 1000;  (* 100% rate *)
        
        aArrived := ABS(D10 - D20) <= 20 AND ABS(D11) <= 100; (* Check arrival tolerance *)
        bArrived := ABS(D12 - D24) <= 20 AND ABS(D13) <= 100; 
        
        IF aArrived AND bArrived THEN
            state := 2;
        END_IF
        
    2: (* Prepare receiving lift while moving loader forward *)
        Y22 := TRUE;
        Y23 := TRUE;
        
        (* Move forward *)
        D28 := targetC * 100; (* Set target C in scaled units *)
        D29 := 1000;  (* 100% rate *)
        
        (* Prepare receiving lift *)
        D32 := targetD * 100; (* Set target D in scaled units *)
        D33 := 1000;
        
        cArrived := ABS(D14 - D28) <= 20 AND ABS(D15) <= 100;
        dArrived := ABS(D16 - D32) <= 20 AND ABS(D17) <= 100;
        
        IF cArrived AND dArrived THEN
            state := 3;
        END_IF
        
    3: (* Lower to dock and validate *)
        D20 := 10000; (* Target A = 100 mm -> 10000 scaled value *)
        D21 := 1000;  (* 100% rate *)
        
        aArrived := ABS(D10 - D20) <= 20 AND ABS(D11) <= 100;
        
        IF aArrived THEN
            dockingAllowed := TRUE;
            (* Maintain receiving lift position requirement *)
            IF D14 > targetC * 100 - 4000 AND D10 < 11500 THEN
                dArrived := ABS(D16 - D32) <= 20 AND ABS(D17) <= 100;
            END_IF
            state := 4;
        END_IF
        
    4: (* Raise and return to starting positions *)
        D20 := 12000; (* Raise to A=120 mm *)
        cArrived := ABS(D14 - 0) <= 20 AND ABS(D15) <= 100;
        
        IF D10 = 12000 THEN
            D28 := 0; (* Return C to starting position *)
            D29 := 1000;
            
            dArrived := ABS(D16 - D32) <= 20 AND ABS(D17) <= 100;
            
            IF cArrived AND dArrived THEN
                state := 5;
            END_IF
        END_IF
        
    5: (* Completion state *)
        completionTimer(IN := (dockingAllowed AND cArrived), PT := T#100ms);
        
        IF completionTimer.Q THEN
            Y2 := TRUE;
        END_IF
        
END_CASE

END_PROGRAM