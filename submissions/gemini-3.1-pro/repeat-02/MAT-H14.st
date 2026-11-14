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
    
    running : BOOL;
    in_state : INT;
    out_state : INT;
    lane1_tare : INT;
    lane2_tare : INT;
    lane1_in_use : BOOL;
    lane2_in_use : BOOL;
    seq_pre_req : INT;
    seq_post_req : INT;
    current_tare : INT;
    current_gross : INT;
    out_active_lane : INT;
    net_mass : INT;
END_VAR

IF X0 THEN
    running := TRUE;
END_IF;

IF NOT X17 THEN lane1_in_use := FALSE; END_IF;
IF NOT X19 THEN lane2_in_use := FALSE; END_IF;

IF running THEN
    CASE in_state OF
        0:
            in_state := 1;
        1:
            IF NOT X11 AND X1F AND X10 THEN
                Y10 := TRUE;
            END_IF;
            IF X11 THEN
                Y10 := FALSE;
                in_state := 2;
            END_IF;
        2:
            Y17 := TRUE;
            IF X1E THEN
                in_state := 3;
            END_IF;
        3:
            IF NOT X12 AND NOT X15 THEN
                seq_pre_req := seq_pre_req + 1;
                IF seq_pre_req > 30000 THEN seq_pre_req := 1; END_IF;
                D202 := seq_pre_req;
                Y11 := TRUE;
                in_state := 4;
            END_IF;
        4:
            Y11 := FALSE;
            IF D4 = seq_pre_req AND NOT X15 AND NOT X12 THEN
                current_tare := D2;
                in_state := 5;
            END_IF;
        5:
            Y17 := FALSE;
            IF X1F THEN
                in_state := 6;
            END_IF;
        6:
            IF X17 AND NOT lane1_in_use THEN
                lane1_tare := current_tare;
                lane1_in_use := TRUE;
                D200 := 1;
                Y12 := TRUE;
                in_state := 7;
            ELSIF X19 AND NOT lane2_in_use THEN
                lane2_tare := current_tare;
                lane2_in_use := TRUE;
                D200 := 2;
                Y12 := TRUE;
                in_state := 7;
            END_IF;
        7:
            IF NOT X11 THEN
                Y12 := FALSE;
                in_state := 1;
            END_IF;
    END_CASE;

    CASE out_state OF
        0:
            out_state := 1;
        1:
            IF NOT X13 AND X21 THEN
                IF X18 THEN
                    D201 := 1;
                    Y13 := TRUE;
                    out_active_lane := 1;
                    out_state := 2;
                ELSIF X1A THEN
                    D201 := 2;
                    Y13 := TRUE;
                    out_active_lane := 2;
                    out_state := 2;
                END_IF;
            END_IF;
        2:
            IF X13 THEN
                Y13 := FALSE;
                out_state := 3;
            END_IF;
        3:
            Y18 := TRUE;
            IF X20 THEN
                out_state := 4;
            END_IF;
        4:
            IF NOT X14 AND NOT X16 THEN
                seq_post_req := seq_post_req + 1;
                IF seq_post_req > 30000 THEN seq_post_req := 1; END_IF;
                D203 := seq_post_req;
                Y14 := TRUE;
                out_state := 5;
            END_IF;
        5:
            Y14 := FALSE;
            IF D5 = seq_post_req AND NOT X16 AND NOT X14 THEN
                current_gross := D3;
                out_state := 6;
            END_IF;
        6:
            Y18 := FALSE;
            IF X21 THEN
                out_state := 7;
            END_IF;
        7:
            IF out_active_lane = 1 THEN
                net_mass := current_gross - lane1_tare;
            ELSE
                net_mass := current_gross - lane2_tare;
            END_IF;
            
            IF net_mass >= 95 AND net_mass <= 105 THEN
                D204 := 1;
                IF X1B THEN
                    Y15 := TRUE;
                    out_state := 8;
                END_IF;
            ELSE
                D204 := 2;
                IF X1C THEN
                    Y15 := TRUE;
                    out_state := 8;
                END_IF;
            END_IF;
        8:
            IF NOT X13 THEN
                Y15 := FALSE;
                out_state := 1;
            END_IF;
    END_CASE;
    
    IF X1D AND NOT X10 AND NOT X11 AND NOT X13 AND X17 AND X19 AND in_state = 1 AND out_state = 1 THEN
        Y16 := TRUE;
    END_IF;
END_IF;

END_PROGRAM