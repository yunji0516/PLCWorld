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
    D1040 : DINT;
    D1041 : DINT;
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
    D503 : DINT;
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
    D2040 : DINT;
    D2041 : DINT;
    D2042 : DINT;
    Y50 : BOOL;
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
    current_req : INT := 0;
    req_id : DINT := 0;
    req_loc : DINT := 0;
    req_is_cancelled : BOOL := FALSE;
    target_shuttle : DINT := 0;
    target_lift_h : DINT := 95000;
    seq_counter : DINT := 0;
    timer_cnt : INT := 0;
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;

    a_settled : BOOL;
    b_settled : BOOL;
    c_settled : BOOL;
    d_settled : BOOL;
    s3_settled : BOOL;
    s4_settled : BOOL;
END_VAR

// Check axis settled conditions (±0.20 mm or deg -> ±20 units of 0.01, speed <= 1.00 -> 100 units)
a_settled := (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100);
b_settled := (ABS(D1004 - D2004) <= 20) AND (ABS(D1005) <= 100);
c_settled := (ABS(D1008 - D2008) <= 20) AND (ABS(D1009) <= 100);
d_settled := (ABS(D1012 - D2012) <= 20) AND (ABS(D1013) <= 100);

s3_settled := (ABS(D1016 - D2016) <= 20) AND (ABS(D1017) <= 100) AND
              (ABS(D1020 - D2020) <= 20) AND (ABS(D1021) <= 100) AND
              (ABS(D1024 - D2024) <= 20) AND (ABS(D1025) <= 100) AND
              (ABS(D1028 - D2028) <= 20) AND (ABS(D1029) <= 100);

s4_settled := (ABS(D1032 - D2032) <= 20) AND (ABS(D1033) <= 100) AND
              (ABS(D1036 - D2036) <= 20) AND (ABS(D1037) <= 100) AND
              (ABS(D1040 - D2040) <= 20) AND (ABS(D1041) <= 100);

// Default axis rates and enables
Y40 := TRUE;
D2001 := 700;
D2002 := 0;

Y41 := TRUE;
D2005 := 700;
D2006 := 0;

Y42 := TRUE;
D2009 := 700;
D2010 := 0;

Y43 := TRUE;
D2013 := 700;
D2014 := 0;

Y44 := TRUE;
D2017 := 700;
D2018 := 0;

Y45 := TRUE;
D2021 := 700;
D2022 := 0;

Y46 := TRUE;
D2025 := 700;
D2026 := 0;

Y47 := TRUE;
D2029 := 700;
D2030 := 0;

Y48 := TRUE;
D2033 := 700;
D2034 := 0;

Y49 := TRUE;
D2037 := 700;
D2038 := 0;

Y50 := TRUE;
D2041 := 700;
D2042 := 0;

CASE step OF
    0: // Init / Select Request
        D2000 := 0;      // Shuttle X at 0
        D2004 := 0;      // Connection fork 0
        D2008 := 40000;  // Lift A home 400 mm
        D2012 := 40000;  // Lift B home 400 mm
        D2016 := -6500;  // s3_0 home -65 deg
        D2020 := 0;      // s3_1 home 0 mm
        D2024 := 6500;   // s3_2 home 65 deg
        D2028 := 0;      // s3_3 home 0 mm
        D2032 := -65000; // s4_0 home -650 mm
        D2036 := 65000;  // s4_1 home 650 mm
        D2040 := 0;      // s4_2 home 0 mm
        Y30 := FALSE;

        IF NOT req0_done AND (D100 > 0) THEN
            current_req := 0;
            req_id := D100;
            req_loc := D101;
            req_is_cancelled := X31;
            step := 10;
        ELSIF NOT req1_done AND (D120 > 0) THEN
            current_req := 1;
            req_id := D120;
            req_loc := D121;
            req_is_cancelled := X35;
            step := 10;
        ELSIF req0_done AND req1_done THEN
            step := 200; // All done
        END_IF;

    10: // Move lift to docking height (950 mm = 95000)
        IF D92 <> 0 THEN
            target_lift_h := D92;
        ELSE
            target_lift_h := 95000;
        END_IF;

        IF req_loc = 1 THEN
            D2008 := target_lift_h;
            target_shuttle := D403;
            IF target_shuttle = 0 THEN
                target_shuttle := -405000;
            END_IF;
        ELSE
            D2012 := target_lift_h;
            target_shuttle := D406;
            IF target_shuttle = 0 THEN
                target_shuttle := -185000;
            END_IF;
        END_IF;

        // Move shuttle X to docking position
        D2000 := target_shuttle;

        IF a_settled AND ((req_loc = 1 AND c_settled) OR (req_loc <> 1 AND d_settled)) THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 1; // Extraction
            D81 := req_loc;
            step := 12;
        END_IF;

    12: // Extend fork to connect (180 mm = 18000)
        D2004 := 18000;
        IF b_settled AND (D90 = req_id) THEN
            // Retrieved jig onto shuttle
            step := 14;
        END_IF;

    14: // Retract fork to 0 mm with jig
        D2004 := 0;
        IF b_settled THEN
            // Lower lift back to home 400 mm
            IF req_loc = 1 THEN
                D2008 := 40000;
            ELSE
                D2012 := 40000;
            END_IF;
            
            IF req_is_cancelled THEN
                step := 100; // Skip cell processing, return jig
            ELSE
                step := 20; // Move to Cell 3
            END_IF;
        END_IF;

    20: // Move shuttle to Cell 3 (Port 3)
        IF D409 <> 0 THEN
            D2000 := D409;
        ELSE
            D2000 := 0; // Nominal 0 mm
        END_IF;

        IF a_settled THEN
            step := 22;
        END_IF;

    22: // Process in Cell 3: Apply goal parameters
        D2016 := D500;
        D2020 := D501;
        D2024 := D502;
        D2028 := D503;
        Y70 := TRUE;

        IF s3_settled AND X70 THEN
            // Cell 3 completed, retract boom to <= 80 mm before swivel
            step := 24;
        END_IF;

    24: // Retract boom to <= 80 mm (e.g. 0 mm)
        D2020 := 0;
        D2028 := 0;
        IF (ABS(D1020) <= 8000) AND (ABS(D1028) <= 8000) THEN
            // Swivel back to home coordinates
            D2016 := -6500;
            D2024 := 6500;
            step := 26;
        END_IF;

    26: // Wait for Cell 3 home settled
        IF s3_settled THEN
            Y70 := FALSE;
            step := 30; // Move to Cell 4
        END_IF;

    30: // Move shuttle to Cell 4 (Port 4)
        IF D412 <> 0 THEN
            D2000 := D412;
        ELSE
            D2000 := 670000; // Nominal 6700 mm
        END_IF;

        IF a_settled THEN
            step := 32;
        END_IF;

    32: // Process in Cell 4: Apply goal parameters safely
        // Safety: Exchange head maintains height difference >= 220 mm at horizontal gap < 230 mm
        // First raise s4_2 height if needed, then move horizontal axes s4_0, s4_1
        D2040 := D602;
        IF ABS(D1040 - D602) <= 20 THEN
            D2032 := D600;
            D2036 := D601;
        END_IF;
        Y75 := TRUE;

        IF s4_settled AND X75 THEN
            step := 34;
        END_IF;

    34: // Return Cell 4 to home coordinates safely
        // Move horizontal axes home first while height is maintained, then lower height
        D2032 := -65000;
        D2036 := 65000;
        IF (ABS(D1032 - (-65000)) <= 20) AND (ABS(D1036 - 65000) <= 20) THEN
            D2040 := 0;
            IF s4_settled THEN
                Y75 := FALSE;
                step := 100; // Return jig to lift
            END_IF;
        END_IF;

    100: // Return jig to original lift section
        IF req_loc = 1 THEN
            D2008 := target_lift_h;
            D2000 := target_shuttle;
        ELSE
            D2012 := target_lift_h;
            D2000 := target_shuttle;
        END_IF;

        IF a_settled AND ((req_loc = 1 AND c_settled) OR (req_loc <> 1 AND d_settled)) THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 2; // Placement
            D81 := req_loc;
            step := 102;
        END_IF;

    102: // Extend fork to transfer jig to lift
        D2004 := 18000;
        IF b_settled AND (D90 = 0) THEN
            step := 104;
        END_IF;

    104: // Retract fork to 0 mm
        D2004 := 0;
        IF b_settled THEN
            // Lower lift back to initial height (400 mm)
            IF req_loc = 1 THEN
                D2008 := 40000;
            ELSE
                D2012 := 40000;
            END_IF;
            step := 106;
        END_IF;

    106: // Wait for lift to reach home height and stop
        IF ((req_loc = 1 AND c_settled) OR (req_loc <> 1 AND d_settled)) THEN
            IF current_req = 0 THEN
                D300 := req_id;
                IF req_is_cancelled THEN
                    D301 := 2;
                ELSE
                    D301 := 1;
                END_IF;
                req0_done := TRUE;
            ELSE
                D302 := req_id;
                IF req_is_cancelled THEN
                    D303 := 2;
                ELSE
                    D303 := 1;
                END_IF;
                req1_done := TRUE;
            END_IF;
            step := 0; // Next request or finish
        END_IF;

    200: // All requests completed: align shuttle X to 0, fork to 0, cells and lifts to home
        D2000 := 0;
        D2004 := 0;
        D2008 := 40000;
        D2012 := 40000;
        D2016 := -6500;
        D2020 := 0;
        D2024 := 6500;
        D2028 := 0;
        D2032 := -65000;
        D2036 := 65000;
        D2040 := 0;

        IF a_settled AND b_settled AND c_settled AND d_settled AND s3_settled AND s4_settled THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 5 THEN // 5 scans * 20 ms = 100 ms
                Y2 := TRUE;
            END_IF;
        ELSE
            timer_cnt := 0;
            Y2 := FALSE;
        END_IF;
END_CASE;

END_PROGRAM
