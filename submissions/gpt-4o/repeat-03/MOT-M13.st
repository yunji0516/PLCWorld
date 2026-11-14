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
    D102 : DINT;
    D103 : DINT;
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
    target_a : DINT;
    target_b : DINT;
    target_c : DINT;
    target_d : DINT;
    rate_a : DINT;
    rate_b : DINT;
    rate_c : DINT;
    rate_d : DINT;
    engage : BOOL;
    start_timer : TON;
    completion_timer : TON;
    docking_complete : BOOL;
    edge_start : R_TRIG;
    initialized : BOOL := FALSE;
END_VAR

(* Initialize variables *)
IF NOT initialized THEN
    target_a := 0;
    target_b := 0;
    target_c := 0;
    target_d := 0;
    rate_a := 0;
    rate_b := 0;
    rate_c := 0;
    rate_d := 0;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := FALSE;
    initialized := TRUE;
END_IF

(* Detect start edge *)
edge_start(CLK := X0);
engage := edge_start.Q;

(* Control Logic *)
IF engage THEN
    (* Start Loader A and Lift D in parallel *)
    IF D10 < 12000 THEN
        target_a := 12000;
        rate_a := 1000;
        Y20 := TRUE;
    ELSE
        target_a := 10000;
        rate_a := 1000;
    END_IF
    
    IF D16 < D103 THEN
        target_d := D103;
        rate_d := 1000;
        Y23 := TRUE;
    ELSE
        IF D10 < 11500 AND D14 > (D102 - 4000) THEN
            (* Maintain D at receive position *)
            target_d := D103;
            rate_d := 1000;
        ELSE
            target_d := 0;
            rate_d := 1000;
        END_IF
    END_IF
    
    (* Control Tilt B and Forward C *)
    target_b := D101;
    rate_b := 1000;
    Y21 := TRUE;
    
    IF D14 < D102 THEN
        target_c := D102;
        rate_c := 1000;
        Y22 := TRUE;
    ELSE
        target_c := 0;
        rate_c := 1000;
    END_IF
    
    (* Check if docking is complete *)
    docking_complete := (ABS(D10 - 10000) <= 200) AND (ABS(D12 - D101) <= 200) AND (ABS(D14 - D102) <= 200) AND (ABS(D16 - D103) <= 200);
    
    (* Completion Status *)
    IF docking_complete THEN
        IF NOT start_timer.Q THEN
            start_timer(IN := TRUE, PT := T#15s);
        END_IF
    ELSE
        start_timer(IN := FALSE);
    END_IF
    
    IF start_timer.Q THEN
        completion_timer(IN := TRUE, PT := T#100ms);
        IF completion_timer.Q THEN
            Y2 := TRUE;
        END_IF
    END_IF
    
ELSE
    (* Disable all axes if not engaged *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    target_a := 0;
    target_b := 0;
    target_c := 0;
    target_d := 0;
    rate_a := 0;
    rate_b := 0;
    rate_c := 0;
    rate_d := 0;
    Y2 := FALSE;
    start_timer(IN := FALSE);
    completion_timer(IN := FALSE);
END_IF

(* Apply calculated targets and rates *)
D20 := target_a;
D21 := rate_a;
D24 := target_b;
D25 := rate_b;
D28 := target_c;
D29 := rate_c;
D32 := target_d;
D33 := rate_d;
END_PROGRAM