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

    (* Internal state variables *)
    r0_id : DINT;
    r0_loc : DINT;
    r0_progress : DINT;
    r0_due : DINT;
    r0_status : DINT;
    r0_active : BOOL;
    r0_state : INT;
    r0_ack_sent : BOOL;

    r1_id : DINT;
    r1_loc : DINT;
    r1_progress : DINT;
    r1_due : DINT;
    r1_status : DINT;
    r1_active : BOOL;
    r1_state : INT;
    r1_ack_sent : BOOL;

    (* Timers *)
    settle_timer : TON;
    settle_timer2 : TON;
    complete_hold_timer : TON;
    edge_ret0 : R_TRIG;
    edge_ret1 : R_TRIG;
    edge_can0 : R_TRIG;
    edge_can1 : R_TRIG;
    edge_prog0 : R_TRIG;
    edge_prog1 : R_TRIG;

    (* Counters and flags *)
    couple_seq_val : DINT;
    cell3_in_use : BOOL;
    cell4_in_use : BOOL;
    shuttle_busy : BOOL;
    complete_valid : BOOL;

    (* Position scaling *)
    a_pos : REAL;
    a_vel : REAL;
    b_pos : REAL;
    b_vel : REAL;
    c_pos : REAL;
    c_vel : REAL;
    d_pos : REAL;
    d_vel : REAL;
    s30_pos : REAL;
    s30_vel : REAL;
    s31_pos : REAL;
    s31_vel : REAL;
    s32_pos : REAL;
    s32_vel : REAL;
    s40_pos : REAL;
    s40_vel : REAL;
    s41_pos : REAL;
    s41_vel : REAL;

    (* Sway tracking *)
    prev_s32_pos : REAL;
    sway_angle : REAL;
    sway_vel : REAL;
    sway_settle_time : TIME;

    (* Derived signals *)
    at_cell3 : BOOL;
    at_cell4 : BOOL;
    at_lift : BOOL;
    connected : BOOL;

    (* Constants *)
    STN1_POS : DINT := -405000;
    STN2_POS : DINT := -185000;
    STN3_POS : DINT := 90000;
    STN4_POS : DINT := 470000;
    LIFT_DOCK : DINT := 95000;
    FORK_CONN : DINT := 18000;
    FORK_HOME : DINT := 0;
    LIFT_HOME_C : DINT := 40000;
    LIFT_HOME_D : DINT := 40000;
    S30_HOME : DINT := 100000;
    S31_HOME : DINT := 0;
    S32_HOME : DINT := 0;
    S40_HOME : DINT := 0;
    S41_HOME : DINT := 0;

    (* State constants *)
    ST_IDLE : INT := 0;
    ST_REQ_MOVE : INT := 1;
    ST_REQ_CONNECT : INT := 2;
    ST_REQ_CELL3 : INT := 3;
    ST_REQ_CELL4 : INT := 4;
    ST_REQ_RET_MOVE : INT := 5;
    ST_REQ_RET_CONNECT : INT := 6;
    ST_REQ_RET_DISCONNECT : INT := 7;
    ST_REQ_DONE : INT := 8;
    ST_CANCEL : INT := 9;
    ST_CANCEL_RET : INT := 10;
END_VAR

(* Scale inputs from 0.01 units *)
a_pos := REAL(D1000) / 100.0;
a_vel := REAL(D1001) / 100.0;
b_pos := REAL(D1004) / 100.0;
b_vel := REAL(D1005) / 100.0;
c_pos := REAL(D1008) / 100.0;
c_vel := REAL(D1009) / 100.0;
d_pos := REAL(D1012) / 100.0;
d_vel := REAL(D1013) / 100.0;
s30_pos := REAL(D1016) / 100.0;
s30_vel := REAL(D1017) / 100.0;
s31_pos := REAL(D1020) / 100.0;
s31_vel := REAL(D1021) / 100.0;
s32_pos := REAL(D1024) / 100.0;
s32_vel := REAL(D1025) / 100.0;
s40_pos := REAL(D1028) / 100.0;
s40_vel := REAL(D1029) / 100.0;
s41_pos := REAL(D1032) / 100.0;
s41_vel := REAL(D1033) / 100.0;

(* Update edge triggers *)
edge_ret0(CLK := X30);
edge_ret1(CLK := X34);
edge_can0(CLK := X31);
edge_can1(CLK := X35);
edge_prog0(CLK := D102 > 0);
edge_prog1(CLK := D122 > 0);

(* Detect request arrivals *)
IF (NOT r0_active) AND (D100 > 0) AND (D102 = 0) THEN
    r0_active := TRUE;
    r0_id := D100;
    r0_loc := D101;
    r0_due := D103;
    r0_progress := D102;
    r0_status := 0;
    r0_state := ST_REQ_MOVE;
    r0_ack_sent := FALSE;
END_IF;

IF (NOT r1_active) AND (D120 > 0) AND (D122 = 0) THEN
    r1_active := TRUE;
    r1_id := D120;
    r1_loc := D121;
    r1_due := D123;
    r1_progress := D122;
    r1_status := 0;
    r1_state := ST_REQ_MOVE;
    r1_ack_sent := FALSE;
END_IF;

(* Update progress tracking *)
IF r0_active THEN
    IF D102 > r0_progress THEN
        r0_progress := D102;
    END_IF;
END_IF;

IF r1_active THEN
    IF D122 > r1_progress THEN
        r1_progress := D122;
    END_IF;
END_IF;

(* Determine shuttle target station based on active requests *)
shuttle_busy := (r0_state >= ST_REQ_MOVE) AND (r0_state <= ST_REQ_RET_DISCONNECT);
IF NOT shuttle_busy THEN
    shuttle_busy := (r1_state >= ST_REQ_MOVE) AND (r1_state <= ST_REQ_RET_DISCONNECT);
END_IF;

(* Determine docking positions *)
IF r0_active AND (r0_loc = 0) THEN
    station_target := STN1_POS;
ELSIF r0_active AND (r0_loc = 1) THEN
    station_target := STN2_POS;
ELSIF r1_active AND (r1_loc = 0) THEN
    station_target := STN1_POS;
ELSIF r1_active AND (r1_loc = 1) THEN
    station_target := STN2_POS;
ELSE
    station_target := 0;
END_IF;

(* Connection geometry - determine current station *)
IF ABS(a_pos + 4050.0) < 2.0 THEN
    at_lift := TRUE;
ELSIF ABS(a_pos + 1850.0) < 2.0 THEN
    at_lift := TRUE;
ELSIF ABS(a_pos - 900.0) < 2.0 THEN
    at_cell3 := TRUE;
ELSIF ABS(a_pos - 4700.0) < 2.0 THEN
    at_cell4 := TRUE;
ELSE
    at_lift := FALSE;
    at_cell3 := FALSE;
    at_cell4 := FALSE;
END_IF;

(* Check if connected (fork extended) *)
IF b_pos > 170.0 THEN
    connected := TRUE;
ELSE
    connected := FALSE;
END_IF;

(* Hoist sway calculation *)
sway_angle := s32_pos;
sway_vel := s32_vel;

(* Sway settling detection *)
IF (ABS(sway_angle) <= 0.03) AND (ABS(sway_vel) <= 0.15) THEN
    settle_timer(IN := TRUE, PT := T#30ms);
ELSE
    settle_timer(IN := FALSE, PT := T#30ms);
END_IF;

(* Default output assignments - home all axes *)
(* Shuttle axis A *)
IF (r0_state = ST_IDLE) AND (r1_state = ST_IDLE) THEN
    D2000 := 0;
    D2001 := 500;
    D2002 := 0;
    Y40 := TRUE;
ELSIF r0_state = ST_REQ_MOVE THEN
    D2000 := station_target;
    D2001 := 800;
    D2002 := 0;
    Y40 := TRUE;
ELSIF r0_state = ST_REQ_CELL3 THEN
    D2000 := STN3_POS;
    D2001 := 800;
    D2002 := 0;
    Y40 := TRUE;
ELSIF r0_state = ST_REQ_CELL4 THEN
    D2000 := STN4_POS;
    D2001 := 800;
    D2002 := 0;
    Y40 := TRUE;
ELSIF r0_state = ST_REQ_RET_MOVE THEN
    D2000 := station_target;
    D2001 := 800;
    D2002 := 0;
    Y40 := TRUE;
ELSIF r1_state = ST_REQ_MOVE THEN
    D2000 := station_target;
    D2001 := 800;
    D2002 := 0;
    Y40 := TRUE;
ELSIF r1_state = ST_REQ_CELL3 THEN
    D2000 := STN3_POS;
    D2001 := 800;
    D2002 := 0;
    Y40 := TRUE;
ELSIF r1_state = ST_REQ_CELL4 THEN
    D2000 := STN4_POS;
    D2001 := 800;
    D2002 := 0;
    Y40 := TRUE;
ELSIF r1_state = ST_REQ_RET_MOVE THEN
    D2000 := station_target;
    D2001 := 800;
    D2002 := 0;
    Y40 := TRUE;
ELSE
    D2000 := 0;
    D2001 := 500;
    D2002 := 0;
    Y40 := TRUE;
END_IF;

(* Fork axis B *)
IF (r0_state = ST_REQ_CONNECT) OR (r0_state = ST_REQ_RET_CONNECT) OR
   (r0_state = ST_REQ_CELL3) OR (r0_state = ST_REQ_CELL4) OR
   (r1_state = ST_REQ_CONNECT) OR (r1_state = ST_REQ_RET_CONNECT) OR
   (r1_state = ST_REQ_CELL3) OR (r1_state = ST_REQ_CELL4) THEN
    D2004 := FORK_CONN;
    D2005 := 600;
    D2006 := 0;
    Y41 := TRUE;
ELSE
    D2004 := FORK_HOME;
    D2005 := 600;
    D2006 := 0;
    Y41 := TRUE;
END_IF;

(* Lift axis C *)
IF (r0_state = ST_REQ_CONNECT) OR (r0_state = ST_REQ_RET_CONNECT) OR
   (r0_state = ST_REQ_RET_DISCONNECT) OR
   (r1_state = ST_REQ_CONNECT) OR (r1_state = ST_REQ_RET_CONNECT) OR
   (r1_state = ST_REQ_RET_DISCONNECT) THEN
    D2008 := LIFT_DOCK;
    D2009 := 600;
    D2010 := 0;
    Y42 := TRUE;
ELSIF (r0_state >= ST_REQ_RET_DISCONNECT) AND (r0_state <= ST_REQ_DONE) THEN
    D2008 := LIFT_HOME_C;
    D2009 := 500;
    D2010 := 0;
    Y42 := TRUE;
ELSE
    D2008 := LIFT_HOME_C;
    D2009 := 500;
    D2010 := 0;
    Y42 := TRUE;
END_IF;

(* Lift axis D *)
D2012 := LIFT_HOME_D;
D2013 := 500;
D2014 := 0;
Y43 := TRUE;

(* Cell 3 - Hoist axes *)
IF r0_state = ST_REQ_CELL3 THEN
    D2016 := D500;
    D2017 := D501;
    D2018 := D502;
    Y44 := TRUE;
    Y45 := TRUE;
    Y46 := TRUE;
    D2024 := 0;
    D2025 := 500;
    D2026 := 0;
    Y70 := TRUE;
    Y71 := FALSE;
    D700 := r0_id;
    D701 := D526;
    D702 := 500;
ELSIF r1_state = ST_REQ_CELL3 THEN
    D2016 := D500;
    D2017 := D501;
    D2018 := D502;
    Y44 := TRUE;
    Y45 := TRUE;
    Y46 := TRUE;
    D2024 := 0;
    D2025 := 500;
    D2026 := 0;
    Y70 := TRUE;
    Y71 := FALSE;
    D700 := r1_id;
    D701 := D526;
    D702 := 500;
ELSE
    D2016 := S30_HOME;
    D2017 := S31_HOME;
    D2018 := 0;
    Y44 := TRUE;
    Y45 := TRUE;
    Y46 := FALSE;
    D2024 := S32_HOME;
    D2025 := 500;
    D2026 := 0;
    Y70 := FALSE;
    Y71 := FALSE;
    D700 := 0;
    D701 := 0;
    D702 := 0;
END_IF;

(* Cell 4 - Balanced inclined head *)
IF r0_state = ST_REQ_CELL4 THEN
    D2028 := D600;
    D2029 := D601;
    D2030 := 0;
    Y47 := TRUE;
    Y48 := TRUE;
    Y75 := TRUE;
    Y76 := FALSE;
    D710 := r0_id;
    D711 := D626;
    D712 := 500;
ELSIF r1_state = ST_REQ_CELL4 THEN
    D2028 := D600;
    D2029 := D601;
    D2030 := 0;
    Y47 := TRUE;
    Y48 := TRUE;
    Y75 := TRUE;
    Y76 := FALSE;
    D710 := r1_id;
    D711 := D626;
    D712 := 500;
ELSE
    D2028 := S40_HOME;
    D2029 := S41_HOME;
    D2030 := 0;
    Y47 := TRUE;
    Y48 := TRUE;
    Y75 := FALSE;
    Y76 := FALSE;
    D710 := 0;
    D711 := 0;
    D712 := 0;
END_IF;

(* Brake control *)
IF (r0_state = ST_IDLE) AND (r1_state = ST_IDLE) THEN
    Y30 := TRUE;
ELSE
    Y30 := FALSE;
END_IF;

(* Action and station outputs *)
D80 := 0;
D81 := 0;
D82 := couple_seq_val;

IF r0_active AND (r0_state = ST_REQ_CONNECT) THEN
    D80 := 1;
    D81 := r0_loc + 1;
    couple_seq_val := couple_seq_val + 1;
    D82 := couple_seq_val;
ELSIF r1_active AND (r1_state = ST_REQ_CONNECT) THEN
    D80 := 1;
    D81 := r1_loc + 1;
    couple_seq_val := couple_seq_val + 1;
    D82 := couple_seq_val;
END_IF;

(* Request 0 state machine *)
CASE r0_state OF
    ST_IDLE:
        (* Wait for request *)
        NULL;

    ST_REQ_MOVE:
        (* Move shuttle to lift station *)
        IF ABS(a_pos - REAL(station_target) / 100.0) < 2.0 THEN
            IF ABS(a_vel) < 1.0 THEN
                r0_state := ST_REQ_CONNECT;
            END_IF;
        END_IF;

    ST_REQ_CONNECT:
        (* Connect at lift: raise lift, extend fork *)
        IF ABS(c_pos - REAL(LIFT_DOCK) / 100.0) < 2.0 AND ABS(b_pos - REAL(FORK_CONN) / 100.0) < 2.0 THEN
            r0_state := ST_REQ_CELL3;
        END_IF;

    ST_REQ_CELL3:
        (* Process at cell 3 - hoist *)
        IF X70 OR settle_timer.Q THEN
            r0_state := ST_REQ_CELL4;
        END_IF;

    ST_REQ_CELL4:
        (* Move to cell 4 *)
        IF ABS(a_pos - REAL(STN4_POS) / 100.0) < 2.0 THEN
            IF ABS(a_vel) < 1.0 THEN
                r0_state := ST_REQ_RET_MOVE;
            END_IF;
        END_IF;

    ST_REQ_RET_MOVE:
        (* Return to lift station *)
        IF ABS(a_pos - REAL(station_target) / 100.0) < 2.0 THEN
            IF ABS(a_vel) < 1.0 THEN
                r0_state := ST_REQ_RET_CONNECT;
            END_IF;
        END_IF;

    ST_REQ_RET_CONNECT:
        (* Reconnect at lift *)
        IF ABS(c_pos - REAL(LIFT_DOCK) / 100.0) < 2.0 AND ABS(b_pos - REAL(FORK_CONN) / 100.0) < 2.0 THEN
            r0_state := ST_REQ_RET_DISCONNECT;
        END_IF;

    ST_REQ_RET_DISCONNECT:
        (* Disconnect: retract fork, lower lift *)
        IF ABS(b_pos) < 2.0 AND ABS(c_pos - REAL(LIFT_HOME_C) / 100.0) < 2.0 THEN
            r0_state := ST_REQ_DONE;
        END_IF;

    ST_REQ_DONE:
        (* Send completion acknowledgment *)
        IF NOT r0_ack_sent THEN
            D300 := r0_id;
            D301 := 1;
            r0_ack_sent := TRUE;
        END_IF;
        r0_active := FALSE;
        r0_state := ST_IDLE;

    ST_CANCEL:
        r0_status := 2;
        r0_state := ST_CANCEL_RET;

    ST_CANCEL_RET:
        (* Cancelled - retrieve and return *)
        D300 := r0_id;
        D301 := 2;
        r0_active := FALSE;
        r0_state := ST_IDLE;
END_CASE;

(* Request 1 state machine *)
CASE r1_state OF
    ST_IDLE:
        NULL;

    ST_REQ_MOVE:
        IF ABS(a_pos - REAL(station_target) / 100.0) < 2.0 THEN
            IF ABS(a_vel) < 1.0 THEN
                r1_state := ST_REQ_CONNECT;
            END_IF;
        END_IF;

    ST_REQ_CONNECT:
        IF ABS(c_pos - REAL(LIFT_DOCK) / 100.0) < 2.0 AND ABS(b_pos - REAL(FORK_CONN) / 100.0) < 2.0 THEN
            r1_state := ST_REQ_CELL3;
        END_IF;

    ST_REQ_CELL3:
        IF X70 OR settle_timer.Q THEN
            r1_state := ST_REQ_CELL4;
        END_IF;

    ST_REQ_CELL4:
        IF ABS(a_pos - REAL(STN4_POS) / 100.0) < 2.0 THEN
            IF ABS(a_vel) < 1.0 THEN
                r1_state := ST_REQ_RET_MOVE;
            END_IF;
        END_IF;

    ST_REQ_RET_MOVE:
        IF ABS(a_pos - REAL(station_target) / 100.0) < 2.0 THEN
            IF ABS(a_vel) < 1.0 THEN
                r1_state := ST_REQ_RET_CONNECT;
            END_IF;
        END_IF;

    ST_REQ_RET_CONNECT:
        IF ABS(c_pos - REAL(LIFT_DOCK) / 100.0) < 2.0 AND ABS(b_pos - REAL(FORK_CONN) / 100.0) < 2.0 THEN
            r1_state := ST_REQ_RET_DISCONNECT;
        END_IF;

    ST_REQ_RET_DISCONNECT:
        IF ABS(b_pos) < 2.0 AND ABS(c_pos - REAL(LIFT_HOME_C) / 100.0) < 2.0 THEN
            r1_state := ST_REQ_DONE;
        END_IF;

    ST_REQ_DONE:
        IF NOT r1_ack_sent THEN
            D302 := r1_id;
            D303 := 1;
            r1_ack_sent := TRUE;
        END_IF;
        r1_active := FALSE;
        r1_state := ST_IDLE;

    ST_CANCEL:
        r1_status := 2;
        r1_state := ST_CANCEL_RET;

    ST_CANCEL_RET:
        D302 := r1_id;
        D303 := 2;
        r1_active := FALSE;
        r1_state := ST_IDLE;
END_CASE;

(* Check cancellation *)
IF r0_active AND X31 THEN
    r0_state := ST_CANCEL;
END_IF;

IF r1_active AND X35 THEN
    r1_state := ST_CANCEL;
END_IF;

(* Completion detection *)
complete_valid := FALSE;

IF NOT r0_active AND NOT r1_active THEN
    IF ABS(a_pos) < 0.5 AND ABS(b_pos) < 0.5 AND
       ABS(c_pos - REAL(LIFT_HOME_C) / 100.0) < 0.5 AND
       ABS(d_pos - REAL(LIFT_HOME_D) / 100.0) < 0.5 AND
       ABS(s30_pos - REAL(S30_HOME) / 100.0) < 0.5 AND
       ABS(s31_pos) < 0.5 AND ABS(s32_pos) < 0.03 AND
       ABS(s40_pos) < 0.5 AND ABS(s41_pos) < 0.5 AND
       ABS(a_vel) < 0.5 AND ABS(b_vel) < 0.5 THEN
        complete_valid := TRUE;
    END_IF;
END_IF;

IF complete_valid THEN
    complete_hold_timer(IN := TRUE, PT := T#100ms);
ELSE
    complete_hold_timer(IN := FALSE, PT := T#100ms);
END_IF;

Y2 := complete_hold_timer.Q;

END_PROGRAM