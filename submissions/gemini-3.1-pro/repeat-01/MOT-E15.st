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
    
    A_pos_deg : REAL;
    A_speed_deg : REAL;
    A_pred_deg : REAL;
    A_pred_rad : REAL;
    B_target_mm : REAL;
    B_speed_mm : REAL;
    
    timer : TON;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    
    A_pos_deg := REAL(D13) * 0.01;
    A_speed_deg := REAL(D14) * 0.01;
    
    (* Predict A's position 1 PLC scan (10 ms) ahead to compensate for output delay *)
    A_pred_deg := A_pos_deg + (A_speed_deg * 0.010);
    A_pred_rad := A_pred_deg * 0.017453292519943295;
    
    (* Calculate counterweight target position and feedforward speed to maintain zero moment *)
    B_target_mm := -450.0 * SIN(A_pred_rad);
    B_speed_mm := -450.0 * COS(A_pred_rad) * A_speed_deg * 0.017453292519943295;
    
    D20 := DINT(ROUND(B_target_mm * 100.0));
    D21 := DINT(ROUND(B_speed_mm * 100.0));
    
    (* Ensure commands strictly abide by the allowed raw bounds *)
    D20 := LIMIT(-200000, D20, 200000);
    D21 := LIMIT(-200000, D21, 200000);
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
END_IF;

(* Monitor support moment |M| <= 1 Nm (|D17| <= 100) *)
timer(IN := X10 AND (ABS(D17) <= 100), PT := T#30ms);

IF timer.Q THEN
    Y2 := TRUE;
END_IF;

IF NOT X10 THEN
    Y2 := FALSE;
END_IF;

END_PROGRAM