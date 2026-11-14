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
    
    req_edge : R_TRIG;
    slide_settle : TON;
    combined_settle : TON;
    complete_hold : TON;
    
    state : INT := 0;
    slide_cond : BOOL;
    retract_target : DINT := 50000;
END_VAR

req_edge(CLK := X10);

slide_cond := (ABS(D12 - D15) <= 20) AND (ABS(D13) <= 100);
slide_settle(IN := (state = 3 OR state = 4) AND slide_cond, PT := T#30ms);

CASE state OF
    0: (* Idle *)
        D20 := D10;
        D21 := D12;
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF req_edge.Q THEN
            state := 1;
        END_IF;
        
    1: (* Retract slide *)
        D21 := retract_target;
        Y21 := TRUE;
        Y20 := FALSE;
        D20 := D14;
        IF X11 THEN
            state := 2;
        END_IF;
        
    2: (* Rotate table *)
        D20 := D14;
        Y20 := TRUE;
        Y21 := FALSE;
        D21 := retract_target;
        IF X12 THEN
            state := 3;
        END_IF;
        
    3: (* Approach slide *)
        D21 := D15;
        Y21 := TRUE;
        Y20 := FALSE;
        D20 := D14;
        IF slide_settle.Q AND X12 THEN
            state := 4;
        END_IF;
        
    4: (* Combined settle 30ms *)
        D21 := D15;
        Y21 := TRUE;
        Y20 := FALSE;
        D20 := D14;
        combined_settle(IN := X12 AND slide_settle.Q, PT := T#30ms);
        IF combined_settle.Q THEN
            Y2 := TRUE;
            state := 5;
        END_IF;
        
    5: (* Maintain 100ms *)
        complete_hold(IN := state = 5, PT := T#100ms);
        IF complete_hold.Q THEN
            state := 6;
        END_IF;
        
    6: (* Done *)
        Y2 := TRUE;
        D20 := D14;
        D21 := D15;
        Y20 := FALSE;
        Y21 := FALSE;
END_CASE;

END_PROGRAM