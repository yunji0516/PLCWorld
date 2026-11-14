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

    r_id : ARRAY[0..1] OF DINT;
    r_state : ARRAY[0..1] OF INT;
    
    shuttle_state : INT;
    shuttle_src : INT;
    shuttle_dst : INT;
    shuttle_req : INT;
    shuttle_src_x : DINT;
    shuttle_dst_x : DINT;
    src_ready : BOOL;
    dst_ready : BOOL;
    
    table_state : INT;
    t_ch : INT;
    tab_appr_ok : BOOL;
    appr_timer : TON;
    
    table_free : BOOL;
    wait_free : BOOL;
    
    a_target : DINT;
    b_target : DINT;
    c_target : DINT;
    d_target : DINT;
    e_target : DINT;
    f_target : DINT;
END_VAR

(* 1. Read Requests and State Updates *)
IF D100 > 0 AND r_state[0] = 0 THEN
    r_id[0] := D100;
    r_state[0] := 10;
END_IF;
IF D110 > 0 AND r_state[1] = 0 THEN
    r_id[1] := D110;
    r_state[1] := 10;
END_IF;

table_free := NOT ((r_state[0] >= 40 AND r_state[0] <= 70) OR (r_state[1] >= 40 AND r_state[1] <= 70));
wait_free := NOT ((r_state[0] = 30 OR r_state[0] = 35) OR (r_state[1] = 30 OR r_state[1] = 35));

(* 2. Shuttle Scheduler *)
IF shuttle_state = 0 AND NOT X51 THEN
    IF r_state[0] = 70 THEN
        shuttle_src := 4; shuttle_dst := 1; shuttle_req := 0; shuttle_state := 10; r_state[0] := 80;
    ELSIF r_state[1] = 70 THEN
        shuttle_src := 4; shuttle_dst := 2; shuttle_req := 1; shuttle_state := 10; r_state[1] := 80;
    ELSIF r_state[0] = 35 AND table_free THEN
        shuttle_src := 3; shuttle_dst := 4; shuttle_req := 0; shuttle_state := 10; r_state[0] := 40;
    ELSIF r_state[1] = 35 AND table_free THEN
        shuttle_src := 3; shuttle_dst := 4; shuttle_req := 1; shuttle_state := 10; r_state[1] := 40;
    ELSIF r_state[0] = 20 AND table_free THEN
        shuttle_src := 1; shuttle_dst := 4; shuttle_req := 0; shuttle_state := 10; r_state[0] := 40;
    ELSIF r_state[1] = 20 AND table_free THEN
        shuttle_src := 2; shuttle_dst := 4; shuttle_req := 1; shuttle_state := 10; r_state[1] := 40;
    ELSIF r_state[0] = 20 AND wait_free THEN
        shuttle_src := 1; shuttle_dst := 3; shuttle_req := 0; shuttle_state := 10; r_state[0] := 30;
    ELSIF r_state[1] = 20 AND wait_free THEN
        shuttle_src := 2; shuttle_dst := 3; shuttle_req := 1; shuttle_state := 10; r_state[1] := 30;
    END_IF;
    
    CASE shuttle_src OF
        1: shuttle_src_x := -90000;
        2: shuttle_src_x := -35000;
        3: shuttle_src_x := 15000;
        4: shuttle_src_x := 85000;
    END_CASE;
    CASE shuttle_dst OF
        1: shuttle_dst_x := -90000;
        2: shuttle_dst_x := -35000;
        3: shuttle_dst_x := 15000;
        4: shuttle_dst_x := 85000;
    END_CASE;
END_IF;

(* 3. Shuttle Execution *)
CASE shuttle_state OF
    10:
        a_target := shuttle_src_x;
        src_ready := FALSE;
        CASE shuttle_src OF
            1: src_ready := X54;
            2: src_ready := X55;
            3: src_ready := TRUE;
            4: src_ready := X56;
        END_CASE;
        IF ABS(D10 - a_target) <= 20 AND ABS(D11) <= 100 AND src_ready THEN
            shuttle_state := 20;
        END_IF;
    20:
        b_target := 18000;
        IF ABS(D12 - 18000) <= 20 AND ABS(D13) <= 100 THEN
            D80 := 1;
            D81 := shuttle_src;
            D82 := D82 + 1;
            shuttle_state := 35;
        END_IF;
    35:
        IF D96 = D82 THEN
            shuttle_state := 40;
        END_IF;
    40:
        b_target := 0;
        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            shuttle_state := 50;
        END_IF;
    50:
        a_target := shuttle_dst_x;
        dst_ready := FALSE;
        CASE shuttle_dst OF
            1: dst_ready := X54;
            2: dst_ready := X55;
            3: dst_ready := TRUE;
            4: dst_ready := X56;
        END_CASE;
        IF ABS(D10 - a_target) <= 20 AND ABS(D11) <= 100 AND dst_ready THEN
            shuttle_state := 60;
        END_IF;
    60:
        b_target := 18000;
        IF ABS(D12 - 18000) <= 20 AND ABS(D13) <= 100 THEN
            D80 := 2;
            D81 := shuttle_dst;
            D82 := D82 + 1;
            shuttle_state := 75;
        END_IF;
    75:
        IF D96 = D82 THEN
            shuttle_state := 80;
        END_IF;
    80:
        b_target := 0;
        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            IF shuttle_req = 0 THEN
                IF r_state[0] = 30 THEN r_state[0] := 35;
                ELSIF r_state[0] = 40 THEN r_state[0] := 50;
                ELSIF r_state[0] = 80 THEN r_state[0] := 90;
                END_IF;
            ELSE
                IF r_state[1] = 30 THEN r_state[1] := 35;
                ELSIF r_state[1] = 40 THEN r_state[1] := 50;
                ELSIF r_state[1] = 80 THEN r_state[1] := 90;
                END_IF;
            END_IF;
            shuttle_state := 0;
        END_IF;
END_CASE;

IF r_state[0] = 50 THEN r_state[0] := 60; END_IF;
IF r_state[1] = 50 THEN r_state[1] := 60; END_IF;

(* 4. Table Execution *)
IF table_state = 0 THEN
    IF r_state[0] = 60 THEN
        t_ch := 0; table_state := 1;
    ELSIF r_state[1] = 60 THEN
        t_ch := 1; table_state := 1;
    ELSE
        e_target := 0; f_target := 5000;
    END_IF;
END_IF;

tab_appr_ok := (table_state = 2) AND (ABS(D20 - D95) <= 20) AND (ABS(D21) <= 100);
appr_timer(IN := tab_appr_ok, PT := T#80ms);

CASE table_state OF
    1:
        e_target := D94;
        IF X53 THEN table_state := 2; END_IF;
    2:
        f_target := D95;
        IF appr_timer.Q OR X52 THEN 
            table_state := 3; 
        END_IF;
    3:
        f_target := 5000;
        IF ABS(D20 - 5000) <= 20 AND ABS(D21) <= 100 THEN table_state := 4; END_IF;
    4:
        e_target := 0;
        IF X56 THEN
            table_state := 5;
        END_IF;
    5:
        IF t_ch = 0 THEN r_state[0] := 70; ELSE r_state[1] := 70; END_IF;
        table_state := 0;
END_CASE;

(* 5. Lift Execution and Request State Progress *)
CASE r_state[0] OF
    10: IF X54 THEN r_state[0] := 20; END_IF;
    90: r_state[0] := 100;
    100: IF ABS(D14 - D150) <= 20 AND ABS(D15) <= 100 THEN r_state[0] := 110; END_IF;
    110: IF D100 = 0 THEN r_state[0] := 0; END_IF;
END_CASE;

IF r_state[0] >= 10 AND r_state[0] <= 90 THEN
    c_target := 73250;
ELSE
    c_target := D150;
END_IF;

IF r_state[0] = 110 THEN
    D300 := r_id[0]; D301 := 1;
ELSE
    D300 := 0; D301 := 0;
END_IF;

CASE r_state[1] OF
    10: IF X55 THEN r_state[1] := 20; END_IF;
    90: r_state[1] := 100;
    100: IF ABS(D16 - D151) <= 20 AND ABS(D17) <= 100 THEN r_state[1] := 110; END_IF;
    110: IF D110 = 0 THEN r_state[1] := 0; END_IF;
END_CASE;

IF r_state[1] >= 10 AND r_state[1] <= 90 THEN
    d_target := 73250;
ELSE
    d_target := D151;
END_IF;

IF r_state[1] = 110 THEN
    D302 := r_id[1]; D303 := 1;
ELSE
    D302 := 0; D303 := 0;
END_IF;

(* 6. Final Outputs and Overrides *)
D201 := 1000; Y20 := TRUE;
D205 := 1000; Y21 := TRUE;
D209 := 1000; Y22 := TRUE;
D213 := 1000; Y23 := TRUE;
D217 := 1000; Y24 := TRUE;
D221 := 1000; Y25 := TRUE;

IF X51 THEN
    a_target := 0;
    b_target := 0;
    e_target := 0;
    f_target := 5000;
    c_target := D150;
    d_target := D151;
    IF ABS(D10) <= 20 AND ABS(D12) <= 20 AND ABS(D18) <= 20 AND ABS(D20 - 5000) <= 20 AND ABS(D14 - D150) <= 20 AND ABS(D16 - D151) <= 20 AND D90=0 AND D91=0 AND D92=0 THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;
ELSE
    Y2 := FALSE;
END_IF;

D200 := a_target;
D204 := b_target;
D208 := c_target;
D212 := d_target;
D216 := e_target;
D220 := f_target;

END_PROGRAM