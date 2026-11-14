PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT;
    D204 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    
    state : INT := 0;
    trays_done : DINT := 0;
    seq_pre_val : INT := 0;
    seq_post_val : INT := 0;
    pre_mass_val : INT := 0;
    post_mass_val : INT := 0;
    current_lane : INT := 0;
    out_lane_val : INT := 0;
    route_val : INT := 0;
    clear1_flag : BOOL := FALSE;
    clear2_flag : BOOL := FALSE;
END_VAR

(* Default outputs *)
Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
D200 := current_lane;
D201 := out_lane_val;
D202 := seq_pre_val;
D203 := seq_post_val;
D204 := route_val;

CASE state OF
    0: (* IDLE *)
        IF X0 AND X10 AND trays_done < 4 THEN
            state := 10;
        END_IF;
        
    10: (* FEED *)
        Y10 := X10 AND NOT X11;
        IF X11 THEN
            state := 20;
        END_IF;
        
    20: (* PRE_LIFT *)
        Y17 := TRUE;
        IF X1E THEN
            state := 30;
        END_IF;
        
    30: (* PRE_MEAS_REQ *)
        Y11 := TRUE;
        seq_pre_val := seq_pre_val + 1;
        state := 31;
        
    31: (* PRE_MEAS_WAIT *)
        Y11 := FALSE;
        IF D4 = seq_pre_val THEN
            pre_mass_val := D2;
            state := 40;
        END_IF;
        
    40: (* PRE_LOWER *)
        Y17 := FALSE;
        IF X1F THEN
            state := 50;
        END_IF;
        
    50: (* REQ_LANE *)
        IF X17 THEN
            current_lane := 1;
            state := 60;
        ELSIF X19 THEN
            current_lane := 2;
            state := 60;
        END_IF;
        
    60: (* TO_LANE *)
        Y12 := TRUE;
        state := 61;
        
    61: (* WAIT_KIT *)
        Y12 := FALSE;
        IF (current_lane = 1 AND X18) OR (current_lane = 2 AND X1A) THEN
            state := 70;
        END_IF;
        
    70: (* LOAD_POST *)
        Y13 := TRUE;
        out_lane_val := current_lane;
        state := 71;
        
    71: (* WAIT_POST_PRESENT *)
        Y13 := FALSE;
        IF X13 THEN
            state := 80;
        END_IF;
        
    80: (* POST_LIFT *)
        Y18 := TRUE;
        IF X20 THEN
            state := 90;
        END_IF;
        
    90: (* POST_MEAS_REQ *)
        Y14 := TRUE;
        seq_post_val := seq_post_val + 1;
        state := 91;
        
    91: (* POST_MEAS_WAIT *)
        Y14 := FALSE;
        IF D5 = seq_post_val THEN
            post_mass_val := D3;
            state := 100;
        END_IF;
        
    100: (* POST_LOWER *)
        Y18 := FALSE;
        IF X21 THEN
            state := 110;
        END_IF;
        
    110: (* CALC_ROUTE *)
        IF (post_mass_val - pre_mass_val) >= 95 AND (post_mass_val - pre_mass_val) <= 105 THEN
            route_val := 1;
        ELSE
            route_val := 2;
        END_IF;
        
        IF (route_val = 1 AND X1B) OR (route_val = 2 AND X1C) THEN
            state := 120;
        END_IF;
        
    120: (* DISPATCH *)
        Y15 := TRUE;
        state := 121;
        
    121: (* WAIT_CLEAR *)
        Y15 := FALSE;
        IF route_val = 1 THEN
            IF NOT X1B THEN clear1_flag := TRUE; END_IF;
            IF clear1_flag AND X1B THEN
                clear1_flag := FALSE;
                trays_done := trays_done + 1;
                IF trays_done < 4 THEN
                    state := 0;
                ELSE
                    state := 200;
                END_IF;
            END_IF;
        ELSE
            IF NOT X1C THEN clear2_flag := TRUE; END_IF;
            IF clear2_flag AND X1C THEN
                clear2_flag := FALSE;
                trays_done := trays_done + 1;
                IF trays_done < 4 THEN
                    state := 0;
                ELSE
                    state := 200;
                END_IF;
            END_IF;
        END_IF;
        
    200: (* COMPLETE *)
        Y16 := TRUE;
END_CASE;
END_PROGRAM