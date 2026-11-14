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

    (* ---- internal state ---- *)
    stage : INT := 0;      // 0=PROCESSING, 1=GOHOME, 2=HOLD
    proc_idx : INT := 0;   // 0 -> request0, 1 -> request1
    leg : INT := 0;        // 0=lift-start,1=cell3,2=cell4,3=lift-return
    subphase : INT := 0;   // 0=GOTO,1=EXTEND,2=PROCESS,3=RETRIEVE
    seq_num : DINT := 0;

    r_done0 : BOOL := FALSE;
    r_done1 : BOOL := FALSE;
    slot_done0 : BOOL;
    slot_done1 : BOOL;

    cur_id : DINT;
    cur_loc : DINT;
    cur_cancelled : BOOL;

    a_tgt, b_tgt, c_tgt, d_tgt : DINT;
    s3_0_tgt, s3_1_tgt : DINT;
    s4_0_tgt, s4_1_tgt, s4_2_tgt : DINT;

    station_coord : DINT;
    station_num : DINT;
    port_ready : BOOL;

    pos_tol : DINT := 20;
    spd_tol : DINT := 100;

    a_arr, b_arr : BOOL;
    s3_arr, s4_arr : BOOL;
    home_ok : BOOL;

    pi_c : REAL := 3.141592653589793;
    theta_a_r, theta_b_r : REAL;
    x_cw : REAL;
    moment4 : REAL;

    en_a, en_b, en_c, en_d : BOOL;
    en_s3_0, en_s3_1 : BOOL;
    en_s4_0, en_s4_1, en_s4_2 : BOOL;

    lift_dock_tgt : DINT;

    completion_hold : TON;
END_VAR

(* ---- pick a non-empty slot if current one is empty and idle ---- *)
IF stage = 0 AND leg = 0 AND subphase = 0 THEN
    IF proc_idx = 0 AND D100 = 0 AND D120 <> 0 AND NOT r_done1 THEN
        proc_idx := 1;
    ELSIF proc_idx = 1 AND D120 = 0 AND D100 <> 0 AND NOT r_done0 THEN
        proc_idx := 0;
    END_IF;
END_IF;

IF proc_idx = 0 THEN
    cur_id := D100;
    cur_loc := D101;
    cur_cancelled := X31;
ELSE
    cur_id := D120;
    cur_loc := D121;
    cur_cancelled := X35;
END_IF;

slot_done0 := r_done0 OR (D100 = 0);
slot_done1 := r_done1 OR (D120 = 0);

lift_dock_tgt := D92;

en_a := TRUE; en_b := TRUE; en_c := TRUE; en_d := TRUE;
en_s3_0 := TRUE; en_s3_1 := TRUE; en_s4_0 := TRUE; en_s4_1 := TRUE; en_s4_2 := TRUE;

Y70 := FALSE;
Y71 := FALSE;
Y75 := FALSE;
Y76 := FALSE;

CASE stage OF

0: (* ---- PROCESSING ---- *)

    IF leg = 0 OR leg = 3 THEN
        IF cur_loc = 1 THEN
            station_coord := -405000;
            station_num := 1;
            port_ready := X61;
        ELSE
            station_coord := -185000;
            station_num := 2;
            port_ready := X62;
        END_IF;
    ELSIF leg = 1 THEN
        station_coord := 490000;
        station_num := 3;
        port_ready := X63;
    ELSE
        station_coord := 1140000;
        station_num := 4;
        port_ready := X64;
    END_IF;

    IF cur_id = 0 OR (proc_idx = 0 AND r_done0) OR (proc_idx = 1 AND r_done1) THEN
        a_tgt := 0; b_tgt := 0; c_tgt := 40000; d_tgt := 40000;
        s3_0_tgt := -60000; s3_1_tgt := -60000;
        s4_0_tgt := 0; s4_1_tgt := 0; s4_2_tgt := 0;
    ELSE
        IF cur_cancelled AND leg < 3 AND (subphase = 1 OR subphase = 2) THEN
            subphase := 3;
        END_IF;

        CASE subphase OF
            0: (* GOTO *)
                a_tgt := station_coord;
                b_tgt := 0;
                c_tgt := lift_dock_tgt;
                d_tgt := lift_dock_tgt;
                a_arr := (ABS(D1000 - a_tgt) <= pos_tol) AND (ABS(D1001) <= spd_tol);
                IF a_arr THEN
                    subphase := 1;
                END_IF;

            1: (* EXTEND *)
                a_tgt := station_coord;
                b_tgt := 18000;
                D80 := 2;
                D81 := station_num;
                b_arr := (ABS(D1004 - b_tgt) <= pos_tol) AND (ABS(D1005) <= spd_tol);
                IF b_arr AND port_ready THEN
                    seq_num := seq_num + 1;
                    D82 := seq_num;
                    IF leg = 1 OR leg = 2 THEN
                        subphase := 2;
                    ELSE
                        subphase := 3;
                    END_IF;
                END_IF;

            2: (* PROCESS at cell3 or cell4 *)
                a_tgt := station_coord;
                b_tgt := 18000;
                IF leg = 1 THEN
                    s3_0_tgt := LIMIT(-95000, D500, 95000);
                    s3_1_tgt := LIMIT(-95000, D501, 95000);
                    Y70 := TRUE;
                    Y71 := TRUE;
                    D700 := cur_id;
                    D701 := D526;
                    D702 := 1000;
                    s3_arr := (ABS(D1016 - s3_0_tgt) <= pos_tol) AND (ABS(D1017) <= spd_tol)
                              AND (ABS(D1020 - s3_1_tgt) <= pos_tol) AND (ABS(D1021) <= spd_tol);
                    IF X70 AND s3_arr THEN
                        subphase := 3;
                    END_IF;
                ELSE
                    s4_0_tgt := LIMIT(-5000, D600, 5000);
                    s4_1_tgt := LIMIT(-5000, D601, 5000);
                    theta_a_r := (REAL(D1024) / 100.0) * pi_c / 180.0;
                    theta_b_r := (REAL(D1028) / 100.0) * pi_c / 180.0;
                    IF D602 <> 0 THEN
                        s4_2_tgt := LIMIT(-45000, D602, 45000);
                    ELSE
                        x_cw := -225.0 * (SIN(theta_a_r) + SIN(theta_b_r));
                        s4_2_tgt := DINT(LIMIT(-45000.0, ROUND(x_cw * 100.0), 45000.0));
                    END_IF;
                    moment4 := 20.0 * 9.81 / 1000.0 *
                               (225.0 * (SIN(theta_a_r) + SIN(theta_b_r)) + (REAL(D1032) / 100.0));
                    Y75 := TRUE;
                    Y76 := TRUE;
                    D710 := cur_id;
                    D711 := D626;
                    D712 := 1000;
                    s4_arr := (ABS(D1024 - s4_0_tgt) <= pos_tol) AND (ABS(D1025) <= spd_tol)
                              AND (ABS(D1028 - s4_1_tgt) <= pos_tol) AND (ABS(D1029) <= spd_tol)
                              AND (ABS(D1032 - s4_2_tgt) <= pos_tol) AND (ABS(D1033) <= spd_tol);
                    IF X75 AND s4_arr AND (ABS(moment4) <= 1.0) THEN
                        subphase := 3;
                    END_IF;
                END_IF;

            3: (* RETRIEVE *)
                a_tgt := station_coord;
                b_tgt := 0;
                D80 := 1;
                D81 := station_num;
                b_arr := (ABS(D1004 - b_tgt) <= pos_tol) AND (ABS(D1005) <= spd_tol);
                IF b_arr THEN
                    IF cur_cancelled AND leg < 3 THEN
                        leg := 3;
                        subphase := 0;
                    ELSIF leg = 3 THEN
                        IF proc_idx = 0 THEN
                            D300 := cur_id;
                            IF cur_cancelled THEN
                                D301 := 2;
                            ELSE
                                D301 := 1;
                            END_IF;
                            r_done0 := TRUE;
                        ELSE
                            D302 := cur_id;
                            IF cur_cancelled THEN
                                D303 := 2;
                            ELSE
                                D303 := 1;
                            END_IF;
                            r_done1 := TRUE;
                        END_IF;
                        leg := 0;
                        subphase := 0;
                        IF proc_idx = 0 AND D120 <> 0 AND NOT r_done1 THEN
                            proc_idx := 1;
                        ELSIF proc_idx = 1 AND D100 <> 0 AND NOT r_done0 THEN
                            proc_idx := 0;
                        ELSE
                            stage := 1;
                        END_IF;
                    ELSE
                        leg := leg + 1;
                        subphase := 0;
                    END_IF;
                END_IF;
        END_CASE;
    END_IF;

1: (* ---- GO HOME ---- *)
    a_tgt := 0; b_tgt := 0; c_tgt := 40000; d_tgt := 40000;
    s3_0_tgt := -60000; s3_1_tgt := -60000;
    s4_0_tgt := 0; s4_1_tgt := 0; s4_2_tgt := 0;

    home_ok := (ABS(D1000 - 0) <= pos_tol) AND (ABS(D1001) <= spd_tol)
        AND (ABS(D1004 - 0) <= pos_tol) AND (ABS(D1005) <= spd_tol)
        AND (ABS(D1008 - 40000) <= pos_tol) AND (ABS(D1009) <= spd_tol)
        AND (ABS(D1012 - 40000) <= pos_tol) AND (ABS(D1013) <= spd_tol)
        AND (ABS(D1016 - (-60000)) <= pos_tol) AND (ABS(D1017) <= spd_tol)
        AND (ABS(D1020 - (-60000)) <= pos_tol) AND (ABS(D1021) <= spd_tol)
        AND (ABS(D1024 - 0) <= pos_tol) AND (ABS(D1025) <= spd_tol)
        AND (ABS(D1028 - 0) <= pos_tol) AND (ABS(D1029) <= spd_tol)
        AND (ABS(D1032 - 0) <= pos_tol) AND (ABS(D1033) <= spd_tol);

    IF home_ok AND X51 AND slot_done0 AND slot_done1 THEN
        stage := 2;
    END_IF;

    IF (D100 <> 0 AND NOT r_done0) THEN
        proc_idx := 0; leg := 0; subphase := 0; stage := 0;
    ELSIF (D120 <> 0 AND NOT r_done1) THEN
        proc_idx := 1; leg := 0; subphase := 0; stage := 0;
    END_IF;

2: (* ---- HOLD / COMPLETION ---- *)
    a_tgt := 0; b_tgt := 0; c_tgt := 40000; d_tgt := 40000;
    s3_0_tgt := -60000; s3_1_tgt := -60000;
    s4_0_tgt := 0; s4_1_tgt := 0; s4_2_tgt := 0;
    en_a := FALSE; en_b := FALSE; en_c := FALSE; en_d := FALSE;
    en_s3_0 := FALSE; en_s3_1 := FALSE; en_s4_0 := FALSE; en_s4_1 := FALSE; en_s4_2 := FALSE;

    home_ok := (ABS(D1000 - 0) <= pos_tol) AND (ABS(D1001) <= spd_tol)
        AND (ABS(D1004 - 0) <= pos_tol) AND (ABS(D1005) <= spd_tol)
        AND (ABS(D1008 - 40000) <= pos_tol) AND (ABS(D1009) <= spd_tol)
        AND (ABS(D1012 - 40000) <= pos_tol) AND (ABS(D1013) <= spd_tol)
        AND (ABS(D1016 - (-60000)) <= pos_tol) AND (ABS(D1017) <= spd_tol)
        AND (ABS(D1020 - (-60000)) <= pos_tol) AND (ABS(D1021) <= spd_tol)
        AND (ABS(D1024 - 0) <= pos_tol) AND (ABS(D1025) <= spd_tol)
        AND (ABS(D1028 - 0) <= pos_tol) AND (ABS(D1029) <= spd_tol)
        AND (ABS(D1032 - 0) <= pos_tol) AND (ABS(D1033) <= spd_tol);

    completion_hold(IN := (home_ok AND X51 AND slot_done0 AND slot_done1), PT := T#100ms);

    Y2 := home_ok AND X51 AND slot_done0 AND slot_done1;

    IF NOT (home_ok AND X51 AND slot_done0 AND slot_done1) THEN
        stage := 1;
    END_IF;

END_CASE;

(* ---- write actuator outputs ---- *)
D2000 := a_tgt; D2001 := SEL(en_a, 0, 1000); D2002 := 0; Y40 := en_a;
D2004 := b_tgt; D2005 := SEL(en_b, 0, 1000); D2006 := 0; Y41 := en_b;
D2008 := c_tgt; D2009 := SEL(en_c, 0, 1000); D2010 := 0; Y42 := en_c;
D2012 := d_tgt; D2013 := SEL(en_d, 0, 1000); D2014 := 0; Y43 := en_d;
D2016 := s3_0_tgt; D2017 := SEL(en_s3_0, 0, 1000); D2018 := 0; Y44 := en_s3_0;
D2020 := s3_1_tgt; D2021 := SEL(en_s3_1, 0, 1000); D2022 := 0; Y45 := en_s3_1;
D2024 := s4_0_tgt; D2025 := SEL(en_s4_0, 0, 1000); D2026 := 0; Y46 := en_s4_0;
D2028 := s4_1_tgt; D2029 := SEL(en_s4_1, 0, 1000); D2030 := 0; Y47 := en_s4_1;
D2032 := s4_2_tgt; D2033 := SEL(en_s4_2, 0, 1000); D2034 := 0; Y48 := en_s4_2;

Y30 := (ABS(D1000 - a_tgt) <= pos_tol) AND (ABS(D1001) <= spd_tol);

END_PROGRAM