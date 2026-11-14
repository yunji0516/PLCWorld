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
    sensor_edge_pos : DINT;
    edge_detect : R_TRIG;
    completion_timer : TON;
END_VAR

CASE state OF
    0: // WAIT_START — do not enable any axis before X0
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        D20 := 0;
        D21 := 0;
        D24 := 0;
        D25 := 0;
        D28 := 0;
        D29 := 0;
        
        IF X0 THEN
            state := 1;
        END_IF;
        
    1: // RETRACT_B — move B to 0 to clear tool from overhang risk
        Y20 := FALSE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        
        Y21 := TRUE;
        D24 := 0;
        D25 := 500;
        
        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            state := 2;
        END_IF;
        
    2: // RAISE_C — raise head to C=100 to clear guards
        Y20 := FALSE;
        Y21 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        
        Y22 := TRUE;
        D28 := 10000;
        D29 := 500;
        
        IF ABS(D14 - 10000) <= 20 AND ABS(D15) <= 100 THEN
            state := 3;
        END_IF;
        
    3: // CLEAR_SENSOR_IF_NEEDED — ensure X34 is FALSE before seeking fresh edge
        Y21 := TRUE;
        D24 := 0;
        D25 := 500;
        Y22 := TRUE;
        D28 := 10000;
        D29 := 500;
        Y30 := FALSE;
        Y2 := FALSE;
        
        Y20 := TRUE;
        D20 := 0;
        D21 := 200;
        
        IF NOT X34 THEN
            state := 4;
        END_IF;
        
    4: // SEEK_SENSOR — move A toward sensor region at low speed, detect OFF→ON
        Y21 := TRUE;
        D24 := 0;
        D25 := 500;
        Y22 := TRUE;
        D28 := 10000;
        D29 := 500;
        Y30 := FALSE;
        Y2 := FALSE;
        
        Y20 := TRUE;
        D20 := 7500;
        D21 := 100;
        
        edge_detect(CLK := X34);
        IF edge_detect.Q THEN
            sensor_edge_pos := D10;
            state := 5;
        END_IF;
        
    5: // STOP_AFTER_EDGE — stop A within 10 mm (1000 scaled) of the latched edge
        Y21 := TRUE;
        D24 := 0;
        D25 := 500;
        Y22 := TRUE;
        D28 := 10000;
        D29 := 500;
        Y30 := FALSE;
        Y2 := FALSE;
        
        D20 := sensor_edge_pos;
        D21 := 100;
        
        IF ABS(D10 - sensor_edge_pos) <= 1000 AND ABS(D11) <= 100 THEN
            state := 6;
        END_IF;
        
    6: // CONFIGURE — assert Y30 to register origin, keep B and C at targets
        Y20 := FALSE;
        Y2 := FALSE;
        
        Y21 := TRUE;
        D24 := 0;
        D25 := 500;
        
        Y22 := TRUE;
        D28 := 10000;
        D29 := 500;
        
        Y30 := TRUE;
        
        IF X35 THEN
            Y30 := FALSE;
            state := 7;
        END_IF;
        
    7: // MOVE_FINAL — move A to D90+park, maintain B=0 and C=100
        Y30 := FALSE;
        Y2 := FALSE;
        
        Y20 := TRUE;
        D20 := D90 + D101;
        D21 := 500;
        
        Y21 := TRUE;
        D24 := 0;
        D25 := 500;
        
        Y22 := TRUE;
        D28 := 10000;
        D29 := 500;
        
        IF ABS(D10 - (D90 + D101)) <= 20 AND ABS(D11) <= 100 THEN
            IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
                IF ABS(D14 - 10000) <= 20 AND ABS(D15) <= 100 THEN
                    state := 8;
                END_IF;
            END_IF;
        END_IF;
        
    8: // STABILIZE_AND_COMPLETE — wait 100 ms then assert completion
        Y30 := FALSE;
        
        completion_timer(IN := TRUE, PT := T#100ms);
        IF completion_timer.Q THEN
            Y2 := TRUE;
            state := 9;
        END_IF;
        
    9: // DONE — maintain final position and completion flag
        Y2 := TRUE;
        Y30 := FALSE;
        
        Y20 := TRUE;
        D20 := D90 + D101;
        D21 := 500;
        
        Y21 := TRUE;
        D24 := 0;
        D25 := 500;
        
        Y22 := TRUE;
        D28 := 10000;
        D29 := 500;
END_CASE;

END_PROGRAM