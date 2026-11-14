PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D20 : DINT;
    Y2 : BOOL;
    
    stable_cnt : DINT;
    ctrl_active : BOOL;
END_VAR

IF X10 THEN
    ctrl_active := TRUE;
END_IF;

IF ctrl_active THEN
    D20 := (D10 - D13) - D14 - D15 - D16;
    
    IF D20 > 180000 THEN D20 := 180000; END_IF;
    IF D20 < -180000 THEN D20 := -180000; END_IF;
    
    IF ABS(D10 - D13) <= 100 AND ABS(D14) <= 100 AND ABS(D15) <= 20 AND ABS(D16) <= 100 THEN
        stable_cnt := stable_cnt + 1;
    ELSE
        stable_cnt := 0;
    END_IF;
    
    IF stable_cnt >= 3 THEN
        Y2 := TRUE;
    END_IF;
ELSE
    D20 := 0;
    Y2 := FALSE;
END_IF;

END_PROGRAM