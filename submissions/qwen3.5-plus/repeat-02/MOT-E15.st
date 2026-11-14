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
    
    pi_const : REAL := 3.14159265358979;
    a_deg : REAL;
    a_rad : REAL;
    sin_val : REAL;
    cos_val : REAL;
    b_ideal : REAL;
    a_speed_dps : REAL;
    b_speed : REAL;
    completion_timer : TON;
    y2_set : BOOL;
END_VAR

// Convert head position to degrees
a_deg := REAL(D13) / 100.0;
a_rad := a_deg * pi_const / 180.0;

// Calculate trig functions
sin_val := SIN(a_rad);
cos_val := COS(a_rad);

// Ideal counterweight position for balance: b = -450 * sin(a)
// Derived from M = 30*9.81*0.3*sin(a) + 20*9.81*b/1000 = 0
b_ideal := -450.0 * sin_val;

// D20 command: position in mm × 0.01
D20 := DINT(b_ideal * 100.0);
IF D20 > 200000 THEN D20 := 200000; END_IF;
IF D20 < -200000 THEN D20 := -200000; END_IF;

// Feedforward speed: db/dt = -450 * cos(a) * (pi/180) * da/dt
a_speed_dps := REAL(D14) / 100.0;
b_speed := -450.0 * cos_val * (pi_const / 180.0) * a_speed_dps;
D21 := DINT(b_speed * 100.0);
IF D21 > 200000 THEN D21 := 200000; END_IF;
IF D21 < -200000 THEN D21 := -200000; END_IF;

// Function activation
Y20 := X10;

// Completion check: |D17| <= 100 corresponds to |M| <= 1 Nm
IF ABS(D17) <= 100 THEN
    completion_timer(IN := TRUE, PT := T#30ms);
    IF completion_timer.Q THEN
        y2_set := TRUE;
    END_IF;
ELSE
    completion_timer(IN := FALSE);
END_IF;

Y2 := y2_set;

END_PROGRAM