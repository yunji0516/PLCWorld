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
    
    sway_angle : REAL;
    sway_vel : REAL;
    trolley_pos : REAL;
    trolley_vel : REAL;
    target_pos : REAL;
    pos_error : REAL;
    acc_cmd : REAL;
    acc_raw : DINT;
    
    stability_scans : INT;
    y2_ready : BOOL;
    
    K_sway : REAL := 10000.0;
    K_swayvel : REAL := 10000.0;
    K_pos : REAL := 500.0;
    K_vel : REAL := 200.0;
    max_acc : DINT := 180000;
END_VAR

acc_raw := 0;

IF X10 THEN
    sway_angle := REAL(D15) / 100.0;
    sway_vel := REAL(D16) / 100.0;
    trolley_pos := REAL(D11) / 100.0;
    trolley_vel := REAL(D12) / 100.0;
    target_pos := REAL(D10) / 100.0;
    
    pos_error := target_pos - trolley_pos;
    
    acc_cmd := -K_sway * sway_angle 
             - K_swayvel * sway_vel
             + K_pos * pos_error
             - K_vel * trolley_vel;
    
    acc_raw := LIMIT(-max_acc, DINT(acc_cmd * 100.0), max_acc);
    
    IF ABS(D11 - D10) <= 100 AND ABS(D12) <= 100 AND ABS(D15) <= 20 AND ABS(D16) <= 100 THEN
        stability_scans := stability_scans + 1;
    ELSE
        stability_scans := 0;
    END_IF;
    
    IF stability_scans >= 3 THEN
        y2_ready := TRUE;
    END_IF;
END_IF;

D20 := acc_raw;
Y2 := y2_ready;

END_PROGRAM