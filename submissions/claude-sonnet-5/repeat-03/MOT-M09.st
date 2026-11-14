PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;

    (* internal state *)
    stage      : INT := 0;
    pos_tol    : DINT := 20;    (* 0.2 mm * 100 *)
    vel_tol    : DINT := 100;   (* 1 mm/s * 100 *)
    a_lock     : DINT := 10000; (* 100 mm * 100 *)
    bc_lock    : DINT := 6000;  (* 60 mm  * 100 *)
    zero_pos   : DINT := 0;
END_VAR

CASE stage OF

0: // idle - wait for start approval, outputs must stay off
    Y20 := FALSE; D20 := 0; D21 := 0;
    Y21 := FALSE; D24 := 0; D25 := 0;
    Y22 := FALSE; D28 := 0; D29 := 0;
    Y23 := FALSE; D32 := 0; D33 := 0;
    Y2 := FALSE;
    IF X0 THEN
        stage := 1;
    END_IF;

1: // establish guide position A=100 first (aligns with receiver gap)
    Y20 := TRUE;  D20 := a_lock; D21 := 1000;
    Y21 := FALSE; D24 := 0;      D25 := 0;
    Y22 := FALSE; D28 := 0;      D29 := 0;
    Y23 := FALSE; D32 := 0;      D33 := 0;
    IF (ABS(D10 - a_lock) <= pos_tol) AND (ABS(D11) <= vel_tol) THEN
        stage := 2;
    END_IF;

2: // guide locked at gap; now insert both locking pins B and C to 60 (free order)
    Y20 := TRUE; D20 := a_lock;  D21 := 1000;
    Y21 := TRUE; D24 := bc_lock; D25 := 1000;
    Y22 := TRUE; D28 := bc_lock; D29 := 1000;
    Y23 := FALSE; D32 := 0;      D33 := 0;
    IF (ABS(D12 - bc_lock) <= pos_tol) AND (ABS(D13) <= vel_tol) AND
       (ABS(D14 - bc_lock) <= pos_tol) AND (ABS(D15) <= vel_tol) THEN
        stage := 3;
    END_IF;

3: // locked posture achieved; drive D into requested depth while maintaining lock
    Y20 := TRUE; D20 := a_lock;  D21 := 1000;
    Y21 := TRUE; D24 := bc_lock; D25 := 1000;
    Y22 := TRUE; D28 := bc_lock; D29 := 1000;
    Y23 := TRUE; D32 := D101;    D33 := 1000;
    IF (ABS(D16 - D101) <= pos_tol) AND (ABS(D17) <= vel_tol) THEN
        stage := 4;
    END_IF;

4: // internal access reached; retrieve D back to origin while maintaining lock
    Y20 := TRUE; D20 := a_lock;  D21 := 1000;
    Y21 := TRUE; D24 := bc_lock; D25 := 1000;
    Y22 := TRUE; D28 := bc_lock; D29 := 1000;
    Y23 := TRUE; D32 := zero_pos; D33 := 1000;
    IF (ABS(D16 - zero_pos) <= pos_tol) AND (ABS(D17) <= vel_tol) THEN
        stage := 5;
    END_IF;

5: // D fully retrieved (safe below threshold); retract locking pins while guide stays at gap
    Y20 := TRUE; D20 := a_lock;   D21 := 1000;
    Y21 := TRUE; D24 := zero_pos; D25 := 1000;
    Y22 := TRUE; D28 := zero_pos; D29 := 1000;
    Y23 := TRUE; D32 := zero_pos; D33 := 1000;
    IF (ABS(D12 - zero_pos) <= pos_tol) AND (ABS(D13) <= vel_tol) AND
       (ABS(D14 - zero_pos) <= pos_tol) AND (ABS(D15) <= vel_tol) THEN
        stage := 6;
    END_IF;

6: // pins clear; retract guide to origin
    Y20 := TRUE; D20 := zero_pos; D21 := 1000;
    Y21 := TRUE; D24 := zero_pos; D25 := 1000;
    Y22 := TRUE; D28 := zero_pos; D29 := 1000;
    Y23 := TRUE; D32 := zero_pos; D33 := 1000;
    IF (ABS(D10 - zero_pos) <= pos_tol) AND (ABS(D11) <= vel_tol) THEN
        stage := 7;
    END_IF;

7: // all axes at origin, hold and assert completion
    Y20 := TRUE; D20 := zero_pos; D21 := 1000;
    Y21 := TRUE; D24 := zero_pos; D25 := 1000;
    Y22 := TRUE; D28 := zero_pos; D29 := 1000;
    Y23 := TRUE; D32 := zero_pos; D33 := 1000;

    IF (ABS(D10) <= pos_tol) AND (ABS(D11) <= vel_tol) AND
       (ABS(D12) <= pos_tol) AND (ABS(D13) <= vel_tol) AND
       (ABS(D14) <= pos_tol) AND (ABS(D15) <= vel_tol) AND
       (ABS(D16) <= pos_tol) AND (ABS(D17) <= vel_tol) THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;

ELSE
    stage := 0;

END_CASE;

END_PROGRAM