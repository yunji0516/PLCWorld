PROGRAM Main
VAR
    req0_rise : R_TRIG;
    req1_rise : R_TRIG;
    timer_settle : TON;
    timer_approach : TON;
    timer_hold : TON;
    timer_stable : TON;
    
    rq0_id : DINT := 0;
    rq0_done : BOOL := FALSE;
    rq0_returned : BOOL := FALSE;
    rq0_location : DINT := 1;
    
    rq1_id : DINT := 0;
    rq1_done : BOOL := FALSE;
    rq1_returned : BOOL := FALSE;
    rq1_location : DINT := 2;
    
    seq_cnt : DINT := 1;
    last_action : DINT := 0;
    last_station : DINT := 0;
    last_seq : DINT := 0;
    
    tgt_a : DINT := 15000;
    tgt_b : DINT := 0;
    tgt_c : DINT := 0;
    tgt_d : DINT := 0;
    tgt_e : DINT := 0;
    tgt_f : DINT := 5000;
    en_a : BOOL := FALSE;
    en_b : BOOL := FALSE;
    en_c : BOOL := FALSE;
    en_d : BOOL := FALSE;
    en_e : BOOL := FALSE;
    en_f : BOOL := FALSE;
    
    act : DINT := 0;
    stn : DINT := 0;
    cpl_seq : DINT := 0;
    
    phase : DINT := 0;
    serving : DINT := 0;
    home_h_a : DINT := 0;
    home_h_b : DINT := 0;
    
    y2_active : BOOL := FALSE;
    y2_hold_cnt : DINT := 0;
    
    PORT_A : DINT := -90000;
    PORT_B : DINT := -35000;
    PORT_WAIT : DINT := 15000;
    PORT_TAB : DINT := 85000;
    H_CONN : DINT := 73250;
    F_CONN : DINT := 18000;
    F_RET : DINT := 0;
    T_CONN : DINT := 0;
    T_APP : DINT := 9000;
    S_RET : DINT := 5000;
    S_APP_MAX : DINT := 74000;
    RATE : DINT := 1000;
    
    S_INIT : DINT := 0;
    S_REQ_DETECT : DINT := 1;
    S_GO_LIFT : DINT := 2;
    S_WAIT_SHUTTLE_ARR : DINT := 3;
    S_LOWER_LIFT : DINT := 4;
    S_WAIT_LIFT_STOP : DINT := 5;
    S_CONN_EXTRACT : DINT := 6;
    S_WAIT_EXT_CONN : DINT := 7;
    S_FORK_OUT : DINT := 8;
    S_WAIT_FORK_OUT : DINT := 9;
    S_RAISE_LIFT_RET : DINT := 10;
    S_WAIT_RAISE_RET : DINT := 11;
    S_GO_TABLE : DINT := 12;
    S_WAIT_SHUTTLE_TAB : DINT := 13;
    S_CONN_DEPOSIT_TAB : DINT := 14;
    S_WAIT_TAB_DEP : DINT := 15;
    S_FORK_IN_TAB : DINT := 16;
    S_WAIT_FORK_IN_TAB : DINT := 17;
    S_ROTATE : DINT := 18;
    S_WAIT_ROT_SETTLE : DINT := 19;
    S_APPROACH : DINT := 20;
    S_WAIT_APP_SETTLE : DINT := 21;
    S_WAIT_SERVED : DINT := 22;
    S_RETRACT_SLIDE : DINT := 23;
    S_WAIT_SLIDE_RET : DINT := 24;
    S_ROT_BACK : DINT := 25;
    S_WAIT_ROT_BACK : DINT := 26;
    S_CONN_EXTRACT_TAB : DINT := 27;
    S_WAIT_TAB_EXT : DINT := 28;
    S_FORK_OUT_TAB : DINT := 29;
    S_WAIT_FORK_OUT_TAB : DINT := 30;
    S_GO_ORIG_LIFT : DINT := 31;
    S_WAIT_LIFT_POS : DINT := 32;
    S_CONN_DEPOSIT_LIFT : DINT := 33;
    S_WAIT_LIFT_DEP : DINT := 34;
    S_FORK_IN_LIFT : DINT := 35;
    S_WAIT_FORK_IN_LIFT : DINT := 36;
    S_LOWER_HOME : DINT := 37;
    S_WAIT_HOME_STOP : DINT := 38;
    S_ACK_REQ : DINT := 39;
    S_CHECK_NEXT : DINT := 40;
    S_FINAL_HOLD : DINT := 41;
    
    shuttle_holding_id : DINT := 0;
    table_id_cur : DINT := 0;
    buffer_id_cur : DINT := 0;
    req_depth : DINT := 70000;
    req_angle : DINT := 9000;
    orig_lane : DINT := 0;
END_VAR

req0_rise(CLK := NOT X30);
req1_rise(CLK := NOT X31);

home_h_a := D150;
home_h_b := D151;

IF (D100 <> 0) AND (NOT rq0_done) AND (rq0_id <> D100) THEN
    rq0_id := D100;
    rq0_done := FALSE;
    rq0_returned := FALSE;
    rq0_location := 1;
    IF (D104 = 1) THEN
        rq0_location := 1;
    ELSIF (D104 = 2) THEN
        rq0_location := 2;
    END_IF;
END_IF;

IF (D110 <> 0) AND (NOT rq1_done) AND (rq1_id <> D110) THEN
    rq1_id := D110;
    rq1_done := FALSE;
    rq1_returned := FALSE;
    rq1_location := 2;
    IF (D114 = 1) THEN
        rq1_location := 1;
    ELSIF (D114 = 2) THEN
        rq1_location := 2;
    END_IF;
END_IF;

rq0_location := D104;
rq1_location := D114;
rq0_returned := X32;
rq1_returned := X33;

tgt_a := 15000;
tgt_b := 0;
tgt_c := 0;
tgt_d := 0;
tgt_e := 0;
tgt_f := 5000;
en_a := FALSE;
en_b := FALSE;
en_c := FALSE;
en_d := FALSE;
en_e := FALSE;
en_f := FALSE;
act := 0;
stn := 0;
cpl_seq := last_seq;

CASE phase OF
    S_INIT:
        tgt_a := PORT_WAIT;
        tgt_b := F_RET;
        tgt_f := S_RET;
        en_a := TRUE;
        en_b := TRUE;
        en_f := TRUE;
        IF (ABS(D10 - PORT_WAIT) < 20) AND (D11 = 0) AND (ABS(D12 - F_RET) < 20) AND (ABS(D20 - S_RET) < 20) THEN
            phase := S_REQ_DETECT;
        END_IF;
        
    S_REQ_DETECT:
        IF (NOT rq0_done) AND (rq0_id <> 0) AND (rq0_location = 1) THEN
            serving := 0;
            orig_lane := 1;
            req_depth := DINT#70000;
            req_angle := 9000;
            phase := S_GO_LIFT;
        ELSIF (NOT rq0_done) AND (rq0_id <> 0) AND (rq0_location = 2) THEN
            serving := 0;
            orig_lane := 1;
            req_depth := DINT#70000;
            req_angle := 9000;
            phase := S_GO_LIFT;
        ELSIF (NOT rq1_done) AND (rq1_id <> 0) AND (rq1_location = 2) THEN
            serving := 1;
            orig_lane := 2;
            req_depth := DINT#70000;
            req_angle := 9000;
            phase := S_GO_LIFT;
        ELSIF (NOT rq1_done) AND (rq1_id <> 0) AND (rq1_location = 1) THEN
            serving := 1;
            orig_lane := 2;
            req_depth := DINT#70000;
            req_angle := 9000;
            phase := S_GO_LIFT;
        ELSIF (rq0_done) AND (rq1_done) AND (D90 = 0) AND (D91 = 0) AND (D92 = 0) THEN
            phase := S_FINAL_HOLD;
        END_IF;
        
    S_GO_LIFT:
        tgt_b := F_RET;
        en_b := TRUE;
        IF (orig_lane = 1) THEN
            tgt_a := PORT_A;
            tgt_c := H_CONN;
            tgt_d := 0;
        ELSE
            tgt_a := PORT_B;
            tgt_c := 0;
            tgt_d := H_CONN;
        END_IF;
        en_a := TRUE;
        IF (orig_lane = 1) THEN
            en_c := TRUE;
            en_d := FALSE;
        ELSE
            en_c := FALSE;
            en_d := TRUE;
        END_IF;
        IF (ABS(D10 - tgt_a) < 200) AND (D11 = 0) THEN
            phase := S_LOWER_LIFT;
        END_IF;
        
    S_LOWER_LIFT:
        IF (orig_lane = 1) THEN
            tgt_c := H_CONN;
            tgt_d := 0;
            en_c := TRUE;
            en_d := FALSE;
            IF (ABS(D14 - H_CONN) < 20) AND (D15 = 0) THEN
                phase := S_CONN_EXTRACT;
            END_IF;
        ELSE
            tgt_c := 0;
            tgt_d := H_CONN;
            en_c := FALSE;
            en_d := TRUE;
            IF (ABS(D16 - H_CONN) < 20) AND (D17 = 0) THEN
                phase := S_CONN_EXTRACT;
            END_IF;
        END_IF;
        tgt_a := tgt_a;
        en_a := TRUE;
        
    S_CONN_EXTRACT:
        act := 1;
        IF (orig_lane = 1) THEN
            stn := 1;
        ELSE
            stn := 2;
        END_IF;
        cpl_seq := seq_cnt;
        seq_cnt := seq_cnt + 1;
        last_seq := cpl_seq;
        tgt_a := tgt_a;
        en_a := TRUE;
        phase := S_WAIT_EXT_CONN;
        
    S_WAIT_EXT_CONN:
        IF (orig_lane = 1) AND (X54) THEN
            phase := S_FORK_OUT;
        ELSIF (orig_lane = 2) AND (X55) THEN
            phase := S_FORK_OUT;
        END_IF;
        tgt_a := tgt_a;
        en_a := TRUE;
        act := 1;
        stn := stn;
        cpl_seq := cpl_seq;
        
    S_FORK_OUT:
        tgt_b := F_CONN;
        en_b := TRUE;
        act := 0;
        stn := 0;
        cpl_seq := cpl_seq;
        IF (ABS(D12 - F_CONN) < 20) AND (D13 = 0) THEN
            phase := S_RAISE_LIFT_RET;
        END_IF;
        
    S_RAISE_LIFT_RET:
        IF (orig_lane = 1) THEN
            tgt_c := 0;
            tgt_d := 0;
            en_c := TRUE;
            en_d := FALSE;
            IF (D14 = 0) AND (D15 = 0) THEN
                phase := S_GO_TABLE;
            END_IF;
        ELSE
            tgt_c := 0;
            tgt_d := 0;
            en_c := FALSE;
            en_d := TRUE;
            IF (D16 = 0) AND (D17 = 0) THEN
                phase := S_GO_TABLE;
            END_IF;
        END_IF;
        tgt_a := tgt_a;
        en_a := TRUE;
        
    S_GO_TABLE:
        tgt_a := PORT_TAB;
        en_a := TRUE;
        tgt_b := F_CONN;
        en_b := TRUE;
        IF (ABS(D10 - PORT_TAB) < 200) AND (D11 = 0) THEN
            phase := S_CONN_DEPOSIT_TAB;
        END_IF;
        
    S_CONN_DEPOSIT_TAB:
        act := 2;
        stn := 4;
        cpl_seq := seq_cnt;
        seq_cnt := seq_cnt + 1;
        last_seq := cpl_seq;
        tgt_a := PORT_TAB;
        en_a := TRUE;
        tgt_b := F_CONN;
        en_b := TRUE;
        phase := S_WAIT_TAB_DEP;
        
    S_WAIT_TAB_DEP:
        IF (X56) THEN
            phase := S_FORK_IN_TAB;
        END_IF;
        tgt_a := PORT_TAB;
        en_a := TRUE;
        tgt_b := F_CONN;
        en_b := TRUE;
        act := 2;
        stn := 4;
        cpl_seq := cpl_seq;
        
    S_FORK_IN_TAB:
        tgt_b := F_RET;
        en_b := TRUE;
        act := 0;
        stn := 0;
        cpl_seq := cpl_seq;
        IF (ABS(D12 - F_RET) < 20) AND (D13 = 0) THEN
            phase := S_ROTATE;
        END_IF;
        
    S_ROTATE:
        tgt_e := T_APP;
        en_e := TRUE;
        IF (ABS(D18 - T_APP) < 20) AND (D19 = 0) THEN
            timer_settle(IN := TRUE, PT := T#30ms);
            phase := S_WAIT_ROT_SETTLE;
        END_IF;
        
    S_WAIT_ROT_SETTLE:
        timer_settle(IN := TRUE, PT := T#30ms);
        tgt_e := T_APP;
        en_e := TRUE;
        IF (timer_settle.Q) THEN
            phase := S_APPROACH;
        END_IF;
        
    S_APPROACH:
        tgt_f := req_depth;
        en_f := TRUE;
        IF (ABS(D20 - req_depth) < 20) AND (D21 = 0) THEN
            timer_approach(IN := TRUE, PT := T#80ms);
            phase := S_WAIT_APP_SETTLE;
        END_IF;
        
    S_WAIT_APP_SETTLE:
        timer_approach(IN := TRUE, PT := T#80ms);
        tgt_f := req_depth;
        en_f := TRUE;
        IF (timer_approach.Q) THEN
            phase := S_WAIT_SERVED;
        END_IF;
        
    S_WAIT_SERVED:
        tgt_f := req_depth;
        en_f := TRUE;
        tgt_e := T_APP;
        en_e := TRUE;
        IF ((serving = 0) AND (X30)) OR ((serving = 1) AND (X31)) THEN
            phase := S_RETRACT_SLIDE;
        END_IF;
        
    S_RETRACT_SLIDE:
        tgt_f := S_RET;
        en_f := TRUE;
        IF (ABS(D20 - S_RET) < 20) AND (D21 = 0) THEN
            phase := S_ROT_BACK;
        END_IF;
        
    S_ROT_BACK:
        tgt_e := T_CONN;
        en_e := TRUE;
        IF (ABS(D18 - T_CONN) < 20) AND (D19 = 0) THEN
            timer_settle(IN := TRUE, PT := T#30ms);
            phase := S_WAIT_ROT_BACK;
        END_IF;
        
    S_WAIT_ROT_BACK:
        timer_settle(IN := TRUE, PT := T#30ms);
        tgt_e := T_CONN;
        en_e := TRUE;
        IF (timer_settle.Q) THEN
            phase := S_CONN_EXTRACT_TAB;
        END_IF;
        
    S_CONN_EXTRACT_TAB:
        act := 1;
        stn := 4;
        cpl_seq := seq_cnt;
        seq_cnt := seq_cnt + 1;
        last_seq := cpl_seq;
        tgt_a := PORT_TAB;
        en_a := TRUE;
        phase := S_WAIT_TAB_EXT;
        
    S_WAIT_TAB_EXT:
        IF (X56) THEN
            phase := S_FORK_OUT_TAB;
        END_IF;
        tgt_a := PORT_TAB;
        en_a := TRUE;
        act := 1;
        stn := 4;
        cpl_seq := cpl_seq;
        
    S_FORK_OUT_TAB:
        tgt_b := F_CONN;
        en_b := TRUE;
        act := 0;
        stn := 0;
        cpl_seq := cpl_seq;
        IF (ABS(D12 - F_CONN) < 20) AND (D13 = 0) THEN
            phase := S_GO_ORIG_LIFT;
        END_IF;
        
    S_GO_ORIG_LIFT:
        tgt_a := tgt_a;
        tgt_b := F_CONN;
        en_a := TRUE;
        en_b := TRUE;
        IF (orig_lane = 1) THEN
            tgt_a := PORT_A;
        ELSE
            tgt_a := PORT_B;
        END_IF;
        IF (ABS(D10 - tgt_a) < 200) AND (D11 = 0) THEN
            phase := S_CONN_DEPOSIT_LIFT;
        END_IF;
        
    S_CONN_DEPOSIT_LIFT:
        act := 2;
        IF (orig_lane = 1) THEN
            stn := 1;
        ELSE
            stn := 2;
        END_IF;
        cpl_seq := seq_cnt;
        seq_cnt := seq_cnt + 1;
        last_seq := cpl_seq;
        tgt_a := tgt_a;
        en_a := TRUE;
        phase := S_WAIT_LIFT_DEP;
        
    S_WAIT_LIFT_DEP:
        IF (orig_lane = 1) AND (X54) THEN
            phase := S_FORK_IN_LIFT;
        ELSIF (orig_lane = 2) AND (X55) THEN
            phase := S_FORK_IN_LIFT;
        END_IF;
        tgt_a := tgt_a;
        en_a := TRUE;
        act := 2;
        stn := stn;
        cpl_seq := cpl_seq;
        
    S_FORK_IN_LIFT:
        tgt_b := F_RET;
        en_b := TRUE;
        act := 0;
        stn := 0;
        cpl_seq := cpl_seq;
        IF (ABS(D12 - F_RET) < 20) AND (D13 = 0) THEN
            phase := S_LOWER_HOME;
        END_IF;
        
    S_LOWER_HOME:
        IF (orig_lane = 1) THEN
            tgt_c := home_h_a;
            tgt_d := 0;
            en_c := TRUE;
            en_d := FALSE;
            IF (ABS(D14 - home_h_a) < 20) AND (D15 = 0) THEN
                phase := S_ACK_REQ;
            END_IF;
        ELSE
            tgt_c := 0;
            tgt_d := home_h_b;
            en_c := FALSE;
            en_d := TRUE;
            IF (ABS(D16 - home_h_b) < 20) AND (D17 = 0) THEN
                phase := S_ACK_REQ;
            END_IF;
        END_IF;
        
    S_ACK_REQ:
        IF (serving = 0) THEN
            D300 := rq0_id;
            D301 := 1;
            rq0_done := TRUE;
        ELSE
            D302 := rq1_id;
            D303 := 1;
            rq1_done := TRUE;
        END_IF;
        act := 0;
        stn := 0;
        phase := S_CHECK_NEXT;
        
    S_CHECK_NEXT:
        IF (NOT rq0_done) OR (NOT rq1_done) THEN
            phase := S_REQ_DETECT;
        ELSE
            phase := S_FINAL_HOLD;
        END_IF;
        D300 := 0;
        D301 := 0;
        D302 := 0;
        D303 := 0;
        
    S_FINAL_HOLD:
        tgt_a := 0;
        tgt_b := 0;
        tgt_c := home_h_a;
        tgt_d := home_h_b;
        tgt_e := T_CONN;
        tgt_f := S_RET;
        en_a := TRUE;
        en_b := TRUE;
        en_c := TRUE;
        en_d := TRUE;
        en_e := TRUE;
        en_f := TRUE;
        act := 0;
        stn := 0;
        D300 := 0;
        D301 := 0;
        D302 := 0;
        D303 := 0;
        
        IF (ABS(D10) < 20) AND (D11 = 0) AND (ABS(D12) < 20) AND (D13 = 0) AND (ABS(D20 - S_RET) < 20) AND (D21 = 0) AND (ABS(D14 - home_h_a) < 20) AND (D15 = 0) AND (ABS(D16 - home_h_b) < 20) AND (D17 = 0) AND (ABS(D18 - T_CONN) < 20) AND (D19 = 0) THEN
            timer_hold(IN := TRUE, PT := T#100ms);
            IF (timer_hold.Q) THEN
                Y2 := TRUE;
                y2_active := TRUE;
            END_IF;
        ELSE
            timer_hold(IN := FALSE, PT := T#100ms);
        END_IF;
        
        IF (X51) AND (y2_active) THEN
            timer_stable(IN := TRUE, PT := T#100ms);
            IF (timer_stable.Q) THEN
                Y2 := FALSE;
            END_IF;
        ELSE
            timer_stable(IN := FALSE, PT := T#100ms);
        END_IF;
END_CASE;

D200 := tgt_a;
D201 := RATE;
Y20 := en_a;
D204 := tgt_b;
D205 := RATE;
Y21 := en_b;
D208 := tgt_c;
D209 := RATE;
Y22 := en_c;
D212 := tgt_d;
D213 := RATE;
Y23 := en_d;
D216 := tgt_e;
D217 := RATE;
Y24 := en_e;
D220 := tgt_f;
D221 := RATE;
Y25 := en_f;
D80 := act;
D81 := stn;
D82 := cpl_seq;

END_PROGRAM