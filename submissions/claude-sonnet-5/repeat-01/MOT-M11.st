PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;

    (* Internal *)
    step : INT := 0;
    pos_tol : DINT := 20;   (* 0.2 physical * 100 *)
    vel_tol : DINT := 100;  (* 1 physical * 100 *)
END_VAR

CASE step OF

0: // Wait for start approval; keep all actuators off
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    D20 := 0;
    D21 := 0;
    D24 := 0;
    D25 := 0;
    D28 := 0;
    D29 := 0;
    Y2 := FALSE;
    IF X0 THEN
        step := 1;
    END_IF;

1: // Index disk to first angle (B port), tools retracted
    Y20 := TRUE;
    D20 := D101;
    D21 := 1000;
    Y21 := FALSE;
    D24 := 0;
    D25 := 0;
    Y22 := FALSE;
    D28 := 0;
    D29 := 0;
    IF (ABS(D10 - D101) <= pos_tol) AND (ABS(D11) <= vel_tol) THEN
        step := 2;
    END_IF;

2: // Hold A at first, lower B to depth1
    Y20 := TRUE;
    D20 := D101;
    D21 := 1000;
    Y21 := TRUE;
    D24 := D103;
    D25 := 1000;
    IF (ABS(D12 - D103) <= pos_tol) AND (ABS(D13) <= vel_tol) THEN
        step := 3;
    END_IF;

3: // Retract B fully while A stays at first
    Y20 := TRUE;
    D20 := D101;
    D21 := 1000;
    Y21 := TRUE;
    D24 := 0;
    D25 := 1000;
    IF (ABS(D12 - 0) <= pos_tol) AND (ABS(D13) <= vel_tol) THEN
        step := 4;
    END_IF;

4: // B retracted, safe to move A to second (C port)
    Y20 := TRUE;
    D20 := D102;
    D21 := 1000;
    Y21 := TRUE;
    D24 := 0;
    D25 := 1000;
    IF (ABS(D10 - D102) <= pos_tol) AND (ABS(D11) <= vel_tol) THEN
        step := 5;
    END_IF;

5: // Hold A at second, lower C to depth2
    Y20 := TRUE;
    D20 := D102;
    D21 := 1000;
    Y21 := TRUE;
    D24 := 0;
    D25 := 1000;
    Y22 := TRUE;
    D28 := D104;
    D29 := 1000;
    IF (ABS(D14 - D104) <= pos_tol) AND (ABS(D15) <= vel_tol) THEN
        step := 6;
    END_IF;

6: // Retract C fully while A stays at second
    Y20 := TRUE;
    D20 := D102;
    D21 := 1000;
    Y21 := TRUE;
    D24 := 0;
    D25 := 1000;
    Y22 := TRUE;
    D28 := 0;
    D29 := 1000;
    IF (ABS(D14 - 0) <= pos_tol) AND (ABS(D15) <= vel_tol) THEN
        step := 7;
    END_IF;

7: // Completed: A=second, B=0, C=0; maintain and assert completion
    Y20 := TRUE;
    D20 := D102;
    D21 := 1000;
    Y21 := TRUE;
    D24 := 0;
    D25 := 1000;
    Y22 := TRUE;
    D28 := 0;
    D29 := 1000;
    Y2 := TRUE;

ELSE
    step := 0;

END_CASE;

END_PROGRAM