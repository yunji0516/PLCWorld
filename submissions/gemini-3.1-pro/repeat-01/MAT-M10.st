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

    X10_edge : R_TRIG;
    t_rel1 : TON;
    t_rel2 : TON;
    state : INT := 0;
    sel1 : BOOL;
    sel2 : BOOL;
    sel3 : BOOL;
END_VAR

X10_edge(CLK := X10);

CASE state OF
    0:
        IF X10_edge.Q THEN
            sel1 := (D10 MOD 2) <> 0;
            sel2 := ((D10 / 2) MOD 2) <> 0;
            sel3 := ((D10 / 4) MOD 2) <> 0;
            state := 10;
        END_IF;

    10:
        IF NOT sel1 OR NOT sel2 OR NOT sel3 THEN
            state := 11;
        ELSE
            state := 40;
        END_IF;

    11: (* Down at source *)
        IF X23 THEN
            state := 12;
        END_IF;

    12: (* Release unselected *)
        IF (sel1 OR NOT X26) AND (sel2 OR NOT X27) AND (sel3 OR NOT X28) AND t_rel1.Q THEN
            state := 13;
        END_IF;

    13: (* Up at source *)
        IF X22 THEN
            state := 40;
        END_IF;

    40:
        IF sel1 OR sel2 OR sel3 THEN
            state := 41;
        ELSE
            state := 71; (* Skip target and complete, already at source home *)
        END_IF;

    41: (* Forward to target *)
        IF X21 THEN
            state := 42;
        END_IF;

    42: (* Down at target *)
        IF X23 THEN
            state := 43;
        END_IF;

    43: (* Release selected *)
        IF NOT X26 AND NOT X27 AND NOT X28 AND t_rel2.Q THEN
            state := 44;
        END_IF;

    44: (* Up at target *)
        IF X22 THEN
            state := 70;
        END_IF;

    70: (* Back to source *)
        IF X20 THEN
            state := 71;
        END_IF;

    71: (* Done *)
        ;
END_CASE;

t_rel1(IN := (state = 12), PT := T#150ms);
t_rel2(IN := (state = 43), PT := T#150ms);

(* Actuator commands *)
Y20 := (state = 41);
Y21 := (state = 70);
Y22 := (state = 13) OR (state = 44);
Y23 := (state = 11) OR (state = 12) OR (state = 42) OR (state = 43);

(* Latch release outputs *)
IF state = 0 THEN
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
END_IF;

IF state = 12 THEN
    IF NOT sel1 THEN Y24 := TRUE; END_IF;
    IF NOT sel2 THEN Y25 := TRUE; END_IF;
    IF NOT sel3 THEN Y26 := TRUE; END_IF;
END_IF;

IF state = 43 THEN
    IF sel1 THEN Y24 := TRUE; END_IF;
    IF sel2 THEN Y25 := TRUE; END_IF;
    IF sel3 THEN Y26 := TRUE; END_IF;
END_IF;

Y2 := (state = 71);

END_PROGRAM