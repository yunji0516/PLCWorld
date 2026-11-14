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
    D20 : INT;
    D21 : INT;
    start_edge : R_TRIG;
    aligned_edge : R_TRIG;
    state : INT := 0;
    target_id : INT := 0;
    steps_to_ejector : INT := 0;
END_VAR

start_edge(CLK := X10);
aligned_edge(CLK := X20);

CASE state OF
    0: (* IDLE_WAIT *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            target_id := D10;
            state := 1;
        END_IF;

    1: (* ROTATE_CW_SEARCH *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF aligned_edge.Q THEN
            Y20 := FALSE;
            state := 2;
        END_IF;

    2: (* CHECK_D20 *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF D20 = target_id THEN
            steps_to_ejector := 2;
            state := 3;
        ELSE
            state := 1;
        END_IF;

    3: (* ROTATE_TO_EJECTOR *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF aligned_edge.Q THEN
            Y20 := FALSE;
            steps_to_ejector := steps_to_ejector - 1;
            IF steps_to_ejector > 0 THEN
                state := 3;
            ELSE
                state := 4;
            END_IF;
        END_IF;

    4: (* PUSH_EXTEND *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF X22 THEN
            Y22 := FALSE;
            state := 5;
        END_IF;

    5: (* PUSH_RETRACT *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X21 THEN
            Y23 := FALSE;
            state := 6;
        END_IF;

    6: (* DONE *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM