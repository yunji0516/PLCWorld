PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    maint_cnt : INT := 0;
    y2_ready : BOOL := FALSE;
    a_deg : REAL;
    a_speed : REAL;
    sin_a : REAL;
    cos_a : REAL;
    b_target : REAL;
    b_ff : REAL;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    
    a_deg := D13 / 100.0;
    a_speed := D14 / 100.0;
    
    sin_a := SIN(a_deg * 0.01745329252);
    cos_a := COS(a_deg * 0.01745329252);
    
    b_target := -450.0 * sin_a;
    b_ff := -450.0 * cos_a * a_speed * 0.01745329252;
    
    D20 := DINT(b_target * 100.0);
    D21 := DINT(b_ff * 100.0);
    
    IF D20 > 150000 THEN D20 := 150000; END_IF;
    IF D20 < -150000 THEN D20 := -150000; END_IF;
    
    IF D21 > 100000 THEN D21 := 100000; END_IF;
    IF D21 < -100000 THEN D21 := -100000; END_IF;
    
    IF NOT y2_ready THEN
        IF ABS(D17) <= 100 THEN
            IF maint_cnt < 3 THEN
                maint_cnt := maint_cnt + 1;
            END_IF;
            IF maint_cnt >= 3 THEN
                y2_ready := TRUE;
            END_IF;
        ELSE
            maint_cnt := 0;
        END_IF;
    END_IF;
    
    Y2 := y2_ready;
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
    maint_cnt := 0;
    y2_ready := FALSE;
END_IF;

END_PROGRAM