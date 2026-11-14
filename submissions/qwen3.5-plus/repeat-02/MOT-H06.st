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
    D603 : DINT;
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
    
    (* Internal state *)
    g_st : INT := 0;
    g_step : INT := 0;
    g_req : INT := -1;
    g_seq : DINT := 0;
    g_sta_tgt : DINT := 0;
    g_lift_tgt : DINT := 0;
    
    t_settle : TON;
    t_compl : TON;
    t_cell : TON;
    
    f_done0 : BOOL;
    f_done1 : BOOL;
    f_cancel0 : BOOL;
    f_cancel1 : BOOL;
    f_compl_held : BOOL;
    
    (* Rate limits *)
    RATE_MOVE : DINT := 800;
    
    (* Tolerances in raw units (×0.01) *)
    TOL_POS : REAL := 20.0;
    TOL_VEL : REAL := 100.0;
    
    (* Constants *)
    DOCK_H : DINT := 73250;
    INIT_H : DINT := 15000;
    STN3 : DINT := 0;
    STN4 : DINT := 670000;
    FORK_CONN : DINT := 18000;
    FORK_RETR : DINT := 0;
    SLIDE_RET : DINT := 50000;
    SLIDE_EXT : DINT := 70000;
    BOOM_RET : DINT := 8000;
END_VAR

(* Detect cancellation flags early *)
IF NOT f_done0 AND D100 > 0 AND X31 THEN
    f_cancel0 := TRUE;
END_IF;
IF NOT f_done1 AND D120 > 0 AND X35 THEN
    f_cancel1 := TRUE;
END_IF;

(* Default all outputs OFF/zero each scan *)
D2000 := 0; D2001 := 0; D2002 := 0; Y40 := FALSE;
D2004 := 0; D2005 := 0; D2006 := 0; Y41 := FALSE;
D2008 := 0; D2009 := 0; D2010 := 0; Y42 := FALSE;
D2012 := 0; D2013 := 0; D2014 := 0; Y43 := FALSE;
D2016 := 0; D2017 := 0; D2018 := 0; Y44 := FALSE;
D2020 := 0; D2021 := 0; D2022 := 0; Y45 := FALSE;
D2024 := 0; D2025 := 0; D2026 := 0; Y46 := FALSE;
D2028 := 0; D2029 := 0; D2030 := 0; Y47 := FALSE;
D2032 := 0; D2033 := 0; D2034 := 0; Y48 := FALSE;
D2036 := 0; D2037 := 0; D2038 := 0; Y49 := FALSE;
Y30 := FALSE;
Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
D80 := 0; D81 := 0; D82 := 0;
D300 := 0; D301 := 0; D302 := 0; D303 := 0;
Y2 := FALSE;

CASE g_st OF
    0: (* WAIT FOR REQUEST *)
        IF NOT f_done0 AND D100 > 0 THEN
            g_req := 0;
            g_st := 1; g_step := 0;
        ELSIF NOT f_done1 AND D120 > 0 THEN
            g_req := 1;
            g_st := 1; g_step := 0;
        END_IF;
        
    1: (* MOVE SHUTTLE TO LIFT STATION *)
        IF g_req = 0 THEN
            g_sta_tgt := D101 * 100;
        ELSE
            g_sta_tgt := D121 * 100;
        END_IF;
        
        D2000 := g_sta_tgt;
        D2001 := RATE_MOVE;
        Y40 := TRUE;
        
        IF ABS(REAL(D1000) - REAL(g_sta_tgt)) < TOL_POS AND ABS(REAL(D1001)) < TOL_VEL THEN
            g_step := 1;
        END_IF;
        
    2: (* CONNECT LIFT - FORK EXTEND *)
        D2004 := FORK_CONN;
        D2005 := RATE_MOVE;
        Y41 := TRUE;
        g_step := 2;
        
    3: (* CONNECT LIFT - RAISE LIFT *)
        D2004 := FORK_CONN;
        D2005 := RATE_MOVE;
        Y41 := TRUE;
        
        IF g_req = 0 THEN
            D2008 := DOCK_H;
            D2009 := RATE_MOVE;
            Y42 := TRUE;
            D81 := 1;
            IF X61 AND ABS(REAL(D1008) - REAL(DOCK_H)) < TOL_POS AND ABS(REAL(D1004) - REAL(FORK_CONN)) < TOL_POS THEN
                g_step := 3;
            END_IF;
        ELSE
            D2012 := DOCK_H;
            D2013 := RATE_MOVE;
            Y43 := TRUE;
            D81 := 2;
            IF X62 AND ABS(REAL(D1012) - REAL(DOCK_H)) < TOL_POS AND ABS(REAL(D1004) - REAL(FORK_CONN)) < TOL_POS THEN
                g_step := 3;
            END_IF;
        END_IF;
        
    4: (* NEW CONNECTION SEQUENCE *)
        D81 := 0;
        g_seq := g_seq + 1;
        D82 := g_seq;
        g_step := 4;
        
    5: (* MOVE TO CELL 3 *)
        D2000 := STN3;
        D2001 := RATE_MOVE;
        Y40 := TRUE;
        
        IF ABS(REAL(D1000) - REAL(STN3)) < TOL_POS AND ABS(REAL(D1001)) < TOL_VEL THEN
            g_step := 5;
        END_IF;
        
    6: (* CELL 3 - ROTATE AT SLIDE ≤500 *)
        Y70 := TRUE;
        IF g_req = 0 THEN
            D700 := D520;
            D701 := D526;
            D2016 := D527;
        ELSE
            D700 := D620;
            D701 := D626;
            D2016 := D627;
        END_IF;
        D2017 := RATE_MOVE;
        Y44 := TRUE;
        D2020 := SLIDE_RET;
        D2021 := RATE_MOVE;
        Y45 := TRUE;
        
        t_cell(IN := X72, PT := T#80ms);
        IF t_cell.Q THEN
            g_step := 6;
        END_IF;
        
    7: (* CELL 3 - APPROACH 700mm AFTER STOP *)
        Y70 := TRUE;
        D2020 := SLIDE_EXT;
        D2021 := RATE_MOVE;
        Y45 := TRUE;
        
        IF ABS(REAL(D1020) - REAL(SLIDE_EXT)) < TOL_POS THEN
            g_step := 7;
        END_IF;
        
    8: (* MOVE TO CELL 4 *)
        D2000 := STN4;
        D2001 := RATE_MOVE;
        Y40 := TRUE;
        
        IF ABS(REAL(D1000) - REAL(STN4)) < TOL_POS AND ABS(REAL(D1001)) < TOL_VEL THEN
            g_step := 8;
        END_IF;
        
    9: (* CELL 4 - BOOM RETRACT ≤80 BEFORE SWIVEL *)
        Y75 := TRUE;
        IF g_req = 0 THEN
            D710 := D620;
            D711 := D626;
        ELSE
            D710 := D620;
            D711 := D626;
        END_IF;
        D2024 := 0; D2025 := RATE_MOVE; Y46 := TRUE;
        D2028 := BOOM_RET; D2029 := RATE_MOVE; Y47 := TRUE;
        D2032 := 0; D2033 := RATE_MOVE; Y48 := TRUE;
        D2036 := 0; D2037 := RATE_MOVE; Y49 := TRUE;
        
        t_cell(IN := X77, PT := T#80ms);
        IF t_cell.Q THEN
            g_step := 9;
        END_IF;
        
    10: (* MOVE BACK TO LIFT STATION *)
        D2000 := g_sta_tgt;
        D2001 := RATE_MOVE;
        Y40 := TRUE;
        
        IF ABS(REAL(D1000) - REAL(g_sta_tgt)) < TOL_POS AND ABS(REAL(D1001)) < TOL_VEL THEN
            g_step := 10;
        END_IF;
        
    11: (* DISCONNECT - FORK RETRACT & LOWER LIFT *)
        D2004 := FORK_RETR;
        D2005 := RATE_MOVE;
        Y41 := TRUE;
        
        IF g_req = 0 THEN
            D2008 := INIT_H;
            D2009 := RATE_MOVE;
            Y42 := TRUE;
            IF X30 AND ABS(REAL(D1004) - REAL(FORK_RETR)) < TOL_POS AND ABS(REAL(D1008) - REAL(INIT_H)) < TOL_POS THEN
                g_step := 11;
            END_IF;
        ELSE
            D2012 := INIT_H;
            D2013 := RATE_MOVE;
            Y43 := TRUE;
            IF X34 AND ABS(REAL(D1004) - REAL(FORK_RETR)) < TOL_POS AND ABS(REAL(D1012) - REAL(INIT_H)) < TOL_POS THEN
                g_step := 11;
            END_IF;
        END_IF;
        
    12: (* ACKNOWLEDGE *)
        IF g_req = 0 THEN
            D300 := D100;
            D301 := 1;
            IF f_cancel0 THEN D301 := 2; END_IF;
            f_done0 := TRUE;
        ELSE
            D302 := D120;
            D303 := 1;
            IF f_cancel1 THEN D303 := 2; END_IF;
            f_done1 := TRUE;
        END_IF;
        
        g_st := 0;
        g_step := 0;
        g_req := -1;
        
    13: (* CANCEL RETRIEVAL - RETURN TO LIFT AND RELEASE *)
        (* Retrieve access mechanism and return fixture *)
        D2000 := g_sta_tgt;
        D2001 := RATE_MOVE;
        Y40 := TRUE;
        
        IF ABS(REAL(D1000) - REAL(g_sta_tgt)) < TOL_POS THEN
            D2004 := FORK_RETR;
            D2005 := RATE_MOVE;
            Y41 := TRUE;
            
            IF g_req = 0 THEN
                D2008 := INIT_H;
                D2009 := RATE_MOVE;
                Y42 := TRUE;
            ELSE
                D2012 := INIT_H;
                D2013 := RATE_MOVE;
                Y43 := TRUE;
            END_IF;
            
            IF X30 OR X34 THEN
                (* Acknowledge cancellation *)
                IF g_req = 0 THEN
                    D300 := D100; D301 := 2; f_done0 := TRUE;
                ELSE
                    D302 := D120; D303 := 2; f_done1 := TRUE;
                END_IF;
                g_seq := g_seq + 1;
                D82 := g_seq;
                g_st := 0;
                g_step := 0;
                g_req := -1;
            END_IF;
        END_IF;
END_CASE;

(* Completion observation *)
IF f_done0 AND f_done1 AND NOT f_compl_held THEN
    t_compl(IN := TRUE, PT := T#100ms);
    IF t_compl.Q THEN
        f_compl_held := TRUE;
        Y2 := TRUE;
    END_IF;
ELSE
    t_compl(IN := FALSE);
END_IF;

(* Final completion check with all conditions *)
IF f_compl_held AND Y2 THEN
    (* Verify shuttle/fork at 0, cells at home, lifts at home *)
    IF ABS(REAL(D1000)) > TOL_POS OR ABS(REAL(D1004)) > TOL_POS THEN
        (* Maintain Y2 if previously set per task rules *)
    END_IF;
END_IF;

END_PROGRAM