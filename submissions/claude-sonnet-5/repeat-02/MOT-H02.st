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

    (* ---- internal state ---- *)
    phase : INT := 0;
    cur_req : INT := 0;
    prev_phase_stored : INT := -1;
    cancel_step : INT := 0;
    prev_cstep_stored : INT := -1;
    seq_ctr : DINT := 0;

    sel_id : DINT;
    sel_cancelled : BOOL;
    sel_station : DINT;
    sel_station_raw : DINT;

    lift_want : DINT;
    lift_pos : DINT;
    lift_vel : DINT;

    a_want : DINT := 0;
    b_want : DINT := 0;
    s30_want : DINT := -60000;
    s31_want : DINT := -60000;
    s40_want : DINT := -60000;
    s41_want : DINT := -60000;

    org40 : DINT := -60000;
    org41 : DINT := -60000;
    cfg_cnt : DINT := 0;

    r0_completed : BOOL := FALSE;
    r1_completed : BOOL := FALSE;

    is_new_phase : BOOL;
    is_new_cstep : BOOL;
    port_ready : BOOL;

    all_home : BOOL;
    ready_for_completion : BOOL;
    obs_timer : TON;
    y2_latch : BOOL := FALSE;

    POS_TOL : DINT := 20;
    SPD_TOL : DINT := 100;
    LIFT_DOCK : DINT := 95000;
    LIFT_HOME : DINT := 40000;
    STATION1 : DINT := -405000;
    STATION2 : DINT := -185000;
    STATION3 : DINT := 0;
    STATION4 : DINT := 470000;
    FORK_RETRIEVE : DINT := 0;
    FORK_CONNECT : DINT := 18000;
    CELL_HOME : DINT := -60000;
END_VAR

(* ---- select active request data ---- *)
IF cur_req = 0 THEN
    sel_id := D100;
    sel_cancelled := X31;
    sel_station := 1;
    sel_station_raw := STATION1;
    lift_pos := D1008;
    lift_vel := D1009;
ELSE
    sel_id := D120;
    sel_cancelled := X35;
    sel_station := 2;
    sel_station_raw := STATION2;
    lift_pos := D1012;
    lift_vel := D1013;
END_IF;

lift_want := LIFT_HOME;

(* cancellation override for active phases *)
IF sel_cancelled AND phase >= 1 AND phase <= 17 THEN
    phase := 80;
    cancel_step := 0;
END_IF;

is_new_phase := (phase <> prev_phase_stored);
is_new_cstep := (cancel_step <> prev_cstep_stored);

Y70 := FALSE;
Y71 := FALSE;
Y75 := FALSE;
Y76 := FALSE;

CASE phase OF

0: (* SELECT / IDLE *)
    a_want := 0;
    b_want := FORK_RETRIEVE;
    s30_want := CELL_HOME;
    s31_want := CELL_HOME;
    s40_want := CELL_HOME;
    s41_want := CELL_HOME;
    IF cur_req = 0 THEN
        IF r0_completed THEN
            cur_req := 1;
        ELSIF sel_id <> 0 THEN
            IF sel_cancelled THEN
                phase := 81;
            ELSE
                phase := 1;
            END_IF;
        ELSE
            IF (D120 <> 0) AND (NOT r1_completed) THEN
                cur_req := 1;
            END_IF;
        END_IF;
    ELSE
        IF r1_completed THEN
            cur_req := 0;
        ELSIF sel_id <> 0 THEN
            IF sel_cancelled THEN
                phase := 81;
            ELSE
                phase := 1;
            END_IF;
        ELSE
            IF (D100 <> 0) AND (NOT r0_completed) THEN
                cur_req := 0;
            END_IF;
        END_IF;
    END_IF;

1: (* LIFT_RISE *)
    lift_want := LIFT_DOCK;
    IF (ABS(lift_pos - LIFT_DOCK) <= POS_TOL) AND (ABS(lift_vel) <= SPD_TOL) THEN
        phase := 2;
    END_IF;

2: (* SHUTTLE_TO_LIFT : extraction from lift *)
    lift_want := LIFT_DOCK;
    a_want := sel_station_raw;
    b_want := FORK_RETRIEVE;
    IF is_new_phase THEN
        seq_ctr := seq_ctr + 1;
        D80 := 1; D81 := sel_station; D82 := seq_ctr;
    END_IF;
    port_ready := (sel_station = 1 AND X61) OR (sel_station = 2 AND X62);
    IF (ABS(D1000 - a_want) <= POS_TOL) AND (ABS(D1001) <= SPD_TOL) AND
       (ABS(D1004 - b_want) <= POS_TOL) AND (ABS(D1005) <= SPD_TOL) AND
       (ABS(lift_pos - LIFT_DOCK) <= POS_TOL) AND (ABS(lift_vel) <= SPD_TOL) AND port_ready THEN
        phase := 3;
    END_IF;

3: (* SHUTTLE_TO_CELL3 *)
    lift_want := LIFT_HOME;
    a_want := STATION3;
    b_want := FORK_RETRIEVE;
    IF (ABS(D1000 - a_want) <= POS_TOL) AND (ABS(D1001) <= SPD_TOL) THEN
        phase := 4;
    END_IF;

4: (* FORK_CONNECT_CELL3 : placement *)
    a_want := STATION3;
    b_want := FORK_CONNECT;
    IF is_new_phase THEN
        seq_ctr := seq_ctr + 1;
        D80 := 2; D81 := 3; D82 := seq_ctr;
    END_IF;
    IF (ABS(D1004 - b_want) <= POS_TOL) AND (ABS(D1005) <= SPD_TOL) AND X63 THEN
        phase := 5;
    END_IF;

5: (* CELL3_PROCESS *)
    b_want := FORK_CONNECT;
    s30_want := CELL_HOME + D500;
    s31_want := CELL_HOME + D501;
    D700 := sel_id; D701 := D526; D702 := 1000;
    Y70 := TRUE;
    IF (ABS(D1016 - s30_want) <= POS_TOL) AND (ABS(D1017) <= SPD_TOL) AND
       (ABS(D1020 - s31_want) <= POS_TOL) AND (ABS(D1021) <= SPD_TOL) AND X70 THEN
        phase := 6;
    END_IF;

6: (* CELL3_RETURN_HOME *)
    s30_want := CELL_HOME;
    s31_want := CELL_HOME;
    IF (ABS(D1016 - CELL_HOME) <= POS_TOL) AND (ABS(D1017) <= SPD_TOL) AND
       (ABS(D1020 - CELL_HOME) <= POS_TOL) AND (ABS(D1021) <= SPD_TOL) THEN
        phase := 7;
    END_IF;

7: (* FORK_RETRIEVE_CELL3 : extraction *)
    b_want := FORK_RETRIEVE;
    IF is_new_phase THEN
        seq_ctr := seq_ctr + 1;
        D80 := 1; D81 := 3; D82 := seq_ctr;
    END_IF;
    IF (ABS(D1004 - b_want) <= POS_TOL) AND (ABS(D1005) <= SPD_TOL) AND X63 THEN
        phase := 8;
    END_IF;

8: (* SHUTTLE_TO_CELL4 *)
    a_want := STATION4;
    b_want := FORK_RETRIEVE;
    IF (ABS(D1000 - a_want) <= POS_TOL) AND (ABS(D1001) <= SPD_TOL) THEN
        phase := 9;
    END_IF;

9: (* FORK_CONNECT_CELL4 : placement *)
    a_want := STATION4;
    b_want := FORK_CONNECT;
    IF is_new_phase THEN
        seq_ctr := seq_ctr + 1;
        D80 := 2; D81 := 4; D82 := seq_ctr;
    END_IF;
    IF (ABS(D1004 - b_want) <= POS_TOL) AND (ABS(D1005) <= SPD_TOL) AND X64 THEN
        phase := 10;
        cfg_cnt := 0;
    END_IF;

10: (* CELL4_CONFIGURE_HOLD : reference set while stopped *)
    s40_want := CELL_HOME;
    s41_want := CELL_HOME;
    IF (ABS(D1025) <= SPD_TOL) AND (ABS(D1029) <= SPD_TOL) THEN
        Y75 := TRUE;
        cfg_cnt := cfg_cnt + 1;
        IF cfg_cnt >= 2 THEN
            org40 := D1024;
            org41 := D1028;
            Y75 := FALSE;
            phase := 11;
            cfg_cnt := 0;
        END_IF;
    ELSE
        Y75 := FALSE;
        cfg_cnt := 0;
    END_IF;

11: (* CELL4_PROCESS *)
    s40_want := org40 + D600;
    s41_want := org41 + D601;
    D710 := sel_id; D711 := D626; D712 := 1000;
    Y76 := TRUE;
    IF (ABS(D1024 - s40_want) <= POS_TOL) AND (ABS(D1025) <= SPD_TOL) AND
       (ABS(D1028 - s41_want) <= POS_TOL) AND (ABS(D1029) <= SPD_TOL) AND X75 THEN
        phase := 12;
    END_IF;

12: (* CELL4_RETURN_HOME *)
    s40_want := org40;
    s41_want := org41;
    IF (ABS(D1024 - org40) <= POS_TOL) AND (ABS(D1025) <= SPD_TOL) AND
       (ABS(D1028 - org41) <= POS_TOL) AND (ABS(D1029) <= SPD_TOL) THEN
        phase := 13;
    END_IF;

13: (* FORK_RETRIEVE_CELL4 : extraction *)
    b_want := FORK_RETRIEVE;
    IF is_new_phase THEN
        seq_ctr := seq_ctr + 1;
        D80 := 1; D81 := 4; D82 := seq_ctr;
    END_IF;
    IF (ABS(D1004 - b_want) <= POS_TOL) AND (ABS(D1005) <= SPD_TOL) AND X64 THEN
        phase := 14;
    END_IF;

14: (* SHUTTLE_TO_LIFT_RETURN *)
    lift_want := LIFT_DOCK;
    a_want := sel_station_raw;
    b_want := FORK_RETRIEVE;
    IF (ABS(D1000 - a_want) <= POS_TOL) AND (ABS(D1001) <= SPD_TOL) AND
       (ABS(lift_pos - LIFT_DOCK) <= POS_TOL) AND (ABS(lift_vel) <= SPD_TOL) THEN
        phase := 15;
    END_IF;

15: (* FORK_CONNECT_LIFT : placement *)
    lift_want := LIFT_DOCK;
    b_want := FORK_CONNECT;
    IF is_new_phase THEN
        seq_ctr := seq_ctr + 1;
        D80 := 2; D81 := sel_station; D82 := seq_ctr;
    END_IF;
    port_ready := (sel_station = 1 AND X61) OR (sel_station = 2 AND X62);
    IF (ABS(D1004 - b_want) <= POS_TOL) AND (ABS(D1005) <= SPD_TOL) AND
       (ABS(lift_pos - LIFT_DOCK) <= POS_TOL) AND (ABS(lift_vel) <= SPD_TOL) AND port_ready THEN
        phase := 16;
    END_IF;

16: (* FORK_RETRIEVE_END : extraction, disengage before descend *)
    lift_want := LIFT_DOCK;
    b_want := FORK_RETRIEVE;
    IF is_new_phase THEN
        seq_ctr := seq_ctr + 1;
        D80 := 1; D81 := sel_station; D82 := seq_ctr;
    END_IF;
    port_ready := (sel_station = 1 AND X61) OR (sel_station = 2 AND X62);
    IF (ABS(D1004 - b_want) <= POS_TOL) AND (ABS(D1005) <= SPD_TOL) AND port_ready THEN
        phase := 17;
    END_IF;

17: (* LIFT_DESCEND *)
    lift_want := LIFT_HOME;
    IF (ABS(lift_pos - LIFT_HOME) <= POS_TOL) AND (ABS(lift_vel) <= SPD_TOL) THEN
        phase := 18;
    END_IF;

18: (* RESPOND completion *)
    IF cur_req = 0 THEN
        D300 := sel_id; D301 := 1; r0_completed := TRUE;
    ELSE
        D302 := sel_id; D303 := 1; r1_completed := TRUE;
    END_IF;
    phase := 0;

80: (* CANCEL_RETRIEVE *)
    CASE cancel_step OF
    0:
        lift_want := LIFT_DOCK;
        b_want := FORK_RETRIEVE;
        IF (ABS(D1004 - b_want) <= POS_TOL) AND (ABS(D1005) <= SPD_TOL) THEN
            cancel_step := 1;
        END_IF;
    1:
        lift_want := LIFT_DOCK;
        a_want := sel_station_raw;
        IF (ABS(D1000 - a_want) <= POS_TOL) AND (ABS(D1001) <= SPD_TOL) AND
           (ABS(lift_pos - LIFT_DOCK) <= POS_TOL) AND (ABS(lift_vel) <= SPD_TOL) THEN
            cancel_step := 2;
        END_IF;
    2:
        lift_want := LIFT_DOCK;
        b_want := FORK_CONNECT;
        port_ready := (sel_station = 1 AND X61) OR (sel_station = 2 AND X62);
        IF is_new_cstep THEN
            seq_ctr := seq_ctr + 1;
            D80 := 2; D81 := sel_station; D82 := seq_ctr;
        END_IF;
        IF (ABS(D1004 - b_want) <= POS_TOL) AND (ABS(D1005) <= SPD_TOL) AND port_ready THEN
            cancel_step := 3;
        END_IF;
    3:
        b_want := FORK_RETRIEVE;
        port_ready := (sel_station = 1 AND X61) OR (sel_station = 2 AND X62);
        IF is_new_cstep THEN
            seq_ctr := seq_ctr + 1;
            D80 := 1; D81 := sel_station; D82 := seq_ctr;
        END_IF;
        IF (ABS(D1004 - b_want) <= POS_TOL) AND (ABS(D1005) <= SPD_TOL) AND port_ready THEN
            cancel_step := 4;
        END_IF;
    4:
        lift_want := LIFT_HOME;
        IF (ABS(lift_pos - LIFT_HOME) <= POS_TOL) AND (ABS(lift_vel) <= SPD_TOL) THEN
            phase := 81;
        END_IF;
    ELSE
        cancel_step := 0;
    END_CASE;

81: (* CANCEL_RESPOND *)
    IF cur_req = 0 THEN
        D300 := sel_id; D301 := 2; r0_completed := TRUE;
    ELSE
        D302 := sel_id; D303 := 2; r1_completed := TRUE;
    END_IF;
    phase := 0;
    cancel_step := 0;

ELSE
    phase := 0;
END_CASE;

(* ---- write lift axis outputs ---- *)
IF cur_req = 0 THEN
    D2008 := lift_want; D2009 := 1000; D2010 := 0; Y42 := TRUE;
    D2012 := LIFT_HOME; D2013 := 1000; D2014 := 0; Y43 := TRUE;
ELSE
    D2012 := lift_want; D2013 := 1000; D2014 := 0; Y43 := TRUE;
    D2008 := LIFT_HOME; D2009 := 1000; D2010 := 0; Y42 := TRUE;
END_IF;

(* ---- write shared axis outputs ---- *)
D2000 := a_want; D2001 := 1000; D2002 := 0; Y40 := TRUE;
D2004 := b_want; D2005 := 1000; D2006 := 0; Y41 := TRUE;
D2016 := s30_want; D2017 := 1000; D2018 := 0; Y44 := TRUE;
D2020 := s31_want; D2021 := 1000; D2022 := 0; Y45 := TRUE;
D2024 := s40_want; D2025 := 1000; D2026 := 0; Y46 := TRUE;
D2028 := s41_want; D2029 := 1000; D2030 := 0; Y47 := TRUE;

Y30 := FALSE;

(* ---- final completion check ---- *)
all_home := (ABS(D1000 - 0) <= POS_TOL) AND (ABS(D1001) <= SPD_TOL) AND
            (ABS(D1004 - FORK_RETRIEVE) <= POS_TOL) AND (ABS(D1005) <= SPD_TOL) AND
            (ABS(D1016 - CELL_HOME) <= POS_TOL) AND (ABS(D1017) <= SPD_TOL) AND
            (ABS(D1020 - CELL_HOME) <= POS_TOL) AND (ABS(D1021) <= SPD_TOL) AND
            (ABS(D1024 - CELL_HOME) <= POS_TOL) AND (ABS(D1025) <= SPD_TOL) AND
            (ABS(D1028 - CELL_HOME) <= POS_TOL) AND (ABS(D1029) <= SPD_TOL) AND
            (ABS(D1008 - LIFT_HOME) <= POS_TOL) AND (ABS(D1009) <= SPD_TOL) AND
            (ABS(D1012 - LIFT_HOME) <= POS_TOL) AND (ABS(D1013) <= SPD_TOL);

ready_for_completion := r0_completed AND r1_completed AND X51 AND all_home;

obs_timer(IN := ready_for_completion, PT := T#100ms);
IF obs_timer.Q THEN
    y2_latch := TRUE;
END_IF;
Y2 := y2_latch;

prev_phase_stored := phase;
prev_cstep_stored := cancel_step;

END_PROGRAM