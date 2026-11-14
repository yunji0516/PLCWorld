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
    state : INT := 0;
    start_edge : R_TRIG;
    req_D10 : INT;
    src_D20 : INT;
    start_D21 : INT;
    target_D21 : INT;
    diff : INT;
    rot_done : BOOL;
END_VAR

start_edge(CLK := X10);

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;
Y2 := FALSE;

CASE state OF
    0:
        IF start_edge.Q THEN
            req_D10 := D10;
            src_D20 := D20;
            state := 1;
        END_IF;

    1:
        Y24 := TRUE;
        IF X22 THEN
            state := 2;
        END_IF;

    2:
        Y20 := TRUE;
        IF X24 THEN
            start_D21 := D21;
            target_D21 := req_D10 - src_D20 + start_D21;
            state := 3;
        END_IF;

    3:
        Y20 := TRUE;
        Y23 := TRUE;
        IF X23 THEN
            state := 4;
        END_IF;

    4:
        Y20 := TRUE;
        IF NOT X21 THEN
            Y21 := TRUE;
        END_IF;
        
        diff := target_D21 - D21;
        WHILE diff > 180 DO
            diff := diff - 360;
        END_WHILE;
        WHILE diff < -180 DO
            diff := diff + 360;
        END_WHILE;
        
        IF diff > 1 THEN
            Y25 := TRUE;
            rot_done := FALSE;
        ELSIF diff < -1 THEN
            Y26 := TRUE;
            rot_done := FALSE;
        ELSE
            rot_done := TRUE;
        END_IF;
        
        IF X21 AND rot_done THEN
            state := 5;
        END_IF;

    5:
        Y20 := TRUE;
        Y24 := TRUE;
        IF X22 THEN
            state := 6;
        END_IF;

    6:
        IF X25 THEN
            state := 7;
        END_IF;

    7:
        Y23 := TRUE;
        IF X23 THEN
            state := 8;
        END_IF;

    8:
        IF NOT X20 THEN
            Y22 := TRUE;
        ELSE
            state := 9;
        END_IF;

    9:
        Y2 := TRUE;

END_CASE;

END_PROGRAM