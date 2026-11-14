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
    start_edge : R_TRIG;
    state : INT := 0;
    current_target : DINT := 0;
    slot_idx : DINT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q AND D10 = 1 AND X22 THEN
            state := 1;
            slot_idx := 0;
            current_target := 0;
        END_IF;
    1:
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF X22 THEN
            IF current_target > D20 + 4 THEN
                Y20 := TRUE;
                Y21 := FALSE;
            ELSIF current_target < D20 - 4 THEN
                Y20 := FALSE;
                Y21 := TRUE;
            ELSE
                Y20 := FALSE;
                Y21 := FALSE;
                state := 2;
            END_IF;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
        END_IF;
    2:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF X25 THEN
            IF NOT X24 THEN
                state := 3;
            ELSE
                slot_idx := slot_idx + 1;
                IF slot_idx > 3 THEN
                    state := 5;
                ELSE
                    current_target := slot_idx * 160;
                    state := 1;
                END_IF;
            END_IF;
        END_IF;
    3:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF X23 OR X26 THEN
            state := 4;
        END_IF;
    4:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X22 THEN
            state := 5;
        END_IF;
    5:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM