PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    hold_timer : TON;
    edge_x0 : R_TRIG;
    start_seen : BOOL := FALSE;
END_VAR

BEGIN
    edge_x0(CLK := X0);
    
    IF NOT start_seen AND edge_x0.Q THEN
        start_seen := TRUE;
    END_IF;
    
    CASE state OF
        0: // IDLE — wait for start request
            Y20 := FALSE;
            Y21 := FALSE;
            Y2 := FALSE;
            hold_timer(IN := FALSE);
            IF start_seen THEN
                state := 1;
            END_IF;
            
        1: // MOVE_TO_CORNER_FORWARD — travel a from ~200 to s=500, B=0
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := 50000;
            D24 := 0;
            D21 := 500;
            D25 := 100;
            hold_timer(IN := FALSE);
            
            IF ABS(D10 - 50000) <= 20 AND ABS(D11) <= 100 THEN
                state := 2;
            END_IF;
            
        2: // HOLD_AT_CORNER_FORWARD — ensure full stop at corner
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := 50000;
            D24 := 0;
            D21 := 100;
            D25 := 100;
            hold_timer(IN := TRUE, PT := T#30ms);
            IF hold_timer.Q THEN
                hold_timer(IN := FALSE);
                state := 3;
            END_IF;
            
        3: // ROTATE_TO_90 — rotate B to 90 deg at corner
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := 50000;
            D24 := 9000;
            D21 := 100;
            D25 := 500;
            hold_timer(IN := FALSE);
            
            IF ABS(D12 - 9000) <= 20 AND ABS(D13) <= 100 THEN
                state := 4;
            END_IF;
            
        4: // MOVE_TO_TARGET — travel a from s=500 to requested target, B=90
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := D101;
            D24 := 9000;
            D21 := 500;
            D25 := 100;
            hold_timer(IN := FALSE);
            
            IF ABS(D10 - D101) <= 20 AND ABS(D11) <= 100 THEN
                state := 5;
            END_IF;
            
        5: // RETURN_TO_CORNER — travel a back from target to s=500, B=90
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := 50000;
            D24 := 9000;
            D21 := 500;
            D25 := 100;
            hold_timer(IN := FALSE);
            
            IF ABS(D10 - 50000) <= 20 AND ABS(D11) <= 100 THEN
                state := 6;
            END_IF;
            
        6: // HOLD_AT_CORNER_RETURN — ensure full stop at corner on return
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := 50000;
            D24 := 9000;
            D21 := 100;
            D25 := 100;
            hold_timer(IN := TRUE, PT := T#30ms);
            IF hold_timer.Q THEN
                hold_timer(IN := FALSE);
                state := 7;
            END_IF;
            
        7: // ROTATE_TO_0 — rotate B back to 0 deg at corner
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := 50000;
            D24 := 0;
            D21 := 100;
            D25 := 500;
            hold_timer(IN := FALSE);
            
            IF ABS(D12 - 0) <= 20 AND ABS(D13) <= 100 THEN
                state := 8;
            END_IF;
            
        8: // RETURN_TO_START — travel a from s=500 back to s=200, B=0
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := 20000;
            D24 := 0;
            D21 := 500;
            D25 := 100;
            hold_timer(IN := FALSE);
            
            IF ABS(D10 - 20000) <= 20 AND ABS(D11) <= 100 THEN
                state := 9;
            END_IF;
            
        9: // COMPLETE — hold at start position, assert completion
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := 20000;
            D24 := 0;
            D21 := 100;
            D25 := 100;
            Y2 := TRUE;
    END_CASE;
END_PROGRAM