PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;
    state : INT := 0;
    match : BOOL;
    start_edge : R_TRIG;
    tmr : TON;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0: (* WAIT_START *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        tmr(IN := FALSE);
        IF start_edge.Q THEN
            match := (D20 = D10);
            state := 1;
        END_IF;

    1: (* ROUTE *)
        Y2 := FALSE;
        tmr(IN := TRUE, PT := T#500ms);
        IF match THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSE
            Y20 := FALSE;
            Y21 := TRUE;
        END_IF;
        IF tmr.Q THEN
            state := 2;
        END_IF;

    2: (* DELIVER *)
        tmr(IN := FALSE);
        Y2 := FALSE;
        IF D20 = 0 THEN
            state := 3;
        END_IF;

    3: (* RETURN *)
        Y20 := FALSE;
        Y21 := FALSE;
        tmr(IN := TRUE, PT := T#500ms);
        Y2 := FALSE;
        IF tmr.Q THEN
            state := 4;
        END_IF;

    4: (* DONE *)
        Y20 := FALSE;
        Y21 := FALSE;
        tmr(IN := FALSE);
        Y2 := TRUE;
END_CASE;

END_PROGRAM