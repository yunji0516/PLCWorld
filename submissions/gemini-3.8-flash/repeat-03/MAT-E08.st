PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;

    start_trig : R_TRIG;
    state : INT := 0;
    stop_count : INT := 0;
END_VAR

start_trig(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        IF start_trig.Q THEN
            state := 1;
            Y20 := TRUE;
        END_IF;

    1:
        Y20 := TRUE;
        IF X20 THEN
            state := 2;
        END_IF;

    2:
        Y20 := TRUE;
        IF NOT X20 THEN
            Y20 := FALSE;
            stop_count := 0;
            state := 3;
        END_IF;

    3:
        Y20 := FALSE;
        stop_count := stop_count + 1;
        IF stop_count >= 5 THEN
            state := 4;
            Y2 := TRUE;
        END_IF;

    4:
        Y20 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM