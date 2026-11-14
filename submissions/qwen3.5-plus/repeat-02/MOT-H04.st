PROGRAM Main
VAR
    state : INT := 0;
    current_req : INT := 0;
    station_target : REAL := 0.0;
    lift_target : REAL := 400.0;
    fork_target : REAL := 0.0;
    seq_counter : DINT := 0;
    settle_timer : TON;
    hold_timer : TON;
    
    a_pos : REAL;
    b_pos : REAL;
    c_pos : REAL;
    d_pos : REAL;
    s3_0_pos : REAL;
    s3_1_pos : REAL;
    s3_2_pos : REAL;
    s4_0_pos : REAL;
    s4_1_pos : REAL;
    
    a_vel : REAL;
    b_vel : REAL;
    c_vel : REAL;
    d_vel : REAL;
    s3_0_vel : REAL;
    s3_1_vel : REAL;
    s3_2_vel : REAL;
    s4_0_vel : REAL;
    s4_1_vel : REAL;
    
    a_target_raw : DINT;
    b_target_raw : DINT;
    c_target_raw : DINT;
    d_target_raw : DINT;
    s3_0_target_raw : DINT;
    s3_1_target_raw : DINT;
    s3_2_target_raw : DINT;
    s4_0_target_raw : DINT;
    s4_1_target_raw : DINT;
    
    a_rate_val : DINT;
    b_rate_val : DINT;
    c_rate_val : DINT;
    d_rate_val : DINT;
    s3_0_rate_val : DINT;
    s3_1_rate_val : DINT;
    s3_2_rate_val : DINT;
    s4_0_rate_val : DINT;
    s4_1_rate_val : DINT;
    
    a_en : BOOL;
    b_en : BOOL;
    c_en : BOOL;
    d_en : BOOL;
    s3_0_en : BOOL;
    s3_1_en : BOOL;
    s3_2_en : BOOL;
    s4_0_en : BOOL;
    s4_1_en : BOOL;
    
    m3_cfg : BOOL;
    m3_ret : BOOL;
    m3_sel : DINT;
    m3_rt : DINT;
    m3_acc : DINT;
    
    m4_cfg : BOOL;
    m4_ret : BOOL;
    m4_sel : DINT;
    m4_rt : DINT;
    m4_acc : DINT;
    
    act_val : DINT;
    stat_val : DINT;
    coup_val : DINT;
    stat_num : DINT;
    brk_val : BOOL;
    comp_val : BOOL;
    
    ack0_val : DINT;
    status0_val : DINT;
    ack1_val : DINT;
    status1_val : DINT;
    
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;
END_VAR

VAR CONSTANT
    HOME_A : REAL := 0.0;
    HOME_B : REAL := 0.0;
    HOME_C : REAL := 400.0;
    HOME_D : REAL := 400.0;
    HOME_S3_0 : REAL := 1000.0;
    HOME_S3_1 : REAL := 0.0;
    HOME_S3_2 : REAL := 0.0;
    HOME_S4_0 : REAL := 0.0;
    HOME_S4_1 : REAL := 0.0;
    LIFT_DOCK : REAL := 950.0;
    ST1 : REAL := -4050.0;
    ST2 : REAL := -1850.0;
    ST3 : REAL := 900.0;
    ST4 : REAL := 4700.0;
    FORK_RET : REAL := 0.0;
    FORK_CONN : REAL := 180.0;
    RATE_MOVE : DINT := 800;
    RATE_SLOW : DINT := 300;
    TOL_POS : REAL := 0.2;
    TOL_VEL : REAL := 1.0;
    MAX_A : REAL := 5100.0;
    MIN_A : REAL := -4500.0;
    MAX_B : REAL := 180.0;
    MIN_B : REAL := 0.0;
    MAX_C : REAL := 1200.0;
    MIN_C : REAL := 0.0;
    MAX_D : REAL := 1200.0;
    MIN_D : REAL := 0.0;
    MAX_S3_0 : REAL := 1500.0;
    MIN_S3_0 : REAL := 500.0;
    MAX_S3_1 : REAL := 1000.0;
    MIN_S3_1 : REAL := -1000.0;
    MAX_S3_2 : REAL := 30.0;
    MIN_S3_2 : REAL := -30.0;
    MAX_S4_0 : REAL := 50.0;
    MIN_S4_0 : REAL := -50.0;
    MAX_S4_1 : REAL := 450.0;
    MIN_S4_1 : REAL := -450.0;
END_VAR

(* Helper function to scale and clamp *)
a_pos := D1000 / 100.0;
b_pos := D1004 / 100.0;
c_pos := D1008 / 100.0;
d_pos := D1012 / 100.0;
s3_0_pos := D1016 / 100.0;
s3_1_pos := D1020 / 100.0;
s3_2_pos := D1024 / 100.0;
s4_0_pos := D1028 / 100.0;
s4_1_pos := D1032 / 100.0;

a_vel := D1001 / 100.0;
b_vel := D1005 / 100.0;
c_vel := D1009 / 100.0;
d_vel := D1013 / 100.0;
s3_0_vel := D1017 / 100.0;
s3_1_vel := D1021 / 100.0;
s3_2_vel := D1025 / 100.0;
s4_0_vel := D1029 / 100.0;
s4_1_vel := D1033 / 100.0;

(* State Machine *)
CASE state OF
    0: (* IDLE: Find active request *)
        IF req0_done = FALSE AND D102 > 0 THEN
            current_req := 0;
            station_target := ST1;
            IF D101 = 2 THEN station_target := ST2; END_IF;
            state := 1;
            coup_val := coup_val + 1;
        ELSIF req1_done = FALSE AND D122 > 0 THEN
            current_req := 1;
            station_target := ST1;
            IF D121 = 2 THEN station_target := ST2; END_IF;
            state := 1;
            coup_val := coup_val + 1;
        ELSE
            state := 0;
        END_IF;
        brk_val := TRUE;
        
    1: (* MOVE SHUTTLE TO LIFT *)
        brk_val := FALSE;
        a_en := TRUE;
        a_rate_val := RATE_MOVE;
        a_target_raw := DINT(station_target * 100.0);
        IF ABS(a_pos - station_target) <= TOL_POS AND ABS(a_vel) <= TOL_VEL THEN
            settle_timer(IN := TRUE, PT := T#30ms);
            IF settle_timer.Q THEN
                settle_timer(IN := FALSE);
                state := 2;
            END_IF;
        ELSE
            settle_timer(IN := FALSE);
        END_IF;
        
    2: (* LIFT UP *)
        brk_val := TRUE;
        c_en := TRUE;
        d_en := TRUE;
        c_rate_val := RATE_MOVE;
        d_rate_val := RATE_MOVE;
        c_target_raw := DINT(LIFT_DOCK * 100.0);
        d_target_raw := DINT(LIFT_DOCK * 100.0);
        IF ABS(c_pos - LIFT_DOCK) <= TOL_POS AND ABS(d_pos - LIFT_DOCK) <= TOL_POS THEN
            settle_timer(IN := TRUE, PT := T#30ms);
            IF settle_timer.Q THEN
                settle_timer(IN := FALSE);
                state := 3;
            END_IF;
        ELSE
            settle_timer(IN := FALSE);
        END_IF;
        
    3: (* DOCK LIFT / FORK EXTEND *)
        brk_val := TRUE;
        b_en := TRUE;
        b_rate_val := RATE_SLOW;
        b_target_raw := DINT(FORK_CONN * 100.0);
        stat_num := 1;
        IF current_req = 0 THEN stat_val := 1; END_IF;
        IF current_req = 1 THEN stat_val := 2; END_IF;
        IF b_pos >= FORK_CONN - TOL_POS THEN
            settle_timer(IN := TRUE, PT := T#80ms);
            IF settle_timer.Q THEN
                settle_timer(IN := FALSE);
                state := 4;
            END_IF;
        ELSE
            settle_timer(IN := FALSE);
        END_IF;
        
    4: (* MOVE TO CELL 3 *)
        brk_val := FALSE;
        a_en := TRUE;
        a_rate_val := RATE_MOVE;
        a_target_raw := DINT(ST3 * 100.0);
        c_en := TRUE;
        d_en := TRUE;
        c_rate_val := RATE_SLOW;
        d_rate_val := RATE_SLOW;
        c_target_raw := DINT(HOME_C * 100.0);
        d_target_raw := DINT(HOME_D * 100.0);
        b_en := TRUE;
        b_rate_val := RATE_SLOW;
        b_target_raw := DINT(FORK_CONN * 100.0);
        IF ABS(a_pos - ST3) <= TOL_POS THEN
            settle_timer(IN := TRUE, PT := T#30ms);
            IF settle_timer.Q THEN
                settle_timer(IN := FALSE);
                state := 5;
            END_IF;
        ELSE
            settle_timer(IN := FALSE);
        END_IF;
        
    5: (* CELL 3 HANDSHAKE *)
        brk_val := TRUE;
        m3_cfg := TRUE;
        m3_ret := TRUE;
        m3_sel := 1;
        m3_rt := 1;
        m3_acc := 100;
        stat_num := 3;
        IF X70 OR X71 THEN
            m3_cfg := FALSE;
            m3_ret := FALSE;
            state := 6;
        END_IF;
        
    6: (* MOVE TO CELL 4 *)
        brk_val := FALSE;
        a_en := TRUE;
        a_rate_val := RATE_MOVE;
        a_target_raw := DINT(ST4 * 100.0);
        b_en := TRUE;
        b_rate_val := RATE_SLOW;
        b_target_raw := DINT(FORK_CONN * 100.0);
        IF ABS(a_pos - ST4) <= TOL_POS THEN
            settle_timer(IN := TRUE, PT := T#30ms);
            IF settle_timer.Q THEN
                settle_timer(IN := FALSE);
                state := 7;
            END_IF;
        ELSE
            settle_timer(IN := FALSE);
        END_IF;
        
    7: (* CELL 4 HANDSHAKE *)
        brk_val := TRUE;
        m4_cfg := TRUE;
        m4_ret := TRUE;
        m4_sel := 1;
        m4_rt := 1;
        m4_acc := 100;
        stat_num := 4;
        IF X75 OR X76 THEN
            m4_cfg := FALSE;
            m4_ret := FALSE;
            state := 8;
        END_IF;
        
    8: (* RETURN TO LIFT *)
        brk_val := FALSE;
        a_en := TRUE;
        a_rate_val := RATE_MOVE;
        a_target_raw := DINT(station_target * 100.0);
        b_en := TRUE;
        b_rate_val := RATE_SLOW;
        b_target_raw := DINT(FORK_CONN * 100.0);
        c_en := TRUE;
        d_en := TRUE;
        c_rate_val := RATE_SLOW;
        d_rate_val := RATE_SLOW;
        c_target_raw := DINT(LIFT_DOCK * 100.0);
        d_target_raw := DINT(LIFT_DOCK * 100.0);
        IF ABS(a_pos - station_target) <= TOL_POS THEN
            settle_timer(IN := TRUE, PT := T#30ms);
            IF settle_timer.Q THEN
                settle_timer(IN := FALSE);
                state := 9;
            END_IF;
        ELSE
            settle_timer(IN := FALSE);
        END_IF;
        
    9: (* LIFT DOWN & FORK RETRACT *)
        brk_val := TRUE;
        c_en := TRUE;
        d_en := TRUE;
        c_rate_val := RATE_MOVE;
        d_rate_val := RATE_MOVE;
        c_target_raw := DINT(HOME_C * 100.0);
        d_target_raw := DINT(HOME_D * 100.0);
        b_en := TRUE;
        b_rate_val := RATE_SLOW;
        b_target_raw := DINT(FORK_RET * 100.0);
        IF ABS(c_pos - HOME_C) <= TOL_POS AND ABS(d_pos - HOME_D) <= TOL_POS AND b_pos <= FORK_RET + TOL_POS THEN
            settle_timer(IN := TRUE, PT := T#30ms);
            IF settle_timer.Q THEN
                settle_timer(IN := FALSE);
                state := 10;
            END_IF;
        ELSE
            settle_timer(IN := FALSE);
        END_IF;
        
    10: (* WAIT RETURNED / ACK *)
        brk_val := TRUE;
        IF current_req = 0 THEN
            IF X30 THEN
                ack0_val := D100;
                IF X31 THEN status0_val := 2; ELSE status0_val := 1; END_IF;
                req0_done := TRUE;
                state := 11;
            END_IF;
        ELSE
            IF X34 THEN
                ack1_val := D120;
                IF X35 THEN status1_val := 2; ELSE status1_val := 1; END_IF;
                req1_done := TRUE;
                state := 11;
            END_IF;
        END_IF;
        
    11: (* CHECK ALL DONE *)
        brk_val := TRUE;
        IF X51 THEN
            state := 12;
        ELSE
            state := 0; (* Loop for next request *)
        END_IF;
        
    12: (* GO HOME *)
        brk_val := FALSE;
        a_en := TRUE; a_rate_val := RATE_SLOW; a_target_raw := DINT(HOME_A * 100.0);
        b_en := TRUE; b_rate_val := RATE_SLOW; b_target_raw := DINT(HOME_B * 100.0);
        c_en := TRUE; c_rate_val := RATE_SLOW; c_target_raw := DINT(HOME_C * 100.0);
        d_en := TRUE; d_rate_val := RATE_SLOW; d_target_raw := DINT(HOME_D * 100.0);
        s3_0_en := TRUE; s3_0_rate_val := RATE_SLOW; s3_0_target_raw := DINT(HOME_S3_0 * 100.0);
        s3_1_en := TRUE; s3_1_rate_val := RATE_SLOW; s3_1_target_raw := DINT(HOME_S3_1 * 100.0);
        s3_2_en := TRUE; s3_2_rate_val := RATE_SLOW; s3_2_target_raw := DINT(HOME_S3_2 * 100.0);
        s4_0_en := TRUE; s4_0_rate_val := RATE_SLOW; s4_0_target_raw := DINT(HOME_S4_0 * 100.0);
        s4_1_en := TRUE; s4_1_rate_val := RATE_SLOW; s4_1_target_raw := DINT(HOME_S4_1 * 100.0);
        IF ABS(a_pos - HOME_A) <= TOL_POS AND ABS(b_pos - HOME_B) <= TOL_POS AND ABS(c_pos - HOME_C) <= TOL_POS AND ABS(d_pos - HOME_D) <= TOL_POS THEN
            hold_timer(IN := TRUE, PT := T#100ms);
            IF hold_timer.Q THEN
                hold_timer(IN := FALSE);
                state := 13;
            END_IF;
        ELSE
            hold_timer(IN := FALSE);
        END_IF;
        
    13: (* FINAL COMPLETE *)
        brk_val := TRUE;
        comp_val := TRUE;
        
ELSE
    state := 0;
END_CASE;

(* Apply limits *)
a_target_raw := MAX(MIN(a_target_raw, DINT(MAX_A * 100.0)), DINT(MIN_A * 100.0));
b_target_raw := MAX(MIN(b_target_raw, DINT(MAX_B * 100.0)), DINT(MIN_B * 100.0));
c_target_raw := MAX(MIN(c_target_raw, DINT(MAX_C * 100.0)), DINT(MIN_C * 100.0));
d_target_raw := MAX(MIN(d_target_raw, DINT(MAX_D * 100.0)), DINT(MIN_D * 100.0));
s3_0_target_raw := MAX(MIN(s3_0_target_raw, DINT(MAX_S3_0 * 100.0)), DINT(MIN_S3_0 * 100.0));
s3_1_target_raw := MAX(MIN(s3_1_target_raw, DINT(MAX_S3_1 * 100.0)), DINT(MIN_S3_1 * 100.0));
s3_2_target_raw := MAX(MIN(s3_2_target_raw, DINT(MAX_S3_2 * 100.0)), DINT(MIN_S3_2 * 100.0));
s4_0_target_raw := MAX(MIN(s4_0_target_raw, DINT(MAX_S4_0 * 100.0)), DINT(MIN_S4_0 * 100.0));
s4_1_target_raw := MAX(MIN(s4_1_target_raw, DINT(MAX_S4_1 * 100.0)), DINT(MIN_S4_1 * 100.0));

(* Assign outputs *)
D2000 := a_target_raw;
D2001 := MAX(a_rate_val, 20);
D2002 := 0;
Y40 := a_en;

D2004 := b_target_raw;
D2005 := MAX(b_rate_val, 20);
D2006 := 0;
Y41 := b_en;

D2008 := c_target_raw;
D2009 := MAX(c_rate_val, 20);
D2010 := 0;
Y42 := c_en;

D2012 := d_target_raw;
D2013 := MAX(d_rate_val, 20);
D2014 := 0;
Y43 := d_en;

D2016 := s3_0_target_raw;
D2017 := MAX(s3_0_rate_val, 20);
D2018 := 0;
Y44 := s3_0_en;

D2020 := s3_1_target_raw;
D2021 := MAX(s3_1_rate_val, 20);
D2022 := 0;
Y45 := s3_1_en;

D2024 := s3_2_target_raw;
D2025 := MAX(s3_2_rate_val, 20);
D2026 := 0;
Y46 := s3_2_en;

D2028 := s4_0_target_raw;
D2029 := MAX(s4_0_rate_val, 20);
D2030 := 0;
Y47 := s4_0_en;

D2032 := s4_1_target_raw;
D2033 := MAX(s4_1_rate_val, 20);
D2034 := 0;
Y48 := s4_1_en;

Y70 := m3_cfg;
Y71 := m3_ret;
D700 := m3_sel;
D701 := m3_rt;
D702 := m3_acc;

Y75 := m4_cfg;
Y76 := m4_ret;
D710 := m4_sel;
D711 := m4_rt;
D712 := m4_acc;

D80 := act_val;
D81 := stat_num;
D82 := coup_val;

D300 := ack0_val;
D301 := status0_val;
D302 := ack1_val;
D303 := status1_val;

Y30 := brk_val;
Y2 := comp_val;

END_PROGRAM