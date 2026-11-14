PROGRAM Main
VAR
    main_state : INT := 0;
    curr_req : INT := 0;
    curr_id : DINT := 0;
    curr_port : INT := 1;
    is_cancelling : BOOL := FALSE;
    last_req0_id : DINT := 0;
    last_req1_id : DINT := 0;
    seq : DINT := 1;
    
    a_target : DINT := 0;
    b_target : DINT := 0;
    c_target : DINT := 15000;
    d_target : DINT := 15000;
    
    m4_targ_x : DINT := 100000;
    m4_targ_l : DINT := 0;
    
    real_s3_0 : REAL;
    real_err_m : REAL;
    real_vel_m : REAL;
    real_theta : REAL;
    real_w : REAL;
    real_a_SI : REAL;
    real_a_out : REAL;
END_VAR

Y40 := TRUE; D2001 := 1000;
Y41 := TRUE; D2005 := 1000;
Y42 := TRUE; D2009 := 1000;
Y43 := TRUE; D2013 := 1000;
Y44 := TRUE; D2017 := 1000;
Y45 := TRUE; D2021 := 1000;
Y46 := TRUE; D2025 := 1000;
Y47 := TRUE; D2029 := 1000;
Y48 := TRUE; D2033 := 1000;
D2032 := 0;

IF curr_req = 0 AND X31 THEN is_cancelling := TRUE; END_IF;
IF curr_req = 1 AND X35 THEN is_cancelling := TRUE; END_IF;

IF is_cancelling THEN
    IF main_state >= 20 AND main_state <= 22 THEN
        main_state := 80;
    ELSIF main_state = 30 THEN
        main_state := 31;
    ELSIF main_state = 50 THEN
        main_state := 80;
    ELSIF main_state >= 51 AND main_state <= 60 THEN
        main_state := 61;
    END_IF;
END_IF;

CASE main_state OF
    0:
        a_target := 0; b_target := 0; c_target := 15000; d_target := 15000;
        IF D100 > 0 AND D100 <> last_req0_id AND NOT X30 THEN
            curr_req := 0; curr_id := D100; curr_port := 1;
            is_cancelling := FALSE; main_state := 10;
        ELSIF D120 > 0 AND D120 <> last_req1_id AND NOT X34 THEN
            curr_req := 1; curr_id := D120; curr_port := 2;
            is_cancelling := FALSE; main_state := 10;
        ELSIF X51 THEN
            main_state := 99;
        END_IF;

    10:
        c_target := SEL(curr_port = 1, 15000, D92);
        d_target := SEL(curr_port = 2, 15000, D92);
        IF (curr_port = 1 AND ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100) OR
           (curr_port = 2 AND ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100) THEN
            main_state := 11;
        END_IF;

    11:
        a_target := SEL(curr_port = 1, D406, D403);
        b_target := 18000;
        IF ABS(D1000 - a_target) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 1; D81 := curr_port; D82 := seq;
            main_state := 12;
        END_IF;

    12:
        IF D90 = curr_id THEN
            seq := seq + 1; main_state := 13;
        END_IF;

    13:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            main_state := 20;
        END_IF;

    20:
        IF is_cancelling THEN
            main_state := 80;
        ELSE
            main_state := 201;
        END_IF;

    201:
        a_target := D409; b_target := 18000;
        c_target := 15000; d_target := 15000;
        IF ABS(D1000 - a_target) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 2; D81 := 3; D82 := seq;
            main_state := 21;
        END_IF;

    21:
        IF D90 = 0 THEN
            seq := seq + 1; main_state := 22;
        END_IF;

    22:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            main_state := 30;
        END_IF;

    30:
        IF is_cancelling THEN
            main_state := 31;
        ELSE
            IF X70 THEN main_state := 31; END_IF;
        END_IF;

    31:
        IF ABS(D1016) <= 20 AND ABS(D1017) <= 100 AND ABS(D1020) <= 20 AND ABS(D1021) <= 100 THEN
            main_state := 40;
        END_IF;

    40:
        a_target := D409; b_target := 18000;
        IF ABS(D1000 - a_target) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 1; D81 := 3; D82 := seq;
            main_state := 41;
        END_IF;

    41:
        IF D90 = curr_id THEN
            seq := seq + 1; main_state := 42;
        END_IF;

    42:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            main_state := 50;
        END_IF;

    50:
        IF is_cancelling THEN
            main_state := 80;
        ELSE
            main_state := 501;
        END_IF;

    501:
        a_target := D412; b_target := 18000;
        IF ABS(D1000 - a_target) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 2; D81 := 4; D82 := seq;
            main_state := 51;
        END_IF;

    51:
        IF D90 = 0 THEN
            seq := seq + 1; main_state := 52;
        END_IF;

    52:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            main_state := 60;
        END_IF;

    60:
        IF is_cancelling THEN
            main_state := 61;
        ELSE
            IF X75 THEN main_state := 61; END_IF;
        END_IF;

    61:
        IF ABS(D1024 - 100000) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 3 AND ABS(D1033) <= 15 THEN
            main_state := 70;
        END_IF;

    70:
        a_target := D412; b_target := 18000;
        IF ABS(D1000 - a_target) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 1; D81 := 4; D82 := seq;
            main_state := 71;
        END_IF;

    71:
        IF D90 = curr_id THEN
            seq := seq + 1; main_state := 72;
        END_IF;

    72:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            main_state := 80;
        END_IF;

    80:
        a_target := SEL(curr_port = 1, D406, D403);
        b_target := 18000;
        c_target := SEL(curr_port = 1, 15000, D92);
        d_target := SEL(curr_port = 2, 15000, D92);
        IF ABS(D1000 - a_target) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND
           ((curr_port = 1 AND ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100) OR
            (curr_port = 2 AND ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100)) THEN
            D80 := 2; D81 := curr_port; D82 := seq;
            main_state := 81;
        END_IF;

    81:
        IF D90 = 0 THEN
            seq := seq + 1; main_state := 82;
        END_IF;

    82:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            main_state := 83;
        END_IF;

    83:
        c_target := 15000; d_target := 15000;
        IF ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 THEN
            main_state := 90;
        END_IF;

    90:
        IF curr_req = 0 THEN
            last_req0_id := curr_id;
            D300 := curr_id;
            D301 := SEL(is_cancelling, 1, 2);
        ELSE
            last_req1_id := curr_id;
            D302 := curr_id;
            D303 := SEL(is_cancelling, 1, 2);
        END_IF;
        main_state := 0;
        
    99:
        c_target := 15000; d_target := 15000;
        a_target := 0; b_target := 0;
        IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND
           ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20 AND
           ABS(D1016) <= 20 AND ABS(D1024 - 100000) <= 20 AND ABS(D1028) <= 20 AND
           ABS(D1032) <= 3 THEN
            Y2 := TRUE;
        END_IF;

END_CASE;

D2000 := a_target;
D2004 := b_target;
D2008 := c_target;
D2012 := d_target;

IF main_state = 30 THEN
    D2016 := D500;
ELSE
    D2016 := 0;
END_IF;
real_s3_0 := REAL(D1016) * 3.14159265 / 18000.0;
D2020 := DINT(-450.0 * SIN(real_s3_0) * 100.0);

IF main_state = 60 THEN
    m4_targ_x := D600; m4_targ_l := D601;
ELSE
    m4_targ_x := 100000; m4_targ_l := 0;
END_IF;

real_err_m := REAL(m4_targ_x - D1024) / 100000.0;
real_vel_m := REAL(D1025) / 100000.0;
real_theta := REAL(D1032) / 100.0 * 3.14159265 / 180.0;
real_w := REAL(D1033) / 100.0 * 3.14159265 / 180.0;

real_a_SI := 5.0 * real_err_m - 4.0 * real_vel_m + 15.0 * real_theta + 10.0 * real_w;
real_a_out := real_a_SI * 100000.0;

IF real_a_out > 1000000.0 THEN real_a_out := 1000000.0; END_IF;
IF real_a_out < -1000000.0 THEN real_a_out := -1000000.0; END_IF;

D712 := DINT(real_a_out);
D2024 := D712;
D2028 := m4_targ_l;

IF main_state = 99 AND ABS(D1009) <= 100 AND ABS(D1013) <= 100 THEN
    Y30 := TRUE;
ELSE
    Y30 := FALSE;
END_IF;

END_PROGRAM