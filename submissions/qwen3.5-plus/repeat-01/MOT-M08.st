PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    edge_det : R_TRIG;
    latched_pos : REAL := 0.0;
    a_target_phys : REAL := 0.0;
    pitch_phys : REAL := 0.0;
    index_phys : REAL := 0.0;
    reach_phys : REAL := 0.0;
END_VAR

edge_det(CLK := X34);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        IF X0 THEN
            state := 1;
        END_IF;
        
    1:
        D21 := 500;
        D20 := 10000;
        Y20 := TRUE;
        IF edge_det.Q THEN
            latched_pos := D10 / 100.0;
            state := 2;
        END_IF;
        
    2:
        D20 := DINT((latched_pos + 5.0) * 100.0);
        IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 THEN
            state := 3;
        END_IF;
        
    3:
        Y30 := TRUE;
        state := 4;
        
    4:
        Y30 := FALSE;
        pitch_phys := D101 / 100.0;
        index_phys := D102 / 100.0;
        reach_phys := D103 / 100.0;
        a_target_phys := REAL(D90) + index_phys * pitch_phys;
        D20 := DINT(a_target_phys * 100.0);
        state := 5;
        
    5:
        D20 := DINT(a_target_phys * 100.0);
        IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 THEN
            state := 6;
        END_IF;
        
    6:
        D25 := 500;
        D24 := DINT(reach_phys * 100.0);
        Y21 := TRUE;
        IF ABS(D12 - D24) <= 20 AND ABS(D13) <= 100 THEN
            state := 7;
        END_IF;
        
    7:
        D24 := 0;
        IF ABS(D12 - D24) <= 20 AND ABS(D13) <= 100 THEN
            state := 8;
        END_IF;
        
    8:
        Y2 := TRUE;
        state := 9;
        
    9:
        Y2 := TRUE;
END_CASE;

END_PROGRAM