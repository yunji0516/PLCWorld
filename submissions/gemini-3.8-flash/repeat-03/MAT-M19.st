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

    r_trig_x10 : R_TRIG;
    state : INT := 0;
    items_done : INT := 0;
    target_side : ARRAY [0..3] OF BOOL;
    diff1 : INT;
    diff2 : INT;
END_VAR

r_trig_x10(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF r_trig_x10.Q THEN
            diff1 := ABS((D20 + D21) - (D22 + D23));
            diff2 := ABS((D20 + D22) - (D21 + D23));
            IF diff1 <= 1 THEN
                target_side[0] := FALSE;
                target_side[1] := FALSE;
                target_side[2] := TRUE;
                target_side[3] := TRUE;
            ELSIF diff2 <= 1 THEN
                target_side[0] := FALSE;
                target_side[1] := TRUE;
                target_side[2] := FALSE;
                target_side[3] := TRUE;
            ELSE
                target_side[0] := FALSE;
                target_side[1] := TRUE;
                target_side[2] := TRUE;
                target_side[3] := FALSE;
            END_IF;
            items_done := 0;
            state := 1;
        END_IF;

    1:
        IF NOT target_side[items_done] THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSE
            Y20 := FALSE;
            Y21 := TRUE;
        END_IF;
        IF X21 THEN
            Y20 := FALSE;
            Y21 := FALSE;
            state := 2;
        END_IF;

    2:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X20 THEN
            items_done := items_done + 1;
            IF items_done >= 4 THEN
                state := 3;
            ELSE
                state := 1;
            END_IF;
        END_IF;

    3:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        IF X23 THEN
            Y22 := FALSE;
            state := 4;
        END_IF;

    4:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM