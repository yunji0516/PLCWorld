PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;
    start_edge : R_TRIG;
    state : INT;
    mass_load : DINT;
    transfer_target : INT;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0: (* IDLE - wait for start request rising edge *)
        IF start_edge.Q THEN
            state := 1;
            mass_load := DINT(D20);
        END_IF;
        
    1: (* DECIDE - evaluate loads BEFORE placement to choose optimal side *)
        (* Calculate resulting absolute load difference for each option *)
        (* diff_if_left = |left_load + mass - right_load| *)
        (* diff_if_right = |left_load - (right_load + mass)| *)
        IF ABS(DINT(D21) + mass_load - DINT(D22)) < ABS(DINT(D21) - (DINT(D22) + mass_load)) THEN
            (* Left gives better balance - check availability *)
            IF X22 THEN
                transfer_target := -1;
            ELSIF X23 THEN
                transfer_target := 1;
            ELSE
                transfer_target := 0;
            END_IF;
        ELSIF ABS(DINT(D21) - (DINT(D22) + mass_load)) < ABS(DINT(D21) + mass_load - DINT(D22)) THEN
            (* Right gives better balance - check availability *)
            IF X23 THEN
                transfer_target := 1;
            ELSIF X22 THEN
                transfer_target := -1;
            ELSE
                transfer_target := 0;
            END_IF;
        ELSE
            (* Tie - prefer left if available *)
            IF X22 THEN
                transfer_target := -1;
            ELSIF X23 THEN
                transfer_target := 1;
            ELSE
                transfer_target := 0;
            END_IF;
        END_IF;
        state := 2;
        
    2: (* TRANSFER - drive to target side until received *)
        IF transfer_target = -1 THEN
            Y20 := TRUE;
            Y21 := FALSE;
            IF X20 THEN
                Y20 := FALSE;
                Y21 := FALSE;
                state := 3;
            END_IF;
        ELSIF transfer_target = 1 THEN
            Y20 := FALSE;
            Y21 := TRUE;
            IF X21 THEN
                Y20 := FALSE;
                Y21 := FALSE;
                state := 3;
            END_IF;
        ELSE
            (* No valid target - stop immediately *)
            Y20 := FALSE;
            Y21 := FALSE;
            state := 3;
        END_IF;
        
    3: (* COMPLETED - hold result and Y2 *)
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        
ELSE
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
END_CASE;

END_PROGRAM