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
    start_edge : R_TRIG;
    sel_1 : BOOL;
    sel_2 : BOOL;
    sel_3 : BOOL;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q THEN
            sel_1 := (D10 MOD 2) <> 0;
            sel_2 := ((D10 / 2) MOD 2) <> 0;
            sel_3 := ((D10 / 4) MOD 2) <> 0;
            state := 1;
        END_IF;
    1:
        IF X23 THEN
            state := 2;
        END_IF;
    2:
        IF (X26 = sel_1) AND (X27 = sel_2) AND (X28 = sel_3) THEN
            state := 3;
        END_IF;
    3:
        IF X22 THEN
            state := 4;
        END_IF;
    4:
        IF X21 THEN
            state := 5;
        END_IF;
    5:
        IF X23 THEN
            state := 6;
        END_IF;
    6:
        IF X25 THEN
            state := 7;
        END_IF;
    7:
        IF X22 THEN
            state := 8;
        END_IF;
    8:
        IF X20 THEN
            state := 9;
        END_IF;
END_CASE;

Y20 := (state = 4);
Y21 := (state = 8);
Y22 := (state = 3) OR (state = 4) OR (state = 7) OR (state = 8);
Y23 := (state = 1) OR (state = 2) OR (state = 5) OR (state = 6);

Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

IF state >= 2 THEN
    IF NOT sel_1 THEN Y24 := TRUE; END_IF;
    IF NOT sel_2 THEN Y25 := TRUE; END_IF;
    IF NOT sel_3 THEN Y26 := TRUE; END_IF;
END_IF;

IF state >= 6 THEN
    Y24 := TRUE;
    Y25 := TRUE;
    Y26 := TRUE;
END_IF;

Y2 := (state = 9);

END_PROGRAM