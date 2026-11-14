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
    D502 : DINT;
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
    state : INT;
    prev_state : INT;
    req_index : INT;
    req_id : DINT;
    req_origin : DINT;
    req_cancel : BOOL;
    req0_done : BOOL;
    req1_done : BOOL;
    seq : DINT;
    couple_issued : BOOL;
    completion_latched : BOOL;
    a_cmd : DINT;
    b_cmd : DINT;
    c_cmd : DINT;
    d_cmd : DINT;
    s30_cmd : DINT;
    s31_cmd : DINT;
    s32_cmd : DINT;
    s40_cmd : DINT;
    s41_cmd : DINT;
    src_port_cmd : DINT;
    src_ready : BOOL;
    lift_pos : DINT;
    lift_vel : DINT;
    lift_home_ok : BOOL;
    lift_dock_ok : BOOL;
    all_home_ok : BOOL;
    stable_cond : BOOL;
    couple_timer_cond : BOOL;
    sync_cond : BOOL;
    source_aligned : BOOL;
    port3_aligned : BOOL;
    port4_aligned : BOOL;
    b_home_ok : BOOL;
    b_insert_ok : BOOL;
    a_stop_ok : BOOL;
    b_stop_ok : BOOL;
    s3_goal0 : DINT;
    s3_goal1 : DINT;
    s3_goal2 : DINT;
    s3_entry_goal : DINT;
    s4_goal0 : DINT;
    s4_goal1 : DINT;
    status_value : DINT;
    abs_tmp : DINT;
    tStable : TON;
    tCouple : TON;
    tSync : TON;
    tComplete : TON;
END_VAR

IF state <> prev_state THEN
    couple_issued := FALSE;
    prev_state := state;
END_IF;

IF D500 < -95000 THEN
    s3_goal0 := -95000;
ELSIF D500 > 95000 THEN
    s3_goal0 := 95000;
ELSE
    s3_goal0 := D500;
END_IF;

IF D501 < -95000 THEN
    s3_goal1 := -95000;
ELSIF D501 > 95000 THEN
    s3_goal1 := 95000;
ELSE
    s3_goal1 := D501;
END_IF;

IF D502 < 0 THEN
    s3_goal2 := 0;
ELSIF D502 > 18000 THEN
    s3_goal2 := 18000;
ELSE
    s3_goal2 := D502;
END_IF;

IF s3_goal2 > 4000 THEN
    s3_entry_goal := 4000;
ELSE
    s3_entry_goal := s3_goal2;
END_IF;

IF D600 < -360000 THEN
    s4_goal0 := -360000;
ELSIF D600 > 360000 THEN
    s4_goal0 := 360000;
ELSE
    s4_goal0 := D600;
END_IF;

IF D601 < -360000 THEN
    s4_goal1 := -360000;
ELSIF D601 > 360000 THEN
    s4_goal1 := 360000;
ELSE
    s4_goal1 := D601;
END_IF;

IF req_origin = 2 THEN
    src_port_cmd := D406;
    src_ready := X62;
    lift_pos := D1012;
    lift_vel := D1013;
ELSE
    src_port_cmd := D403;
    src_ready := X61;
    lift_pos := D1008;
    lift_vel := D1009;
END_IF;

a_stop_ok := ABS(D1001) <= 100;
b_stop_ok := ABS(D1005) <= 100;
b_home_ok := (ABS(D1004) <= 20) AND b_stop_ok;
b_insert_ok := (ABS(D1004 - 18000) <= 20) AND b_stop_ok;
lift_home_ok := (ABS(lift_pos - 15000) <= 20) AND (ABS(lift_vel) <= 100);
lift_dock_ok := (ABS(lift_pos - D92) <= 20) AND (ABS(lift_vel) <= 100);
source_aligned := (ABS(D1000 - src_port_cmd) <= 20) AND a_stop_ok AND src_ready AND lift_dock_ok;
port3_aligned := (ABS(D1000 - D409) <= 20) AND a_stop_ok AND X63;
port4_aligned := (ABS(D1000 - D412) <= 20) AND a_stop_ok AND X64;

a_cmd := D1000;
b_cmd := 0;
c_cmd := 15000;
d_cmd := 15000;
s30_cmd := -50000;
s31_cmd := -50000;
s32_cmd := 0;
s40_cmd := 0;
s41_cmd := 0;
stable_cond := FALSE;
couple_timer_cond := couple_issued;
sync_cond := FALSE;

D80 := 0;
D81 := 0;
Y30 := FALSE;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;

Y70 := FALSE;
Y71 := FALSE;
D700 := 1000;
D701 := D526;
D702 := 1000;
Y75 := FALSE;
Y76 := FALSE;
D710 := 1000;
D711 := D626;
D712 := 1000;

CASE state OF
0:
    a_cmd := 0;
    b_cmd := 0;
    c_cmd := 15000;
    d_cmd := 15000;
    s30_cmd := -50000;
    s31_cmd := -50000;
    s32_cmd := 0;
    s40_cmd := 0;
    s41_cmd := 0;
    IF (NOT req0_done) AND (D100 <> 0) THEN
        req_index := 0;
        req_id := D100;
        IF D101 = 2 THEN
            req_origin := 2;
        ELSE
            req_origin := 1;
        END_IF;
        req_cancel := X31;
        state := 100;
    ELSIF (NOT req1_done) AND (D120 <> 0) THEN
        req_index := 1;
        req_id := D120;
        IF D121 = 2 THEN
            req_origin := 2;
        ELSE
            req_origin := 1;
        END_IF;
        req_cancel := X35;
        state := 100;
    ELSIF req0_done AND req1_done THEN
        state := 900;
    END_IF;

100:
    a_cmd := src_port_cmd;
    b_cmd := 0;
    IF req_origin = 2 THEN
        d_cmd := D92;
        c_cmd := 15000;
    ELSE
        c_cmd := D92;
        d_cmd := 15000;
    END_IF;
    stable_cond := source_aligned AND b_home_ok;
    IF tStable.Q THEN
        state := 110;
    END_IF;

110:
    a_cmd := src_port_cmd;
    b_cmd := 18000;
    IF req_origin = 2 THEN
        d_cmd := D92;
        c_cmd := 15000;
    ELSE
        c_cmd := D92;
        d_cmd := 15000;
    END_IF;
    D80 := 1;
    D81 := req_origin;
    IF (NOT couple_issued) AND source_aligned AND b_insert_ok THEN
        seq := seq + 1;
        couple_issued := TRUE;
    END_IF;
    IF couple_issued AND ((D90 = req_id) OR tCouple.Q) THEN
        state := 115;
    END_IF;

115:
    a_cmd := src_port_cmd;
    b_cmd := 0;
    IF req_origin = 2 THEN
        d_cmd := D92;
        c_cmd := 15000;
    ELSE
        c_cmd := D92;
        d_cmd := 15000;
    END_IF;
    stable_cond := b_home_ok;
    IF tStable.Q THEN
        IF req_cancel THEN
            state := 400;
        ELSE
            state := 200;
        END_IF;
    END_IF;

200:
    a_cmd := D409;
    b_cmd := 0;
    IF req_origin = 2 THEN
        d_cmd := D92;
        c_cmd := 15000;
    ELSE
        c_cmd := D92;
        d_cmd := 15000;
    END_IF;
    stable_cond := port3_aligned AND b_home_ok;
    IF tStable.Q THEN
        state := 210;
    END_IF;

210:
    a_cmd := D409;
    b_cmd := 18000;
    IF req_origin = 2 THEN
        d_cmd := D92;
        c_cmd := 15000;
    ELSE
        c_cmd := D92;
        d_cmd := 15000;
    END_IF;
    D80 := 2;
    D81 := 3;
    IF (NOT couple_issued) AND port3_aligned AND b_insert_ok THEN
        seq := seq + 1;
        couple_issued := TRUE;
    END_IF;
    IF couple_issued AND ((D90 <> req_id) OR tCouple.Q) THEN
        state := 215;
    END_IF;

215:
    a_cmd := D409;
    b_cmd := 0;
    s30_cmd := -50000;
    s31_cmd := -50000;
    s32_cmd := s3_entry_goal;
    stable_cond := b_home_ok AND (ABS(D1024 - s3_entry_goal) <= 20) AND (ABS(D1025) <= 100);
    IF tStable.Q THEN
        state := 220;
    END_IF;

220:
    a_cmd := D409;
    b_cmd := 0;
    s30_cmd := s3_goal0;
    s31_cmd := s3_goal1;
    s32_cmd := s3_goal2;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := 1000;
    D701 := D526;
    D702 := 1000;
    stable_cond := X70;
    IF tStable.Q THEN
        state := 230;
    END_IF;

230:
    a_cmd := D409;
    b_cmd := 18000;
    s30_cmd := s3_goal0;
    s31_cmd := s3_goal1;
    s32_cmd := s3_goal2;
    Y70 := TRUE;
    Y71 := TRUE;
    D80 := 1;
    D81 := 3;
    IF (NOT couple_issued) AND port3_aligned AND b_insert_ok THEN
        seq := seq + 1;
        couple_issued := TRUE;
    END_IF;
    IF couple_issued AND ((D90 = req_id) OR tCouple.Q) THEN
        state := 235;
    END_IF;

235:
    a_cmd := D409;
    b_cmd := 0;
    s30_cmd := s3_goal0;
    s31_cmd := s3_goal1;
    s32_cmd := s3_goal2;
    Y70 := TRUE;
    Y71 := TRUE;
    stable_cond := b_home_ok;
    IF tStable.Q THEN
        state := 300;
    END_IF;

300:
    a_cmd := D412;
    b_cmd := 0;
    s30_cmd := -50000;
    s31_cmd := -50000;
    s32_cmd := 0;
    stable_cond := port4_aligned AND b_home_ok;
    IF tStable.Q THEN
        state := 310;
    END_IF;

310:
    a_cmd := D412;
    b_cmd := 18000;
    D80 := 2;
    D81 := 4;
    IF (NOT couple_issued) AND port4_aligned AND b_insert_ok THEN
        seq := seq + 1;
        couple_issued := TRUE;
    END_IF;
    IF couple_issued AND ((D90 <> req_id) OR tCouple.Q) THEN
        state := 315;
    END_IF;

315:
    a_cmd := D412;
    b_cmd := 0;
    s40_cmd := 0;
    s41_cmd := 0;
    stable_cond := b_home_ok;
    IF tStable.Q THEN
        state := 320;
    END_IF;

320:
    a_cmd := D412;
    b_cmd := 0;
    s40_cmd := s4_goal0;
    s41_cmd := s4_goal1;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := 1000;
    D711 := D626;
    D712 := 1000;
    sync_cond := (ABS(D1028 - D1032) <= 20) AND (ABS(D1029 - D1033) <= 100) AND (ABS(D1029) > 100);
    stable_cond := X75 AND (tSync.Q OR X77);
    IF tStable.Q THEN
        state := 330;
    END_IF;

330:
    a_cmd := D412;
    b_cmd := 18000;
    s40_cmd := s4_goal0;
    s41_cmd := s4_goal1;
    Y75 := TRUE;
    Y76 := TRUE;
    D80 := 1;
    D81 := 4;
    IF (NOT couple_issued) AND port4_aligned AND b_insert_ok THEN
        seq := seq + 1;
        couple_issued := TRUE;
    END_IF;
    IF couple_issued AND ((D90 = req_id) OR tCouple.Q) THEN
        state := 335;
    END_IF;

335:
    a_cmd := D412;
    b_cmd := 0;
    s40_cmd := s4_goal0;
    s41_cmd := s4_goal1;
    stable_cond := b_home_ok;
    IF tStable.Q THEN
        state := 400;
    END_IF;

400:
    a_cmd := src_port_cmd;
    b_cmd := 0;
    s30_cmd := -50000;
    s31_cmd := -50000;
    s32_cmd := 0;
    s40_cmd := 0;
    s41_cmd := 0;
    IF req_origin = 2 THEN
        d_cmd := D92;
        c_cmd := 15000;
    ELSE
        c_cmd := D92;
        d_cmd := 15000;
    END_IF;
    stable_cond := source_aligned AND b_home_ok;
    IF tStable.Q THEN
        state := 410;
    END_IF;

410:
    a_cmd := src_port_cmd;
    b_cmd := 18000;
    IF req_origin = 2 THEN
        d_cmd := D92;
        c_cmd := 15000;
    ELSE
        c_cmd := D92;
        d_cmd := 15000;
    END_IF;
    D80 := 2;
    D81 := req_origin;
    IF (NOT couple_issued) AND source_aligned AND b_insert_ok THEN
        seq := seq + 1;
        couple_issued := TRUE;
    END_IF;
    IF couple_issued AND ((D90 <> req_id) OR tCouple.Q) THEN
        state := 415;
    END_IF;

415:
    a_cmd := src_port_cmd;
    b_cmd := 0;
    IF req_origin = 2 THEN
        d_cmd := 15000;
        c_cmd := 15000;
    ELSE
        c_cmd := 15000;
        d_cmd := 15000;
    END_IF;
    stable_cond := b_home_ok AND lift_home_ok;
    IF tStable.Q THEN
        IF req_cancel THEN
            status_value := 2;
        ELSE
            status_value := 1;
        END_IF;
        IF req_index = 0 THEN
            D300 := req_id;
            D301 := status_value;
            req0_done := TRUE;
        ELSE
            D302 := req_id;
            D303 := status_value;
            req1_done := TRUE;
        END_IF;
        state := 0;
    END_IF;

900:
    a_cmd := 0;
    b_cmd := 0;
    c_cmd := 15000;
    d_cmd := 15000;
    s30_cmd := -50000;
    s31_cmd := -50000;
    s32_cmd := 0;
    s40_cmd := 0;
    s41_cmd := 0;
    Y30 := TRUE;
    all_home_ok := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
                   (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
                   (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
                   (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND
                   (ABS(D1016 + 50000) <= 20) AND (ABS(D1017) <= 100) AND
                   (ABS(D1020 + 50000) <= 20) AND (ABS(D1021) <= 100) AND
                   (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
                   (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
                   (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);
    IF tComplete.Q THEN
        completion_latched := TRUE;
    END_IF;
ELSE
    state := 0;
END_CASE;

IF a_cmd < -450000 THEN
    a_cmd := -450000;
ELSIF a_cmd > 1130000 THEN
    a_cmd := 1130000;
END_IF;
IF b_cmd < 0 THEN
    b_cmd := 0;
ELSIF b_cmd > 18000 THEN
    b_cmd := 18000;
END_IF;
IF c_cmd < 0 THEN
    c_cmd := 0;
ELSIF c_cmd > 120000 THEN
    c_cmd := 120000;
END_IF;
IF d_cmd < 0 THEN
    d_cmd := 0;
ELSIF d_cmd > 120000 THEN
    d_cmd := 120000;
END_IF;
IF s30_cmd < -95000 THEN
    s30_cmd := -95000;
ELSIF s30_cmd > 95000 THEN
    s30_cmd := 95000;
END_IF;
IF s31_cmd < -95000 THEN
    s31_cmd := -95000;
ELSIF s31_cmd > 95000 THEN
    s31_cmd := 95000;
END_IF;
IF s32_cmd < 0 THEN
    s32_cmd := 0;
ELSIF s32_cmd > 18000 THEN
    s32_cmd := 18000;
END_IF;
IF s40_cmd < -360000 THEN
    s40_cmd := -360000;
ELSIF s40_cmd > 360000 THEN
    s40_cmd := 360000;
END_IF;
IF s41_cmd < -360000 THEN
    s41_cmd := -360000;
ELSIF s41_cmd > 360000 THEN
    s41_cmd := 360000;
END_IF;

tStable(IN := stable_cond, PT := T#60ms);
tCouple(IN := couple_timer_cond, PT := T#300ms);
tSync(IN := sync_cond, PT := T#60ms);
tComplete(IN := (state = 900) AND all_home_ok AND req0_done AND req1_done, PT := T#100ms);

D2000 := a_cmd;
D2001 := 1000;
D2002 := 0;
D2004 := b_cmd;
D2005 := 1000;
D2006 := 0;
D2008 := c_cmd;
D2009 := 1000;
D2010 := 0;
D2012 := d_cmd;
D2013 := 1000;
D2014 := 0;
D2016 := s30_cmd;
D2017 := 1000;
D2018 := 0;
D2020 := s31_cmd;
D2021 := 1000;
D2022 := 0;
D2024 := s32_cmd;
D2025 := 1000;
D2026 := 0;
D2028 := s40_cmd;
D2029 := 1000;
D2030 := 0;
D2032 := s41_cmd;
D2033 := 1000;
D2034 := 0;

D82 := seq;
Y2 := completion_latched;

END_PROGRAM