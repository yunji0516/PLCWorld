PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    A_pred : REAL;
    D20_real : REAL;
    D21_real : REAL;
    
    stable_timer : TON;
    deg2rad : REAL := 0.017453292519943;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    
    (* Predict head A position (in degrees) 10 ms into the future to compensate for scan and tracking delay *)
    A_pred := (REAL(D13) + REAL(D14) * 0.01) / 100.0;
    
    (* Calculate target counterweight B position to zero out the support moment (D20 is in mm * 100) *)
    D20_real := -45000.0 * SIN(A_pred * deg2rad);
    D20 := LIMIT(-200000, DINT(D20_real), 200000);
    
    (* Calculate feedforward B speed (D21 is in mm/s * 100) *)
    D21_real := -7.85398163397 * COS(A_pred * deg2rad) * REAL(D14);
    D21 := LIMIT(-200000, DINT(D21_real), 200000);
    
    (* Check completion condition: |M| <= 1 Nm corresponds to |D17| <= 100 *)
    stable_timer(IN := (ABS(D17) <= 100), PT := T#30ms);
    IF stable_timer.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    D21 := 0;
    stable_timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM