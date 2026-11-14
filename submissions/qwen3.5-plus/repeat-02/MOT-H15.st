PROGRAM Main
VAR
    D1000 : DINT;
    D1001 : DINT;
    D1004 : DINT;
    D1005 : DINT;
    D1008 : DINT;
    D1009 : DINT;
    D1012 : DINT;
    D1013 : DINT;
    D1016 : DINT;
    D1017 : DINT;
    D1020 : DINT;
    D1021 : DINT;
    D1024 : DINT;
    D1025 : DINT;
    D1028 : DINT;
    D1029 : DINT;
    D1032 : DINT;
    D1033 : DINT;
    D1036 : DINT;
    D1037 : DINT;
    D100 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    X30 : BOOL;
    X31 : BOOL;
    D120 : DINT;
    D121 : DINT;
    D122 : DINT;
    D123 : DINT;
    D124 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    X51 : BOOL;
    D90 : DINT;
    D91 : DINT;
    D92 : DINT;
    X52 : BOOL;
    X53 : BOOL;
    D403 : DINT;
    D404 : DINT;
    X61 : BOOL;
    D406 : DINT;
    D407 : DINT;
    X62 : BOOL;
    D409 : DINT;
    D410 : DINT;
    X63 : BOOL;
    D412 : DINT;
    D413 : DINT;
    X64 : BOOL;
    D500 : DINT;
    D501 : DINT;
    D502 : DINT;
    D520 : DINT;
    D521 : DINT;
    D522 : DINT;
    D523 : DINT;
    D524 : DINT;
    D525 : DINT;
    D526 : DINT;
    D527 : DINT;
    X70 : BOOL;
    X71 : BOOL;
    X72 : BOOL;
    D600 : DINT;
    D601 : DINT;
    D602 : DINT;
    D620 : DINT;
    D621 : DINT;
    D622 : DINT;
    D623 : DINT;
    D624 : DINT;
    D625 : DINT;
    D626 : DINT;
    D627 : DINT;
    X75 : BOOL;
    X76 : BOOL;
    X77 : BOOL;
    D2000 : DINT;
    D2001 : DINT;
    D2002 : DINT;
    Y40 : BOOL;
    D2004 : DINT;
    D2005 : DINT;
    D2006 : DINT;
    Y41 : BOOL;
    D2008 : DINT;
    D2009 : DINT;
    D2010 : DINT;
    Y42 : BOOL;
    D2012 : DINT;
    D2013 : DINT;
    D2014 : DINT;
    Y43 : BOOL;
    D2016 : DINT;
    D2017 : DINT;
    D2018 : DINT;
    Y44 : BOOL;
    D2020 : DINT;
    D2021 : DINT;
    D2022 : DINT;
    Y45 : BOOL;
    D2024 : DINT;
    D2025 : DINT;
    D2026 : DINT;
    Y46 : BOOL;
    D2028 : DINT;
    D2029 : DINT;
    D2030 : DINT;
    Y47 : BOOL;
    D2032 : DINT;
    D2033 : DINT;
    D2034 : DINT;
    Y48 : BOOL;
    D2036 : DINT;
    D2037 : DINT;
    D2038 : DINT;
    Y49 : BOOL;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    Y70 : BOOL;
    Y71 : BOOL;
    D700 : DINT;
    D701 : DINT;
    D702 : DINT;
    Y75 : BOOL;
    Y76 : BOOL;
    D710 : DINT;
    D711 : DINT;
    D712 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y30 : BOOL;
    Y2 : BOOL;
    
    st : INT := 0;
    req_sel : DINT := 0;
    loc_sel : DINT := 1;
    tgt_sel : DINT := 90;
    seq : DINT := 1;
    dock_x : DINT := 0;
    lift_t : DINT := 40000;
    s30_t : DINT := 0;
    s31_t : DINT := 0;
    s32_t : DINT := 0;
    m3_ang : REAL := 0.0;
    pck : DINT := 1;
    r0_fin : BOOL := FALSE;
    r1_fin : BOOL := FALSE;
    tmr_move : TON;
    edge_m3 : R_TRIG;
    edge_m4 : R_TRIG;
    tmr_y2 : TON;
    pi_v : REAL := 3.14159265;
END_VAR

(* Default outputs *)
D2000 := 0; Y40 := FALSE; D2001 := 20; D2002 := 0;
D2004 := 0; Y41 := FALSE; D2005 := 20; D2006 := 0;
D2008 := 40000; Y42 := FALSE; D2009 := 20; D2010 := 0;
D2012 := 40000; Y43 := FALSE; D2013 := 20; D2014 := 0;
D2016 := 0; Y44 := FALSE; D2017 := 20; D2018 := 0;
D2020 := 0; Y45 := FALSE; D2021 := 20; D2022 := 0;
D2024 := 0; Y46 := FALSE; D2025 := 20; D2026 := 0;
D2028 := 0; Y47 := FALSE; D2029 := 20; D2030 := 0;
D2032 := 0; Y48 := FALSE; D2033 := 20; D2034 := 0;
D2036 := 0; Y49 := FALSE; D2037 := 20; D2038 := 0;
Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
D80 := 0; D81 := 0; D82 := 0;
Y30 := TRUE;
Y2 := FALSE;
D300 := 0; D301 := 0; D302 := 0; D303 := 0;

edge_m3(CLK := X70);
edge_m4(CLK := X75);

(* Request Selection *)
IF st = 0 THEN
    IF NOT r0_fin AND D102 > 0 THEN
        req_sel := 0; loc_sel := D101; tgt_sel := 90; seq := seq + 1; st := 1;
    ELSIF NOT r1_fin AND D122 > 0 THEN
        req_sel := 1; loc_sel := D121; tgt_sel := 180; seq := seq + 1; st := 1;
    END_IF;
END_IF;

CASE st OF
    1: (* Approach Lift *)
        IF loc_sel = 1 THEN dock_x := -405000; ELSE dock_x := -185000; END_IF;
        lift_t := LIMIT(0, D92, 120000);
        
        D2000 := LIMIT(-450000, dock_x, 450000); Y40 := TRUE; D2001 := 500;
        D2004 := 18000; Y41 := TRUE; D2005 := 500;
        IF loc_sel = 1 THEN
            D2008 := LIMIT(0, lift_t, 120000); Y42 := TRUE; D2009 := 500;
            D2012 := 40000; Y43 := TRUE; D2013 := 20;
        ELSE
            D2012 := LIMIT(0, lift_t, 120000); Y43 := TRUE; D2013 := 500;
            D2008 := 40000; Y42 := TRUE; D2009 := 20;
        END_IF;
        Y30 := FALSE;
        
        tmr_move(IN := (ABS(D1000 - dock_x) < 20) AND (ABS(D1001) < 100) AND (ABS(D1004 - 18000) < 20) AND (ABS(D1005) < 100), PT := T#30ms);
        IF tmr_move.Q THEN st := 2; END_IF;
        
    2: (* Connect to Lift *)
        D80 := 1; D81 := loc_sel; D82 := seq;
        IF (loc_sel = 1 AND X61) OR (loc_sel = 2 AND X62) THEN
            st := 3;
        END_IF;
        
    3: (* Move to Cell 3 *)
        D2000 := 0; Y40 := TRUE; D2001 := 500;
        D2004 := 18000; Y41 := TRUE; D2005 := 500;
        
        tmr_move(IN := (ABS(D1000) < 20) AND (ABS(D1001) < 100) AND (ABS(D1004 - 18000) < 20) AND (ABS(D1005) < 100), PT := T#30ms);
        IF tmr_move.Q THEN st := 4; END_IF;
        
    4: (* Process Cell 3 *)
        Y70 := TRUE; D701 := 1; D702 := 1;
        IF tgt_sel = 90 THEN
            s30_t := 3500; s31_t := -2000;
            m3_ang := SIN(35.0 * pi_v / 180.0) + SIN(-20.0 * pi_v / 180.0);
            s32_t := DINT(-225.0 * m3_ang * 100.0);
        ELSE
            s30_t := -3500; s31_t := 2000;
            m3_ang := SIN(-35.0 * pi_v / 180.0) + SIN(20.0 * pi_v / 180.0);
            s32_t := DINT(-225.0 * m3_ang * 100.0);
        END_IF;
        s32_t := LIMIT(-45000, s32_t, 45000);
        
        D2016 := s30_t; Y44 := TRUE; D2017 := 500;
        D2020 := s31_t; Y45 := TRUE; D2021 := 500;
        D2024 := s32_t; Y46 := TRUE; D2025 := 500;
        
        IF edge_m3.Q THEN st := 5; END_IF;
        
    5: (* Move to Cell 4 *)
        D2000 := 375000; Y40 := TRUE; D2001 := 500;
        D2004 := 18000; Y41 := TRUE; D2005 := 500;
        
        tmr_move(IN := (ABS(D1000 - 375000) < 20) AND (ABS(D1001) < 100) AND (ABS(D1004 - 18000) < 20) AND (ABS(D1005) < 100), PT := T#30ms);
        IF tmr_move.Q THEN st := 6; END_IF;
        
    6: (* Process Cell 4 *)
        Y75 := TRUE; D711 := 1; D712 := 1;
        IF m3_ang < 0.0 THEN pck := 1 ELSE pck := 2 END_IF;
        D710 := pck;
        
        IF edge_m4.Q THEN st := 7; END_IF;
        
    7: (* Return to Lift *)
        D2000 := dock_x; Y40 := TRUE; D2001 := 500;
        D2004 := 18000; Y41 := TRUE; D2005 := 500;
        
        tmr_move(IN := (ABS(D1000 - dock_x) < 20) AND (ABS(D1001) < 100) AND (ABS(D1004 - 18000) < 20) AND (ABS(D1005) < 100), PT := T#30ms);
        IF tmr_move.Q THEN st := 8; END_IF;
        
    8: (* Place on Lift *)
        D80 := 2; D81 := loc_sel; D82 := seq;
        IF (loc_sel = 1 AND X61) OR (loc_sel = 2 AND X62) THEN
            st := 9;
        END_IF;
        
    9: (* Disconnect & Descend *)
        D2004 := 0; Y41 := TRUE; D2005 := 500;
        IF loc_sel = 1 THEN
            D2008 := 40000; Y42 := TRUE; D2009 := 500;
        ELSE
            D2012 := 40000; Y43 := TRUE; D2013 := 500;
        END_IF;
        
        IF loc_sel = 1 THEN
            tmr_move(IN := (ABS(D1004) < 20) AND (ABS(D1005) < 100) AND (ABS(D1008 - 40000) < 20) AND (ABS(D1009) < 100), PT := T#30ms);
        ELSE
            tmr_move(IN := (ABS(D1004) < 20) AND (ABS(D1005) < 100) AND (ABS(D1012 - 40000) < 20) AND (ABS(D1013) < 100), PT := T#30ms);
        END_IF;
        IF tmr_move.Q THEN st := 10; END_IF;
        
    10: (* Ack & Wait Returned *)
        IF req_sel = 0 THEN
            D300 := D100; D301 := 1;
            IF X30 OR X31 THEN r0_fin := TRUE; st := 0; END_IF;
        ELSE
            D302 := D120; D303 := 1;
            IF X34 OR X35 THEN r1_fin := TRUE; st := 0; END_IF;
        END_IF;
        
    11: (* Complete *)
        D2000 := 0; Y40 := FALSE; D2001 := 20;
        D2004 := 0; Y41 := FALSE; D2005 := 20;
        D2008 := 40000; Y42 := FALSE; D2009 := 20;
        D2012 := 40000; Y43 := FALSE; D2013 := 20;
        D2016 := 0; Y44 := FALSE; D2017 := 20;
        D2020 := 0; Y45 := FALSE; D2021 := 20;
        D2024 := 0; Y46 := FALSE; D2025 := 20;
        D2028 := 0; Y47 := FALSE; D2029 := 20;
        D2032 := 0; Y48 := FALSE; D2033 := 20;
        D2036 := 0; Y49 := FALSE; D2037 := 20;
        Y30 := TRUE;
        Y2 := TRUE;
END_CASE;

IF r0_fin AND r1_fin THEN
    st := 11;
END_IF;

tmr_y2(IN := Y2, PT := T#100ms);
IF tmr_y2.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM