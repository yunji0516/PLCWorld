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
    
    started : BOOL := FALSE;
    edge_start : R_TRIG;
    sel1 : BOOL := FALSE;
    sel2 : BOOL := FALSE;
    sel3 : BOOL := FALSE;
    complete : BOOL := FALSE;
END_VAR

edge_start(CLK := X10);

IF edge_start.Q AND NOT started THEN
    started := TRUE;
    sel1 := (D10 MOD 2) <> 0;
    sel2 := ((D10 / 2) MOD 2) <> 0;
    sel3 := ((D10 / 4) MOD 2) <> 0;
END_IF;

IF started THEN
    Y20 := sel1;
    Y21 := sel2;
    Y22 := sel3;
    
    complete := TRUE;
    
    IF sel1 AND X20 THEN 
        complete := FALSE; 
    END_IF;
    
    IF sel2 AND X21 THEN 
        complete := FALSE; 
    END_IF;
    
    IF sel3 AND X22 THEN 
        complete := FALSE; 
    END_IF;
    
    IF NOT sel1 AND NOT X20 THEN 
        complete := FALSE; 
    END_IF;
    
    IF NOT sel2 AND NOT X21 THEN 
        complete := FALSE; 
    END_IF;
    
    IF NOT sel3 AND NOT X22 THEN 
        complete := FALSE; 
    END_IF;
    
    Y2 := complete;
END_IF;

END_PROGRAM