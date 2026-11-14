PROGRAM Main
VAR
    D1000 : DINT; D1001 : DINT; D1004 : DINT; D1005 : DINT;
    D1008 : DINT; D1009 : DINT; D1012 : DINT; D1013 : DINT;
    D1016 : DINT; D1017 : DINT; D1020 : DINT; D1021 : DINT;
    D1024 : DINT; D1025 : DINT; D1028 : DINT; D1029 : DINT;
    D100 : DINT; D101 : DINT; D102 : DINT; D103 : DINT; D104 : DINT;
    X30 : BOOL; X31 : BOOL;
    D120 : DINT; D121 : DINT; D122 : DINT; D123 : DINT; D124 : DINT;
    X34 : BOOL; X35 : BOOL;
    X51 : BOOL;
    D90 : DINT; D91 : DINT; D92 : DINT;
    X52 : BOOL; X53 : BOOL;
    D403 : DINT; D404 : DINT; X61 : BOOL;
    D406 : DINT; D407 : DINT; X62 : BOOL;
    D409 : DINT; D410 : DINT; X63 : BOOL;
    D412 : DINT; D413 : DINT; X64 : BOOL;
    D500 : DINT; D501 : DINT; D520 : DINT; D521 : DINT; D522 : DINT;
    D523 : DINT; D524 : DINT; D525 : DINT; D526 : DINT; D527 : DINT;
    X70 : BOOL; X71 : BOOL; X72 : BOOL;
    D600 : DINT; D601 : DINT; D620 : DINT; D621 : DINT; D622 : DINT;
    D623 : DINT; D624 : DINT; D625 : DINT; D626 : DINT; D627 : DINT;
    X75 : BOOL; X76 : BOOL; X77 : BOOL;
    D2000 : DINT; D2001 : DINT; D2002 : DINT; Y40 : BOOL;
    D2004 : DINT; D2005 : DINT; D2006 : DINT; Y41 : BOOL;
    D2008 : DINT; D2009 : DINT; D2010 : DINT; Y42 : BOOL;
    D2012 : DINT; D2013 : DINT; D2014 : DINT; Y43 : BOOL;
    D2016 : DINT; D2017 : DINT; D2018 : DINT; Y44 : BOOL;
    D2020 : DINT; D2021 : DINT; D2022 : DINT; Y45 : BOOL;
    D2024 : DINT; D2025 : DINT; D2026 : DINT; Y46 : BOOL;
    D2028 : DINT; D2029 : DINT; D2030 : DINT; Y47 : BOOL;
    D300 : DINT; D301 : DINT; D302 : DINT; D303 : DINT;
    Y70 : BOOL; Y71 : BOOL; D700 : DINT; D701 : DINT; D702 : DINT;
    Y75 : BOOL; Y76 : BOOL; D710 : DINT; D711 : DINT; D712 : DINT;
    D80 : DINT; D81 : DINT; D82 : DINT; Y30 : BOOL; Y2 : BOOL;

    req_step : ARRAY[0..1] OF INT := [0, 0];
    active_idx : INT := -1;
    seq_num : DINT := 1;
    current_lift : INT := 1;
    target_a : DINT := 0;
    timer_config : TON;
    timer_y2 : TON;
    all_done_flag : BOOL := FALSE;
    moving_flag : BOOL := FALSE;
END_VAR

(* Default safe outputs *)
Y40 := FALSE; D2000 := 0; D2001 := 0; D2002 := 0;
Y41 := FALSE; D2004 := 0; D2005 := 0; D2006 := 0;
Y42 := FALSE; D2008 := 0; D2009 := 0; D2010 := 0;
Y43 := FALSE; D2012 := 0; D2013 := 0; D2014 := 0;
Y44 := FALSE; D2016 := 0; D2017 := 0; D2018 := 0;
Y45 := FALSE; D2020 := 0; D2021 := 0; D2022 := 0;
Y46 := FALSE; D2024 := 0; D2025 := 0; D2026 := 0;
Y47 := FALSE; D2028 := 0; D2029 := 0; D2030 := 0;
Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
D80 := 0; D81 := 0; D82 := 0;
Y2 := FALSE;

(* 1. Request Selection *)
IF active_idx < 0 THEN
    IF (D100 > 0) AND NOT X30 AND NOT X31 THEN
        active_idx := 0;
        req_step[0] := 1;
        current_lift := 1;
        IF D101 = 2 THEN current_lift := 2; END_IF;
    ELSIF (D120 > 0) AND NOT X34 AND NOT X35 THEN
        active_idx := 1;
        req_step[1] := 1;
        current_lift := 1;
        IF D121 = 2 THEN current_lift := 2; END_IF;
    END_IF;
END_IF;

(* 2. State Machine Execution *)
IF active_idx >= 0 THEN
    VAR
        id : DINT;
        p_x : DINT;
        p_ready : BOOL;
        a_pos : DINT;
        a_vel : DINT;
        b_pos : DINT;
        s30_pos : DINT; s31_pos : DINT;
        s30_vel : DINT; s31_vel : DINT;
        s40_pos : DINT; s41_pos : DINT;
        s40_vel : DINT; s41_vel : DINT;
        m3_g0 : DINT; m3_g1 : DINT;
        m4_g0 : DINT; m4_g1 : DINT;
        at_pos : BOOL;
        canceled : BOOL;
    END_VAR
    
    id := IF active_idx = 0 THEN D100 ELSE D120 END_IF;
    canceled := IF active_idx = 0 THEN X31 ELSE X35 END_IF;
    
    a_pos := D1000; a_vel := D1001;
    b_pos := D1004;
    s30_pos := D1016; s31_pos := D1020; s30_vel := D1017; s31_vel := D1021;
    s40_pos := D1024; s41_pos := D1028; s40_vel := D1025; s41_vel := D1029;
    m3_g0 := D500; m3_g1 := D501;
    m4_g0 := D600; m4_g1 := D601;
    
    p_x := IF current_lift = 1 THEN D403 ELSE D406 END_IF;
    p_ready := IF current_lift = 1 THEN X61 ELSE X62 END_IF;
    
    at_pos := (ABS(a_pos - target_a) < 20) AND (ABS(a_vel) < 100);
    moving_flag := (ABS(a_vel) > 100) OR (ABS(D1005) > 100) OR (ABS(D1009) > 100) OR (ABS(D1013) > 100) OR (ABS(D1017) > 100) OR (ABS(D1021) > 100) OR (ABS(D1025) > 100) OR (ABS(D1029) > 100);
    
    (* Lift Preparation & Return *)
    Y42 := TRUE; Y43 := TRUE;
    IF req_step[active_idx] <= 2 THEN
        D2008 := 95000; D2009 := 500; D2010 := 0;
        D2012 := 95000; D2013 := 500; D2014 := 0;
    ELSE
        D2008 := 0; D2009 := 500; D2010 := 0;
        D2012 := 0; D2013 := 500; D2014 := 0;
    END_IF;

    CASE req_step[active_idx] OF
        1: (* Move Shuttle to Lift *)
            target_a := p_x;
            Y40 := TRUE; D2000 := target_a; D2001 := 500; D2002 := 0;
            Y41 := TRUE; D2004 := 0; D2005 := 500; D2006 := 0;
            IF at_pos THEN req_step[active_idx] := 2; END_IF;

        2: (* Connect Fork *)
            Y40 := TRUE; D2000 := target_a; D2001 := 500; D2002 := 0;
            Y41 := TRUE; D2004 := 18000; D2005 := 500; D2006 := 0;
            D81 := current_lift; D80 := 1; D82 := seq_num;
            seq_num := seq_num + 1;
            IF (D90 = id) AND p_ready THEN req_step[active_idx] := 3; END_IF;

        3: (* Move to Cell 3 *)
            target_a := D409;
            Y40 := TRUE; D2000 := target_a; D2001 := 500; D2002 := 0;
            Y41 := TRUE; D2004 := 18000; D2005 := 500; D2006 := 0;
            IF at_pos THEN req_step[active_idx] := 4; END_IF;

        4: (* Process Cell 3 *)
            Y40 := TRUE; D2000 := target_a; D2001 := 500; D2002 := 0;
            Y41 := TRUE; D2004 := 18000; D2005 := 500; D2006 := 0;
            Y44 := TRUE; D2016 := m3_g0; D2017 := 500; D2018 := 0;
            Y45 := TRUE; D2020 := m3_g1; D2021 := 500; D2022 := 0;
            D700 := IF active_idx = 0 THEN D101 ELSE D121 END_IF;
            D701 := 0; D702 := 0;
            Y71 := TRUE;
            IF X70 OR ((ABS(s30_pos - m3_g0) < 20) AND (ABS(s31_pos - m3_g1) < 20)) THEN
                req_step[active_idx] := 5;
            END_IF;

        5: (* Move to Cell 4 *)
            target_a := D412;
            Y40 := TRUE; D2000 := target_a; D2001 := 500; D2002 := 0;
            Y41 := TRUE; D2004 := 18000; D2005 := 500; D2006 := 0;
            Y71 := FALSE;
            IF at_pos THEN req_step[active_idx] := 6; END_IF;

        6: (* Process Cell 4 *)
            Y40 := TRUE; D2000 := target_a; D2001 := 500; D2002 := 0;
            Y41 := TRUE; D2004 := 18000; D2005 := 500; D2006 := 0;
            
            (* Reference change while stopped *)
            IF (ABS(s40_vel) < 100) AND (ABS(s41_vel) < 100) THEN
                timer_config(IN := TRUE, PT := T#50ms);
                Y75 := TRUE;
            END_IF;
            IF timer_config.Q THEN
                Y75 := FALSE;
                timer_config(IN := FALSE);
            END_IF;
            
            Y46 := TRUE; D2024 := m4_g0; D2025 := 500; D2026 := 0;
            Y47 := TRUE; D2028 := m4_g1; D2029 := 500; D2030 := 0;
            D710 := IF active_idx = 0 THEN D101 ELSE D121 END_IF;
            D711 := 0; D712 := 0;
            Y76 := TRUE;
            
            IF X75 OR ((ABS(s40_pos - m4_g0) < 20) AND (ABS(s41_pos - m4_g1) < 20)) THEN
                req_step[active_idx] := 7;
            END_IF;

        7: (* Move to Return Lift *)
            target_a := p_x;
            Y40 := TRUE; D2000 := target_a; D2001 := 500; D2002 := 0;
            Y41 := TRUE; D2004 := 18000; D2005 := 500; D2006 := 0;
            Y76 := FALSE;
            IF at_pos THEN req_step[active_idx] := 8; END_IF;

        8: (* Disconnect Fork *)
            Y40 := TRUE; D2000 := target_a; D2001 := 500; D2002 := 0;
            Y41 := TRUE; D2004 := 0; D2005 := 500; D2006 := 0;
            D81 := current_lift; D80 := 2; D82 := seq_num;
            seq_num := seq_num + 1;
            IF (D90 = 0) OR (NOT p_ready) THEN req_step[active_idx] := 9; END_IF;

        9: (* Acknowledge & Reset *)
            IF active_idx = 0 THEN
                D300 := id; D301 := IF canceled THEN 2 ELSE 1 END_IF;
            ELSE
                D302 := id; D303 := IF canceled THEN 2 ELSE 1 END_IF;
            END_IF;
            req_step[active_idx] := 0;
            active_idx := -1;
            seq_num := 1;
    END_CASE;
END_IF;

(* 3. Brake Management *)
Y30 := NOT moving_flag;

(* 4. Completion Check Y2 *)
IF (D100 > 0 AND NOT X30) OR (D120 > 0 AND NOT X34) THEN
    all_done_flag := FALSE;
ELSE
    all_done_flag := TRUE;
END_IF;

IF all_done_flag THEN
    IF (ABS(D1000) < 20) AND (ABS(D1004) < 20) AND 
       (ABS(D1016 - (-60000)) < 20) AND (ABS(D1020 - (-60000)) < 20) AND
       (ABS(D1024 - (-60000)) < 20) AND (ABS(D1028 - (-60000)) < 20) AND
       (ABS(D1008) < 20) AND (ABS(D1012) < 20) THEN
        timer_y2(IN := TRUE, PT := T#100ms);
        IF timer_y2.Q THEN
            Y2 := TRUE;
        END_IF;
    ELSE
        timer_y2(IN := FALSE, PT := T#100ms);
    END_IF;
ELSE
    timer_y2(IN := FALSE, PT := T#100ms);
END_IF;

END_PROGRAM