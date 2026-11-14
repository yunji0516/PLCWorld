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
    
    req_idx : INT := 0;
    active_id : DINT := 0;
    active_loc : DINT := 0;
    state : INT := 0;
    is_cancelling : BOOL := FALSE;
    target_a : DINT := 0;
    target_b : DINT := 0;
    target_c : DINT := 15000;
    target_d : DINT := 15000;
    target_s3_0 : DINT := -60000;
    target_s3_1 : DINT := -60000;
    target_s4_0 : DINT := 0;
    target_s4_1 : DINT := 0;
    target_s4_2 : DINT := 0;
    memorized_capture : DINT := 0;
    
    port_x : DINT;
    port_ready : BOOL;
    port_id : DINT;
    lift_pos : DINT;
    
    couple_seq : DINT := 0;
    
    y2_timer_in : BOOL := FALSE;
    y2_timer : TON;
END_VAR

(* Set static drives and enables *)
D2001 := 1000; D2002 := 0; Y40 := TRUE;
D2005 := 1000; D2006 := 0; Y41 := TRUE;
D2009 := 1000; D2010 := 0; Y42 := TRUE;
D2013 := 1000; D2014 := 0; Y43 := TRUE;
D2017 := 1000; D2018 := 0; Y44 := TRUE;
D2021 := 1000; D2022 := 0; Y45 := TRUE;
D2025 := 1000; D2026 := 0; Y46 := TRUE;
D2029 := 1000; D2030 := 0; Y47 := TRUE;
D2033 := 1000; D2034 := 0; Y48 := TRUE;
Y30 := FALSE;

(* Dynamic port properties for current request *)
IF active_loc = 1 THEN
    port_x := D403; port_ready := X61; port_id := D404; lift_pos := D1008;
ELSE
    port_x := D406; port_ready := X62; port_id := D407; lift_pos := D1012;
END_IF

(* Configure Cell retention and identification *)
IF state > 0 THEN
    Y70 := TRUE; Y71 := TRUE; D700 := active_id;
    Y75 := TRUE; Y76 := TRUE; D710 := active_id;
ELSE
    Y70 := FALSE; Y71 := FALSE; D700 := 0;
    Y75 := FALSE; Y76 := FALSE; D710 := 0;
END_IF

(* Detect Cancel dynamically *)
IF (req_idx = 0 AND X31) OR (req_idx = 1 AND X35) THEN
    is_cancelling := TRUE;
END_IF

(* Perform state jump on cancel cleanly when axes and mechanisms are safely stationary/retracted *)
IF is_cancelling AND D1004 <= 20 AND target_b = 0 THEN
    IF state < 80 THEN
        IF D90 = active_id THEN
            IF state <> 80 THEN state := 80; END_IF
        ELSIF D410 = active_id THEN
            IF state < 35 OR (state > 35 AND state < 40) THEN state := 35; END_IF
        ELSIF D413 = active_id THEN
            IF state < 65 OR (state > 66 AND state < 70) THEN state := 65; END_IF
        ELSIF (D404 = active_id OR D407 = active_id) THEN
            IF state < 11 OR (state > 14 AND state < 20) THEN state := 85; END_IF
        END_IF
    END_IF
END_IF

(* Core Sequencer *)
CASE state OF
    0:
        IF req_idx = 0 THEN
            IF D100 > 0 AND NOT X30 THEN
                active_id := D100; active_loc := D101; is_cancelling := FALSE; state := 10;
                D300 := 0; D301 := 0;
            ELSE
                req_idx := 1;
            END_IF
        ELSIF req_idx = 1 THEN
            IF D120 > 0 AND NOT X34 THEN
                active_id := D120; active_loc := D121; is_cancelling := FALSE; state := 10;
                D302 := 0; D303 := 0;
            ELSE
                req_idx := 0;
            END_IF
        END_IF

    10: (* Pickup from Lift *)
        target_a := port_x;
        IF active_loc = 1 THEN target_c := 73250; ELSE target_d := 73250; END_IF
        IF ABS(D1000 - target_a) <= 20 AND port_ready AND ABS(lift_pos - 73250) <= 20 THEN
            state := 11;
        END_IF
    
    11: (* Extend Fork *)
        target_b := 18000;
        IF D1004 >= 17980 THEN state := 12; END_IF
        
    12: (* Handover - Extraction *)
        D80 := 1; D81 := active_loc; couple_seq := couple_seq + 1; D82 := couple_seq; state := 13;
        
    13: (* Wait Ownership *)
        IF D90 = active_id THEN state := 14; END_IF
        
    14: (* Retract Fork *)
        target_b := 0;
        IF D1004 <= 20 THEN state := 15; END_IF
        
    15: (* Descend Lift *)
        IF active_loc = 1 THEN target_c := 15000; ELSE target_d := 15000; END_IF
        state := 20;

    20: (* Deliver to Cell 3 *)
        target_a := D409;
        IF ABS(D1000 - target_a) <= 20 AND X63 THEN state := 21; END_IF
        
    21: (* Extend Fork *)
        target_b := 18000; IF D1004 >= 17980 THEN state := 22; END_IF
        
    22: (* Handover - Placement *)
        D80 := 2; D81 := 3; couple_seq := couple_seq + 1; D82 := couple_seq; state := 23;
        
    23: (* Wait Ownership *)
        IF D90 = 0 AND D410 = active_id THEN state := 24; END_IF
        
    24: (* Retract Fork *)
        target_b := 0; IF D1004 <= 20 THEN state := 30; END_IF
        
    30: (* Cell 3 Operation setup *)
        IF D520 = 0 THEN
            target_s3_0 := D500 + 25000;
        ELSE
            target_s3_1 := D501 + 25000;
        END_IF
        state := 31;
        
    31: (* Wait passage capture and command stop *)
        IF D522 = active_id AND D524 = D91 THEN
            memorized_capture := D523;
            IF D520 = 0 THEN
                target_s3_0 := memorized_capture + 25000;
            ELSE
                target_s3_1 := memorized_capture + 25000;
            END_IF
            state := 315;
        END_IF
        
    315: (* Wait until cell stops after capture *)
        IF (D520 = 0 AND ABS(D1016 - target_s3_0) <= 20) OR (D520 = 1 AND ABS(D1020 - target_s3_1) <= 20) THEN
            state := 32;
        END_IF
        
    32: (* Restore Cell 3 axis to initial *)
        target_s3_0 := -60000; target_s3_1 := -60000;
        IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1020 - (-60000)) <= 20 THEN state := 40; END_IF
        
    35: (* Cancel Recovery - Restore Cell 3 axis directly *)
        target_s3_0 := -60000; target_s3_1 := -60000;
        IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1020 - (-60000)) <= 20 THEN state := 40; END_IF

    40: (* Pickup from Cell 3 *)
        target_a := D409;
        IF ABS(D1000 - target_a) <= 20 AND X63 THEN state := 41; END_IF
        
    41: (* Extend Fork *)
        target_b := 18000; IF D1004 >= 17980 THEN state := 42; END_IF
        
    42: (* Handover - Extraction *)
        D80 := 1; D81 := 3; couple_seq := couple_seq + 1; D82 := couple_seq; state := 43;
        
    43: (* Wait Ownership *)
        IF D90 = active_id AND D410 = 0 THEN state := 44; END_IF
        
    44: (* Retract Fork *)
        target_b := 0; IF D1004 <= 20 THEN state := 50; END_IF
        
    50: (* Deliver to Cell 4 *)
        target_a := D412; IF ABS(D1000 - target_a) <= 20 AND X64 THEN state := 51; END_IF
        
    51: (* Extend Fork *)
        target_b := 18000; IF D1004 >= 17980 THEN state := 52; END_IF
        
    52: (* Handover - Placement *)
        D80 := 2; D81 := 4; couple_seq := couple_seq + 1; D82 := couple_seq; state := 53;
        
    53: (* Wait Ownership *)
        IF D90 = 0 AND D413 = active_id THEN state := 54; END_IF
        
    54: (* Retract Fork *)
        target_b := 0; IF D1004 <= 20 THEN state := 60; END_IF
        
    60: (* Cell 4 Operation - Retrieve/clear pins *)
        target_s4_1 := 0; target_s4_2 := 0;
        IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN state := 61; END_IF
        
    61: (* Cell 4 Operation - Index Rotation using registration value *)
        target_s4_0 := memorized_capture;
        IF ABS(D1024 - target_s4_0) <= 20 THEN state := 62; END_IF
        
    62: (* Cell 4 Operation - Insert selected pin *)
        IF D620 = 0 THEN target_s4_1 := 4000; ELSE target_s4_2 := 4000; END_IF
        IF (D620 = 0 AND ABS(D1028 - 4000) <= 20) OR (D620 = 1 AND ABS(D1032 - 4000) <= 20) THEN
            state := 63;
        END_IF
        
    63: (* Cell 4 Operation - Retract pin *)
        target_s4_1 := 0; target_s4_2 := 0;
        IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN state := 64; END_IF
        
    64: (* Cell 4 Operation - Reset rotation *)
        target_s4_0 := 0;
        IF ABS(D1024) <= 20 THEN state := 70; END_IF
        
    65: (* Cancel Recovery - Restore Cell 4 directly *)
        target_s4_1 := 0; target_s4_2 := 0;
        IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN state := 66; END_IF
        
    66: (* Cancel Recovery - Return rotation *)
        target_s4_0 := 0; IF ABS(D1024) <= 20 THEN state := 70; END_IF
        
    70: (* Pickup from Cell 4 *)
        target_a := D412; IF ABS(D1000 - target_a) <= 20 AND X64 THEN state := 71; END_IF
        
    71: (* Extend Fork *)
        target_b := 18000; IF D1004 >= 17980 THEN state := 72; END_IF
        
    72: (* Handover - Extraction *)
        D80 := 1; D81 := 4; couple_seq := couple_seq + 1; D82 := couple_seq; state := 73;
        
    73: (* Wait Ownership *)
        IF D90 = active_id AND D413 = 0 THEN state := 74; END_IF
        
    74: (* Retract Fork *)
        target_b := 0; IF D1004 <= 20 THEN state := 80; END_IF
        
    80: (* Return Shuttle to original Lift *)
        target_a := port_x;
        IF active_loc = 1 THEN target_c := 73250; ELSE target_d := 73250; END_IF
        IF ABS(D1000 - target_a) <= 20 AND port_ready AND ABS(lift_pos - 73250) <= 20 THEN
            state := 81;
        END_IF
        
    81: (* Extend Fork *)
        target_b := 18000; IF D1004 >= 17980 THEN state := 82; END_IF
        
    82: (* Handover - Placement *)
        D80 := 2; D81 := active_loc; couple_seq := couple_seq + 1; D82 := couple_seq; state := 83;
        
    83: (* Wait Ownership *)
        IF D90 = 0 AND port_id = active_id THEN state := 84; END_IF
        
    84: (* Retract Fork *)
        target_b := 0; IF D1004 <= 20 THEN state := 85; END_IF
        
    85: (* Rest Lift to initial *)
        IF active_loc = 1 THEN target_c := 15000; ELSE target_d := 15000; END_IF
        IF ABS(lift_pos - 15000) <= 20 THEN state := 90; END_IF
        
    90: (* Set status *)
        IF req_idx = 0 THEN
            D300 := active_id;
            IF is_cancelling THEN D301 := 2; ELSE D301 := 1; END_IF
        ELSE
            D302 := active_id;
            IF is_cancelling THEN D303 := 2; ELSE D303 := 1; END_IF
        END_IF
        state := 91;
        
    91: (* Wait for acknowledgement logic to loop request evaluation *)
        IF (req_idx = 0 AND X30) OR (req_idx = 1 AND X34) THEN
            state := 0;
            req_idx := (req_idx + 1) MOD 2;
        END_IF

END_CASE

(* Route targets to output addresses *)
D2000 := target_a;
D2004 := target_b;
D2008 := target_c;
D2012 := target_d;
D2016 := target_s3_0;
D2020 := target_s3_1;
D2024 := target_s4_0;
D2028 := target_s4_1;
D2032 := target_s4_2;

(* Terminal observation interval when all tasks are physically complete and axes at initial state *)
IF X51 AND state = 0 THEN
    target_a := 0;
    target_b := 0;
    target_c := 15000;
    target_d := 15000;
    target_s3_0 := -60000;
    target_s3_1 := -60000;
    target_s4_0 := 0;
    target_s4_1 := 0;
    target_s4_2 := 0;
    
    IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20
       AND ABS(D1016 - (-60000)) <= 20 AND ABS(D1020 - (-60000)) <= 20
       AND ABS(D1024) <= 20 AND ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN
       y2_timer_in := TRUE;
    ELSE
       y2_timer_in := FALSE;
    END_IF
ELSE
    y2_timer_in := FALSE;
END_IF

y2_timer(IN := y2_timer_in, PT := T#100ms);
Y2 := y2_timer.Q;

END_PROGRAM
```