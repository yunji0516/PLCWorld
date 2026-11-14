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

    pre_state : INT := 0;
    post_state : INT := 0;
    pre_seq_counter : INT := 0;
    post_seq_counter : INT := 0;
    pre_tare : INT := 0;
    post_gross : INT := 0;
    net_mass : INT := 0;
    lane1_tare : INT := 0;
    lane2_tare : INT := 0;
    current_post_tare : INT := 0;
    lane1_busy : BOOL := FALSE;
    lane2_busy : BOOL := FALSE;
    active_out_lane : INT := 0;
    trays_completed : INT := 0;
END_VAR

// Inbound Sequence (Source -> Inbound Scale -> Kit Workstation)
CASE pre_state OF
    0:
        Y12 := FALSE;
        IF X10 AND NOT X11 THEN
            Y10 := TRUE;
            pre_state := 1;
        END_IF;
        
    1:
        IF X11 THEN
            Y10 := FALSE;
            pre_state := 2;
        END_IF;
        
    2:
        Y17 := TRUE;
        Y11 := FALSE; 
        IF X1E THEN
            pre_state := 3;
        END_IF;
        
    3:
        IF NOT X12 AND NOT X15 THEN 
            pre_seq_counter := pre_seq_counter + 1;
            D202 := pre_seq_counter;
            Y11 := TRUE;
            pre_state := 4;
        END_IF;
        
    4:
        IF D4 = pre_seq_counter THEN
            pre_tare := D2;
            Y11 := FALSE;
            pre_state := 5;
        END_IF;
        
    5:
        Y17 := FALSE;
        Y11 := FALSE;
        IF X1F THEN
            pre_state := 6;
        END_IF;
        
    6:
        IF X17 AND NOT lane1_busy THEN
            D200 := 1;
            Y12 := TRUE;
            lane1_tare := pre_tare;
            lane1_busy := TRUE;
            pre_state := 7;
        ELSIF X19 AND NOT lane2_busy THEN
            D200 := 2;
            Y12 := TRUE;
            lane2_tare := pre_tare;
            lane2_busy := TRUE;
            pre_state := 7;
        END_IF;
        
    7:
        IF NOT X11 THEN
            Y12 := FALSE;
            pre_state := 0;
        END_IF;
END_CASE;

// Outbound Sequence (Kit Workstation -> Finished Scale -> Dispatch)
CASE post_state OF
    0:
        Y15 := FALSE;
        IF NOT X13 AND X21 THEN
            IF X18 AND lane1_busy THEN
                D201 := 1;
                Y13 := TRUE;
                current_post_tare := lane1_tare;
                active_out_lane := 1;
                post_state := 1;
            ELSIF X1A AND lane2_busy THEN
                D201 := 2;
                Y13 := TRUE;
                current_post_tare := lane2_tare;
                active_out_lane := 2;
                post_state := 1;
            END_IF;
        END_IF;
        
    1:
        IF X13 THEN
            Y13 := FALSE;
            IF active_out_lane = 1 THEN
                lane1_busy := FALSE;
            ELSIF active_out_lane = 2 THEN
                lane2_busy := FALSE;
            END_IF;
            post_state := 2;
        END_IF;
        
    2:
        Y18 := TRUE;
        Y14 := FALSE;
        IF X20 THEN
            post_state := 3;
        END_IF;
        
    3:
        IF NOT X14 AND NOT X16 THEN 
            post_seq_counter := post_seq_counter + 1;
            D203 := post_seq_counter;
            Y14 := TRUE;
            post_state := 4;
        END_IF;
        
    4:
        IF D5 = post_seq_counter THEN
            post_gross := D3;
            Y14 := FALSE;
            post_state := 5;
        END_IF;
        
    5:
        Y18 := FALSE;
        Y14 := FALSE;
        IF X21 THEN
            net_mass := post_gross - current_post_tare;
            IF net_mass >= 95 AND net_mass <= 105 THEN
                D204 := 1;
            ELSE
                D204 := 2;
            END_IF;
            post_state := 6;
        END_IF;
        
    6:
        IF (D204 = 1 AND X1B) OR (D204 = 2 AND X1C) THEN
            Y15 := TRUE;
            post_state := 7;
        END_IF;
        
    7:
        IF NOT X13 THEN
            Y15 := FALSE;
            trays_completed := trays_completed + 1;
            post_state := 0;
        END_IF;
END_CASE;

// Task Completion
IF trays_completed >= 4 AND 
   pre_state = 0 AND 
   post_state = 0 AND 
   NOT lane1_busy AND 
   NOT lane2_busy AND 
   NOT X11 AND 
   NOT X13 THEN
    Y16 := TRUE;
END_IF;

END_PROGRAM