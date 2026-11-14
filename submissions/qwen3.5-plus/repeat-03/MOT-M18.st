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
    
    state : INT;
    edge_sensor : R_TRIG;
    timer_y30 : TON;
    sensor_pos : DINT;
    stop_pos : DINT;
END_VAR

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        timer_y30(IN := FALSE);
        edge_sensor(CLK := FALSE);
        IF X0 THEN
            state := 1;
        END_IF;
        
    1:
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        Y20 := FALSE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        timer_y30(IN := FALSE);
        edge_sensor(CLK := FALSE);
        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            state := 2;
        END_IF;
        
    2:
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        Y20 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        timer_y30(IN := FALSE);
        edge_sensor(CLK := FALSE);
        IF ABS(D14 - 10000) <= 20 AND ABS(D15) <= 100 THEN
            state := 3;
            D20 := 4000;
            D21 := 1000;
            Y20 := TRUE;
        END_IF;
        
    3:
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;
        D20 := 4000;
        D21 := 1000;
        Y20 := TRUE;
        Y30 := FALSE;
        Y2 := FALSE;
        timer_y30(IN := FALSE);
        edge_sensor(CLK := FALSE);
        IF ABS(D10 - 4000) <= 20 AND ABS(D11) <= 100 THEN
            state := 4;
            D20 := 10000;
            D21 := 1000;
        END_IF;
        
    4:
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;
        D20 := 10000;
        D21 := 1000;
        Y20 := TRUE;
        Y30 := FALSE;
        Y2 := FALSE;
        timer_y30(IN := FALSE);
        
        edge_sensor(CLK := X34);
        IF edge_sensor.Q THEN
            sensor_pos := D10;
            stop_pos := sensor_pos;
            D20 := stop_pos;
            state := 5;
        END_IF;
        
    5:
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;
        D20 := stop_pos;
        D21 := 1000;
        Y20 := TRUE;
        Y30 := FALSE;
        Y2 := FALSE;
        timer_y30(IN := FALSE);
        edge_sensor(CLK := FALSE);
        
        IF ABS(D10 - stop_pos) <= 20 AND ABS(D11) <= 100 THEN
            state := 6;
        END_IF;
        
    6:
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;
        D20 := stop_pos;
        D21 := 1000;
        Y20 := TRUE;
        Y2 := FALSE;
        
        Y30 := TRUE;
        timer_y30(IN := TRUE, PT := T#100ms);
        edge_sensor(CLK := FALSE);
        IF timer_y30.Q THEN
            Y30 := FALSE;
            state := 7;
        END_IF;
        
    7:
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;
        D20 := D90 + D101;
        D21 := 1000;
        Y20 := TRUE;
        Y30 := FALSE;
        Y2 := FALSE;
        timer_y30(IN := FALSE);
        edge_sensor(CLK := FALSE);
        
        IF ABS(D10 - (D90 + D101)) <= 20 AND ABS(D11) <= 100 THEN
            state := 8;
        END_IF;
        
    8:
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;
        
        D20 := D90 + D101;
        D21 := 1000;
        Y20 := TRUE;
        Y30 := FALSE;
        timer_y30(IN := FALSE);
        edge_sensor(CLK := FALSE);
        
        IF ABS(D10 - (D90 + D101)) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12) <= 20 AND ABS(D13) <= 100 AND
           ABS(D14 - 10000) <= 20 AND ABS(D15) <= 100 THEN
            Y2 := TRUE;
        ELSE
            Y2 := FALSE;
        END_IF;
        
END_CASE;
END_PROGRAM