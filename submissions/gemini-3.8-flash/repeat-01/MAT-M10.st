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

    r_trig_x10 : R_TRIG;
    timer_release : TON;
    state : INT := 0;
    req_d10 : INT := 0;
    sel1 : BOOL := FALSE;
    sel2 : BOOL := FALSE;
    sel3 : BOOL := FALSE;
    unsel1 : BOOL := FALSE;
    unsel2 : BOOL := FALSE;
    unsel3 : BOOL := FALSE;
    grip_rel1 : BOOL := FALSE;
    grip_rel2 : BOOL := FALSE;
    grip_rel3 : BOOL := FALSE;
    timer_in : BOOL := FALSE;
END_VAR

r_trig_x10(CLK := X10);

timer_in := (state = 11) OR (state = 41);
timer_release(IN := timer_in, PT := T#200ms);

IF r_trig_x10.Q AND (state = 0) THEN
    req_d10 := D10;
    sel1 := (req_d10 AND 1) <> 0;
    sel2 := (req_d10 AND 2) <> 0;
    sel3 := (req_d10 AND 4) <> 0;
    unsel1 := NOT sel1;
    unsel2 := NOT sel2;
    unsel3 := NOT sel3;

    IF unsel1 OR unsel2 OR unsel3 THEN
        state := 10;
    ELSE
        state := 30;
    END_IF;
END_IF;

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

CASE state OF
    10:
        Y23 := NOT X23;
        IF X23 THEN
            state := 11;
        END_IF;

    11:
        IF unsel1 THEN
            grip_rel1 := TRUE;
        END_IF;
        IF unsel2 THEN
            grip_rel2 := TRUE;
        END_IF;
        IF unsel3 THEN
            grip_rel3 := TRUE;
        END_IF;

        IF timer_release.Q AND (NOT unsel1 OR NOT X26) AND (NOT unsel2 OR NOT X27) AND (NOT unsel3 OR NOT X28) THEN
            state := 20;
        END_IF;

    20:
        Y22 := NOT X22;
        IF X22 THEN
            state := 30;
        END_IF;

    30:
        IF X22 THEN
            Y20 := NOT X21;
        END_IF;
        IF X21 THEN
            state := 40;
        END_IF;

    40:
        Y23 := NOT X23;
        IF X23 THEN
            state := 41;
        END_IF;

    41:
        IF sel1 THEN
            grip_rel1 := TRUE;
        END_IF;
        IF sel2 THEN
            grip_rel2 := TRUE;
        END_IF;
        IF sel3 THEN
            grip_rel3 := TRUE;
        END_IF;

        IF timer_release.Q AND (NOT sel1 OR NOT X26) AND (NOT sel2 OR NOT X27) AND (NOT sel3 OR NOT X28) THEN
            state := 50;
        END_IF;

    50:
        Y22 := NOT X22;
        IF X22 THEN
            state := 60;
        END_IF;

    60:
        IF X22 THEN
            Y21 := NOT X20;
        END_IF;
        IF X20 THEN
            state := 70;
        END_IF;

    70:
        Y2 := TRUE;
END_CASE;

Y24 := grip_rel1;
Y25 := grip_rel2;
Y26 := grip_rel3;

END_PROGRAM