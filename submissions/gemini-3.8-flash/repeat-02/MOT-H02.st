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

    step : INT := 0;
    seq_counter : DINT := 1;
    curr_req_ch : INT := -1;
    curr_req_id : DINT := 0;
    curr_lift_station : DINT := 1;
    curr_status : DINT := 1;

    m3_hold_timer : DINT := 0;
    m4_hold_timer : DINT := 0;
    settle_timer : DINT := 0;
    complete_timer : DINT := 0;
    init_done : BOOL := FALSE;

    c0_done : BOOL := FALSE;
    c1_done : BOOL := FALSE;
    last_r0_id : DINT := 0;
    last_r1_id : DINT := 0;
END_VAR

IF NOT init_done THEN
    D2000 := 0;
    D2001 := 1000;
    D2002 := 0;
    Y40 := TRUE;

    D2004 := 0;
    D2005 := 1000;
    D2006 := 0;
    Y41 := TRUE;

    D2008 := 40000;
    D2009 := 1000;
    D2010 := 0;
    Y42 := TRUE;

    D2012 := 40000;
    D2013 := 1000;
    D2014 := 0;
    Y43 := TRUE;

    D2016 := -60000;
    D2017 := 1000;
    D2018 := 0;
    Y44 := TRUE;

    D2020 := -60000;
    D2021 := 1000;
    D2022 := 0;
    Y45 := TRUE;

    D2024 := -60000;
    D2025 := 1000;
    D2026 := 0;
    Y46 := TRUE;

    D2028 := -60000;
    D2029 := 1000;
    D2030 := 0;
    Y47 := TRUE;

    Y30 := FALSE;
    Y2 := FALSE;
    Y70 := FALSE;
    Y71 := FALSE;
    Y75 := FALSE;
    Y76 := FALSE;
    D80 := 0;
    D81 := 0;
    D82 := 0;
    init_done := TRUE;
END_VAR

IF (D100 <> last_r0_id) AND (D100 > 0) THEN
    c0_done := FALSE;
    last_r0_id := D100;
END_IF;
IF (D120 <> last_r1_id) AND (D120 > 0) THEN
    c1_done := FALSE;
    last_r1_id := D120;
END_IF;

CASE step OF
    0: (* IDLE: wait for requests or all_done *)
        IF NOT c0_done AND (D100 > 0) THEN
            curr_req_ch := 0;
            curr_req_id := D100;
            IF D101 = 2 THEN
                curr_lift_station := 2;
            ELSE
                curr_lift_station := 1;
            END_IF;
            IF X31 THEN
                curr_status := 2;
            ELSE
                curr_status := 1;
            END_IF;
            step := 10;
        ELSIF NOT c1_done AND (D120 > 0) THEN
            curr_req_ch := 1;
            curr_req_id := D120;
            IF D121 = 2 THEN
                curr_lift_station := 2;
            ELSE
                curr_lift_station := 1;
            END_IF;
            IF X35 THEN
                curr_status := 2;
            ELSE
                curr_status := 1;
            END_IF;
            step := 10;
        ELSIF X51 THEN
            step := 900;
        END_IF;

    (* LIFT ENTRY & PICKUP *)
    10: (* Lift to docking height 950 mm *)
        IF curr_lift_station = 1 THEN
            IF D92 <> 0 THEN
                D2008 := D92;
            ELSE
                D2008 := 95000;
            END_IF;
        ELSE
            IF D92 <> 0 THEN
                D2012 := D92;
            ELSE
                D2012 := 95000;
            END_IF;
        END_IF;
        step := 11;

    11: (* Wait for lift in position and ready *)
        IF ((curr_lift_station = 1 AND X61) OR (curr_lift_station = 2 AND X62)) OR
           ((curr_lift_station = 1 AND ABS(D1008 - D2008) <= 20 AND ABS(D1009) <= 100) OR
            (curr_lift_station = 2 AND ABS(D1012 - D2012) <= 20 AND ABS(D1013) <= 100)) THEN
            IF curr_lift_station = 1 THEN
                IF D403 <> 0 THEN
                    D2000 := D403;
                ELSE
                    D2000 := -405000;
                END_IF;
            ELSE
                IF D406 <> 0 THEN
                    D2000 := D406;
                ELSE
                    D2000 := -185000;
                END_IF;
            END_IF;
            step := 12;
        END_IF;

    12: (* Shuttle arrived at lift dock *)
        IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 THEN
            D2004 := 18000; (* Extend connection fork *)
            step := 13;
        END_IF;

    13: (* Fork extended to 180 mm *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 1; (* 1 extraction *)
            D81 := curr_lift_station;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            settle_timer := 0;
            step := 14;
        END_IF;

    14: (* Coupling wait and retract fork *)
        settle_timer := settle_timer + 20;
        IF settle_timer >= 60 THEN
            D2004 := 0; (* Retract fork *)
            step := 15;
        END_IF;

    15: (* Fork retracted to 0 mm *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            IF (curr_req_ch = 0 AND X31) OR (curr_req_ch = 1 AND X35) THEN
                curr_status := 2;
                step := 100; (* Cancelled: return to lift *)
            ELSE
                step := 20; (* Proceed to Cell 3 *)
            END_IF;
        END_IF;

    (* CELL 3 OPERATIONS *)
    20: (* Move shuttle to Cell 3 *)
        IF D409 <> 0 THEN
            D2000 := D409;
        ELSE
            D2000 := 0;
        END_IF;
        step := 21;

    21: (* Wait shuttle at Cell 3 *)
        IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 THEN
            D2004 := 18000; (* Extend fork *)
            step := 22;
        END_IF;

    22: (* Fork extended at Cell 3 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 2; (* 2 placement *)
            D81 := 3;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            settle_timer := 0;
            step := 23;
        END_IF;

    23: (* Placement complete, retract fork *)
        settle_timer := settle_timer + 20;
        IF settle_timer >= 60 THEN
            D2004 := 0;
            step := 24;
        END_IF;

    24: (* Fork retracted, start Cell 3 gantry motion *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            D2016 := D500;
            D2020 := D501;
            step := 25;
        END_IF;

    25: (* Gantry at goal, hold for 80 ms *)
        IF ABS(D1016 - D2016) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - D2020) <= 20 AND ABS(D1021) <= 100 THEN
            m3_hold_timer := m3_hold_timer + 20;
            IF m3_hold_timer >= 80 OR X70 THEN
                D2016 := -60000;
                D2020 := -60000;
                m3_hold_timer := 0;
                step := 26;
            END_IF;
        ELSE
            m3_hold_timer := 0;
        END_IF;

    26: (* Gantry returned to home posture *)
        IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 THEN
            D2004 := 18000; (* Extend fork to retrieve jig *)
            step := 27;
        END_IF;

    27: (* Fork extended for extraction from Cell 3 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 1; (* 1 extraction *)
            D81 := 3;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            settle_timer := 0;
            step := 28;
        END_IF;

    28: (* Jig extracted, retract fork *)
        settle_timer := settle_timer + 20;
        IF settle_timer >= 60 THEN
            D2004 := 0;
            step := 29;
        END_IF;

    29: (* Fork retracted at Cell 3 *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            IF (curr_req_ch = 0 AND X31) OR (curr_req_ch = 1 AND X35) THEN
                curr_status := 2;
                step := 100; (* Cancelled: return to lift *)
            ELSE
                step := 40; (* Proceed to Cell 4 *)
            END_IF;
        END_IF;

    (* CELL 4 OPERATIONS *)
    40: (* Move shuttle to Cell 4 *)
        IF D412 <> 0 THEN
            D2000 := D412;
        ELSE
            D2000 := 470000;
        END_IF;
        step := 41;

    41: (* Shuttle arrived at Cell 4 *)
        IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 THEN
            D2004 := 18000; (* Extend fork *)
            step := 42;
        END_IF;

    42: (* Fork extended at Cell 4 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 2; (* 2 placement *)
            D81 := 4;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            settle_timer := 0;
            step := 43;
        END_IF;

    43: (* Placement complete, retract fork *)
        settle_timer := settle_timer + 20;
        IF settle_timer >= 60 THEN
            D2004 := 0;
            step := 44;
        END_IF;

    44: (* Fork retracted, move Cell 4 axes to goal *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            D2024 := D600;
            D2028 := D601;
            step := 45;
        END_IF;

    45: (* Cell 4 at goal, configure reference axis *)
        IF ABS(D1024 - D2024) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028 - D2028) <= 20 AND ABS(D1029) <= 100 THEN
            Y75 := TRUE; (* Assert configure pulse while stopped *)
            step := 46;
        END_IF;

    46: (* Deassert configure and hold result for 80 ms *)
        Y75 := FALSE;
        m4_hold_timer := m4_hold_timer + 20;
        IF m4_hold_timer >= 80 OR X75 THEN
            D2024 := -60000;
            D2028 := -60000;
            m4_hold_timer := 0;
            step := 47;
        END_IF;

    47: (* Cell 4 axes returned to initial connection posture *)
        IF ABS(D1024 - (-60000)) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028 - (-60000)) <= 20 AND ABS(D1029) <= 100 THEN
            D2004 := 18000; (* Extend fork to retrieve jig *)
            step := 48;
        END_IF;

    48: (* Fork extended for extraction from Cell 4 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 1; (* 1 extraction *)
            D81 := 4;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            settle_timer := 0;
            step := 49;
        END_IF;

    49: (* Jig extracted, retract fork *)
        settle_timer := settle_timer + 20;
        IF settle_timer >= 60 THEN
            D2004 := 0;
            step := 50;
        END_IF;

    50: (* Fork retracted at Cell 4, return to lift *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            step := 100;
        END_IF;

    (* RETURN TO LIFT SECTION *)
    100: (* Move shuttle back to original lift station *)
        IF curr_lift_station = 1 THEN
            IF D403 <> 0 THEN
                D2000 := D403;
            ELSE
                D2000 := -405000;
            END_IF;
        ELSE
            IF D406 <> 0 THEN
                D2000 := D406;
            ELSE
                D2000 := -185000;
            END_IF;
        END_IF;
        step := 101;

    101: (* Shuttle back at lift station *)
        IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 THEN
            D2004 := 18000; (* Extend fork *)
            step := 102;
        END_IF;

    102: (* Fork extended at lift station *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 2; (* 2 placement *)
            D81 := curr_lift_station;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            settle_timer := 0;
            step := 103;
        END_IF;

    103: (* Placement complete, retract fork *)
        settle_timer := settle_timer + 20;
        IF settle_timer >= 60 THEN
            D2004 := 0;
            step := 104;
        END_IF;

    104: (* Fork retracted, return lift to initial height *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            IF curr_lift_station = 1 THEN
                D2008 := 40000; (* Initial height 400 mm *)
            ELSE
                D2012 := 40000; (* Initial height 400 mm *)
            END_IF;
            step := 105;
        END_IF;

    105: (* Lift returned to initial height and stopped *)
        IF (curr_lift_station = 1 AND ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100) OR
           (curr_lift_station = 2 AND ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100) THEN
            (* Acknowledge request *)
            IF curr_req_ch = 0 THEN
                D300 := curr_req_id;
                D301 := curr_status;
                c0_done := TRUE;
            ELSE
                D302 := curr_req_id;
                D303 := curr_status;
                c1_done := TRUE;
            END_IF;
            step := 106;
        END_IF;

    106: (* Return shuttle to 0 mm *)
        D2000 := 0;
        step := 107;

    107: (* Shuttle back at 0 mm *)
        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 THEN
            step := 0; (* Ready for next request *)
        END_IF;

    (* FINAL COMPLETION *)
    900: (* Ensure all axes at initial home posture *)
        D2000 := 0;
        D2004 := 0;
        D2008 := 40000;
        D2012 := 40000;
        D2016 := -60000;
        D2020 := -60000;
        D2024 := -60000;
        D2028 := -60000;
        D80 := 0;
        D81 := 0;
        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024 - (-60000)) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028 - (-60000)) <= 20 AND ABS(D1029) <= 100 THEN
            Y2 := TRUE;
            complete_timer := complete_timer + 20;
            IF complete_timer >= 100 THEN
                step := 999;
            END_IF;
        ELSE
            complete_timer := 0;
            Y2 := FALSE;
        END_IF;

    999: (* Completed state preserved *)
        Y2 := TRUE;
END_CASE;

END_PROGRAM