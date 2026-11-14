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

    (* internal state *)
    step        : INT := 0;
    check1_done : BOOL := FALSE;
    check2_done : BOOL := FALSE;

    c_arr0   : BOOL;
    c_arr50  : BOOL;
    d_arr100 : BOOL;
    d_arr0   : BOOL;

    pos_tol : DINT := 20;   (* 0.2 mm * 100 *)
    vel_tol : DINT := 100;  (* 1 mm/s * 100 *)
END_VAR

(* ---- arrival evaluation, based on actual continuous feedback ---- *)
c_arr0   := (ABS(D10)         <= pos_tol) AND (ABS(D11) <= vel_tol);
c_arr50  := (ABS(D10 - 5000)  <= pos_tol) AND (ABS(D11) <= vel_tol);
d_arr100 := (ABS(D12 - 10000) <= pos_tol) AND (ABS(D13) <= vel_tol);
d_arr0   := (ABS(D12)         <= pos_tol) AND (ABS(D13) <= vel_tol);

CASE step OF

0: (* wait for start, nothing supplied *)
    Y20 := FALSE; Y21 := FALSE;
    Y22 := FALSE; Y23 := FALSE;
    Y24 := FALSE; Y25 := FALSE;
    D20 := 0; D21 := 1000;
    D24 := 0; D25 := 1000;
    Y2 := FALSE;
    IF X0 THEN
        step := 1;
    END_IF;

1: (* extend A to 40 and B to 180 -> extraction position, C/D held at 0 (z=0, always safe) *)
    Y20 := TRUE;  Y21 := FALSE;
    Y22 := TRUE;  Y23 := FALSE;
    Y24 := TRUE;  D20 := 0;  D21 := 1000;
    Y25 := TRUE;  D24 := 0;  D25 := 1000;
    IF X2 AND X4 THEN
        check1_done := TRUE;
        step := 2;
    END_IF;

2: (* retract B to home, keep A extended, C/D still held at 0 (z=0, safe) *)
    Y20 := TRUE;  Y21 := FALSE;
    Y22 := FALSE; Y23 := TRUE;
    Y24 := TRUE;  D20 := 0;  D21 := 1000;
    Y25 := TRUE;  D24 := 0;  D25 := 1000;
    IF X2 AND X3 THEN
        step := 3;
    END_IF;

3: (* move jig D to 100mm while C stays at 0 (z=0, safe regardless of q) *)
    Y20 := TRUE;  Y21 := FALSE;
    Y22 := FALSE; Y23 := FALSE;
    Y24 := TRUE;  D20 := 0;     D21 := 1000;
    Y25 := TRUE;  D24 := 10000; D25 := 1000;
    IF d_arr100 AND X5 THEN
        step := 4;
    END_IF;

4: (* lower head C to 50mm; x=40,q=100 fixed -> outside both contact zones for any z *)
    Y20 := TRUE;  Y21 := FALSE;
    Y22 := FALSE; Y23 := FALSE;
    Y24 := TRUE;  D20 := 5000;  D21 := 1000;
    Y25 := TRUE;  D24 := 10000; D25 := 1000;
    IF c_arr50 AND X2 AND X3 THEN
        check2_done := TRUE;
        step := 5;
    END_IF;

5: (* raise C back to 0; x,q unchanged (still safe pair) while z falls back below 10 *)
    Y20 := TRUE;  Y21 := FALSE;
    Y22 := FALSE; Y23 := FALSE;
    Y24 := TRUE;  D20 := 0;     D21 := 1000;
    Y25 := TRUE;  D24 := 10000; D25 := 1000;
    IF c_arr0 THEN
        step := 6;
    END_IF;

6: (* retract jig D back to 0; z already ~0, safe regardless of q transient *)
    Y20 := TRUE;  Y21 := FALSE;
    Y22 := FALSE; Y23 := FALSE;
    Y24 := TRUE;  D20 := 0; D21 := 1000;
    Y25 := TRUE;  D24 := 0; D25 := 1000;
    IF d_arr0 THEN
        step := 7;
    END_IF;

7: (* retract A back to home; z already ~0, safe regardless of x transient *)
    Y20 := FALSE; Y21 := TRUE;
    Y22 := FALSE; Y23 := FALSE;
    Y24 := TRUE;  D20 := 0; D21 := 1000;
    Y25 := TRUE;  D24 := 0; D25 := 1000;
    IF X1 THEN
        step := 8;
    END_IF;

8: (* all axes at origin; valves off; hold servos at 0; claim/maintain completion *)
    Y20 := FALSE; Y21 := FALSE;
    Y22 := FALSE; Y23 := FALSE;
    Y24 := TRUE;  D20 := 0; D21 := 1000;
    Y25 := TRUE;  D24 := 0; D25 := 1000;
    IF check1_done AND check2_done AND X1 AND X3 AND c_arr0 AND d_arr0 THEN
        Y2 := TRUE;
    END_IF;

ELSE
    step := 0;

END_CASE;

END_PROGRAM