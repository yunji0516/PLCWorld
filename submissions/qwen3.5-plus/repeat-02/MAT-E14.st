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
    dir : INT;
END_VAR

(* State machine: 0 = IDLE, 1 = MOVING, 2 = DONE *)

CASE state OF
    0: (* IDLE: wait for start request rising edge, then decide direction *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        start_edge(CLK := X10);
        IF start_edge.Q THEN
            (* Evaluate load imbalance for left vs right placement *)
            (* left_diff = |(D21 + D20) - D22|, right_diff = |D21 - (D22 + D20)| *)
            IF ABS(DINT(D21) + DINT(D20) - DINT(D22)) <= ABS(DINT(D21) - DINT(D22) - DINT(D20)) THEN
                (* Left side gives smaller or equal imbalance *)
                IF X22 THEN
                    dir := -1; (* Feed left *)
                ELSE
                    dir := 1; (* Fallback: feed right *)
                END_IF;
            ELSE
                (* Right side gives smaller imbalance *)
                IF X23 THEN
                    dir := 1; (* Feed right *)
                ELSE
                    dir := -1; (* Fallback: feed left *)
                END_IF;
            END_IF;
            state := 1;
        END_IF;

    1: (* MOVING: feed in chosen direction until receipt confirmed *)
        IF dir = -1 THEN
            Y20 := TRUE;
            Y21 := FALSE;
            IF X20 THEN
                Y20 := FALSE;
                Y21 := FALSE;
                Y2 := TRUE;
                state := 2;
            END_IF;
        ELSE
            Y20 := FALSE;
            Y21 := TRUE;
            IF X21 THEN
                Y20 := FALSE;
                Y21 := FALSE;
                Y2 := TRUE;
                state := 2;
            END_IF;
        END_IF;

    2: (* DONE: hold result through remaining evaluation budget *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM