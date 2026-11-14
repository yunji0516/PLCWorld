PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    init_D10 : DINT;
    init_D12 : DINT;
    safe_retract : DINT;
    
    abs_d12_d15 : DINT;
    abs_d13 : DINT;
    term_cond : BOOL;
    
    timer_30ms : TON;
END_VAR

safe_retract := MIN(50000, D16);

IF state = 0 THEN
    D20 := D10;
    D21 := D12;
    Y20 := TRUE;
    Y21 := TRUE;
    Y2 := FALSE;
    
    IF X10 THEN
        init_D10 := D10;
        init_D12 := D12;
        (* If table is already settled at requested target, skip retraction/rotation space requirement *)
        IF X12 AND (ABS(D10 - D14) <= 20) THEN
            state := 3;
        ELSE
            state := 1;
        END_IF;
    END_IF;
END_IF;

IF state = 1 THEN
    D21 := MIN(init_D12, safe_retract);
    D20 := init_D10;
    Y20 := TRUE;
    Y21 := TRUE;
    Y2 := FALSE;
    
    (* Wait for actual slide retraction physically establishing safety clearance *)
    IF X11 AND (D12 <= safe_retract) THEN
        state := 2;
    END_IF;
END_IF;

IF state = 2 THEN
    D21 := MIN(init_D12, safe_retract);
    D20 := D14;
    Y20 := TRUE;
    Y21 := TRUE;
    Y2 := FALSE;
    
    (* Wait for actual table-settled condition at target *)
    IF X12 THEN
        state := 3;
    END_IF;
END_IF;

IF state = 3 THEN
    D21 := D15;
    D20 := D14;
    Y20 := TRUE;
    Y21 := TRUE;
    Y2 := FALSE;
END_IF;

abs_d12_d15 := ABS(D12 - D15);
abs_d13 := ABS(D13);

(* Terminal condition evaluates the combined stability of both axes *)
term_cond := X12 AND (abs_d12_d15 <= 20) AND (abs_d13 <= 100);

timer_30ms(IN := ((state = 3) OR (state = 4)) AND term_cond, PT := T#30ms);

IF (state = 3) AND timer_30ms.Q THEN
    state := 4;
END_IF;

IF state = 4 THEN
    D21 := D15;
    D20 := D14;
    Y20 := TRUE;
    Y21 := TRUE;
    Y2 := TRUE;
END_IF;

END_PROGRAM