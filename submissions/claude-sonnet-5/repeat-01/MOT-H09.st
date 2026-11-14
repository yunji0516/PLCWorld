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
    main_phase   : INT := 0;
    sub_phase    : INT := 0;
    cur_req      : INT := 0;
    cur_id       : DINT := 0;
    cur_location : DINT := 0;
    seq_counter  : DINT := 0;

    pos_tol  : DINT := 20;
    vel_tol  : DINT := 100;
    home_tol : DINT := 20;

    HOME_A   : DINT := 0;
    HOME_B   : DINT := 0;
    HOME_C   : DINT := 15000;
    HOME_D   : DINT := 15000;
    HOME_S3  : DINT := 0;
    HOME_S4_0: DINT := 0;
    HOME_S4_1: DINT := 5000;

    STATION1 : DINT := -360000;
    STATION2 : DINT := -230000;
    STATION3 : DINT := 490000;
    STATION4 : DINT := 1140000;

    FORK_CONN: DINT := 18000;
    FORK_RET : DINT := 0;

    default_rate : DINT := 500;

    lift_target : DINT;
    origin_station : DINT;
    arrived : BOOL;
    all_home : BOOL;
    cancel_now : BOOL;
    y2_latch : BOOL := FALSE;
END_VAR

(* ============ default (parked / home) outputs ============ *)
D2000 := HOME_A;   D2001 := default_rate; D2002 := 0; Y40 := TRUE;
D2004 := FORK_RET; D2005 := default_rate; D2006 := 0; Y41 := TRUE;
D2008 := HOME_C;   D2009 := default_rate; D2010 := 0; Y42 := TRUE;
D2012 := HOME_D;   D2013 := default_rate; D2014 := 0; Y43 := TRUE;
D2016 := HOME_S3;  D2017 := default_rate; D2018 := 0; Y44 := TRUE;
D2020 := HOME_S3;  D2021 := default_rate; D2022 := 0; Y45 := TRUE;
D2024 := HOME_S3;  D2025 := default_rate; D2026 := 0; Y46 := TRUE;
D2028 := HOME_S4_0;D2029 := default_rate; D2030 := 0; Y47 := TRUE;
D2032 := HOME_S4_1;D2033 := default_rate; D2034 := 0; Y48 := TRUE;
Y70 := FALSE; Y71 := FALSE; Y75 := FALSE; Y76 := FALSE;

(* origin station for active request *)
IF cur_location = 1 THEN
    origin_station := STATION1;
ELSE
    origin_station := STATION2;
END_IF;

(* ============ cancellation watch ============ *)
cancel_now := FALSE;
IF cur_req = 0 THEN
    cancel_now := X31;
ELSIF cur_req = 1 THEN
    cancel_now := X35;
END_IF;

IF cancel_now AND (main_phase >= 1) AND (main_phase <= 18) THEN
    main_phase := 50;
    sub_phase := 0;
END_IF;

(* ============ main sequencer ============ *)
CASE main_phase OF

0: (* SELECT next request *)
    IF cur_req = 0 THEN
        IF D100 <> 0 THEN
            cur_id := D100; cur_location := D101; main_phase := 1;
        END_IF;
    ELSIF cur_req = 1 THEN
        IF D120 <> 0 THEN
            cur_id := D120; cur_location := D121; main_phase := 1;
        END_IF;
    ELSE
        main_phase := 90;
    END_IF;

1: (* LIFT_RAISE to source dock height *)
    lift_target := D92;
    IF cur_location = 1 THEN
        D2008 := lift_target;
        arrived := (ABS(D1008 - lift_target) <= pos_tol) AND (ABS(D1009) <= vel_tol);
    ELSE
        D2012 := lift_target;
        arrived := (ABS(D1012 - lift_target) <= pos_tol) AND (ABS(D1013) <= vel_tol);
    END_IF;
    IF arrived THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D80 := 1;
        D81 := cur_location;
        main_phase := 2;
    END_IF;

2: (* FORK connect at origin - handover jig lift -> shuttle *)
    D2004 := FORK_CONN;
    arrived := (ABS(D1004 - FORK_CONN) <= pos_tol) AND (ABS(D1005) <= vel_tol);
    IF arrived THEN main_phase := 3; END_IF;

3: (* FORK retract at origin *)
    D2004 := FORK_RET;
    arrived := (ABS(D1004 - FORK_RET) <= pos_tol) AND (ABS(D1005) <= vel_tol);
    IF arrived THEN main_phase := 4; END_IF;

4: (* SHUTTLE to cell3 station *)
    D2000 := STATION3;
    arrived := (ABS(D1000 - STATION3) <= pos_tol) AND (ABS(D1001) <= vel_tol);
    IF arrived THEN main_phase := 5; END_IF;

5: (* FORK connect at cell3 *)
    D2004 := FORK_CONN;
    arrived := (ABS(D1004 - FORK_CONN) <= pos_tol) AND (ABS(D1005) <= vel_tol);
    IF arrived THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D80 := 2;
        D81 := 3;
        sub_phase := 0;
        main_phase := 6;
    END_IF;

6: (* CELL3 pocket axes staged extension - one axis beyond 80mm at a time *)
    Y70 := TRUE; Y71 := TRUE;
    D700 := cur_location; D701 := cur_location; D702 := 500;
    CASE sub_phase OF
        0:
            D2016 := D500;
            arrived := (ABS(D1016 - D500) <= pos_tol) AND (ABS(D1017) <= vel_tol);
            IF arrived THEN sub_phase := 1; END_IF;
        1:
            D2016 := D500; D2020 := D501;
            arrived := (ABS(D1020 - D501) <= pos_tol) AND (ABS(D1021) <= vel_tol);
            IF arrived THEN sub_phase := 2; END_IF;
        2:
            D2016 := D500; D2020 := D501; D2024 := D502;
            arrived := (ABS(D1024 - D502) <= pos_tol) AND (ABS(D1025) <= vel_tol);
            IF arrived THEN sub_phase := 3; END_IF;
        3:
            D2016 := D500; D2020 := D501; D2024 := D502;
            main_phase := 7;
    END_CASE;

7: (* WAIT for cell3 result maintained 80ms -> X70 *)
    D2016 := D500; D2020 := D501; D2024 := D502;
    Y70 := TRUE; Y71 := TRUE;
    D700 := cur_location; D701 := cur_location; D702 := 500;
    IF X70 THEN
        sub_phase := 0;
        main_phase := 8;
    END_IF;

8: (* Retract pocket axes then fork *)
    CASE sub_phase OF
        0:
            D2016 := HOME_S3; D2020 := HOME_S3; D2024 := HOME_S3;
            arrived := (ABS(D1016 - HOME_S3) <= home_tol) AND
                       (ABS(D1020 - HOME_S3) <= home_tol) AND
                       (ABS(D1024 - HOME_S3) <= home_tol);
            IF arrived THEN sub_phase := 1; END_IF;
        1:
            D2016 := HOME_S3; D2020 := HOME_S3; D2024 := HOME_S3;
            D2004 := FORK_RET;
            arrived := (ABS(D1004 - FORK_RET) <= pos_tol) AND (ABS(D1005) <= vel_tol);
            IF arrived THEN main_phase := 9; END_IF;
    END_CASE;

9: (* SHUTTLE to cell4 station *)
    D2000 := STATION4;
    arrived := (ABS(D1000 - STATION4) <= pos_tol) AND (ABS(D1001) <= vel_tol);
    IF arrived THEN main_phase := 10; END_IF;

10: (* FORK connect at cell4 *)
    D2004 := FORK_CONN;
    arrived := (ABS(D1004 - FORK_CONN) <= pos_tol) AND (ABS(D1005) <= vel_tol);
    IF arrived THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D80 := 2;
        D81 := 4;
        sub_phase := 0;
        main_phase := 11;
    END_IF;

11: (* CELL4: rotate at slide<=500 then approach to goal1 *)
    Y75 := TRUE; Y76 := TRUE;
    D710 := cur_location; D711 := cur_location; D712 := 500;
    CASE sub_phase OF
        0:
            D2032 := HOME_S4_1;
            D2028 := D600;
            arrived := (ABS(D1028 - D600) <= pos_tol) AND (ABS(D1029) <= vel_tol);
            IF arrived THEN sub_phase := 1; END_IF;
        1:
            D2028 := D600;
            D2032 := D601;
            arrived := (ABS(D1032 - D601) <= pos_tol) AND (ABS(D1033) <= vel_tol);
            IF arrived THEN main_phase := 12; END_IF;
    END_CASE;

12: (* WAIT for cell4 result -> X75 *)
    D2028 := D600; D2032 := D601;
    Y75 := TRUE; Y76 := TRUE;
    D710 := cur_location; D711 := cur_location; D712 := 500;
    IF X75 THEN
        sub_phase := 0;
        main_phase := 13;
    END_IF;

13: (* Retract table then fork *)
    CASE sub_phase OF
        0:
            D2032 := HOME_S4_1; D2028 := HOME_S4_0;
            arrived := (ABS(D1032 - HOME_S4_1) <= home_tol) AND
                       (ABS(D1028 - HOME_S4_0) <= home_tol);
            IF arrived THEN sub_phase := 1; END_IF;
        1:
            D2032 := HOME_S4_1; D2028 := HOME_S4_0;
            D2004 := FORK_RET;
            arrived := (ABS(D1004 - FORK_RET) <= pos_tol) AND (ABS(D1005) <= vel_tol);
            IF arrived THEN main_phase := 14; END_IF;
    END_CASE;

14: (* SHUTTLE back to origin lift station *)
    D2000 := origin_station;
    arrived := (ABS(D1000 - origin_station) <= pos_tol) AND (ABS(D1001) <= vel_tol);
    IF arrived THEN main_phase := 15; END_IF;

15: (* FORK connect at origin - handover shuttle -> lift *)
    D2004 := FORK_CONN;
    arrived := (ABS(D1004 - FORK_CONN) <= pos_tol) AND (ABS(D1005) <= vel_tol);
    IF arrived THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D80 := 2;
        D81 := cur_location;
        main_phase := 16;
    END_IF;

16: (* FORK retract at origin *)
    D2004 := FORK_RET;
    arrived := (ABS(D1004 - FORK_RET) <= pos_tol) AND (ABS(D1005) <= vel_tol);
    IF arrived THEN main_phase := 17; END_IF;

17: (* LIFT down to home height *)
    IF cur_location = 1 THEN
        D2008 := HOME_C;
        arrived := (ABS(D1008 - HOME_C) <= pos_tol) AND (ABS(D1009) <= vel_tol);
    ELSE
        D2012 := HOME_D;
        arrived := (ABS(D1012 - HOME_D) <= pos_tol) AND (ABS(D1013) <= vel_tol);
    END_IF;
    IF arrived THEN main_phase := 18; END_IF;

18: (* wait returned confirmation then respond completion *)
    arrived := FALSE;
    IF cur_req = 0 THEN
        IF X30 THEN arrived := TRUE; END_IF;
    ELSE
        IF X34 THEN arrived := TRUE; END_IF;
    END_IF;
    IF arrived THEN
        IF cur_req = 0 THEN
            D300 := cur_id; D301 := 1;
        ELSE
            D302 := cur_id; D303 := 1;
        END_IF;
        main_phase := 19;
    END_IF;

19: (* advance to next request *)
    cur_req := cur_req + 1;
    main_phase := 0;

50: (* ABORT: retract pocket & table axes, deconfigure *)
    Y70 := FALSE; Y71 := FALSE; Y75 := FALSE; Y76 := FALSE;
    D2016 := HOME_S3; D2020 := HOME_S3; D2024 := HOME_S3;
    D2028 := HOME_S4_0; D2032 := HOME_S4_1;
    arrived := (ABS(D1016 - HOME_S3) <= home_tol) AND
               (ABS(D1020 - HOME_S3) <= home_tol) AND
               (ABS(D1024 - HOME_S3) <= home_tol) AND
               (ABS(D1028 - HOME_S4_0) <= home_tol) AND
               (ABS(D1032 - HOME_S4_1) <= home_tol);
    IF arrived THEN main_phase := 51; END_IF;

51: (* ABORT: ensure fork retracted *)
    D2004 := FORK_RET;
    arrived := (ABS(D1004 - FORK_RET) <= pos_tol) AND (ABS(D1005) <= vel_tol);
    IF arrived THEN main_phase := 52; END_IF;

52: (* ABORT: shuttle back to origin lift station *)
    D2000 := origin_station;
    arrived := (ABS(D1000 - origin_station) <= pos_tol) AND (ABS(D1001) <= vel_tol);
    IF arrived THEN main_phase := 53; END_IF;

53: (* ABORT: fork connect at origin - handover back to lift *)
    D2004 := FORK_CONN;
    arrived := (ABS(D1004 - FORK_CONN) <= pos_tol) AND (ABS(D1005) <= vel_tol);
    IF arrived THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D80 := 2;
        D81 := cur_location;
        main_phase := 54;
    END_IF;

54: (* ABORT: fork retract at origin *)
    D2004 := FORK_RET;
    arrived := (ABS(D1004 - FORK_RET) <= pos_tol) AND (ABS(D1005) <= vel_tol);
    IF arrived THEN main_phase := 55; END_IF;

55: (* ABORT: lift down to home *)
    IF cur_location = 1 THEN
        D2008 := HOME_C;
        arrived := (ABS(D1008 - HOME_C) <= pos_tol) AND (ABS(D1009) <= vel_tol);
    ELSE
        D2012 := HOME_D;
        arrived := (ABS(D1012 - HOME_D) <= pos_tol) AND (ABS(D1013) <= vel_tol);
    END_IF;
    IF arrived THEN main_phase := 56; END_IF;

56: (* ABORT: wait returned, respond cancellation retrieval *)
    arrived := FALSE;
    IF cur_req = 0 THEN
        IF X30 THEN arrived := TRUE; END_IF;
    ELSE
        IF X34 THEN arrived := TRUE; END_IF;
    END_IF;
    IF arrived THEN
        IF cur_req = 0 THEN
            D300 := cur_id; D301 := 2;
        ELSE
            D302 := cur_id; D303 := 2;
        END_IF;
        main_phase := 57;
    END_IF;

57: (* ABORT: advance to next request *)
    cur_req := cur_req + 1;
    main_phase := 0;

90: (* ALL requests handled - park at global home posture and declare completion *)
    all_home := (ABS(D1000 - HOME_A) <= pos_tol) AND
                (ABS(D1004 - HOME_B) <= pos_tol) AND
                (ABS(D1008 - HOME_C) <= pos_tol) AND
                (ABS(D1012 - HOME_D) <= pos_tol) AND
                (ABS(D1016 - HOME_S3) <= pos_tol) AND
                (ABS(D1020 - HOME_S3) <= pos_tol) AND
                (ABS(D1024 - HOME_S3) <= pos_tol) AND
                (ABS(D1028 - HOME_S4_0) <= pos_tol) AND
                (ABS(D1032 - HOME_S4_1) <= pos_tol);
    IF all_home THEN
        y2_latch := TRUE;
        main_phase := 91;
    END_IF;

91: (* COMPLETED - maintain home posture and Y2 *)
    ;

ELSE
    main_phase := 0;
END_CASE;

(* ============ brake control: engage except while shuttle travels ============ *)
IF (main_phase = 4) OR (main_phase = 9) OR (main_phase = 14) OR (main_phase = 52) THEN
    Y30 := FALSE;
ELSE
    Y30 := TRUE;
END_IF;

Y2 := y2_latch;

END_PROGRAM