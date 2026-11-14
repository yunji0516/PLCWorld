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
    init : BOOL := FALSE;
    target_retract : DINT := 0;
    ton_combined : TON;
    combined_cond : BOOL;
END_VAR

IF NOT init THEN
    (* Hold current position at rest before the work request *)
    D20 := D10;
    D21 := D12;
    Y20 := TRUE;
    Y21 := TRUE;
    Y2 := FALSE;
    init := TRUE;
END_IF

CASE state OF
    0: (* Wait for request *)
        IF X10 THEN
            (* Calculate the safe retraction target *)
            target_retract := MIN(D21, 50000);
            target_retract := MIN(target_retract, D16);
            D21 := target_retract;
            state := 1;
        END_IF
        
    1: (* Retract slide to safe position *)
        D21 := target_retract;
        IF X11 THEN
            D20 := D14;
            state := 2;
        END_IF
        
    2: (* Rotate table while keeping slide retracted *)
        D20 := D14;
        IF X12 THEN
            D21 := D15;
            state := 3;
        END_IF
        
    3: (* Re-approach slide to the requested entry *)
        D20 := D14;
        D21 := D15;
        
    4: (* Complete and maintain conditions *)
        D20 := D14;
        D21 := D15;
        Y2 := TRUE;
END_CASE

(* Check the combined terminal condition: 
   Table settled (X12) AND slide within +/-0.2 mm AND slide speed <= 1 mm/s *)
combined_cond := X12 AND (ABS(D12 - D15) <= 20) AND (ABS(D13) <= 100);
ton_combined(IN := (state >= 3) AND combined_cond, PT := T#30ms);

IF (state = 3) AND ton_combined.Q THEN
    Y2 := TRUE;
    state := 4;
END_IF

END_PROGRAM