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

    state : INT := 0;
    start_edge : R_TRIG;
    req_id : INT := 0;
    timer_en : BOOL := FALSE;
    timer : TON;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q THEN
            req_id := D10;
            state := 10;
        END_IF

    10:
        Y20 := FALSE;
        IF D20 = req_id THEN
            state := 30;
        ELSE
            state := 20;
        END_IF

    20:
        Y21 := FALSE;
        Y20 := FALSE;
        IF X20 THEN
            state := 21;
        END_IF

    21:
        IF D20 = req_id OR X22 THEN
            Y20 := FALSE;
            state := 22;
        ELSE
            Y20 := TRUE;
        END_IF

    22:
        Y20 := FALSE;
        timer_en := TRUE;
        IF timer.Q THEN
            timer_en := FALSE;
            state := 30;
        END_IF

    30:
        Y21 := TRUE;
        Y20 := FALSE;
        IF X21 THEN
            state := 31;
        END_IF

    31:
        Y21 := TRUE;
        IF X22 THEN
            Y20 := FALSE;
            state := 32;
        ELSE
            Y20 := TRUE;
        END_IF

    32:
        Y20 := FALSE;
        timer_en := TRUE;
        IF timer.Q THEN
            timer_en := FALSE;
            state := 40;
        END_IF

    40:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := TRUE;
END_CASE;

timer(IN := timer_en, PT := T#50ms);

END_PROGRAM