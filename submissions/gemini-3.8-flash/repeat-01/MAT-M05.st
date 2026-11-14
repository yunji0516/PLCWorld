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

    rtrig_start : R_TRIG;
    started : BOOL := FALSE;
    state : INT := 0;
    current_layer : INT := 1;
    layer_req : ARRAY [1..4] OF INT;
    dwell_count : INT := 0;
    from_left : BOOL := FALSE;
END_VAR

rtrig_start(CLK := X10);

IF rtrig_start.Q AND (state = 0) THEN
    layer_req[1] := D11;
    layer_req[2] := D12;
    layer_req[3] := D13;
    layer_req[4] := D14;
    current_layer := 1;
    started := TRUE;
    dwell_count := 0;
    state := 10;
END_IF;

IF started THEN
    CASE state OF
        10: (* GO_TO_SOURCE *)
            IF layer_req[current_layer] = 0 THEN
                IF X20 OR (D20 <= -700) THEN
                    Y21 := FALSE;
                    Y22 := FALSE;
                    dwell_count := 0;
                    state := 15;
                ELSE
                    Y21 := TRUE;
                    Y22 := FALSE;
                END_IF;
            ELSE
                IF X21 OR (D20 >= 700) THEN
                    Y21 := FALSE;
                    Y22 := FALSE;
                    dwell_count := 0;
                    state := 15;
                ELSE
                    Y21 := FALSE;
                    Y22 := TRUE;
                END_IF;
            END_IF;

        15: (* WAIT_STOP_AT_SOURCE *)
            Y21 := FALSE;
            Y22 := FALSE;
            IF X29 AND X27 THEN
                dwell_count := dwell_count + 1;
                IF dwell_count >= 5 THEN
                    dwell_count := 0;
                    state := 20;
                END_IF;
            ELSE
                dwell_count := 0;
            END_IF;

        20: (* LOWER_AT_SOURCE *)
            Y24 := TRUE;
            Y23 := FALSE;
            IF X24 THEN
                Y24 := FALSE;
                dwell_count := 0;
                state := 25;
            END_IF;

        25: (* GRIP_AT_SOURCE *)
            Y20 := TRUE;
            IF X25 THEN
                dwell_count := dwell_count + 1;
                IF dwell_count >= 5 THEN
                    dwell_count := 0;
                    state := 30;
                END_IF;
            ELSE
                dwell_count := 0;
            END_IF;

        30: (* RAISE_AT_SOURCE *)
            Y23 := TRUE;
            Y24 := FALSE;
            IF X23 THEN
                Y23 := FALSE;
                dwell_count := 0;
                from_left := (D20 < 0);
                state := 40;
            END_IF;

        40: (* GO_TO_STACK *)
            IF from_left THEN
                IF X22 OR (D20 >= 0) THEN
                    Y22 := FALSE;
                    dwell_count := 0;
                    state := 45;
                ELSE
                    Y22 := TRUE;
                    Y21 := FALSE;
                END_IF;
            ELSE
                IF X22 OR (D20 <= 0) THEN
                    Y21 := FALSE;
                    dwell_count := 0;
                    state := 45;
                ELSE
                    Y21 := TRUE;
                    Y22 := FALSE;
                END_IF;
            END_IF;

        45: (* WAIT_STOP_AT_STACK *)
            Y21 := FALSE;
            Y22 := FALSE;
            IF X29 AND (X22 OR ((D20 >= -5) AND (D20 <= 5))) THEN
                dwell_count := dwell_count + 1;
                IF dwell_count >= 5 THEN
                    dwell_count := 0;
                    state := 50;
                END_IF;
            ELSE
                dwell_count := 0;
            END_IF;

        50: (* ADJUST_TABLE *)
            IF D22 > 700 THEN
                Y26 := TRUE;
                Y27 := FALSE;
                dwell_count := 0;
            ELSIF D22 < 700 THEN
                Y26 := FALSE;
                Y27 := TRUE;
                dwell_count := 0;
            ELSE
                Y26 := FALSE;
                Y27 := FALSE;
                dwell_count := dwell_count + 1;
                IF dwell_count >= 5 THEN
                    dwell_count := 0;
                    state := 60;
                END_IF;
            END_IF;

        60: (* LOWER_AT_STACK *)
            Y24 := TRUE;
            Y23 := FALSE;
            IF X24 THEN
                Y24 := FALSE;
                dwell_count := 0;
                state := 65;
            END_IF;

        65: (* RELEASE_AT_STACK *)
            Y20 := FALSE;
            IF X26 AND X28 THEN
                dwell_count := dwell_count + 1;
                IF dwell_count >= 5 THEN
                    dwell_count := 0;
                    state := 70;
                END_IF;
            ELSE
                dwell_count := 0;
            END_IF;

        70: (* RAISE_AT_STACK *)
            Y23 := TRUE;
            Y24 := FALSE;
            IF X23 THEN
                Y23 := FALSE;
                dwell_count := 0;
                IF current_layer < 4 THEN
                    current_layer := current_layer + 1;
                    state := 10;
                ELSE
                    state := 80;
                END_IF;
            END_IF;

        80: (* GO_HOME *)
            IF X20 OR (D20 <= -700) THEN
                Y21 := FALSE;
                dwell_count := 0;
                state := 85;
            ELSE
                Y21 := TRUE;
                Y22 := FALSE;
            END_IF;

        85: (* WAIT_STOP_AT_HOME *)
            Y21 := FALSE;
            Y22 := FALSE;
            IF X29 AND (X20 OR (D20 <= -695)) AND X23 THEN
                dwell_count := dwell_count + 1;
                IF dwell_count >= 10 THEN
                    dwell_count := 0;
                    state := 90;
                END_IF;
            ELSE
                dwell_count := 0;
            END_IF;

        90: (* CLAIM_COMPLETION *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            Y24 := FALSE;
            Y26 := FALSE;
            Y27 := FALSE;
            Y2 := TRUE;
    END_CASE;
END_IF;

(* Safety interlocks and pre-start holding *)
IF NOT started THEN
    Y2 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y26 := FALSE;
    Y27 := FALSE;
ELSE
    IF NOT X23 THEN
        Y21 := FALSE;
        Y22 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
    END_IF;
    IF Y21 OR Y22 THEN
        Y24 := FALSE;
    END_IF;
    IF Y21 AND Y22 THEN
        Y21 := FALSE;
        Y22 := FALSE;
    END_IF;
    IF Y23 AND Y24 THEN
        Y23 := FALSE;
        Y24 := FALSE;
    END_IF;
    IF Y26 AND Y27 THEN
        Y26 := FALSE;
        Y27 := FALSE;
    END_IF;
END_IF;

END_PROGRAM