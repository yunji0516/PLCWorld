PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;
    start_edge : R_TRIG;
    state : INT := 0;
    target_len : DINT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            state := 1;
            target_len := DINT(D10);
        END_IF;
    1:
        Y23 := FALSE;
        Y2 := FALSE;
        IF D20 > 4 THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSIF D20 < -4 THEN
            Y20 := FALSE;
            Y21 := TRUE;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
        END_IF;
        Y22 := TRUE;
        IF DINT(D21) >= target_len - 3 AND DINT(D21) <= target_len + 3 THEN
            state := 2;
            Y22 := FALSE;
        END_IF;
    2:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        Y23 := TRUE;
        IF X20 THEN
            state := 3;
        END_IF;
    3:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y2 := TRUE;
ELSE
    state := 0;
END_CASE;

END_PROGRAM