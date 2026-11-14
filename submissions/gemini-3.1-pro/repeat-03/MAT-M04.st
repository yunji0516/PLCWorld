PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X31 : BOOL;
    Y2 : BOOL;
    D20 : INT;
    
    step : INT := 0;
    delivered_count : INT := 0;
    current_class : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE step OF
    0:
        IF start_edge.Q AND D10 = 2 THEN
            step := 1;
            delivered_count := 0;
        END_IF
        
    1:
        IF X26 AND X31 THEN
            current_class := D20;
            step := 2;
        END_IF
        
    2:
        IF X22 THEN
            step := 3;
        END_IF
        
    3:
        IF X24 THEN
            step := 4;
        END_IF
        
    4:
        IF X23 THEN
            step := 5;
        END_IF
        
    5:
        IF X21 THEN
            step := 6;
        END_IF
        
    6:
        IF X22 THEN
            step := 7;
        END_IF
        
    7:
        IF X25 THEN
            step := 8;
        END_IF
        
    8:
        IF X23 THEN
            step := 9;
        END_IF
        
    9:
        IF X20 THEN
            delivered_count := delivered_count + 1;
            IF delivered_count = 2 THEN
                step := 10;
            ELSE
                step := 1;
            END_IF
        END_IF
        
    10:
        (* Sequence complete. Hold and maintain completion claim. *)
        
END_CASE

Y20 := (step >= 3) AND (step <= 6);
Y21 := (step = 5);
Y22 := (step = 9);
Y23 := (step = 4) OR (step = 8);
Y24 := (step = 2) OR (step = 6);

IF current_class = 1 AND ((step >= 5) AND (step <= 8)) THEN
    Y25 := TRUE;
ELSE
    Y25 := FALSE;
END_IF

Y2 := (step = 10);

END_PROGRAM