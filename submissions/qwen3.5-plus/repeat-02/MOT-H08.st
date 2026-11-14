PROGRAM Main
VAR
    req_state : INT := 0;
    active_req : INT := -1;
    req_port_sel : INT := 1;
    hold_timer : TON;
    obs_timer : TON;
    
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;
    req0_cancelled : BOOL := FALSE;
    req1_cancelled : BOOL := FALSE;
    completion_ok : BOOL := FALSE;
    
    tgt_a : DINT := 0;
    tgt_b : DINT := 0;
    tgt_c : DINT := 40000;
    tgt_d : DINT := 40000;
    tgt_s30 : DINT := -60000;
    tgt_s31 : DINT := -60000;
    tgt_s40 : DINT := 0;
    tgt_s41 : DINT := 0;
    tgt_s42 : DINT := 0;
    
    C_PI : REAL := 3.14159265;
    DOCK1 : DINT := -405000;
    DOCK2 : DINT := -185000;
    DOCK3 : DINT := 490000;
    DOCK4 : DINT := 1140000;
    HOME_A : DINT := 0;
    HOME_B : DINT := 0;
    HOME_C : DINT := 40000;
    HOME_D : DINT := 40000;
    HOME_S30 : DINT := -60000;
    HOME_S31 : DINT := -60000;
    HOME_S40 : DINT := 0;
    HOME_S41 : DINT := 0;
    HOME_S42 : DINT := 0;
    
    lift_diff : REAL;
    gantry_skew : REAL;
    angle_sway : REAL;
    mom_val : REAL;
    calc_rate : REAL;
    dist : REAL;
    rate_val : DINT;
    
    trig0 : R_TRIG;
    trig1 : R_TRIG;
END_VAR

hold_timer(IN := FALSE, PT := T#80ms);
obs_timer(IN := FALSE, PT := T#100ms);

trig0(CLK := D100 > 0 AND NOT req0_done AND NOT req0_cancelled);
trig1(CLK := D120 > 0 AND NOT req1_done AND NOT req1_cancelled);

IF active_req = -1 THEN
    IF trig0.Q THEN
        active_req := 0; req_state := 1; req_port_sel := 1;
        IF D101 >= 2 THEN req_port_sel := 2; END_IF;
    ELSIF trig1.Q THEN
        active_req := 1; req_state := 1; req_port_sel := 1;
        IF D121 >= 2 THEN req_port_sel := 2; END_IF;
    END_IF;
END_IF;

CASE active_req OF
    0:
        CASE req_state OF
            1:
                tgt_a := DOCK1; IF req_port_sel=2 THEN tgt_a:=DOCK2; END_IF;
                tgt_c := D92; tgt_d := D92;
                IF ABS(D1000-tgt_a)<500 AND ABS(D1008-tgt_c)<500 AND ABS(D1012-tgt_d)<500 THEN req_state:=2; END_IF;
            2:
                tgt_b := 18000;
                IF ABS(D1004-tgt_b)<500 THEN req_state:=3; END_IF;
            3:
                tgt_a := DOCK3;
                IF ABS(D1000-tgt_a)<500 THEN req_state:=4; END_IF;
            4:
                tgt_s30:=D500; tgt_s31:=D501; Y70:=TRUE; Y71:=TRUE;
                hold_timer(IN:=TRUE, PT:=T#80ms);
                IF hold_timer.Q THEN hold_timer(IN:=FALSE); IF X72 OR X70 THEN Y70:=FALSE; Y71:=FALSE; req_state:=5; END_IF; END_IF;
            5:
                tgt_a := DOCK4;
                IF ABS(D1000-tgt_a)<500 THEN req_state:=6; END_IF;
            6:
                tgt_s40:=D600; tgt_s41:=D601; tgt_s42:=D602; Y75:=TRUE; Y76:=TRUE;
                hold_timer(IN:=TRUE, PT:=T#80ms);
                IF hold_timer.Q THEN hold_timer(IN:=FALSE); IF X77 OR X75 THEN Y75:=FALSE; Y76:=FALSE; req_state:=7; END_IF; END_IF;
            7:
                tgt_a := DOCK1; IF req_port_sel=2 THEN tgt_a:=DOCK2; END_IF;
                IF ABS(D1000-tgt_a)<500 THEN req_state:=8; END_IF;
            8:
                tgt_b:=0; tgt_c:=0; tgt_d:=0;
                IF ABS(D1004-tgt_b)<500 AND ABS(D1008-tgt_c)<500 AND ABS(D1012-tgt_d)<500 THEN req_state:=9; END_IF;
            9:
                D300:=D100; D301:=1; req0_done:=TRUE; active_req:=-1; req_state:=0;
                Y70:=FALSE; Y71:=FALSE; Y75:=FALSE; Y76:=FALSE;
        END_CASE;
    1:
        CASE req_state OF
            1:
                tgt_a := DOCK1; IF req_port_sel=2 THEN tgt_a:=DOCK2; END_IF;
                tgt_c := D92; tgt_d := D92;
                IF ABS(D1000-tgt_a)<500 AND ABS(D1008-tgt_c)<500 AND ABS(D1012-tgt_d)<500 THEN req_state:=2; END_IF;
            2:
                tgt_b := 18000;
                IF ABS(D1004-tgt_b)<500 THEN req_state:=3; END_IF;
            3:
                tgt_a := DOCK3;
                IF ABS(D1000-tgt_a)<500 THEN req_state:=4; END_IF;
            4:
                tgt_s30:=D500; tgt_s31:=D501; Y70:=TRUE; Y71:=TRUE;
                hold_timer(IN:=TRUE, PT:=T#80ms);
                IF hold_timer.Q THEN hold_timer(IN:=FALSE); IF X72 OR X70 THEN Y70:=FALSE; Y71:=FALSE; req_state:=5; END_IF; END_IF;
            5:
                tgt_a := DOCK4;
                IF ABS(D1000-tgt_a)<500 THEN req_state:=6; END_IF;
            6:
                tgt_s40:=D600; tgt_s41:=D601; tgt_s42:=D602; Y75:=TRUE; Y76:=TRUE;
                hold_timer(IN:=TRUE, PT:=T#80ms);
                IF hold_timer.Q THEN hold_timer(IN:=FALSE); IF X77 OR X75 THEN Y75:=FALSE; Y76:=FALSE; req_state:=7; END_IF; END_IF;
            7:
                tgt_a := DOCK1; IF req_port_sel=2 THEN tgt_a:=DOCK2; END_IF;
                IF ABS(D1000-tgt_a)<500 THEN req_state:=8; END_IF;
            8:
                tgt_b:=0; tgt_c:=0; tgt_d:=0;
                IF ABS(D1004-tgt_b)<500 AND ABS(D1008-tgt_c)<500 AND ABS(D1012-tgt_d)<500 THEN req_state:=9; END_IF;
            9:
                D302:=D120; D303:=1; req1_done:=TRUE; active_req:=-1; req_state:=0;
                Y70:=FALSE; Y71:=FALSE; Y75:=FALSE; Y76:=FALSE;
        END_CASE;
    ELSE
        tgt_a := HOME_A; tgt_b := HOME_B; tgt_c := HOME_C; tgt_d := HOME_D;
        tgt_s30 := HOME_S30; tgt_s31 := HOME_S31;
        tgt_s40 := HOME_S40; tgt_s41 := HOME_S41; tgt_s42 := HOME_S42;
        
        IF X31 AND NOT req0_done AND NOT req0_cancelled THEN req0_cancelled:=TRUE; D300:=D100; D301:=2; END_IF;
        IF X35 AND NOT req1_done AND NOT req1_cancelled THEN req1_cancelled:=TRUE; D302:=D120; D303:=2; END_IF;
        
        IF (req0_done OR req0_cancelled) AND (req1_done OR req1_cancelled) AND NOT completion_ok THEN completion_ok:=TRUE; END_IF;
        
        IF completion_ok THEN
            IF ABS(D1000-HOME_A)<200 AND ABS(D1004-HOME_B)<200 AND ABS(D1008-HOME_C)<200 AND ABS(D1012-HOME_D)<200 AND
               ABS(D1016-HOME_S30)<200 AND ABS(D1020-HOME_S31)<200 AND ABS(D1024-HOME_S40)<200 AND ABS(D1028-HOME_S41)<200 AND ABS(D1032-HOME_S42)<200 THEN
                obs_timer(IN:=TRUE, PT:=T#100ms);
            ELSE
                obs_timer(IN:=FALSE);
            END_IF;
            IF obs_timer.Q THEN Y2:=TRUE; END_IF;
        ELSE
            Y2:=FALSE;
        END_IF;
END_CASE;

lift_diff := ABS(REAL(D1008) - REAL(D1012));
gantry_skew := ABS(REAL(D1016) - REAL(D1020));
angle_sway := MAX(ABS(REAL(D1024)), ABS(REAL(D1028)));
mom_val := 0.1962 * (225.0 * (SIN(REAL(D1024)*C_PI/180.0) + SIN(REAL(D1028)*C_PI/180.0)) + REAL(D1032));

IF lift_diff > 8000.0 THEN tgt_c := D1008; tgt_d := D1012; END_IF;
IF gantry_skew > 300.0 THEN tgt_s30 := D1016; tgt_s31 := D1020; END_IF;
IF angle_sway > 2500.0 THEN tgt_s40 := D1024; tgt_s41 := D1028; END_IF;
IF ABS(mom_val) > 25.0 THEN tgt_s42 := D1032; END_IF;

dist := ABS(REAL(tgt_a) - REAL(D1000));
calc_rate := MAX(20.0, dist / 50.0);
rate_val := DINT(LIMIT(20.0, calc_rate, 1000.0));

D2000 := LIMIT(-450000, tgt_a, 1461300);
D2001 := rate_val; Y40 := active_req >= 0 OR tgt_a <> D1000; D2002 := 0;

D2004 := LIMIT(0, tgt_b, 18000);
D2005 := 200; Y41 := active_req >= 0 OR tgt_b <> D1004; D2006 := 0;

D2008 := LIMIT(0, tgt_c, 120000);
D2009 := 200; Y42 := active_req >= 0 OR tgt_c <> D1008; D2010 := 0;

D2012 := LIMIT(0, tgt_d, 120000);
D2013 := 200; Y43 := active_req >= 0 OR tgt_d <> D1012; D2014 := 0;

D2016 := LIMIT(-95000, tgt_s30, 95000);
D2017 := 200; Y44 := (req_state >= 4 AND req_state <= 5 AND active_req = 0) OR (req_state >= 4 AND req_state <= 5 AND active_req = 1); D2018 := 0;

D2020 := LIMIT(-95000, tgt_s31, 95000);
D2021 := 200; Y45 := Y44; D2022 := 0;

D2024 := LIMIT(-5000, tgt_s40, 5000);
D2025 := 200; Y46 := (req_state >= 6 AND req_state <= 7 AND active_req = 0) OR (req_state >= 6 AND req_state <= 7 AND active_req = 1); D2026 := 0;

D2028 := LIMIT(-5000, tgt_s41, 5000);
D2029 := 200; Y47 := Y46; D2030 := 0;

D2032 := LIMIT(-45000, tgt_s42, 45000);
D2033 := 200; Y48 := Y46; D2034 := 0;

D700 := 0; D701 := 0; D702 := 0;
D710 := 0; D711 := 0; D712 := 0;
D80 := 0; D81 := req_port_sel; D82 := D91 + 1; Y30 := FALSE;

END_PROGRAM