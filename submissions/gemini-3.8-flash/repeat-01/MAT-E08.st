PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;

    r_trig_start : R_TRIG;
    state : INT := 0;
    wait_cnt : INT := 0;
END_VAR

r_trig_start(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y2 := FALSE;
        IF r_trig_start.Q THEN
            state := 1;
            Y20 := TRUE;
        END_IF;

    1:
        Y20 := TRUE;
        Y2 := FALSE;
        IF X20 THEN
            state := 2;
        END_IF;

    2:
        Y20 := TRUE;
        Y2 := FALSE;
        IF NOT X20 THEN
            state := 3;
            Y20 := FALSE;
        END_IF;

    3:
        Y20 := FALSE;
        Y2 := FALSE;
        wait_cnt := wait_cnt + 1;
        IF wait_cnt >= 5 THEN
            state := 4;
            Y2 := TRUE;
        END_IF;

    4:
        Y20 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM