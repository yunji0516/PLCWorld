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
    sel_mask : INT;
    release1_req : BOOL;
    release2_req : BOOL;
    release3_req : BOOL;
    complete : BOOL;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q AND NOT complete THEN
    sel_mask := D10;
    release1_req := (sel_mask AND 1) <> 0;
    release2_req := (sel_mask AND 2) <> 0;
    release3_req := (sel_mask AND 4) <> 0;
    
    Y20 := release1_req;
    Y21 := release2_req;
    Y22 := release3_req;
END_IF;

IF NOT complete THEN
    IF release1_req AND NOT X20 THEN Y20 := FALSE; END_IF;
    IF release2_req AND NOT X21 THEN Y21 := FALSE; END_IF;
    IF release3_req AND NOT X22 THEN Y22 := FALSE; END_IF;
    
    IF (release1_req = NOT X20) AND
       (release2_req = NOT X21) AND
       (release3_req = NOT X22) THEN
        complete := TRUE;
    END_IF;
END_IF;

Y2 := complete;

END_PROGRAM