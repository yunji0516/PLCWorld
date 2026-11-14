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
    D2020 : DINT;
    D2021 : DINT;
    D2022 : DINT;
    Y45 : BOOL;
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

    (* Internal variables *)
    sys_state : INT := 0;
    active_req : INT := 0;

    req0_active : BOOL := FALSE;
    req0_id : DINT := 0;
    req0_location : DINT := 0;
    req0_cancelled : BOOL := FALSE;
    req0_returned : BOOL := FALSE;
    req0_done : BOOL := FALSE;
    req0_stage : INT := 0;

    req1_active : BOOL := FALSE;
    req1_id : DINT := 0;
    req1_location : DINT := 0;
    req1_cancelled : BOOL := FALSE;
    req1_returned : BOOL := FALSE;
    req1_done : BOOL := FALSE;
    req1_stage : INT := 0;

    seq_counter : DINT := 1;
    completion_timer : TON;
    edge_prev0 : BOOL := FALSE;
    edge_prev1 : BOOL := FALSE;
    prev_r0_ret : BOOL := FALSE;
    prev_r1_ret : BOOL := FALSE;

    pos_a : REAL;
    pos_b : REAL;
    pos_c : REAL;
    pos_d : REAL;
    vel_a : REAL;
    vel_b : REAL;
    vel_c : REAL;
    vel_d : REAL;
    pos_s3_0 : REAL;
    pos_s3_1 : REAL;
    vel_s3_0 : REAL;
    vel_s3_1 : REAL;
    pos_s4_0 : REAL;
    pos_s4_1 : REAL;
    pos_s4_2 : REAL;
    pos_s4_3 : REAL;
    vel_s4_0 : REAL;
    vel_s4_1 : REAL;
    vel_s4_2 : REAL;
    vel_s4_3 : REAL;

    at_home : BOOL;
    shuttle_at_station : BOOL;
    fork_at_retract : BOOL;
    lift_at_home : BOOL;
    c3_at_home : BOOL;
    c4_at_home : BOOL;
    all_at_home : BOOL;

    station_pos : DINT;
    current_lane : INT;

    done_20ms_timer : TON;
    scan_counter : DINT := 0;
END_VAR

(* Convert positions from 0.01 scale to REAL *)
pos_a := REAL(D1000) * 0.01;
pos_b := REAL(D1004) * 0.01;
pos_c := REAL(D1008) * 0.01;
pos_d := REAL(D1012) * 0.01;
vel_a := REAL(D1001) * 0.01;
vel_b := REAL(D1005) * 0.01;
vel_c := REAL(D1009) * 0.01;
vel_d := REAL(D1013) * 0.01;
pos_s3_0 := REAL(D1016) * 0.01;
pos_s3_1 := REAL(D1020) * 0.01;
vel_s3_0 := REAL(D1017) * 0.01;
vel_s3_1 := REAL(D1021) * 0.01;
pos_s4_0 := REAL(D1024) * 0.01;
pos_s4_1 := REAL(D1028) * 0.01;
pos_s4_2 := REAL(D1032) * 0.01;
pos_s4_3 := REAL(D1036) * 0.01;
vel_s4_0 := REAL(D1025) * 0.01;
vel_s4_1 := REAL(D1029) * 0.01;
vel_s4_2 := REAL(D1033) * 0.01;
vel_s4_3 := REAL(D1037) * 0.01;

(* Check arrival tolerance for an axis *)
FUNCTION IS_ARRIVED : BOOL
VAR_INPUT
    actual_pos : REAL;
    target_pos : REAL;
    actual_vel : REAL;
END_VAR
    IS_ARRIVED := (ABS(actual_pos - target_pos) < 0.25) AND (ABS(actual_vel) < 1.5);
END_FUNCTION

scan_counter := scan_counter + 1;

(* Read request info *)
IF D100 <> 0 THEN
    req0_active := TRUE;
    req0_id := D100;
    req0_location := D101;
END_IF;

IF D120 <> 0 THEN
    req1_active := TRUE;
    req1_id := D120;
    req1_location := D121;
END_IF;

(* Track cancellation *)
IF req0_active AND X31 THEN
    req0_cancelled := TRUE;
END_IF;
IF req1_active AND X35 THEN
    req1_cancelled := TRUE;
END_IF;

(* Track returned - rising edge detection *)
IF prev_r0_ret = FALSE AND X30 = TRUE THEN
    req0_returned := TRUE;
    req0_done := TRUE;
END_IF;
prev_r0_ret := X30;

IF prev_r1_ret = FALSE AND X34 = TRUE THEN
    req1_returned := TRUE;
    req1_done := TRUE;
END_IF;
prev_r1_ret := X34;

(* Station position lookup *)
CASE req0_location OF
    1: station_pos := -3600;
    2: station_pos := -2300;
    3: station_pos := 0;
    4: station_pos := 6700;
    ELSE station_pos := 0;
END_CASE;

CASE req1_location OF
    1: station_pos := -3600;
    2: station_pos := -2300;
    3: station_pos := 0;
    4: station_pos := 6700;
    ELSE station_pos := 0;
END_CASE;

(* Default all outputs to safe *)
Y40 := FALSE;
Y41 := FALSE;
Y42 := FALSE;
Y43 := FALSE;
Y44 := FALSE;
Y45 := FALSE;
Y46 := FALSE;
Y47 := FALSE;
Y48 := FALSE;
Y49 := FALSE;
D2000 := DINT(pos_a * 100.0);
D2001 := 100;
D2002 := 0;
D2004 := DINT(pos_b * 100.0);
D2005 := 100;
D2006 := 0;
D2008 := DINT(pos_c * 100.0);
D2009 := 100;
D2010 := 0;
D2012 := DINT(pos_d * 100.0);
D2013 := 100;
D2014 := 0;
D2016 := DINT(pos_s3_0 * 100.0);
D2017 := 100;
D2018 := 0;
D2020 := DINT(pos_s3_1 * 100.0);
D2021 := 100;
D2022 := 0;
D2024 := DINT(pos_s4_0 * 100.0);
D2025 := 100;
D2026 := 0;
D2028 := DINT(pos_s4_1 * 100.0);
D2029 := 100;
D2030 := 0;
D2032 := DINT(pos_s4_2 * 100.0);
D2033 := 100;
D2034 := 0;
D2036 := DINT(pos_s4_3 * 100.0);
D2037 := 100;
D2038 := 0;
D80 := 0;
D81 := 0;
D82 := 0;
Y30 := FALSE;
Y70 := FALSE;
Y71 := FALSE;
D700 := 0;
D701 := 0;
D702 := 0;
Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := 0;
D712 := 0;
D300 := 0;
D301 := 0;
D302 := 0;
D303 := 0;

(* Check home conditions *)
at_home := (ABS(pos_a) < 0.25) AND (ABS(pos_b) < 0.25)
         AND (ABS(pos_c - 150.0) < 0.5) AND (ABS(pos_d - 150.0) < 0.5)
         AND (ABS(pos_s3_0) < 0.25) AND (ABS(pos_s3_1 - 50.0) < 0.5)
         AND (ABS(pos_s4_0 + 65.0) < 0.25) AND (ABS(pos_s4_1) < 0.5)
         AND (ABS(pos_s4_2 - 65.0) < 0.25) AND (ABS(pos_s4_3) < 0.5);

shuttle_at_station := FALSE;
fork_at_retract := ABS(pos_b) < 0.5;
lift_at_home := (ABS(pos_c - 150.0) < 0.5) AND (ABS(pos_d - 150.0) < 0.5);
c3_at_home := (ABS(pos_s3_0) < 0.25) AND (ABS(pos_s3_1 - 50.0) < 0.5);
c4_at_home := (ABS(pos_s4_0 + 65.0) < 0.25) AND (ABS(pos_s4_1) < 0.5)
            AND (ABS(pos_s4_2 - 65.0) < 0.25) AND (ABS(pos_s4_3) < 0.5);
all_at_home := at_home AND c3_at_home AND c4_at_home;

IF req0_active AND NOT req0_done THEN
    req0_location := D101;
END_IF;
IF req1_active AND NOT req1_done THEN
    req1_location := D121;
END_IF;

(* Main state machine *)
CASE sys_state OF
    0: (* Idle - check for new requests *)
        IF req0_active AND NOT req0_done THEN
            active_req := 0;
            req0_stage := 0;
            sys_state := 10;
        ELSIF req1_active AND NOT req1_done THEN
            active_req := 1;
            req1_stage := 0;
            sys_state := 10;
        ELSIF req0_done AND req1_done AND all_at_home THEN
            sys_state := 90;
        END_IF;

    10: (* Move shuttle to station position *)
        IF active_req = 0 THEN
            station_pos := -3600;
            CASE req0_location OF
                1: station_pos := -3600;
                2: station_pos := -2300;
                3: station_pos := 0;
                4: station_pos := 6700;
            END_CASE;
        ELSE
            CASE req1_location OF
                1: station_pos := -3600;
                2: station_pos := -2300;
                3: station_pos := 0;
                4: station_pos := 6700;
            END_CASE;
        END_IF;

        Y40 := TRUE;
        D2000 := station_pos;
        D2001 := 800;
        D2002 := 0;

        IF ABS(REAL(D2000) - pos_a) < 0.3 AND ABS(vel_a) < 1.5 THEN
            sys_state := 20;
        END_IF;
        IF active_req = 0 AND req0_cancelled THEN
            sys_state := 40;
        ELSIF active_req = 1 AND req1_cancelled THEN
            sys_state := 40;
        END_IF;

    20: (* Extend fork to connection position *)
        Y41 := TRUE;
        D2004 := 18000;
        D2005 := 300;
        D2006 := 0;

        IF ABS(REAL(D2004) - pos_b) < 0.5 AND ABS(vel_b) < 1.5 THEN
            sys_state := 30;
        END_IF;
        IF active_req = 0 AND req0_cancelled THEN
            sys_state := 40;
        ELSIF active_req = 1 AND req1_cancelled THEN
            sys_state := 40;
        END_IF;

    30: (* Cell work phase *)
        IF active_req = 0 THEN
            current_lane := DINT(BOOL_TO_INT(req0_cancelled));
            D700 := req0_id;
            D701 := D526;
            D702 := 800;
            Y70 := TRUE;
            Y71 := TRUE;
            D710 := req0_id;
            D711 := D626;
            D712 := 800;
            Y75 := TRUE;
            Y76 := TRUE;

            (* Cell 3: rotary table - rotate then extend *)
            IF req0_location = 3 OR req0_location = 1 OR req0_location = 2 THEN
                D2016 := D527;
                D2017 := 500;
                Y44 := TRUE;
                IF ABS(REAL(D2016) - pos_s3_0) < 0.3 AND ABS(vel_s3_0) < 1.0 THEN
                    D2020 := 500;
                    D2021 := 400;
                    Y45 := TRUE;
                    IF ABS(REAL(D2020) - pos_s3_1) < 0.3 AND ABS(vel_s3_1) < 1.0 THEN
                        sys_state := 50;
                    END_IF;
                END_IF;
            END_IF;

            (* Cell 4: boom - retract then rotate *)
            IF req0_location = 4 OR req0_location = 1 OR req0_location = 2 THEN
                D2028 := 8000;
                D2029 := 400;
                Y47 := TRUE;
                IF ABS(REAL(D2028) - pos_s4_1) < 0.5 AND ABS(vel_s4_1) < 1.5 THEN
                    D2024 := D627;
                    D2025 := 500;
                    Y46 := TRUE;
                    IF ABS(REAL(D2024) - pos_s4_0) < 0.3 AND ABS(vel_s4_0) < 1.0 THEN
                        D2032 := D627 + 130;
                        D2033 := 500;
                        Y48 := TRUE;
                        IF ABS(REAL(D2032) - pos_s4_2) < 0.3 AND ABS(vel_s4_2) < 1.0 THEN
                            D2036 := D603;
                            D2037 := 400;
                            Y49 := TRUE;
                            IF ABS(REAL(D2036) - pos_s4_3) < 0.5 AND ABS(vel_s4_3) < 1.5 THEN
                                sys_state := 50;
                            END_IF;
                        END_IF;
                    END_IF;
                END_IF;
            END_IF;
        ELSE
            (* Same for req1 *)
            D700 := req1_id;
            D701 := D526;
            D702 := 800;
            Y70 := TRUE;
            Y71 := TRUE;
            D710 := req1_id;
            D711 := D626;
            D712 := 800;
            Y75 := TRUE;
            Y76 := TRUE;

            IF req1_location = 3 OR req1_location = 1 OR req1_location = 2 THEN
                D2016 := D527;
                D2017 := 500;
                Y44 := TRUE;
                IF ABS(REAL(D2016) - pos_s3_0) < 0.3 AND ABS(vel_s3_0) < 1.0 THEN
                    D2020 := 500;
                    D2021 := 400;
                    Y45 := TRUE;
                    IF ABS(REAL(D2020) - pos_s3_1) < 0.3 AND ABS(vel_s3_1) < 1.0 THEN
                        sys_state := 50;
                    END_IF;
                END_IF;
            END_IF;

            IF req1_location = 4 OR req1_location = 1 OR req1_location = 2 THEN
                D2028 := 8000;
                D2029 := 400;
                Y47 := TRUE;
                IF ABS(REAL(D2028) - pos_s4_1) < 0.5 AND ABS(vel_s4_1) < 1.5 THEN
                    D2024 := D627;
                    D2025 := 500;
                    Y46 := TRUE;
                    IF ABS(REAL(D2024) - pos_s4_0) < 0.3 AND ABS(vel_s4_0) < 1.0 THEN
                        D2032 := D627 + 130;
                        D2033 := 500;
                        Y48 := TRUE;
                        IF ABS(REAL(D2032) - pos_s4_2) < 0.3 AND ABS(vel_s4_2) < 1.0 THEN
                            D2036 := D603;
                            D2037 := 400;
                            Y49 := TRUE;
                            IF ABS(REAL(D2036) - pos_s4_3) < 0.5 AND ABS(vel_s4_3) < 1.5 THEN
                                sys_state := 50;
                            END_IF;
                        END_IF;
                    END_IF;
                END_IF;
            END_IF;
        END_IF;

        IF active_req = 0 AND req0_cancelled THEN
            sys_state := 40;
        ELSIF active_req = 1 AND req1_cancelled THEN
            sys_state := 40;
        END_IF;

    40: (* Cancellation retrieval - retract cell axes to home *)
        Y44 := TRUE;
        D2016 := 0;
        D2017 := 500;
        Y45 := TRUE;
        D2020 := 5000;
        D2021 := 400;
        Y46 := TRUE;
        D2024 := -6500;
        D2025 := 500;
        Y47 := TRUE;
        D2028 := 8000;
        D2029 := 400;
        Y48 := TRUE;
        D2032 := 6500;
        D2033 := 500;
        Y49 := TRUE;
        D2036 := 0;
        D2037 := 400;
        Y70 := FALSE;
        Y71 := FALSE;
        Y75 := FALSE;
        Y76 := FALSE;

        IF c3_at_home AND c4_at_home THEN
            sys_state := 60;
        END_IF;

    50: (* Disconnect - retract fork *)
        D2004 := 0;
        D2005 := 300;
        IF ABS(REAL(D2004) - pos_b) < 0.5 AND ABS(vel_b) < 1.5 THEN
            IF active_req = 0 THEN
                D300 := req0_id;
                IF req0_cancelled THEN
                    D301 := 2;
                ELSE
                    D301 := 1;
                END_IF;
            ELSE
                D302 := req1_id;
                IF req1_cancelled THEN
                    D303 := 2;
                ELSE
                    D303 := 1;
                END_IF;
            END_IF;
            sys_state := 70;
        END_IF;

    60: (* After retrieval - move shuttle back home *)
        Y40 := TRUE;
        D2000 := 0;
        D2001 := 800;
        IF ABS(pos_a) < 0.3 AND ABS(vel_a) < 1.5 THEN
            sys_state := 70;
        END_IF;

    70: (* Retract lift to home position *)
        Y42 := TRUE;
        D2008 := 15000;
        D2009 := 500;
        Y43 := TRUE;
        D2012 := 15000;
        D2013 := 500;
        IF lift_at_home THEN
            sys_state := 80;
        END_IF;

    80: (* Return shuttle and fork to home *)
        Y40 := TRUE;
        D2000 := 0;
        D2001 := 800;
        Y41 := TRUE;
        D2004 := 0;
        D2005 := 300;
        Y44 := TRUE;
        D2016 := 0;
        D2017 := 500;
        Y45 := TRUE;
        D2020 := 5000;
        D2021 := 400;
        Y46 := TRUE;
        D2024 := -6500;
        D2025 := 500;
        Y47 := TRUE;
        D2028 := 0;
        D2029 := 400;
        Y48 := TRUE;
        D2032 := 6500;
        D2033 := 500;
        Y49 := TRUE;
        D2036 := 0;
        D2037 := 400;

        IF all_at_home THEN
            IF active_req = 0 THEN
                req0_stage := 99;
            ELSE
                req1_stage := 99;
            END_IF;
            sys_state := 0;
        END_IF;

    90: (* Completion - verify all at home and maintain Y2 *)
        Y2 := TRUE;
        completion_timer(IN := TRUE, PT := T#100ms);
        IF completion_timer.Q THEN
            (* Maintain completion *)
        END_IF;
        IF NOT all_at_home THEN
            Y2 := FALSE;
            completion_timer(IN := FALSE);
            sys_state := 0;
        END_IF;

END_CASE;

(* Handle cell 3 and 4 home positioning *)
IF sys_state <> 30 THEN
    IF NOT c3_at_home THEN
        Y44 := TRUE;
        D2016 := 0;
        D2017 := 500;
        Y45 := TRUE;
        D2020 := 5000;
        D2021 := 400;
    END_IF;
    IF NOT c4_at_home THEN
        Y46 := TRUE;
        D2024 := -6500;
        D2025 := 500;
        Y47 := TRUE;
        D2028 := 0;
        D2029 := 400;
        Y48 := TRUE;
        D2032 := 6500;
        D2033 := 500;
        Y49 := TRUE;
        D2036 := 0;
        D2037 := 400;
    END_IF;
END_IF;

(* Connection sequence *)
IF sys_state >= 10 AND sys_state <= 30 THEN
    IF D82 = 0 THEN
        D82 := seq_counter;
        seq_counter := seq_counter + 1;
    END_IF;
END_IF;

(* Station output *)
IF active_req = 0 THEN
    D81 := req0_location;
ELSE
    D81 := req1_location;
END_IF;

END_PROGRAM