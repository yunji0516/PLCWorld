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
    
    state : INT := 0;
    layer_idx : INT := 0;
    recipe : ARRAY[0..3] OF INT;
    edge_rise : R_TRIG;
    scans_left : INT := 0;
END_VAR

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y26 := FALSE;
Y27 := FALSE;

edge_rise(CLK := X10);

CASE state OF
    0:
        IF edge_rise.Q THEN
            recipe[0] := D11;
            recipe[1] := D12;
            recipe[2] := D13;
            recipe[3] := D14;
            layer_idx := 0;
            state := 1;
        END_IF;
        
    1:
        IF NOT X23 THEN
            Y23 := TRUE;
        ELSE
            state := 2;
        END_IF;
        
    2:
        IF NOT X23 THEN
            Y23 := TRUE;
        ELSIF recipe[layer_idx] = 0 THEN
            IF NOT X20 THEN
                IF D20 > -691 THEN
                    Y21 := TRUE;
                ELSIF D20 < -709 THEN
                    Y22 := TRUE;
                END_IF;
            ELSE
                state := 3;
            END_IF;
        ELSE
            IF NOT X21 THEN
                IF D20 > 709 THEN
                    Y21 := TRUE;
                ELSIF D20 < 691 THEN
                    Y22 := TRUE;
                END_IF;
            ELSE
                state := 3;
            END_IF;
        END_IF;
        
    3:
        Y24 := TRUE;
        IF X24 THEN
            state := 4;
        END_IF;
        
    4:
        IF X27 THEN
            Y20 := TRUE;
            IF X25 THEN
                state := 5;
            END_IF;
        END_IF;
        
    5:
        Y23 := TRUE;
        IF X23 THEN
            state := 6;
        END_IF;
        
    6:
        IF NOT X23 THEN
            Y23 := TRUE;
        ELSIF NOT X22 THEN
            IF D20 > 9 THEN
                Y21 := TRUE;
            ELSIF D20 < -9 THEN
                Y22 := TRUE;
            END_IF;
        ELSE
            state := 7;
        END_IF;
        
    7:
        IF scans_left = 0 THEN
            scans_left := (1150 - D22) / 5;
        END_IF;
        IF X24 OR scans_left <= 0 THEN
            Y24 := FALSE;
            scans_left := 0;
            state := 8;
        ELSE
            Y24 := TRUE;
            scans_left := scans_left - 1;
        END_IF;
        
    8:
        Y20 := FALSE;
        IF X26 THEN
            state := 9;
        END_IF;
        
    9:
        Y23 := TRUE;
        IF X23 THEN
            layer_idx := layer_idx + 1;
            IF layer_idx >= 4 THEN
                state := 10;
            ELSE
                state := 1;
            END_IF;
        END_IF;
        
    10:
        IF NOT X23 THEN
            Y23 := TRUE;
        ELSIF NOT X20 THEN
            IF D20 > -691 THEN
                Y21 := TRUE;
            ELSIF D20 < -709 THEN
                Y22 := TRUE;
            END_IF;
        ELSE
            state := 11;
        END_IF;
        
    11:
        Y20 := FALSE;
        Y2 := TRUE;
        
ELSE
    state := 0;
END_CASE;

END_PROGRAM