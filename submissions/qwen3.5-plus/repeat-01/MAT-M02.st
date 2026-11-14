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
    start_edge : R_TRIG;
    state : INT := 0;
    plate_angle : INT := 0;
    head_start : INT := 0;
    target_head : DINT := 0;
    diff : DINT;
    req_angle : INT := 0;
END_VAR

start_edge(CLK := X10);

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

CASE state OF
    0:
        IF start_edge.Q THEN
            req_angle := D10;
            state := 1;
        END_IF;

    1:
        Y24 := TRUE;
        IF X22 AND X28 THEN
            plate_angle := D20;
            head_start := D21;
            state := 2;
        END_IF;

    2:
        Y20 := TRUE;
        IF X24 THEN
            state := 3;
        END_IF;

    3:
        Y23 := TRUE;
        IF X23 AND X28 THEN
            target_head := DINT(req_angle) - (DINT(plate_angle) - DINT(head_start));
            state := 4;
        END_IF;

    4:
        diff := target_head - DINT(D21);
        IF ABS(diff) <= 2 THEN
            IF X28 THEN
                state := 5;
            END_IF;
        ELSE
            IF diff > 0 THEN
                Y25 := TRUE;
            ELSE
                Y26 := TRUE;
            END_IF;
        END_IF;

    5:
        Y21 := TRUE;
        IF X21 AND X28 THEN
            state := 6;
        END_IF;

    6:
        Y24 := TRUE;
        IF X22 AND X28 THEN
            state := 7;
        END_IF;

    7:
        IF X25 THEN
            state := 8;
        END_IF;

    8:
        Y23 := TRUE;
        IF X23 AND X28 THEN
            state := 9;
        END_IF;

    9:
        Y22 := TRUE;
        IF X20 AND X28 THEN
            state := 10;
        END_IF;

    10:
        Y2 := TRUE;
END_CASE;

END_PROGRAM