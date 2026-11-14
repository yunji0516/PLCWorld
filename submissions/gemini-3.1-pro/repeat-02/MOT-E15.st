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

    a_deg : REAL;
    a_dot : REAL;
    a_next : REAL;
    a_rad : REAL;
    a_dot_rad : REAL;
    
    y_d : REAL;
    y_d_dot : REAL;
    y_d_ddot : REAL;
    
    b_cmd : REAL;
    b_cmd_dot : REAL;
    
    stable_timer : TON;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    
    (* Convert actual position and speed of Axis A from raw format *)
    a_deg := REAL(D13) / 100.0;
    a_dot := REAL(D14) / 100.0;
    
    (* Project Axis A position forward by one 10 ms PLC scan *)
    a_next := a_deg + a_dot * 0.01;
    
    (* Convert to radians *)
    a_rad := a_next * 3.14159265 / 180.0;
    a_dot_rad := a_dot * 3.14159265 / 180.0;
    
    (* 
       Calculate ideal counterweight trajectory to offset the moment.
       M = 30 * 9.81 * 0.3 * sin(a) + 20 * 9.81 * b / 1000 = 0
       b = -450 * sin(a)
    *)
    y_d := -450.0 * SIN(a_rad);
    y_d_dot := -450.0 * COS(a_rad) * a_dot_rad;
    y_d_ddot := 450.0 * SIN(a_rad) * (a_dot_rad * a_dot_rad);
    
    (* 
       Apply inverse dynamics feedforward for Axis B closed-loop response.
       w_n = 60 rad/s, damping ratio = 1.
       b_cmd = y_d + (2*zeta/w_n)*y_d_dot + (1/w_n^2)*y_d_ddot
    *)
    b_cmd := y_d + (2.0 / 60.0) * y_d_dot + (1.0 / 3600.0) * y_d_ddot;
    b_cmd_dot := y_d_dot + (2.0 / 60.0) * y_d_ddot;
    
    (* Assign bounded outputs *)
    D20 := LIMIT(-200000, DINT(b_cmd * 100.0), 200000);
    D21 := LIMIT(-200000, DINT(b_cmd_dot * 100.0), 200000);
    
    (* Maintain completion claim once |M| <= 1 Nm (D17 <= 100) is stable for 30 ms *)
    stable_timer(IN := (ABS(D17) <= 100) AND NOT Y2, PT := T#30ms);
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