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
    D1040 : DINT;
    D1041 : DINT;
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
    D503 : DINT;
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
    D2040 : DINT;
    D2041 : DINT;
    D2042 : DINT;
    Y50 : BOOL;
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
    (* Internal variables *)
    state : INT := 0;
    req_idx : INT := 0;
    req_id_val : DINT := 0;
    req_target : DINT := 0;
    seq_num : DINT := 1;
    done0 : BOOL := FALSE;
    done1 : BOOL := FALSE;
    cancel0 : BOOL := FALSE;
    cancel1 : BOOL := FALSE;
    home_ok : BOOL := FALSE;
    st_timer : TON;
    arr_timer : TON;
    obs_timer : TON;
    final_done : BOOL := FALSE;
END_VAR

(* Default outputs reset *)
D2000 := 0; D2001 := 500; D2002 := 0; Y40 := FALSE;
D2004 := 0; D2005 := 500; D2006 := 0; Y41 := FALSE;
D2008 := 0; D2009 := 500; D2010 := 0; Y42 := FALSE;
D2012 := 0; D2013 := 500; D2014 := 0; Y43 := FALSE;
D2016 := 0; D2017 := 500; D2018 := 0; Y44 := FALSE;
D2020 := 0; D2021 := 500; D2022 := 0; Y45 := FALSE;
D2024 := 0; D2025 := 500; D2026 := 0; Y46 := FALSE;
D2028 := 0; D2029 := 500; D2030 := 0; Y47 := FALSE;
D2032 := 0; D2033 := 500; D2034 := 0; Y48 := FALSE;
D2036 := 0; D2037 := 500; D2038 := 0; Y49 := FALSE;
D2040 := 0; D2041 := 500; D2042 := 0; Y50 := FALSE;
Y30 := FALSE; D80 := 0; D81 := 0; D82 := 0;
D300 := 0; D301 := 0; D302 := 0; D303 := 0;
Y2 := FALSE;
Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;

(* Safety: lift height difference <= 80mm (8000 in 0.01 units) *)
IF ABS(D1008 - D1012) > 8000 THEN
    Y42 := FALSE; Y43 := FALSE;
END_IF;

(* State machine *)
CASE state OF
    0: (* Home initialization *)
        D2000 := 0; Y40 := TRUE;
        D2004 := 0; Y41 := TRUE;
        D2008 := 40000; Y42 := TRUE;
        D2012 := 40000; Y43 := TRUE;
        D2016 := -6500; Y44 := TRUE;
        D2020 := 0; Y45 := TRUE;
        D2024 := 6500; Y46 := TRUE;
        D2028 := 0; Y47 := TRUE;
        D2032 := -6500; Y48 := TRUE;
        D2036 := 6500; Y49 := TRUE;
        D2040 := 0; Y50 := TRUE;
        
        home_ok := (ABS(D1000) < 200) AND (ABS(D1004) < 200) AND
                   (ABS(D1008 - 40000) < 200) AND (ABS(D1012 - 40000) < 200) AND
                   (ABS(D1016 + 6500) < 200) AND (ABS(D1020) < 200) AND
                   (ABS(D1024 - 6500) < 200) AND (ABS(D1028) < 200) AND
                   (ABS(D1032 + 6500) < 200) AND (ABS(D1036 - 6500) < 200) AND
                   (ABS(D1040) < 200);
        IF home_ok THEN
            state := 1;
        END_IF;
        
    1: (* Wait for request *)
        IF (D102 > 0) AND NOT done0 AND NOT cancel0 THEN
            req_idx := 0;
            req_id_val := D100;
            req_target := D101;
            state := 2;
        ELSIF (D122 > 0) AND NOT done1 AND NOT cancel1 THEN
            req_idx := 1;
            req_id_val := D120;
            req_target := D121;
            state := 2;
        END_IF;
        
    2: (* Approach source lift *)
        D80 := 1;
        IF req_idx = 0 THEN
            IF req_target = 1 THEN
                D2000 := -405000;
            ELSIF req_target = 2 THEN
                D2000 := -185000;
            END_IF;
        ELSE
            IF req_target = 1 THEN
                D2000 := -405000;
            ELSIF req_target = 2 THEN
                D2000 := -185000;
            END_IF;
        END_IF;
        Y40 := TRUE; Y41 := TRUE;
        
        st_timer(IN := (ABS(D1000 - D2000) < 2000), PT := T#30ms);
        IF st_timer.Q THEN
            state := 3;
        END_IF;
        
    3: (* Connect fork to 180mm *)
        D2004 := 18000;
        Y40 := TRUE; Y41 := TRUE;
        
        st_timer(IN := (ABS(D1004 - 18000) < 2000), PT := T#30ms);
        IF st_timer.Q THEN
            state := 4;
        END_IF;
        
    4: (* Lower lift *)
        IF req_idx = 0 THEN
            D2008 := 0;
            Y42 := TRUE;
            st_timer(IN := (ABS(D1008) < 2000), PT := T#30ms);
        ELSE
            D2012 := 0;
            Y43 := TRUE;
            st_timer(IN := (ABS(D1012) < 2000), PT := T#30ms);
        END_IF;
        Y40 := TRUE; Y41 := TRUE;
        IF st_timer.Q THEN
            state := 5;
        END_IF;
        
    5: (* Move to cell 3 or 4 *)
        IF req_target = 3 THEN
            D2000 := 0;
        ELSIF req_target = 4 THEN
            D2000 := 670000;
        END_IF;
        Y40 := TRUE; Y41 := TRUE;
        
        st_timer(IN := (ABS(D1000 - D2000) < 2000), PT := T#30ms);
        IF st_timer.Q THEN
            state := 6;
        END_IF;
        
    6: (* Cell operation *)
        Y40 := TRUE; Y41 := TRUE;
        IF req_target = 3 THEN
            D2016 := D500; D2020 := D501; D2024 := D502; D2028 := D503;
            Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE;
            Y70 := TRUE; D700 := req_id_val;
            
            IF X72 AND X70 THEN
                state := 7;
            END_IF;
        ELSIF req_target = 4 THEN
            D2032 := D600; D2036 := D601; D2040 := D602;
            Y48 := TRUE; Y49 := TRUE; Y50 := TRUE;
            Y75 := TRUE; D710 := req_id_val;
            
            IF X77 AND X75 THEN
                state := 7;
            END_IF;
        END_IF;
        
    7: (* Return to lift *)
        IF req_target = 1 THEN
            D2000 := -405000;
        ELSIF req_target = 2 THEN
            D2000 := -185000;
        END_IF;
        Y40 := TRUE; Y41 := TRUE;
        
        st_timer(IN := (ABS(D1000 - D2000) < 2000), PT := T#30ms);
        IF st_timer.Q THEN
            state := 8;
        END_IF;
        
    8: (* Raise lift *)
        IF req_idx = 0 THEN
            D2008 := 40000;
            Y42 := TRUE;
            st_timer(IN := (ABS(D1008 - 40000) < 2000), PT := T#30ms);
        ELSE
            D2012 := 40000;
            Y43 := TRUE;
            st_timer(IN := (ABS(D1012 - 40000) < 2000), PT := T#30ms);
        END_IF;
        Y40 := TRUE; Y41 := TRUE;
        IF st_timer.Q THEN
            state := 9;
        END_IF;
        
    9: (* Disconnect fork *)
        D2004 := 0;
        Y40 := TRUE; Y41 := TRUE;
        
        st_timer(IN := (ABS(D1004) < 2000), PT := T#30ms);
        IF st_timer.Q THEN
            state := 10;
        END_IF;
        
    10: (* Acknowledge completion *)
        Y40 := TRUE; Y41 := TRUE;
        D80 := 0;
        IF req_idx = 0 THEN
            D300 := req_id_val;
            D301 := 1;
            done0 := TRUE;
        ELSE
            D302 := req_id_val;
            D303 := 1;
            done1 := TRUE;
        END_IF;
        state := 11;
        
    11: (* Check for next request or prepare final *)
        IF NOT done0 AND (D102 > 0) THEN
            req_idx := 0; req_id_val := D100; req_target := D101;
            state := 2;
        ELSIF NOT done1 AND (D122 > 0) THEN
            req_idx := 1; req_id_val := D120; req_target := D121;
            state := 2;
        ELSE
            state := 12;
        END_IF;
        
    12: (* Return all to home positions *)
        D2000 := 0; Y40 := TRUE;
        D2004 := 0; Y41 := TRUE;
        D2008 := 40000; Y42 := TRUE;
        D2012 := 40000; Y43 := TRUE;
        D2016 := -6500; Y44 := TRUE;
        D2020 := 0; Y45 := TRUE;
        D2024 := 6500; Y46 := TRUE;
        D2028 := 0; Y47 := TRUE;
        D2032 := -6500; Y48 := TRUE;
        D2036 := 6500; Y49 := TRUE;
        D2040 := 0; Y50 := TRUE;
        
        home_ok := (ABS(D1000) < 200) AND (ABS(D1004) < 200) AND
                   (ABS(D1008 - 40000) < 200) AND (ABS(D1012 - 40000) < 200) AND
                   (ABS(D1016 + 6500) < 200) AND (ABS(D1020) < 200) AND
                   (ABS(D1024 - 6500) < 200) AND (ABS(D1028) < 200) AND
                   (ABS(D1032 + 6500) < 200) AND (ABS(D1036 - 6500) < 200) AND
                   (ABS(D1040) < 200);
        IF home_ok THEN
            state := 13;
        END_IF;
        
    13: (* Final completion with 100ms hold *)
        Y2 := TRUE;
        obs_timer(IN := TRUE, PT := T#100ms);
        IF obs_timer.Q THEN
            final_done := TRUE;
        END_IF;
END_CASE;

(* Cancellation handling *)
IF (X31 OR X35) AND state <> 13 THEN
    cancel0 := X31;
    cancel1 := X35;
    (* Retrieve and return logic would go here in full implementation *)
    state := 12;
END_IF;

END_PROGRAM