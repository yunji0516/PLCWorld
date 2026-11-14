```iecst
PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
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
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    
    table_state : INT := 0;
    pos0_state : INT := 0;
    pos1_state : INT := 0;
    pos2_state : INT := 0;
    pos3_state : INT := 0;
    rework_state : INT := 0;
    
    body_gen : ARRAY[0..10] OF INT;
    
    ack_edge : R_TRIG;
    complete_cond : BOOL;
END_VAR

// Initialize edge-triggered commands to FALSE every scan
Y10 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y16 := FALSE;
Y18 := FALSE;
Y1B := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

// Exit acknowledgement edge
ack_edge(CLK := X1E);
Y19 := ack_edge.Q;

// Position 0: Load and Return logic
CASE pos0_state OF
0:
    IF D0 > 0 THEN
        pos0_state := 4;
    ELSIF X2A AND NOT X27 THEN
        Y1F := TRUE;
        pos0_state := 2;
    ELSIF X10 AND NOT X11 THEN
        Y10 := TRUE;
        pos0_state := 1;
    ELSE
        pos0_state := 4;
    END_IF;
1:
    IF D0 > 0 THEN
        body_gen[D0] := 1;
        pos0_state := 4;
    END_IF;
2:
    IF D0 > 0 THEN
        body_gen[D0] := body_gen[D0] + 1;
        pos0_state := 4;
    END_IF;
4:
    IF D0 = 0 AND ((X2A AND NOT X27) OR (X10 AND NOT X11)) THEN
        pos0_state := 0;
    END_IF;
END_CASE;

// Position 1: Insert logic
CASE pos1_state OF
0:
    IF D1 = 0 THEN
        pos1_state := 4;
    ELSIF X21 THEN
        pos1_state := 4;
    ELSE
        pos1_state := 1;
    END_IF;
1:
    IF X13 THEN
        Y12 := TRUE;
        pos1_state := 2;
    END_IF;
2:
    IF X21 THEN
        pos1_state := 4;
    END_IF;
4:
    IF D1 > 0 AND NOT X21 THEN
        pos1_state := 0;
    END_IF;
END_CASE;

// Position 2: Inspect logic
CASE pos2_state OF
0:
    IF D2 = 0 THEN
        pos2_state := 4;
    ELSIF D6 = D2 AND D7 = body_gen[D2] THEN
        pos2_state := 4;
    ELSE
        pos2_state := 1;
    END_IF;
1:
    D200 := body_gen[D2];
    Y13 := TRUE;
    pos2_state := 2;
2:
    D200 := body_gen[D2];
    IF D6 = D2 AND D7 = body_gen[D2] THEN
        pos2_state := 4;
    END_IF;
4:
    IF D2 > 0 AND NOT (D6 = D2 AND D7 = body_gen[D2]) THEN
        pos2_state := 0;
    END_IF;
END_CASE;

// Position 3: Eject and Rework logic
CASE pos3_state OF
0:
    IF D3 = 0 THEN
        pos3_state := 4;
    ELSE
        pos3_state := 1;
    END_IF;
1:
    IF X20 THEN
        IF X24 THEN
            IF X1B AND NOT X25 AND NOT X26 THEN
                Y1B := TRUE;
                pos3_state := 2;
            END_IF;
        ELSE
            IF X1B AND NOT X17 THEN
                pos3_state := 3;
            END_IF;
        END_IF;
    END_IF;
2:
    IF D3 = 0 THEN
        pos3_state := 4;
    END_IF;
3:
    IF X1C THEN
        pos3_state := 5;
    END_IF;
5:
    IF X1B THEN
        pos3_state := 6;
    END_IF;
6:
    IF X1D AND NOT X1E AND X1B AND X20 THEN
        Y16 := TRUE;
        pos3_state := 7;
    END_IF;
7:
    IF D3 = 0 THEN
        pos3_state := 4;
    END_IF;
4:
    IF D3 > 0 THEN
        pos3_state := 0;
    END_IF;
END_CASE;

// Rework logic
CASE rework_state OF
0:
    IF X26 THEN
        rework_state := 1;
    END_IF;
1:
    IF X27 THEN
        Y1D := TRUE;
        rework_state := 2;
    END_IF;
2:
    IF X28 THEN
        Y1E := TRUE;
        rework_state := 3;
    END_IF;
3:
    IF X29 THEN
        rework_state := 4;
    END_IF;
4:
    IF NOT X27 THEN
        rework_state := 5;
    END_IF;
5:
    IF NOT X26 THEN
        rework_state := 0;
    END_IF;
END_CASE;

// Table Shared Rotation logic
CASE table_state OF
0:
    IF X19 THEN
        table_state := 1;
    END_IF;
1:
    IF (pos0_state = 4) AND (pos1_state = 4) AND (pos2_state = 4) AND (pos3_state = 4) THEN
        IF NOT X14 AND NOT X15 AND NOT X16 AND NOT X17 AND NOT X25 AND X1B AND X19 THEN
            IF D0 > 0 OR D1 > 0 OR D2 > 0 OR D3 > 0 THEN
                table_state := 2;
            END_IF;
        END_IF;
    END_IF;
2:
    IF X1A THEN
        Y18 := TRUE;
        table_state := 3;
    END_IF;
3:
    IF X18 THEN
        table_state := 4;
    END_IF;
4:
    IF NOT X18 AND X1A THEN
        table_state := 5;
    END_IF;
5:
    IF X19 THEN
        pos0_state := 0;
        pos1_state := 0;
        pos2_state := 0;
        pos3_state := 0;
        table_state := 1;
    END_IF;
END_CASE;

// Maintained State Outputs
Y11 := (pos1_state = 1);
Y14 := (pos3_state = 3);
Y15 := (pos3_state = 5);
Y17 := (table_state = 0) OR (table_state = 1) OR (table_state = 5);
Y1C := (rework_state >= 1 AND rework_state <= 3);

// Task Completion Condition
complete_cond := (D10 = 6) AND NOT X1E AND (D0 = 0) AND (D1 = 0) AND (D2 = 0) AND (D3 = 0) 
                 AND NOT X26 AND NOT X14 AND NOT X15 AND NOT X16 AND NOT X17 
                 AND NOT X25 AND NOT X18 AND X19 AND X1B AND X11;
Y1A := complete_cond;

END_PROGRAM
```