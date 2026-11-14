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
    D21 : DINT;
    Y2 : BOOL;

    StableTimer : TON;
    StableCond : BOOL;

    X_target, X_pos, X_spd : REAL;
    Z_pos, Z_spd : REAL;
    C_pos, C_spd : REAL;

    X_error, V_cmd_raw, V_max, V_cmd : REAL;
    Z_error, dir, C_des, C_error, V_diff_cmd : REAL;
    Left_cmd, Right_cmd : REAL;
END_VAR

IF NOT X10 THEN
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
    StableTimer(IN := FALSE, PT := T#30ms);
    RETURN;
END_IF;

X_target := REAL(D10) / 100.0;
X_pos := REAL(D11) / 100.0;
X_spd := REAL(D12) / 100.0;
Z_pos := REAL(D13) / 100.0;
Z_spd := REAL(D14) / 100.0;
C_pos := REAL(D15) / 100.0;
C_spd := REAL(D16) / 100.0;

X_error := X_target - X_pos;
V_max := SQRT(4000.0 * ABS(X_error));
V_cmd_raw := 4.0 * X_error;

IF V_cmd_raw > V_max THEN 
    V_cmd_raw := V_max; 
END_IF;
IF V_cmd_raw < -V_max THEN 
    V_cmd_raw := -V_max; 
END_IF;

IF V_cmd_raw > 1500.0 THEN 
    V_cmd_raw := 1500.0; 
END_IF;
IF V_cmd_raw < -1500.0 THEN 
    V_cmd_raw := -1500.0; 
END_IF;

V_cmd := V_cmd_raw - 0.2 * X_spd;

Z_error := 0.0 - Z_pos;

dir := 1.0;
IF V_cmd < -0.1 THEN
    dir := -1.0;
END_IF;

C_des := (0.2 * Z_error - 0.4 * Z_spd) * dir;
IF C_des > 15.0 THEN 
    C_des := 15.0; 
END_IF;
IF C_des < -15.0 THEN 
    C_des := -15.0; 
END_IF;

C_error := C_des - C_pos;
V_diff_cmd := 150.0 * C_error - 3.0 * C_spd;

IF V_diff_cmd > 600.0 THEN 
    V_diff_cmd := 600.0; 
END_IF;
IF V_diff_cmd < -600.0 THEN 
    V_diff_cmd := -600.0; 
END_IF;

Left_cmd := V_cmd - V_diff_cmd / 2.0;
Right_cmd := V_cmd + V_diff_cmd / 2.0;

IF Left_cmd > 2000.0 THEN 
    Left_cmd := 2000.0; 
END_IF;
IF Left_cmd < -2000.0 THEN 
    Left_cmd := -2000.0; 
END_IF;
IF Right_cmd > 2000.0 THEN 
    Right_cmd := 2000.0; 
END_IF;
IF Right_cmd < -2000.0 THEN 
    Right_cmd := -2000.0; 
END_IF;

D20 := DINT(Left_cmd * 100.0);
D21 := DINT(Right_cmd * 100.0);

StableCond := (ABS(X_error) <= 1.0) AND (ABS(Z_pos) <= 2.0) AND (ABS(C_pos) <= 0.3) AND (ABS(X_spd) <= 2.0) AND (ABS(C_spd) <= 1.0);
StableTimer(IN := StableCond, PT := T#30ms);

IF StableTimer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM