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
    started : BOOL;
    completed : BOOL;
    sel1 : BOOL;
    sel2 : BOOL;
    sel3 : BOOL;
END_VAR

start_edge(CLK := X10);
IF start_edge.Q AND NOT started THEN
    started := TRUE;
    sel1 := (D10 AND 1) <> 0;
    sel2 := (D10 AND 2) <> 0;
    sel3 := (D10 AND 4) <> 0;
END_IF;

IF started AND NOT completed THEN
    Y20 := sel1;
    Y21 := sel2;
    Y22 := sel3;

    IF (sel1 <> X20) AND (sel2 <> X21) AND (sel3 <> X22) THEN
        completed := TRUE;
    END_IF;
END_IF;

IF completed THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM