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
    sel1 : BOOL := FALSE;
    sel2 : BOOL := FALSE;
    sel3 : BOOL := FALSE;
    
    rTrigX10 : R_TRIG;
    tState2 : TON;
    tState6 : TON;
END_VAR

rTrigX10(CLK := X10);

CASE state OF
    0:
        Y22 := FALSE;
        Y23 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        Y2 := FALSE;
        
        IF rTrigX10.Q THEN
            sel1 := (D10 MOD 2) <> 0;
            sel2 := ((D10 / 2) MOD 2) <> 0;
            sel3 := ((D10 / 4) MOD 2) <> 0;
            state := 1;
        END_IF;

    1:
        Y23 := TRUE;
        Y22 := FALSE;
        IF X23 THEN
            Y23 := FALSE;
            state := 2;
        END_IF;

    2:
        IF NOT sel1 THEN Y24 := TRUE; END_IF;
        IF NOT sel2 THEN Y25 := TRUE; END_IF;
        IF NOT sel3 THEN Y26 := TRUE; END_IF;
        
        IF tState2.Q THEN
            state := 3;
        END_IF;

    3:
        Y22 := TRUE;
        Y23 := FALSE;
        IF X22 THEN
            Y22 := FALSE;
            state := 4;
        END_IF;

    4:
        Y20 := TRUE;
        Y21 := FALSE;
        IF X21 THEN
            Y20 := FALSE;
            state := 5;
        END_IF;

    5:
        Y23 := TRUE;
        Y22 := FALSE;
        IF X23 THEN
            Y23 := FALSE;
            state := 6;
        END_IF;

    6:
        Y24 := TRUE;
        Y25 := TRUE;
        Y26 := TRUE;
        
        IF tState6.Q THEN
            state := 7;
        END_IF;

    7:
        Y22 := TRUE;
        Y23 := FALSE;
        IF X22 THEN
            Y22 := FALSE;
            state := 8;
        END_IF;

    8:
        Y21 := TRUE;
        Y20 := FALSE;
        IF X20 THEN
            Y21 := FALSE;
            state := 9;
        END_IF;

    9:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
END_CASE;

tState2(IN := (state = 2), PT := T#200ms);
tState6(IN := (state = 6), PT := T#200ms);

END_PROGRAM