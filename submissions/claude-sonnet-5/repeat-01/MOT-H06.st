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

    (* internal *)
    scan_count      : DINT := 0;
    cancel_channel  : INT := 0;   (* 0 none, 1=r0, 2=r1 *)
    phase           : INT := 0;
    active_cell     : INT := 0;   (* 0,3,4 *)
    seq_done        : BOOL := FALSE;
    seq_done2       : BOOL := FALSE;
    settle          : TON;
    home_hold       : TON;
    completion_latched : BOOL := FALSE;
    last_ack_id0    : DINT := -1;
    last_ack_id1    : DINT := -1;
    req_id          : DINT := 0;
    req_loc         : DINT := 0;
    lift_axis_is_c  : BOOL := TRUE;

    target_a  : DINT;
    target_b  : DINT;
    target_c  : DINT;
    target_d  : DINT;
    target_s3_0 : DINT;
    target_s3_1 : DINT;
    target_s4_0 : DINT;
    target_s4_1 : DINT;
    target_s4_2 : DINT;
    target_s4_3 : DINT;

    home_cond       : BOOL;
    home_cond_final : BOOL;
END_VAR

scan_count := scan_count + 1;

(* ---------- default holds (safe) ---------- *)
target_a := D1000;
target_b := D1004;
target_c := D1008;
target_d := D1012;
target_s3_0 := D1016;
target_s3_1 := D1020;
target_s4_0 := D1024;
target_s4_1 := D1028;
target_s4_2 := D1032;
target_s4_3 := D1036;

Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE; Y49 := TRUE;

D80 := 0;
D81 := 0;

Y30 := TRUE;

Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;

(* ---------- select next cancellation channel (priority r0 then r1) ---------- *)
IF cancel_channel = 0 THEN
    IF X31 AND (D100 <> last_ack_id0) THEN
        cancel_channel := 1;
        req_id := D100;
        req_loc := D101;
        IF D522 = req_id THEN
            active_cell := 3;
        ELSIF D622 = req_id THEN
            active_cell := 4;
        ELSE
            active_cell := 0;
        END_IF;
        lift_axis_is_c := (req_loc = 1);
        seq_done := FALSE;
        seq_done2 := FALSE;
        phase := 10;
    ELSIF X35 AND (D120 <> last_ack_id1) THEN
        cancel_channel := 2;
        req_id := D120;
        req_loc := D121;
        IF D522 = req_id THEN
            active_cell := 3;
        ELSIF D622 = req_id THEN
            active_cell := 4;
        ELSE
            active_cell := 0;
        END_IF;
        lift_axis_is_c := (req_loc = 1);
        seq_done := FALSE;
        seq_done2 := FALSE;
        phase := 10;
    END_IF;
END_IF;

(* ---------- retrieval sequence ---------- *)
CASE phase OF

10: (* retract owning cell axes, respecting sequencing gates *)
    IF active_cell = 3 THEN
        IF D1020 <= 50020 THEN
            target_s3_0 := 0;
        ELSE
            target_s3_0 := D1016;
        END_IF;
        target_s3_1 := 5000;
        home_cond := (ABS(D1016 - 0) <= 20) AND (ABS(D1017) <= 100)
                     AND (ABS(D1020 - 5000) <= 20) AND (ABS(D1021) <= 100);
    ELSIF active_cell = 4 THEN
        IF (D1028 <= 8020) AND (D1036 <= 8020) THEN
            target_s4_0 := -6500;
            target_s4_2 := 6500;
        ELSE
            target_s4_0 := D1024;
            target_s4_2 := D1032;
        END_IF;
        target_s4_1 := 0;
        target_s4_3 := 0;
        home_cond := (ABS(D1024 - (-6500)) <= 20) AND (ABS(D1025) <= 100)
                     AND (ABS(D1028 - 0) <= 20) AND (ABS(D1029) <= 100)
                     AND (ABS(D1032 - 6500) <= 20) AND (ABS(D1033) <= 100)
                     AND (ABS(D1036 - 0) <= 20) AND (ABS(D1037) <= 100);
    ELSE
        home_cond := TRUE;
    END_IF;
    settle(IN := home_cond, PT := T#30ms);
    IF settle.Q THEN
        phase := 15;
    END_IF;

15: (* release ownership from the source cell before transfer *)
    IF active_cell <> 0 THEN
        D80 := 1;
        D81 := active_cell;
        IF (active_cell = 3 AND X63) OR (active_cell = 4 AND X64) THEN
            phase := 20;
        END_IF;
    ELSE
        phase := 20;
    END_IF;

20: (* retract connection fork to retrieval position 0 *)
    target_b := 0;
    settle(IN := (ABS(D1004 - 0) <= 20) AND (ABS(D1005) <= 100), PT := T#30ms);
    IF settle.Q THEN
        phase := 30;
    END_IF;

30: (* move shuttle to owning lift's dock; fork stays at 0 (entry <=40mm) *)
    Y30 := FALSE;
    IF req_loc = 1 THEN
        target_a := -360000;
    ELSIF req_loc = 2 THEN
        target_a := -230000;
    ELSE
        target_a := D1000;
    END_IF;
    target_b := 0;
    settle(IN := (ABS(D1000 - target_a) <= 20) AND (ABS(D1001) <= 100) AND X53, PT := T#30ms);
    IF settle.Q THEN
        phase := 40;
    END_IF;

40: (* align lift to actual source dock height *)
    Y30 := TRUE;
    IF lift_axis_is_c THEN
        target_c := D92;
        settle(IN := (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100), PT := T#30ms);
    ELSE
        target_d := D92;
        settle(IN := (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100), PT := T#30ms);
    END_IF;
    IF settle.Q THEN
        phase := 50;
    END_IF;

50: (* place jig into lift connection - new sequence number *)
    D80 := 2;
    D81 := req_loc;
    IF NOT seq_done2 THEN
        D82 := D82 + 1;
        seq_done2 := TRUE;
    END_IF;
    IF (req_loc = 1 AND X61) OR (req_loc = 2 AND X62) THEN
        phase := 60;
    END_IF;

60: (* withdraw shuttle and lift to initial connection posture / height *)
    target_a := 0;
    IF lift_axis_is_c THEN
        target_c := 15000;
    ELSE
        target_d := 15000;
    END_IF;
    IF lift_axis_is_c THEN
        settle(IN := (ABS(D1000 - 0) <= 20) AND (ABS(D1001) <= 100)
                     AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100), PT := T#30ms);
    ELSE
        settle(IN := (ABS(D1000 - 0) <= 20) AND (ABS(D1001) <= 100)
                     AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100), PT := T#30ms);
    END_IF;
    IF settle.Q THEN
        phase := 70;
    END_IF;

70: (* respond with cancellation retrieval status *)
    IF cancel_channel = 1 THEN
        D300 := req_id;
        D301 := 2;
        last_ack_id0 := req_id;
    ELSIF cancel_channel = 2 THEN
        D302 := req_id;
        D303 := 2;
        last_ack_id1 := req_id;
    END_IF;
    cancel_channel := 0;
    active_cell := 0;
    phase := 0;

ELSE
    phase := 0;
END_CASE;

(* ---------- normal completion acknowledgement for channel not busy retrieving ---------- *)
IF (NOT X31) AND X30 AND (D100 <> last_ack_id0) AND (cancel_channel <> 1) THEN
    D300 := D100;
    D301 := 1;
    last_ack_id0 := D100;
END_IF;
IF (NOT X35) AND X34 AND (D120 <> last_ack_id1) AND (cancel_channel <> 2) THEN
    D302 := D120;
    D303 := 1;
    last_ack_id1 := D120;
END_IF;

(* ---------- final completion (Y2) ---------- *)
home_cond_final := (ABS(D1000 - 0) <= 20) AND (ABS(D1004 - 0) <= 20)
                   AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1012 - 15000) <= 20)
                   AND (ABS(D1016 - 0) <= 20) AND (ABS(D1020 - 5000) <= 20)
                   AND (ABS(D1024 - (-6500)) <= 20) AND (ABS(D1028 - 0) <= 20)
                   AND (ABS(D1032 - 6500) <= 20) AND (ABS(D1036 - 0) <= 20)
                   AND (ABS(D1001) <= 100) AND (ABS(D1005) <= 100)
                   AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100)
                   AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100)
                   AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100)
                   AND (ABS(D1033) <= 100) AND (ABS(D1037) <= 100);

home_hold(IN := (X51 AND home_cond_final), PT := T#100ms);

IF (NOT completion_latched) AND home_hold.Q AND (scan_count <= 16000) THEN
    completion_latched := TRUE;
END_IF;

Y2 := completion_latched;

(* ---------- clip and write axis commands ---------- *)
D2000 := LIMIT(-450000, target_a, 730000);
D2004 := LIMIT(0, target_b, 18000);
D2008 := LIMIT(0, target_c, 120000);
D2012 := LIMIT(0, target_d, 120000);
D2016 := LIMIT(0, target_s3_0, 27000);
D2020 := LIMIT(0, target_s3_1, 74000);
D2024 := LIMIT(-9000, target_s4_0, 9000);
D2028 := LIMIT(0, target_s4_1, 65000);
D2032 := LIMIT(-9000, target_s4_2, 9000);
D2036 := LIMIT(0, target_s4_3, 65000);

D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0; D2034 := 0; D2038 := 0;

D2001 := 0;
IF ABS(D2000 - D1000) > 20 THEN
    D2001 := 300;
END_IF;
D2005 := 0;
IF ABS(D2004 - D1004) > 20 THEN
    D2005 := 300;
END_IF;
D2009 := 0;
IF ABS(D2008 - D1008) > 20 THEN
    D2009 := 300;
END_IF;
D2013 := 0;
IF ABS(D2012 - D1012) > 20 THEN
    D2013 := 300;
END_IF;
D2017 := 0;
IF ABS(D2016 - D1016) > 20 THEN
    D2017 := 300;
END_IF;
D2021 := 0;
IF ABS(D2020 - D1020) > 20 THEN
    D2021 := 300;
END_IF;
D2025 := 0;
IF ABS(D2024 - D1024) > 20 THEN
    D2025 := 300;
END_IF;
D2029 := 0;
IF ABS(D2028 - D1028) > 20 THEN
    D2029 := 300;
END_IF;
D2033 := 0;
IF ABS(D2032 - D1032) > 20 THEN
    D2033 := 300;
END_IF;
D2037 := 0;
IF ABS(D2036 - D1036) > 20 THEN
    D2037 := 300;
END_IF;

D2001 := LIMIT(0, D2001, 1000);
D2005 := LIMIT(0, D2005, 1000);
D2009 := LIMIT(0, D2009, 1000);
D2013 := LIMIT(0, D2013, 1000);
D2017 := LIMIT(0, D2017, 1000);
D2021 := LIMIT(0, D2021, 1000);
D2025 := LIMIT(0, D2025, 1000);
D2029 := LIMIT(0, D2029, 1000);
D2033 := LIMIT(0, D2033, 1000);
D2037 := LIMIT(0, D2037, 1000);

END_PROGRAM