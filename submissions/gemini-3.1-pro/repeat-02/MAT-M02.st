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
    X31 : BOOL;
    Y2 : BOOL;
    D20 : INT;
    D21 : INT;
    
    State : INT := 0;
    start_edge : R_TRIG;
    Target_Head : INT;
    Diff_P : INT;
    rot_done : BOOL;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q AND State = 0 THEN
    Diff_P := D10 - D20;
    
    WHILE Diff_P > 180 DO
        Diff_P := Diff_P - 360;
    END_WHILE;
    WHILE Diff_P < -180 DO
        Diff_P := Diff_P + 360;
    END_WHILE;
    
    Target_Head := D21 + Diff_P;
    State := 1;
END_IF;

CASE State OF
0:
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
    Y2 := FALSE;

1:
    Y24 := TRUE;
    IF X22 THEN
        Y24 := FALSE;
        State := 2;
    END_IF;

2:
    Y20 := TRUE;
    IF X24 THEN
        State := 3;
    END_IF;

3:
    Y20 := TRUE;
    Y23 := TRUE;
    IF X23 THEN
        Y23 := FALSE;
        rot_done := FALSE;
        State := 4;
    END_IF;

4:
    Y20 := TRUE;
    
    IF NOT X21 THEN
        Y21 := TRUE;
    ELSE
        Y21 := FALSE;
    END_IF;

    IF NOT rot_done THEN
        IF Target_Head - D21 > 1 THEN
            Y25 := TRUE;
            Y26 := FALSE;
        ELSIF D21 - Target_Head > 1 THEN
            Y25 := FALSE;
            Y26 := TRUE;
        ELSE
            Y25 := FALSE;
            Y26 := FALSE;
            rot_done := TRUE;
        END_IF;
    END_IF;

    IF X21 AND rot_done THEN
        Y21 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        State := 5;
    END_IF;

5:
    Y20 := TRUE;
    Y24 := TRUE;
    IF X22 THEN
        Y24 := FALSE;
        State := 6;
    END_IF;

6:
    Y20 := FALSE;
    IF X25 THEN
        State := 7;
    END_IF;

7:
    Y23 := TRUE;
    IF X23 THEN
        Y23 := FALSE;
        State := 8;
    END_IF;

8:
    IF NOT X20 THEN
        Y22 := TRUE;
    ELSE
        Y22 := FALSE;
        State := 9;
    END_IF;

9:
    Y2 := TRUE;

END_CASE;

END_PROGRAM