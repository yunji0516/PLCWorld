PROGRAM Main
VAR
    sys_state : INT := 0;
    req_sel : INT := -1;
    req_due_val : DINT := 0;
    ack0_val : DINT := 0;
    ack1_val : DINT := 0;
    status0_val : DINT := 0;
    status1_val : DINT := 0;
    couple_seq_val : DINT := 0;
    t80 : TON;
    t100 : TON;
    t_done_obs : TON;
    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;
    src_dock_pos : DINT := 0;
    tgt_angle : DINT := 0;
    tgt_slide : DINT := 0;
    tgt_pin : DINT := 0;
    wait_active : BOOL := FALSE;
END_VAR

(* Default outputs *)
D2000 := 0; D2001 := 0; D2002 := 0; Y40 := FALSE;
D2004 := 0; D2005 := 0; D2006 := 0; Y41 := FALSE;
D2008 := 0; D2009 := 0; D2010 := 0; Y42 := FALSE;
D2012 := 0; D2013 := 0; D2014 := 0; Y43 := FALSE;
D2016 := 0; D2017 := 0; D2018 := 0; Y44 := FALSE;
D2020 := 0; D2021 := 0; D2022 := 0; Y45 := FALSE;
D2024 := 0; D2025 := 0; D2026 := 0; Y46 := FALSE;
D2028 := 0; D2029 := 0; D2030 := 0; Y47 := FALSE;
D2032 := 0; D2033 := 0; D2034 := 0; Y48 := FALSE;
Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
D80 := 0; D81 := 0; D82 := 0; Y30 := TRUE; Y2 := FALSE;
D300 := 0; D301 := 0; D302 := 0; D303 := 0;

(* Arrival check helpers (inline) *)
(* a_arrived: ABS(D1000 - tgt) <= 20 AND ABS(D1001) <= 100 *)
(* b_arrived: ABS(D1004 - tgt) <= 20 AND ABS(D1005) <= 100 *)
(* c_arrived: ABS(D1008 - tgt) <= 20 AND ABS(D1009) <= 100 *)
(* d_arrived: ABS(D1012 - tgt) <= 20 AND ABS(D1013) <= 100 *)
(* s30_arrived: ABS(D1016 - tgt) <= 20 AND ABS(D1017) <= 100 *)
(* s31_arrived: ABS(D1020 - tgt) <= 20 AND ABS(D1021) <= 100 *)
(* s40_arrived: ABS(D1024 - tgt) <= 20 AND ABS(D1025) <= 100 *)
(* s41_arrived: ABS(D1028 - tgt) <= 20 AND ABS(D1029) <= 100 *)
(* s42_arrived: ABS(D1032 - tgt) <= 20 AND ABS(D1033) <= 100 *)

CASE sys_state OF
    0: (* IDLE: Wait for requests *)
        Y30 := TRUE;
        IF (D102 = 0 AND NOT r0_done AND NOT X31) THEN
            IF (req_sel = -1) OR (D103 < req_due_val) THEN
                req_sel := 0;
                req_due_val := D103;
            END_IF;
        END_IF;
        IF (D122 = 0 AND NOT r1_done AND NOT X35) THEN
            IF (req_sel = -1) OR (D123 < req_due_val) THEN
                req_sel := 1;
                req_due_val := D123;
            END_IF;
        END_IF;
        IF req_sel = 0 THEN
            sys_state := 1;
        ELSIF req_sel = 1 THEN
            sys_state := 1;
        ELSE
            sys_state := 0;
        END_IF;

    1: (* MOVE TO SOURCE LIFT *)
        Y30 := FALSE;
        IF req_sel = 0 THEN
            src_dock_pos := -405000;
            D81 := 1;
        ELSE
            src_dock_pos := -185000;
            D81 := 2;
        END_IF;
        D2000 := LIMIT(src_dock_pos, -450000, 450000);
        D2001 := LIMIT(500, 20, 1000);
        Y40 := TRUE;
        IF (ABS(D1000 - src_dock_pos) <= 20) AND (ABS(D1001) <= 100) THEN
            D2001 := 0;
            sys_state := 2;
        END_IF;

    2: (* WAIT SOURCE DOCK READY *)
        Y30 := TRUE;
        IF (req_sel = 0 AND X61) OR (req_sel = 1 AND X62) THEN
            sys_state := 3;
        END_IF;

    3: (* EXTEND FORK *)
        Y30 := FALSE;
        D2004 := 18000;
        D2005 := LIMIT(500, 20, 1000);
        Y41 := TRUE;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            D2005 := 0;
            sys_state := 4;
        END_IF;

    4: (* WAIT FORK STABLE / COUPLE *)
        Y30 := TRUE;
        couple_seq_val := couple_seq_val + 1;
        D82 := couple_seq_val;
        D80 := 1; (* extraction *)
        sys_state := 5;

    5: (* LIFT UP *)
        Y30 := FALSE;
        IF req_sel = 0 THEN
            D2008 := D92;
            D2009 := LIMIT(500, 20, 1000);
            Y42 := TRUE;
            IF (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100) THEN
                D2009 := 0;
                sys_state := 6;
            END_IF;
        ELSE
            D2012 := D92;
            D2013 := LIMIT(500, 20, 1000);
            Y43 := TRUE;
            IF (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100) THEN
                D2013 := 0;
                sys_state := 6;
            END_IF;
        END_IF;

    6: (* WAIT LIFT CAPTURE *)
        Y30 := TRUE;
        sys_state := 7;

    7: (* RETRACT FORK *)
        Y30 := FALSE;
        D2004 := 0;
        D2005 := LIMIT(500, 20, 1000);
        Y41 := TRUE;
        IF (ABS(D1004 - 0) <= 20) AND (ABS(D1005) <= 100) THEN
            D2005 := 0;
            sys_state := 8;
        END_IF;

    8: (* MOVE TO CELL 3 *)
        Y30 := FALSE;
        D2000 := 0;
        D2001 := LIMIT(600, 20, 1000);
        Y40 := TRUE;
        IF (ABS(D1000 - 0) <= 20) AND (ABS(D1001) <= 100) THEN
            D2001 := 0;
            sys_state := 9;
        END_IF;

    9: (* WAIT CELL 3 DOCK *)
        Y30 := TRUE;
        IF X63 THEN
            sys_state := 10;
        END_IF;

    10: (* PREP CELL 3: Set angle, limit slide to 50000 *)
        Y70 := TRUE;
        IF req_sel = 0 THEN
            tgt_angle := D500;
            tgt_slide := D501;
        ELSE
            tgt_angle := D500;
            tgt_slide := D501;
        END_IF;
        D2016 := LIMIT(tgt_angle, 0, 27000);
        D2017 := LIMIT(400, 20, 1000);
        Y44 := TRUE;
        D2020 := 50000;
        D2021 := LIMIT(300, 20, 1000);
        Y45 := TRUE;
        D700 := LIMIT(tgt_slide, 0, 74000);
        D701 := 1; (* route *)
        D702 := 500; (* accel *)
        sys_state := 11;

    11: (* ROTATE CELL 3 *)
        Y71 := TRUE;
        IF (ABS(D1016 - tgt_angle) <= 20) AND (ABS(D1017) <= 100) THEN
            D2017 := 0;
            Y44 := FALSE;
            sys_state := 12;
        END_IF;

    12: (* APPROACH CELL 3: slide to 70000 *)
        D2020 := 70000;
        D2021 := LIMIT(400, 20, 1000);
        Y45 := TRUE;
        IF (ABS(D1020 - 70000) <= 20) AND (ABS(D1021) <= 100) THEN
            D2021 := 0;
            sys_state := 13;
        END_IF;

    13: (* WAIT CELL 3 SYNC (80ms) *)
        t80(IN := NOT wait_active, PT := T#80ms);
        wait_active := TRUE;
        IF t80.Q THEN
            sys_state := 14;
        END_IF;

    14: (* RETREAT CELL 3 *)
        D2020 := 50000;
        D2021 := LIMIT(300, 20, 1000);
        Y45 := TRUE;
        IF (ABS(D1020 - 50000) <= 20) AND (ABS(D1021) <= 100) THEN
            D2021 := 0;
            Y45 := FALSE;
            Y70 := FALSE;
            Y71 := FALSE;
            sys_state := 15;
        END_IF;

    15: (* MOVE TO CELL 4 *)
        Y30 := FALSE;
        D2000 := 360000;
        D2001 := LIMIT(600, 20, 1000);
        Y40 := TRUE;
        IF (ABS(D1000 - 360000) <= 20) AND (ABS(D1001) <= 100) THEN
            D2001 := 0;
            sys_state := 16;
        END_IF;

    16: (* WAIT CELL 4 DOCK *)
        Y30 := TRUE;
        IF X64 THEN
            sys_state := 17;
        END_IF;

    17: (* PREP CELL 4: Retrieve pins *)
        Y75 := TRUE;
        D2024 := 0;
        D2025 := LIMIT(400, 20, 1000);
        Y46 := TRUE;
        D2028 := 0;
        D2029 := LIMIT(300, 20, 1000);
        Y47 := TRUE;
        D2032 := 0;
        D2033 := LIMIT(300, 20, 1000);
        Y48 := TRUE;
        D710 := 1;
        D711 := 1;
        D712 := 500;
        sys_state := 18;

    18: (* ROTATE CELL 4 *)
        Y76 := TRUE;
        IF req_sel = 0 THEN
            tgt_angle := D600;
        ELSE
            tgt_angle := D600;
        END_IF;
        D2024 := LIMIT(tgt_angle, 0, 27000);
        D2025 := LIMIT(400, 20, 1000);
        Y46 := TRUE;
        IF (ABS(D1024 - tgt_angle) <= 20) AND (ABS(D1025) <= 100) THEN
            D2025 := 0;
            sys_state := 19;
        END_IF;

    19: (* INSERT PIN (40mm) *)
        IF req_sel = 0 THEN
            tgt_pin := D601;
        ELSE
            tgt_pin := D602;
        END_IF;
        tgt_pin := LIMIT(tgt_pin, 0, 4000);
        D2028 := tgt_pin;
        D2029 := LIMIT(300, 20, 1000);
        Y47 := TRUE;
        IF (ABS(D1028 - tgt_pin) <= 20) AND (ABS(D1029) <= 100) THEN
            D2029 := 0;
            sys_state := 20;
        END_IF;

    20: (* WAIT CELL 4 SYNC (80ms) *)
        t80(IN := NOT wait_active, PT := T#80ms);
        wait_active := TRUE;
        IF t80.Q THEN
            sys_state := 21;
        END_IF;

    21: (* RETRACT PIN & ROTATE HOME *)
        D2028 := 0;
        D2029 := LIMIT(300, 20, 1000);
        Y47 := TRUE;
        D2024 := 0;
        D2025 := LIMIT(400, 20, 1000);
        Y46 := TRUE;
        IF (ABS(D1028 - 0) <= 20) AND (ABS(D1028) <= 100) AND 
           (ABS(D1024 - 0) <= 20) AND (ABS(D1025) <= 100) THEN
            D2029 := 0; D2025 := 0;
            Y46 := FALSE; Y47 := FALSE;
            Y75 := FALSE; Y76 := FALSE;
            sys_state := 22;
        END_IF;

    22: (* MOVE TO RETURN LIFT *)
        Y30 := FALSE;
        D2000 := src_dock_pos;
        D2001 := LIMIT(600, 20, 1000);
        Y40 := TRUE;
        IF (ABS(D1000 - src_dock_pos) <= 20) AND (ABS(D1001) <= 100) THEN
            D2001 := 0;
            sys_state := 23;
        END_IF;

    23: (* WAIT RETURN DOCK *)
        Y30 := TRUE;
        IF (req_sel = 0 AND X61) OR (req_sel = 1 AND X62) THEN
            sys_state := 24;
        END_IF;

    24: (* EXTEND FORK *)
        Y30 := FALSE;
        D2004 := 18000;
        D2005 := LIMIT(500, 20, 1000);
        Y41 := TRUE;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            D2005 := 0;
            sys_state := 25;
        END_IF;

    25: (* WAIT FORK STABLE *)
        Y30 := TRUE;
        couple_seq_val := couple_seq_val + 1;
        D82 := couple_seq_val;
        D80 := 2; (* placement *)
        sys_state := 26;

    26: (* LOWER LIFT *)
        Y30 := FALSE;
        IF req_sel = 0 THEN
            D2008 := 40000;
            D2009 := LIMIT(500, 20, 1000);
            Y42 := TRUE;
            IF (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) THEN
                D2009 := 0;
                sys_state := 27;
            END_IF;
        ELSE
            D2012 := 40000;
            D2013 := LIMIT(500, 20, 1000);
            Y43 := TRUE;
            IF (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) THEN
                D2013 := 0;
                sys_state := 27;
            END_IF;
        END_IF;

    27: (* WAIT LIFT RELEASE *)
        Y30 := TRUE;
        sys_state := 28;

    28: (* RETRACT FORK *)
        Y30 := FALSE;
        D2004 := 0;
        D2005 := LIMIT(500, 20, 1000);
        Y41 := TRUE;
        IF (ABS(D1004 - 0) <= 20) AND (ABS(D1005) <= 100) THEN
            D2005 := 0;
            sys_state := 29;
        END_IF;

    29: (* MOVE HOME *)
        Y30 := FALSE;
        D2000 := 0;
        D2001 := LIMIT(500, 20, 1000);
        Y40 := TRUE;
        IF (ABS(D1000 - 0) <= 20) AND (ABS(D1001) <= 100) THEN
            D2001 := 0;
            sys_state := 30;
        END_IF;

    30: (* ACKNOWLEDGE & RESET *)
        Y30 := TRUE;
        IF req_sel = 0 THEN
            ack0_val := D100;
            status0_val := 1; (* completion *)
            r0_done := TRUE;
        ELSE
            ack1_val := D120;
            status1_val := 1;
            r1_done := TRUE;
        END_IF;
        req_sel := -1;
        sys_state := 0;

END_CASE;

(* Handle cancellations *)
IF (req_sel = 0 AND X31) THEN
    status0_val := 2; (* retrieval *)
    r0_done := TRUE;
    req_sel := -1;
    sys_state := 0;
END_IF;
IF (req_sel = 1 AND X35) THEN
    status1_val := 2;
    r1_done := TRUE;
    req_sel := -1;
    sys_state := 0;
END_IF;

(* Write ack/status outputs *)
D300 := ack0_val; D301 := status0_val;
D302 := ack1_val; D303 := status1_val;

(* Timers *)
t80(IN := wait_active, PT := T#80ms);
t100(IN := sys_state = 30 AND NOT t100.Q, PT := T#100ms);

(* Completion observation *)
IF r0_done AND r1_done AND X51 THEN
    t_done_obs(IN := NOT Y2, PT := T#100ms);
    IF t_done_obs.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    t_done_obs(IN := FALSE, PT := T#100ms);
    Y2 := FALSE;
END_IF;

END_PROGRAM