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
    D18 : DINT;
    D19 : DINT;
    D101 : DINT;
    D102 : DINT;
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
    D36 : DINT;
    D37 : DINT;
    Y24 : BOOL;
    Y2 : BOOL;
    step : INT := 0;
    startEdge : R_TRIG;
    posTol : DINT := 20;
    velTol : DINT := 100;
END_VAR

(* Step 0: Wait for start request *)
IF step = 0 THEN
    startEdge(CLK := X0);
    IF startEdge.Q THEN
        step := 10;
    END_IF;
END_IF;

(* Step 10: Open A and B vertical plates to 50mm *)
IF step = 10 THEN
    D20 := 5000; D21 := 800; Y20 := TRUE;
    D24 := 5000; D25 := 800; Y21 := TRUE;
    step := 11;
END_IF;

(* Step 11: Wait for A and B arrival at 50mm *)
IF step = 11 THEN
    IF ABS(D10 - 5000) <= posTol AND ABS(D11) <= velTol AND
       ABS(D12 - 5000) <= posTol AND ABS(D13) <= velTol THEN
        step := 20;
    END_IF;
END_IF;

(* Step 20: Move C transfer jig to target *)
IF step = 20 THEN
    D28 := D101; D29 := 800; Y22 := TRUE;
    step := 21;
END_IF;

(* Step 21: Wait for C arrival at target *)
IF step = 21 THEN
    IF ABS(D14 - D101) <= posTol AND ABS(D15) <= velTol THEN
        step := 30;
    END_IF;
END_IF;

(* Step 30: Move D lower support to 70mm to dock under jig *)
IF step = 30 THEN
    D32 := 7000; D33 := 800; Y23 := TRUE;
    step := 31;
END_IF;

(* Step 31: Wait for D arrival at 70mm *)
IF step = 31 THEN
    IF ABS(D16 - 7000) <= posTol AND ABS(D17) <= velTol THEN
        step := 40;
    END_IF;
END_IF;

(* Step 40: Lower E upper tool to stroke *)
IF step = 40 THEN
    D36 := D102; D37 := 800; Y24 := TRUE;
    step := 41;
END_IF;

(* Step 41: Wait for E arrival at stroke *)
IF step = 41 THEN
    IF ABS(D18 - D102) <= posTol AND ABS(D19) <= velTol THEN
        step := 50;
    END_IF;
END_IF;

(* Step 50: Retract E upper tool to 0 *)
IF step = 50 THEN
    D36 := 0; D37 := 800;
    step := 51;
END_IF;

(* Step 51: Wait for E arrival at 0 *)
IF step = 51 THEN
    IF ABS(D18) <= posTol AND ABS(D19) <= velTol THEN
        step := 60;
    END_IF;
END_IF;

(* Step 60: Retract C transfer jig to 0 *)
IF step = 60 THEN
    D28 := 0; D29 := 800;
    step := 61;
END_IF;

(* Step 61: Wait for C arrival at 0 *)
IF step = 61 THEN
    IF ABS(D14) <= posTol AND ABS(D15) <= velTol THEN
        step := 70;
    END_IF;
END_IF;

(* Step 70: Retract D lower support to 0 *)
IF step = 70 THEN
    D32 := 0; D33 := 800;
    step := 71;
END_IF;

(* Step 71: Wait for D arrival at 0 *)
IF step = 71 THEN
    IF ABS(D16) <= posTol AND ABS(D17) <= velTol THEN
        step := 80;
    END_IF;
END_IF;

(* Step 80: Retract A and B vertical plates to 0 *)
IF step = 80 THEN
    D20 := 0; D21 := 800;
    D24 := 0; D25 := 800;
    step := 81;
END_IF;

(* Step 81: Wait for A and B arrival at 0 *)
IF step = 81 THEN
    IF ABS(D10) <= posTol AND ABS(D11) <= velTol AND
       ABS(D12) <= posTol AND ABS(D13) <= velTol THEN
        step := 90;
    END_IF;
END_IF;

(* Step 90: All axes at 0, assert completion and disable enables *)
IF step = 90 THEN
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE;
    Y2 := TRUE;
END_IF;

END_PROGRAM