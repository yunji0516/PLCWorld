PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    D15 : DINT;
    D16 : DINT;
    D18 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y2 : BOOL;

    timer_30ms : TON;
    stable : BOOL;
    
    L_m : REAL;
    x_m : REAL;
    x_ref_m : REAL;
    x_dot_m : REAL;
    th_rad : REAL;
    th_dot_rad : REAL;
    
    x_err_m : REAL;
    x_err_clamped : REAL;
    
    k_p : REAL;
    k_v : REAL;
    k_th : REAL;
    k_thd : REAL;
    
    u : REAL;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := D10;
    
    (* Convert inputs to SI base units for control math *)
    L_m := MAX(0.6, REAL(D11) * 0.00001);
    x_m := REAL(D13) * 0.00001;
    x_ref_m := REAL(D17) * 0.00001;
    x_dot_m := REAL(D14) * 0.00001;
    
    th_rad := REAL(D15) * 0.0001745329;
    th_dot_rad := REAL(D16) * 0.0001745329;
    
    (* Trolley position error, softly clamped to shape tracking speed and restrain initial acceleration *)
    x_err_m := x_ref_m - x_m;
    x_err_clamped := LIMIT(-1.0, x_err_m, 1.0);
    
    (* Variable-gain LQR / pole-placement for actual wire length *)
    k_p := 2.064 * L_m;
    k_v := L_m * (4.128 - 0.042 * L_m);
    k_thd := L_m * (8.8 - k_v);
    k_th := L_m * (29.25 - k_p - 0.2 * k_v) - 9.81;
    
    (* Linear control law for trolley acceleration *)
    u := k_p * x_err_clamped - k_v * x_dot_m + k_th * th_rad + k_thd * th_dot_rad;
    
    (* Apply the command with safe output saturation (4 m/s^2) *)
    D21 := DINT(LIMIT(-400000.0, u * 100000.0, 400000.0));
ELSE
    Y20 := FALSE;
    D20 := D11;
    D21 := 0;
END_IF;

(* Completion constraint evaluation *)
stable := X10 AND 
          (ABS(D11 - D10) <= 100) AND
          (ABS(D13 - D17) <= 100) AND
          (ABS(D15 - D18) <= 20) AND
          (ABS(D12) <= 1) AND
          (ABS(D14) <= 1) AND
          (ABS(D16) <= 1);

(* Maintenance hold requirement *)
timer_30ms(IN := stable, PT := T#30ms);
Y2 := timer_30ms.Q;

END_PROGRAM