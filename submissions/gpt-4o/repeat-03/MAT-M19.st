PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;
    D23 : INT;
    D24 : INT;
    D25 : INT;
    D26 : INT;

    start_trigger : R_TRIG;
    state : INT := 0; (* 0: Idle, 1: Load Left, 2: Load Right, 3: Depart *)
    load_left : BOOL;
    load_right : BOOL;
    depart_complete : BOOL;
    total_loaded : INT := 0;
    current_side : BOOL; (* TRUE: Left, FALSE: Right *)
    weights : ARRAY[1..4] OF INT;
    weight_sum_left : INT := 0;
    weight_sum_right : INT := 0;
END_VAR

(* Implement the control logic here. *)

start_trigger(CLK := X10);

IF start_trigger.Q THEN
    IF D10 = 4 THEN
        weights[1] := D20;
        weights[2] := D21;
        weights[3] := D22;
        weights[4] := D23;
        state := 1; (* Start loading process *)
    END_IF;
END_IF;

CASE state OF
    0: (* Idle *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        
    1: (* Load Left *)
        IF X20 AND (NOT X21) THEN (* Module at home *)
            IF (load_left = FALSE) AND (D26 < 4) THEN
                current_side := TRUE; (* Load to Left *)
                IF D26 = 0 THEN (* Load first material to left *)
                    Y20 := TRUE;
                    weight_sum_left := weight_sum_left + weights[1 + D26];
                    load_left := TRUE;
                ELSIF D26 = 1 THEN (* Load second material to left *)
                    Y20 := TRUE;
                    weight_sum_left := weight_sum_left + weights[1 + D26];
                    load_left := TRUE;
                ELSIF D26 = 2 THEN (* Load third or fourth material to left for balance if needed *)
                    IF weight_sum_left <= weight_sum_right THEN
                        Y20 := TRUE;
                        weight_sum_left := weight_sum_left + weights[1 + D26];
                        load_left := TRUE;
                    ELSE
                        state := 2; (* Skip to load right if balance needed *)
                    END_IF;
                END_IF;
            END_IF;
        END_IF;
        
        IF X22 THEN
            total_loaded := total_loaded + 1;
            load_left := FALSE;
            state := 2; (* Move to next state to load Right *)
        END_IF;

    2: (* Load Right *)
        IF X20 AND (NOT X21) THEN (* Module at home *)
            IF (load_right = FALSE) AND (D26 < 4) THEN
                current_side := FALSE; (* Load to Right *)
                IF (D26 = 0) OR (D26 = 1) THEN (* Assuming the loading order might be altered for balance *)
                    state := 1; (* Switch back to left for the first two simply *)
                ELSIF D26 = 2 THEN (* Load third or fourth material to right for balance if needed *)
                    IF weight_sum_right < weight_sum_left THEN
                        Y21 := TRUE;
                        weight_sum_right := weight_sum_right + weights[1 + D26];
                        load_right := TRUE;
                    ELSE
                        state := 1; (* Switch back to left for loading balance *)
                    END_IF;
                ELSIF D26 = 3 THEN (* Load fourth material to right *)
                    Y21 := TRUE;
                    weight_sum_right := weight_sum_right + weights[1 + D26];
                    load_right := TRUE;
                END_IF;
            END_IF;
        END_IF;

        IF X22 THEN
            total_loaded := total_loaded + 1;
            load_right := FALSE;
            IF total_loaded = 4 THEN
                state := 3; (* Proceed to depart after loading all materials *)
            ELSE
                state := 1; (* Go to Load Left side check *)
            END_IF;
        END_IF;

    3: (* Depart *)
        IF weight_sum_left <= weight_sum_right + 1 AND weight_sum_right <= weight_sum_left + 1 THEN
            IF NOT X23 THEN
                Y22 := TRUE;
            ELSE
                depart_complete := TRUE;
            END_IF;
        END_IF;

        IF depart_complete THEN
            Y22 := FALSE; (* Ensure all outputs are off after departure *)
            Y2 := TRUE;   (* Set completion flag *)
        END_IF;
END_CASE;

END_PROGRAM