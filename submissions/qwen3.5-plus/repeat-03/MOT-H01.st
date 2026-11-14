PROGRAM Main
VAR
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D18 : DINT;
    D19 : DINT;
    D20 : DINT;
    D21 : DINT;
    D100 : DINT;
    X30 : BOOL;
    X32 : BOOL;
    D104 : DINT;
    D103 : DINT;
    D110 : DINT;
    X31 : BOOL;
    X33 : BOOL;
    D114 : DINT;
    D113 : DINT;
    X51 : BOOL;
    D90 : DINT;
    D91 : DINT;
    D92 : DINT;
    D93 : DINT;
    D94 : DINT;
    D95 : DINT;
    D96 : DINT;
    X52 : BOOL;
    X53 : BOOL;
    X54 : BOOL;
    X55 : BOOL;
    X56 : BOOL;
    X57 : BOOL;
    D150 : DINT;
    D151 : DINT;
    D200 : DINT;
    D201 : DINT;
    Y20 : BOOL;
    D204 : DINT;
    D205 : DINT;
    Y21 : BOOL;
    D208 : DINT;
    D209 : DINT;
    Y22 : BOOL;
    D212 : DINT;
    D213 : DINT;
    Y23 : BOOL;
    D216 : DINT;
    D217 : DINT;
    Y24 : BOOL;
    D220 : DINT;
    D221 : DINT;
    Y25 : BOOL;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y2 : BOOL;
    
    g_state : DINT := 0;
    active_req : DINT := 0;
    target_lift : DINT := 1;
    current_id : DINT := 0;
    target_depth : DINT;
    seq_cnt : DINT := 0;
    done0 : BOOL := FALSE;
    done1 : BOOL := FALSE;
    
    t_couple : TON;
    t_home : TON;
    
    sh_arr : BOOL;
    fk_arr : BOOL;
    lf_arr : BOOL;
    tb_arr : BOOL;
    sl_arr : BOOL;
    
    lf_pos : DINT;
    lf_vel : DINT;
    lf_tgt : DINT;
END_VAR

D201 := 1000;
D205 := 1000;
D209 := 1000;
D213 := 1000;
D217 := 1000;
D221 := 1000;

sh_arr := ABS(D10 - D200) <= 20 AND ABS(D11) <= 100;
fk_arr := ABS(D12 - D204) <= 20 AND ABS(D13) <= 100;
tb_arr := ABS(D18 - D216) <= 20 AND ABS(D19) <= 100;
sl_arr := ABS(D20 - D220) <= 20 AND ABS(D21) <= 100;

lf_pos := IF target_lift = 1 THEN D14 ELSE D16 END_IF;
lf_vel := IF target_lift = 1 THEN D15 ELSE D17 END_IF;
lf_tgt := IF target_lift = 1 THEN D208 ELSE D212 END_IF;
lf_arr := ABS(lf_pos - lf_tgt) <= 20 AND ABS(lf_vel) <= 100;

CASE g_state OF
    0: (* IDLE / SELECT NEXT *)
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y25 := FALSE;
        D200 := D10; D204 := D12; D208 := D14; D212 := D16; D216 := D18; D220 := D20;
        D80 := 0; D81 := 0; D82 := seq_cnt;
        t_couple(IN := FALSE, PT := T#100ms);
        t_home(IN := FALSE, PT := T#100ms);
        Y2 := FALSE;
        
        IF NOT done0 THEN
            active_req := 0; target_lift := 1; current_id := D100;
            target_depth := D95;
            g_state := 1;
        ELSIF NOT done1 THEN
            active_req := 1; target_lift := 2; current_id := D110;
            target_depth := D95;
            g_state := 1;
        ELSE
            g_state := 25;
        END_IF;

    1: (* ALIGN LIFT TO CONNECTION HEIGHT *)
        Y20 := FALSE; Y21 := FALSE; Y24 := FALSE; Y25 := FALSE;
        D80 := 0; D81 := 0; D82 := seq_cnt;
        D200 := D10; D204 := D12; D216 := D18; D220 := D20;
        IF target_lift = 1 THEN D208 := 73250; Y22 := TRUE; ELSE D212 := 73250; Y23 := TRUE; END_IF;
        t_couple(IN := FALSE, PT := T#100ms);
        IF lf_arr THEN g_state := 2; END_IF;

    2: (* SHUTTLE TO LIFT X *)
        Y21 := FALSE; Y24 := FALSE; Y25 := FALSE;
        D80 := 0; D81 := 0; D82 := seq_cnt;
        D204 := D12; D216 := D18; D220 := D20;
        IF target_lift = 1 THEN 
            D208 := D14; D200 := -90000; Y22 := TRUE; 
        ELSE 
            D212 := D16; D200 := -35000; Y23 := TRUE; 
        END_IF;
        Y20 := TRUE;
        IF D12 > 4000 THEN D200 := D10; Y20 := FALSE; END_IF;
        t_couple(IN := FALSE, PT := T#100ms);
        IF sh_arr AND lf_arr THEN g_state := 3; END_IF;

    3: (* FORK EXTEND TO 180 *)
        Y20 := FALSE; Y24 := FALSE; Y25 := FALSE;
        D80 := 0; D81 := 0; D82 := seq_cnt;
        D200 := IF target_lift = 1 THEN -90000 ELSE -35000 END_IF;
        D216 := D18; D220 := D20;
        IF target_lift = 1 THEN D208 := D14; Y22 := TRUE; ELSE D212 := D16; Y23 := TRUE; END_IF;
        Y20 := TRUE; Y21 := TRUE;
        D204 := 18000;
        t_couple(IN := FALSE, PT := T#100ms);
        IF fk_arr AND sh_arr AND lf_arr THEN g_state := 4; END_IF;

    4: (* CMD PICKUP FROM LIFT *)
        D80 := 1; D81 := target_lift; D82 := seq_cnt; seq_cnt := seq_cnt + 1;
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := FALSE; Y25 := FALSE;
        D200 := IF target_lift = 1 THEN -90000 ELSE -35000 END_IF;
        D204 := 18000; D216 := D18; D220 := D20;
        t_couple(IN := TRUE, PT := T#100ms);
        IF t_couple.Q THEN
            t_couple(IN := FALSE);
            g_state := 5;
        END_IF;

    5: (* FORK RETRACT *)
        D80 := 0; D81 := 0; D82 := seq_cnt;
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := FALSE; Y25 := FALSE;
        D200 := IF target_lift = 1 THEN -90000 ELSE -35000 END_IF;
        D204 := 0; D216 := D18; D220 := D20;
        IF target_lift = 1 THEN D208 := D14; Y22 := TRUE; ELSE D212 := D16; Y23 := TRUE; END_IF;
        t_couple(IN := FALSE, PT := T#100ms);
        IF fk_arr THEN g_state := 6; END_IF;

    6: (* SHUTTLE TO STANDBY *)
        D80 := 0; D81 := 0; D82 := seq_cnt;
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := FALSE; Y25 := FALSE;
        D200 := 15000; D204 := 0; D216 := D18; D220 := D20;
        IF target_lift = 1 THEN D208 := D14; Y22 := TRUE; ELSE D212 := D16; Y23 := TRUE; END_IF;
        t_couple(IN := FALSE, PT := T#100ms);
        IF sh_arr AND fk_arr AND lf_arr THEN g_state := 7; END_IF;

    7: (* CMD PLACE TO STANDBY *)
        D80 := 2; D81 := 3; D82 := seq_cnt; seq_cnt := seq_cnt + 1;
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := FALSE; Y25 := FALSE;
        D200 := 15000; D204 := 0; D216 := D18; D220 := D20;
        t_couple(IN := TRUE, PT := T#100ms);
        IF t_couple.Q THEN
            t_couple(IN := FALSE);
            g_state := 8;
        END_IF;

    8: (* FORK EXTEND *)
        D80 := 0; D81 := 0; D82 := seq_cnt;
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := FALSE; Y25 := FALSE;
        D200 := 15000; D204 := 18000; D216 := D18; D220 := D20;
        IF target_lift = 1 THEN D208 := D14; Y22 := TRUE; ELSE D212 := D16; Y23 := TRUE; END_IF;
        t_couple(IN := FALSE, PT := T#100ms);
        IF fk_arr AND sh_arr AND lf_arr THEN g_state := 9; END_IF;

    9: (* CMD PICKUP FROM STANDBY *)
        D80 := 1; D81 := 3; D82 := seq_cnt; seq_cnt := seq_cnt + 1;
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := FALSE; Y25 := FALSE;
        D200 := 15000; D204 := 18000; D216 := D18; D220 := D20;
        t_couple(IN := TRUE, PT := T#100ms);
        IF t_couple.Q THEN
            t_couple(IN := FALSE);
            g_state := 10;
        END_IF;

    10: (* FORK RETRACT *)
        D80 := 0; D81 := 0; D82 := seq_cnt;
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := FALSE; Y25 := FALSE;
        D200 := 15000; D204 := 0; D216 := D18; D220 := D20;
        IF target_lift = 1 THEN D208 := D14; Y22 := TRUE; ELSE D212 := D16; Y23 := TRUE; END_IF;
        t_couple(IN := FALSE, PT := T#100ms);
        IF fk_arr THEN g_state := 11; END_IF;

    11: (* SHUTTLE TO TABLE *)
        D80 := 0; D81 := 0; D82 := seq_cnt;
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := FALSE; Y25 := FALSE;
        D200 := 85000; D204 := 0; D216 := D18; D220 := D20;
        IF target_lift = 1 THEN D208 := D14; Y22 := TRUE; ELSE D212 := D16; Y23 := TRUE; END_IF;
        t_couple(IN := FALSE, PT := T#100ms);
        IF sh_arr AND fk_arr AND lf_arr THEN g_state := 12; END_IF;

    12: (* CMD PLACE TO TABLE *)
        D80 := 2; D81 := 4; D82 := seq_cnt; seq_cnt := seq_cnt + 1;
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := FALSE; Y25 := FALSE;
        D200 := 85000; D204 := 0; D216 := D18; D220 := D20;
        t_couple(IN := TRUE, PT := T#100ms);
        IF t_couple.Q THEN
            t_couple(IN := FALSE);
            g_state := 13;
        END_IF;

    13: (* ROTATE TABLE TO 90 *)
        D80 := 0; D81 := 0; D82 := seq_cnt;
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := TRUE; Y25 := FALSE;
        D200 := 85000; D204 := 0; D220 := D20;
        IF target_lift = 1 THEN D208 := D14; Y22 := TRUE; ELSE D212 := D16; Y23 := TRUE; END_IF;
        D216 := 9000;
        t_couple(IN := FALSE, PT := T#100ms);
        IF tb_arr AND fk_arr AND sh_arr AND lf_arr THEN g_state := 14; END_IF;

    14: (* SLIDE APPROACH *)
        D80 := 0; D81 := 0; D82 := seq_cnt;
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := TRUE; Y25 := TRUE;
        D200 := 85000; D204 := 0; D216 := 9000;
        IF target_lift = 1 THEN D208 := D14; Y22 := TRUE; ELSE D212 := D16; Y23 := TRUE; END_IF;
        D220 := target_depth;
        t_couple(IN := FALSE, PT := T#100ms);
        IF sl_arr AND tb_arr AND fk_arr AND sh_arr AND lf_arr THEN g_state := 15; END_IF;

    15: (* WAIT SERVED *)
        D80 := 0; D81 := 0; D82 := seq_cnt;
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := TRUE; Y25 := TRUE;
        D200 := 85000; D204 := 0; D216 := 9000; D220 := target_depth;
        IF target_lift = 1 THEN D208 := D14; Y22 := TRUE; ELSE D212 := D16; Y23 := TRUE; END_IF;
        t_couple(IN := FALSE, PT := T#100ms);
        IF (active_req = 0 AND X30) OR (active_req = 1 AND X31) THEN
            g_state := 16;
        END_IF;

    16: (* SLIDE RETRACT *)
        D80 := 0; D81 := 0; D82 := seq_cnt;
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := TRUE; Y25 := TRUE;
        D200 := 85000; D204 := 0; D216 := 9000; D220 := 5000;
        IF target_lift = 1 THEN D208 := D14; Y22 := TRUE; ELSE D212 := D16; Y23 := TRUE; END_IF;
        t_couple(IN := FALSE, PT := T#100ms);
        IF sl_arr AND tb_arr AND fk_arr AND sh_arr AND lf_arr THEN g_state := 17; END_IF;

    17: (* ROTATE TABLE TO 0 *)
        D80 := 0; D81 := 0; D82 := seq_cnt;
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := TRUE; Y25 := FALSE;
        D200 := 85000; D204 := 0; D216 := 0; D220 := 5000;
        IF target_lift = 1 THEN D208 := D14; Y22 := TRUE; ELSE D212 := D16; Y23 := TRUE; END_IF;
        t_couple(IN := FALSE, PT := T#100ms);
        IF tb_arr AND fk_arr AND sh_arr AND sl_arr AND lf_arr THEN g_state := 18; END_IF;

    18: (* FORK EXTEND *)
        D80 := 0; D81 := 0; D82 := seq_cnt;
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := TRUE; Y25 := FALSE;
        D200 := 85000; D204 := 18000; D216 := 0; D220 := 5000;
        IF target_lift = 1 THEN D208 := D14; Y22 := TRUE; ELSE D212 := D16; Y23 := TRUE; END_IF;
        t_couple(IN := FALSE, PT := T#100ms);
        IF fk_arr AND tb_arr AND sh_arr AND sl_arr AND lf_arr THEN g_state := 19; END_IF;

    19: (* CMD PICKUP FROM TABLE *)
        D80 := 1; D81 := 4; D82 := seq_cnt; seq_cnt := seq_cnt + 1;
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := TRUE; Y25 := FALSE;
        D200 := 85000; D204 := 18000; D216 := 0; D220 := 5000;
        t_couple(IN := TRUE, PT := T#100ms);
        IF t_couple.Q THEN
            t_couple(IN := FALSE);
            g_state := 20;
        END_IF;

    20: (* FORK RETRACT *)
        D80 := 0; D81 := 0; D82 := seq_cnt;
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := TRUE; Y25 := FALSE;
        D200 := 85000; D204 := 0; D216 := 0; D220 := 5000;
        IF target_lift = 1 THEN D208 := D14; Y22 := TRUE; ELSE D212 := D16; Y23 := TRUE; END_IF;
        t_couple(IN := FALSE, PT := T#100ms);
        IF fk_arr THEN g_state := 21; END_IF;

    21: (* SHUTTLE TO LIFT RETURN *)
        D80 := 0; D81 := 0; D82 := seq_cnt;
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := FALSE; Y25 := FALSE;
        D200 := IF target_lift = 1 THEN -90000 ELSE -35000 END_IF;
        D204 := 0; D216 := 0; D220 := 5000;
        IF target_lift = 1 THEN D208 := D14; Y22 := TRUE; ELSE D212 := D16; Y23 := TRUE; END_IF;
        t_couple(IN := FALSE, PT := T#100ms);
        IF sh_arr AND fk_arr AND tb_arr AND sl_arr AND lf_arr THEN g_state := 22; END_IF;

    22: (* CMD PLACE TO LIFT *)
        D80 := 2; D81 := target_lift; D82 := seq_cnt; seq_cnt := seq_cnt + 1;
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := FALSE; Y25 := FALSE;
        D200 := IF target_lift = 1 THEN -90000 ELSE -35000 END_IF;
        D204 := 0; D216 := 0; D220 := 5000;
        t_couple(IN := TRUE, PT := T#100ms);
        IF t_couple.Q THEN
            t_couple(IN := FALSE);
            g_state := 23;
        END_IF;

    23: (* LOWER LIFT TO HOME *)
        D80 := 0; D81 := 0; D82 := seq_cnt;
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := FALSE; Y25 := FALSE;
        D200 := IF target_lift = 1 THEN -90000 ELSE -35000 END_IF;
        D204 := 0; D216 := 0; D220 := 5000;
        IF target_lift = 1 THEN D208 := D150; Y22 := TRUE; ELSE D212 := D151; Y23 := TRUE; END_IF;
        t_couple(IN := FALSE, PT := T#100ms);
        IF lf_arr AND sh_arr AND fk_arr AND tb_arr AND sl_arr THEN g_state := 24; END_IF;

    24: (* ACK DONE *)
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y25 := FALSE;
        D80 := 0; D81 := 0; D82 := seq_cnt;
        D200 := D10; D204 := D12; D208 := D14; D212 := D16; D216 := D18; D220 := D20;
        t_couple(IN := FALSE, PT := T#100ms);
        IF active_req = 0 THEN
            D300 := current_id; D301 := 1; done0 := TRUE;
        ELSE
            D302 := current_id; D303 := 1; done1 := TRUE;
        END_IF;
        g_state := 0;

    25: (* RETURN TO HOME *)
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := TRUE; Y25 := TRUE;
        D200 := 0; D204 := 0; D216 := 0; D220 := 5000;
        D208 := D150; D212 := D151;
        D80 := 0; D81 := 0; D82 := seq_cnt;
        t_couple(IN := FALSE, PT := T#100ms);
        t_home(IN := TRUE, PT := T#100ms);
        IF sh_arr AND fk_arr AND tb_arr AND sl_arr AND lf_arr AND (D90 = 0) AND (D91 = 0) AND (D92 = 0) THEN
            IF t_home.Q THEN
                t_home(IN := FALSE);
                Y2 := TRUE;
                g_state := 26;
            END_IF;
        END_IF;

    26: (* MAINTAIN Y2 *)
        Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE; Y24 := TRUE; Y25 := TRUE;
        D200 := 0; D204 := 0; D216 := 0; D220 := 5000;
        D208 := D150; D212 := D151;
        D80 := 0; D81 := 0; D82 := seq_cnt;
        Y2 := TRUE;
        t_couple(IN := FALSE, PT := T#100ms);
        t_home(IN := FALSE, PT := T#100ms);
END_CASE;

END_PROGRAM