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

    L : REAL;
    L_dot : REAL;
    Cd : REAL;
    g : REAL := 9.81;
    
    (* Desired characteristic equation coefficients for closed-loop poles at s = -2.0 *)
    d0 : REAL := 16.0;
    d1 : REAL := 32.0;
    d2 : REAL := 24.0;
    d3 : REAL := 8.0;
    
    k1 : REAL;
    k2 : REAL;
    k3 : REAL;
    k4 : REAL;
    
    p : REAL;
    v : REAL;
    theta : REAL;
    omega : REAL;
    u_real : REAL;
    u_cmd : DINT;

    in_target : BOOL;
    stable_timer : TON;
END_VAR

(* Convert wire length and speed to standard SI units (meters, meters/second) *)
L := REAL(D11) / 100000.0;
IF L < 0.1 THEN
    L := 0.1;
END_IF;
L_dot := REAL(D12) / 100000.0;

(* Calculate coupled damping term from varying rope length and pendulum sway damping *)
Cd := 2.0 * L_dot + 0.2 * L;

(* Dynamic calculation of state feedback gains for robust pole placement *)
k1 := L * d0 / g;
k2 := (L * d1 - k1 * Cd) / g;
k3 := g + k2 * Cd + L * k1 - L * d2;
k4 := Cd + L * k2 - L * d3;

(* Read current system errors and convert to standard SI units *)
p := REAL(D13 - D17) / 100000.0;
v := REAL(D14) / 100000.0;
theta := REAL(D15 - D18) * 3.14159265 / 18000.0;
omega := REAL(D16) * 3.14159265 / 18000.0;

(* Full-state feedback control law for trolley acceleration *)
u_real := -k1 * p - k2 * v - k3 * theta - k4 * omega;

(* Convert acceleration command back to 0.01 mm/s^2 and enforce permitted limits *)
u_cmd := DINT(u_real * 100000.0);
u_cmd := LIMIT(-400000, u_cmd, 400000);

(* Apply hoist and trolley commands based on task activation *)
IF X10 THEN
    Y20 := TRUE;
    D20 := D10;
    D21 := u_cmd;
ELSE
    Y20 := FALSE;
    D20 := D11;
    D21 := 0;
END_IF;

(* Evaluate physical convergence to targets *)
in_target := X10 AND 
             (ABS(D11 - D10) <= 100) AND
             (ABS(D13 - D17) <= 100) AND
             (ABS(D15 - D18) <= 20) AND
             (ABS(D12) <= 100) AND
             (ABS(D14) <= 100) AND
             (ABS(D16) <= 100);

stable_timer(IN := in_target, PT := T#30ms);

(* Latch completion signal upon confirming 30 ms stability *)
IF stable_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM