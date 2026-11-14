PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    State : INT := 0;
    stop_cnt : INT := 0;
    settle_cnt : INT := 0;
    sweeping_positive : BOOL := FALSE;
    x34_edge : R_TRIG;
    
    a_tgt : DINT := 0;
    a_rt : DINT := 0;
    a_en : BOOL := FALSE;
    
    b_tgt : DINT := 0;
    b_rt : DINT := 0;
    b_en : BOOL := FALSE;
    
    c_tgt : DINT := 0;
    c_rt : DINT := 0;
    c_en : BOOL := FALSE;
END_VAR

x34_edge(CLK := X34);

CASE State OF
    0:
        a_en := FALSE;
        b_en := FALSE;
        c_en := FALSE;
        IF X0 THEN
            State := 1;
        END_IF

    1:
        b_en := TRUE;
        b_tgt := 1000;
        b_rt := 500;
        IF D12 = 1000 AND ABS(D13) <= 1 THEN
            State := 2;
        END_IF

    2:
        b_en := TRUE; b_tgt := 1000; b_rt := 500;
        c_en := TRUE; c_tgt := 10000; c_rt := 500;
        IF D14 >= 6000 THEN
            State := 3;
        END_IF

    3:
        b_en := TRUE; b_tgt := 0; b_rt := 500;
        c_en := TRUE; c_tgt := 10000; c_rt := 500;
        IF D14 >= 9980 AND D12 <= 20 THEN
            IF D10 > 5000 THEN
                a_tgt := 2000;
                a_rt := 500;
                sweeping_positive := FALSE;
            ELSE
                a_tgt := 15000;
                a_rt := 100;
                sweeping_positive := TRUE;
            END_IF
            State := 4;
        END_IF

    4:
        b_en := TRUE; b_tgt := 0; b_rt := 500;
        c_en := TRUE; c_tgt := 10000; c_rt := 500;
        a_en := TRUE;
        
        IF NOT sweeping_positive THEN
            a_tgt := 2000;
            a_rt := 500;
            IF D10 <= 2100 THEN
                a_tgt := 15000;
                a_rt := 100;
                sweeping_positive := TRUE;
            END_IF
        ELSE
            a_tgt := 15000;
            a_rt := 100;
        END_IF
        
        IF x34_edge.Q AND sweeping_positive THEN
            State := 5;
            stop_cnt := 0;
        END_IF

    5:
        b_en := TRUE; b_tgt := 0; b_rt := 500;
        c_en := TRUE; c_tgt := 10000; c_rt := 500;
        a_en := FALSE;
        
        IF ABS(D11) <= 1 THEN
            stop_cnt := stop_cnt + 1;
        ELSE
            stop_cnt := 0;
        END_IF
        
        IF stop_cnt >= 5 THEN
            State := 6;
        END_IF

    6:
        b_en := TRUE; b_tgt := 0; b_rt := 500;
        c_en := TRUE; c_tgt := 10000; c_rt := 500;
        a_en := FALSE;
        
        IF X35 THEN
            State := 7;
            settle_cnt := 0;
        END_IF

    7:
        b_en := TRUE; b_tgt := 0; b_rt := 500;
        c_en := TRUE; c_tgt := 10000; c_rt := 500;
        a_en := TRUE;
        a_tgt := D90 + D101;
        a_rt := 500;
        
        IF ABS(D10 - a_tgt) <= 20 AND ABS(D11) <= 1 AND
           ABS(D12 - 0) <= 20 AND ABS(D13) <= 1 AND
           ABS(D14 - 10000) <= 20 AND ABS(D15) <= 1 THEN
            settle_cnt := settle_cnt + 1;
        ELSE
            settle_cnt := 0;
        END_IF
        
        IF settle_cnt >= 10 THEN
            State := 8;
        END_IF

    8:
        b_en := TRUE; b_tgt := 0; b_rt := 500;
        c_en := TRUE; c_tgt := 10000; c_rt := 500;
        a_en := TRUE; a_tgt := D90 + D101; a_rt := 500;

END_CASE

D20 := a_tgt;
D21 := a_rt;
Y20 := a_en;

D24 := b_tgt;
D25 := b_rt;
Y21 := b_en;

D28 := c_tgt;
D29 := c_rt;
Y22 := c_en;

Y30 := (State = 6);
Y2 := (State = 8);

END_PROGRAM