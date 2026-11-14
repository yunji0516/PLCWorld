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

    (* Internal state *)
    step    : INT := 0;
    pos_tol : DINT := 20;   (* 0.2 (mm or deg) * 100 *)
    vel_tol : DINT := 100;  (* 1 (mm/s or deg/s) * 100 *)
END_VAR

CASE step OF

0:
    (* wait for start request before any enable *)
    IF X0 THEN
        (* retreat feeder A to 0, keep D held at 0 *)
        Y20 := TRUE;
        D20 := 0;
        D21 := 1000;
        Y23 := TRUE;
        D32 := 0;
        D33 := 1000;
        step := 1;
    END_IF;

1:
    (* wait feeder fully retreated and stopped at A=0 *)
    IF ABS(D10 - 0) <= pos_tol AND ABS(D11) <= vel_tol THEN
        (* rotate head to destination angle before lateral travel *)
        Y21 := TRUE;
        D24 := 9000;   (* 90 deg *)
        D25 := 1000;
        step := 2;
    END_IF;

2:
    (* wait B arrival at 90 deg before moving C, A stays held at 0 *)
    IF ABS(D12 - 9000) <= pos_tol AND ABS(D13) <= vel_tol THEN
        Y22 := TRUE;
        D28 := D101;   (* target already scaled x100 *)
        D29 := 1000;
        step := 3;
    END_IF;

3:
    (* wait destination stop: B=90, C=target, D=0 all settled; A still held at 0 *)
    IF ABS(D14 - D101) <= pos_tol AND ABS(D15) <= vel_tol THEN
        (* destination stop reached: begin raising D toward final height *)
        D32 := 10000;  (* 100 mm *)
        step := 4;
    END_IF;

4:
    (* wait D arrival at 100 mm (Y clearance established for return) *)
    IF ABS(D16 - 10000) <= pos_tol AND ABS(D17) <= vel_tol THEN
        (* rotate head back flat (Z clearance established for feeder return) *)
        D24 := 0;
        step := 5;
    END_IF;

5:
    (* wait B back at 0 before allowing feeder/lateral overlap *)
    IF ABS(D12 - 0) <= pos_tol AND ABS(D13) <= vel_tol THEN
        (* B already at 0 (high position): feeder re-entry and C retraction may overlap *)
        D20 := 28000;  (* 280 mm *)
        D28 := 0;
        step := 6;
    END_IF;

6:
    (* wait both A and C to reach final positions *)
    IF ABS(D10 - 28000) <= pos_tol AND ABS(D11) <= vel_tol
       AND ABS(D14 - 0) <= pos_tol AND ABS(D15) <= vel_tol THEN
        step := 7;
    END_IF;

7:
    (* final configuration reached: A=280, B=0, C=0, D=100 -- hold and declare completion *)
    Y2 := TRUE;

ELSE
    ;
END_CASE

END_PROGRAM