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
    (* Internal variables *)
    req0_state : INT := 0;
    req1_state : INT := 0;
    seq_cnt : DINT := 0;
    req0_lane : INT := 0;
    req1_lane : INT := 0;
    req0_angle : DINT := 0;
    req1_angle : DINT := 0;
    req0_acked : BOOL := FALSE;
    req1_acked : BOOL := FALSE;
    t_hold : TON;
    t_c3_wait : TON;
    t_c4_wait : TON;
    t_complete : TON;
    curr_req : INT := 0;
    c3_configured : BOOL := FALSE;
    c4_configured : BOOL := FALSE;
END_VAR

CONST
    TOL := 20;
    VEL_TOL := 100;
    RATE_MED := 500;
    DOCK1 := -360000;
    DOCK2 := -230000;
    DOCK3 := 490000;
    DOCK4 := 1140000;
    DOCK_H := 73250;
    HOME_LIFT := 15000;
    FORK_EXT := 18000;
    FORK_RET := 0;
    S41_ROT_LIMIT := 50000;
    S41_EXT := 70000;
    S41_HOME := 5000;
    HOME_SHUTTLE := 0;
    HOME_FORK := 0;
    S3_HOME := 0;
    S40_HOME := 0;
END_CONST

(* Helper macro-like logic via inline checks *)
(* State machine for request r_idx: 0 or 1 *)
PROCEDURE ProcessRequest(r_idx : INT)
VAR_INPUT
    r_idx : INT;
END_VAR
VAR
    st : INT;
    port : DINT;
    lift_en : BOOL;
    lift_pos : DINT;
    lift_vel : DINT;
    lift_tgt : DINT;
    lift_rate : DINT;
    lift_ff : DINT;
    lane : INT;
    angle : DINT;
    cancelled : BOOL;
    returned : BOOL;
    ack_out : DINT;
    status_out : DINT;
BEGIN
    IF r_idx = 0 THEN
        st := req0_state;
        port := DOCK1;
        lift_en := Y42;
        lift_pos := D1008;
        lift_vel := D1009;
        lane := req0_lane;
        angle := req0_angle;
        cancelled := X31;
        returned := X30;
        ack_out := D300;
        status_out := D301;
    ELSE
        st := req1_state;
        port := DOCK2;
        lift_en := Y43;
        lift_pos := D1012;
        lift_vel := D1013;
        lane := req1_lane;
        angle := req1_angle;
        cancelled := X35;
        returned := X34;
        ack_out := D302;
        status_out := D303;
    END_IF;

    IF returned AND NOT ((r_idx = 0 AND req0_acked) OR (r_idx = 1 AND req1_acked)) THEN
        ack_out := D100 + r_idx * 20; (* Request ID *)
        status_out := 2; (* Cancellation/Retrieval *)
        IF cancelled THEN status_out := 2; ELSE status_out := 1; END_IF;
        IF r_idx = 0 THEN req0_acked := TRUE; req0_state := 19;
        ELSE req1_acked := TRUE; req1_state := 19; END_IF;
        RETURN;
    END_IF;

    IF cancelled AND st > 0 AND st < 19 THEN
        st := 14; (* Force return to lift *)
    END_IF;

    CASE st OF
        0: (* IDLE / WAIT *)
            Y40 := FALSE; D2000 := HOME_SHUTTLE; D2001 := 0; D2002 := 0;
            Y41 := FALSE; D2004 := FORK_RET; D2005 := 0; D2006 := 0;
            lift_en := FALSE; lift_tgt := HOME_LIFT; lift_rate := 0; lift_ff := 0;
            Y44 := FALSE; D2016 := S3_HOME; D2017 := 0; D2018 := 0;
            Y45 := FALSE; D2020 := S3_HOME; D2021 := 0; D2022 := 0;
            Y46 := FALSE; D2024 := S3_HOME; D2025 := 0; D2026 := 0;
            Y47 := FALSE; D2028 := S40_HOME; D2029 := 0; D2030 := 0;
            Y48 := FALSE; D2032 := S41_HOME; D2033 := 0; D2034 := 0;
            Y30 := FALSE;
            Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0;
            Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0;
            D80 := 0; D81 := 0;
            IF r_idx = 0 THEN req0_lane := INT_TO_INT(D520); req0_angle := D527;
            ELSE req1_lane := INT_TO_INT(D620); req1_angle := D627; END_IF;
            st := 1;
        1: (* LIFT UP *)
            lift_en := TRUE; lift_tgt := DOCK_H; lift_rate := RATE_MED; lift_ff := 0;
            IF ABS(lift_pos - DOCK_H) < TOL AND ABS(lift_vel) < VEL_TOL THEN st := 2; END_IF;
        2: (* SHUTTLE TO LIFT *)
            Y40 := TRUE; D2000 := port; D2001 := RATE_MED; D2002 := 0;
            Y41 := FALSE; D2004 := FORK_RET; D2005 := 0; D2006 := 0;
            IF ABS(D1000 - port) < TOL AND ABS(D1001) < VEL_TOL THEN st := 3; END_IF;
        3: (* FORK EXTEND *)
            Y41 := TRUE; D2004 := FORK_EXT; D2005 := RATE_MED; D2006 := 0;
            IF ABS(D1004 - FORK_EXT) < TOL AND ABS(D1005) < VEL_TOL THEN st := 4; END_IF;
        4: (* CLAIM LIFT *)
            D81 := (IF r_idx = 0 THEN 1 ELSE 2 END_IF);
            D80 := 1; (* Extract *)
            seq_cnt := seq_cnt + 1; D82 := seq_cnt;
            Y30 := TRUE;
            IF D90 = (D100 + r_idx * 20) THEN st := 5; END_IF;
        5: (* SHUTTLE TO C3 *)
            Y40 := TRUE; D2000 := DOCK3; D2001 := RATE_MED; D2002 := 0;
            Y41 := FALSE; D2004 := FORK_RET; D2005 := 0; D2006 := 0;
            IF ABS(D1000 - DOCK3) < TOL AND ABS(D1001) < VEL_TOL THEN st := 6; END_IF;
        6: (* CONFIG C3 *)
            Y70 := TRUE; D700 := lane; D701 := 0; D702 := 0;
            t_c3_wait(IN := TRUE, PT := T#80ms);
            IF t_c3_wait.Q THEN st := 7; END_IF;
        7: (* RETAIN C3 *)
            Y71 := TRUE;
            t_c3_wait(IN := FALSE, PT := T#80ms);
            IF X72 OR (t_c3_wait.ET > T#40ms) THEN st := 8; END_IF;
        8: (* FORK RETRACT C3 *)
            Y41 := TRUE; D2004 := FORK_RET; D2005 := RATE_MED; D2006 := 0;
            Y71 := FALSE;
            IF ABS(D1004 - FORK_RET) < TOL AND ABS(D1005) < VEL_TOL THEN st := 9; END_IF;
        9: (* SHUTTLE TO C4 *)
            Y40 := TRUE; D2000 := DOCK4; D2001 := RATE_MED; D2002 := 0;
            IF ABS(D1000 - DOCK4) < TOL AND ABS(D1001) < VEL_TOL THEN st := 10; END_IF;
        10: (* ROTATE C4 *)
            Y48 := TRUE; D2032 := S41_ROT_LIMIT; D2033 := RATE_MED; D2034 := 0;
            Y47 := TRUE; D2028 := angle; D2029 := RATE_MED; D2030 := 0;
            IF ABS(D1032 - S41_ROT_LIMIT) < TOL AND ABS(D1028 - angle) < TOL THEN st := 11; END_IF;
        11: (* EXTEND C4 *)
            Y48 := TRUE; D2032 := S41_EXT; D2033 := RATE_MED; D2034 := 0;
            IF ABS(D1032 - S41_EXT) < TOL AND ABS(D1033) < VEL_TOL THEN st := 12; END_IF;
        12: (* WAIT C4 *)
            Y75 := TRUE; D710 := lane; D711 := 0; D712 := 0;
            t_c4_wait(IN := TRUE, PT := T#80ms);
            IF t_c4_wait.Q OR X77 THEN st := 13; END_IF;
        13: (* RETRACT C4 *)
            Y48 := TRUE; D2032 := S41_HOME; D2033 := RATE_MED; D2034 := 0;
            Y75 := FALSE;
            Y47 := TRUE; D2028 := S40_HOME; D2029 := RATE_MED; D2030 := 0;
            IF ABS(D1032 - S41_HOME) < TOL AND ABS(D1028 - S40_HOME) < TOL THEN st := 14; END_IF;
        14: (* SHUTTLE TO LIFT RET *)
            Y40 := TRUE; D2000 := port; D2001 := RATE_MED; D2002 := 0;
            Y41 := FALSE; D2004 := FORK_RET; D2005 := 0; D2006 := 0;
            IF ABS(D1000 - port) < TOL AND ABS(D1001) < VEL_TOL THEN st := 15; END_IF;
        15: (* FORK EXTEND RET *)
            Y41 := TRUE; D2004 := FORK_EXT; D2005 := RATE_MED; D2006 := 0;
            IF ABS(D1004 - FORK_EXT) < TOL AND ABS(D1005) < VEL_TOL THEN st := 16; END_IF;
        16: (* PLACE LIFT *)
            D81 := (IF r_idx = 0 THEN 1 ELSE 2 END_IF);
            D80 := 2; (* Place *)
            seq_cnt := seq_cnt + 1; D82 := seq_cnt;
            Y30 := FALSE;
            IF D90 <> (D100 + r_idx * 20) OR X61 OR X62 THEN st := 17; END_IF;
        17: (* LIFT DOWN *)
            lift_en := TRUE; lift_tgt := HOME_LIFT; lift_rate := RATE_MED; lift_ff := 0;
            IF ABS(lift_pos - HOME_LIFT) < TOL AND ABS(lift_vel) < VEL_TOL THEN st := 18; END_IF;
        18: (* HOME ALL *)
            Y40 := TRUE; D2000 := HOME_SHUTTLE; D2001 := RATE_MED; D2002 := 0;
            Y41 := TRUE; D2004 := HOME_FORK; D2005 := RATE_MED; D2006 := 0;
            IF ABS(D1000) < TOL AND ABS(D1004) < TOL AND ABS(D1001) < VEL_TOL AND ABS(D1005) < VEL_TOL THEN st := 19; END_IF;
        19: (* DONE *)
            Y40 := FALSE; D2000 := 0; D2001 := 0; D2002 := 0;
            Y41 := FALSE; D2004 := 0; D2005 := 0; D2006 := 0;
            lift_en := FALSE; lift_tgt := 0; lift_rate := 0; lift_ff := 0;
            Y70 := FALSE; Y71 := FALSE;
            Y75 := FALSE; Y76 := FALSE;
            D80 := 0; D81 := 0;
    END_CASE;

    IF r_idx = 0 THEN req0_state := st;
    ELSE req1_state := st; END_IF;
END_PROCEDURE;

BEGIN
    (* Assign lift outputs based on internal tracking variables *)
    (* Note: In ST, we can't easily pass outputs by reference to a procedure without VAR_IN_OUT.
       I will inline the logic or use direct assignments to keep it simple and compliant. *)
    (* Re-implementing inline for correctness and simplicity *)
    
    (* Initialize defaults *)
    Y40 := FALSE; D2000 := 0; D2001 := 0; D2002 := 0;
    Y41 := FALSE; D2004 := 0; D2005 := 0; D2006 := 0;
    Y42 := FALSE; D2008 := 0; D2009 := 0; D2010 := 0;
    Y43 := FALSE; D2012 := 0; D2013 := 0; D2014 := 0;
    Y44 := FALSE; D2016 := 0; D2017 := 0; D2018 := 0;
    Y45 := FALSE; D2020 := 0; D2021 := 0; D2022 := 0;
    Y46 := FALSE; D2024 := 0; D2025 := 0; D2026 := 0;
    Y47 := FALSE; D2028 := 0; D2029 := 0; D2030 := 0;
    Y48 := FALSE; D2032 := 0; D2033 := 0; D2034 := 0;
    Y30 := FALSE;
    Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
    Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
    D80 := 0; D81 := 0; D82 := seq_cnt;

    (* Process Request 0 *)
    IF req0_acked THEN
        req0_state := 19;
    END_IF;

    CASE req0_state OF
        0:
            req0_lane := INT_TO_INT(D520); req0_angle := D527;
            req0_state := 1;
        1:
            Y42 := TRUE; D2008 := DOCK_H; D2009 := RATE_MED;
            IF ABS(D1008 - DOCK_H) < TOL AND ABS(D1009) < VEL_TOL THEN req0_state := 2; END_IF;
        2:
            Y40 := TRUE; D2000 := DOCK1; D2001 := RATE_MED;
            Y41 := FALSE; D2004 := FORK_RET;
            IF ABS(D1000 - DOCK1) < TOL AND ABS(D1001) < VEL_TOL THEN req0_state := 3; END_IF;
        3:
            Y41 := TRUE; D2004 := FORK_EXT; D2005 := RATE_MED;
            IF ABS(D1004 - FORK_EXT) < TOL AND ABS(D1005) < VEL_TOL THEN req0_state := 4; END_IF;
        4:
            D81 := 1; D80 := 1; seq_cnt := seq_cnt + 1; D82 := seq_cnt; Y30 := TRUE;
            IF D90 = D100 THEN req0_state := 5; END_IF;
        5:
            Y40 := TRUE; D2000 := DOCK3; D2001 := RATE_MED;
            Y41 := FALSE; D2004 := FORK_RET;
            IF ABS(D1000 - DOCK3) < TOL AND ABS(D1001) < VEL_TOL THEN req0_state := 6; END_IF;
        6:
            Y70 := TRUE; D700 := req0_lane; D701 := 0;
            t_c3_wait(IN := TRUE, PT := T#80ms);
            IF t_c3_wait.Q THEN req0_state := 7; END_IF;
        7:
            Y71 := TRUE; t_c3_wait(IN := FALSE, PT := T#80ms);
            IF X72 OR t_c3_wait.ET > T#40ms THEN req0_state := 8; END_IF;
        8:
            Y41 := TRUE; D2004 := FORK_RET; D2005 := RATE_MED;
            Y71 := FALSE;
            IF ABS(D1004 - FORK_RET) < TOL AND ABS(D1005) < VEL_TOL THEN req0_state := 9; END_IF;
        9:
            Y40 := TRUE; D2000 := DOCK4; D2001 := RATE_MED;
            IF ABS(D1000 - DOCK4) < TOL AND ABS(D1001) < VEL_TOL THEN req0_state := 10; END_IF;
        10:
            Y48 := TRUE; D2032 := S41_ROT_LIMIT; D2033 := RATE_MED;
            Y47 := TRUE; D2028 := req0_angle; D2029 := RATE_MED;
            IF ABS(D1032 - S41_ROT_LIMIT) < TOL AND ABS(D1028 - req0_angle) < TOL THEN req0_state := 11; END_IF;
        11:
            Y48 := TRUE; D2032 := S41_EXT; D2033 := RATE_MED;
            IF ABS(D1032 - S41_EXT) < TOL AND ABS(D1033) < VEL_TOL THEN req0_state := 12; END_IF;
        12:
            Y75 := TRUE; D710 := req0_lane; D711 := 0;
            t_c4_wait(IN := TRUE, PT := T#80ms);
            IF t_c4_wait.Q OR X77 THEN req0_state := 13; END_IF;
        13:
            Y48 := TRUE; D2032 := S41_HOME; D2033 := RATE_MED;
            Y75 := FALSE;
            Y47 := TRUE; D2028 := S40_HOME; D2029 := RATE_MED;
            IF ABS(D1032 - S41_HOME) < TOL AND ABS(D1028 - S40_HOME) < TOL THEN req0_state := 14; END_IF;
        14:
            Y40 := TRUE; D2000 := DOCK1; D2001 := RATE_MED;
            Y41 := FALSE; D2004 := FORK_RET;
            IF ABS(D1000 - DOCK1) < TOL AND ABS(D1001) < VEL_TOL THEN req0_state := 15; END_IF;
        15:
            Y41 := TRUE; D2004 := FORK_EXT; D2005 := RATE_MED;
            IF ABS(D1004 - FORK_EXT) < TOL AND ABS(D1005) < VEL_TOL THEN req0_state := 16; END_IF;
        16:
            D81 := 1; D80 := 2; seq_cnt := seq_cnt + 1; D82 := seq_cnt; Y30 := FALSE;
            IF D90 <> D100 OR X61 THEN req0_state := 17; END_IF;
        17:
            Y42 := TRUE; D2008 := HOME_LIFT; D2009 := RATE_MED;
            IF ABS(D1008 - HOME_LIFT) < TOL AND ABS(D1009) < VEL_TOL THEN req0_state := 18; END_IF;
        18:
            Y40 := TRUE; D2000 := HOME_SHUTTLE; D2001 := RATE_MED;
            Y41 := TRUE; D2004 := HOME_FORK; D2005 := RATE_MED;
            IF ABS(D1000) < TOL AND ABS(D1004) < TOL THEN req0_state := 19; END_IF;
        19:
            NULL;
    END_CASE;

    (* Process Request 1 if 0 is done or idle *)
    IF req0_state >= 18 THEN
        IF req1_acked THEN req1_state := 19; END_IF;
        CASE req1_state OF
            0:
                req1_lane := INT_TO_INT(D620); req1_angle := D627;
                req1_state := 1;
            1:
                Y43 := TRUE; D2012 := DOCK_H; D2013 := RATE_MED;
                IF ABS(D1012 - DOCK_H) < TOL AND ABS(D1013) < VEL_TOL THEN req1_state := 2; END_IF;
            2:
                Y40 := TRUE; D2000 := DOCK2; D2001 := RATE_MED;
                Y41 := FALSE; D2004 := FORK_RET;
                IF ABS(D1000 - DOCK2) < TOL AND ABS(D1001) < VEL_TOL THEN req1_state := 3; END_IF;
            3:
                Y41 := TRUE; D2004 := FORK_EXT; D2005 := RATE_MED;
                IF ABS(D1004 - FORK_EXT) < TOL AND ABS(D1005) < VEL_TOL THEN req1_state := 4; END_IF;
            4:
                D81 := 2; D80 := 1; seq_cnt := seq_cnt + 1; D82 := seq_cnt; Y30 := TRUE;
                IF D90 = D120 THEN req1_state := 5; END_IF;
            5:
                Y40 := TRUE; D2000 := DOCK3; D2001 := RATE_MED;
                Y41 := FALSE; D2004 := FORK_RET;
                IF ABS(D1000 - DOCK3) < TOL AND ABS(D1001) < VEL_TOL THEN req1_state := 6; END_IF;
            6:
                Y70 := TRUE; D700 := req1_lane; D701 := 0;
                t_c3_wait(IN := TRUE, PT := T#80ms);
                IF t_c3_wait.Q THEN req1_state := 7; END_IF;
            7:
                Y71 := TRUE; t_c3_wait(IN := FALSE, PT := T#80ms);
                IF X72 OR t_c3_wait.ET > T#40ms THEN req1_state := 8; END_IF;
            8:
                Y41 := TRUE; D2004 := FORK_RET; D2005 := RATE_MED;
                Y71 := FALSE;
                IF ABS(D1004 - FORK_RET) < TOL AND ABS(D1005) < VEL_TOL THEN req1_state := 9; END_IF;
            9:
                Y40 := TRUE; D2000 := DOCK4; D2001 := RATE_MED;
                IF ABS(D1000 - DOCK4) < TOL AND ABS(D1001) < VEL_TOL THEN req1_state := 10; END_IF;
            10:
                Y48 := TRUE; D2032 := S41_ROT_LIMIT; D2033 := RATE_MED;
                Y47 := TRUE; D2028 := req1_angle; D2029 := RATE_MED;
                IF ABS(D1032 - S41_ROT_LIMIT) < TOL AND ABS(D1028 - req1_angle) < TOL THEN req1_state := 11; END_IF;
            11:
                Y48 := TRUE; D2032 := S41_EXT; D2033 := RATE_MED;
                IF ABS(D1032 - S41_EXT) < TOL AND ABS(D1033) < VEL_TOL THEN req1_state := 12; END_IF;
            12:
                Y75 := TRUE; D710 := req1_lane; D711 := 0;
                t_c4_wait(IN := TRUE, PT := T#80ms);
                IF t_c4_wait.Q OR X77 THEN req1_state := 13; END_IF;
            13:
                Y48 := TRUE; D2032 := S41_HOME; D2033 := RATE_MED;
                Y75 := FALSE;
                Y47 := TRUE; D2028 := S40_HOME; D2029 := RATE_MED;
                IF ABS(D1032 - S41_HOME) < TOL AND ABS(D1028 - S40_HOME) < TOL THEN req1_state := 14; END_IF;
            14:
                Y40 := TRUE; D2000 := DOCK2; D2001 := RATE_MED;
                Y41 := FALSE; D2004 := FORK_RET;
                IF ABS(D1000 - DOCK2) < TOL AND ABS(D1001) < VEL_TOL THEN req1_state := 15; END_IF;
            15:
                Y41 := TRUE; D2004 := FORK_EXT; D2005 := RATE_MED;
                IF ABS(D1004 - FORK_EXT) < TOL AND ABS(D1005) < VEL_TOL THEN req1_state := 16; END_IF;
            16:
                D81 := 2; D80 := 2; seq_cnt := seq_cnt + 1; D82 := seq_cnt; Y30 := FALSE;
                IF D90 <> D120 OR X62 THEN req1_state := 17; END_IF;
            17:
                Y43 := TRUE; D2012 := HOME_LIFT; D2013 := RATE_MED;
                IF ABS(D1012 - HOME_LIFT) < TOL AND ABS(D1013) < VEL_TOL THEN req1_state := 18; END_IF;
            18:
                Y40 := TRUE; D2000 := HOME_SHUTTLE; D2001 := RATE_MED;
                Y41 := TRUE; D2004 := HOME_FORK; D2005 := RATE_MED;
                IF ABS(D1000) < TOL AND ABS(D1004) < TOL THEN req1_state := 19; END_IF;
            19:
                NULL;
        END_CASE;
    END_IF;

    (* Completion Check *)
    IF (req0_state = 19 OR req0_acked) AND (req1_state = 19 OR req1_acked) THEN
        IF ABS(D1000) < TOL AND ABS(D1004) < TOL AND 
           ABS(D1008 - HOME_LIFT) < TOL AND ABS(D1012 - HOME_LIFT) < TOL AND
           ABS(D1016) < TOL AND ABS(D1020) < TOL AND ABS(D1024) < TOL AND
           ABS(D1028) < TOL AND ABS(D1032 - S41_HOME) < TOL THEN
            t_hold(IN := TRUE, PT := T#100ms);
            IF t_hold.Q THEN Y2 := TRUE; END_IF;
        ELSE
            t_hold(IN := FALSE, PT := T#100ms);
        END_IF;
    ELSE
        Y2 := FALSE;
        t_hold(IN := FALSE, PT := T#100ms);
    END_IF;

END_PROGRAM