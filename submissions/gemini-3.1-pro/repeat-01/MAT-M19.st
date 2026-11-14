PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;
    D23 : INT;
    D24 : INT;
    D25 : INT;
    D26 : INT;
    
    state : INT := 0;
    start_edge : R_TRIG;
    assign : ARRAY[0..3] OF BOOL;
    w1, w2, w3, w4 : INT;
    diff1, diff2, diff3 : INT;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q THEN
            w1 := D20;
            w2 := D21;
            w3 := D22;
            w4 := D23;
            
            diff1 := ABS(w1 + w2 - w3 - w4);
            diff2 := ABS(w1 + w3 - w2 - w4);
            diff3 := ABS(w1 + w4 - w2 - w3);
            
            IF diff1 <= 1 THEN
                assign[0] := TRUE;
                assign[1] := TRUE;
                assign[2] := FALSE;
                assign[3] := FALSE;
            ELSIF diff2 <= 1 THEN
                assign[0] := TRUE;
                assign[1] := FALSE;
                assign[2] := TRUE;
                assign[3] := FALSE;
            ELSE
                assign[0] := TRUE;
                assign[1] := FALSE;
                assign[2] := FALSE;
                assign[3] := TRUE;
            END_IF;
            
            state := 1;
        END_IF;
        
    1:
        IF X20 THEN
            IF D26 >= 0 AND D26 <= 3 THEN
                IF assign[D26] THEN
                    Y20 := TRUE;
                    Y21 := FALSE;
                ELSE
                    Y20 := FALSE;
                    Y21 := TRUE;
                END_IF;
                state := 2;
            ELSIF D26 >= 4 THEN
                Y20 := FALSE;
                Y21 := FALSE;
                state := 3;
            END_IF;
        END_IF;
        
    2:
        IF X21 THEN
            Y20 := FALSE;
            Y21 := FALSE;
            state := 1;
        END_IF;
        
    3:
        Y22 := TRUE;
        IF X23 THEN
            Y22 := FALSE;
            state := 4;
        END_IF;
        
    4:
        Y2 := TRUE;
        
END_CASE;

END_PROGRAM