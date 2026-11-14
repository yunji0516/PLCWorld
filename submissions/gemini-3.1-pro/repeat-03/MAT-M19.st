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
    
    start_trig : R_TRIG;
    started : BOOL;
    state : INT := 0;
    left_assign : ARRAY[1..4] OF BOOL;
    diff1 : INT;
    diff2 : INT;
    diff3 : INT;
    idx : INT;
    target_count : INT;
END_VAR

start_trig(CLK := X10);

CASE state OF
0:
    IF start_trig.Q AND NOT started THEN
        started := TRUE;
        target_count := D10;
        
        diff1 := ABS((D20 + D21) - (D22 + D23));
        diff2 := ABS((D20 + D22) - (D21 + D23));
        diff3 := ABS((D20 + D23) - (D21 + D22));
        
        IF diff1 <= 1 THEN
            left_assign[1] := TRUE; left_assign[2] := TRUE; 
            left_assign[3] := FALSE; left_assign[4] := FALSE;
        ELSIF diff2 <= 1 THEN
            left_assign[1] := TRUE; left_assign[2] := FALSE; 
            left_assign[3] := TRUE; left_assign[4] := FALSE;
        ELSE
            left_assign[1] := TRUE; left_assign[2] := FALSE; 
            left_assign[3] := FALSE; left_assign[4] := TRUE;
        END_IF;
        
        state := 1;
    END_IF;

1:
    IF D26 < 4 THEN
        IF X20 THEN
            idx := D26 + 1;
            IF idx >= 1 AND idx <= 4 THEN
                IF left_assign[idx] THEN
                    Y20 := TRUE;
                ELSE
                    Y21 := TRUE;
                END_IF;
                state := 2;
            END_IF;
        END_IF;
    ELSE
        IF X20 THEN
            state := 4;
        END_IF;
    END_IF;

2:
    IF X21 THEN
        Y20 := FALSE;
        Y21 := FALSE;
        state := 3;
    END_IF;

3:
    IF X20 THEN
        state := 1;
    END_IF;

4:
    Y22 := TRUE;
    IF X23 THEN
        Y22 := FALSE;
        Y2 := TRUE;
        state := 5;
    END_IF;

5:
    Y2 := TRUE;
    
END_CASE;

END_PROGRAM