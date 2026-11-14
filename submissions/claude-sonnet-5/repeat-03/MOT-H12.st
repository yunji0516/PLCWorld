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

    (* ---- internal ---- *)
    a_home : DINT := 0;
    b_home : DINT := 0;
    c_home : DINT := 15000;
    d_home : DINT := 15000;
    s3_0_home : DINT := -85000;
    s3_1_home : DINT := -85000;
    s4_0_home : DINT := -65000;
    s4_1_home : DINT := 65000;
    s4_2_home : DINT := 0;

    pos_tol : DINT := 20;
    vel_tol : DINT := 100;
    fork_connect : DINT := 18000; (* 180 mm * 100 *)
    drive_rate : DINT := 800;

    scan_count : DINT := 0;

    busy_owner : INT := 0;

    r0_state : INT := 0;
    r0_origin_is_c : BOOL;
    r0_cancel_latched : BOOL;
    r0_acked : BOOL;

    r1_state : INT := 0;
    r1_origin_is_c : BOOL;
    r1_cancel_latched : BOOL;
    r1_acked : BOOL;

    seq_counter : DINT := 0;

    target_a : DINT;
    lift_ready : BOOL;
    fork_ready : BOOL;
    a_ready : BOOL;
    port_ready : BOOL;

    all_axes_home : BOOL;
    y2_hold_timer : TON;
    final_declared : BOOL := FALSE;
END_VAR

scan_count := scan_count + 1;

(* -------- defaults every scan : drive everything toward home -------- *)
Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;

D2000 := a_home;   D2001 := drive_rate; D2002 := 0;
D2004 := b_home;   D2005 := drive_rate; D2006 := 0;
D2008 := c_home;   D2009 := drive_rate; D2010 := 0;
D2012 := d_home;   D2013 := drive_rate; D2014 := 0;
D2016 := s3_0_home; D2017 := drive_rate; D2018 := 0;
D2020 := s3_1_home; D2021 := drive_rate; D2022 := 0;
D2024 := s4_0_home; D2025 := drive_rate; D2026 := 0;
D2028 := s4_1_home; D2029 := drive_rate; D2030 := 0;
D2032 := s4_2_home; D2033 := drive_rate; D2034 := 0;

Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := D520; D702 := 500;
Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := D620; D712 := 500;

D80 := 0; D81 := 0; D82 := seq_counter;

(* -------- latch cancellations -------- *)
IF X31 THEN
    r0_cancel_latched := TRUE;
END_IF;
IF X35 THEN
    r1_cancel_latched := TRUE;
END_IF;

(* ======================= REQUEST 0 STATE MACHINE ======================= *)
CASE r0_state OF

0:
    IF D100 <> 0 AND NOT X30 THEN
        r0_origin_is_c := (D101 = 1);
        r0_cancel_latched := FALSE;
        r0_acked := FALSE;
        r0_state := 1;
    END_IF;

1:
    IF r0_origin_is_c THEN
        D2008 := D92; D2009 := drive_rate; D2010 := 0; Y42 := TRUE;
        lift_ready := ABS(D1008 - D92) <= pos_tol AND ABS(D1009) <= vel_tol;
    ELSE
        D2012 := D92; D2013 := drive_rate; D2014 := 0; Y43 := TRUE;
        lift_ready := ABS(D1012 - D92) <= pos_tol AND ABS(D1013) <= vel_tol;
    END_IF;
    D2004 := 0; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    fork_ready := ABS(D1004) <= pos_tol AND ABS(D1005) <= vel_tol;
    IF lift_ready AND fork_ready THEN
        IF r0_cancel_latched THEN
            r0_state := 13;
        ELSIF busy_owner = 0 THEN
            busy_owner := 1;
            r0_state := 2;
        END_IF;
    END_IF;

2:
    IF r0_origin_is_c THEN
        target_a := D403; port_ready := X61;
    ELSE
        target_a := D406; port_ready := X62;
    END_IF;
    D2000 := target_a; D2001 := drive_rate; D2002 := 0; Y40 := TRUE;
    a_ready := ABS(D1000 - target_a) <= pos_tol AND ABS(D1001) <= vel_tol;
    IF a_ready AND port_ready THEN
        r0_state := 3;
    END_IF;

3:
    seq_counter := seq_counter + 1;
    IF r0_origin_is_c THEN D81 := 1; ELSE D81 := 2; END_IF;
    D80 := 1; D82 := seq_counter;
    D2004 := 0; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    IF r0_cancel_latched THEN
        r0_state := 10;
    ELSE
        r0_state := 4;
    END_IF;

4:
    D2000 := D409; D2001 := drive_rate; D2002 := 0; Y40 := TRUE;
    a_ready := ABS(D1000 - D409) <= pos_tol AND ABS(D1001) <= vel_tol;
    IF a_ready AND X63 THEN
        r0_state := 5;
    END_IF;

5:
    seq_counter := seq_counter + 1;
    D80 := 2; D81 := 3; D82 := seq_counter;
    D2004 := fork_connect; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    Y70 := TRUE; Y71 := TRUE; D700 := D100; D701 := D520; D702 := 500;
    fork_ready := ABS(D1004 - fork_connect) <= pos_tol AND ABS(D1005) <= vel_tol;
    IF fork_ready AND X70 THEN
        r0_state := 6;
    END_IF;

6:
    seq_counter := seq_counter + 1;
    D80 := 1; D81 := 3; D82 := seq_counter;
    D2004 := 0; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    Y70 := FALSE; Y71 := FALSE;
    fork_ready := ABS(D1004) <= pos_tol AND ABS(D1005) <= vel_tol;
    IF fork_ready THEN
        IF r0_cancel_latched THEN
            r0_state := 10;
        ELSE
            r0_state := 7;
        END_IF;
    END_IF;

7:
    D2000 := D412; D2001 := drive_rate; D2002 := 0; Y40 := TRUE;
    a_ready := ABS(D1000 - D412) <= pos_tol AND ABS(D1001) <= vel_tol;
    IF a_ready AND X64 THEN
        r0_state := 8;
    END_IF;

8:
    seq_counter := seq_counter + 1;
    D80 := 2; D81 := 4; D82 := seq_counter;
    D2004 := fork_connect; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    Y75 := TRUE; Y76 := TRUE; D710 := D100; D711 := D620; D712 := 500;
    fork_ready := ABS(D1004 - fork_connect) <= pos_tol AND ABS(D1005) <= vel_tol;
    IF fork_ready AND X75 THEN
        r0_state := 9;
    END_IF;

9:
    seq_counter := seq_counter + 1;
    D80 := 1; D81 := 4; D82 := seq_counter;
    D2004 := 0; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    Y75 := FALSE; Y76 := FALSE;
    fork_ready := ABS(D1004) <= pos_tol AND ABS(D1005) <= vel_tol;
    IF fork_ready THEN
        r0_state := 10;
    END_IF;

10:
    IF r0_origin_is_c THEN
        target_a := D403; port_ready := X61;
    ELSE
        target_a := D406; port_ready := X62;
    END_IF;
    D2000 := target_a; D2001 := drive_rate; D2002 := 0; Y40 := TRUE;
    a_ready := ABS(D1000 - target_a) <= pos_tol AND ABS(D1001) <= vel_tol;
    IF a_ready AND port_ready THEN
        r0_state := 11;
    END_IF;

11:
    seq_counter := seq_counter + 1;
    IF r0_origin_is_c THEN D81 := 1; ELSE D81 := 2; END_IF;
    D80 := 2; D82 := seq_counter;
    D2004 := fork_connect; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    fork_ready := ABS(D1004 - fork_connect) <= pos_tol AND ABS(D1005) <= vel_tol;
    IF fork_ready THEN
        r0_state := 12;
    END_IF;

12:
    D2004 := 0; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    fork_ready := ABS(D1004) <= pos_tol AND ABS(D1005) <= vel_tol;
    IF r0_origin_is_c THEN
        D2008 := c_home; D2009 := drive_rate; D2010 := 0; Y42 := TRUE;
        lift_ready := ABS(D1008 - c_home) <= pos_tol AND ABS(D1009) <= vel_tol;
    ELSE
        D2012 := d_home; D2013 := drive_rate; D2014 := 0; Y43 := TRUE;
        lift_ready := ABS(D1012 - d_home) <= pos_tol AND ABS(D1013) <= vel_tol;
    END_IF;
    IF fork_ready AND lift_ready THEN
        busy_owner := 0;
        r0_state := 13;
    END_IF;

13:
    IF NOT r0_acked THEN
        D300 := D100;
        IF r0_cancel_latched THEN
            D301 := 2;
        ELSE
            D301 := 1;
        END_IF;
        r0_acked := TRUE;
    END_IF;

ELSE
    r0_state := 0;
END_CASE;

(* ======================= REQUEST 1 STATE MACHINE ======================= *)
CASE r1_state OF

0:
    IF D120 <> 0 AND NOT X34 THEN
        r1_origin_is_c := (D121 = 1);
        r1_cancel_latched := FALSE;
        r1_acked := FALSE;
        r1_state := 1;
    END_IF;

1:
    IF r1_origin_is_c THEN
        D2008 := D92; D2009 := drive_rate; D2010 := 0; Y42 := TRUE;
        lift_ready := ABS(D1008 - D92) <= pos_tol AND ABS(D1009) <= vel_tol;
    ELSE
        D2012 := D92; D2013 := drive_rate; D2014 := 0; Y43 := TRUE;
        lift_ready := ABS(D1012 - D92) <= pos_tol AND ABS(D1013) <= vel_tol;
    END_IF;
    D2004 := 0; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    fork_ready := ABS(D1004) <= pos_tol AND ABS(D1005) <= vel_tol;
    IF lift_ready AND fork_ready THEN
        IF r1_cancel_latched THEN
            r1_state := 13;
        ELSIF busy_owner = 0 THEN
            busy_owner := 2;
            r1_state := 2;
        END_IF;
    END_IF;

2:
    IF r1_origin_is_c THEN
        target_a := D403; port_ready := X61;
    ELSE
        target_a := D406; port_ready := X62;
    END_IF;
    D2000 := target_a; D2001 := drive_rate; D2002 := 0; Y40 := TRUE;
    a_ready := ABS(D1000 - target_a) <= pos_tol AND ABS(D1001) <= vel_tol;
    IF a_ready AND port_ready THEN
        r1_state := 3;
    END_IF;

3:
    seq_counter := seq_counter + 1;
    IF r1_origin_is_c THEN D81 := 1; ELSE D81 := 2; END_IF;
    D80 := 1; D82 := seq_counter;
    D2004 := 0; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    IF r1_cancel_latched THEN
        r1_state := 10;
    ELSE
        r1_state := 4;
    END_IF;

4:
    D2000 := D409; D2001 := drive_rate; D2002 := 0; Y40 := TRUE;
    a_ready := ABS(D1000 - D409) <= pos_tol AND ABS(D1001) <= vel_tol;
    IF a_ready AND X63 THEN
        r1_state := 5;
    END_IF;

5:
    seq_counter := seq_counter + 1;
    D80 := 2; D81 := 3; D82 := seq_counter;
    D2004 := fork_connect; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    Y70 := TRUE; Y71 := TRUE; D700 := D120; D701 := D520; D702 := 500;
    fork_ready := ABS(D1004 - fork_connect) <= pos_tol AND ABS(D1005) <= vel_tol;
    IF fork_ready AND X70 THEN
        r1_state := 6;
    END_IF;

6:
    seq_counter := seq_counter + 1;
    D80 := 1; D81 := 3; D82 := seq_counter;
    D2004 := 0; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    Y70 := FALSE; Y71 := FALSE;
    fork_ready := ABS(D1004) <= pos_tol AND ABS(D1005) <= vel_tol;
    IF fork_ready THEN
        IF r1_cancel_latched THEN
            r1_state := 10;
        ELSE
            r1_state := 7;
        END_IF;
    END_IF;

7:
    D2000 := D412; D2001 := drive_rate; D2002 := 0; Y40 := TRUE;
    a_ready := ABS(D1000 - D412) <= pos_tol AND ABS(D1001) <= vel_tol;
    IF a_ready AND X64 THEN
        r1_state := 8;
    END_IF;

8:
    seq_counter := seq_counter + 1;
    D80 := 2; D81 := 4; D82 := seq_counter;
    D2004 := fork_connect; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    Y75 := TRUE; Y76 := TRUE; D710 := D120; D711 := D620; D712 := 500;
    fork_ready := ABS(D1004 - fork_connect) <= pos_tol AND ABS(D1005) <= vel_tol;
    IF fork_ready AND X75 THEN
        r1_state := 9;
    END_IF;

9:
    seq_counter := seq_counter + 1;
    D80 := 1; D81 := 4; D82 := seq_counter;
    D2004 := 0; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    Y75 := FALSE; Y76 := FALSE;
    fork_ready := ABS(D1004) <= pos_tol AND ABS(D1005) <= vel_tol;
    IF fork_ready THEN
        r1_state := 10;
    END_IF;

10:
    IF r1_origin_is_c THEN
        target_a := D403; port_ready := X61;
    ELSE
        target_a := D406; port_ready := X62;
    END_IF;
    D2000 := target_a; D2001 := drive_rate; D2002 := 0; Y40 := TRUE;
    a_ready := ABS(D1000 - target_a) <= pos_tol AND ABS(D1001) <= vel_tol;
    IF a_ready AND port_ready THEN
        r1_state := 11;
    END_IF;

11:
    seq_counter := seq_counter + 1;
    IF r1_origin_is_c THEN D81 := 1; ELSE D81 := 2; END_IF;
    D80 := 2; D82 := seq_counter;
    D2004 := fork_connect; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    fork_ready := ABS(D1004 - fork_connect) <= pos_tol AND ABS(D1005) <= vel_tol;
    IF fork_ready THEN
        r1_state := 12;
    END_IF;

12:
    D2004 := 0; D2005 := drive_rate; D2006 := 0; Y41 := TRUE;
    fork_ready := ABS(D1004) <= pos_tol AND ABS(D1005) <= vel_tol;
    IF r1_origin_is_c THEN
        D2008 := c_home; D2009 := drive_rate; D2010 := 0; Y42 := TRUE;
        lift_ready := ABS(D1008 - c_home) <= pos_tol AND ABS(D1009) <= vel_tol;
    ELSE
        D2012 := d_home; D2013 := drive_rate; D2014 := 0; Y43 := TRUE;
        lift_ready := ABS(D1012 - d_home) <= pos_tol AND ABS(D1013) <= vel_tol;
    END_IF;
    IF fork_ready AND lift_ready THEN
        busy_owner := 0;
        r1_state := 13;
    END_IF;

13:
    IF NOT r1_acked THEN
        D302 := D120;
        IF r1_cancel_latched THEN
            D303 := 2;
        ELSE
            D303 := 1;
        END_IF;
        r1_acked := TRUE;
    END_IF;

ELSE
    r1_state := 0;
END_CASE;

(* -------- shared brake: engaged only while shuttle path idle -------- *)
Y30 := (busy_owner = 0);

(* -------- final completion : all axes at published home / initial posture -------- *)
all_axes_home :=
    ABS(D1000 - a_home) <= pos_tol AND ABS(D1001) <= vel_tol AND
    ABS(D1004 - b_home) <= pos_tol AND ABS(D1005) <= vel_tol AND
    ABS(D1008 - c_home) <= pos_tol AND ABS(D1009) <= vel_tol AND
    ABS(D1012 - d_home) <= pos_tol AND ABS(D1013) <= vel_tol AND
    ABS(D1016 - s3_0_home) <= pos_tol AND ABS(D1017) <= vel_tol AND
    ABS(D1020 - s3_1_home) <= pos_tol AND ABS(D1021) <= vel_tol AND
    ABS(D1024 - s4_0_home) <= pos_tol AND ABS(D1025) <= vel_tol AND
    ABS(D1028 - s4_1_home) <= pos_tol AND ABS(D1029) <= vel_tol AND
    ABS(D1032 - s4_2_home) <= pos_tol AND ABS(D1033) <= vel_tol;

IF NOT final_declared THEN
    y2_hold_timer(IN := (X51 AND all_axes_home AND (scan_count <= 16000)), PT := T#100ms);
    IF y2_hold_timer.Q THEN
        final_declared := TRUE;
    END_IF;
END_IF;

Y2 := final_declared;

END_PROGRAM