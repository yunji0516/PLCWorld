```st
PROGRAM Main
VAR
    state : INT := 0;
    req_sel : INT := 0;
    pickup_pos : DINT;
    is_cancelled : BOOL := FALSE;
    r0_id_latch : DINT;
    r1_id_latch : DINT;
    r0_loc_latch : DINT;
    r1_loc_latch : DINT;
    r0_ack_set : BOOL := FALSE;
    r1_ack_set : BOOL := FALSE;
    r0_cancel_flag : BOOL := FALSE;
    r1_cancel_flag : BOOL := FALSE;
    seq_cnt : DINT := 1;
    t80ms : TON;
    t100ms : TON;
    complete_start_time : TIME := T#0ms;
    y2_held : BOOL := FALSE;
    ST1 : DINT := -405000;
    ST2 : DINT := -185000;
    ST3 : DINT := 0;
    ST4 : DINT := 360000;
    LIFT_UP : DINT := 95000;
    LIFT_DOWN : DINT := 0;
    FORK_OUT : DINT := 18000;
    FORK_IN : DINT := 0;
    C3H : DINT := -60000;
    C4H : DINT := -60000;
    R_FAST : DINT := 800;
    R_MED : DINT := 500;
    R_SLOW : DINT := 100;
    R_CREEP : DINT := 50;
END_VAR

IF state = 0 THEN
    IF NOT r0_ack_set AND NOT r0_done_flag THEN
        IF D100 <> 0 OR (r0_id_latch = 0 AND D100 <> 0) THEN
            req_sel := 0;
            r0_id_latch := D100;
            r0_loc_latch := D101;
            r0_cancel_flag := X31;
            IF r0_loc_latch = 1 THEN
                pickup_pos := ST1;
            ELSE
                pickup_pos := ST2;
            END_IF;
            is_cancelled := r0_cancel_flag;
            state := 1;
        END_IF;
    ELSIF NOT r1_ack_set AND NOT r1_done_flag THEN
        IF D120 <> 0 OR (r1_id_latch = 0 AND D120 <> 0) THEN
            req_sel := 1;
            r1_id_latch := D120;
            r1_loc_latch := D121;
            r1_cancel_flag := X35;
            IF r1_loc_latch = 1 THEN
                pickup_pos := ST1;
            ELSE
                pickup_pos := ST2;
            END_IF;
            is_cancelled := r1_cancel_flag;
            state := 1;
        END_IF;
    END_IF;
    D80 := 0;
    D81 := 0;
    D82 := seq_cnt;
    Y30 := TRUE;

ELSIF state = 1 THEN
    D2000 := pickup_pos;
    D2001 := R_MED;
    D2002 := 0;
    Y40 := TRUE;
    D80 := 0;
    D81 := 0;
    D82 := seq_cnt;
    Y30 := FALSE;
    IF ABS(D1000 - pickup_pos) < 200 AND ABS(D1001) < 100 THEN
        state := 2;
    END_IF;

ELSIF state = 2 THEN
    D2000 := pickup_pos;
    D2001 := 0;
    Y40 := TRUE;
    D80 := 0;
    IF req_sel = 0 THEN
        IF r0_loc_latch = 1 THEN
            D2008 := LIFT_UP;
            D2009 := R_MED;
            Y42 := TRUE;
            D81 := 1;
        ELSE
            D2012 := LIFT_UP;
            D2013 := R_MED;
            Y43 := TRUE;
            D81 := 2;
        END_IF;
    ELSE
        IF r1_loc_latch = 1 THEN
            D2008 := LIFT_UP;
            D2009 := R_MED;
            Y42 := TRUE;
            D81 := 1;
        ELSE
            D2012 := LIFT_UP;
            D2013 := R_MED;
            Y43 := TRUE;
            D81 := 2;
        END_IF;
    END_IF;
    IF (req_sel = 0 AND r0_loc_latch = 1 AND ABS(D1008 - LIFT_UP) < 200) OR
       (req_sel = 0 AND r0_loc_latch <> 1 AND ABS(D1012 - LIFT_UP) < 200) OR
       (req_sel = 1 AND r1_loc_latch = 1 AND ABS(D1008 - LIFT_UP) < 200) OR
       (req_sel = 1 AND r1_loc_latch <> 1 AND ABS(D1012 - LIFT_UP) < 200) THEN
        state := 3;
    END_IF;

ELSIF state = 3 THEN
    D2000 := pickup_pos;
    D2001 := 0;
    Y40 := TRUE;
    IF req_sel = 0 THEN
        IF r0_loc_latch = 1 THEN
            D2008 := LIFT_UP;
            Y42 := TRUE;
            D2009 := 0;
        ELSE
            D2012 := LIFT_UP;
            Y43 := TRUE;
            D2013 := 0;
        END_IF;
    ELSE
        IF r1_loc_latch = 1 THEN
            D2008 := LIFT_UP;
            Y42 := TRUE;
            D2009 := 0;
        ELSE
            D2012 := LIFT_UP;
            Y43 := TRUE;
            D2013 := 0;
        END_IF;
    END_IF;
    D2004 := FORK_OUT;
    D2005 := R_SLOW;
    Y41 := TRUE;
    D80 := 1;
    IF req_sel = 0 THEN
        D81 := r0_loc_latch;
    ELSE
        D81 := r1_loc_latch;
    END_IF;
    D82 := seq_cnt;
    IF (req_sel = 0 AND r0_loc_latch = 1 AND X61) OR
       (req_sel = 0 AND r0_loc_latch = 2 AND X62) OR
       (req_sel = 1 AND r1_loc_latch = 1 AND X61) OR
       (req_sel = 1 AND r1_loc_latch = 2 AND X62) THEN
        seq_cnt := seq_cnt + 1;
        state := 4;
    END_IF;

ELSIF state = 4 THEN
    D2000 := pickup_pos;
    D2001 := 0;
    Y40 := TRUE;
    D2004 := FORK_OUT;
    D2005 := 0;
    Y41 := TRUE;
    IF req_sel = 0 THEN
        IF r0_loc_latch = 1 THEN
            D2008 := LIFT_UP;
            Y42 := TRUE;
        ELSE
            D2012 := LIFT_UP;
            Y43 := TRUE;
        END_IF;
    ELSE
        IF r1_loc_latch = 1 THEN
            D2008 := LIFT_UP;
            Y42 := TRUE;
        ELSE
            D2012 := LIFT_UP;
            Y43 := TRUE;
        END_IF;
    END_IF;
    D80 := 2;
    state := 5;

ELSIF state = 5 THEN
    D2000 := ST3;
    D2001 := R_FAST;
    D2002 := 0;
    Y40 := TRUE;
    D2004 := FORK_OUT;
    D2005 := 0;
    Y41 := TRUE;
    D81 := 0;
    D80 := 0;
    IF ABS(D1000 - ST3) < 200 AND ABS(D1001) < 100 THEN
        state := 6;
    END_IF;

ELSIF state = 6 THEN
    D2000 := ST3;
    D2001 := 0;
    Y40 := TRUE;
    D2004 := FORK_OUT;
    D2005 := 0;
    Y41 := TRUE;
    D700 := 1;
    D701 := 0;
    D702 := 6000;
    Y44 := TRUE;
    Y45 := TRUE;
    IF NOT is_cancelled THEN
        D2016 := D500;
        D2017 := R_MED;
        D2020 := D501;
        D2021 := R_MED;
    ELSE
        D2016 := C3H;
        D2017 := R_SLOW;
        D2020 := C3H;
        D2021 := R_SLOW;
    END_IF;
    t80ms(IN := (IF req_sel = 0 THEN X70 ELSE X70 END_IF), PT := T#80ms);
    IF t80ms.Q OR is_cancelled THEN
        state := 7;
    END_IF;

ELSIF state = 7 THEN
    D2000 := ST3;
    D2001 := 0;
    Y40 := TRUE;
    D2004 := FORK_OUT;
    D2005 := 0;
    Y41 := TRUE;
    D700 := 0;
    Y44 := FALSE;
    Y45 := FALSE;
    D2016 := C3H;
    D2017 := R_SLOW;
    D2020 := C3H;
    D2021 := R_SLOW;
    Y44 := TRUE;
    Y45 := TRUE;
    IF ABS(D1016 - C3H) < 200 AND ABS(D1020 - C3H) < 200 THEN
        state := 8;
    END_IF;

ELSIF state = 8 THEN
    D2000 := ST4;
    D2001 := R_FAST;
    D2002 := 0;
    Y40 := TRUE;
    D2004 := FORK_OUT;
    D2005 := 0;
    Y41 := TRUE;
    D81 := 0;
    IF ABS(D1000 - ST4) < 200 AND ABS(D1001) < 100 THEN
        state := 9;
    END_IF;

ELSIF state = 9 THEN
    D2000 := ST4;
    D2001 := 0;
    Y40 := TRUE;
    D2004 := FORK_OUT;
    D2005 := 0;
    Y41 := TRUE;
    IF ABS(D1024) < 100 AND ABS(D1028) < 100 THEN
        Y75 := TRUE;
        D710 := 1;
        D711 := 0;
        D712 := 6000;
    ELSE
        Y75 := FALSE;
    END_IF;
    IF NOT is_cancelled THEN
        D2024 := D600;
        D2025 := R_MED;
        D2028 := D601;
        D2029 := R_MED;
    ELSE
        D2024 := C4H;
        D2025 := R_SLOW;
        D2028 := C4H;
        D2029 := R_SLOW;
    END_IF;
    Y46 := TRUE;
    Y47 := TRUE;
    IF ABS(D1024 - D600) < 200 AND ABS(D1028 - D601) < 200 AND NOT is_cancelled THEN
        t80ms(IN := X77, PT := T#80ms);
        IF t80ms.Q THEN
            Y75 := FALSE;
            state := 10;
        END_IF;
    ELSIF is_cancelled AND ABS(D1024 - C4H) < 200 AND ABS(D1028 - C4H) < 200 THEN
        Y75 := FALSE;
        state := 10;
    END_IF;

ELSIF state = 10 THEN
    D2000 := ST4;
    D2001 := 0;
    Y40 := TRUE;
    D2004 := FORK_OUT;
    D2005 := 0;
    Y41 := TRUE;
    Y75 := FALSE;
    Y76 := TRUE;
    D2024 := D600;
    D2025 := 0;
    D2028 := D601;
    D2029 := 0;
    state := 11;

ELSIF state = 11 THEN
    D2000 := ST4;
    D2001 := 0;
    Y40 := TRUE;
    D2004 := FORK_OUT;
    D2005 := 0;
    Y41 := TRUE;
    Y75 := FALSE;
    Y76 := FALSE;
    D2024 := C4H;
    D2025 := R_SLOW;
    D2028 := C4H;
    D2029 := R_SLOW;
    Y46 := TRUE;
    Y47 := TRUE;
    IF ABS(D1024 - C4H) < 200 AND ABS(D1028 - C4H) < 200 THEN
        state := 12;
    END_IF;

ELSIF state = 12 THEN
    D2000 := pickup_pos;
    D2001 := R_FAST;
    D2002 := 0;
    Y40 := TRUE;
    D2004 := FORK_OUT;
    D2005 := 0;
    Y41 := TRUE;
    D81 := 0;
    IF ABS(D1000 - pickup_pos) < 200 AND ABS(D1001) < 100 THEN
        state := 13;
    END_IF;

ELSIF state = 13 THEN
    D2000 := pickup_pos;
    D2001 := 0;
    Y40 := TRUE;
    IF req_sel = 0 THEN
        IF r0_loc_latch = 1 THEN
            D2008 := LIFT_UP;
            Y42 := TRUE;
        ELSE
            D2012 := LIFT_UP;
            Y43 := TRUE;
        END_IF;
    ELSE
        IF r1_loc_latch = 1 THEN
            D2008 := LIFT_UP;
            Y42 := TRUE;
        ELSE
            D2012 := LIFT_UP;
            Y43 := TRUE;
        END_IF;
    END_IF;
    D2004 := FORK_OUT;
    D2005 := 0;
    Y41 := TRUE;
    D80 := 0;
    IF req_sel = 0 THEN
        D81 := r0_loc_latch;
    ELSE
        D81 := r1_loc_latch;
    END_IF;
    D2004 := FORK_IN;
    D2005 := R_SLOW;
    state := 14;

ELSIF state = 14 THEN
    D2000 := pickup_pos;
    D2001 := 0;
    Y40 := TRUE;
    IF req_sel = 0 THEN
        IF r0_loc_latch = 1 THEN
            D2008 := LIFT_UP;
            Y42 := TRUE;
        ELSE
            D2012 := LIFT_UP;
            Y43 := TRUE;
        END_IF;
    ELSE
        IF r1_loc_latch = 1 THEN
            D2008 := LIFT_UP;
            Y42 := TRUE;
        ELSE
            D2012 := LIFT_UP;
            Y43 := TRUE;
        END_IF;
    END_IF;
    D2004 := FORK_IN;
    D2005 := 0;
    Y41 := TRUE;
    IF ABS(D1004 - FORK_IN) < 200 THEN
        state := 15;
    END_IF;

ELSIF state = 15 THEN
    D2000 := pickup_pos;
    D2001 := 0;
    Y40 := TRUE;
    D2004 := FORK_IN;
    D2005 := 0;
    Y41 := TRUE;
    D80 := 0;
    IF req_sel = 0 THEN
        IF r0_loc_latch = 1 THEN
            D2008 := LIFT_DOWN;
            D2009 := R_MED;
            Y42 := TRUE;
        ELSE
            D2012 := LIFT_DOWN;
            D2013 := R_MED;
            Y43 := TRUE;
        END_IF;
    ELSE
        IF r1_loc_latch = 1 THEN
            D2008 := LIFT_DOWN;
            D2009 := R_MED;
            Y42 := TRUE;
        ELSE
            D2012 := LIFT_DOWN;
            D2013 := R_MED;
            Y43 := TRUE;
        END_IF;
    END_IF;
    IF (req_sel = 0 AND r0_loc_latch = 1 AND ABS(D1008 - LIFT_DOWN) < 200) OR
       (req_sel = 0 AND r0_loc_latch <> 1 AND ABS(D1012 - LIFT_DOWN) < 200) OR
       (req_sel = 1 AND r1_loc_latch = 1 AND ABS(D1008 - LIFT_DOWN) < 200) OR
       (req_sel = 1 AND r1_loc_latch <> 1 AND ABS(D1012 - LIFT_DOWN) < 200) THEN
        IF req_sel = 0 THEN
            D300 := r0_id_latch;
            IF is_cancelled THEN
                D301 := 2;
            ELSE
                D301 := 1;
            END_IF;
            r0_ack_set := TRUE;
            r0_done_flag := TRUE;
        ELSE
            D302 := r1_id_latch;
            IF is_cancelled THEN
                D303 := 2;
            ELSE
                D303 := 1;
            END_IF;
            r1_ack_set := TRUE;
            r1_done_flag := TRUE;
        END_IF;
        state := 16;
    END_IF;

ELSIF state = 16 THEN
    D2000 := 0;
    D2001 := R_FAST;
    D2002 := 0;
    Y40 := TRUE;
    D2004 := 0;
    D2005 := R_SLOW;
    Y41 := TRUE;
    D2008 := 0;
    D2009 := R_SLOW;
    Y42 := TRUE;
    D2012 := 0;
    D2013 := R_SLOW;
    Y43 := TRUE;
    D2016 := C3H;
    D2017 := R_SLOW;
    D2020 := C3H;
    D2021 := R_SLOW;
    Y44 := TRUE;
    Y45 := TRUE;
    D2024 := C4H;
    D2025 := R_SLOW;
    D2028 := C4H;
    D2029 := R_SLOW;
    Y46 := TRUE;
    Y47 := TRUE;
    D80 := 0;
    D81 := 0;
    D300 := 0;
    D301 := 0;
    D302 := 0;
    D303 := 0;
    IF ABS(D1000) < 200 AND ABS(D1004) < 200 AND
       ABS(D1008) < 200 AND ABS(D1012) < 200 AND
       ABS(D1016 - C3H) < 200 AND ABS(D1020 - C3H) < 200 AND
       ABS(D1024 - C4H) < 200 AND ABS(D1028 - C4H) < 200 THEN
        state := 17;
    END_IF;

ELSIF state = 17 THEN
    D2000 := 0;
    D2001 := 0;
    Y40 := TRUE;
    D2004 := 0;
    D2005 := 0;
    Y41 := TRUE;
    D2008 := 0;
    D2009 := 0;
    Y42 := TRUE;
    D2012 := 0;
    D2013 := 0;
    Y43 := TRUE;
    D2016 := C3H;
    D2017 := 0;
    D2020 := C3H;
    D2021 := 0;
    Y44 := TRUE;
    Y45 := TRUE;
    D2024 := C4H;
    D2025 := 0;
    D2028 := C4H;
    D2029 := 0;
    Y46 := TRUE;
    Y47 := TRUE;
    D80 := 0;
    D81 := 0;
    Y30 := TRUE;
    IF NOT r0_ack_set OR NOT r1_ack_set THEN
        state := 0;
    ELSE
        t100ms(IN := TRUE, PT := T#100ms);
        IF t100ms.Q AND NOT y2_held THEN
            y2_held := TRUE;
            Y2 := TRUE;
        END_IF;
    END_IF;
END_IF;

Y70 := FALSE;
Y71 := FALSE;

END_PROGRAM
```