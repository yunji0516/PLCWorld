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

    (* Internal variables *)
    stage      : INT := 0;
    started    : BOOL := FALSE;
    targetVal  : DINT := 0;
    postol     : DINT := 20;   (* 0.2 physical unit * 100 *)
    veltol     : DINT := 100;  (* 1 physical unit * 100 *)
END_VAR

(* Latch start request - enables must never activate before X0 *)
IF X0 THEN
    started := TRUE;
END_IF;

CASE stage OF

0: (* Wait for start request; keep all axes disabled *)
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
    D20 := 0; D21 := 0;
    D24 := 0; D25 := 0;
    D28 := 0; D29 := 0;
    D32 := 0; D33 := 0;
    IF started THEN
        targetVal := D101;
        stage := 1;
    END_IF;

1: (* Retract feeder A to 0 ; hold B,C,D at 0 (feeder retreat test) *)
    Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE;
    D20 := 0;    D21 := 1000;
    D24 := 0;    D25 := 1000;
    D28 := 0;    D29 := 1000;
    D32 := 0;    D33 := 1000;
    IF (ABS(D10 - 0) <= postol) AND (ABS(D11) <= veltol) THEN
        stage := 2;
    END_IF;

2: (* Raise head D to 100 mm before crossing destination cheeks; A stays 0 *)
    D20 := 0;
    D24 := 0;
    D28 := 0;
    D32 := 10000; D33 := 1000;
    IF (ABS(D16 - 10000) <= postol) AND (ABS(D17) <= veltol) THEN
        stage := 3;
    END_IF;

3: (* Rotate head B to 90 and move C to target while elevated (D=100); A stays 0 *)
    D20 := 0;
    D24 := 9000;  D25 := 1000;
    D28 := targetVal; D29 := 1000;
    D32 := 10000; D33 := 1000;
    IF (ABS(D12 - 9000) <= postol) AND (ABS(D13) <= veltol) AND
       (ABS(D14 - targetVal) <= postol) AND (ABS(D15) <= veltol) THEN
        stage := 4;
    END_IF;

4: (* Lower D to 0 : first destination stop B=90,C=target,D=0 ; A remains 0 *)
    D20 := 0;
    D32 := 0; D33 := 1000;
    IF (ABS(D16 - 0) <= postol) AND (ABS(D17) <= veltol) AND
       (ABS(D12 - 9000) <= postol) AND (ABS(D13) <= veltol) AND
       (ABS(D14 - targetVal) <= postol) AND (ABS(D15) <= veltol) THEN
        stage := 5;
    END_IF;

5: (* Return: raise D back to 100 before rotating/retracting *)
    D32 := 10000; D33 := 1000;
    IF (ABS(D16 - 10000) <= postol) AND (ABS(D17) <= veltol) THEN
        stage := 6;
    END_IF;

6: (* Rotate B back to 0 while elevated (D=100) *)
    D24 := 0; D25 := 1000;
    IF (ABS(D12 - 0) <= postol) AND (ABS(D13) <= veltol) THEN
        stage := 7;
    END_IF;

7: (* Retract C back to 0 (B already 0, elevated D=100) *)
    D28 := 0; D29 := 1000;
    IF (ABS(D14 - 0) <= postol) AND (ABS(D15) <= veltol) THEN
        stage := 8;
    END_IF;

8: (* Feeder re-entry: A to 280 ; B already 0 gives fork Z-clearance *)
    D20 := 28000; D21 := 1000;
    IF (ABS(D10 - 28000) <= postol) AND (ABS(D11) <= veltol) AND
       (ABS(D12 - 0) <= postol) AND (ABS(D13) <= veltol) AND
       (ABS(D14 - 0) <= postol) AND (ABS(D15) <= veltol) AND
       (ABS(D16 - 10000) <= postol) AND (ABS(D17) <= veltol) THEN
        stage := 9;
    END_IF;

9: (* Final hold : A=280,B=0,C=0,D=100 ; assert and maintain completion *)
    D20 := 28000; D21 := 1000;
    D24 := 0;     D25 := 1000;
    D28 := 0;     D29 := 1000;
    D32 := 10000; D33 := 1000;
    Y2 := TRUE;

ELSE
    stage := 0;

END_CASE;

END_PROGRAM