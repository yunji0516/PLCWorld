PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    
    state : INT := 0;
    target_pos : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        (* Wait for Start request *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q AND D10 = 1 THEN
            state := 1;
            target_pos := 0;
        END_IF;

    1:
        (* Ensure pusher is fully retracted before any rack movement *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X22 THEN
            Y23 := FALSE;
            state := 2;
        END_IF;

    2:
        (* Check alignment and occupancy at current target_pos *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X25 THEN
            IF NOT X24 THEN
                (* Vacant slot found, begin insertion *)
                state := 4;
            ELSE
                (* Slot occupied, advance target position to the next slot *)
                target_pos := target_pos + 160;
                IF target_pos > 480 THEN
                    target_pos := 480;
                END_IF;
                state := 3;
            END_IF;
        ELSE
            (* If not aligned, seek alignment at the target position *)
            state := 3;
        END_IF;

    3:
        (* Move rack until aligned at the target_pos *)
        Y22 := FALSE;
        Y23 := FALSE;
        IF X25 AND ABS(D20 - target_pos) < 4 THEN
            Y20 := FALSE;
            Y21 := FALSE;
            state := 2;
        ELSE
            IF D20 < target_pos THEN
                Y20 := TRUE;
                Y21 := FALSE;
            ELSIF D20 > target_pos THEN
                Y21 := TRUE;
                Y20 := FALSE;
            ELSE
                Y20 := FALSE;
                Y21 := FALSE;
            END_IF;
        END_IF;

    4:
        (* Push plate into the vacant slot *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF X23 THEN
            Y22 := FALSE;
            state := 5;
        END_IF;

    5:
        (* Retract pusher back home *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X22 THEN
            Y23 := FALSE;
            state := 6;
        END_IF;

    6:
        (* Task complete *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM