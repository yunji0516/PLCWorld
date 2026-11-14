```
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
    
    start_edge : R_TRIG;
    a_sensor : R_TRIG;
    
    state : INT;
    a_ref_pos : DINT;
    a_stop_target : DINT;
    a_final_target : DINT;
    d90_plus_park : DINT;
    ref_detected : BOOL;
    
    tol_pos : DINT := 20;
    tol_vel : DINT := 100;
END_VAR

CASE state OF
    0: (* WAIT_START - wait for start signal, no axes enabled *)
        start_edge(CLK := X0);
        Y30 := FALSE;
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        D24 := 0;
        D28 := 0;
        IF start_edge.Q THEN
            state := 1;
            D24 := 0;
            D28 := 100 * 100;
        END_IF;
        
    1: (* B_RETRACT - retract internal tool B to 0 *)
        Y21 := TRUE;
        D25 := 1000;
        D24 := 0;
        Y30 := FALSE;
        Y2 := FALSE;
        Y20 := FALSE;
        Y22 := FALSE;
        IF (ABS(D24 - D12) <= tol_pos) AND (ABS(D13) <= tol_vel) THEN
            Y21 := FALSE;
            state := 2;
        END_IF;
        
    2: (* C_RAISE - raise elevation C to 100 *)
        Y22 := TRUE;
        D29 := 1000;
        D28 := 100 * 100;
        Y30 := FALSE;
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF (ABS(D28 - D14) <= tol_pos) AND (ABS(D15) <= tol_vel) THEN
            Y22 := FALSE;
            state := 3;
        END_IF;
        
    3: (* A_SEARCH - search for reference sensor on A axis *)
        Y20 := TRUE;
        D21 := 1000;
        D20 := 350 * 100;
        Y30 := FALSE;
        Y2 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        
        (* Detect edge of reference sensor *)
        a_sensor(CLK := X34);
        IF (a_sensor.Q) AND (X34 = TRUE) THEN
            a_ref_pos := D10;
            a_stop_target := a_ref_pos + 10 * 100;
            D20 := a_stop_target;
            D21 := 1000;
            ref_detected := TRUE;
            state := 4;
        END_IF;
        
    4: (* A_SEARCH_STOPPED - stop within 10mm after edge *)
        Y20 := TRUE;
        D21 := 1000;
        D20 := a_stop_target;
        Y30 := FALSE;
        Y2 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        
        IF (ABS(a_stop_target - D10) <= tol_pos) AND (ABS(D11) <= tol_vel) THEN
            state := 5;
        END_IF;
        
    5: (* REGISTER - pulse Y30 to register origin *)
        Y30 := TRUE;
        d90_plus_park := D90 + D101;
        a_final_target := d90_plus_park * 100;
        Y2 := FALSE;
        state := 6;
        
    6: (* A_FINAL - move A to final position D90 + park *)
        Y20 := TRUE;
        D21 := 1000;
        D20 := a_final_target;
        Y30 := FALSE;
        Y2 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        
        IF (ABS(a_final_target - D10) <= tol_pos) AND (ABS(D11) <= tol_vel) THEN
            state := 7;
        END_IF;
        
    7: (* COMPLETE - assert completion signal *)
        Y20 := FALSE;
        Y30 := FALSE;
        Y2 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        
END_CASE;

END_PROGRAM
```