PROGRAM Main
VAR
    D1000 : DINT; D1001 : DINT; D1004 : DINT; D1005 : DINT; D1008 : DINT; D1009 : DINT;
    D1012 : DINT; D1013 : DINT; D1016 : DINT; D1017 : DINT; D1020 : DINT; D1021 : DINT;
    D1024 : DINT; D1025 : DINT; D1028 : DINT; D1029 : DINT; D1032 : DINT; D1033 : DINT;
    D100 : DINT; D101 : DINT; D102 : DINT; D103 : DINT; D104 : DINT; X30 : BOOL; X31 : BOOL;
    D120 : DINT; D121 : DINT; D122 : DINT; D123 : DINT; D124 : DINT; X34 : BOOL; X35 : BOOL;
    X51 : BOOL; D90 : DINT; D91 : DINT; D92 : DINT; X52 : BOOL; X53 : BOOL;
    D403 : DINT; D404 : DINT; X61 : BOOL; D406 : DINT; D407 : DINT; X62 : BOOL;
    D409 : DINT; D410 : DINT; X63 : BOOL; D412 : DINT; D413 : DINT; X64 : BOOL;
    D500 : DINT; D501 : DINT; D502 : DINT; D520 : DINT; D521 : DINT; D522 : DINT;
    D523 : DINT; D524 : DINT; D525 : DINT; D526 : DINT; D527 : DINT; X70 : BOOL; X71 : BOOL;
    X72 : BOOL; D600 : DINT; D601 : DINT; D620 : DINT; D621 : DINT; D622 : DINT; D623 : DINT;
    D624 : DINT; D625 : DINT; D626 : DINT; D627 : DINT; X75 : BOOL; X76 : BOOL; X77 : BOOL;
    D2000 : DINT; D2001 : DINT; D2002 : DINT; Y40 : BOOL; D2004 : DINT; D2005 : DINT;
    D2006 : DINT; Y41 : BOOL; D2008 : DINT; D2009 : DINT; D2010 : DINT; Y42 : BOOL;
    D2012 : DINT; D2013 : DINT; D2014 : DINT; Y43 : BOOL; D2016 : DINT; D2017 : DINT;
    D2018 : DINT; Y44 : BOOL; D2020 : DINT; D2021 : DINT; D2022 : DINT; Y45 : BOOL;
    D2024 : DINT; D2025 : DINT; D2026 : DINT; Y46 : BOOL; D2028 : DINT; D2029 : DINT;
    D2030 : DINT; Y47 : BOOL; D2032 : DINT; D2033 : DINT; D2034 : DINT; Y48 : BOOL;
    D300 : DINT; D301 : DINT; D302 : DINT; D303 : DINT; Y70 : BOOL; Y71 : BOOL;
    D700 : DINT; D701 : DINT; D702 : DINT; Y75 : BOOL; Y76 : BOOL; D710 : DINT;
    D711 : DINT; D712 : DINT; D80 : DINT; D81 : DINT; D82 : DINT; Y30 : BOOL; Y2 : BOOL;

    state : INT := 0;
    cur_req : INT := 0;
    cancel_flag : BOOL := FALSE;
    lift_pos : DINT := 0;
    seq_ctr : DINT := 1;
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;
    
    t_sync : TON;
    t_hold : TON;
    t_move : TON;
    t_done : TON;
    
    CONST_PORT1 : DINT := -405000;
    CONST_PORT2 : DINT := -185000;
    CONST_PORT3 : DINT := 65000;
    CONST_PORT4 : DINT := 360000;
    CONST_DOCK : DINT := 95000;
    CONST_FORK_IN : DINT := 18000;
    CONST_FORK_OUT : DINT := 0;
END_VAR

CASE state OF
0: (* IDLE *)
    IF NOT req0_done AND D102 > 0 THEN
        cur_req := 1; cancel_flag := X31; state := 10;
    ELSIF NOT req1_done AND D122 > 0 THEN
        cur_req := 2; cancel_flag := X35; state := 10;
    ELSE
        Y40 := FALSE; Y41 := FALSE; Y42 := FALSE; Y43 := FALSE;
        Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE; Y48 := FALSE;
        Y70 := FALSE; Y71 := FALSE; Y75 := FALSE; Y76 := FALSE;
        D300 := 0; D301 := 0; D302 := 0; D303 := 0;
        D80 := 0; D81 := 0; D82 := 0;
        D2000 := 0; D2001 := 0; D2002 := 0;
        D2004 := 0; D2005 := 0; D2006 := 0;
        D2008 := 0; D2009 := 0; D2010 := 0;
        D2012 := 0; D2013 := 0; D2014 := 0;
        D2016 := 0; D2017 := 0; D2018 := 0;
        D2020 := 0; D2021 := 0; D2022 := 0;
        D2024 := 0; D2025 := 0; D2026 := 0;
        D2028 := 0; D2029 := 0; D2030 := 0;
        D2032 := 0; D2033 := 0; D2034 := 0;
        D700 := 0; D701 := 0; D702 := 0;
        D710 := 0; D711 := 0; D712 := 0;
        Y30 := FALSE;
        Y2 := t_done.Q;
    END_IF;

10: (* MOVE SHUTTLE TO LIFT *)
    IF cur_req = 1 THEN lift_pos := CONST_PORT1; D81 := 1;
    ELSIF cur_req = 2 THEN lift_pos := CONST_PORT2; D81 := 2;
    END_IF;
    D80 := 1; D82 := seq_ctr;
    Y40 := TRUE; D2000 := lift_pos; D2001 := 500; D2002 := 0;
    Y41 := FALSE; Y42 := FALSE; Y43 := FALSE;
    Y44 := FALSE; 
    Y45 := TRUE; D2020 := 0; D2021 := 200; D2022 := 0;
    Y46 := TRUE; D2024 := 0; D2025 := 200; D2026 := 0;
    Y47 := FALSE; Y48 := FALSE;
    Y70 := FALSE; Y71 := FALSE; Y75 := FALSE; Y76 := FALSE;
    D700 := 0; D701 := 0; D702 := 3000; D710 := 0; D711 := 0; D712 := 7200;
    D2016 := 0; D2017 := 0; D2018 := 0;
    D2028 := 0; D2029 := 0; D2030 := 0;
    D2032 := 0; D2033 := 0; D2034 := 0;
    t_move(IN := ABS(D1000 - lift_pos) > 500, PT := T#2000ms);
    IF t_move.Q THEN state := 20; END_IF;

20: (* EXTEND FORK *)
    D80 := 2;
    Y41 := TRUE; D2004 := CONST_FORK_IN; D2005 := 300; D2006 := 0;
    Y40 := TRUE; D2000 := lift_pos; D2001 := 50;
    t_move(IN := D1004 < CONST_FORK_IN - 200, PT := T#1000ms);
    IF t_move.Q THEN state := 30; END_IF;

30: (* LIFT UP *)
    IF cur_req = 1 THEN Y42 := TRUE; D2008 := CONST_DOCK; D2009 := 400; D2010 := 0; Y43 := FALSE;
    ELSIF cur_req = 2 THEN Y43 := TRUE; D2012 := CONST_DOCK; D2013 := 400; D2014 := 0; Y42 := FALSE;
    END_IF;
    t_move(IN := TRUE, PT := T#2000ms);
    IF t_move.Q THEN state := 40; END_IF;

40: (* WAIT COUPLING *)
    D80 := 0; D81 := 0;
    Y40 := TRUE; D2000 := lift_pos; D2001 := 50;
    Y41 := TRUE; D2004 := CONST_FORK_IN; D2005 := 50;
    IF cur_req = 1 THEN Y42 := TRUE; D2008 := CONST_DOCK; D2009 := 50; Y43 := FALSE;
    ELSE Y43 := TRUE; D2012 := CONST_DOCK; D2013 := 50; Y42 := FALSE; END_IF;
    
    IF cur_req = 1 AND X61 AND ABS(D1000 - CONST_PORT1) < 1000 THEN state := 50;
    ELSIF cur_req = 2 AND X62 AND ABS(D1000 - CONST_PORT2) < 1000 THEN state := 50;
    END_IF;

50: (* MOVE TO CELL 3 *)
    D81 := 3; D82 := seq_ctr;
    Y40 := TRUE; D2000 := CONST_PORT3; D2001 := 500; D2002 := 0;
    Y45 := TRUE; D2020 := 0; D2021 := 200; D2022 := 0;
    Y46 := TRUE; D2024 := 0; D2025 := 200; D2026 := 0;
    t_move(IN := ABS(D1000 - CONST_PORT3) > 500, PT := T#2000ms);
    IF t_move.Q THEN state := 60; END_IF;

60: (* CELL 3 PROCESS *)
    Y71 := TRUE; Y70 := TRUE;
    Y44 := TRUE; D2016 := 0; D2017 := 0; D2018 := 0;
    Y45 := TRUE; D2020 := 0; D2021 := 100; D2022 := 0;
    Y46 := TRUE; D2024 := 0; D2025 := 100; D2026 := 0;
    t_hold(IN := X72 OR X70, PT := T#80ms);
    IF t_hold.Q THEN state := 70; END_IF;

70: (* MOVE TO CELL 4 *)
    D81 := 4; D82 := seq_ctr;
    Y70 := FALSE;
    Y40 := TRUE; D2000 := CONST_PORT4; D2001 := 500; D2002 := 0;
    t_move(IN := ABS(D1000 - CONST_PORT4) > 500, PT := T#2000ms);
    IF t_move.Q THEN state := 80; END_IF;

80: (* CELL 4 GEAR SYNC *)
    Y75 := TRUE; Y76 := FALSE; Y71 := TRUE;
    D710 := 1000; D711 := 0; D712 := 7200;
    Y47 := TRUE; D2028 := D600; D2029 := 500; D2030 := 0;
    Y48 := TRUE; D2032 := D600; D2033 := 500; D2034 := 0;
    t_sync(IN := (ABS(D1017) > 100) AND (ABS(D1017 - D1029) <= 20) AND (ABS(D1016/100 - D1028/100) <= 20), PT := T#50ms);
    IF t_sync.Q THEN state := 90; END_IF;

90: (* WAIT CELL 4 RESULT *)
    Y75 := TRUE; Y71 := TRUE;
    t_hold(IN := X77 OR X75, PT := T#80ms);
    IF t_hold.Q THEN state := 100; END_IF;

100: (* RETURN SHUTTLE *)
    IF cur_req = 1 THEN lift_pos := CONST_PORT1;
    ELSIF cur_req = 2 THEN lift_pos := CONST_PORT2;
    END_IF;
    D81 := cur_req; D82 := seq_ctr;
    Y75 := FALSE; Y76 := FALSE;
    Y40 := TRUE; D2000 := lift_pos; D2001 := 500; D2002 := 0;
    Y47 := TRUE; D2028 := 0; D2029 := 200; D2030 := 0;
    Y48 := TRUE; D2032 := 0; D2033 := 200; D2034 := 0;
    t_move(IN := ABS(D1000 - lift_pos) > 500, PT := T#2000ms);
    IF t_move.Q THEN state := 110; END_IF;

110: (* RETRACT FORK *)
    D80 := 1;
    Y41 := TRUE; D2004 := CONST_FORK_OUT; D2005 := 300; D2006 := 0;
    Y40 := TRUE; D2000 := lift_pos; D2001 := 50;
    t_move(IN := D1004 > CONST_FORK_OUT + 200, PT := T#1000ms);
    IF t_move.Q THEN state := 120; END_IF;

120: (* LIFT DOWN *)
    IF cur_req = 1 THEN Y42 := TRUE; D2008 := 40000; D2009 := 400; D2010 := 0; Y43 := FALSE;
    ELSIF cur_req = 2 THEN Y43 := TRUE; D2012 := 40000; D2013 := 400; D2014 := 0; Y42 := FALSE;
    END_IF;
    t_move(IN := TRUE, PT := T#2000ms);
    IF t_move.Q THEN state := 130; END_IF;

130: (* ACK *)
    IF cur_req = 1 THEN
        D300 := D100; D301 := IF cancel_flag THEN 2 ELSE 1 END_IF;
        req0_done := TRUE;
    ELSIF cur_req = 2 THEN
        D302 := D120; D303 := IF cancel_flag THEN 2 ELSE 1 END_IF;
        req1_done := TRUE;
    END_IF;
    seq_ctr := seq_ctr + 1;
    cur_req := 0;
    state := 0;
END_CASE;

Y30 := FALSE;
Y2 := t_done.Q;
t_done(IN := (req0_done AND req1_done) AND (ABS(D1000) < 500) AND (ABS(D1004) < 500) AND (ABS(D1008 - 40000) < 500) AND (ABS(D1012 - 40000) < 500), PT := T#100ms);
END_PROGRAM