PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D94 : DINT;
    D95 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    comp_timer : TON;
    edge_start : R_TRIG;
    arrived_a : BOOL;
    arrived_b : BOOL;
    pose_ready : BOOL;
END_VAR

arrived_a := (ABS(D10 - D101) <= 20) AND (ABS(D11) <= 100);
arrived_b := (ABS(D12 - D102) <= 20) AND (ABS(D13) <= 100);
pose_ready := arrived_a AND arrived_b;

edge_start(CLK := X0);
comp_timer(IN := (state = 6), PT := T#100ms);

CASE state OF
    0: (* WAIT START *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        D20 := 0;
        D24 := 0;
        D21 := 0;
        D25 := 0;
        IF edge_start.Q THEN
            state := 1;
        END_IF;
        
    1: (* MOVE TO POSE *)
        D20 := D101;
        D24 := D102;
        D21 := 1000;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        Y30 := FALSE;
        Y2 := FALSE;
        IF pose_ready THEN
            state := 2;
        END_IF;
        
    2: (* WAIT READY *)
        Y30 := FALSE;
        IF NOT X34 THEN
            state := 3;
        END_IF;
        
    3: (* REQUEST PULSE *)
        Y30 := TRUE;
        IF X34 THEN
            state := 4;
        END_IF;
        
    4: (* BUSY / HOLD POSE *)
        Y30 := FALSE;
        D20 := D101;
        D24 := D102;
        D21 := 1000;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        IF X35 THEN
            state := 5;
        END_IF;
        
    5: (* RETRACT B *)
        D20 := D101;
        D24 := 0;
        D21 := 1000;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
            state := 6;
        END_IF;
        
    6: (* COMPLETE *)
        Y2 := TRUE;
        IF comp_timer.Q THEN
            state := 7;
        END_IF;
        
    7: (* HOLD COMPLETE *)
        Y2 := TRUE;
        D20 := D101;
        D24 := 0;
        D21 := 1000;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        
END_CASE;

END_PROGRAM