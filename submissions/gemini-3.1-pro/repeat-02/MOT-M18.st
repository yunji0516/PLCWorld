PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    move_neg : BOOL := FALSE;
    edge_sensor : R_TRIG;
    timer : TON;
    
    cmd_a_target : DINT := 0;
    cmd_a_rate : DINT := 0;
    cmd_a_en : BOOL := FALSE;
    
    cmd_b_target : DINT := 0;
    cmd_b_rate : DINT := 0;
    cmd_b_en : BOOL := FALSE;
    
    cmd_c_target : DINT := 0;
    cmd_c_rate : DINT := 0;
    cmd_c_en : BOOL := FALSE;
    
    cmd_conf : BOOL := FALSE;
END_VAR

edge_sensor(CLK := X34);

CASE state OF
    0:
        IF X0 THEN
            IF D10 > 9000 THEN
                move_neg := TRUE;
            ELSE
                move_neg := FALSE;
            END_IF;
            state := 1;
        END_IF;
        
    1:
        cmd_b_target := 0;
        cmd_b_rate := 1000;
        cmd_b_en := TRUE;
        
        IF ABS(D12 - cmd_b_target) <= 20 AND ABS(D13) <= 100 THEN
            state := 2;
        END_IF;
        
    2:
        cmd_c_target := 10000;
        cmd_c_rate := 1000;
        cmd_c_en := TRUE;
        
        IF ABS(D14 - cmd_c_target) <= 20 AND ABS(D15) <= 100 THEN
            state := 3;
        END_IF;
        
    3:
        IF move_neg THEN
            cmd_a_target := 0;
        ELSE
            cmd_a_target := 16000;
        END_IF;
        cmd_a_rate := 200;
        cmd_a_en := TRUE;
        
        IF edge_sensor.Q THEN
            state := 4;
        END_IF;
        
    4:
        cmd_a_en := FALSE;
        
        IF ABS(D11) <= 100 THEN
            state := 5;
        END_IF;
        
    5:
        cmd_conf := TRUE;
        
        IF X35 THEN
            state := 6;
        END_IF;
        
    6:
        cmd_conf := FALSE;
        cmd_a_target := D90 + D101;
        cmd_a_rate := 1000;
        cmd_a_en := TRUE;
        
        IF ABS(D10 - cmd_a_target) <= 20 AND ABS(D11) <= 100 
           AND ABS(D12 - cmd_b_target) <= 20 AND ABS(D13) <= 100
           AND ABS(D14 - cmd_c_target) <= 20 AND ABS(D15) <= 100 THEN
            state := 7;
        END_IF;
        
    7:
        (* Maintain final state for completion timer *)
        ;
END_CASE

timer(IN := (state = 7), PT := T#100ms);

D20 := cmd_a_target;
D21 := cmd_a_rate;
Y20 := cmd_a_en;

D24 := cmd_b_target;
D25 := cmd_b_rate;
Y21 := cmd_b_en;

D28 := cmd_c_target;
D29 := cmd_c_rate;
Y22 := cmd_c_en;

Y30 := cmd_conf;
Y2 := timer.Q;

END_PROGRAM