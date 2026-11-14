PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    D20 : INT;

    state : INT := 0;
    started : BOOL := FALSE;
    sel1 : BOOL := FALSE;
    sel2 : BOOL := FALSE;
    sel3 : BOOL := FALSE;
    has_unsel : BOOL := FALSE;
    has_sel : BOOL := FALSE;
    rel_timer_in : BOOL := FALSE;
    rel_timer : TON;
    r_trig_start : R_TRIG;
END_VAR

r_trig_start(CLK := X10);
rel_timer(IN := rel_timer_in, PT := T#200ms);

IF NOT started THEN
    Y2 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;

    IF r_trig_start.Q THEN
        started := TRUE;
        sel1 := (D10 AND 1) <> 0;
        sel2 := (D10 AND 2) <> 0;
        sel3 := (D10 AND 4) <> 0;
        has_unsel := (NOT sel1) OR (NOT sel2) OR (NOT sel3);
        has_sel := sel1 OR sel2 OR sel3;

        IF has_unsel THEN
            state := 10;
        ELSIF has_sel THEN
            state := 30;
        ELSE
            state := 100;
        END_IF;
    END_IF;
ELSE
    CASE state OF
        10: (* Lower at source to return unselected materials *)
            Y23 := TRUE;
            Y22 := FALSE;
            IF X23 THEN
                Y23 := FALSE;
                state := 20;
            END_IF;

        20: (* Release unselected materials at source nests *)
            IF NOT sel1 THEN
                Y24 := TRUE;
            END_IF;
            IF NOT sel2 THEN
                Y25 := TRUE;
            END_IF;
            IF NOT sel3 THEN
                Y26 := TRUE;
            END_IF;
            rel_timer_in := TRUE;
            IF rel_timer.Q AND (sel1 OR NOT X26) AND (sel2 OR NOT X27) AND (sel3 OR NOT X28) THEN
                rel_timer_in := FALSE;
                state := 25;
            END_IF;

        25: (* Raise to upper at source *)
            Y22 := TRUE;
            Y23 := FALSE;
            IF X22 THEN
                Y22 := FALSE;
                IF has_sel THEN
                    state := 30;
                ELSE
                    state := 100;
                END_IF;
            END_IF;

        30: (* Travel forward to receiver *)
            IF X22 THEN
                Y20 := TRUE;
                Y21 := FALSE;
            ELSE
                Y20 := FALSE;
            END_IF;
            IF X21 THEN
                Y20 := FALSE;
                state := 40;
            END_IF;

        40: (* Lower at receiver *)
            Y23 := TRUE;
            Y22 := FALSE;
            IF X23 THEN
                Y23 := FALSE;
                state := 50;
            END_IF;

        50: (* Release selected materials at receiver nests *)
            IF sel1 THEN
                Y24 := TRUE;
            END_IF;
            IF sel2 THEN
                Y25 := TRUE;
            END_IF;
            IF sel3 THEN
                Y26 := TRUE;
            END_IF;
            rel_timer_in := TRUE;
            IF rel_timer.Q AND (X25 OR ((NOT sel1 OR NOT X26) AND (NOT sel2 OR NOT X27) AND (NOT sel3 OR NOT X28))) THEN
                rel_timer_in := FALSE;
                state := 60;
            END_IF;

        60: (* Raise to upper at receiver *)
            Y22 := TRUE;
            Y23 := FALSE;
            IF X22 THEN
                Y22 := FALSE;
                state := 70;
            END_IF;

        70: (* Travel back to source *)
            IF X22 THEN
                Y21 := TRUE;
                Y20 := FALSE;
            ELSE
                Y21 := FALSE;
            END_IF;
            IF X20 THEN
                Y21 := FALSE;
                state := 100;
            END_IF;

        100: (* Completed *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            rel_timer_in := FALSE;
            Y2 := TRUE;
    END_CASE;
END_IF;

(* Safety interlocks *)
IF Y20 AND Y21 THEN
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;
IF Y22 AND Y23 THEN
    Y22 := FALSE;
    Y23 := FALSE;
END_IF;
IF (Y20 OR Y21) AND NOT X22 THEN
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;
END_PROGRAM