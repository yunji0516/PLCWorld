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
    
    step : INT := 0;
    layer_num : INT := 1;
    recipe : ARRAY[1..4] OF INT;
    edge_start : R_TRIG;
END_VAR

edge_start(CLK := X10);

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y26 := FALSE;
Y27 := FALSE;

CASE step OF
0: 
    IF edge_start.Q THEN
        recipe[1] := D11;
        recipe[2] := D12;
        recipe[3] := D13;
        recipe[4] := D14;
        layer_num := 1;
        step := 1;
    END_IF;
    
1: 
    IF NOT X23 THEN
        Y23 := TRUE;
    ELSE
        IF recipe[layer_num] = 0 THEN 
            IF NOT X20 THEN Y21 := TRUE; END_IF;
        ELSE 
            IF NOT X21 THEN Y22 := TRUE; END_IF;
        END_IF;
        IF (recipe[layer_num] = 0 AND X20) OR (recipe[layer_num] = 1 AND X21) THEN
            step := 2;
        END_IF;
    END_IF;
    
2: 
    Y24 := TRUE;
    IF X24 THEN
        step := 3;
    END_IF;

3: 
    Y20 := TRUE;
    IF X25 THEN
        step := 4;
    END_IF;

4: 
    Y20 := TRUE;
    Y23 := TRUE;
    IF X23 THEN
        step := 5;
    END_IF;

5: 
    Y20 := TRUE;
    IF NOT X22 THEN
        IF D20 < 0 THEN Y22 := TRUE;
        ELSIF D20 > 0 THEN Y21 := TRUE;
        END_IF;
    ELSE
        step := 6;
    END_IF;

6: 
    Y20 := TRUE;
    IF D22 < 698 THEN
        Y27 := TRUE;
    ELSIF D22 > 702 THEN
        Y26 := TRUE;
    ELSE
        step := 7;
    END_IF;

7: 
    Y20 := TRUE;
    Y24 := TRUE;
    IF X24 THEN
        step := 8;
    END_IF;

8: 
    Y20 := FALSE;
    IF X26 AND X28 THEN
        step := 9;
    END_IF;

9: 
    layer_num := layer_num + 1;
    IF layer_num > 4 THEN
        step := 10;
    ELSE
        step := 1;
    END_IF;

10: 
    IF NOT X23 THEN
        Y23 := TRUE;
    ELSE
        IF NOT X20 THEN Y21 := TRUE; END_IF;
        IF X20 THEN step := 11; END_IF;
    END_IF;

11: 
    Y2 := TRUE;
END_CASE;

END_PROGRAM