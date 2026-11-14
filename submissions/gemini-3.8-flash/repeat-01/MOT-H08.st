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

    step : INT := 0;
    active_req : INT := 0;
    current_req_id : DINT := 0;
    current_loc : DINT := 0;
    current_cancelled : BOOL := FALSE;
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;
    seq_counter : DINT := 1;
    wait_timer : TON;
    wait_in : BOOL := FALSE;
    wait_time : TIME := T#0ms;

    radA : REAL;
    radB : REAL;
    cw_pos_m : REAL;
END_VAR

wait_timer(IN := wait_in, PT := wait_time);

// Enable all axes by default with full speed
Y40 := TRUE;
D2001 := 1000;
D2002 := 0;

Y41 := TRUE;
D2005 := 1000;
D2006 := 0;

Y42 := TRUE;
D2009 := 1000;
D2010 := 0;

Y43 := TRUE;
D2013 := 1000;
D2014 := 0;

Y44 := TRUE;
D2017 := 1000;
D2018 := 0;

Y45 := TRUE;
D2021 := 1000;
D2022 := 0;

Y46 := TRUE;
D2025 := 1000;
D2026 := 0;

Y47 := TRUE;
D2029 := 1000;
D2030 := 0;

Y48 := TRUE;
D2033 := 1000;
D2034 := 0;

// Balance head interlocking calculation for cell 4 counterweight
radA := (REAL(D2024) / 100.0) * 3.14159265 / 180.0;
radB := (REAL(D2028) / 100.0) * 3.14159265 / 180.0;
cw_pos_m := -225.0 * (SIN(radA) + SIN(radB));
IF D602 <> 0 THEN
    D2032 := D602;
ELSE
    D2032 := DINT(cw_pos_m * 100.0);
END_IF;

CASE step OF
    0: // Idle / Arbitrate request
        wait_in := FALSE;
        D80 := 0;
        D81 := 0;
        IF NOT req0_done AND D100 > 0 THEN
            active_req := 0;
            current_req_id := D100;
            current_loc := D101;
            IF current_loc = 0 THEN current_loc := 1; END_IF;
            current_cancelled := X31;
            step := 10;
        ELSIF NOT req1_done AND D120 > 0 THEN
            active_req := 1;
            current_req_id := D120;
            current_loc := D121;
            IF current_loc = 0 THEN current_loc := 2; END_IF;
            current_cancelled := X35;
            step := 10;
        ELSIF (req0_done OR D100 = 0) AND (req1_done OR D120 = 0) AND (req0_done OR req1_done OR X51) THEN
            step := 100; // Final return and completion
        END_IF;

    10: // Align lifts and move shuttle to lift station
        IF current_loc = 1 THEN
            D2008 := D92; // 950 mm connection height
            D2012 := D92; // keep lift B aligned within 80 mm
            IF D403 <> 0 THEN D2000 := D403; ELSE D2000 := -405000; END_IF;
        ELSE
            D2008 := D92; // keep lift A aligned within 80 mm
            D2012 := D92; // 950 mm connection height
            IF D406 <> 0 THEN D2000 := D406; ELSE D2000 := -185000; END_IF;
        END_IF;
        D2004 := 0;

        IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004 - D2004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - D2008) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - D2012) <= 20 AND ABS(D1013) <= 100 THEN
            IF (current_loc = 1 AND X61) OR (current_loc = 2 AND X62) THEN
                step := 11;
            END_IF;
        END_IF;

    11: // Couple with lift jig (extraction)
        D80 := 1; // 1: extraction
        D81 := current_loc;
        D82 := seq_counter;
        seq_counter := seq_counter + 1;
        D2004 := 18000; // 180 mm connection fork
        step := 12;

    12: // Wait fork connected and ownership transferred
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND D90 = current_req_id THEN
            D80 := 0;
            D81 := 0;
            D2004 := 0; // retract fork
            step := 13;
        END_IF;

    13: // Wait fork retracted
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF current_cancelled OR (active_req = 0 AND X31) OR (active_req = 1 AND X35) THEN
                current_cancelled := TRUE;
                step := 60; // Return directly to lift
            ELSE
                step := 20; // Move to Cell 3
            END_IF;
        END_IF;

    20: // Move shuttle to Cell 3
        IF D409 <> 0 THEN D2000 := D409; ELSE D2000 := 490000; END_IF;
        D2016 := -60000;
        D2020 := -60000;
        IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 AND X63 THEN
            step := 21;
        END_IF;

    21: // Transfer jig to Cell 3 (placement)
        D80 := 2; // placement
        D81 := 3;
        D82 := seq_counter;
        seq_counter := seq_counter + 1;
        D2004 := 18000;
        step := 22;

    22: // Wait fork placed into Cell 3
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND D522 = current_req_id THEN
            D80 := 0;
            D81 := 0;
            D2004 := 0;
            step := 23;
        END_IF;

    23: // Wait fork retracted, configure Cell 3
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            Y70 := TRUE; // m3_configure
            step := 24;
        END_IF;

    24: // Execute Cell 3 operation
        D2016 := D500;
        D2020 := D501;
        IF ABS(D1016 - D500) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - D501) <= 20 AND ABS(D1021) <= 100 THEN
            wait_in := TRUE;
            wait_time := T#80ms;
            IF wait_timer.Q OR X70 THEN
                wait_in := FALSE;
                step := 25;
            END_IF;
        ELSE
            wait_in := FALSE;
        END_IF;

    25: // Cell 3 return to connection posture
        D2016 := -60000;
        D2020 := -60000;
        IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 AND X63 THEN
            step := 26;
        END_IF;

    26: // Extract jig from Cell 3
        D80 := 1; // extraction
        D81 := 3;
        D82 := seq_counter;
        seq_counter := seq_counter + 1;
        D2004 := 18000;
        step := 27;

    27: // Wait fork extraction complete
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND D90 = current_req_id THEN
            D80 := 0;
            D81 := 0;
            Y70 := FALSE;
            D2004 := 0;
            step := 28;
        END_IF;

    28: // Wait fork retracted
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 30; // Proceed to Cell 4
        END_IF;

    30: // Move shuttle to Cell 4
        IF D412 <> 0 THEN D2000 := D412; ELSE D2000 := 1140000; END_IF;
        D2024 := 0;
        D2028 := 0;
        IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 AND X64 THEN
            step := 31;
        END_IF;

    31: // Transfer jig to Cell 4 (placement)
        D80 := 2; // placement
        D81 := 4;
        D82 := seq_counter;
        seq_counter := seq_counter + 1;
        D2004 := 18000;
        step := 32;

    32: // Wait fork placed into Cell 4
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND D622 = current_req_id THEN
            D80 := 0;
            D81 := 0;
            D2004 := 0;
            step := 33;
        END_IF;

    33: // Wait fork retracted, configure Cell 4
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            Y75 := TRUE; // m4_configure
            step := 34;
        END_IF;

    34: // Execute Cell 4 operation
        D2024 := D600;
        D2028 := D601;
        IF ABS(D1024 - D600) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028 - D601) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032 - D2032) <= 20 AND ABS(D1033) <= 100 THEN
            wait_in := TRUE;
            wait_time := T#80ms;
            IF wait_timer.Q OR X75 THEN
                wait_in := FALSE;
                step := 35;
            END_IF;
        ELSE
            wait_in := FALSE;
        END_IF;

    35: // Cell 4 return to connection posture
        D2024 := 0;
        D2028 := 0;
        IF ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 AND X64 THEN
            step := 36;
        END_IF;

    36: // Extract jig from Cell 4
        D80 := 1; // extraction
        D81 := 4;
        D82 := seq_counter;
        seq_counter := seq_counter + 1;
        D2004 := 18000;
        step := 37;

    37: // Wait fork extraction complete
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND D90 = current_req_id THEN
            D80 := 0;
            D81 := 0;
            Y75 := FALSE;
            D2004 := 0;
            step := 38;
        END_IF;

    38: // Wait fork retracted
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 60; // Return to original lift
        END_IF;

    60: // Move shuttle back to original lift station
        IF current_loc = 1 THEN
            D2008 := D92;
            D2012 := D92;
            IF D403 <> 0 THEN D2000 := D403; ELSE D2000 := -405000; END_IF;
        ELSE
            D2008 := D92;
            D2012 := D92;
            IF D406 <> 0 THEN D2000 := D406; ELSE D2000 := -185000; END_IF;
        END_IF;

        IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1008 - D2008) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - D2012) <= 20 AND ABS(D1013) <= 100 THEN
            IF (current_loc = 1 AND X61) OR (current_loc = 2 AND X62) THEN
                step := 61;
            END_IF;
        END_IF;

    61: // Place jig back to lift
        D80 := 2; // placement
        D81 := current_loc;
        D82 := seq_counter;
        seq_counter := seq_counter + 1;
        D2004 := 18000;
        step := 62;

    62: // Wait jig placed onto lift
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND
           ((current_loc = 1 AND D404 = current_req_id) OR (current_loc = 2 AND D407 = current_req_id)) THEN
            D80 := 0;
            D81 := 0;
            D2004 := 0;
            step := 63;
        END_IF;

    63: // Wait fork retracted
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 64;
        END_IF;

    64: // Descend lifts to initial height (400 mm)
        D2008 := 40000;
        D2012 := 40000;
        IF ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 THEN
            // Acknowledge request completion
            IF active_req = 0 THEN
                D300 := current_req_id;
                IF current_cancelled THEN D301 := 2; ELSE D301 := 1; END_IF;
                req0_done := TRUE;
            ELSE
                D302 := current_req_id;
                IF current_cancelled THEN D303 := 2; ELSE D303 := 1; END_IF;
                req1_done := TRUE;
            END_IF;
            step := 0; // Next request or complete
        END_IF;

    100: // Return all axes to initial home positions
        D2000 := 0;
        D2004 := 0;
        D2008 := 40000;
        D2012 := 40000;
        D2016 := -60000;
        D2020 := -60000;
        D2024 := 0;
        D2028 := 0;
        D2032 := 0;
        D80 := 0;
        D81 := 0;
        Y70 := FALSE;
        Y75 := FALSE;

        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM
