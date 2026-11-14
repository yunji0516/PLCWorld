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

    init : BOOL := FALSE;
    State : INT := 0;
    active_req : INT := -1;
    req_id : DINT := 0;
    port : DINT := 0;
    seq : DINT := 0;
    cancel_flag : BOOL := FALSE;
    jig_pos : INT := 0; 
    captured_val : DINT := 0;
    lift_port_x : DINT := 0;

    t_a : DINT := 0;
    t_b : DINT := 0;
    t_c : DINT := 15000;
    t_d : DINT := 15000;
    t_s3_0 : DINT := -60000;
    t_s3_1 : DINT := -60000;
    t_s4_0 : DINT := -60000;
    t_s4_1 : DINT := -60000;
END_VAR

IF NOT init THEN
    init := TRUE;
    t_a := D1000;
    t_b := D1004;
    t_c := D1008;
    t_d := D1012;
    t_s3_0 := D1016;
    t_s3_1 := D1020;
    t_s4_0 := D1024;
    t_s4_1 := D1028;
    seq := 1;
    Y30 := TRUE;
    D702 := 0;
    D712 := 0;
END_IF;

IF Y30 THEN
    t_c := D1008;
    t_d := D1012;
END_IF;

IF active_req = 0 AND X31 THEN cancel_flag := TRUE; END_IF;
IF active_req = 1 AND X35 THEN cancel_flag := TRUE; END_IF;

IF cancel_flag THEN
    IF State = 100 OR State = 110 THEN State := 430; END_IF;
    IF State = 150 OR State = 270 THEN State := 390; END_IF;
    IF State >= 190 AND State <= 210 THEN State := 220; END_IF;
    IF State >= 310 AND State <= 330 THEN State := 340; END_IF;
END_IF;

IF port = 1 THEN 
    lift_port_x := D403;
ELSE 
    lift_port_x := D406;
END_IF;

CASE State OF
    0:
        IF X51 THEN
            State := 500;
        ELSIF D100 > 0 AND D300 <> D100 AND NOT X30 AND NOT X31 THEN
            active_req := 0; req_id := D100; port := D101; cancel_flag := FALSE; jig_pos := 0; State := 100;
        ELSIF D120 > 0 AND D302 <> D120 AND NOT X34 AND NOT X35 THEN
            active_req := 1; req_id := D120; port := D121; cancel_flag := FALSE; jig_pos := 0; State := 100;
        ELSIF D100 > 0 AND X31 AND D300 <> D100 AND NOT X30 THEN
            active_req := 0; req_id := D100; port := D101; cancel_flag := TRUE; jig_pos := 0; State := 430;
        ELSIF D120 > 0 AND X35 AND D302 <> D120 AND NOT X34 THEN
            active_req := 1; req_id := D120; port := D121; cancel_flag := TRUE; jig_pos := 0; State := 430;
        END_IF;

    100:
        t_c := 73250; t_d := 73250;
        IF ABS(D1008 - 73250) <= 20 AND ABS(D1012 - 73250) <= 20 THEN
            State := 105;
        ELSE
            Y30 := FALSE;
        END_IF;

    105:
        Y30 := TRUE;
        IF X52 THEN State := 110; END_IF;

    110:
        t_a := lift_port_x;
        IF ABS(D1000 - t_a) <= 20 AND ABS(D1001) <= 100 THEN State := 120; END_IF;

    120:
        t_b := 18000;
        IF D1004 >= 17980 AND ABS(D1005) <= 100 THEN 
            seq := seq + 1; 
            State := 130; 
        END_IF;

    130:
        D80 := 1; D81 := port; D82 := seq;
        IF D90 = req_id THEN 
            jig_pos := 1; 
            State := 140; 
        END_IF;

    140:
        t_b := 0;
        IF D1004 <= 20 AND ABS(D1005) <= 100 THEN State := 150; END_IF;

    150:
        t_a := D409;
        IF ABS(D1000 - t_a) <= 20 AND ABS(D1001) <= 100 THEN State := 160; END_IF;

    160:
        t_b := 18000;
        IF D1004 >= 17980 AND ABS(D1005) <= 100 THEN 
            seq := seq + 1; 
            State := 170; 
        END_IF;

    170:
        D80 := 2; D81 := 3; D82 := seq;
        IF D90 = 0 THEN 
            jig_pos := 3; 
            State := 180; 
        END_IF;

    180:
        t_b := 0;
        IF D1004 <= 20 AND ABS(D1005) <= 100 THEN State := 190; END_IF;

    190:
        IF ABS(D1017) <= 100 AND ABS(D1021) <= 100 THEN
            Y70 := TRUE;
            State := 195;
        END_IF;

    195:
        Y70 := FALSE;
        State := 200;

    200:
        D700 := req_id;
        D701 := D526;
        t_s3_0 := D500;
        t_s3_1 := D501;
        IF ABS(D1016 - D500) <= 20 AND ABS(D1020 - D501) <= 20 THEN
            State := 210;
        END_IF;

    210:
        IF X70 THEN
            Y71 := TRUE;
            State := 220;
        END_IF;

    220:
        t_s3_0 := -60000;
        t_s3_1 := -60000;
        IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1020 - (-60000)) <= 20 THEN
            State := 230;
        END_IF;

    230:
        t_a := D409;
        IF ABS(D1000 - t_a) <= 20 AND ABS(D1001) <= 100 THEN State := 240; END_IF;

    240:
        t_b := 18000;
        IF D1004 >= 17980 AND ABS(D1005) <= 100 THEN 
            seq := seq + 1; 
            State := 250; 
        END_IF;

    250:
        D80 := 1; D81 := 3; D82 := seq;
        IF D90 = req_id THEN 
            jig_pos := 1; 
            State := 260; 
        END_IF;

    260:
        t_b := 0;
        IF D1004 <= 20 AND ABS(D1005) <= 100 THEN State := 270; END_IF;

    270:
        t_a := D412;
        IF ABS(D1000 - t_a) <= 20 AND ABS(D1001) <= 100 THEN State := 280; END_IF;

    280:
        t_b := 18000;
        IF D1004 >= 17980 AND ABS(D1005) <= 100 THEN 
            seq := seq + 1; 
            State := 290; 
        END_IF;

    290:
        D80 := 2; D81 := 4; D82 := seq;
        IF D90 = 0 THEN 
            jig_pos := 4; 
            State := 300; 
        END_IF;

    300:
        t_b := 0;
        IF D1004 <= 20 AND ABS(D1005) <= 100 THEN State := 310; END_IF;

    310:
        D710 := req_id;
        IF D620 = 0 THEN 
            t_s4_0 := 95000; t_s4_1 := -60000; 
        ELSE 
            t_s4_1 := 95000; t_s4_0 := -60000; 
        END_IF;
        IF D622 = req_id AND D624 = D91 THEN
            captured_val := D623;
            State := 320;
        END_IF;

    320:
        IF D624 <> D91 THEN
            State := 310;
        ELSE
            IF D620 = 0 THEN 
                t_s4_0 := captured_val + 25000; t_s4_1 := -60000;
            ELSE 
                t_s4_1 := captured_val + 25000; t_s4_0 := -60000; 
            END_IF;
            IF (D620 = 0 AND ABS(D1024 - (captured_val + 25000)) <= 20) OR
               (D620 = 1 AND ABS(D1028 - (captured_val + 25000)) <= 20) THEN
                State := 330;
            END_IF;
        END_IF;

    330:
        IF D624 <> D91 THEN
            Y76 := FALSE;
            State := 310;
        ELSIF X75 THEN
            Y76 := TRUE;
            State := 340;
        END_IF;

    340:
        t_s4_0 := -60000;
        t_s4_1 := -60000;
        IF ABS(D1024 - (-60000)) <= 20 AND ABS(D1028 - (-60000)) <= 20 THEN
            State := 350;
        END_IF;

    350:
        t_a := D412;
        IF ABS(D1000 - t_a) <= 20 AND ABS(D1001) <= 100 THEN State := 360; END_IF;

    360:
        t_b := 18000;
        IF D1004 >= 17980 AND ABS(D1005) <= 100 THEN 
            seq := seq + 1; 
            State := 370; 
        END_IF;

    370:
        D80 := 1; D81 := 4; D82 := seq;
        IF D90 = req_id THEN 
            jig_pos := 1; 
            State := 380; 
        END_IF;

    380:
        t_b := 0;
        IF D1004 <= 20 AND ABS(D1005) <= 100 THEN State := 390; END_IF;

    390:
        t_a := lift_port_x;
        IF ABS(D1000 - t_a) <= 20 AND ABS(D1001) <= 100 THEN State := 400; END_IF;

    400:
        t_b := 18000;
        IF D1004 >= 17980 AND ABS(D1005) <= 100 THEN 
            seq := seq + 1; 
            State := 410; 
        END_IF;

    410:
        D80 := 2; D81 := port; D82 := seq;
        IF D90 = 0 THEN 
            jig_pos := 0; 
            State := 420; 
        END_IF;

    420:
        t_b := 0;
        IF D1004 <= 20 AND ABS(D1005) <= 100 THEN State := 430; END_IF;

    430:
        t_c := 15000; t_d := 15000;
        IF ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20 THEN
            State := 435;
        ELSE
            Y30 := FALSE;
        END_IF;

    435:
        Y30 := TRUE;
        IF X52 THEN State := 440; END_IF;

    440:
        IF active_req = 0 THEN
            D300 := req_id;
            IF cancel_flag THEN D301 := 2; ELSE D301 := 1; END_IF;
        ELSE
            D302 := req_id;
            IF cancel_flag THEN D303 := 2; ELSE D303 := 1; END_IF;
        END_IF;
        State := 450;

    450:
        IF (active_req = 0 AND X30) OR (active_req = 1 AND X34) THEN
            Y71 := FALSE; Y76 := FALSE;
            active_req := -1;
            State := 0;
        END_IF;

    500:
        t_a := 0; t_b := 0;
        t_s3_0 := -60000; t_s3_1 := -60000;
        t_s4_0 := -60000; t_s4_1 := -60000;
        t_c := 15000; t_d := 15000;
        IF ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20 THEN
            Y30 := TRUE;
            IF X52 AND ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND 
               ABS(D1016 - (-60000)) <= 20 AND ABS(D1020 - (-60000)) <= 20 AND 
               ABS(D1024 - (-60000)) <= 20 AND ABS(D1028 - (-60000)) <= 20 THEN
                Y2 := TRUE;
            ELSE
                Y2 := FALSE;
            END_IF;
        ELSE
            Y30 := FALSE;
            Y2 := FALSE;
        END_IF;
END_CASE;

D2000 := t_a;
D2004 := t_b;
D2008 := t_c;
D2012 := t_d;
D2016 := t_s3_0;
D2020 := t_s3_1;
D2024 := t_s4_0;
D2028 := t_s4_1;

Y40 := TRUE;
Y41 := TRUE;
IF Y30 THEN
    Y42 := FALSE;
    Y43 := FALSE;
ELSE
    Y42 := TRUE;
    Y43 := TRUE;
END_IF;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;

D2001 := 1000;
D2005 := 1000;
D2009 := SEL(Y30, 1000, 0);
D2013 := SEL(Y30, 1000, 0);
D2017 := 1000;
D2021 := 1000;
D2025 := 1000;
D2029 := 1000;

D2002 := 0;
D2006 := 0;
D2010 := 0;
D2014 := 0;
D2018 := 0;
D2022 := 0;
D2026 := 0;
D2030 := 0;

END_PROGRAM