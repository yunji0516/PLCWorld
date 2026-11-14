PROGRAM Main
VAR
    st0 : INT := 0;
    st1 : INT := 0;
    tm_brake : TON;
    tm_stab : TON;
    tm_comp : TON;
    tm_stab_final : TON;
    cur_req : INT := 0;
    brake_open_timer : TON;
    brake_close_timer : TON;
    lift_stopped : BOOL := FALSE;
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;
    all_done_sig : BOOL := FALSE;
    ack0_val : DINT := 0;
    ack1_val : DINT := 0;
    status0_val : DINT := 0;
    status1_val : DINT := 0;
    act_station : DINT := 0;
    act_action : DINT := 0;
    act_couple_seq : DINT := 0;
    seq_counter : DINT := 0;
    target_a : DINT := 0;
    target_b : DINT := 0;
    target_c : DINT := 15000;
    target_d : DINT := 15000;
    target_s3_0 : DINT := 0;
    target_s3_1 : DINT := 0;
    target_s4_0 : DINT := 100000;
    target_s4_1 : DINT := 0;
    target_s4_2 : DINT := 0;
    rate_a : DINT := 0;
    rate_b : DINT := 0;
    rate_c : DINT := 0;
    rate_d : DINT := 0;
    rate_s3_0 : DINT := 0;
    rate_s3_1 : DINT := 0;
    rate_s4_0 : DINT := 0;
    rate_s4_1 : DINT := 0;
    rate_s4_2 : DINT := 0;
    ff_a : DINT := 0;
    ff_b : DINT := 0;
    ff_c : DINT := 0;
    ff_d : DINT := 0;
    ff_s3_0 : DINT := 0;
    ff_s3_1 : DINT := 0;
    ff_s4_0 : DINT := 0;
    ff_s4_1 : DINT := 0;
    ff_s4_2 : DINT := 0;
    en_a : BOOL := FALSE;
    en_b : BOOL := FALSE;
    en_c : BOOL := FALSE;
    en_d : BOOL := FALSE;
    en_s3_0 : BOOL := FALSE;
    en_s3_1 : BOOL := FALSE;
    en_s4_0 : BOOL := FALSE;
    en_s4_1 : BOOL := FALSE;
    en_s4_2 : BOOL := FALSE;
    cfg3 : BOOL := FALSE;
    ret3 : BOOL := FALSE;
    sel3 : DINT := 0;
    rt3 : DINT := 0;
    ac3 : DINT := 0;
    cfg4 : BOOL := FALSE;
    ret4 : BOOL := FALSE;
    sel4 : DINT := 0;
    rt4 : DINT := 0;
    ac4 : DINT := 0;
    port_seq : DINT := 0;
    station_val : DINT := 0;
    action_val : DINT := 0;
    couple_val : DINT := 0;
    brake_cmd : BOOL := FALSE;
    done_cmd : BOOL := FALSE;
    prev_r0_id : DINT := -1;
    prev_r1_id : DINT := -1;
END_VAR

(* Default outputs to safe/zero except completion/ack which hold last value *)
D2000 := 0; D2001 := 0; D2002 := 0; Y40 := FALSE;
D2004 := 0; D2005 := 0; D2006 := 0; Y41 := FALSE;
D2008 := 15000; D2009 := 0; D2010 := 0; Y42 := FALSE;
D2012 := 15000; D2013 := 0; D2014 := 0; Y43 := FALSE;
D2016 := 0; D2017 := 0; D2018 := 0; Y44 := FALSE;
D2020 := 0; D2021 := 0; D2022 := 0; Y45 := FALSE;
D2024 := 100000; D2025 := 0; D2026 := 0; Y46 := FALSE;
D2028 := 0; D2029 := 0; D2030 := 0; Y47 := FALSE;
D2032 := 0; D2033 := 0; D2034 := 0; Y48 := FALSE;
Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
D80 := 0; D81 := 0; D82 := 0; Y30 := TRUE; Y2 := FALSE;

(* Brake logic: open only when lifts stopped or moving up, close only when stops <= 1 mm/s *)
lift_stopped := (ABS(D1009) <= 100) AND (ABS(D1013) <= 100);
IF NOT (st0 = 0 AND st1 = 0) THEN
    IF lift_stopped OR (D2008 > D1008) OR (D2012 > D1012) THEN
        brake_cmd := FALSE;
    ELSE
        brake_cmd := TRUE;
    END_IF;
ELSE
    brake_cmd := TRUE;
END_IF;

tm_brake(IN := NOT brake_cmd, PT := T#80ms);
Y30 := brake_cmd;

(* Station mapping *)
FUNCTION GetStationTarget : DINT
    VAR_INPUT loc : DINT; END_VAR
    CASE loc OF
        1: GetStationTarget := -360000;
        2: GetStationTarget := -230000;
        3: GetStationTarget := 230000;
        4: GetStationTarget := 990000;
        ELSE GetStationTarget := 0;
    END_CASE;
END_FUNCTION

(* Request 0 State Machine *)
IF D100 <> prev_r0_id THEN
    st0 := 0; prev_r0_id := D100;
END_IF;

CASE st0 OF
    0: (* Idle / Wait for request *)
        IF D102 > 0 AND D102 < 10 THEN
            st0 := 1;
        END_IF;
    1: (* Lift A up *)
        target_c := 73250; rate_c := 500; en_c := TRUE;
        IF ABS(D1008 - 73250) < 2000 AND ABS(D1009) <= 100 THEN
            st0 := 2;
        END_IF;
    2: (* Fork extend & Shuttle to station *)
        target_b := 18000; rate_b := 300; en_b := TRUE;
        target_a := GetStationTarget(D101); rate_a := 500; en_a := TRUE;
        act_station := D101; act_action := 1; seq_counter := seq_counter + 1; couple_val := seq_counter;
        IF ABS(D1004 - 18000) < 2000 AND ABS(D1005) <= 100 AND ABS(D1000 - target_a) < 2000 AND ABS(D1001) <= 100 THEN
            st0 := 3;
        END_IF;
    3: (* Cell 3 approach & configure *)
        target_a := 230000; rate_a := 500; en_a := TRUE;
        cfg3 := TRUE; sel3 := D100; rt3 := D526; ac3 := 500;
        ret3 := TRUE;
        IF X72 THEN (* synced *)
            st0 := 4;
        END_IF;
    4: (* Cell 3 process wait *)
        cfg3 := TRUE; ret3 := TRUE;
        IF X70 THEN (* served *)
            st0 := 5;
        END_IF;
    5: (* Shuttle to Cell 4 *)
        target_a := 990000; rate_a := 500; en_a := TRUE;
        cfg3 := FALSE; ret3 := FALSE;
        IF ABS(D1000 - 990000) < 2000 AND ABS(D1001) <= 100 THEN
            st0 := 6;
        END_IF;
    6: (* Cell 4 configure & process *)
        cfg4 := TRUE; sel4 := D100; rt4 := D626; ac4 := 500; ret4 := TRUE;
        IF X77 THEN
            st0 := 7;
        END_IF;
    7: (* Shuttle back to Lift station *)
        target_a := GetStationTarget(D101); rate_a := 500; en_a := TRUE;
        cfg4 := FALSE; ret4 := FALSE;
        IF ABS(D1000 - target_a) < 2000 AND ABS(D1001) <= 100 THEN
            st0 := 8;
        END_IF;
    8: (* Fork retract *)
        target_b := 0; rate_b := 300; en_b := TRUE;
        IF ABS(D1004) < 2000 AND ABS(D1005) <= 100 THEN
            st0 := 9;
        END_IF;
    9: (* Lift A down *)
        target_c := 15000; rate_c := 500; en_c := TRUE;
        IF ABS(D1008 - 15000) < 2000 AND ABS(D1009) <= 100 THEN
            st0 := 10;
        END_IF;
    10: (* Ack & Done *)
        ack0_val := D100; status0_val := 1;
        req0_done := TRUE;
        st0 := 0;
        prev_r0_id := D100;
        IF D102 >= 10 THEN D102 := 10; END_IF;
END_CASE;

(* Request 1 State Machine *)
IF D120 <> prev_r1_id THEN
    st1 := 0; prev_r1_id := D120;
END_IF;

CASE st1 OF
    0: (* Idle *)
        IF D122 > 0 AND D122 < 10 THEN
            st1 := 1;
        END_IF;
    1: (* Lift B up *)
        target_d := 73250; rate_d := 500; en_d := TRUE;
        IF ABS(D1012 - 73250) < 2000 AND ABS(D1013) <= 100 THEN
            st1 := 2;
        END_IF;
    2: (* Fork extend & Shuttle to station *)
        target_b := 18000; rate_b := 300; en_b := TRUE;
        target_a := GetStationTarget(D121); rate_a := 500; en_a := TRUE;
        act_station := D121; act_action := 1; seq_counter := seq_counter + 1; couple_val := seq_counter;
        IF ABS(D1004 - 18000) < 2000 AND ABS(D1005) <= 100 AND ABS(D1000 - target_a) < 2000 AND ABS(D1001) <= 100 THEN
            st1 := 3;
        END_IF;
    3: (* Cell 3 approach *)
        target_a := 230000; rate_a := 500; en_a := TRUE;
        cfg3 := TRUE; sel3 := D120; rt3 := D526; ac3 := 500;
        ret3 := TRUE;
        IF X72 THEN
            st1 := 4;
        END_IF;
    4: (* Cell 3 wait *)
        cfg3 := TRUE; ret3 := TRUE;
        IF X70 THEN
            st1 := 5;
        END_IF;
    5: (* Shuttle to Cell 4 *)
        target_a := 990000; rate_a := 500; en_a := TRUE;
        cfg3 := FALSE; ret3 := FALSE;
        IF ABS(D1000 - 990000) < 2000 AND ABS(D1001) <= 100 THEN
            st1 := 6;
        END_IF;
    6: (* Cell 4 configure *)
        cfg4 := TRUE; sel4 := D120; rt4 := D626; ac4 := 500; ret4 := TRUE;
        IF X77 THEN
            st1 := 7;
        END_IF;
    7: (* Shuttle back *)
        target_a := GetStationTarget(D121); rate_a := 500; en_a := TRUE;
        cfg4 := FALSE; ret4 := FALSE;
        IF ABS(D1000 - target_a) < 2000 AND ABS(D1001) <= 100 THEN
            st1 := 8;
        END_IF;
    8: (* Fork retract *)
        target_b := 0; rate_b := 300; en_b := TRUE;
        IF ABS(D1004) < 2000 AND ABS(D1005) <= 100 THEN
            st1 := 9;
        END_IF;
    9: (* Lift B down *)
        target_d := 15000; rate_d := 500; en_d := TRUE;
        IF ABS(D1012 - 15000) < 2000 AND ABS(D1013) <= 100 THEN
            st1 := 10;
        END_IF;
    10: (* Ack & Done *)
        ack1_val := D120; status1_val := 1;
        req1_done := TRUE;
        st1 := 0;
        prev_r1_id := D120;
        IF D122 >= 10 THEN D122 := 10; END_IF;
END_CASE;

(* Cancellation handling *)
IF X31 AND st0 > 0 AND st0 < 10 THEN
    st0 := 8; (* Jump to retract *)
END_IF;
IF X35 AND st1 > 0 AND st1 < 10 THEN
    st1 := 8;
END_IF;

(* Output assignment *)
D2000 := target_a; D2001 := rate_a; D2002 := ff_a; Y40 := en_a;
D2004 := target_b; D2005 := rate_b; D2006 := ff_b; Y41 := en_b;
D2008 := target_c; D2009 := rate_c; D2010 := ff_c; Y42 := en_c;
D2012 := target_d; D2013 := rate_d; D2014 := ff_d; Y43 := en_d;
D2016 := target_s3_0; D2017 := rate_s3_0; D2018 := ff_s3_0; Y44 := en_s3_0;
D2020 := target_s3_1; D2021 := rate_s3_1; D2022 := ff_s3_1; Y45 := en_s3_1;
D2024 := target_s4_0; D2025 := rate_s4_0; D2026 := ff_s4_0; Y46 := en_s4_0;
D2028 := target_s4_1; D2029 := rate_s4_1; D2030 := ff_s4_1; Y47 := en_s4_1;
D2032 := target_s4_2; D2033 := rate_s4_2; D2034 := ff_s4_2; Y48 := en_s4_2;
Y70 := cfg3; Y71 := ret3; D700 := sel3; D701 := rt3; D702 := ac3;
Y75 := cfg4; Y76 := ret4; D710 := sel4; D711 := rt4; D712 := ac4;
D80 := act_action; D81 := act_station; D82 := couple_val;
D300 := ack0_val; D301 := status0_val;
D302 := ack1_val; D303 := status1_val;

(* Completion logic *)
all_done_sig := req0_done AND req1_done;
IF all_done_sig AND X51 THEN
    tm_comp(IN := TRUE, PT := T#100ms);
    IF tm_comp.Q THEN
        done_cmd := TRUE;
    END_IF;
ELSE
    tm_comp(IN := FALSE);
    done_cmd := FALSE;
END_IF;
Y2 := done_cmd;

(* Brake safety enforcement *)
IF (en_c OR en_d) AND (ABS(D1009) > 100 OR ABS(D1013) > 100) AND brake_cmd THEN
    brake_cmd := FALSE;
END_IF;
Y30 := brake_cmd;

END_PROGRAM