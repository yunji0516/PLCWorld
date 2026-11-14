PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    D20 : INT;
    
    start_edge : R_TRIG;
    active : BOOL;
    withdraw_ended : BOOL;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q AND NOT active AND NOT withdraw_ended THEN
    active := TRUE;
END_IF;

IF active AND NOT withdraw_ended THEN
    IF X20 THEN
        withdraw_ended := TRUE;
        Y20 := FALSE;
    ELSE
        IF D20 <= 250 THEN
            Y20 := TRUE;
        ELSIF D20 >= 500 THEN
            Y20 := FALSE;
        END_IF;
    END_IF;
END_IF;

IF withdraw_ended THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM