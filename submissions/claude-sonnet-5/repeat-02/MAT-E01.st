PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;

    start_trig : R_TRIG;
    started    : BOOL := FALSE;
    completed  : BOOL := FALSE;
END_VAR

start_trig(CLK := X10);

IF start_trig.Q AND NOT started AND D10 = 1 THEN
    started := TRUE;
END_IF;

IF started THEN
    Y20 := TRUE;
END_IF;

IF started AND X20 AND NOT completed THEN
    completed := TRUE;
END_IF;

IF completed THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM