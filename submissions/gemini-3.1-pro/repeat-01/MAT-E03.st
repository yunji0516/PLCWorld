PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    
    start_edge : R_TRIG;
    active : BOOL;
    sel1 : BOOL;
    sel2 : BOOL;
    sel3 : BOOL;
    timer : TON;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q THEN
    active := TRUE;
    sel1 := AND_WORD(WORD(D10), WORD(1)) <> WORD(0);
    sel2 := AND_WORD(WORD(D10), WORD(2)) <> WORD(0);
    sel3 := AND_WORD(WORD(D10), WORD(4)) <> WORD(0);
END_IF;

IF active THEN
    Y20 := sel1;
    Y21 := sel2;
    Y22 := sel3;
    
    timer(IN := TRUE, PT := T#250ms);
    
    IF timer.Q THEN
        IF (X20 = NOT sel1) AND (X21 = NOT sel2) AND (X22 = NOT sel3) THEN
            Y2 := TRUE;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM