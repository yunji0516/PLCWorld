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

    r_trig_start : R_TRIG;
    ton_dwell : TON;
    state : INT := 0;
    item_idx : INT := 1;
    target_side : ARRAY [1..4] OF BOOL;
    w1 : INT;
    w2 : INT;
    w3 : INT;
    w4 : INT;
    diff1 : INT;
    diff2 : INT;
    diff3 : INT;
END_VAR

r_trig_start(CLK := X10);
ton_dwell(IN := (state = 20 AND X21), PT := T#50ms);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF r_trig_start.Q THEN
            w1 := D20;
            w2 := D21;
            w3 := D22;
            w4 := D23;

            diff1 := ABS((w1 + w2) - (w3 + w4));
            diff2 := ABS((w1 + w3) - (w2 + w4));
            diff3 := ABS((w1 + w4) - (w2 + w3));

            IF (diff1 <= diff2) AND (diff1 <= diff3) THEN
                target_side[1] := FALSE;
                target_side[2] := FALSE;
                target_side[3] := TRUE;
                target_side[4] := TRUE;
            ELSIF diff2 <= diff3 THEN
                target_side[1] := FALSE;
                target_side[2] := TRUE;
                target_side[3] := FALSE;
                target_side[4] := TRUE;
            ELSE
                target_side[1] := FALSE;
                target_side[2] := TRUE;
                target_side[3] := TRUE;
                target_side[4] := FALSE;
            END_IF;

            item_idx := 1;
            state := 10;
        END_IF;

    10:
        IF item_idx > 4 THEN
            state := 30;
        ELSIF X20 THEN
            IF NOT target_side[item_idx] THEN
                Y20 := TRUE;
                Y21 := FALSE;
            ELSE
                Y20 := FALSE;
                Y21 := TRUE;
            END_IF;
            state := 20;
        END_IF;

    20:
        IF X21 AND ((D26 >= item_idx) OR ton_dwell.Q) THEN
            Y20 := FALSE;
            Y21 := FALSE;
            state := 25;
        END_IF;

    25:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X20 THEN
            item_idx := item_idx + 1;
            state := 10;
        END_IF;

    30:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X23 THEN
            Y22 := FALSE;
            Y2 := TRUE;
            state := 40;
        ELSIF (D26 >= 4) AND X20 AND (ABS(D24 - D25) <= 1) THEN
            Y22 := TRUE;
        END_IF;

    40:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM