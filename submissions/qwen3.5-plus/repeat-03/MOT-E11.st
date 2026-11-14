PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    det_mem : BOOL;
    stab_cnt : DINT;
END_VAR

IF X11 THEN
    det_mem := TRUE;
END_IF;

IF X10 AND det_mem THEN
    Y20 := TRUE;
    D20 := D10;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

IF X10 AND det_mem AND (ABS(D11 - D10) <= 20) AND (ABS(D12) <= 100) THEN
    stab_cnt := stab_cnt + 1;
ELSE
    stab_cnt := 0;
END_IF;

IF stab_cnt >= 3 THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM