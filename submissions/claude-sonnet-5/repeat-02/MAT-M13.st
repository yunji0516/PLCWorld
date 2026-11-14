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

    edge : R_TRIG;
    state : INT := 0;
    sub : INT := 0;
    req_id : INT := 0;
    search_count : INT := 0;
    rotate_remaining : INT := 0;
END_VAR

edge(CLK := X10);

IF edge.Q AND state = 0 THEN
    req_id := D10;
    search_count := 0;
    sub := 0;
    state := 1;
END_IF;

CASE state OF
0:
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;

1: (* search item identity at reader station *)
    Y22 := FALSE;
    Y23 := FALSE;
    CASE sub OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X20 THEN
            IF D20 = req_id THEN
                rotate_remaining := 2;
                state := 2;
                sub := 1;
            ELSE
                search_count := search_count + 1;
                IF search_count >= 4 THEN
                    (* should not occur: exactly one matching item is guaranteed *)
                    state := 0;
                    sub := 0;
                ELSE
                    sub := 1;
                END_IF;
            END_IF;
        END_IF;
    1:
        Y20 := TRUE;
        Y21 := FALSE;
        IF NOT X20 THEN
            sub := 2;
        END_IF;
    2:
        IF X20 THEN
            Y20 := FALSE;
            sub := 0;
        END_IF;
    ELSE
        sub := 0;
    END_CASE;

2: (* rotate found pocket 180 degrees to ejector station *)
    Y22 := FALSE;
    Y23 := FALSE;
    CASE sub OF
    1:
        Y20 := TRUE;
        Y21 := FALSE;
        IF NOT X20 THEN
            sub := 2;
        END_IF;
    2:
        IF X20 THEN
            Y20 := FALSE;
            rotate_remaining := rotate_remaining - 1;
            IF rotate_remaining <= 0 THEN
                state := 3;
                sub := 0;
            ELSE
                sub := 1;
            END_IF;
        END_IF;
    ELSE
        sub := 1;
    END_CASE;

3: (* push only when indexed/aligned *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF X20 THEN
        Y22 := TRUE;
        Y23 := FALSE;
        IF X22 THEN
            Y22 := FALSE;
            state := 5;
        END_IF;
    ELSE
        Y22 := FALSE;
    END_IF;

5: (* retract *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := TRUE;
    IF X21 THEN
        Y23 := FALSE;
        state := 7;
    END_IF;

7: (* terminal hold: verify and latch completion *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF NOT Y2 THEN
        IF X20 AND X21 AND X23 THEN
            Y2 := TRUE;
        END_IF;
    END_IF;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
END_CASE;

END_PROGRAM