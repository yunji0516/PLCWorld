PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    D20 : INT;
    D22 : INT;

    start_edge : R_TRIG;
    state : INT := 0;
    cur_layer : INT := 1;
    req_layer : ARRAY[1..4] OF INT;
    target_x : INT := -700;
    adjust_table_enable : BOOL := FALSE;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        adjust_table_enable := FALSE;

        IF start_edge.Q THEN
            req_layer[1] := D11;
            req_layer[2] := D12;
            req_layer[3] := D13;
            req_layer[4] := D14;
            cur_layer := 1;
            state := 10;
        END_IF;

    10:
        IF req_layer[cur_layer] = 0 THEN
            target_x := -700;
        ELSE
            target_x := 700;
        END_IF;
        adjust_table_enable := TRUE;
        state := 20;

    20:
        adjust_table_enable := TRUE;
        IF X23 THEN
            IF target_x = -700 THEN
                IF (NOT X20) AND (D20 > -700) THEN
                    Y21 := TRUE;
                    Y22 := FALSE;
                ELSE
                    Y21 := FALSE;
                    Y22 := FALSE;
                    IF X20 AND X29 THEN
                        state := 30;
                    END_IF;
                END_IF;
            ELSE
                IF (NOT X21) AND (D20 < 700) THEN
                    Y22 := TRUE;
                    Y21 := FALSE;
                ELSE
                    Y21 := FALSE;
                    Y22 := FALSE;
                    IF X21 AND X29 THEN
                        state := 30;
                    END_IF;
                END_IF;
            END_IF;
        ELSE
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := TRUE;
            Y24 := FALSE;
        END_IF;

    30:
        Y21 := FALSE;
        Y22 := FALSE;
        adjust_table_enable := TRUE;
        IF X27 AND (ABS(D20 - target_x) <= 9) THEN
            state := 40;
        END_IF;

    40:
        adjust_table_enable := TRUE;
        Y24 := TRUE;
        Y23 := FALSE;
        IF X24 THEN
            Y24 := FALSE;
            state := 50;
        END_IF;

    50:
        adjust_table_enable := TRUE;
        Y20 := TRUE;
        IF X25 THEN
            state := 60;
        END_IF;

    60:
        adjust_table_enable := TRUE;
        Y20 := TRUE;
        Y23 := TRUE;
        Y24 := FALSE;
        IF X23 THEN
            Y23 := FALSE;
            state := 70;
        END_IF;

    70:
        Y20 := TRUE;
        adjust_table_enable := TRUE;
        IF X23 THEN
            IF (D20 < 0) AND (NOT X22) THEN
                Y22 := TRUE;
                Y21 := FALSE;
            ELSIF (D20 > 0) AND (NOT X22) THEN
                Y21 := TRUE;
                Y22 := FALSE;
            ELSE
                Y21 := FALSE;
                Y22 := FALSE;
            END_IF;

            IF X22 AND X29 AND (ABS(D20) <= 9) AND (D22 = 700) AND (NOT Y26) AND (NOT Y27) THEN
                state := 80;
            END_IF;
        ELSE
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := TRUE;
            Y24 := FALSE;
        END_IF;

    80:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        adjust_table_enable := FALSE;
        Y24 := TRUE;
        Y23 := FALSE;
        IF X24 THEN
            Y24 := FALSE;
            state := 90;
        END_IF;

    90:
        adjust_table_enable := FALSE;
        Y20 := FALSE;
        IF X26 AND X28 THEN
            state := 100;
        END_IF;

    100:
        adjust_table_enable := FALSE;
        Y20 := FALSE;
        Y23 := TRUE;
        Y24 := FALSE;
        IF X23 THEN
            Y23 := FALSE;
            IF cur_layer = 4 THEN
                state := 110;
            ELSE
                cur_layer := cur_layer + 1;
                state := 10;
            END_IF;
        END_IF;

    110:
        adjust_table_enable := FALSE;
        Y20 := FALSE;
        IF X23 THEN
            IF (NOT X20) AND (D20 > -700) THEN
                Y21 := TRUE;
                Y22 := FALSE;
            ELSE
                Y21 := FALSE;
                Y22 := FALSE;
                IF X20 AND X29 THEN
                    state := 120;
                END_IF;
            END_IF;
        ELSE
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := TRUE;
            Y24 := FALSE;
        END_IF;

    120:
        adjust_table_enable := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        Y2 := TRUE;
END_CASE;

IF adjust_table_enable THEN
    IF D22 > 700 THEN
        Y26 := TRUE;
        Y27 := FALSE;
    ELSIF D22 < 700 THEN
        Y27 := TRUE;
        Y26 := FALSE;
    ELSE
        Y26 := FALSE;
        Y27 := FALSE;
    END_IF;
ELSE
    Y26 := FALSE;
    Y27 := FALSE;
END_IF;

END_PROGRAM