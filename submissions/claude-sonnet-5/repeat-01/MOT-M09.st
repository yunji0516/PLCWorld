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
    step : INT := 0;
    started : BOOL := FALSE;

    posTol : DINT := 20;   (* 0.2 mm * 100 *)
    spdTol : DINT := 100;  (* 1 mm/s * 100 *)

    arrivedA100 : BOOL;
    arrivedB60  : BOOL;
    arrivedC60  : BOOL;
    arrivedDdepth : BOOL;
    arrivedD0 : BOOL;
    arrivedB0 : BOOL;
    arrivedC0 : BOOL;
    arrivedA0 : BOOL;
    allZero : BOOL;
END_VAR

(* Latch start request *)
IF X0 THEN
    started := TRUE;
END_IF;

(* Arrival evaluations, using stated tolerances *)
arrivedA100  := (ABS(D10 - 10000) <= posTol) AND (ABS(D11) <= spdTol);
arrivedB60   := (ABS(D12 - 6000) <= posTol) AND (ABS(D13) <= spdTol);
arrivedC60   := (ABS(D14 - 6000) <= posTol) AND (ABS(D15) <= spdTol);
arrivedDdepth := (ABS(D16 - D101) <= posTol) AND (ABS(D17) <= spdTol);
arrivedD0   := (ABS(D16) <= posTol) AND (ABS(D17) <= spdTol);
arrivedB0   := (ABS(D12) <= posTol) AND (ABS(D13) <= spdTol);
arrivedC0   := (ABS(D14) <= posTol) AND (ABS(D15) <= spdTol);
arrivedA0   := (ABS(D10) <= posTol) AND (ABS(D11) <= spdTol);

CASE step OF

0: (* Idle: wait for start; enables off; targets may be pre-set while off *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    D20 := 0; D21 := 0;
    D24 := 0; D25 := 0;
    D28 := 0; D29 := 0;
    D32 := 0; D33 := 0;
    IF started THEN
        step := 1;
    END_IF;

1: (* Move guide A to 100 mm first *)
    Y20 := TRUE;  D20 := 10000; D21 := 1000;
    Y21 := FALSE; D24 := 0;     D25 := 0;
    Y22 := FALSE; D28 := 0;     D29 := 0;
    Y23 := FALSE; D32 := 0;     D33 := 0;
    IF arrivedA100 THEN
        step := 2;
    END_IF;

2: (* Lock both side pins B and C to 60 mm; order free, done together *)
    Y20 := TRUE; D20 := 10000; D21 := 1000;
    Y21 := TRUE; D24 := 6000;  D25 := 1000;
    Y22 := TRUE; D28 := 6000;  D29 := 1000;
    Y23 := FALSE; D32 := 0;    D33 := 0;
    IF arrivedA100 AND arrivedB60 AND arrivedC60 THEN
        step := 3;
    END_IF;

3: (* Internal access: drive D to requested depth while locking maintained *)
    Y20 := TRUE; D20 := 10000; D21 := 1000;
    Y21 := TRUE; D24 := 6000;  D25 := 1000;
    Y22 := TRUE; D28 := 6000;  D29 := 1000;
    Y23 := TRUE; D32 := D101;  D33 := 1000;
    IF arrivedDdepth THEN
        step := 4;
    END_IF;

4: (* Retrieve D back to 0 while locking still maintained (D>5 guard) *)
    Y20 := TRUE; D20 := 10000; D21 := 1000;
    Y21 := TRUE; D24 := 6000;  D25 := 1000;
    Y22 := TRUE; D28 := 6000;  D29 := 1000;
    Y23 := TRUE; D32 := 0;     D33 := 1000;
    IF arrivedD0 THEN
        step := 5;
    END_IF;

5: (* After D fully retrieved, retrieve locking pins B and C *)
    Y20 := TRUE; D20 := 10000; D21 := 1000;
    Y21 := TRUE; D24 := 0;     D25 := 1000;
    Y22 := TRUE; D28 := 0;     D29 := 1000;
    Y23 := TRUE; D32 := 0;     D33 := 1000;
    IF arrivedB0 AND arrivedC0 THEN
        step := 6;
    END_IF;

6: (* Finally retrieve guide A to 0 *)
    Y20 := TRUE; D20 := 0;   D21 := 1000;
    Y21 := TRUE; D24 := 0;   D25 := 1000;
    Y22 := TRUE; D28 := 0;   D29 := 1000;
    Y23 := TRUE; D32 := 0;   D33 := 1000;
    IF arrivedA0 THEN
        step := 7;
    END_IF;

7: (* Done: hold all axes at 0 *)
    Y20 := TRUE; D20 := 0;   D21 := 1000;
    Y21 := TRUE; D24 := 0;   D25 := 1000;
    Y22 := TRUE; D28 := 0;   D29 := 1000;
    Y23 := TRUE; D32 := 0;   D33 := 1000;

ELSE
    step := 0;

END_CASE;

allZero := arrivedA0 AND arrivedB0 AND arrivedC0 AND arrivedD0;
Y2 := (step = 7) AND allZero;

END_PROGRAM