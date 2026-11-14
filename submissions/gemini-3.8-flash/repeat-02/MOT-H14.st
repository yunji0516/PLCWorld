An IEC 61131-3 Structured Text control program implementing the MOT-H14 specifications.

```iecst
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

    (* Internal State Machine Variables *)
    state : INT := 0;
    sub_state : INT := 0;
    seq_cnt : DINT := 1;

    curr_req_id : DINT := 0;
    curr_req_ch : INT := -1;     (* 0 for r0, 1 for r1 *)
    curr_origin_station : DINT := 0; (* 1 for Lift A, 2 for Lift B *)
    is_cancelled : BOOL := FALSE;

    (* Lift target management *)
    target_c : DINT := 15000;
    target_d : DINT := 15000;

    (* Shuttle and Fork targets *)
    target_a : DINT := 0;
    target_b : DINT := 0;

    (* Cell 3 targets *)
    target_s3_0 : DINT := -60000;
    target_s3_1 : DINT := -60000;

    (* Cell 4 targets *)
    target_s4_0 : DINT := -60000;
    target_s4_1 : DINT := -60000;

    (* Timers & settling counters *)
    settle_cnt : DINT := 0;
    m3_hold_cnt : DINT := 0;
    m4_hold_cnt : DINT := 0;

    (* Request tracking *)
    r0_finished : BOOL := FALSE;
    r1_finished : BOOL := FALSE;

    (* Cached references *)
    last_known_epoch : DINT := 0;
END_VAR

(* Set drive rates and feed-forward *)
D2001 := 1000;
D2002 := 0;
D2005 := 1000;
D2006 := 0;
D2009 := 1000;
D2010 := 0;
D2013 := 1000;
D2014 := 0;
D2017 := 1000;
D2018 := 0;
D2021 := 1000;
D2022 := 0;
D2025 := 1000;
D2026 := 0;
D2029 := 1000;
D2030 := 0;

(* Enable all active axes *)
Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;

(* Defaults for cell configs *)
Y70 := FALSE;
Y71 := FALSE;
Y75 := FALSE;
Y76 := FALSE;
Y30 := FALSE;

(* Main State Machine *)
CASE state OF
    0: (* Idle / Select next request *)
        IF NOT r0_finished AND D100 > 0 AND NOT X30 THEN
            curr_req_id := D100;
            curr_req_ch := 0;
            curr_origin_station := 1;
            is_cancelled := X31;
            state := 10;
            sub_state := 0;
        ELSIF NOT r1_finished AND D120 > 0 AND NOT X34 THEN
            curr_req_id := D120;
            curr_req_ch := 1;
            curr_origin_station := 2;
            is_cancelled := X35;
            state := 10;
            sub_state := 0;
        ELSIF (r0_finished OR D100 = 0 OR X30) AND (r1_finished OR D120 = 0 OR X34) THEN
            IF X51 THEN
                state := 900; (* All done, move to park and declare completion *)
            END IF;
        END IF;

    10: (* Raise corresponding lift to source_dock height *)
        IF curr_origin_station = 1 THEN
            target_c := D92;
            IF ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    state := 20;
                END IF;
            ELSE
                settle_cnt := 0;
            END IF;
        ELSE
            target_d := D92;
            IF ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    state := 20;
                END IF;
            ELSE
                settle_cnt := 0;
            END IF;
        END IF;

    20: (* Move Shuttle A to Lift docking X *)
        IF curr_origin_station = 1 THEN
            target_a := D403;
            IF ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100 AND X61 THEN
                state := 30;
                sub_state := 0;
            END IF;
        ELSE
            target_a := D406;
            IF ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100 AND X62 THEN
                state := 30;
                sub_state := 0;
            END IF;
        END IF;

    30: (* Extract fixture from Lift *)
        CASE sub_state OF
            0:
                D80 := 1; (* Extraction *)
                D81 := curr_origin_station;
                D82 := seq_cnt;
                seq_cnt := seq_cnt + 1;
                target_b := 18000;
                sub_state := 1;
            1:
                IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                    target_b := 0;
                    sub_state := 2;
                END IF;
            2:
                IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND D90 = curr_req_id THEN
                    D80 := 0;
                    D81 := 0;
                    IF is_cancelled THEN
                        state := 200; (* Cancellation: return back immediately *)
                    ELSE
                        state := 40;  (* Normal processing: proceed to Cell 3 *)
                    END IF;
                END IF;
        END CASE;

    40: (* Move Shuttle to Cell 3 *)
        target_a := D409;
        IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 AND X63 THEN
            state := 50;
            sub_state := 0;
        END IF;

    50: (* Place fixture into Cell 3 *)
        CASE sub_state OF
            0:
                D80 := 2; (* Placement *)
                D81 := 3;
                D82 := seq_cnt;
                seq_cnt := seq_cnt + 1;
                target_b := 18000;
                sub_state := 1;
            1:
                IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                    target_b := 0;
                    sub_state := 2;
                END IF;
            2:
                IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND D410 = curr_req_id THEN
                    D80 := 0;
                    D81 := 0;
                    state := 60;
                    sub_state := 0;
                END IF;
        END CASE;

    60: (* Cell 3 Process: Alignment *)
        D700 := curr_req_id;
        CASE sub_state OF
            0: (* Ensure stopped at initial reference posture *)
                IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
                   ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 THEN
                    Y70 := TRUE; (* Configure reference frame while stopped *)
                    sub_state := 1;
                END IF;
            1:
                Y70 := FALSE;
                target_s3_0 := D500;
                target_s3_1 := D501;
                sub_state := 2;
            2:
                IF ABS(D1016 - target_s3_0) <= 20 AND ABS(D1017) <= 100 AND
                   ABS(D1020 - target_s3_1) <= 20 AND ABS(D1021) <= 100 THEN
                    m3_hold_cnt := m3_hold_cnt + 1;
                    IF m3_hold_cnt >= 5 OR X70 THEN
                        m3_hold_cnt := 0;
                        target_s3_0 := -60000;
                        target_s3_1 := -60000;
                        sub_state := 3;
                    END IF;
                ELSE
                    m3_hold_cnt := 0;
                END IF;
            3:
                IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
                   ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 THEN
                    state := 70;
                    sub_state := 0;
                END IF;
        END CASE;

    70: (* Retrieve fixture from Cell 3 *)
        CASE sub_state OF
            0:
                D80 := 1; (* Extraction *)
                D81 := 3;
                D82 := seq_cnt;
                seq_cnt := seq_cnt + 1;
                target_b := 18000;
                sub_state := 1;
            1:
                IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                    target_b := 0;
                    sub_state := 2;
                END IF;
            2:
                IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND D90 = curr_req_id THEN
                    D80 := 0;
                    D81 := 0;
                    state := 80;
                END IF;
        END CASE;

    80: (* Move Shuttle to Cell 4 *)
        target_a := D412;
        IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 AND X64 THEN
            state := 90;
            sub_state := 0;
        END IF;

    90: (* Place fixture into Cell 4 *)
        CASE sub_state OF
            0:
                D80 := 2; (* Placement *)
                D81 := 4;
                D82 := seq_cnt;
                seq_cnt := seq_cnt + 1;
                target_b := 18000;
                sub_state := 1;
            1:
                IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                    target_b := 0;
                    sub_state := 2;
                END IF;
            2:
                IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND D413 = curr_req_id THEN
                    D80 := 0;
                    D81 := 0;
                    state := 100;
                    sub_state := 0;
                END IF;
        END CASE;

    100: (* Cell 4 Process: Registration *)
        D710 := curr_req_id;
        CASE sub_state OF
            0:
                last_known_epoch := D91;
                target_s4_0 := D600;
                sub_state := 1;
            1:
                IF D91 <> last_known_epoch THEN
                    (* Reference changed: update epoch and target *)
                    last_known_epoch := D91;
                    target_s4_0 := D600;
                END IF;
                IF D622 = curr_req_id AND D624 = D91 THEN
                    (* Capture occurred: stop at captured value + 250 mm *)
                    target_s4_0 := D623 + 25000;
                    sub_state := 2;
                END IF;
            2:
                IF D91 <> last_known_epoch THEN
                    last_known_epoch := D91;
                    target_s4_0 := D600;
                    sub_state := 1;
                ELSIF ABS(D1024 - target_s4_0) <= 20 AND ABS(D1025) <= 100 THEN
                    m4_hold_cnt := m4_hold_cnt + 1;
                    IF m4_hold_cnt >= 5 OR X75 THEN
                        m4_hold_cnt := 0;
                        target_s4_0 := -60000;
                        sub_state := 3;
                    END IF;
                ELSE
                    m4_hold_cnt := 0;
                END IF;
            3:
                IF ABS(D1024 - (-60000)) <= 20 AND ABS(D1025) <= 100 THEN
                    state := 110;
                    sub_state := 0;
                END IF;
        END CASE;

    110: (* Retrieve fixture from Cell 4 *)
        CASE sub_state OF
            0:
                D80 := 1; (* Extraction *)
                D81 := 4;
                D82 := seq_cnt;
                seq_cnt := seq_cnt + 1;
                target_b := 18000;
                sub_state := 1;
            1:
                IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                    target_b := 0;
                    sub_state := 2;
                END IF;
            2:
                IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND D90 = curr_req_id THEN
                    D80 := 0;
                    D81 := 0;
                    state := 200;
                    sub_state := 0;
                END IF;
        END CASE;

    200: (* Return fixture to original lift *)
        IF curr_origin_station = 1 THEN
            target_a := D403;
            IF ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100 AND X61 THEN
                state := 210;
                sub_state := 0;
            END IF;
        ELSE
            target_a := D406;
            IF ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100 AND X62 THEN
                state := 210;
                sub_state := 0;
            END IF;
        END IF;

    210: (* Place fixture into original Lift *)
        CASE sub_state OF
            0:
                D80 := 2; (* Placement *)
                D81 := curr_origin_station;
                D82 := seq_cnt;
                seq_cnt := seq_cnt + 1;
                target_b := 18000;
                sub_state := 1;
            1:
                IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                    target_b := 0;
                    sub_state := 2;
                END IF;
            2:
                IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                    D80 := 0;
                    D81 := 0;
                    state := 220;
                    sub_state := 0;
                END IF;
        END CASE;

    220: (* Descend lift to initial height (150 mm) *)
        IF curr_origin_station = 1 THEN
            target_c := 15000;
            IF ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    state := 230;
                END IF;
            ELSE
                settle_cnt := 0;
            END IF;
        ELSE
            target_d := 15000;
            IF ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    state := 230;
                END IF;
            ELSE
                settle_cnt := 0;
            END IF;
        END IF;

    230: (* Ack request and return to idle *)
        IF curr_req_ch = 0 THEN
            D300 := curr_req_id;
            IF is_cancelled THEN
                D301 := 2;
            ELSE
                D301 := 1;
            END IF;
            r0_finished := TRUE;
        ELSE
            D302 := curr_req_id;
            IF is_cancelled THEN
                D303 := 2;
            ELSE
                D303 := 1;
            END IF;
            r1_finished := TRUE;
        END IF;
        state := 0;

    900: (* Park shuttle and fork at initial positions *)
        target_a := 0;
        target_b := 0;
        target_c := 15000;
        target_d := 15000;
        target_s3_0 := -60000;
        target_s3_1 := -60000;
        target_s4_0 := -60000;
        target_s4_1 := -60000;

        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024 - (-60000)) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028 - (-60000)) <= 20 AND ABS(D1029) <= 100 THEN
            Y2 := TRUE;
        END IF;
END_CASE;

(* Drive targets assignment *)
D2000 := target_a;
D2004 := target_b;
D2008 := target_c;
D2012 := target_d;
D2016 := target_s3_0;
D2020 := target_s3_1;
D2024 := target_s4_0;
D2028 := target_s4_1;

END_PROGRAM
```