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
    
    (* Internal state variables *)
    main_state : INT := 0;
    req0_id : DINT := 0;
    req0_loc : DINT := 0;
    req0_done : BOOL := FALSE;
    req0_ack_sent : BOOL := FALSE;
    req1_id : DINT := 0;
    req1_loc : DINT := 0;
    req1_done : BOOL := FALSE;
    req1_ack_sent : BOOL := FALSE;
    seq_num : DINT := 0;
    hold_timer : TON;
    complete_timer : TON;
    settled : BOOL := FALSE;
    init_done : BOOL := FALSE;
    all_done_flag : BOOL := FALSE;
    req0_served : BOOL := FALSE;
    req1_served : BOOL := FALSE;
END_VAR

(* Position constants in ×0.01 units *)
VAR CONSTANT
    SRC_POS : DINT := -405000;
    CELL3_POS : DINT := 0;
    CELL4_POS : DINT := 670000;
    LIFT_DOCK : DINT := 95000;
    FORK_OUT : DINT := 18000;
    FORK_IN : DINT := 0;
    HOME_A : DINT := 0;
    HOME_B : DINT := 0;
    HOME_C : DINT := 40000;
    HOME_D : DINT := 40000;
    HS3_0 : DINT := -6500;
    HS3_1 : DINT := 0;
    HS3_2 : DINT := 6500;
    HS3_3 : DINT := 0;
    HS4_0 : DINT := -65000;
    HS4_1 : DINT := 65000;
    HS4_2 : DINT := 0;
    RATE_MED : DINT := 700;
    RATE_LOW : DINT := 200;
    TOL : DINT := 300;
END_VAR

BEGIN
    (* First scan initialization *)
    IF NOT init_done THEN
        init_done := TRUE;
        Y30 := TRUE;
        (* Home all axes with disabled state *)
        Y40 := FALSE; Y41 := FALSE; Y42 := FALSE; Y43 := FALSE;
        Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE;
        Y48 := FALSE; Y49 := FALSE; Y50 := FALSE;
        D2000 := HOME_A; D2004 := FORK_IN;
        D2008 := HOME_C; D2012 := HOME_D;
        D2016 := HS3_0; D2020 := HS3_1; D2024 := HS3_2; D2028 := HS3_3;
        D2032 := HS4_0; D2036 := HS4_1; D2040 := HS4_2;
        D2001 := 0; D2005 := 0; D2009 := 0; D2013 := 0;
        D2017 := 0; D2021 := 0; D2025 := 0; D2029 := 0;
        D2033 := 0; D2037 := 0; D2041 := 0;
        Y70 := FALSE; Y71 := FALSE; Y75 := FALSE; Y76 := FALSE;
        D80 := 0; D81 := 0; D82 := 0;
        Y2 := FALSE;
    END_IF;

    CASE main_state OF

    (* === STATE 0: Home all axes === *)
    0:
        Y30 := TRUE;
        Y40 := TRUE; D2000 := HOME_A; D2001 := RATE_LOW;
        Y41 := TRUE; D2004 := FORK_IN; D2005 := RATE_LOW;
        Y42 := TRUE; D2008 := HOME_C; D2009 := RATE_LOW;
        Y43 := TRUE; D2012 := HOME_D; D2013 := RATE_LOW;
        Y44 := TRUE; D2016 := HS3_0; D2017 := RATE_LOW;
        Y45 := TRUE; D2020 := HS3_1; D2021 := RATE_LOW;
        Y46 := TRUE; D2024 := HS3_2; D2025 := RATE_LOW;
        Y47 := TRUE; D2028 := HS3_3; D2029 := RATE_LOW;
        Y48 := TRUE; D2032 := HS4_0; D2033 := RATE_LOW;
        Y49 := TRUE; D2036 := HS4_1; D2037 := RATE_LOW;
        Y50 := TRUE; D2040 := HS4_2; D2041 := RATE_LOW;

        IF ABS(D1000 - HOME_A) < TOL AND ABS(D1004 - FORK_IN) < TOL AND
           ABS(D1008 - HOME_C) < TOL AND ABS(D1012 - HOME_D) < TOL AND
           ABS(D1016 - HS3_0) < TOL AND ABS(D1020 - HS3_1) < TOL AND
           ABS(D1024 - HS3_2) < TOL AND ABS(D1028 - HS3_3) < TOL AND
           ABS(D1032 - HS4_0) < TOL AND ABS(D1036 - HS4_1) < TOL AND
           ABS(D1040 - HS4_2) < TOL AND ABS(D1001) < 100 AND ABS(D1005) < 100 THEN
            main_state := 1;
            Y30 := FALSE;
            settled := FALSE;
        END_IF;

    (* === STATE 1: Wait for first request === *)
    1:
        (* Check which request is available *)
        IF D100 > 0 AND NOT req0_done THEN
            req0_id := D100;
            req0_loc := D101;
            req0_ack_sent := FALSE;
            req0_served := FALSE;
            main_state := 10;
        ELSIF D120 > 0 AND NOT req1_done THEN
            req1_id := D120;
            req1_loc := D121;
            req1_ack_sent := FALSE;
            req1_served := FALSE;
            main_state := 20;
        END_IF;

    (* === Request 0 sequence === *)
    10: (* Move shuttle to source *)
        Y40 := TRUE; D2000 := SRC_POS; D2001 := RATE_MED; D2002 := 0;
        IF ABS(D1000 - SRC_POS) < TOL AND ABS(D1001) < 100 THEN
            main_state := 11;
        END_IF;

    11: (* Connect at source - extend fork, prepare lift *)
        Y41 := TRUE; D2004 := FORK_OUT; D2005 := RATE_LOW; D2006 := 0;
        IF req0_loc = 1 THEN
            Y42 := TRUE; D2008 := LIFT_DOCK; D2009 := RATE_LOW;
        ELSIF req0_loc = 2 THEN
            Y43 := TRUE; D2012 := LIFT_DOCK; D2013 := RATE_LOW;
        END_IF;
        seq_num := seq_num + 1;
        D80 := 1; D81 := req0_loc; D82 := seq_num;
        IF D1004 >= FORK_OUT - 2000 AND ABS(D1005) < 100 THEN
            main_state := 12;
        END_IF;

    12: (* Move to cell 3 *)
        Y40 := TRUE; D2000 := CELL3_POS; D2001 := RATE_MED; D2002 := 0;
        D80 := 0; D81 := 3;
        IF ABS(D1000 - CELL3_POS) < TOL AND ABS(D1001) < 100 THEN
            main_state := 13;
        END_IF;

    13: (* Cell 3 boom operations *)
        Y70 := TRUE; Y71 := TRUE;
        D700 := D520; D701 := D526; D702 := 500;
        (* Move boom axes to request targets *)
        Y44 := TRUE; D2016 := HS3_0; D2017 := RATE_LOW; D2018 := 0;
        Y45 := TRUE; D2020 := D500; D2021 := RATE_LOW; D2022 := 0;
        Y46 := TRUE; D2024 := HS3_2; D2025 := RATE_LOW; D2026 := 0;
        Y47 := TRUE; D2028 := D501; D2029 := RATE_LOW; D2030 := 0;
        IF X70 OR X72 THEN
            req0_served := TRUE;
            main_state := 14;
        END_IF;

    14: (* Return boom, move to cell 4 *)
        (* Retract boom - ensure <=80mm before swivel *)
        Y45 := TRUE; D2020 := 8000; D2021 := RATE_LOW;
        Y47 := TRUE; D2028 := 8000; D2029 := RATE_LOW;
        IF D1020 <= 8500 AND D1028 <= 8500 THEN
            Y44 := TRUE; D2016 := HS3_0; D2017 := RATE_LOW;
            Y46 := TRUE; D2024 := HS3_2; D2025 := RATE_LOW;
            Y71 := FALSE;
            (* Move shuttle *)
            Y40 := TRUE; D2000 := CELL4_POS; D2001 := RATE_MED; D2002 := 0;
            D81 := 4;
            IF ABS(D1000 - CELL4_POS) < TOL AND ABS(D1001) < 100 THEN
                main_state := 15;
            END_IF;
        END_IF;

    15: (* Cell 4 exchange head operations *)
        Y75 := TRUE; Y76 := TRUE;
        D710 := D620; D711 := D626; D712 := 500;
        (* Move exchange head axes to targets, maintain height diff *)
        Y48 := TRUE; D2032 := D600; D2033 := RATE_LOW; D2034 := 0;
        Y49 := TRUE; D2036 := D601; D2037 := RATE_LOW; D2038 := 0;
        Y50 := TRUE; D2040 := D602; D2041 := RATE_LOW; D2042 := 0;
        IF X75 OR X77 THEN
            req0_served := TRUE;
            main_state := 16;
        END_IF;

    16: (* Return exchange head, move shuttle back to source *)
        (* Return exchange head to home *)
        Y48 := TRUE; D2032 := HS4_0; D2033 := RATE_LOW;
        Y49 := TRUE; D2036 := HS4_1; D2037 := RATE_LOW;
        Y50 := TRUE; D2040 := HS4_2; D2041 := RATE_LOW;
        Y76 := FALSE;
        IF ABS(D1032 - HS4_0) < TOL AND ABS(D1036 - HS4_1) < TOL AND ABS(D1040 - HS4_2) < TOL THEN
            Y40 := TRUE; D2000 := SRC_POS; D2001 := RATE_MED; D2002 := 0;
            D81 := req0_loc;
            IF ABS(D1000 - SRC_POS) < TOL AND ABS(D1001) < 100 THEN
                main_state := 17;
            END_IF;
        END_IF;

    17: (* Disconnect at source *)
        Y41 := TRUE; D2004 := FORK_IN; D2005 := RATE_LOW; D2006 := 0;
        IF req0_loc = 1 THEN
            D2008 := HOME_C; D2009 := RATE_LOW;
        ELSIF req0_loc = 2 THEN
            D2012 := HOME_D; D2013 := RATE_LOW;
        END_IF;
        D80 := 2;
        IF D1004 <= 2000 AND ABS(D1005) < 100 THEN
            main_state := 18;
        END_IF;

    18: (* Acknowledge request 0 completion *)
        D300 := req0_id;
        D301 := 1;
        req0_ack_sent := TRUE;
        req0_done := TRUE;
        main_state := 2;

    (* === Request 1 sequence === *)
    20: (* Move shuttle to source *)
        Y40 := TRUE; D2000 := SRC_POS; D2001 := RATE_MED; D2002 := 0;
        IF ABS(D1000 - SRC_POS) < TOL AND ABS(D1001) < 100 THEN
            main_state := 21;
        END_IF;

    21: (* Connect at source *)
        Y41 := TRUE; D2004 := FORK_OUT; D2005 := RATE_LOW; D2006 := 0;
        IF req1_loc = 1 THEN
            Y42 := TRUE; D2008 := LIFT_DOCK; D2009 := RATE_LOW;
        ELSIF req1_loc = 2 THEN
            Y43 := TRUE; D2012 := LIFT_DOCK; D2013 := RATE_LOW;
        END_IF;
        seq_num := seq_num + 1;
        D80 := 1; D81 := req1_loc; D82 := seq_num;
        IF D1004 >= FORK_OUT - 2000 AND ABS(D1005) < 100 THEN
            main_state := 22;
        END_IF;

    22: (* Move to cell 3 *)
        Y40 := TRUE; D2000 := CELL3_POS; D2001 := RATE_MED; D2002 := 0;
        D80 := 0; D81 := 3;
        IF ABS(D1000 - CELL3_POS) < TOL AND ABS(D1001) < 100 THEN
            main_state := 23;
        END_IF;

    23: (* Cell 3 boom operations *)
        Y70 := TRUE; Y71 := TRUE;
        D700 := D520; D701 := D526; D702 := 500;
        Y44 := TRUE; D2016 := HS3_0; D2017 := RATE_LOW;
        Y45 := TRUE; D2020 := D500; D2021 := RATE_LOW;
        Y46 := TRUE; D2024 := HS3_2; D2025 := RATE_LOW;
        Y47 := TRUE; D2028 := D501; D2029 := RATE_LOW;
        IF X70 OR X72 THEN
            req1_served := TRUE;
            main_state := 24;
        END_IF;

    24: (* Return boom, move to cell 4 *)
        Y45 := TRUE; D2020 := 8000; D2021 := RATE_LOW;
        Y47 := TRUE; D2028 := 8000; D2029 := RATE_LOW;
        IF D1020 <= 8500 AND D1028 <= 8500 THEN
            Y44 := TRUE; D2016 := HS3_0; D2017 := RATE_LOW;
            Y46 := TRUE; D2024 := HS3_2; D2025 := RATE_LOW;
            Y71 := FALSE;
            Y40 := TRUE; D2000 := CELL4_POS; D2001 := RATE_MED; D2002 := 0;
            D81 := 4;
            IF ABS(D1000 - CELL4_POS) < TOL AND ABS(D1001) < 100 THEN
                main_state := 25;
            END_IF;
        END_IF;

    25: (* Cell 4 exchange head operations *)
        Y75 := TRUE; Y76 := TRUE;
        D710 := D620; D711 := D626; D712 := 500;
        Y48 := TRUE; D2032 := D600; D2033 := RATE_LOW;
        Y49 := TRUE; D2036 := D601; D2037 := RATE_LOW;
        Y50 := TRUE; D2040 := D602; D2041 := RATE_LOW;
        IF X75 OR X77 THEN
            req1_served := TRUE;
            main_state := 26;
        END_IF;

    26: (* Return exchange head, move shuttle back to source *)
        Y48 := TRUE; D2032 := HS4_0; D2033 := RATE_LOW;
        Y49 := TRUE; D2036 := HS4_1; D2037 := RATE_LOW;
        Y50 := TRUE; D2040 := HS4_2; D2041 := RATE_LOW;
        Y76 := FALSE;
        IF ABS(D1032 - HS4_0) < TOL AND ABS(D1036 - HS4_1) < TOL AND ABS(D1040 - HS4_2) < TOL THEN
            Y40 := TRUE; D2000 := SRC_POS; D2001 := RATE_MED; D2002 := 0;
            D81 := req1_loc;
            IF ABS(D1000 - SRC_POS) < TOL AND ABS(D1001) < 100 THEN
                main_state := 27;
            END_IF;
        END_IF;

    27: (* Disconnect at source *)
        Y41 := TRUE; D2004 := FORK_IN; D2005 := RATE_LOW; D2006 := 0;
        IF req1_loc = 1 THEN
            D2008 := HOME_C; D2009 := RATE_LOW;
        ELSIF req1_loc = 2 THEN
            D2012 := HOME_D; D2013 := RATE_LOW;
        END_IF;
        D80 := 2;
        IF D1004 <= 2000 AND ABS(D1005) < 100 THEN
            main_state := 28;
        END_IF;

    28: (* Acknowledge request 1 completion *)
        D302 := req1_id;
        D303 := 1;
        req1_ack_sent := TRUE;
        req1_done := TRUE;
        main_state := 2;

    (* === STATE 2: Check for next request or proceed to completion === *)
    2:
        (* If request 0 done but request 1 not yet active, check for it *)
        IF req0_done AND NOT req1_done AND D120 > 0 AND NOT req1_ack_sent THEN
            req1_id := D120;
            req1_loc := D121;
            req1_ack_sent := FALSE;
            main_state := 20;
        (* If request 1 done but request 0 not yet active, check for it *)
        ELSIF req1_done AND NOT req0_done AND D100 > 0 AND NOT req0_ack_sent THEN
            req0_id := D100;
            req0_loc := D101;
            req0_ack_sent := FALSE;
            main_state := 10;
        (* Both done or no more requests - proceed to completion *)
        ELSIF (req0_done OR NOT req0_ack_sent) AND (req1_done OR NOT req1_ack_sent) THEN
            IF (req0_id = 0 OR req0_done) AND (req1_id = 0 OR req1_done) THEN
                main_state := 100;
            END_IF;
        END_IF;

    (* === STATE 100: Completion - return all to home and maintain === *)
    100:
        (* Return all axes to home positions *)
        Y40 := TRUE; D2000 := HOME_A; D2001 := RATE_LOW; D2002 := 0;
        Y41 := TRUE; D2004 := FORK_IN; D2005 := RATE_LOW; D2006 := 0;
        Y42 := TRUE; D2008 := HOME_C; D2009 := RATE_LOW; D2010 := 0;
        Y43 := TRUE; D2012 := HOME_D; D2013 := RATE_LOW; D2014 := 0;
        Y44 := TRUE; D2016 := HS3_0; D2017 := RATE_LOW; D2018 := 0;
        Y45 := TRUE; D2020 := HS3_1; D2021 := RATE_LOW; D2022 := 0;
        Y46 := TRUE; D2024 := HS3_2; D2025 := RATE_LOW; D2026 := 0;
        Y47 := TRUE; D2028 := HS3_3; D2029 := RATE_LOW; D2030 := 0;
        Y48 := TRUE; D2032 := HS4_0; D2033 := RATE_LOW; D2034 := 0;
        Y49 := TRUE; D2036 := HS4_1; D2037 := RATE_LOW; D2038 := 0;
        Y50 := TRUE; D2040 := HS4_2; D2041 := RATE_LOW; D2042 := 0;
        Y70 := FALSE; Y71 := FALSE; Y75 := FALSE; Y76 := FALSE;
        D80 := 0; D81 := 0;

        (* Check all conditions for completion declaration *)
        IF ABS(D1000) < TOL AND ABS(D1004) < TOL AND
           ABS(D1008 - HOME_C) < TOL AND ABS(D1012 - HOME_D) < TOL AND
           ABS(D1016 - HS3_0) < TOL AND ABS(D1020 - HS3_1) < TOL AND
           ABS(D1024 - HS3_2) < TOL AND ABS(D1028 - HS3_3) < TOL AND
           ABS(D1032 - HS4_0) < TOL AND ABS(D1036 - HS4_1) < TOL AND
           ABS(D1040 - HS4_2) < TOL AND
           ABS(D1001) < 100 AND ABS(D1005) < 100 AND
           ABS(D1009) < 100 AND ABS(D1013) < 100 AND
           ABS(D1017) < 100 AND ABS(D1021) < 100 AND
           ABS(D1025) < 100 AND ABS(D1029) < 100 AND
           ABS(D1033) < 100 AND ABS(D1037) < 100 AND ABS(D1041) < 100 THEN

            IF NOT settled THEN
                hold_timer(IN := TRUE, PT := T#100ms);
                settled := TRUE;
            ELSE
                hold_timer(IN := TRUE, PT := T#100ms);
                IF hold_timer.Q THEN
                    Y2 := TRUE;
                    Y30 := TRUE;
                END_IF;
            END_IF;
        ELSE
            hold_timer(IN := FALSE);
            settled := FALSE;
            Y2 := FALSE;
        END_IF;

        (* Also accept X51 as global done signal *)
        IF X51 THEN
            Y2 := TRUE;
        END_IF;

    END_CASE;

    (* Handle cancellation for request 0 *)
    IF X31 AND req0_id > 0 AND NOT req0_done THEN
        D300 := req0_id;
        D301 := 2; (* Cancellation retrieval *)
        req0_ack_sent := TRUE;
        req0_done := TRUE;
        IF req1_done OR req1_id = 0 THEN
            main_state := 100;
        ELSE
            main_state := 2;
        END_IF;
    END_IF;

    (* Handle cancellation for request 1 *)
    IF X35 AND req1_id > 0 AND NOT req1_done THEN
        D302 := req1_id;
        D303 := 2;
        req1_ack_sent := TRUE;
        req1_done := TRUE;
        IF req0_done OR req0_id = 0 THEN
            main_state := 100;
        ELSE
            main_state := 2;
        END_IF;
    END_IF;

    (* If only one request exists and it's done, go to completion *)
    IF (req0_done AND req1_id = 0) OR (req1_done AND req0_id = 0) OR
       (req0_done AND req1_done) THEN
        IF main_state <> 100 THEN
            main_state := 100;
        END_IF;
    END_IF;

END_PROGRAM