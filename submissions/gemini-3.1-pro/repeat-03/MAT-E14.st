PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;

    start_edge : R_TRIG;
    state : INT := 0;
    diff_L : INT;
    diff_R : INT;
    choice : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        
        IF start_edge.Q THEN
            IF X22 AND NOT X23 THEN
                choice := 1;
            ELSIF X23 AND NOT X22 THEN
                choice := 2;
            ELSIF X22 AND X23 THEN
                diff_L := ABS((D21 + D20) - D22);
                diff_R := ABS(D21 - (D22 + D20));
                IF diff_L <= diff_R THEN
                    choice := 1;
                ELSE
                    choice := 2;
                END_IF
            ELSE
                choice := 0; 
            END_IF
            
            IF choice = 1 THEN
                state := 1;
            ELSIF choice = 2 THEN
                state := 2;
            END_IF
        END_IF
        
    1:
        Y20 := TRUE;
        Y21 := FALSE;
        IF X20 THEN
            Y20 := FALSE;
            state := 3;
        END_IF
        
    2:
        Y20 := FALSE;
        Y21 := TRUE;
        IF X21 THEN
            Y21 := FALSE;
            state := 3;
        END_IF
        
    3:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
        
END_CASE

END_PROGRAM