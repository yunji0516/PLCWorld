PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    D20 : INT;
    
    start_edge : R_TRIG;
    started : BOOL;
    withdrawal_ended : BOOL;
END_VAR

start_edge(CLK := X10);

IF NOT started AND start_edge.Q THEN
    started := TRUE;
END_IF;

IF started THEN
    IF X20 THEN
        withdrawal_ended := TRUE;
    END_IF;
    
    IF NOT withdrawal_ended THEN
        IF D20 <= 260 THEN
            Y20 := TRUE;
        ELSIF D20 >= 400 THEN
            Y20 := FALSE;
        END_IF;
    ELSE
        Y20 := FALSE;
    END_IF;
    
    IF withdrawal_ended AND NOT Y20 THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM