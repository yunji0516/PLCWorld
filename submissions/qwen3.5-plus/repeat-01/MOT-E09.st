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
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    sum_raw : DINT;
    tmp20 : DINT;
    tmp21 : DINT;
    stable_cnt : INT;
    y2_ready : BOOL;
END_VAR

Y20 := X10;

IF X10 THEN
    tmp20 := -D13 - D15;
    IF tmp20 > 200000 THEN tmp20 := 200000; END_IF;
    IF tmp20 < -200000 THEN tmp20 := -200000; END_IF;
    D20 := tmp20;
    
    tmp21 := -D14 - D16;
    IF tmp21 > 200000 THEN tmp21 := 200000; END_IF;
    IF tmp21 < -200000 THEN tmp21 := -200000; END_IF;
    D21 := tmp21;
    
    sum_raw := D11 + D13 + D15;
    IF ABS(sum_raw) <= 200 THEN
        IF stable_cnt < 3 THEN
            stable_cnt := stable_cnt + 1;
        END_IF;
    ELSE
        stable_cnt := 0;
    END_IF;
    
    IF stable_cnt >= 3 THEN
        y2_ready := TRUE;
    END_IF;
ELSE
    D20 := 0;
    D21 := 0;
    stable_cnt := 0;
    y2_ready := FALSE;
END_IF;

Y2 := y2_ready;
END_PROGRAM