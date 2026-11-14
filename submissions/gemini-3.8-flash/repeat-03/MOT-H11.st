**Main**

```iec-st
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
    active_req : INT := -1;
    curr_id : DINT := 0;
    curr_loc : DINT := 0;
    curr_stn : DINT := 1;
    seq_counter : DINT := 0;
    settle_cnt : INT := 0;
    done_cnt : INT := 0;

    r0_finished : BOOL := FALSE;
    r1_finished : BOOL := FALSE;
END_VAR

// Enable all drives and set feedforward to zero
Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;

D2002 := 0;
D2006 := 0;
D2010 := 0;
D2014 := 0;
D2018 := 0;
D2022 := 0;
D2026 := 0;
D2030 := 0;
D2034 := 0;

// High drive ratios for fast settling
D2001 := 1000;
D2005 := 1000;
D2009 := 1000;
D2013 := 1000;
D2017 := 1000;
D2021 := 1000;
D2025 := 1000;
D2029 := 1000;
D2033 := 1000;

// Main process state machine
CASE step OF
    0: // Idle: Select request with earliest deadline
        IF X51 AND (D100 = 0 OR r0_finished) AND (D120 = 0 OR r1_finished) THEN
            step := 90; // All work complete
        ELSE
            IF (D100 > 0) AND NOT r0_finished AND (D120 > 0) AND NOT r1_finished THEN
                IF D103 <= D123 THEN
                    active_req := 0;
                    curr_id := D100;
                    curr_loc := D101;
                ELSE
                    active_req := 1;
                    curr_id := D120;
                    curr_loc := D121;
                END_IF;
                step := 10;
            ELSIF (D100 > 0) AND NOT r0_finished THEN
                active_req := 0;
                curr_id := D100;
                curr_loc := D101;
                step := 10;
            ELSIF (D120 > 0) AND NOT r1_finished THEN
                active_req := 1;
                curr_id := D120;
                curr_loc := D121;
                step := 10;
            END_IF;
        END_IF;

    10: // Align lifts to docking height (D92 = 95000)
        curr_stn := curr_loc;
        D2008 := D92;
        D2012 := D92; // Keep lifts c and d synced
        D2004 := 0;   // Retract fork
        IF (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100) AND
           (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100) THEN
            step := 11;
        END_IF;

    11: // Move shuttle X to lift docking position
        IF curr_stn = 1 THEN
            D2000 := D403;
        ELSE
            D2000 := D406;
        END_IF;
        IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) THEN
            step := 12;
            settle_cnt := 0;
        END_IF;

    12: // Settle and verify ready
        settle_cnt := settle_cnt + 1;
        IF settle_cnt >= 2 THEN
            step := 13;
        END_IF;

    13: // Extend fork to connect (180 mm = 18000)
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            // Trigger extraction sequence
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 1; // Extraction
            D81 := curr_stn;
            step := 14;
        END_IF;

    14: // Wait for holding ownership transfer
        IF D90 = curr_id THEN
            step := 15;
        END_IF;

    15: // Retract fork to retrieval position (0 mm)
        D2004 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            D80 := 0;
            D81 := 0;
            step := 20;
        END_IF;

    20: // Move shuttle to Cell 3 (port3)
        D2000 := D409;
        IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND X63 THEN
            step := 21;
        END_IF;

    21: // Extend fork into Cell 3
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 2; // Placement
            D81 := 3;
            step := 22;
        END_IF;

    22: // Wait for cell 3 handoff
        IF D90 = 0 THEN
            step := 23;
        END_IF;

    23: // Retract fork
        D2004 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            D80 := 0;
            D81 := 0;
            step := 30;
        END_IF;

    30: // Cell 3 processing: Rotate table to requested angle m3_goal0
        D2016 := D500;
        IF (ABS(D1016 - D500) <= 20) AND (ABS(D1017) <= 100) THEN
            step := 31;
        END_IF;

    31: // Cell 3 processing: Approach 700 mm (70000)
        D2020 := 70000;
        IF (ABS(D1020 - 70000) <= 20) AND (ABS(D1021) <= 100) THEN
            step := 32;
        END_IF;

    32: // Maintain at actual result until served
        IF X70 THEN
            step := 33;
        END_IF;

    33: // Retract slide s3_1 to initial 50 mm (5000)
        D2020 := 5000;
        IF (ABS(D1020 - 5000) <= 20) AND (ABS(D1021) <= 100) THEN
            step := 34;
        END_IF;

    34: // Return rotation s3_0 to 0 deg
        D2016 := 0;
        IF (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) THEN
            step := 35;
        END_IF;

    35: // Extend fork into Cell 3 to pick up
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 1; // Extraction
            D81 := 3;
            step := 36;
        END_IF;

    36: // Wait for holding ownership
        IF D90 = curr_id THEN
            step := 37;
        END_IF;

    37: // Retract fork
        D2004 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            D80 := 0;
            D81 := 0;
            step := 40;
        END_IF;

    40: // Move shuttle to Cell 4 (port4)
        D2000 := D412;
        IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND X64 THEN
            step := 41;
        END_IF;

    41: // Extend fork into Cell 4
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 2; // Placement
            D81 := 4;
            step := 42;
        END_IF;

    42: // Wait for Cell 4 handoff
        IF D90 = 0 THEN
            step := 43;
        END_IF;

    43: // Retract fork
        D2004 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            D80 := 0;
            D81 := 0;
            step := 50;
        END_IF;

    50: // Cell 4 processing: Ensure pins retracted (s4_1, s4_2 = 0)
        D2028 := 0;
        D2032 := 0;
        IF (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
           (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
            step := 51;
        END_IF;

    51: // Rotate index to m4_goal0
        D2024 := D600;
        IF (ABS(D1024 - D600) <= 20) AND (ABS(D1025) <= 100) THEN
            step := 52;
        END_IF;

    52: // Insert selected pin 40 mm (4000)
        IF D601 > 0 THEN
            D2028 := 4000;
        ELSE
            D2032 := 4000;
        END_IF;
        IF ((D601 > 0) AND (ABS(D1028 - 4000) <= 20) AND (ABS(D1029) <= 100)) OR
           ((D601 = 0) AND (ABS(D1032 - 4000) <= 20) AND (ABS(D1033) <= 100)) THEN
            step := 53;
        END_IF;

    53: // Maintain at actual result until served
        IF X75 THEN
            step := 54;
        END_IF;

    54: // Retract pin to 0
        D2028 := 0;
        D2032 := 0;
        IF (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
           (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
            step := 55;
        END_IF;

    55: // Return index s4_0 to 0 deg
        D2024 := 0;
        IF (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) THEN
            step := 56;
        END_IF;

    56: // Extend fork into Cell 4 to pick up
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 1; // Extraction
            D81 := 4;
            step := 57;
        END_IF;

    57: // Wait for holding ownership
        IF D90 = curr_id THEN
            step := 58;
        END_IF;

    58: // Retract fork
        D2004 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            D80 := 0;
            D81 := 0;
            step := 60;
        END_IF;

    60: // Move shuttle back to original lift station
        IF curr_stn = 1 THEN
            D2000 := D403;
        ELSE
            D2000 := D406;
        END_IF;
        IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) THEN
            step := 61;
        END_IF;

    61: // Extend fork into lift
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 2; // Placement
            D81 := curr_stn;
            step := 62;
        END_IF;

    62: // Wait for lift handoff
        IF D90 = 0 THEN
            step := 63;
        END_IF;

    63: // Retract fork
        D2004 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            D80 := 0;
            D81 := 0;
            step := 70;
        END_IF;

    70: // Descend lifts to initial height 400 mm (40000)
        D2008 := 40000;
        D2012 := 40000;
        IF (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
           (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) THEN
            // Set completion status
            IF active_req = 0 THEN
                D300 := curr_id;
                IF X31 THEN
                    D301 := 2;
                ELSE
                    D301 := 1;
                END_IF;
                r0_finished := TRUE;
            ELSE
                D302 := curr_id;
                IF X35 THEN
                    D303 := 2;
                ELSE
                    D303 := 1;
                END_IF;
                r1_finished := TRUE;
            END_IF;
            step := 0; // Return to idle for next request
        END_IF;

    90: // Return shuttle to home 0
        D2000 := 0;
        D2004 := 0;
        D2008 := 40000;
        D2012 := 40000;
        D2016 := 0;
        D2020 := 5000;
        D2024 := 0;
        D2028 := 0;
        D2032 := 0;
        IF (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
           (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
           (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) AND
           (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND
           (ABS(D1020 - 5000) <= 20) AND (ABS(D1021) <= 100) AND
           (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
           (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
           (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
            step := 91;
        END_IF;

    91: // Maintain completion Y2 for at least 100 ms
        Y2 := TRUE;
        done_cnt := done_cnt + 1;
END_CASE;

END_PROGRAM
```