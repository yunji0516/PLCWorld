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
    main_state : INT := 0;
    active_req : INT := -1;
    req_id_val : DINT := 0;
    req_loc_val : INT := 0;
    req_due_val : DINT := 0;
    req_cancelled_val : BOOL := FALSE;
    prev_c3_result : DINT := 0;
    seq_num : DINT := 0;
    tmr_80ms : TON;
    tmr_100ms : TON;
    tmr_settle : TON;
    tmr_served : TON;
    tmr_comp : TON;
    trig_r0 : R_TRIG;
    trig_r1 : R_TRIG;
    trig_served_c3 : R_TRIG;
    trig_served_c4 : R_TRIG;
    PI : REAL := 3.14159265;
    RAD_PER_DEG : REAL := 0.017453293;
    HOME_A : DINT := 0;
    HOME_B : DINT := 0;
    HOME_C : DINT := 40000;
    HOME_D : DINT := 40000;
    HOME_S3_0 : DINT := 0;
    HOME_S3_1 : DINT := 0;
    HOME_S3_2 : DINT := 0;
    HOME_S4_0 : DINT := 0;
    HOME_S4_1 : DINT := 0;
    HOME_S4_2 : DINT := 0;
    DOCK_A : DINT := -405000;
    DOCK_B : DINT := -185000;
    DOCK_C3 : DINT := 0;
    DOCK_C4 : DINT := 375000;
    FORK_OUT : DINT := 18000;
    FORK_IN : DINT := 0;
    RATE_TRAVEL : DINT := 500;
    RATE_SLOW : DINT := 100;
    RATE_FINE : DINT := 50;
    tol_pos : REAL := 0.2;
    tol_speed : REAL := 1.0;
    lift_height_diff_max : DINT := 8000;
    moment_max : REAL := 25.0;
    pocket_extend_max : DINT := 8000;
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;
    c3_config_active : BOOL := FALSE;
    c4_config_active : BOOL := FALSE;
    brake_released : BOOL := FALSE;
    lift_a_pos_cmd : DINT := HOME_C;
    lift_b_pos_cmd : DINT := HOME_D;
END_VAR

trig_r0(CLK := D102 > 0);
trig_r1(CLK := D122 > 0);
trig_served_c3(CLK := X70);
trig_served_c4(CLK := X75);

tmr_80ms(IN := X70, PT := T#80ms);
tmr_served(IN := X75, PT := T#80ms);

CASE main_state OF

0: (* IDLE - wait for requests *)
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
    Y70 := FALSE;
    Y71 := FALSE;
    Y75 := FALSE;
    Y76 := FALSE;
    Y30 := TRUE;
    Y2 := FALSE;
    D80 := 0;
    D81 := 0;
    D82 := 0;
    D300 := 0;
    D301 := 0;
    D302 := 0;
    D303 := 0;
    c3_config_active := FALSE;
    c4_config_active := FALSE;
    brake_released := FALSE;

    (* Check for new requests *)
    IF D102 > 0 AND NOT req0_done THEN
        active_req := 0;
        req_id_val := D100;
        req_loc_val := D101;
        req_due_val := D103;
        req_cancelled_val := X31;
        seq_num := seq_num + 1;
        main_state := 1;
    ELSIF D122 > 0 AND NOT req1_done THEN
        active_req := 1;
        req_id_val := D120;
        req_loc_val := D121;
        req_due_val := D123;
        req_cancelled_val := X35;
        seq_num := seq_num + 1;
        main_state := 1;
    END_IF;

1: (* MOVE SHUTTLE TO LIFT *)
    (* Move shuttle to lift docking position *)
    IF req_loc_val = 1 THEN
        target_a := DOCK_A;
    ELSE
        target_a := DOCK_B;
    END_IF;

    D2000 := target_a;
    D2001 := RATE_TRAVEL;
    Y40 := TRUE;
    D2002 := 0;

    (* Release brake *)
    IF X53 AND NOT brake_released THEN
        brake_released := TRUE;
        Y30 := FALSE;
    END_IF;

    (* Raise/lower lift to dock height *)
    IF req_loc_val = 1 THEN
        lift_a_pos_cmd := D92;
        D2008 := lift_a_pos_cmd;
        D2009 := RATE_TRAVEL;
        Y42 := TRUE;
        D2010 := 0;
    ELSE
        lift_b_pos_cmd := D92;
        D2012 := lift_b_pos_cmd;
        D2013 := RATE_TRAVEL;
        Y43 := TRUE;
        D2014 := 0;
    END_IF;

    (* Wait for shuttle to arrive at dock *)
    IF ABS(REAL(D1000) * 0.01 - REAL(target_a) * 0.01) <= tol_pos AND
       ABS(REAL(D1001) * 0.01) <= tol_speed THEN
        tmr_settle(IN := TRUE, PT := T#30ms);
        IF tmr_settle.Q THEN
            tmr_settle(IN := FALSE);
            IF req_cancelled_val THEN
                main_state := 8;
            ELSE
                main_state := 2;
            END_IF;
        END_IF;
    ELSE
        tmr_settle(IN := FALSE);
    END_IF;

2: (* CONNECT FORK *)
    (* Extend fork to connect *)
    D2004 := FORK_OUT;
    D2005 := RATE_SLOW;
    Y41 := TRUE;
    D2006 := 0;

    (* Set connection action *)
    D80 := 1;
    IF req_loc_val = 1 THEN
        D81 := 1;
    ELSE
        D81 := 2;
    END_IF;
    D82 := seq_num;

    (* Maintain lift position *)
    IF req_loc_val = 1 THEN
        D2008 := lift_a_pos_cmd;
        Y42 := TRUE;
    ELSE
        D2012 := lift_b_pos_cmd;
        Y43 := TRUE;
    END_IF;
    Y40 := TRUE;

    (* Wait for fork to extend and connection ready *)
    IF ABS(REAL(D1004) * 0.01 - 180.0) <= tol_pos AND
       ((req_loc_val = 1 AND X61) OR (req_loc_val = 2 AND X62)) THEN
        tmr_settle(IN := TRUE, PT := T#30ms);
        IF tmr_settle.Q THEN
            tmr_settle(IN := FALSE);
            IF req_cancelled_val THEN
                main_state := 8;
            ELSE
                main_state := 3;
            END_IF;
        END_IF;
    ELSE
        tmr_settle(IN := FALSE);
    END_IF;

3: (* MOVE TO CELL 3 *)
    (* Move shuttle to cell 3 dock *)
    D2000 := DOCK_C3;
    D2001 := RATE_TRAVEL;
    Y40 := TRUE;
    D2002 := 0;

    (* Maintain connections *)
    D2004 := FORK_OUT;
    Y41 := TRUE;
    IF req_loc_val = 1 THEN
        D2008 := lift_a_pos_cmd;
        Y42 := TRUE;
    ELSE
        D2012 := lift_b_pos_cmd;
        Y43 := TRUE;
    END_IF;

    (* Wait for shuttle at cell 3 *)
    IF ABS(REAL(D1000) * 0.01) <= tol_pos AND
       ABS(REAL(D1001) * 0.01) <= tol_speed AND
       X63 THEN
        tmr_settle(IN := TRUE, PT := T#30ms);
        IF tmr_settle.Q THEN
            tmr_settle(IN := FALSE);
            main_state := 4;
        END_IF;
    ELSE
        tmr_settle(IN := FALSE);
    END_IF;

4: (* CELL 3 PROCESS *)
    (* Configure cell 3 with target angles *)
    (* Target 90 = [35, -20], Target 180 = [-35, 20] *)
    IF req_loc_val >= 1 THEN
        (* Use goal inputs *)
        D2016 := D500;  (* s3_0 target *)
        D2020 := D501;  (* s3_1 target *)

        (* Counterweight calculation if goal2 is 0 *)
        IF D502 = 0 THEN
            (* Calculate counterweight from moment formula *)
            (* dual: 20*9.81/1000 * [225*(sin(thetaA)+sin(thetaB))+x] *)
            (* For moment~0: x = -225*(sin(thetaA)+sin(thetaB)) *)
            calc_angle_a := REAL(D500) * 0.01 * PI / 180.0;
            calc_angle_b := REAL(D501) * 0.01 * PI / 180.0;
            calc_counterweight := -225.0 * (SIN(calc_angle_a) + SIN(calc_angle_b));
            D2024 := DINT(calc_counterweight * 100.0);
        ELSE
            D2024 := D502;
        END_IF;
    END_IF;

    D2017 := RATE_SLOW;
    D2021 := RATE_SLOW;
    D2025 := RATE_SLOW;
    Y44 := TRUE;
    Y45 := TRUE;
    Y46 := TRUE;
    D2018 := 0;
    D2022 := 0;
    D2026 := 0;

    (* Cell 3 configuration *)
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := req_loc_val;
    D701 := req_target_val();
    D702 := 500;

    (* Maintain shuttle and lift *)
    D2000 := DOCK_C3;
    Y40 := TRUE;
    D2004 := FORK_OUT;
    Y41 := TRUE;
    IF req_loc_val = 1 THEN
        D2008 := lift_a_pos_cmd;
        Y42 := TRUE;
    ELSE
        D2012 := lift_b_pos_cmd;
        Y43 := TRUE;
    END_IF;

    (* Wait for cell 3 served *)
    IF tmr_80ms.Q THEN
        IF req_cancelled_val THEN
            Y70 := FALSE;
            Y71 := FALSE;
            main_state := 7;
        ELSE
            Y70 := FALSE;
            Y71 := FALSE;
            prev_c3_result := D526;
            main_state := 5;
        END_IF;
    END_IF;

5: (* MOVE TO CELL 4 *)
    (* Move shuttle to cell 4 dock *)
    D2000 := DOCK_C4;
    D2001 := RATE_TRAVEL;
    Y40 := TRUE;
    D2002 := 0;

    (* Maintain cell 3 retained *)
    Y44 := TRUE;
    Y45 := TRUE;
    Y46 := TRUE;
    Y71 := TRUE;

    (* Maintain lift *)
    IF req_loc_val = 1 THEN
        D2008 := lift_a_pos_cmd;
        Y42 := TRUE;
    ELSE
        D2012 := lift_b_pos_cmd;
        Y43 := TRUE;
    END_IF;

    (* Wait for shuttle at cell 4 *)
    IF ABS(REAL(D1000) * 0.01 - 3750.0) <= tol_pos AND
       ABS(REAL(D1001) * 0.01) <= tol_speed AND
       X64 THEN
        tmr_settle(IN := TRUE, PT := T#30ms);
        IF tmr_settle.Q THEN
            tmr_settle(IN := FALSE);
            main_state := 6;
        END_IF;
    ELSE
        tmr_settle(IN := FALSE);
    END_IF;

6: (* CELL 4 PROCESS *)
    (* Configure cell 4 with pocket selection *)
    (* Pocket 1 if prev result negative, pocket 2 if >= 0 *)
    IF prev_c3_result < 0 THEN
        D710 := 1;
    ELSE
        D710 := 2;
    END_IF;

    D2028 := D600;
    D2032 := D601;
    D2036 := D602;
    D2029 := RATE_SLOW;
    D2033 := RATE_SLOW;
    D2037 := RATE_SLOW;
    Y47 := TRUE;
    Y48 := TRUE;
    Y49 := TRUE;
    D2030 := 0;
    D2034 := 0;
    D2038 := 0;

    (* Cell 4 configuration *)
    Y75 := TRUE;
    Y76 := TRUE;
    D711 := D626;
    D712 := 500;

    (* Maintain shuttle *)
    D2000 := DOCK_C4;
    Y40 := TRUE;

    (* Maintain cell 3 retained *)
    Y44 := TRUE;
    Y45 := TRUE;
    Y46 := TRUE;
    Y71 := TRUE;

    (* Maintain lift *)
    IF req_loc_val = 1 THEN
        D2008 := lift_a_pos_cmd;
        Y42 := TRUE;
    ELSE
        D2012 := lift_b_pos_cmd;
        Y43 := TRUE;
    END_IF;

    (* Wait for cell 4 served *)
    IF tmr_served.Q THEN
        Y75 := FALSE;
        Y76 := FALSE;
        main_state := 7;
    END_IF;

7: (* RETURN TO LIFT *)
    (* Move shuttle back to lift dock *)
    IF req_loc_val = 1 THEN
        D2000 := DOCK_A;
    ELSE
        D2000 := DOCK_B;
    END_IF;
    D2001 := RATE_TRAVEL;
    Y40 := TRUE;
    D2002 := 0;

    (* Retract fork *)
    D2004 := FORK_IN;
    D2005 := RATE_SLOW;
    Y41 := TRUE;
    D2006 := 0;

    (* Lower lift to home *)
    IF req_loc_val = 1 THEN
        D2008 := HOME_C;
        D2009 := RATE_TRAVEL;
        Y42 := TRUE;
        D2010 := 0;
    ELSE
        D2012 := HOME_D;
        D2013 := RATE_TRAVEL;
        Y43 := TRUE;
        D2014 := 0;
    END_IF;

    (* Maintain cell positions at home *)
    D2016 := HOME_S3_0;
    D2020 := HOME_S3_1;
    D2024 := HOME_S3_2;
    Y44 := TRUE;
    Y45 := TRUE;
    Y46 := TRUE;
    Y70 := FALSE;
    Y71 := FALSE;

    D2028 := HOME_S4_0;
    D2032 := HOME_S4_1;
    D2036 := HOME_S4_2;
    Y47 := TRUE;
    Y48 := TRUE;
    Y49 := TRUE;
    Y75 := FALSE;
    Y76 := FALSE;

    (* Wait for shuttle at lift and fork retracted *)
    IF ((req_loc_val = 1 AND ABS(REAL(D1000) * 0.01 - (-4050.0)) <= tol_pos) OR
        (req_loc_val = 2 AND ABS(REAL(D1000) * 0.01 - (-1850.0)) <= tol_pos)) AND
       ABS(REAL(D1001) * 0.01) <= tol_speed AND
       ABS(REAL(D1004) * 0.01) <= tol_pos AND
       ABS(REAL(D1009) * 0.01) <= tol_speed THEN
        tmr_settle(IN := TRUE, PT := T#30ms);
        IF tmr_settle.Q THEN
            tmr_settle(IN := FALSE);
            main_state := 9;
        END_IF;
    ELSE
        tmr_settle(IN := FALSE);
    END_IF;

8: (* CANCELLED - RETURN TO LIFT *)
    (* Retract fork and return to lift for cancelled request *)
    D2004 := FORK_IN;
    D2005 := RATE_SLOW;
    Y41 := TRUE;
    D2006 := 0;

    IF req_loc_val = 1 THEN
        D2000 := DOCK_A;
    ELSE
        D2000 := DOCK_B;
    END_IF;
    D2001 := RATE_TRAVEL;
    Y40 := TRUE;
    D2002 := 0;

    (* Lower lift to home *)
    IF req_loc_val = 1 THEN
        D2008 := HOME_C;
        D2009 := RATE_TRAVEL;
        Y42 := TRUE;
    ELSE
        D2012 := HOME_D;
        D2013 := RATE_TRAVEL;
        Y43 := TRUE;
    END_IF;

    (* Home all cell axes *)
    D2016 := HOME_S3_0; Y44 := TRUE;
    D2020 := HOME_S3_1; Y45 := TRUE;
    D2024 := HOME_S3_2; Y46 := TRUE;
    Y70 := FALSE; Y71 := FALSE;
    D2028 := HOME_S4_0; Y47 := TRUE;
    D2032 := HOME_S4_1; Y48 := TRUE;
    D2036 := HOME_S4_2; Y49 := TRUE;
    Y75 := FALSE; Y76 := FALSE;

    IF ABS(REAL(D1004) * 0.01) <= tol_pos THEN
        tmr_settle(IN := TRUE, PT := T#30ms);
        IF tmr_settle.Q THEN
            tmr_settle(IN := FALSE);
            main_state := 9;
        END_IF;
    ELSE
        tmr_settle(IN := FALSE);
    END_IF;

9: (* ACKNOWLEDGE REQUEST *)
    (* Acknowledge completion *)
    IF active_req = 0 THEN
        D300 := req_id_val;
        IF req_cancelled_val THEN
            D301 := 2;
        ELSE
            D301 := 1;
        END_IF;
        req0_done := TRUE;
    ELSIF active_req = 1 THEN
        D302 := req_id_val;
        IF req_cancelled_val THEN
            D303 := 2;
        ELSE
            D303 := 1;
        END_IF;
        req1_done := TRUE;
    END_IF;

    D80 := 0;
    D81 := 0;

    active_req := -1;
    main_state := 10;

10: (* RETURN TO HOME *)
    (* Return shuttle and fork to home *)
    D2000 := HOME_A;
    D2001 := RATE_TRAVEL;
    Y40 := TRUE;
    D2002 := 0;

    D2004 := HOME_B;
    D2005 := RATE_TRAVEL;
    Y41 := TRUE;
    D2006 := 0;

    (* Home cell axes *)
    D2016 := HOME_S3_0; D2017 := RATE_TRAVEL; Y44 := TRUE; D2018 := 0;
    D2020 := HOME_S3_1; D2021 := RATE_TRAVEL; Y45 := TRUE; D2022 := 0;
    D2024 := HOME_S3_2; D2025 := RATE_TRAVEL; Y46 := TRUE; D2026 := 0;
    D2028 := HOME_S4_0; D2029 := RATE_TRAVEL; Y47 := TRUE; D2030 := 0;
    D2032 := HOME_S4_1; D2033 := RATE_TRAVEL; Y48 := TRUE; D2034 := 0;
    D2036 := HOME_S4_2; D2037 := RATE_TRAVEL; Y49 := TRUE; D2038 := 0;

    (* Home lifts *)
    D2008 := HOME_C; D2009 := RATE_TRAVEL; Y42 := TRUE; D2010 := 0;
    D2012 := HOME_D; D2013 := RATE_TRAVEL; Y43 := TRUE; D2014 := 0;

    (* Check if at home *)
    IF ABS(REAL(D1000) * 0.01) <= tol_pos AND
       ABS(REAL(D1004) * 0.01) <= tol_pos AND
       ABS(REAL(D1016) * 0.01) <= tol_pos AND
       ABS(REAL(D1020) * 0.01) <= tol_pos AND
       ABS(REAL(D1024) * 0.01) <= tol_pos AND
       ABS(REAL(D1028) * 0.01) <= tol_pos AND
       ABS(REAL(D1032) * 0.01) <= tol_pos AND
       ABS(REAL(D1036) * 0.01) <= tol_pos AND
       ABS(REAL(D1008) * 0.01 - 400.0) <= tol_pos AND
       ABS(REAL(D1012) * 0.01 - 400.0) <= tol_pos THEN
        tmr_settle(IN := TRUE, PT := T#30ms);
        IF tmr_settle.Q THEN
            tmr_settle(IN := FALSE);
            (* Check if all requests done *)
            IF (D102 = 0 OR req0_done) AND (D122 = 0 OR req1_done) THEN
                main_state := 11;
            ELSE
                main_state := 0;
            END_IF;
        END_IF;
    ELSE
        tmr_settle(IN := FALSE);
    END_IF;

11: (* COMPLETION CHECK *)
    (* Maintain home positions *)
    D2000 := HOME_A; Y40 := TRUE;
    D2004 := HOME_B; Y41 := TRUE;
    D2016 := HOME_S3_0; Y44 := TRUE;
    D2020 := HOME_S3_1; Y45 := TRUE;
    D2024 := HOME_S3_2; Y46 := TRUE;
    D2028 := HOME_S4_0; Y47 := TRUE;
    D2032 := HOME_S4_1; Y48 := TRUE;
    D2036 := HOME_S4_2; Y49 := TRUE;
    D2008 := HOME_C; Y42 := TRUE;
    D2012 := HOME_D; Y43 := TRUE;

    (* Check completion condition *)
    IF ABS(REAL(D1000) * 0.01) <= tol_pos AND
       ABS(REAL(D1004) * 0.01) <= tol_pos AND
       ABS(REAL(D1016) * 0.01) <= tol_pos AND
       ABS(REAL(D1020) * 0.01) <= tol_pos AND
       ABS(REAL(D1024) * 0.01) <= tol_pos AND
       ABS(REAL(D1028) * 0.01) <= tol_pos AND
       ABS(REAL(D1032) * 0.01) <= tol_pos AND
       ABS(REAL(D1036) * 0.01) <= tol_pos AND
       ABS(REAL(D1008) * 0.01 - 400.0) <= tol_pos AND
       ABS(REAL(D1012) * 0.01 - 400.0) <= tol_pos THEN
        Y2 := TRUE;
        tmr_comp(IN := TRUE, PT := T#100ms);
        IF tmr_comp.Q THEN
            (* Completion held for 100ms *)
        END_IF;
    ELSE
        Y2 := FALSE;
        tmr_comp(IN := FALSE);
    END_IF;

    (* Check for new requests *)
    IF NOT req0_done AND D102 > 0 THEN
        Y2 := FALSE;
        active_req := 0;
        req_id_val := D100;
        req_loc_val := D101;
        req_due_val := D103;
        req_cancelled_val := X31;
        seq_num := seq_num + 1;
        main_state := 1;
    ELSIF NOT req1_done AND D122 > 0 THEN
        Y2 := FALSE;
        active_req := 1;
        req_id_val := D120;
        req_loc_val := D121;
        req_due_val := D123;
        req_cancelled_val := X35;
        seq_num := seq_num + 1;
        main_state := 1;
    END_IF;

END_CASE;

(* Safety checks - apply brakes if safety violated *)
IF ABS(REAL(D1008) * 0.01 - REAL(D1012) * 0.01) > 80.0 THEN
    Y42 := FALSE;
    Y43 := FALSE;
    Y30 := TRUE;
END_IF;

(* Feedforward defaults *)
IF NOT Y40 THEN D2002 := 0; END_IF;
IF NOT Y41 THEN D2006 := 0; END_IF;
IF NOT Y42 THEN D2010 := 0; END_IF;
IF NOT Y43 THEN D2014 := 0; END_IF;
IF NOT Y44 THEN D2018 := 0; END_IF;
IF NOT Y45 THEN D2022 := 0; END_IF;
IF NOT Y46 THEN D2026 := 0; END_IF;
IF NOT Y47 THEN D2030 := 0; END_IF;
IF NOT Y48 THEN D2034 := 0; END_IF;
IF NOT Y49 THEN D2038 := 0; END_IF;

(* Rate defaults *)
IF NOT Y40 THEN D2001 := 0; END_IF;
IF NOT Y41 THEN D2005 := 0; END_IF;
IF NOT Y42 THEN D2009 := 0; END_IF;
IF NOT Y43 THEN D2013 := 0; END_IF;
IF NOT Y44 THEN D2017 := 0; END_IF;
IF NOT Y45 THEN D2021 := 0; END_IF;
IF NOT Y46 THEN D2025 := 0; END_IF;
IF NOT Y47 THEN D2029 := 0; END_IF;
IF NOT Y48 THEN D2033 := 0; END_IF;
IF NOT Y49 THEN D2037 := 0; END_IF;

END_PROGRAM