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
    D603 : DINT;
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
    substep : INT := 0;
    timer_ms : DINT := 0;
    init_done : BOOL := FALSE;
    active_req : INT := 0;
    active_req_id : DINT := 0;
    is_cancelled : BOOL := FALSE;
    target_station : DINT := 0;
    req0_finished : BOOL := FALSE;
    req1_finished : BOOL := FALSE;
    seq_counter : DINT := 0;
    settle_timer : DINT := 0;
    complete_timer : DINT := 0;

    a_in_pos : BOOL := FALSE;
    b_in_pos : BOOL := FALSE;
    c_in_pos : BOOL := FALSE;
    d_in_pos : BOOL := FALSE;
    s3_0_in_pos : BOOL := FALSE;
    s3_1_in_pos : BOOL := FALSE;
    s4_0_in_pos : BOOL := FALSE;
    s4_1_in_pos : BOOL := FALSE;
    s4_2_in_pos : BOOL := FALSE;
    s4_3_in_pos : BOOL := FALSE;
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

    D2008 := 15000;
    D2009 := 1000;
    D2010 := 0;
    Y42 := TRUE;

    D2012 := 15000;
    D2013 := 1000;
    D2014 := 0;
    Y43 := TRUE;

    D2016 := 0;
    D2017 := 1000;
    D2018 := 0;
    Y44 := TRUE;

    D2020 := 5000;
    D2021 := 1000;
    D2022 := 0;
    Y45 := TRUE;

    D2024 := -6500;
    D2025 := 1000;
    D2026 := 0;
    Y46 := TRUE;

    D2028 := 0;
    D2029 := 1000;
    D2030 := 0;
    Y47 := TRUE;

    D2032 := 6500;
    D2033 := 1000;
    D2034 := 0;
    Y48 := TRUE;

    D2036 := 0;
    D2037 := 1000;
    D2038 := 0;
    Y49 := TRUE;

    Y30 := FALSE;
    Y70 := FALSE;
    Y71 := FALSE;
    Y75 := FALSE;
    Y76 := FALSE;
    init_done := TRUE;
END_VAR;

a_in_pos := (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100);
b_in_pos := (ABS(D1004 - D2004) <= 20) AND (ABS(D1005) <= 100);
c_in_pos := (ABS(D1008 - D2008) <= 20) AND (ABS(D1009) <= 100);
d_in_pos := (ABS(D1012 - D2012) <= 20) AND (ABS(D1013) <= 100);
s3_0_in_pos := (ABS(D1016 - D2016) <= 20) AND (ABS(D1017) <= 100);
s3_1_in_pos := (ABS(D1020 - D2020) <= 20) AND (ABS(D1021) <= 100);
s4_0_in_pos := (ABS(D1024 - D2024) <= 20) AND (ABS(D1025) <= 100);
s4_1_in_pos := (ABS(D1028 - D2028) <= 20) AND (ABS(D1029) <= 100);
s4_2_in_pos := (ABS(D1032 - D2032) <= 20) AND (ABS(D1033) <= 100);
s4_3_in_pos := (ABS(D1036 - D2036) <= 20) AND (ABS(D1037) <= 100);

CASE step OF
    0:
        IF (D100 > 0) AND NOT req0_finished THEN
            active_req := 0;
            active_req_id := D100;
            is_cancelled := X31;
            step := 10;
            substep := 0;
            settle_timer := 0;
        ELSIF (D120 > 0) AND NOT req1_finished THEN
            active_req := 1;
            active_req_id := D120;
            is_cancelled := X35;
            step := 10;
            substep := 0;
            settle_timer := 0;
        ELSIF (D100 = 0 OR req0_finished) AND (D120 = 0 OR req1_finished) THEN
            IF X51 THEN
                step := 900;
            END_IF;
        END_IF;

    10:
        IF (active_req = 0 AND X31) OR (active_req = 1 AND X35) THEN
            is_cancelled := TRUE;
        END_IF;

        CASE substep OF
            0:
                IF active_req = 0 THEN
                    D2008 := D92;
                ELSE
                    D2012 := D92;
                END_IF;
                settle_timer := 0;
                substep := 1;

            1:
                IF ((active_req = 0 AND c_in_pos) OR (active_req = 1 AND d_in_pos)) THEN
                    settle_timer := settle_timer + 20;
                    IF settle_timer >= 40 THEN
                        substep := 2;
                        settle_timer := 0;
                    END_IF;
                ELSE
                    settle_timer := 0;
                END_IF;

            2:
                IF active_req = 0 THEN
                    D2000 := D403;
                ELSE
                    D2000 := D406;
                END_IF;
                substep := 3;

            3:
                IF a_in_pos THEN
                    settle_timer := settle_timer + 20;
                    IF settle_timer >= 40 THEN
                        substep := 4;
                        settle_timer := 0;
                    END_IF;
                ELSE
                    settle_timer := 0;
                END_IF;

            4:
                D2004 := 18000;
                substep := 5;

            5:
                IF b_in_pos THEN
                    settle_timer := settle_timer + 20;
                    IF settle_timer >= 40 THEN
                        seq_counter := seq_counter + 1;
                        D82 := seq_counter;
                        D80 := 1;
                        IF active_req = 0 THEN
                            D81 := 1;
                        ELSE
                            D81 := 2;
                        END_IF;
                        substep := 6;
                        settle_timer := 0;
                    END_IF;
                ELSE
                    settle_timer := 0;
                END_IF;

            6:
                settle_timer := settle_timer + 20;
                IF (D90 = active_req_id) OR (settle_timer >= 100) THEN
                    D2004 := 0;
                    substep := 7;
                    settle_timer := 0;
                END_IF;

            7:
                IF b_in_pos THEN
                    settle_timer := settle_timer + 20;
                    IF settle_timer >= 40 THEN
                        IF is_cancelled THEN
                            step := 200;
                            substep := 0;
                        ELSE
                            step := 20;
                            substep := 0;
                        END_IF;
                        settle_timer := 0;
                    END_IF;
                ELSE
                    settle_timer := 0;
                END_IF;
        END_CASE;

    20:
        IF (active_req = 0 AND X31) OR (active_req = 1 AND X35) THEN
            is_cancelled := TRUE;
            step := 200;
            substep := 0;
        ELSE
            CASE substep OF
                0:
                    D2000 := D409;
                    substep := 1;
                    settle_timer := 0;

                1:
                    IF a_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            substep := 2;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                2:
                    D2004 := 18000;
                    substep := 3;

                3:
                    IF b_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            seq_counter := seq_counter + 1;
                            D82 := seq_counter;
                            D80 := 2;
                            D81 := 3;
                            substep := 4;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                4:
                    settle_timer := settle_timer + 20;
                    IF (D410 = active_req_id) OR (settle_timer >= 100) THEN
                        D2004 := 0;
                        substep := 5;
                        settle_timer := 0;
                    END_IF;

                5:
                    IF b_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            substep := 6;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                6:
                    D2016 := D500;
                    substep := 7;

                7:
                    IF s3_0_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            D2020 := D501;
                            substep := 8;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                8:
                    IF s3_1_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            timer_ms := 0;
                            substep := 9;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                9:
                    timer_ms := timer_ms + 20;
                    IF X70 OR (timer_ms >= 100) THEN
                        D2020 := 5000;
                        substep := 10;
                        settle_timer := 0;
                    END_IF;

                10:
                    IF s3_1_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            D2016 := 0;
                            substep := 11;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                11:
                    IF s3_0_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            D2004 := 18000;
                            substep := 12;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                12:
                    IF b_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            seq_counter := seq_counter + 1;
                            D82 := seq_counter;
                            D80 := 1;
                            D81 := 3;
                            substep := 13;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                13:
                    settle_timer := settle_timer + 20;
                    IF (D90 = active_req_id) OR (settle_timer >= 100) THEN
                        D2004 := 0;
                        substep := 14;
                        settle_timer := 0;
                    END_IF;

                14:
                    IF b_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            IF (active_req = 0 AND X31) OR (active_req = 1 AND X35) THEN
                                is_cancelled := TRUE;
                                step := 200;
                            ELSE
                                step := 30;
                            END_IF;
                            substep := 0;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;
            END_CASE;
        END_IF;

    30:
        IF (active_req = 0 AND X31) OR (active_req = 1 AND X35) THEN
            is_cancelled := TRUE;
            step := 200;
            substep := 0;
        ELSE
            CASE substep OF
                0:
                    D2000 := D412;
                    substep := 1;
                    settle_timer := 0;

                1:
                    IF a_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            substep := 2;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                2:
                    D2004 := 18000;
                    substep := 3;

                3:
                    IF b_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            seq_counter := seq_counter + 1;
                            D82 := seq_counter;
                            D80 := 2;
                            D81 := 4;
                            substep := 4;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                4:
                    settle_timer := settle_timer + 20;
                    IF (D413 = active_req_id) OR (settle_timer >= 100) THEN
                        D2004 := 0;
                        substep := 5;
                        settle_timer := 0;
                    END_IF;

                5:
                    IF b_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            substep := 6;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                6:
                    D2024 := D600;
                    D2032 := D602;
                    substep := 7;

                7:
                    IF s4_0_in_pos AND s4_2_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            D2028 := D601;
                            D2036 := D603;
                            substep := 8;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                8:
                    IF s4_1_in_pos AND s4_3_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            timer_ms := 0;
                            substep := 9;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                9:
                    timer_ms := timer_ms + 20;
                    IF X75 OR (timer_ms >= 100) THEN
                        D2028 := 0;
                        D2036 := 0;
                        substep := 10;
                        settle_timer := 0;
                    END_IF;

                10:
                    IF s4_1_in_pos AND s4_3_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            D2024 := -6500;
                            D2032 := 6500;
                            substep := 11;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                11:
                    IF s4_0_in_pos AND s4_2_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            D2004 := 18000;
                            substep := 12;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                12:
                    IF b_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            seq_counter := seq_counter + 1;
                            D82 := seq_counter;
                            D80 := 1;
                            D81 := 4;
                            substep := 13;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;

                13:
                    settle_timer := settle_timer + 20;
                    IF (D90 = active_req_id) OR (settle_timer >= 100) THEN
                        D2004 := 0;
                        substep := 14;
                        settle_timer := 0;
                    END_IF;

                14:
                    IF b_in_pos THEN
                        settle_timer := settle_timer + 20;
                        IF settle_timer >= 40 THEN
                            step := 200;
                            substep := 0;
                            settle_timer := 0;
                        END_IF;
                    ELSE
                        settle_timer := 0;
                    END_IF;
            END_CASE;
        END_IF;

    200:
        CASE substep OF
            0:
                IF (D2020 > 5000) OR (D1020 > 5020) THEN
                    D2020 := 5000;
                END_IF;
                IF (D2028 > 0) OR (D1028 > 20) THEN
                    D2028 := 0;
                END_IF;
                IF (D2036 > 0) OR (D1036 > 20) THEN
                    D2036 := 0;
                END_IF;
                substep := 1;

            1:
                IF s3_1_in_pos AND s4_1_in_pos AND s4_3_in_pos THEN
                    settle_timer := settle_timer + 20;
                    IF settle_timer >= 40 THEN
                        D2016 := 0;
                        D2024 := -6500;
                        D2032 := 6500;
                        substep := 2;
                        settle_timer := 0;
                    END_IF;
                ELSE
                    settle_timer := 0;
                END_IF;

            2:
                IF s3_0_in_pos AND s4_0_in_pos AND s4_2_in_pos THEN
                    settle_timer := settle_timer + 20;
                    IF settle_timer >= 40 THEN
                        substep := 3;
                        settle_timer := 0;
                    END_IF;
                ELSE
                    settle_timer := 0;
                END_IF;

            3:
                IF D90 = active_req_id THEN
                    substep := 10;
                ELSIF D410 = active_req_id THEN
                    substep := 4;
                ELSIF D413 = active_req_id THEN
                    substep := 7;
                ELSE
                    substep := 10;
                END_IF;

            4:
                D2000 := D409;
                substep := 5;

            5:
                IF a_in_pos THEN
                    settle_timer := settle_timer + 20;
                    IF settle_timer >= 40 THEN
                        D2004 := 18000;
                        substep := 6;
                        settle_timer := 0;
                    END_IF;
                ELSE
                    settle_timer := 0;
                END_IF;

            6:
                IF b_in_pos THEN
                    settle_timer := settle_timer + 20;
                    IF settle_timer >= 40 THEN
                        seq_counter := seq_counter + 1;
                        D82 := seq_counter;
                        D80 := 1;
                        D81 := 3;
                        settle_timer := 0;
                        substep := 9;
                    END_IF;
                ELSE
                    settle_timer := 0;
                END_IF;

            7:
                D2000 := D412;
                substep := 8;

            8:
                IF a_in_pos THEN
                    settle_timer := settle_timer + 20;
                    IF settle_timer >= 40 THEN
                        D2004 := 18000;
                        substep := 6;
                        settle_timer := 0;
                    END_IF;
                ELSE
                    settle_timer := 0;
                END_IF;

            9:
                settle_timer := settle_timer + 20;
                IF (D90 = active_req_id) OR (settle_timer >= 100) THEN
                    D2004 := 0;
                    settle_timer := 0;
                    substep := 10;
                END_IF;

            10:
                IF b_in_pos THEN
                    settle_timer := settle_timer + 20;
                    IF settle_timer >= 40 THEN
                        IF active_req = 0 THEN
                            D2008 := D92;
                            D2000 := D403;
                        ELSE
                            D2012 := D92;
                            D2000 := D406;
                        END_IF;
                        substep := 11;
                        settle_timer := 0;
                    END_IF;
                ELSE
                    settle_timer := 0;
                END_IF;

            11:
                IF a_in_pos AND ((active_req = 0 AND c_in_pos) OR (active_req = 1 AND d_in_pos)) THEN
                    settle_timer := settle_timer + 20;
                    IF settle_timer >= 40 THEN
                        D2004 := 18000;
                        substep := 12;
                        settle_timer := 0;
                    END_IF;
                ELSE
                    settle_timer := 0;
                END_IF;

            12:
                IF b_in_pos THEN
                    settle_timer := settle_timer + 20;
                    IF settle_timer >= 40 THEN
                        seq_counter := seq_counter + 1;
                        D82 := seq_counter;
                        D80 := 2;
                        IF active_req = 0 THEN
                            D81 := 1;
                        ELSE
                            D81 := 2;
                        END_IF;
                        substep := 13;
                        settle_timer := 0;
                    END_IF;
                ELSE
                    settle_timer := 0;
                END_IF;

            13:
                settle_timer := settle_timer + 20;
                IF ((active_req = 0 AND D404 = active_req_id) OR (active_req = 1 AND D407 = active_req_id)) OR (settle_timer >= 100) THEN
                    D2004 := 0;
                    substep := 14;
                    settle_timer := 0;
                END_IF;

            14:
                IF b_in_pos THEN
                    settle_timer := settle_timer + 20;
                    IF settle_timer >= 40 THEN
                        IF active_req = 0 THEN
                            D2008 := 15000;
                        ELSE
                            D2012 := 15000;
                        END_IF;
                        substep := 15;
                        settle_timer := 0;
                    END_IF;
                ELSE
                    settle_timer := 0;
                END_IF;

            15:
                IF ((active_req = 0 AND c_in_pos) OR (active_req = 1 AND d_in_pos)) THEN
                    settle_timer := settle_timer + 20;
                    IF settle_timer >= 40 THEN
                        IF active_req = 0 THEN
                            D300 := active_req_id;
                            IF is_cancelled THEN
                                D301 := 2;
                            ELSE
                                D301 := 1;
                            END_IF;
                            req0_finished := TRUE;
                        ELSE
                            D302 := active_req_id;
                            IF is_cancelled THEN
                                D303 := 2;
                            ELSE
                                D303 := 1;
                            END_IF;
                            req1_finished := TRUE;
                        END_IF;
                        step := 0;
                        substep := 0;
                        settle_timer := 0;
                    END_IF;
                ELSE
                    settle_timer := 0;
                END_IF;
        END_CASE;

    900:
        D2000 := 0;
        D2004 := 0;
        D2008 := 15000;
        D2012 := 15000;
        D2016 := 0;
        D2020 := 5000;
        D2024 := -6500;
        D2028 := 0;
        D2032 := 6500;
        D2036 := 0;

        IF a_in_pos AND b_in_pos AND c_in_pos AND d_in_pos AND
           s3_0_in_pos AND s3_1_in_pos AND s4_0_in_pos AND s4_1_in_pos AND
           s4_2_in_pos AND s4_3_in_pos THEN
            complete_timer := complete_timer + 20;
            IF complete_timer >= 100 THEN
                Y2 := TRUE;
            END_IF;
        ELSE
            complete_timer := 0;
            Y2 := FALSE;
        END_IF;
END_CASE;

END_PROGRAM
