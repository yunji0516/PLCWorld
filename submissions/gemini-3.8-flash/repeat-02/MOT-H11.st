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
    active_ch : INT := -1;
    curr_id : DINT := 0;
    curr_station : DINT := 0;
    curr_cancelled : BOOL := FALSE;
    target_x : DINT := 0;
    hold_cnt : INT := 0;
    seq_counter : DINT := 1;

    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;

    ton_m3 : TON;
    ton_m4 : TON;
    ton_comp : TON;
END_VAR

(* Set default axis drives and feed-forwards *)
D2001 := 1000;
D2005 := 1000;
D2009 := 1000;
D2013 := 1000;
D2017 := 1000;
D2021 := 1000;
D2025 := 1000;
D2029 := 1000;
D2033 := 1000;

D2002 := 0;
D2006 := 0;
D2010 := 0;
D2014 := 0;
D2018 := 0;
D2022 := 0;
D2026 := 0;
D2030 := 0;
D2034 := 0;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;
Y30 := FALSE;

(* Main State Machine *)
CASE step OF
    0: (* Idle - Select next urgent request *)
        D2000 := 0;
        D2004 := 0;
        D2008 := 40000;
        D2012 := 40000;
        D2016 := 0;
        D2020 := 5000;
        D2024 := 0;
        D2028 := 0;
        D2032 := 0;
        D80 := 0;
        D81 := 0;

        IF X51 AND (r0_done OR D100 = 0) AND (r1_done OR D120 = 0) THEN
            step := 900;
        ELSIF (D100 > 0 AND NOT r0_done) AND (D120 > 0 AND NOT r1_done) THEN
            (* Earliest Due Date assignment *)
            IF D103 <= D123 THEN
                active_ch := 0;
                curr_id := D100;
                curr_station := D101;
                curr_cancelled := X31;
            ELSE
                active_ch := 1;
                curr_id := D120;
                curr_station := D121;
                curr_cancelled := X35;
            END_IF;
            step := 10;
        ELSIF (D100 > 0 AND NOT r0_done) THEN
            active_ch := 0;
            curr_id := D100;
            curr_station := D101;
            curr_cancelled := X31;
            step := 10;
        ELSIF (D120 > 0 AND NOT r1_done) THEN
            active_ch := 1;
            curr_id := D120;
            curr_station := D121;
            curr_cancelled := X35;
            step := 10;
        END_IF;

    10: (* Lift moving up to docking height *)
        IF curr_station = 1 THEN
            target_x := D403;
        ELSE
            target_x := D406;
        END_IF;

        D2000 := target_x;
        D2008 := D92;
        D2012 := D92;

        IF ABS(D1000 - target_x) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 THEN
            IF (curr_station = 1 AND X61) OR (curr_station = 2 AND X62) THEN
                D80 := 1;
                D81 := curr_station;
                seq_counter := seq_counter + 1;
                D82 := seq_counter;
                step := 20;
            END_IF;
        END_IF;

    20: (* Extract jig from lift: extend connection fork to 180 mm *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND D90 = curr_id THEN
            step := 30;
        END_IF;

    30: (* Retract fork to 0 mm *)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            IF curr_cancelled THEN
                step := 300; (* Skip processing on cancel *)
            ELSE
                step := 100; (* Move to Cell 3 *)
            END_IF;
        END_IF;

    100: (* Move shuttle to Cell 3 *)
        target_x := D409;
        D2000 := target_x;
        IF ABS(D1000 - target_x) <= 20 AND ABS(D1001) <= 100 AND X63 THEN
            D80 := 2;
            D81 := 3;
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            step := 110;
        END_IF;

    110: (* Place jig into Cell 3: extend fork *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            step := 120;
        END_IF;

    120: (* Retract fork to 0 mm *)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            Y70 := TRUE;
            step := 130;
        END_IF;

    130: (* Cell 3 Operation: rotate table to m3_goal0 while slide <= 500 mm *)
        D2016 := D500;
        IF ABS(D1016 - D500) <= 20 AND ABS(D1017) <= 100 THEN
            step := 140;
        END_IF;

    140: (* Cell 3 Operation: approach to m3_goal1 *)
        D2020 := D501;
        IF ABS(D1020 - D501) <= 20 AND ABS(D1021) <= 100 THEN
            step := 150;
        END_IF;

    150: (* Hold for 80 ms to ensure served *)
        IF X70 THEN
            step := 160;
        END_IF;

    160: (* Cell 3 Return: retract slide to 50 mm, then return angle to 0 *)
        D2020 := 5000;
        IF ABS(D1020 - 5000) <= 20 AND ABS(D1021) <= 100 THEN
            D2016 := 0;
            IF ABS(D1016) <= 20 AND ABS(D1017) <= 100 AND X63 THEN
                Y70 := FALSE;
                D80 := 1;
                D81 := 3;
                seq_counter := seq_counter + 1;
                D82 := seq_counter;
                step := 170;
            END_IF;
        END_IF;

    170: (* Retrieve jig from Cell 3: extend fork *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND D90 = curr_id THEN
            step := 180;
        END_IF;

    180: (* Retract fork to 0 mm *)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            step := 200; (* Move to Cell 4 *)
        END_IF;

    200: (* Move shuttle to Cell 4 *)
        target_x := D412;
        D2000 := target_x;
        IF ABS(D1000 - target_x) <= 20 AND ABS(D1001) <= 100 AND X64 THEN
            D80 := 2;
            D81 := 4;
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            step := 210;
        END_IF;

    210: (* Place jig into Cell 4: extend fork *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            step := 220;
        END_IF;

    220: (* Retract fork to 0 mm *)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            Y75 := TRUE;
            step := 230;
        END_IF;

    230: (* Cell 4 Operation: rotate index to m4_goal0 with pins retracted *)
        D2028 := 0;
        D2032 := 0;
        D2024 := D600;
        IF ABS(D1024 - D600) <= 20 AND ABS(D1025) <= 100 THEN
            step := 240;
        END_IF;

    240: (* Cell 4 Operation: insert selected pin 40 mm *)
        IF D620 = 0 THEN
            D2028 := 4000;
            D2032 := 0;
        ELSE
            D2028 := 0;
            D2032 := 4000;
        END_IF;

        IF ((D620 = 0 AND ABS(D1028 - 4000) <= 20 AND ABS(D1029) <= 100) OR
            (D620 <> 0 AND ABS(D1032 - 4000) <= 20 AND ABS(D1033) <= 100)) THEN
            step := 250;
        END_IF;

    250: (* Hold for 80 ms to ensure served *)
        IF X75 THEN
            step := 260;
        END_IF;

    260: (* Cell 4 Return: retract pins to 0, then return angle to 0 *)
        D2028 := 0;
        D2032 := 0;
        IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            D2024 := 0;
            IF ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND X64 THEN
                Y75 := FALSE;
                D80 := 1;
                D81 := 4;
                seq_counter := seq_counter + 1;
                D82 := seq_counter;
                step := 270;
            END_IF;
        END_IF;

    270: (* Retrieve jig from Cell 4: extend fork *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND D90 = curr_id THEN
            step := 280;
        END_IF;

    280: (* Retract fork to 0 mm *)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            step := 300; (* Return to original lift *)
        END_IF;

    300: (* Return shuttle to original lift docking position *)
        IF curr_station = 1 THEN
            target_x := D403;
        ELSE
            target_x := D406;
        END_IF;

        D2000 := target_x;
        D2008 := D92;
        D2012 := D92;

        IF ABS(D1000 - target_x) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 THEN
            IF (curr_station = 1 AND X61) OR (curr_station = 2 AND X62) THEN
                D80 := 2;
                D81 := curr_station;
                seq_counter := seq_counter + 1;
                D82 := seq_counter;
                step := 310;
            END_IF;
        END_IF;

    310: (* Place jig onto lift: extend fork *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            step := 320;
        END_IF;

    320: (* Retract fork to 0 mm *)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            step := 330;
        END_IF;

    330: (* Lower lift back to initial height 400 mm *)
        D2008 := 40000;
        D2012 := 40000;
        IF ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 THEN
            (* Acknowledge completion or cancellation retrieval *)
            IF active_ch = 0 THEN
                D300 := curr_id;
                IF curr_cancelled THEN
                    D301 := 2;
                ELSE
                    D301 := 1;
                END_IF;
                r0_done := TRUE;
            ELSE
                D302 := curr_id;
                IF curr_cancelled THEN
                    D303 := 2;
                ELSE
                    D303 := 1;
                END_IF;
                r1_done := TRUE;
            END_IF;
            step := 0;
        END_IF;

    900: (* All requests done: return all axes to initial postures *)
        D2000 := 0;
        D2004 := 0;
        D2008 := 40000;
        D2012 := 40000;
        D2016 := 0;
        D2020 := 5000;
        D2024 := 0;
        D2028 := 0;
        D2032 := 0;
        D80 := 0;
        D81 := 0;

        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - 5000) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            step := 910;
        END_IF;

    910: (* Maintain Y2 for completion *)
        Y2 := TRUE;
END_CASE;

ton_comp(IN := (step = 910), PT := T#100ms);

END_PROGRAM
```