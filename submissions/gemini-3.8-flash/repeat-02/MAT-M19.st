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

    trig_start : R_TRIG;
    state : INT := 0;
    current_item : INT := 0;
    side : ARRAY[1..4] OF INT;
    d1 : INT;
    d2 : INT;
    d3 : INT;
END_VAR

trig_start(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;

        IF trig_start.Q THEN
            d1 := ABS((D20 + D21) - (D22 + D23));
            d2 := ABS((D20 + D22) - (D21 + D23));
            d3 := ABS((D20 + D23) - (D21 + D22));

            IF d1 <= 1 THEN
                side[1] := 1;
                side[2] := 1;
                side[3] := 2;
                side[4] := 2;
            ELSIF d2 <= 1 THEN
                side[1] := 1;
                side[2] := 2;
                side[3] := 1;
                side[4] := 2;
            ELSE
                side[1] := 1;
                side[2] := 2;
                side[3] := 2;
                side[4] := 1;
            END_IF;

            current_item := 1;
            state := 10;
        END_IF;

    10:
        IF current_item <= 4 THEN
            IF X20 THEN
                IF side[current_item] = 1 THEN
                    Y20 := TRUE;
                    Y21 := FALSE;
                    state := 11;
                ELSE
                    Y20 := FALSE;
                    Y21 := TRUE;
                    state := 12;
                END_IF;
            END_IF;
        ELSE
            IF X20 AND (D26 >= 4 OR X22) THEN
                state := 20;
            END_IF;
        END_IF;

    11:
        IF X21 THEN
            Y20 := FALSE;
            state := 13;
        END_IF;

    12:
        IF X21 THEN
            Y21 := FALSE;
            state := 13;
        END_IF;

    13:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X20 AND (D26 >= current_item) THEN
            current_item := current_item + 1;
            state := 10;
        END_IF;

    20:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        state := 30;

    30:
        Y22 := TRUE;
        IF X23 THEN
            Y22 := FALSE;
            state := 40;
        END_IF;

    40:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF X20 AND X23 AND (D26 >= 4 OR X22) THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM