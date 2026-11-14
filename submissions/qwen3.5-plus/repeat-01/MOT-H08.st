PROGRAM Main
VAR
    (* Request tracking *)
    req0_active : BOOL;
    req1_active : BOOL;
    req0_done : BOOL;
    req1_done : BOOL;
    req0_cancelled : BOOL;
    req1_cancelled : BOOL;
    req0_ack_sent : BOOL;
    req1_ack_sent : BOOL;
    
    (* System state *)
    sys_state : DINT;  (* 0=idle, 1=resetting, 2=processing *)
    active_req : DINT; (* 0 or 1 *)
    
    (* Phase for active request *)
    phase : DINT;
    
    (* Sequence counter *)
    seq_counter : DINT := 0;
    
    (* Completion timer *)
    comp_timer : TON;
    comp_settle_timer : TON;
    
    (* Settling detection *)
    edge_a : R_TRIG;
    edge_b : R_TRIG;
    edge_c : R_TRIG;
    edge_d : R_TRIG;
    
    (* Constants - positions in 0.01 units *)
    STN_LIFT : DINT := -405000;
    STN_CELL3 : DINT := 490000;
    STN_CELL4 : DINT := 1140000;
    DOCK_H : DINT := 95000;
    HOME_C : DINT := 40000;
    HOME_D : DINT := 40000;
    HOME_S3_0 : DINT := -60000;
    HOME_S3_1 : DINT := -60000;
    HOME_S4_0 : DINT := 0;
    HOME_S4_1 : DINT := 0;
    HOME_S4_2 : DINT := 0;
    FORK_RETRACT : DINT := 0;
    FORK_CONNECT : DINT := 18000;
    MAX_RATE : DINT := 500;
    
    (* Internal position/velocity in physical units *)
    a_pos : REAL;
    a_vel : REAL;
    b_pos : REAL;
    b_vel : REAL;
    c_pos : REAL;
    c_vel : REAL;
    d_pos : REAL;
    d_vel : REAL;
    s3_0_pos : REAL;
    s3_0_vel : REAL;
    s3_1_pos : REAL;
    s3_1_vel : REAL;
    s4_0_pos : REAL;
    s4_0_vel : REAL;
    s4_1_pos : REAL;
    s4_1_vel : REAL;
    s4_2_pos : REAL;
    s4_2_vel : REAL;
    
    (* Moment calculation temp *)
    moment : REAL;
    calc_x : REAL;
    sin_a : REAL;
    sin_b : REAL;
    angle_a_rad : REAL;
    angle_b_rad : REAL;
    K_MOMENT : REAL := 20.0 * 9.81 / 1000.0;
    
    (* Safety check flags *)
    safety_ok : BOOL;
    arrived : BOOL;
    
    (* Cell 3 goal tracking *)
    c3_g0 : DINT;
    c3_g1 : DINT;
    
    (* Cell 4 goal tracking *)
    c4_g0 : DINT;
    c4_g1 : DINT;
    c4_g2 : DINT;
END_VAR

(* Convert scaled inputs to physical units *)
a_pos := DINT_TO_REAL(D1000) * 0.01;
a_vel := DINT_TO_REAL(D1001) * 0.01;
b_pos := DINT_TO_REAL(D1004) * 0.01;
b_vel := DINT_TO_REAL(D1005) * 0.01;
c_pos := DINT_TO_REAL(D1008) * 0.01;
c_vel := DINT_TO_REAL(D1009) * 0.01;
d_pos := DINT_TO_REAL(D1012) * 0.01;
d_vel := DINT_TO_REAL(D1013) * 0.01;
s3_0_pos := DINT_TO_REAL(D1016) * 0.01;
s3_0_vel := DINT_TO_REAL(D1017) * 0.01;
s3_1_pos := DINT_TO_REAL(D1020) * 0.01;
s3_1_vel := DINT_TO_REAL(D1021) * 0.01;
s4_0_pos := DINT_TO_REAL(D1024) * 0.01;
s4_0_vel := DINT_TO_REAL(D1025) * 0.01;
s4_1_pos := DINT_TO_REAL(D1028) * 0.01;
s4_1_vel := DINT_TO_REAL(D1029) * 0.01;
s4_2_pos := DINT_TO_REAL(D1032) * 0.01;
s4_2_vel := DINT_TO_REAL(D1033) * 0.01;

(* Activate/deactivate requests *)
IF (D100 <> 0) AND (NOT req0_active) AND (NOT req0_done) THEN
    req0_active := TRUE;
    req0_cancelled := FALSE;
    req0_ack_sent := FALSE;
    req0_done := FALSE;
END_IF;

IF (D120 <> 0) AND (NOT req1_active) AND (NOT req1_done) THEN
    req1_active := TRUE;
    req1_cancelled := FALSE;
    req1_ack_sent := FALSE;
    req1_done := FALSE;
END_IF;

(* Track cancellations *)
IF req0_active AND X31 THEN
    req0_cancelled := TRUE;
END_IF;
IF req1_active AND X35 THEN
    req1_cancelled := TRUE;
END_IF;

(* Track completions from source *)
IF req0_active AND X30 THEN
    req0_done := TRUE;
END_IF;
IF req1_active AND X34 THEN
    req1_done := TRUE;
END_IF;

(* System state machine *)
CASE sys_state OF
    0: (* Idle - check for pending requests *)
        IF (req0_active AND NOT req0_done AND NOT req0_ack_sent) OR (req1_active AND NOT req1_done AND NOT req1_ack_sent) THEN
            IF (req0_active AND NOT req0_done AND NOT req0_ack_sent) AND (req0_cancelled OR D102 >= 1) THEN
                active_req := 0;
                sys_state := 2;
                phase := 0;
                seq_counter := seq_counter + 1;
            ELSIF (req1_active AND NOT req1_done AND NOT req1_ack_sent) AND (req1_cancelled OR D122 >= 1) THEN
                active_req := 1;
                sys_state := 2;
                phase := 0;
                seq_counter := seq_counter + 1;
            ELSIF req0_active AND NOT req0_done THEN
                active_req := 0;
                sys_state := 2;
                phase := 0;
                seq_counter := seq_counter + 1;
            ELSIF req1_active AND NOT req1_done THEN
                active_req := 1;
                sys_state := 2;
                phase := 0;
                seq_counter := seq_counter + 1;
            END_IF;
        END_IF;
        
    1: (* Resetting home *)
        (* All axes moving to home positions *)
        arrived := (ABS(a_pos) < 5.0) AND (ABS(b_pos) < 5.0) AND 
                   (ABS(c_pos - HOME_C) < 5.0) AND (ABS(d_pos - HOME_D) < 5.0) AND
                   (ABS(s3_0_pos - HOME_S3_0) < 5.0) AND (ABS(s3_1_pos - HOME_S3_1) < 5.0) AND
                   (ABS(s4_0_pos - HOME_S4_0) < 5.0) AND (ABS(s4_1_pos - HOME_S4_1) < 5.0) AND
                   (ABS(s4_2_pos - HOME_S4_2) < 5.0);
        IF arrived THEN
            sys_state := 0;
        END_IF;
        
    2: (* Processing active request *)
        (* Phase transitions based on arrival *)
        CASE phase OF
            0: (* Shuttle moving to source lift *)
                arrived := (ABS(a_pos - STN_LIFT) < 50.0);
                IF arrived THEN
                    phase := 1;
                END_IF;
                
            1: (* Fork extending for pickup *)
                arrived := (ABS(b_pos - FORK_CONNECT) < 10.0);
                IF arrived THEN
                    phase := 2;
                END_IF;
                
            2: (* Shuttle moving to destination *)
                IF (D101 = 3) OR (D121 = 3) THEN
                    arrived := (ABS(a_pos - STN_CELL3) < 50.0);
                ELSE
                    arrived := (ABS(a_pos - STN_CELL4) < 50.0);
                END_IF;
                IF arrived THEN
                    phase := 3;
                END_IF;
                
            3: (* Cell taking jig from shuttle *)
                IF (active_req = 0 AND D101 = 3) OR (active_req = 1 AND D121 = 3) THEN
                    IF X72 THEN
                        phase := 4;
                    END_IF;
                ELSE
                    IF X77 THEN
                        phase := 4;
                    END_IF;
                END_IF;
                
            4: (* Cell processing *)
                IF (active_req = 0 AND D101 = 3) OR (active_req = 1 AND D121 = 3) THEN
                    arrived := (ABS(s3_0_vel) < 2.0) AND (ABS(s3_1_vel) < 2.0);
                ELSE
                    arrived := (ABS(s4_0_vel) < 2.0) AND (ABS(s4_1_vel) < 2.0) AND (ABS(s4_2_vel) < 2.0);
                END_IF;
                IF arrived THEN
                    phase := 5;
                END_IF;
                
            5: (* Cell returning jig, fork extending to receive *)
                arrived := (ABS(b_pos - FORK_CONNECT) < 10.0);
                IF arrived THEN
                    phase := 6;
                END_IF;
                
            6: (* Shuttle moving back to lift *)
                arrived := (ABS(a_pos - STN_LIFT) < 50.0);
                IF arrived THEN
                    phase := 7;
                END_IF;
                
            7: (* Lift moving to docking height *)
                arrived := (ABS(c_pos - DOCK_H) < 50.0) AND (ABS(d_pos - DOCK_H) < 50.0);
                IF arrived THEN
                    phase := 8;
                END_IF;
                
            8: (* Lift receiving jig, fork retracting *)
                arrived := (ABS(b_pos - FORK_RETRACT) < 10.0);
                IF arrived THEN
                    phase := 9;
                END_IF;
                
            9: (* Lift descending to home *)
                arrived := (ABS(c_pos - HOME_C) < 50.0) AND (ABS(d_pos - HOME_D) < 50.0);
                IF arrived THEN
                    phase := 10;
                END_IF;
                
            10: (* Request complete, send ack *)
                phase := 10;
        END_CASE;
END_CASE;

(* Check if both requests done and system at home -> completion *)
IF (req0_done OR NOT req0_active) AND (req1_done OR NOT req1_active) THEN
    arrived := (ABS(a_pos) < 5.0) AND (ABS(b_pos) < 5.0) AND 
               (ABS(c_pos - HOME_C) < 5.0) AND (ABS(d_pos - HOME_D) < 5.0) AND
               (ABS(s3_0_pos - HOME_S3_0) < 5.0) AND (ABS(s3_1_pos - HOME_S3_1) < 5.0) AND
               (ABS(s4_0_pos - HOME_S4_0) < 5.0) AND (ABS(s4_1_pos - HOME_S4_1) < 5.0) AND
               (ABS(s4_2_pos - HOME_S4_2) < 5.0);
    comp_timer(IN := arrived, PT := T#100ms);
    Y2 := comp_timer.Q;
ELSE
    comp_timer(IN := FALSE);
    Y2 := FALSE;
END_IF;

(* Output generation based on phase *)
CASE phase OF
    0: (* Move shuttle to lift *)
        Y30 := FALSE;
        Y40 := TRUE;
        a_enable := TRUE;
        a_target := STN_LIFT;
        a_rate := MAX_RATE;
        a_ff := 0;
        
        b_enable := FALSE;
        c_enable := FALSE;
        d_enable := FALSE;
        s3_0_enable := FALSE;
        s3_1_enable := FALSE;
        s4_0_enable := FALSE;
        s4_1_enable := FALSE;
        s4_2_enable := FALSE;
        
    1: (* Extend fork *)
        Y30 := FALSE;
        Y40 := TRUE;
        a_enable := TRUE;
        a_target := STN_LIFT;
        a_rate := 100;
        a_ff := 0;
        
        Y41 := TRUE;
        b_enable := TRUE;
        b_target := FORK_CONNECT;
        b_rate := MAX_RATE;
        b_ff := 0;
        
        c_enable := FALSE;
        d_enable := FALSE;
        s3_0_enable := FALSE;
        s3_1_enable := FALSE;
        s4_0_enable := FALSE;
        s4_1_enable := FALSE;
        s4_2_enable := FALSE;
        
    2: (* Shuttle to cell *)
        Y30 := FALSE;
        Y40 := TRUE;
        a_enable := TRUE;
        IF (D101 = 3) OR (D121 = 3) THEN
            a_target := STN_CELL3;
        ELSE
            a_target := STN_CELL4;
        END_IF;
        a_rate := MAX_RATE;
        a_ff := 0;
        
        Y41 := TRUE;
        b_enable := TRUE;
        b_target := FORK_CONNECT;
        b_rate := 100;
        b_ff := 0;
        
        c_enable := FALSE;
        d_enable := FALSE;
        s3_0_enable := FALSE;
        s3_1_enable := FALSE;
        s4_0_enable := FALSE;
        s4_1_enable := FALSE;
        s4_2_enable := FALSE;
        
    3: (* Cell receiving - configure cell mechanism *)
        Y30 := FALSE;
        Y40 := TRUE;
        a_enable := TRUE;
        IF (D101 = 3) OR (D121 = 3) THEN
            a_target := STN_CELL3;
        ELSE
            a_target := STN_CELL4;
        END_IF;
        a_rate := 100;
        a_ff := 0;
        
        Y41 := TRUE;
        b_enable := TRUE;
        b_target := FORK_CONNECT;
        b_rate := 100;
        b_ff := 0;
        
        c_enable := FALSE;
        d_enable := FALSE;
        
        IF (D101 = 3) OR (D121 = 3) THEN
            Y44 := TRUE;
            s3_0_enable := TRUE;
            c3_g0 := D500;
            c3_g1 := D501;
            s3_0_target := c3_g0;
            s3_0_rate := MAX_RATE;
            s3_0_ff := 0;
            
            Y45 := TRUE;
            s3_1_enable := TRUE;
            s3_1_target := c3_g1;
            s3_1_rate := MAX_RATE;
            s3_1_ff := 0;
            
            Y70 := TRUE;
            Y71 := TRUE;
            
            s4_0_enable := FALSE;
            s4_1_enable := FALSE;
            s4_2_enable := FALSE;
        ELSE
            Y70 := FALSE;
            Y71 := FALSE;
            s3_0_enable := FALSE;
            s3_1_enable := FALSE;
            
            Y46 := TRUE;
            s4_0_enable := TRUE;
            c4_g0 := D600;
            c4_g1 := D601;
            s4_0_target := c4_g0 * 100;
            s4_0_rate := MAX_RATE;
            s4_0_ff := 0;
            
            Y47 := TRUE;
            s4_1_enable := TRUE;
            s4_1_target := c4_g1 * 100;
            s4_1_rate := MAX_RATE;
            s4_1_ff := 0;
            
            (* Calculate counterweight for balance moment <= 1 Nm *)
            angle_a_rad := DINT_TO_REAL(c4_g0) * 0.01 * 3.14159265358979 / 180.0;
            angle_b_rad := DINT_TO_REAL(c4_g1) * 0.01 * 3.14159265358979 / 180.0;
            sin_a := SIN(angle_a_rad);
            sin_b := SIN(angle_b_rad);
            (* moment = K * [225*(sin_a + sin_b) + x] <= 1 *)
            (* x = 1/K - 225*(sin_a + sin_b) *)
            calc_x := 1.0 / K_MOMENT - 225.0 * (sin_a + sin_b);
            IF calc_x > 45000.0 THEN
                calc_x := 45000.0;
            ELSIF calc_x < -45000.0 THEN
                calc_x := -45000.0;
            END_IF;
            Y48 := TRUE;
            s4_2_enable := TRUE;
            s4_2_target := DINT(REAL_TO_INT(calc_x));
            s4_2_rate := MAX_RATE;
            s4_2_ff := 0;
            
            Y75 := TRUE;
            Y76 := TRUE;
        END_IF;
        
    4: (* Cell processing - maintain positions *)
        Y30 := FALSE;
        Y40 := TRUE;
        a_enable := TRUE;
        IF (D101 = 3) OR (D121 = 3) THEN
            a_target := STN_CELL3;
        ELSE
            a_target := STN_CELL4;
        END_IF;
        a_rate := 100;
        a_ff := 0;
        
        Y41 := TRUE;
        b_enable := TRUE;
        b_target := FORK_CONNECT;
        b_rate := 100;
        b_ff := 0;
        
        c_enable := FALSE;
        d_enable := FALSE;
        
        IF (D101 = 3) OR (D121 = 3) THEN
            Y44 := TRUE;
            s3_0_enable := TRUE;
            s3_0_target := c3_g0;
            s3_0_rate := 100;
            s3_0_ff := 0;
            
            Y45 := TRUE;
            s3_1_enable := TRUE;
            s3_1_target := c3_g1;
            s3_1_rate := 100;
            s3_1_ff := 0;
            
            s4_0_enable := FALSE;
            s4_1_enable := FALSE;
            s4_2_enable := FALSE;
        ELSE
            s3_0_enable := FALSE;
            s3_1_enable := FALSE;
            
            Y46 := TRUE;
            s4_0_enable := TRUE;
            s4_0_target := c4_g0 * 100;
            s4_0_rate := 100;
            s4_0_ff := 0;
            
            Y47 := TRUE;
            s4_1_enable := TRUE;
            s4_1_target := c4_g1 * 100;
            s4_1_rate := 100;
            s4_1_ff := 0;
            
            Y48 := TRUE;
            s4_2_enable := TRUE;
            s4_2_target := DINT(REAL_TO_INT(calc_x));
            s4_2_rate := 100;
            s4_2_ff := 0;
        END_IF;
        
    5: (* Cell releasing jig, fork ready *)
        Y30 := FALSE;
        Y40 := TRUE;
        a_enable := TRUE;
        IF (D101 = 3) OR (D121 = 3) THEN
            a_target := STN_CELL3;
        ELSE
            a_target := STN_CELL4;
        END_IF;
        a_rate := 100;
        a_ff := 0;
        
        Y41 := TRUE;
        b_enable := TRUE;
        b_target := FORK_CONNECT;
        b_rate := MAX_RATE;
        b_ff := 0;
        
        c_enable := FALSE;
        d_enable := FALSE;
        
        IF (D101 = 3) OR (D121 = 3) THEN
            Y44 := TRUE;
            s3_0_enable := TRUE;
            s3_0_target := HOME_S3_0;
            s3_0_rate := MAX_RATE;
            s3_0_ff := 0;
            
            Y45 := TRUE;
            s3_1_enable := TRUE;
            s3_1_target := HOME_S3_1;
            s3_1_rate := MAX_RATE;
            s3_1_ff := 0;
            
            s4_0_enable := FALSE;
            s4_1_enable := FALSE;
            s4_2_enable := FALSE;
        ELSE
            s3_0_enable := FALSE;
            s3_1_enable := FALSE;
            
            Y46 := TRUE;
            s4_0_enable := TRUE;
            s4_0_target := HOME_S4_0;
            s4_0_rate := MAX_RATE;
            s4_0_ff := 0;
            
            Y47 := TRUE;
            s4_1_enable := TRUE;
            s4_1_target := HOME_S4_1;
            s4_1_rate := MAX_RATE;
            s4_1_ff := 0;
            
            Y48 := TRUE;
            s4_2_enable := TRUE;
            s4_2_target := HOME_S4_2;
            s4_2_rate := MAX_RATE;
            s4_2_ff := 0;
        END_IF;
        
    6: (* Shuttle back to lift *)
        Y30 := FALSE;
        Y40 := TRUE;
        a_enable := TRUE;
        a_target := STN_LIFT;
        a_rate := MAX_RATE;
        a_ff := 0;
        
        Y41 := TRUE;
        b_enable := TRUE;
        b_target := FORK_CONNECT;
        b_rate := 100;
        b_ff := 0;
        
        c_enable := FALSE;
        d_enable := FALSE;
        s3_0_enable := FALSE;
        s3_1_enable := FALSE;
        s4_0_enable := FALSE;
        s4_1_enable := FALSE;
        s4_2_enable := FALSE;
        
    7: (* Lift to docking height *)
        Y30 := FALSE;
        Y40 := TRUE;
        a_enable := TRUE;
        a_target := STN_LIFT;
        a_rate := 100;
        a_ff := 0;
        
        Y41 := TRUE;
        b_enable := TRUE;
        b_target := FORK_CONNECT;
        b_rate := 100;
        b_ff := 0;
        
        Y42 := TRUE;
        c_enable := TRUE;
        c_target := DOCK_H;
        c_rate := MAX_RATE;
        c_ff := 0;
        
        Y43 := TRUE;
        d_enable := TRUE;
        d_target := DOCK_H;
        d_rate := MAX_RATE;
        d_ff := 0;
        
        s3_0_enable := FALSE;
        s3_1_enable := FALSE;
        s4_0_enable := FALSE;
        s4_1_enable := FALSE;
        s4_2_enable := FALSE;
        
    8: (* Fork retracting after lift receives jig *)
        Y30 := FALSE;
        Y40 := TRUE;
        a_enable := TRUE;
        a_target := STN_LIFT;
        a_rate := 100;
        a_ff := 0;
        
        Y41 := TRUE;
        b_enable := TRUE;
        b_target := FORK_RETRACT;
        b_rate := MAX_RATE;
        b_ff := 0;
        
        Y42 := TRUE;
        c_enable := TRUE;
        c_target := DOCK_H;
        c_rate := 100;
        c_ff := 0;
        
        Y43 := TRUE;
        d_enable := TRUE;
        d_target := DOCK_H;
        d_rate := 100;
        d_ff := 0;
        
        s3_0_enable := FALSE;
        s3_1_enable := FALSE;
        s4_0_enable := FALSE;
        s4_1_enable := FALSE;
        s4_2_enable := FALSE;
        
    9: (* Lift descending home *)
        Y30 := FALSE;
        Y40 := TRUE;
        a_enable := TRUE;
        a_target := STN_LIFT;
        a_rate := 100;
        a_ff := 0;
        
        Y41 := TRUE;
        b_enable := TRUE;
        b_target := FORK_RETRACT;
        b_rate := 100;
        b_ff := 0;
        
        Y42 := TRUE;
        c_enable := TRUE;
        c_target := HOME_C;
        c_rate := MAX_RATE;
        c_ff := 0;
        
        Y43 := TRUE;
        d_enable := TRUE;
        d_target := HOME_D;
        d_rate := MAX_RATE;
        d_ff := 0;
        
        s3_0_enable := FALSE;
        s3_1_enable := FALSE;
        s4_0_enable := FALSE;
        s4_1_enable := FALSE;
        s4_2_enable := FALSE;
        
    10: (* Request complete - send ack, move to reset or next *)
        Y30 := FALSE;
        Y40 := TRUE;
        a_enable := TRUE;
        a_target := STN_LIFT;
        a_rate := 100;
        a_ff := 0;
        
        Y41 := TRUE;
        b_enable := TRUE;
        b_target := FORK_RETRACT;
        b_rate := 100;
        b_ff := 0;
        
        Y42 := TRUE;
        c_enable := TRUE;
        c_target := HOME_C;
        c_rate := 100;
        c_ff := 0;
        
        Y43 := TRUE;
        d_enable := TRUE;
        d_target := HOME_D;
        d_rate := 100;
        d_ff := 0;
        
        s3_0_enable := FALSE;
        s3_1_enable := FALSE;
        s4_0_enable := FALSE;
        s4_1_enable := FALSE;
        s4_2_enable := FALSE;
        
        (* Send acknowledgment *)
        IF active_req = 0 AND NOT req0_ack_sent THEN
            IF req0_cancelled THEN
                D300 := D100;
                D301 := 2;
            ELSE
                D300 := D100;
                D301 := 1;
            END_IF;
            req0_ack_sent := TRUE;
            req0_active := FALSE;
        ELSIF active_req = 1 AND NOT req1_ack_sent THEN
            IF req1_cancelled THEN
                D302 := D120;
                D303 := 2;
            ELSE
                D302 := D120;
                D303 := 1;
            END_IF;
            req1_ack_sent := TRUE;
            req1_active := FALSE;
        END_IF;
        
        (* Check if we need to reset or process next request *)
        IF (req0_done OR NOT req0_active) AND (req1_done OR NOT req1_active) THEN
            sys_state := 1;
            phase := 0;
        ELSIF req0_active AND NOT req0_done AND NOT req0_ack_sent THEN
            active_req := 0;
            phase := 0;
        ELSIF req1_active AND NOT req1_done AND NOT req1_ack_sent THEN
            active_req := 1;
            phase := 0;
        ELSE
            sys_state := 0;
            phase := 0;
        END_IF;
END_CASE;

(* Station output for current request *)
IF active_req = 0 THEN
    D81 := D101;
ELSE
    D81 := D121;
END_IF;

(* Connection action and sequence *)
IF phase = 1 OR phase = 8 THEN
    D80 := 1;
ELSE
    D80 := 2;
END_IF;
D82 := seq_counter;

(* Cell route/accel outputs *)
IF active_req = 0 THEN
    D701 := D526;
    D702 := D525;
    D711 := D626;
    D712 := D625;
ELSE
    D701 := D526;
    D702 := D525;
    D711 := D626;
    D712 := D625;
END_IF;

(* Cell select outputs *)
IF active_req = 0 THEN
    D700 := D520;
    D710 := D620;
ELSE
    D700 := D520;
    D710 := D620;
END_IF;

(* Safety - ensure brake is open during movement *)
IF phase >= 0 AND phase <= 9 THEN
    Y30 := FALSE;
END_IF;

(* Default outputs when idle *)
IF sys_state = 0 THEN
    Y40 := FALSE;
    Y41 := FALSE;
    Y42 := FALSE;
    Y43 := FALSE;
    Y44 := FALSE;
    Y45 := FALSE;
    Y46 := FALSE;
    Y47 := FALSE;
    Y48 := FALSE;
    Y30 := FALSE;
    Y70 := FALSE;
    Y71 := FALSE;
    Y75 := FALSE;
    Y76 := FALSE;
END_IF;

END_PROGRAM