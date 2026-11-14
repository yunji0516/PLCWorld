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

    (* Internal state variables *)
    init_done : BOOL := FALSE;
    state : INT := 0;
    sub_state : INT := 0;
    current_req : INT := 0; (* 0: Req 0, 1: Req 1 *)
    req_active : BOOL := FALSE;
    active_req_id : DINT := 0;
    active_req_station : DINT := 1;
    next_seq : DINT := 1;

    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;

    timer_ms : DINT := 0;
    dwell_counter : DINT := 0;

    (* Cell target tracking *)
    cw_pos : DINT := 0;
    ang_rad : REAL := 0.0;
    
    (* Completion timer *)
    completion_time : DINT := 0;
END_VAR

(* Initialization on first scan *)
IF NOT init_done THEN
    init_done := TRUE;
    D2000 := 0;      (* a_target = 0 *)
    D2001 := 500;    (* a_rate *)
    D2002 := 0;
    Y40 := TRUE;     (* enable shuttle *)

    D2004 := 0;      (* b_target = 0 mm *)
    D2005 := 500;
    D2006 := 0;
    Y41 := TRUE;     (* enable fork *)

    D2008 := 15000;  (* c_target = 150 mm *)
    D2009 := 500;
    D2010 := 0;
    Y42 := TRUE;     (* enable lift A *)

    D2012 := 15000;  (* d_target = 150 mm *)
    D2013 := 500;
    D2014 := 0;
    Y43 := TRUE;     (* enable lift B *)

    D2016 := 0;      (* s3_0_target = 0 deg *)
    D2017 := 500;
    D2018 := 0;
    Y44 := TRUE;

    D2020 := 0;      (* s3_1_target = 0 mm *)
    D2021 := 500;
    D2022 := 0;
    Y45 := TRUE;

    D2024 := 100000; (* s4_0_target = 1000 mm *)
    D2025 := 500;
    D2026 := 0;
    Y46 := TRUE;

    D2028 := 0;      (* s4_1_target = 0 mm *)
    D2029 := 500;
    D2030 := 0;
    Y47 := TRUE;

    D2032 := 0;      (* s4_2 target *)
    D2033 := 0;
    D2034 := 0;
    Y48 := FALSE;    (* s4_2 externally driven *)

    Y30 := TRUE;     (* brake closed initially *)
    D80 := 0;
    D81 := 0;
    D82 := 0;
    Y2 := FALSE;
END_IF;

(* Brake control interlock: brake can only engage if lifts are stopped *)
IF (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) THEN
    (* Safe to engage brake if commanded or idle *)
    IF state = 0 THEN
        Y30 := TRUE;
    END_IF;
END_IF;

(* Main State Machine *)
CASE state OF
    0: (* Idle / Select Request *)
        D80 := 0;
        D81 := 0;
        IF (D100 > 0) AND NOT r0_done AND NOT X30 AND NOT X31 THEN
            current_req := 0;
            active_req_id := D100;
            IF D101 > 0 THEN
                active_req_station := D101;
            ELSE
                active_req_station := 1;
            END_IF;
            req_active := TRUE;
            state := 10;
            sub_state := 0;
        ELSIF (D120 > 0) AND NOT r1_done AND NOT X34 AND NOT X35 THEN
            current_req := 1;
            active_req_id := D120;
            IF D121 > 0 THEN
                active_req_station := D121;
            ELSE
                active_req_station := 2;
            END_IF;
            req_active := TRUE;
            state := 10;
            sub_state := 0;
        END_IF;

    (* Step 1: Lift original station to dock height D92 *)
    10:
        Y30 := FALSE; (* Release brake to move lift *)
        IF active_req_station = 1 THEN
            D2008 := D92;
            IF (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100) THEN
                state := 20;
                sub_state := 0;
            END_IF;
        ELSE
            D2012 := D92;
            IF (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100) THEN
                state := 20;
                sub_state := 0;
            END_IF;
        END_IF;

    (* Step 2: Shuttle moves to station and fork extracts jig *)
    20:
        CASE sub_state OF
            0: (* Move shuttle to station docking X *)
                IF active_req_station = 1 THEN
                    D2000 := D403;
                ELSE
                    D2000 := D406;
                END_IF;
                IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) THEN
                    sub_state := 1;
                END_IF;
            1: (* Extend fork to connect (180 mm) *)
                D2004 := 18000;
                IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
                    (* Handover extraction *)
                    D80 := 1; (* extraction *)
                    D81 := active_req_station;
                    D82 := next_seq;
                    next_seq := next_seq + 1;
                    sub_state := 2;
                    dwell_counter := 0;
                END_IF;
            2: (* Retract fork to 0 mm *)
                dwell_counter := dwell_counter + 1;
                IF dwell_counter >= 5 THEN
                    D80 := 0;
                    D2004 := 0;
                    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
                        state := 30;
                        sub_state := 0;
                    END_IF;
                END_IF;
        END_CASE;

    (* Step 3: Transport to Cell 3 (Balanced Incline Head) *)
    30:
        CASE sub_state OF
            0: (* Shuttle moves to Port 3 *)
                D2000 := D409;
                IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) THEN
                    sub_state := 1;
                END_IF;
            1: (* Fork places jig in Cell 3 *)
                D2004 := 18000;
                IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
                    D80 := 2; (* placement *)
                    D81 := 3;
                    D82 := next_seq;
                    next_seq := next_seq + 1;
                    sub_state := 2;
                    dwell_counter := 0;
                END_IF;
            2: (* Retract fork *)
                dwell_counter := dwell_counter + 1;
                IF dwell_counter >= 5 THEN
                    D80 := 0;
                    D2004 := 0;
                    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
                        state := 40;
                        sub_state := 0;
                    END_IF;
                END_IF;
        END_CASE;

    (* Step 4: Cell 3 Processing *)
    40:
        CASE sub_state OF
            0: (* Configure Cell 3 and command target *)
                Y70 := TRUE;
                D700 := active_req_id;
                D2016 := D500; (* s3_0 target angle *)
                (* Calculate counterbalance pos x = -450 * sin(theta) *)
                ang_rad := REAL(D500) * 3.14159265 / 18000.0;
                cw_pos := -DINT(45000.0 * SIN(ang_rad));
                IF D501 <> 0 THEN
                    D2020 := D501;
                ELSE
                    D2020 := cw_pos;
                END_IF;
                IF (ABS(D1016 - D2016) <= 20) AND (ABS(D1017) <= 100) AND
                   (ABS(D1020 - D2020) <= 20) AND (ABS(D1021) <= 100) THEN
                    sub_state := 1;
                    dwell_counter := 0;
                END_IF;
            1: (* Maintain result for 80 ms (4 scans) *)
                dwell_counter := dwell_counter + 1;
                IF (dwell_counter >= 4) OR X70 THEN
                    (* Return Cell 3 to initial home 0, 0 *)
                    D2016 := 0;
                    D2020 := 0;
                    IF (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND
                       (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) THEN
                        Y70 := FALSE;
                        sub_state := 2;
                    END_IF;
                END_IF;
            2: (* Retrieve from Cell 3: extend fork *)
                D2004 := 18000;
                IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
                    D80 := 1; (* extraction *)
                    D81 := 3;
                    D82 := next_seq;
                    next_seq := next_seq + 1;
                    sub_state := 3;
                    dwell_counter := 0;
                END_IF;
            3: (* Retract fork *)
                dwell_counter := dwell_counter + 1;
                IF dwell_counter >= 5 THEN
                    D80 := 0;
                    D2004 := 0;
                    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
                        state := 50;
                        sub_state := 0;
                    END_IF;
                END_IF;
        END_CASE;

    (* Step 5: Transport to Cell 4 (Hoist) *)
    50:
        CASE sub_state OF
            0: (* Shuttle moves to Port 4 *)
                D2000 := D412;
                IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) THEN
                    sub_state := 1;
                END_IF;
            1: (* Fork places jig in Cell 4 *)
                D2004 := 18000;
                IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
                    D80 := 2; (* placement *)
                    D81 := 4;
                    D82 := next_seq;
                    next_seq := next_seq + 1;
                    sub_state := 2;
                    dwell_counter := 0;
                END_IF;
            2: (* Retract fork *)
                dwell_counter := dwell_counter + 1;
                IF dwell_counter >= 5 THEN
                    D80 := 0;
                    D2004 := 0;
                    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
                        state := 60;
                        sub_state := 0;
                    END_IF;
                END_IF;
        END_CASE;

    (* Step 6: Cell 4 Processing *)
    60:
        CASE sub_state OF
            0: (* Configure Cell 4 and command goals *)
                Y75 := TRUE;
                D710 := active_req_id;
                IF D600 <> 0 THEN
                    D2024 := D600;
                END_IF;
                IF D601 <> 0 THEN
                    D2028 := D601;
                END_IF;
                IF (ABS(D1024 - D2024) <= 20) AND (ABS(D1025) <= 100) AND
                   (ABS(D1028 - D2028) <= 20) AND (ABS(D1029) <= 100) AND
                   (ABS(D1032) <= 3) AND (ABS(D1033) <= 15) THEN
                    sub_state := 1;
                    dwell_counter := 0;
                END_IF;
            1: (* Maintain result for 80 ms *)
                dwell_counter := dwell_counter + 1;
                IF (dwell_counter >= 4) OR X75 THEN
                    (* Return Cell 4 to home: rope 1000 mm, trolley 0 mm *)
                    D2024 := 100000;
                    D2028 := 0;
                    IF (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100) AND
                       (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
                       (ABS(D1032) <= 3) AND (ABS(D1033) <= 15) THEN
                        Y75 := FALSE;
                        sub_state := 2;
                    END_IF;
                END_IF;
            2: (* Retrieve from Cell 4: extend fork *)
                D2004 := 18000;
                IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
                    D80 := 1; (* extraction *)
                    D81 := 4;
                    D82 := next_seq;
                    next_seq := next_seq + 1;
                    sub_state := 3;
                    dwell_counter := 0;
                END_IF;
            3: (* Retract fork *)
                dwell_counter := dwell_counter + 1;
                IF dwell_counter >= 5 THEN
                    D80 := 0;
                    D2004 := 0;
                    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
                        state := 70;
                        sub_state := 0;
                    END_IF;
                END_IF;
        END_CASE;

    (* Step 7: Return to original lift station *)
    70:
        CASE sub_state OF
            0: (* Move shuttle back to original station *)
                IF active_req_station = 1 THEN
                    D2000 := D403;
                ELSE
                    D2000 := D406;
                END_IF;
                IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) THEN
                    sub_state := 1;
                END_IF;
            1: (* Extend fork to return jig *)
                D2004 := 18000;
                IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
                    D80 := 2; (* placement *)
                    D81 := active_req_station;
                    D82 := next_seq;
                    next_seq := next_seq + 1;
                    sub_state := 2;
                    dwell_counter := 0;
                END_IF;
            2: (* Retract fork *)
                dwell_counter := dwell_counter + 1;
                IF dwell_counter >= 5 THEN
                    D80 := 0;
                    D2004 := 0;
                    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
                        state := 80;
                        sub_state := 0;
                    END_IF;
                END_IF;
        END_CASE;

    (* Step 8: Lower lift to home (150 mm) and acknowledge *)
    80:
        CASE sub_state OF
            0:
                IF active_req_station = 1 THEN
                    D2008 := 15000;
                    IF (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) THEN
                        sub_state := 1;
                    END_IF;
                ELSE
                    D2012 := 15000;
                    IF (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) THEN
                        sub_state := 1;
                    END_IF;
                END_IF;
            1: (* Acknowledge request *)
                IF current_req = 0 THEN
                    D300 := active_req_id;
                    D301 := 1; (* completion *)
                    r0_done := TRUE;
                ELSE
                    D302 := active_req_id;
                    D303 := 1; (* completion *)
                    r1_done := TRUE;
                END_IF;
                req_active := FALSE;
                state := 0;
                sub_state := 0;
        END_CASE;
END_CASE;

(* Final Completion Check *)
IF X51 AND (state = 0) AND NOT req_active THEN
    (* Move shuttle and fork to 0 *)
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := 0;
    D2020 := 0;
    D2024 := 100000;
    D2028 := 0;

    (* Engage brake once lifts are stopped *)
    IF (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) THEN
        Y30 := TRUE;
    END_IF;

    (* Check all initial connection posture and settling conditions *)
    IF (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND
       (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100) AND
       (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 3) AND (ABS(D1033) <= 15) THEN
        completion_time := completion_time + 20;
        IF completion_time >= 100 THEN
            Y2 := TRUE;
        END_IF;
    ELSE
        completion_time := 0;
    END_IF;
ELSE
    IF NOT Y2 THEN
        completion_time := 0;
    END_IF;
END_IF;

END_PROGRAM