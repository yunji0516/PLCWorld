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
    req_layers : ARRAY[1..4] OF INT;
    current_layer : INT := 1;
    target_src : INT := 0;
    edge_X10 : R_TRIG;
END_VAR

edge_X10(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        Y2 := FALSE;
        
        IF edge_X10.Q AND D10 = 4 THEN
            req_layers[1] := D11;
            req_layers[2] := D12;
            req_layers[3] := D13;
            req_layers[4] := D14;
            current_layer := 1;
            state := 1;
        END_IF;

    1:
        IF current_layer > 4 THEN
            state := 20;
        ELSE
            IF req_layers[current_layer] = 0 THEN
                target_src := 0; // Source A
            ELSE
                target_src := 1; // Source B
            END_IF;
            state := 2;
        END_IF;

    2: // Move horizontally to the designated source
        IF target_src = 0 THEN
            Y22 := FALSE;
            IF X20 THEN
                Y21 := FALSE;
                state := 3;
            ELSE
                Y21 := TRUE;
            END_IF;
        ELSE
            Y21 := FALSE;
            IF X21 THEN
                Y22 := FALSE;
                state := 3;
            ELSE
                Y22 := TRUE;
            END_IF;
        END_IF;

    3: // Wait for source plate to be present
        IF X27 THEN
            state := 4;
        END_IF;

    4: // Lower head to pick up plate
        Y24 := TRUE;
        Y23 := FALSE;
        IF X24 THEN
            state := 5;
        END_IF;

    5: // Grip plate
        Y20 := TRUE;
        IF X25 THEN
            state := 6;
        END_IF;

    6: // Raise head
        Y23 := TRUE;
        Y24 := FALSE;
        IF X23 THEN
            state := 7;
        END_IF;

    7: // Move horizontally to the stack center
        IF target_src = 0 THEN
            Y22 := TRUE;
            Y21 := FALSE;
        ELSE
            Y21 := TRUE;
            Y22 := FALSE;
        END_IF;
        
        IF X22 THEN
            Y21 := FALSE;
            Y22 := FALSE;
            state := 8;
        END_IF;

    8: // Adjust deck height so actual stack top D22 is perfectly aligned for placement
        IF D22 > 700 THEN
            Y26 := TRUE;
            Y27 := FALSE;
        ELSE
            Y26 := FALSE;
            state := 9;
        END_IF;

    9: // Lower head to place plate onto stack
        Y24 := TRUE;
        Y23 := FALSE;
        IF X24 THEN
            state := 10;
        END_IF;

    10: // Release grip
        Y20 := FALSE;
        IF X26 THEN
            state := 11;
        END_IF;

    11: // Raise head
        Y23 := TRUE;
        Y24 := FALSE;
        IF X23 THEN
            current_layer := current_layer + 1;
            state := 1;
        END_IF;

    20: // Return to upper position at Source A after all layers are stacked
        Y22 := FALSE;
        IF X20 THEN
            Y21 := FALSE;
            state := 21;
        ELSE
            Y21 := TRUE;
        END_IF;

    21: // Completion claim and outputs off
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM