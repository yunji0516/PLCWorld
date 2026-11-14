PROGRAM Main
VAR
    D1000 : DINT; D1001 : DINT; D1004 : DINT; D1005 : DINT; D1008 : DINT; D1009 : DINT; D1012 : DINT; D1013 : DINT;
    D1016 : DINT; D1017 : DINT; D1020 : DINT; D1021 : DINT; D1024 : DINT; D1025 : DINT; D1028 : DINT; D1029 : DINT;
    D1032 : DINT; D1033 : DINT; D1036 : DINT; D1037 : DINT;
    D100 : DINT; D101 : DINT; D102 : DINT; D103 : DINT; D104 : DINT; X30 : BOOL; X31 : BOOL;
    D120 : DINT; D121 : DINT; D122 : DINT; D123 : DINT; D124 : DINT; X34 : BOOL; X35 : BOOL;
    X51 : BOOL; D90 : DINT; D91 : DINT; D92 : DINT; X52 : BOOL; X53 : BOOL;
    D403 : DINT; D404 : DINT; X61 : BOOL; D406 : DINT; D407 : DINT; X62 : BOOL;
    D409 : DINT; D410 : DINT; X63 : BOOL; D412 : DINT; D413 : DINT; X64 : BOOL;
    D500 : DINT; D501 : DINT; D520 : DINT; D521 : DINT; D522 : DINT; D523 : DINT; D524 : DINT;
    D525 : DINT; D526 : DINT; D527 : DINT; X70 : BOOL; X71 : BOOL; X72 : BOOL;
    D600 : DINT; D601 : DINT; D602 : DINT; D603 : DINT; D620 : DINT; D621 : DINT; D622 : DINT;
    D623 : DINT; D624 : DINT; D625 : DINT; D626 : DINT; D627 : DINT; X75 : BOOL; X76 : BOOL; X77 : BOOL;
    D2000 : DINT; D2001 : DINT; D2002 : DINT; Y40 : BOOL; D2004 : DINT; D2005 : DINT; D2006 : DINT; Y41 : BOOL;
    D2008 : DINT; D2009 : DINT; D2010 : DINT; Y42 : BOOL; D2012 : DINT; D2013 : DINT; D2014 : DINT; Y43 : BOOL;
    D2016 : DINT; D2017 : DINT; D2018 : DINT; Y44 : BOOL; D2020 : DINT; D2021 : DINT; D2022 : DINT; Y45 : BOOL;
    D2024 : DINT; D2025 : DINT; D2026 : DINT; Y46 : BOOL; D2028 : DINT; D2029 : DINT; D2030 : DINT; Y47 : BOOL;
    D2032 : DINT; D2033 : DINT; D2034 : DINT; Y48 : BOOL; D2036 : DINT; D2037 : DINT; D2038 : DINT; Y49 : BOOL;
    D300 : DINT; D301 : DINT; D302 : DINT; D303 : DINT; Y70 : BOOL; Y71 : BOOL; D700 : DINT; D701 : DINT; D702 : DINT;
    Y75 : BOOL; Y76 : BOOL; D710 : DINT; D711 : DINT; D712 : DINT; D80 : DINT; D81 : DINT; D82 : DINT; Y30 : BOOL; Y2 : BOOL;
    
    st : INT := 0;
    cur_req : INT := 0;
    station_val : DINT := 0;
    t_a : DINT := 0; t_b : DINT := 0; t_c : DINT := 0; t_d : DINT := 0;
    t_s30 : DINT := 0; t_s31 : DINT := 0; t_s40 : DINT := 0; t_s41 : DINT := 0; t_s42 : DINT := 0; t_s43 : DINT := 0;
    ack0_v : DINT := 0; sta0_v : DINT := 0;
    ack1_v : DINT := 0; sta1_v : DINT := 0;
    h_done0 : BOOL := FALSE; h_done1 : BOOL := FALSE;
    seq_ctr : DINT := 1;
    t_obs : TON;
    final_obs : BOOL := FALSE;
    step_timer : TON;
END_VAR

CASE st OF
    0: (* Initial Home Check *)
        t_a := 0; t_b := 0; t_c := 15000; t_d := 15000;
        t_s30 := 0; t_s31 := 5000; t_s40 := -6500; t_s41 := 0; t_s42 := 6500; t_s43 := 0;
        Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
        Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE; Y49 := TRUE;
        D82 := 1;
        step_timer(IN := FALSE, PT := T#200ms);
        IF (D1000 = 0) AND (D1004 = 0) AND (D1008 = 15000) AND (D1012 = 15000) AND
           (D1016 = 0) AND (D1020 = 5000) AND (D1024 = -6500) AND (D1028 = 0) AND
           (D1032 = 6500) AND (D1036 = 0) THEN
            st := 10;
        END_IF;

    10: (* Determine Request *)
        IF h_done0 AND h_done1 THEN
            st := 100;
        ELSIF NOT h_done0 THEN
            cur_req := 0;
            station_val := D101;
            IF X31 THEN ack0_v := D100; sta0_v := 2; ELSIF X30 THEN ack0_v := D100; sta0_v := 1; END_IF;
            st := 20;
        ELSIF NOT h_done1 THEN
            cur_req := 1;
            station_val := D121;
            IF X35 THEN ack1_v := D120; sta1_v := 2; ELSIF X34 THEN ack1_v := D120; sta1_v := 1; END_IF;
            st := 20;
        END_IF;
        D82 := seq_ctr;

    20: (* Move Shuttle to Station *)
        D81 := station_val;
        D80 := 1;
        CASE station_val OF
            1: t_a := -360000;
            2: t_a := -230000;
            3: t_a := 0;
            4: t_a := 670000;
        ELSE: t_a := 0;
        END_CASE;
        Y40 := TRUE;
        step_timer(IN := TRUE, PT := T#20ms);
        IF step_timer.Q AND (ABS(D1000 - t_a) <= 200) THEN
            step_timer(IN := FALSE, PT := T#20ms);
            st := 30;
        END_IF;

    30: (* Connect Fork *)
        t_b := 18000;
        Y41 := TRUE;
        D80 := 1;
        seq_ctr := seq_ctr + 1;
        D82 := seq_ctr;
        step_timer(IN := TRUE, PT := T#20ms);
        IF step_timer.Q AND (ABS(D1004 - t_b) <= 200) THEN
            step_timer(IN := FALSE, PT := T#20ms);
            st := 40;
        END_IF;

    40: (* Move Lifts / Operate Cells *)
        CASE station_val OF
            1: 
                t_c := D92; Y42 := TRUE;
                IF ABS(D1008 - t_c) <= 200 THEN st := 50; END_IF;
            2:
                t_d := D92; Y43 := TRUE;
                IF ABS(D1012 - t_d) <= 200 THEN st := 50; END_IF;
            3:
                Y70 := TRUE; D700 := 1; D701 := 1; D702 := 600000;
                Y44 := TRUE; Y45 := TRUE;
                t_s31 := 50000;
                IF ABS(D1020 - t_s31) <= 200 THEN
                    t_s30 := D527;
                    IF ABS(D1016 - t_s30) <= 200 THEN
                        t_s31 := 70000;
                        IF ABS(D1020 - t_s31) <= 200 THEN st := 50; END_IF;
                    END_IF;
                END_IF;
            4:
                Y75 := TRUE; D710 := 1; D711 := 1; D712 := 600000;
                Y46 := TRUE; Y47 := TRUE; Y48 := TRUE; Y49 := TRUE;
                t_s41 := 8000; t_s43 := 8000;
                IF ABS(D1028 - t_s41) <= 200 AND ABS(D1036 - t_s43) <= 200 THEN
                    t_s40 := D627; t_s42 := D627;
                    IF ABS(D1024 - t_s40) <= 200 AND ABS(D1032 - t_s42) <= 200 THEN st := 50; END_IF;
                END_IF;
        ELSE
            st := 50;
        END_CASE;

    50: (* Return from Cell/Lift *)
        CASE station_val OF
            1: t_c := 15000; Y42 := TRUE;
               IF ABS(D1008 - t_c) <= 200 THEN st := 60; END_IF;
            2: t_d := 15000; Y43 := TRUE;
               IF ABS(D1012 - t_d) <= 200 THEN st := 60; END_IF;
            3: 
               t_s31 := 50000;
               IF ABS(D1020 - t_s31) <= 200 THEN
                   t_s30 := 0;
                   IF ABS(D1016 - t_s30) <= 200 THEN
                       t_s31 := 5000;
                       IF ABS(D1020 - t_s31) <= 200 THEN st := 60; END_IF;
                   END_IF;
               END_IF;
            4:
               t_s40 := -6500; t_s42 := 6500;
               IF ABS(D1024 - t_s40) <= 200 AND ABS(D1032 - t_s42) <= 200 THEN
                   t_s41 := 0; t_s43 := 0;
                   IF ABS(D1028 - t_s41) <= 200 AND ABS(D1036 - t_s43) <= 200 THEN st := 60; END_IF;
               END_IF;
        ELSE
            st := 60;
        END_CASE;

    60: (* Disconnect Fork & Return Shuttle *)
        t_b := 0;
        Y41 := TRUE;
        D80 := 0;
        IF ABS(D1004 - t_b) <= 200 THEN
            t_a := 0;
            Y40 := TRUE;
            IF ABS(D1000 - t_a) <= 200 THEN
                st := 70;
            END_IF;
        END_IF;

    70: (* Acknowledge & Advance *)
        D300 := ack0_v; D301 := sta0_v;
        D302 := ack1_v; D303 := sta1_v;
        IF cur_req = 0 THEN h_done0 := TRUE; ELSIF cur_req = 1 THEN h_done1 := TRUE; END_IF;
        st := 10;

    100: (* Final Completion Check *)
        Y2 := FALSE;
        t_obs(IN := FALSE, PT := T#100ms);
        IF (D1000 = 0) AND (D1004 = 0) AND (D1008 = 15000) AND (D1012 = 15000) AND
           (D1016 = 0) AND (D1020 = 5000) AND (D1024 = -6500) AND (D1028 = 0) AND
           (D1032 = 6500) AND (D1036 = 0) THEN
            t_obs(IN := TRUE, PT := T#100ms);
            IF t_obs.Q THEN Y2 := TRUE; final_obs := TRUE; END_IF;
        END_IF;
        D300 := ack0_v; D301 := sta0_v;
        D302 := ack1_v; D303 := sta1_v;
        IF final_obs AND X51 THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

D2000 := t_a; D2001 := 500; D2002 := 0;
D2004 := t_b; D2005 := 500; D2006 := 0;
D2008 := t_c; D2009 := 500; D2010 := 0;
D2012 := t_d; D2013 := 500; D2014 := 0;
D2016 := t_s30; D2017 := 500; D2018 := 0;
D2020 := t_s31; D2021 := 500; D2022 := 0;
D2024 := t_s40; D2025 := 500; D2026 := 0;
D2028 := t_s41; D2029 := 500; D2030 := 0;
D2032 := t_s42; D2033 := 500; D2034 := 0;
D2036 := t_s43; D2037 := 500; D2038 := 0;

Y70 := (st >= 20) AND (st < 50) AND (station_val = 3);
Y71 := (station_val = 3);
D700 := 1; D701 := 1; D702 := 600000;
Y75 := (st >= 20) AND (st < 50) AND (station_val = 4);
Y76 := (station_val = 4);
D710 := 1; D711 := 1; D712 := 600000;

Y30 := (st = 0) OR (st = 100 AND final_obs);

END_PROGRAM