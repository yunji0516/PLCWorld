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
    x34_edge : R_TRIG;
    edge_pos : DINT;
    brake_target : DINT;
    target_A : DINT;
    pos_diff_A : DINT;
    pos_diff_B : DINT;
END_VAR

x34_edge(CLK := X34);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        D21 := 0;
        D25 := 0;
        If X0 Then
            state := 1;
        End_If;
    
    1:
        Y20 := TRUE;
        D21 := 500;
        D20 := 10000;
        Y30 := FALSE;
        
        If x34_edge.Q Then
            edge_pos := D10;
            brake_target := edge_pos + 500;
            state := 2;
        End_If;
    
    2:
        Y20 := TRUE;
        D21 := 500;
        D20 := brake_target;
        
        pos_diff_A := D10 - edge_pos;
        If (ABS(D11) < 100) And (pos_diff_A >= 0) And (pos_diff_A <= 1000) Then
            state := 3;
        End_If;
    
    3:
        Y30 := TRUE;
        state := 4;
    
    4:
        Y30 := FALSE;
        Y20 := TRUE;
        D21 := 500;
        D20 := edge_pos;
        
        If X35 Then
            state := 5;
        End_If;
    
    5:
        Y20 := TRUE;
        D21 := 500;
        target_A := D90 + (D102 * D101) / 100;
        D20 := target_A;
        
        pos_diff_A := D10 - target_A;
        If (ABS(D11) < 100) And (ABS(pos_diff_A) < 20) Then
            state := 6;
        End_If;
    
    6:
        Y20 := TRUE;
        D20 := target_A;
        Y21 := TRUE;
        D25 := 500;
        D24 := D103;
        
        pos_diff_B := D12 - D103;
        If (ABS(D13) < 100) And (ABS(pos_diff_B) < 20) Then
            state := 7;
        End_If;
    
    7:
        Y20 := TRUE;
        D20 := target_A;
        Y21 := TRUE;
        D25 := 500;
        D24 := 0;
        
        pos_diff_B := D12;
        If (ABS(D13) < 100) And (ABS(pos_diff_B) < 20) Then
            state := 8;
        End_If;
    
    8:
        Y20 := TRUE;
        D20 := target_A;
        Y21 := TRUE;
        D24 := 0;
        Y2 := TRUE;
END_CASE;

END_PROGRAM