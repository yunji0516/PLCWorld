PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;

    state : INT := 0;
    match : BOOL := FALSE;
    edge_x10 : R_TRIG;
    t_adv : TON;
    t_ret : TON;
END_VAR

edge_x10(CLK := X10);

t_adv(IN := (state = 1), PT := T#600ms);
t_ret(IN := (state = 2), PT := T#600ms);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF edge_x10.Q AND X20 THEN
            match := (D20 = D10);
            state := 1;
            IF match THEN
                Y20 := TRUE;
                Y21 := FALSE;
            ELSE
                Y20 := FALSE;
                Y21 := TRUE;
            END_IF;
        END_IF;

    1:
        IF match THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSE
            Y20 := FALSE;
            Y21 := TRUE;
        END_IF;
        IF t_adv.Q THEN
            Y20 := FALSE;
            Y21 := FALSE;
            state := 2;
        END_IF;

    2:
        Y20 := FALSE;
        Y21 := FALSE;
        IF t_ret.Q AND X20 THEN
            state := 3;
            Y2 := TRUE;
        END_IF;

    3:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
END_CASE;

END_PROGRAM