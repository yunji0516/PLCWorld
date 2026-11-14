PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    start_trigger : R_TRIG;
    state : INT := 0;
END_VAR

start_trigger(CLK := X10);

CASE state OF
    0:
        Y20 := TRUE;
        IF start_trigger.Q THEN
            state := 1;
        END_IF;
    1:
        Y20 := FALSE;
        IF X21 AND X22 AND NOT X20 THEN
            state := 2;
        END_IF;
    2:
        Y20 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM