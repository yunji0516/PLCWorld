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
    D500 : DINT; D501 : DINT; D520 : DINT; D521 : DINT; D522 : DINT; D523 : DINT;
    D524 : DINT; D525 : DINT; D526 : DINT; D527 : DINT; X70 : BOOL; X71 : BOOL; X72 : BOOL;
    D600 : DINT; D601 : DINT; D602 : DINT; D620 : DINT; D621 : DINT; D622 : DINT;
    D623 : DINT; D624 : DINT; D625 : DINT; D626 : DINT; D627 : DINT; X75 : BOOL;
    X76 : BOOL; X77 : BOOL;
    D2000 : DINT; D2001 : DINT; D2002 : DINT; Y40 : BOOL;
    D2004 : DINT; D2005 : DINT; D2006 : DINT; Y41 : BOOL;
    D2008 : DINT; D2009 : DINT; D2010 : DINT; Y42 : BOOL;
    D2012 : DINT; D2013 : DINT; D2014 : DINT; Y43 : BOOL;
    D2016 : DINT; D2017 : DINT; D2018 : DINT; Y44 : BOOL;
    D2020 : DINT; D2021 : DINT; D2022 : DINT; Y45 : BOOL;
    D2024 : DINT; D2025 : DINT; D2026 : DINT; Y46 : BOOL;
    D2028 : DINT; D2029 : DINT; D2030 : DINT; Y47 : BOOL;
    D2032 : DINT; D2033 : DINT; D2034 : DINT; Y48 : BOOL;
    D300 : DINT; D301 : DINT; D302 : DINT; D303 : DINT;
    Y70 : BOOL; Y71 : BOOL; D700 : DINT; D701 : DINT; D702 : DINT;
    Y75 : BOOL; Y76 : BOOL; D710 : DINT; D711 : DINT; D712 : DINT;
    D80 : DINT; D81 : DINT; D82 : DINT; Y30 : BOOL; Y2 : BOOL;
    
    sys_state : INT := 0;
    req_stage : INT := 0;
    req_id : DINT := 0;
    req_location : DINT := 0;
    active_req : INT := 0;
    
    seq_num : DINT := 0;
    
    t80ms : TON;
    t100ms : TON;
    t30ms : TON;
    
    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;
    
    pos_a_home : DINT := 0;
    pos_b_home : DINT := 0;
    pos_c_home : DINT := 15000;
    pos_d_home : DINT := 15000;
    pos_s30_home : DINT := -85000;
    pos_s31_home : DINT := -85000;
    pos_s40_home : DINT := -65000;
    pos_s41_home : DINT := 65000;
    pos_s42_home : DINT := 0;
    
    pos_lift_a : DINT := -360000;
    pos_lift_b : DINT := -230000;
    pos_cell3 : DINT := 0;
    pos_cell4 : DINT := 360000;
    dock_height : DINT := 73250;
    fork_extend : DINT := 18000;
    fork_retract : DINT := 0;
    
    rate_val : DINT := 800;
    
    port_ready : BOOL := FALSE;
    lift_idx : DINT := 0;
    
    completion_hold : BOOL := FALSE;
END_VAR

IF sys_state = 0 THEN
    D2000 := pos_a_home; D2001 := 0; Y40 := FALSE; D2002 := 0;
    D2004 := pos_b_home; D2005 := 0; Y41 := FALSE; D2006 := 0;
    D2008 := pos_c_home; D2009 := 0; Y42 := FALSE; D2010 := 0;
    D2012 := pos_d_home; D2013 := 0; Y43 := FALSE; D2014 := 0;
    D2016 := pos_s30_home; D2017 := 0; Y44 := FALSE; D2018 := 0;
    D2020 := pos_s31_home; D2021 := 0; Y45 := FALSE; D2022 := 0;
    D2024 := pos_s40_home; D2025 := 0; Y46 := FALSE; D2026 := 0;
    D2028 := pos_s41_home; D2029 := 0; Y47 := FALSE; D2030 := 0;
    D2032 := pos_s42_home; D2033 := 0; Y48 := FALSE; D2034 := 0;
    Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
    Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
    D80 := 0; D81 := 0; D82 := 0; Y30 := FALSE; Y2 := FALSE;
    D300 := 0; D301 := 0; D302 := 0; D303 := 0;
    
    IF (D1000 = pos_a_home) AND (D1004 = pos_b_home) AND
       (D1008 = pos_c_home) AND (D1012 = pos_d_home) AND
       (D1016 = pos_s30_home) AND (D1020 = pos_s31_home) AND
       (D1024 = pos_s40_home) AND (D1028 = pos_s41_home) AND (D1032 = pos_s42_home) THEN
        sys_state := 1;
    END IF;
ELSIF sys_state = 1 THEN
    Y2 := FALSE;
    completion_hold := FALSE;
    Y30 := FALSE;
    
    IF (NOT r0_done) AND (D102 > 0) THEN
        active_req := 0;
        req_id := D100;
        req_location := D101;
        sys_state := 10;
        req_stage := 0;
    ELSIF (NOT r1_done) AND (D122 > 0) THEN
        active_req := 1;
        req_id := D120;
        req_location := D121;
        sys_state := 10;
        req_stage := 0;
    END IF;
ELSIF sys_state = 10 THEN
    Y30 := FALSE;
    Y40 := TRUE; D2001 := rate_val; D2002 := 0;
    port_ready := FALSE;
    
    IF req_location = 1 THEN
        D2000 := pos_lift_a;
        lift_idx := 1;
    ELSE
        D2000 := pos_lift_b;
        lift_idx := 2;
    END IF;
    
    IF ABS(D1000 - D2000) <= 200 THEN
        req_stage := 1;
    END IF;
ELSIF sys_state = 11 THEN
    Y40 := TRUE; D2001 := 0; D2002 := 0;
    Y41 := TRUE; D2005 := rate_val; D2006 := 0;
    D2004 := fork_extend;
    
    IF req_location = 1 THEN
        Y42 := TRUE; D2009 := rate_val; D2010 := 0;
        D2008 := dock_height;
    ELSE
        Y43 := TRUE; D2013 := rate_val; D2014 := 0;
        D2012 := dock_height;
    END IF;
    
    IF (req_location = 1) AND X61 THEN
        port_ready := TRUE;
    ELSIF (req_location = 2) AND X62 THEN
        port_ready := TRUE;
    END IF;
    
    IF port_ready THEN
        seq_num := seq_num + 1;
        D82 := seq_num;
        D81 := lift_idx;
        D80 := 1;
        req_stage := 2;
    END IF;
ELSIF sys_state = 12 THEN
    Y40 := TRUE; D2001 := rate_val; D2002 := 0;
    D2000 := pos_cell3;
    
    IF ABS(D1000 - pos_cell3) <= 200 THEN
        req_stage := 3;
    END IF;
ELSIF sys_state = 13 THEN
    Y40 := TRUE; D2001 := 0; D2002 := 0;
    Y70 := TRUE;
    D700 := 0;
    D701 := 0;
    D702 := 3000;
    
    IF X70 THEN
        Y71 := TRUE;
        req_stage := 4;
    END IF;
ELSIF sys_state = 14 THEN
    Y40 := TRUE; D2001 := rate_val; D2002 := 0;
    D2000 := pos_cell4;
    
    IF ABS(D1000 - pos_cell4) <= 200 THEN
        req_stage := 5;
    END IF;
ELSIF sys_state = 15 THEN
    Y40 := TRUE; D2001 := 0; D2002 := 0;
    Y75 := TRUE;
    D710 := 0;
    D711 := 0;
    D712 := 5000;
    
    IF X75 THEN
        Y76 := TRUE;
        req_stage := 6;
    END IF;
ELSIF sys_state = 16 THEN
    Y40 := TRUE; D2001 := rate_val; D2002 := 0;
    D2000 := pos_cell3;
    
    IF ABS(D1000 - pos_cell3) <= 200 THEN
        Y71 := FALSE;
        req_stage := 7;
    END IF;
ELSIF sys_state = 17 THEN
    Y40 := TRUE; D2001 := 0; D2002 := 0;
    D81 := 3;
    D80 := 2;
    
    IF X63 THEN
        req_stage := 8;
    END IF;
ELSIF sys_state = 18 THEN
    Y40 := TRUE; D2001 := rate_val; D2002 := 0;
    
    IF req_location = 1 THEN
        D2000 := pos_lift_a;
    ELSE
        D2000 := pos_lift_b;
    END IF;
    
    IF ABS(D1000 - D2000) <= 200 THEN
        req_stage := 9;
    END IF;
ELSIF sys_state = 19 THEN
    Y40 := TRUE; D2001 := 0; D2002 := 0;
    
    IF req_location = 1 THEN
        D2008 := pos_c_home;
        IF D1008 = pos_c_home THEN
            req_stage := 10;
        END IF;
    ELSE
        D2012 := pos_d_home;
        IF D1012 = pos_d_home THEN
            req_stage := 10;
        END IF;
    END IF;
ELSIF sys_state = 20 THEN
    Y41 := TRUE; D2005 := rate_val; D2006 := 0;
    D2004 := fork_retract;
    
    IF D1004 = fork_retract THEN
        D80 := 0;
        D81 := 0;
        Y70 := FALSE; Y71 := FALSE;
        Y75 := FALSE; Y76 := FALSE;
        
        IF active_req = 0 THEN
            r0_done := TRUE;
            D300 := req_id; D301 := 1;
        ELSE
            r1_done := TRUE;
            D302 := req_id; D303 := 1;
        END IF;
        
        req_stage := 0;
        sys_state := 1;
    END IF;
ELSIF sys_state = 2 THEN
    Y2 := FALSE;
    
    IF (r0_done OR X30) AND (r1_done OR X34) THEN
        sys_state := 3;
    END IF;
ELSIF sys_state = 3 THEN
    Y40 := TRUE; D2001 := 0; D2002 := 0; D2000 := pos_a_home;
    Y41 := TRUE; D2005 := 0; D2006 := 0; D2004 := pos_b_home;
    
    Y42 := TRUE; D2009 := 0; D2010 := 0; D2008 := pos_c_home;
    Y43 := TRUE; D2013 := 0; D2014 := 0; D2012 := pos_d_home;
    
    Y44 := TRUE; D2017 := 0; D2018 := 0; D2016 := pos_s30_home;
    Y45 := TRUE; D2021 := 0; D2022 := 0; D2020 := pos_s31_home;
    
    Y46 := TRUE; D2025 := 0; D2026 := 0; D2024 := pos_s40_home;
    Y47 := TRUE; D2029 := 0; D2030 := 0; D2028 := pos_s41_home;
    Y48 := TRUE; D2033 := 0; D2034 := 0; D2032 := pos_s42_home;
    
    Y70 := FALSE; Y71 := FALSE; D700 := 0;
    Y75 := FALSE; Y76 := FALSE; D710 := 0;
    
    IF (D1000 = pos_a_home) AND (D1004 = pos_b_home) AND
       (D1008 = pos_c_home) AND (D1012 = pos_d_home) AND
       (D1016 = pos_s30_home) AND (D1020 = pos_s31_home) AND
       (D1024 = pos_s40_home) AND (D1028 = pos_s41_home) AND (D1032 = pos_s42_home) THEN
        sys_state := 4;
    END IF;
ELSIF sys_state = 4 THEN
    Y30 := FALSE;
    Y2 := TRUE;
    t100ms(IN := TRUE, PT := T#100ms);
    
    IF t100ms.Q THEN
        completion_hold := TRUE;
        sys_state := 5;
    END IF;
ELSIF sys_state = 5 THEN
    Y2 := TRUE;
    t100ms(IN := FALSE, PT := T#100ms);
    completion_hold := TRUE;
    
    IF X51 THEN
        sys_state := 6;
    END IF;
ELSIF sys_state = 6 THEN
    Y2 := TRUE;
    completion_hold := TRUE;
END_IF;

IF sys_state >= 4 THEN
    Y40 := TRUE; D2001 := 0; D2000 := pos_a_home; D2002 := 0;
    Y41 := TRUE; D2005 := 0; D2004 := pos_b_home; D2006 := 0;
    Y42 := TRUE; D2009 := 0; D2008 := pos_c_home; D2010 := 0;
    Y43 := TRUE; D2013 := 0; D2012 := pos_d_home; D2014 := 0;
    Y44 := TRUE; D2017 := 0; D2016 := pos_s30_home; D2018 := 0;
    Y45 := TRUE; D2021 := 0; D2020 := pos_s31_home; D2022 := 0;
    Y46 := TRUE; D2025 := 0; D2024 := pos_s40_home; D2026 := 0;
    Y47 := TRUE; D2029 := 0; D2028 := pos_s41_home; D2030 := 0;
    Y48 := TRUE; D2033 := 0; D2032 := pos_s42_home; D2034 := 0;
END_IF;

END_PROGRAM