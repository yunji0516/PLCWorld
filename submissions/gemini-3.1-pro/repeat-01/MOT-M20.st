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
    Y22 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    start_U : DINT := 0;
    target_pos : DINT := 0;
    
    v_real : REAL;
    min_dist_real : REAL;
    min_dist : DINT;
    rem : DINT;
    cur_rem : DINT;
    diff : DINT;
    
    in_pos : BOOL;
    timer_settle : TON;
END_VAR

in_pos := (state = 5) AND (ABS(D11 - target_pos) <= 20) AND (ABS(D12) <= 100);
timer_settle(IN := in_pos, PT := T#30ms);

IF NOT X10 THEN
    state := 0;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    D21 := 0;
ELSE
    CASE state OF
        0:
            state := 1;
            
        1: 
            D20 := D15;
            Y20 := TRUE;
            state := 2;
            
        2: 
            IF X12 THEN
                Y20 := FALSE;
            END_IF;
            
            IF X11 THEN
                Y20 := FALSE;
                start_U := D10;
                state := 3;
            END_IF;
            
        3: 
            IF (D10 - start_U) >= D14 THEN
                Y21 := TRUE;
                state := 4;
            END_IF;
            
        4: 
            IF NOT X12 THEN
                Y21 := FALSE;
                
                rem := D13 MOD 36000;
                IF rem < 0 THEN 
                    rem := rem + 36000; 
                END_IF;
                
                cur_rem := D11 MOD 36000;
                IF cur_rem < 0 THEN 
                    cur_rem := cur_rem + 36000; 
                END_IF;
                
                diff := rem - cur_rem;
                IF diff < 0 THEN 
                    diff := diff + 36000; 
                END_IF;
                
                target_pos := D11 + diff;
                
                v_real := REAL(D12) / 100.0;
                min_dist_real := (v_real * v_real) / 144.0;
                min_dist := DINT(min_dist_real) + 1000; 
                
                WHILE (target_pos - D11) < min_dist DO
                    target_pos := target_pos + 36000;
                END_WHILE;
                
                D21 := target_pos;
                Y22 := TRUE;
                state := 5;
            END_IF;
            
        5: 
            IF timer_settle.Q THEN
                state := 6;
            END_IF;
            
        6: 
            Y2 := TRUE;
            
    END_CASE;
END_IF;

END_PROGRAM