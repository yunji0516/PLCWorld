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
    
    init : BOOL;
    a_ref : REAL;
    v_a_ref : REAL;
    b_ref : REAL;
    v_ref : REAL;
    
    target_a : REAL;
    e_a : REAL;
    a_a_ref : REAL;
    
    target_b : REAL;
    e_b_ref : REAL;
    a_ref_b : REAL;
    
    x1, x2, x3, x4, L : REAL;
    k1, k2, k3, k4 : REAL;
    e_b_ctrl, e_v_ctrl, u : REAL;
    
    length_ok, trolley_ok, sway_ok, is_stable : BOOL;
    stable_timer : DINT;
END_VAR

IF NOT init THEN
    a_ref := REAL(D11) / 100000.0;
    b_ref := REAL(D13) / 100000.0;
    init := TRUE;
END_IF

IF X10 THEN
    Y20 := TRUE;
    
    // Axis A (hoist wire length) reference generation
    target_a := REAL(D10) / 100000.0;
    e_a := target_a - a_ref;
    a_a_ref := 2.25 * e_a - 3.0 * v_a_ref;
    a_a_ref := LIMIT(-1.0, a_a_ref, 1.0);
    v_a_ref := v_a_ref + a_a_ref * 0.01;
    v_a_ref := LIMIT(-0.8, v_a_ref, 0.8);
    a_ref := a_ref + v_a_ref * 0.01;
    D20 := DINT(a_ref * 100000.0);
    
    // Axis B (trolley X) reference generation
    target_b := REAL(D17) / 100000.0;
    e_b_ref := target_b - b_ref;
    a_ref_b := 2.25 * e_b_ref - 3.0 * v_ref;
    a_ref_b := LIMIT(-1.0, a_ref_b, 1.0);
    v_ref := v_ref + a_ref_b * 0.01;
    v_ref := LIMIT(-0.8, v_ref, 0.8);
    b_ref := b_ref + v_ref * 0.01;
    
    // Convert plant state to SI units
    x1 := REAL(D13) / 100000.0;
    x2 := REAL(D14) / 100000.0;
    x3 := REAL(D15) * 0.000174533; // 0.01 deg to rad
    x4 := REAL(D16) * 0.000174533; // 0.01 deg/s to rad/s
    
    L := REAL(D11) / 100000.0;
    L := LIMIT(0.5, L, 3.0);
    
    // LQR Gains scheduled by wire length
    k1 := 1.4335 * L;
    k2 := 2.4465 * L;
    k3 := 9.81 + 1.4335 * L * L - 18.1 * L;
    k4 := 2.4465 * L * L - 6.4 * L;
    
    e_b_ctrl := x1 - b_ref;
    e_v_ctrl := x2 - v_ref;
    
    // State feedback control law for trolley and sway
    u := -k1 * e_b_ctrl - k2 * e_v_ctrl - k3 * x3 - k4 * x4 + a_ref_b;
    u := LIMIT(-1.5, u, 1.5);
    
    D21 := DINT(u * 100000.0);
ELSE
    Y20 := FALSE;
    D20 := D11;
    D21 := 0;
    a_ref := REAL(D11) / 100000.0;
    b_ref := REAL(D13) / 100000.0;
    v_a_ref := 0.0;
    v_ref := 0.0;
END_IF

// Final result stability and completion checking
length_ok := (ABS(D11 - D10) <= 100) AND (ABS(D12) <= 100);
trolley_ok := (ABS(D13 - D17) <= 100) AND (ABS(D14) <= 100);
sway_ok := (ABS(D15 - D18) <= 20) AND (ABS(D16) <= 100);

is_stable := length_ok AND trolley_ok AND sway_ok AND X10;

IF is_stable THEN
    stable_timer := stable_timer + 10;
ELSE
    stable_timer := 0;
END_IF

IF stable_timer >= 30 THEN
    Y2 := TRUE;
END_IF

END_PROGRAM