```iecst
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

    thetaA : REAL;
    thetaB : REAL;
    x_target_real : REAL;
    dyn_s3_2_target : DINT;
    
    state : DINT := 0;
    req_id : DINT := 0;
    req_idx : DINT := 0;
    pocket_sel : DINT := 0;
    
    a_target_val : DINT := 0;
    b_target_val : DINT := 0;
    c_target_val : DINT := 400;
    d_target_val : DINT := 400;
    s3_0_target_val : DINT := 0;
    s3_1_target_val : DINT := 0;
    s4_0_target_val : DINT := 0;
    s4_1_target_val : DINT := 0;
    s4_2_target_val : DINT := 0;
END_VAR

    thetaA := REAL(D1016) * 0.00017453292;
    thetaB := REAL(D1020) * 0.00017453292;
    x_target_real := -225.0 * (SIN(thetaA) + SIN(thetaB));
    dyn_s3_2_target := DINT(ROUND(x_target_real * 100.0));

    CASE state OF
        0: 
            a_target_val := 0;
            b_target_val := 0;
            c_target_val := 400;
            d_target_val := 400;
            s3_0_target_val := 0;
            s3_1_target_val := 0;
            s4_0_target_val := 0;
            s4_1_target_val := 0;
            s4_2_target_val := 0;

            IF X51 THEN
                IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND ABS(D1008 - 400) <= 20 AND ABS(D1012 - 400) <= 20 AND
                   ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 AND
                   ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND ABS(D1036) <= 20 THEN
                    Y2 := TRUE;
                ELSE
                    Y2 := FALSE;
                END_IF;
            ELSE
                Y2 := FALSE;
                IF D100 > 0 AND NOT X30 THEN
                    req_id := D100;
                    req_idx := 0;
                    state := 1;
                ELSIF D120 > 0 AND NOT X34 THEN
                    req_id := D120;
                    req_idx := 1;
                    state := 1;
                END_IF;
            END_IF;

        1: 
            c_target_val := 95000;
            d_target_val := 95000;
            IF ABS(D1008 - 95000) <= 20 AND ABS(D1012 - 95000) <= 20 THEN
                state := 2;
            END_IF;

        2: 
            c_target_val := 95000;
            d_target_val := 95000;
            IF (req_idx = 0 AND X31) OR (req_idx = 1 AND X35) THEN
                state := 20;
            ELSE
                state := 3;
            END_IF;

        3: 
            c_target_val := 95000;
            d_target_val := 95000;
            b_target_val := 0;
            IF req_idx = 0 THEN a_target_val := D403; ELSE a_target_val := D406; END_IF;
            IF ABS(D1000 - a_target_val) <= 20 THEN
                state := 4;
            END_IF;

        4: 
            c_target_val := 95000;
            d_target_val := 95000;
            IF req_idx = 0 THEN a_target_val := D403; ELSE a_target_val := D406; END_IF;
            b_target_val := 18000;
            IF ABS(D1004 - 18000) <= 20 THEN
                state := 5;
            END_IF;

        5: 
            c_target_val := 95000;
            d_target_val := 95000;
            IF req_idx = 0 THEN a_target_val := D403; ELSE a_target_val := D406; END_IF;
            b_target_val := 18000;
            D80 := 1;
            IF req_idx = 0 THEN D81 := 1; ELSE D81 := 2; END_IF;
            D82 := D82 + 1;
            state := 6;

        6: 
            c_target_val := 95000;
            d_target_val := 95000;
            IF req_idx = 0 THEN a_target_val := D403; ELSE a_target_val := D406; END_IF;
            b_target_val := 18000;
            IF D90 = req_id THEN
                state := 7;
            END_IF;

        7: 
            c_target_val := 95000;
            d_target_val := 95000;
            IF req_idx = 0 THEN a_target_val := D403; ELSE a_target_val := D406; END_IF;
            b_target_val := 0;
            IF ABS(D1004) <= 20 THEN
                state := 8;
            END_IF;

        8: 
            c_target_val := 95000;
            d_target_val := 95000;
            b_target_val := 0;
            IF (req_idx = 0 AND X31) OR (req_idx = 1 AND X35) THEN
                state := 18;
            ELSE
                state := 9;
            END_IF;

        9: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 0;
            b_target_val := 0;
            IF ABS(D1000) <= 20 THEN
                state := 10;
            END_IF;

        10: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 0;
            b_target_val := 18000;
            IF ABS(D1004 - 18000) <= 20 THEN
                state := 11;
            END_IF;

        11: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 0;
            b_target_val := 18000;
            D80 := 2;
            D81 := 3;
            D82 := D82 + 1;
            state := 12;

        12: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 0;
            b_target_val := 18000;
            IF D90 = 0 THEN
                state := 13;
            END_IF;

        13: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 0;
            b_target_val := 0;
            IF ABS(D1004) <= 20 THEN
                state := 14;
            END_IF;

        14: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 0;
            b_target_val := 0;
            s3_0_target_val := D500;
            s3_1_target_val := D501;
            IF X70 THEN
                IF (D1016 + D1020) < 0 THEN 
                    pocket_sel := 1; 
                ELSE 
                    pocket_sel := 2; 
                END_IF;
                state := 15;
            ELSIF (req_idx = 0 AND X31) OR (req_idx = 1 AND X35) THEN
                state := 15;
            END_IF;

        15: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 0;
            b_target_val := 0;
            s3_0_target_val := 0;
            s3_1_target_val := 0;
            IF ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 THEN
                state := 16;
            END_IF;

        16: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 0;
            b_target_val := 18000;
            IF ABS(D1004 - 18000) <= 20 THEN
                D80 := 1;
                D81 := 3;
                D82 := D82 + 1;
                state := 17;
            END_IF;

        17: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 0;
            b_target_val := 18000;
            IF D90 = req_id THEN
                state := 171;
            END_IF;

        171: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 0;
            b_target_val := 0;
            IF ABS(D1004) <= 20 THEN
                IF (req_idx = 0 AND X31) OR (req_idx = 1 AND X35) THEN
                    state := 18;
                ELSE
                    state := 172;
                END_IF;
            END_IF;

        172: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 375000;
            b_target_val := 0;
            IF ABS(D1000 - 375000) <= 20 THEN
                state := 1721;
            END_IF;

        1721: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 375000;
            b_target_val := 18000;
            IF ABS(D1004 - 18000) <= 20 THEN
                D80 := 2;
                D81 := 4;
                D82 := D82 + 1;
                state := 173;
            END_IF;

        173: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 375000;
            b_target_val := 18000;
            IF D90 = 0 THEN
                state := 174;
            END_IF;

        174: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 375000;
            b_target_val := 0;
            IF ABS(D1004) <= 20 THEN
                state := 175;
            END_IF;

        175: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 375000;
            b_target_val := 0;
            IF pocket_sel = 1 THEN 
                s4_1_target_val := D601; 
            ELSE 
                s4_2_target_val := D602; 
            END_IF;
            
            IF X75 THEN
                state := 176;
            ELSIF (req_idx = 0 AND X31) OR (req_idx = 1 AND X35) THEN
                state := 176;
            END_IF;

        176: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 375000;
            b_target_val := 0;
            s4_1_target_val := 0;
            s4_2_target_val := 0;
            IF ABS(D1032) <= 20 AND ABS(D1036) <= 20 THEN
                state := 177;
            END_IF;

        177: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 375000;
            b_target_val := 18000;
            IF ABS(D1004 - 18000) <= 20 THEN
                D80 := 1;
                D81 := 4;
                D82 := D82 + 1;
                state := 178;
            END_IF;

        178: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 375000;
            b_target_val := 18000;
            IF D90 = req_id THEN
                state := 179;
            END_IF;

        179: 
            c_target_val := 95000;
            d_target_val := 95000;
            a_target_val := 375000;
            b_target_val := 0;
            IF ABS(D1004) <= 20 THEN
                state := 18;
            END_IF;

        18: 
            c_target_val := 95000;
            d_target_val := 95000;
            IF req_idx = 0 THEN a_target_val := D403; ELSE a_target_val := D406; END_IF;
            b_target_val := 0;
            IF ABS(D1000 - a_target_val) <= 20 THEN
                state := 181;
            END_IF;

        181: 
            c_target_val := 95000;
            d_target_val := 95000;
            IF req_idx = 0 THEN a_target_val := D403; ELSE a_target_val := D406; END_IF;
            b_target_val := 18000;
            IF ABS(D1004 - 18000) <= 20 THEN
                D80 := 2;
                IF req_idx = 0 THEN D81 := 1; ELSE D81 := 2; END_IF;
                D82 := D82 + 1;
                state := 19;
            END_IF;

        19: 
            c_target_val := 95000;
            d_target_val := 95000;
            IF req_idx = 0 THEN a_target_val := D403; ELSE a_target_val := D406; END_IF;
            b_target_val := 18000;
            IF D90 = 0 THEN
                state := 191;
            END_IF;

        191: 
            c_target_val := 95000;
            d_target_val := 95000;
            IF req_idx = 0 THEN a_target_val := D403; ELSE a_target_val := D406; END_IF;
            b_target_val := 0;
            IF ABS(D1004) <= 20 THEN
                state := 20;
            END_IF;

        20: 
            c_target_val := 400;
            d_target_val := 400;
            IF ABS(D1008 - 400) <= 20 AND ABS(D1012 - 400) <= 20 THEN
                IF req_idx = 0 THEN
                    D300 := req_id;
                    IF X31 THEN D301 := 2; ELSE D301 := 1; END_IF;
                ELSE
                    D302 := req_id;
                    IF X35 THEN D303 := 2; ELSE D303 := 1; END_IF;
                END_IF;
                state := 21;
            END_IF;

        21: 
            c_target_val := 400;
            d_target_val := 400;
            IF (req_idx = 0 AND X30) OR (req_idx = 1 AND X34) THEN
                IF req_idx = 0 THEN 
                    D300 := 0; 
                    D301 := 0; 
                ELSE 
                    D302 := 0; 
                    D303 := 0; 
                END_IF;
                state := 0;
            END_IF;
    END_CASE;

    IF state >= 14 AND state <= 16 THEN
        Y70 := TRUE; 
        Y71 := TRUE; 
        D700 := req_id;
    ELSE
        Y70 := FALSE; 
        Y71 := FALSE; 
        D700 := 0;
    END_IF;

    IF state >= 175 AND state <= 177 THEN
        Y75 := TRUE; 
        Y76 := TRUE; 
        D710 := req_id;
    ELSE
        Y75 := FALSE; 
        Y76 := FALSE; 
        D710 := 0;
    END_IF;

    Y30 := FALSE;

    D2000 := a_target_val; D2001 := 1000; D2002 := 0; Y40 := TRUE;
    D2004 := b_target_val; D2005 := 1000; D2006 := 0; Y41 := TRUE;
    D2008 := c_target_val; D2009 := 1000; D2010 := 0; Y42 := TRUE;
    D2012 := d_target_val; D2013 := 1000; D2014 := 0; Y43 := TRUE;

    D2016 := s3_0_target_val; D2017 := 1000; D2018 := 0; Y44 := TRUE;
    D2020 := s3_1_target_val; D2021 := 1000; D2022 := 0; Y45 := TRUE;
    D2024 := dyn_s3_2_target; D2025 := 1000; D2026 := 0; Y46 := TRUE;

    D2028 := s4_0_target_val; D2029 := 1000; D2030 := 0; Y47 := TRUE;
    D2032 := s4_1_target_val; D2033 := 1000; D2034 := 0; Y48 := TRUE;
    D2036 := s4_2_target_val; D2037 := 1000; D2038 := 0; Y49 := TRUE;

END_PROGRAM
```