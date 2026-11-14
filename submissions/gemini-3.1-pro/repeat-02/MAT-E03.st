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

    started : BOOL;
    start_edge : R_TRIG;
    sel1 : BOOL;
    sel2 : BOOL;
    sel3 : BOOL;
    mask : INT;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q THEN
    started := TRUE;
    mask := D10;
    
    (* Extract bits 0, 1, and 2 for products P1, P2, and P3 respectively *)
    sel1 := (mask - (mask / 2) * 2) <> 0;
    sel2 := ((mask / 2) - (mask / 4) * 2) <> 0;
    sel3 := ((mask / 4) - (mask / 8) * 2) <> 0;
END_IF;

IF started THEN
    (* Issue release commands to the selected grippers *)
    Y20 := sel1;
    Y21 := sel2;
    Y22 := sel3;
    
    (* Check physical observations against expected holding states *)
    IF (X20 = NOT sel1) AND (X21 = NOT sel2) AND (X22 = NOT sel3) THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM