PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y24 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y25 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y2 : BOOL;

    (* internal *)
    step      : DINT := 0;
    checked1  : BOOL := FALSE;
    checked2  : BOOL := FALSE;

    pos_tol   : DINT := 20;    (* 0.2 mm * 100 *)
    vel_tol   : DINT := 100;   (* 1 mm/s * 100 *)

    c_t0      : DINT := 0;     (* C target 0 mm, scaled *)
    c_t50     : DINT := 5000;  (* C target 50 mm, scaled *)
    d_t0      : DINT := 0;     (* D target 0 mm, scaled *)
    d_t100    : DINT := 10000; (* D target 100 mm, scaled *)

    rate_max  : DINT := 1000;
END_VAR

CASE step OF

0: (* wait for start *)
    Y20 := FALSE; Y21 := FALSE;
    Y22 := FALSE; Y23 := FALSE;
    Y24 := FALSE; D20 := 0; D21 := 0;
    Y25 := FALSE; D24 := 0; D25 := 0;
    IF X0 THEN
        step := 1;
    END_IF;

1: (* extraction check: extend A, extend B, hold C at 0 *)
    Y20 := TRUE;  Y21 := FALSE;
    Y22 := TRUE;  Y23 := FALSE;
    Y24 := TRUE;  D20 := c_t0;  D21 := rate_max;
    Y25 := FALSE; D24 := 0;     D25 := 0;
    IF X2 AND X4 AND (ABS(D10 - c_t0) <= pos_tol) AND (ABS(D11) <= vel_tol) THEN
        checked1 := TRUE;
        step := 2;
    END_IF;

2: (* retract B to home, advance D to 100, keep A extended, hold C at 0 *)
    Y20 := TRUE;  Y21 := FALSE;
    Y22 := FALSE; Y23 := TRUE;
    Y24 := TRUE;  D20 := c_t0;   D21 := rate_max;
    Y25 := TRUE;  D24 := d_t100; D25 := rate_max;
    IF X3 AND X5 AND (ABS(D12 - d_t100) <= pos_tol) AND (ABS(D13) <= vel_tol) THEN
        step := 3;
    END_IF;

3: (* jig approach: lower C to 50 while A/B/D held *)
    Y20 := TRUE;  Y21 := FALSE;
    Y22 := FALSE; Y23 := TRUE;
    Y24 := TRUE;  D20 := c_t50;  D21 := rate_max;
    Y25 := TRUE;  D24 := d_t100; D25 := rate_max;
    IF (ABS(D10 - c_t50) <= pos_tol) AND (ABS(D11) <= vel_tol) THEN
        checked2 := TRUE;
        step := 4;
    END_IF;

4: (* raise C back to 0 before moving A/D, keep x/q fixed while z>10 *)
    Y20 := TRUE;  Y21 := FALSE;
    Y22 := FALSE; Y23 := TRUE;
    Y24 := TRUE;  D20 := c_t0;   D21 := rate_max;
    Y25 := TRUE;  D24 := d_t100; D25 := rate_max;
    IF (ABS(D10 - c_t0) <= pos_tol) AND (ABS(D11) <= vel_tol) THEN
        step := 5;
    END_IF;

5: (* return A and D to origin, B already home, C held at 0 *)
    Y20 := FALSE; Y21 := TRUE;
    Y22 := FALSE; Y23 := TRUE;
    Y24 := TRUE;  D20 := c_t0; D21 := rate_max;
    Y25 := TRUE;  D24 := d_t0; D25 := rate_max;
    IF X1 AND X3 AND
       (ABS(D10 - c_t0) <= pos_tol) AND (ABS(D11) <= vel_tol) AND
       (ABS(D12 - d_t0) <= pos_tol) AND (ABS(D13) <= vel_tol) THEN
        step := 6;
    END_IF;

6: (* all axes at origin, maintain and claim completion *)
    Y20 := FALSE; Y21 := TRUE;
    Y22 := FALSE; Y23 := TRUE;
    Y24 := TRUE;  D20 := c_t0; D21 := rate_max;
    Y25 := TRUE;  D24 := d_t0; D25 := rate_max;
    IF checked1 AND checked2 THEN
        Y2 := TRUE;
    END_IF;

ELSE
    step := 0;

END_CASE;

END_PROGRAM