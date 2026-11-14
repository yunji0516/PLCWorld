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
    
    pi : REAL := 3.14159265359;
    g : REAL := 9810.0;
    
    (* Pole placement coefficients for characteristic equation: s^4 + C3 s^3 + C2 s^2 + C1 s + C0 = 0 
       Designed for poles at -2.0 +- 1.5i (w_n = 2.5 rad/s, zeta = 0.8) *)
    C0 : REAL := 39.0625;
    C1 : REAL := 50.0;
    C2 : REAL := 28.5;
    C3 : REAL := 8.0;

    L : REAL;
    x : REAL;
    v : REAL;
    theta : REAL;
    omega : REAL;
    x_target : REAL;

    k_x : REAL;
    k_v : REAL;
    k_theta : REAL;
    k_omega : REAL;
    
    u : REAL;

    state : DINT := 0;
    timer_maintenance : TON;
    timer_observation : TON;
    
    abs_x_err : REAL;
    abs_v : REAL;
    abs_theta : REAL;
    abs_omega : REAL;
    
    condition_met : BOOL;
END_VAR

IF NOT X10 THEN
    state := 0;
    Y2 := FALSE;
    D20 := 0;
    timer_maintenance(IN := FALSE, PT := T#30ms);
    timer_observation(IN := FALSE, PT := T#100ms);
    RETURN;
END_IF

(* Read and scale physical states *)
x_target := REAL(D10) / 100.0;
x := REAL(D11) / 100.0;
v := REAL(D12) / 100.0;
L := REAL(D13) / 100.0;

IF L < 10.0 THEN
    L := 10.0; (* Prevent division by zero or invalid lengths *)
END_IF

theta := REAL(D15) / 100.0 * pi / 180.0;
omega := REAL(D16) / 100.0 * pi / 180.0;

(* Calculate adaptive gains based on current hoisting length L *)
k_x := C0 * L / g;
k_v := C1 * L / g;
k_theta := (L * k_x) + g - (C2 * L);
k_omega := (L * k_v) - (C3 * L);

(* State feedback control law *)
u := - ( (k_x * (x - x_target)) + (k_v * v) + (k_theta * theta) + (k_omega * omega) );

(* Enforce trolley acceleration limits to ±1800 mm/s^2 *)
IF u > 1800.0 THEN
    u := 1800.0;
ELSIF u < -1800.0 THEN
    u := -1800.0;
END_IF

(* Command trolley acceleration (x100 format) *)
D20 := DINT(u * 100.0);

(* Completion logic *)
abs_x_err := ABS(x - x_target);
abs_v := ABS(v);
abs_theta := ABS(REAL(D15) / 100.0);
abs_omega := ABS(REAL(D16) / 100.0);

condition_met := (abs_x_err <= 1.0) AND (abs_v <= 1.0) AND (abs_theta <= 0.2) AND (abs_omega <= 1.0);

IF state = 0 THEN
    timer_maintenance(IN := condition_met, PT := T#30ms);
    timer_observation(IN := FALSE, PT := T#100ms);
    IF timer_maintenance.Q THEN
        state := 1;
    END_IF
ELSIF state = 1 THEN
    timer_maintenance(IN := condition_met, PT := T#30ms);
    timer_observation(IN := TRUE, PT := T#100ms);
END_IF

Y2 := (state = 1);

END_PROGRAM