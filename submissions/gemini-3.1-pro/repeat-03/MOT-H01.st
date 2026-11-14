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

    init : BOOL := FALSE;
    cmd_seq : DINT := 0;
    ts : INT := 0;
    current_src : DINT := 0;
    current_dst : DINT := 0;
    table_state : INT := 0;
    c_target : DINT := 0;
    d_target : DINT := 0;
    station_ready : BOOL := FALSE;
    y2_cond : BOOL := FALSE;
    current_req0 : DINT := 0;
    current_req1 : DINT := 0;
END_VAR

IF NOT init THEN
    cmd_seq := D96;
    D200 := D10;
    D204 := 0;
    init := TRUE;
END_IF;

IF D100 > 0 AND D100 <> current_req0 THEN
    current_req0 := D100;
    D301 := 0;
    D300 := 0;
END_IF;

IF D110 > 0 AND D110 <> current_req1 THEN
    current_req1 := D110;
    D303 := 0;
    D302 := 0;
END_IF;

IF X51 THEN
    D200 := 0;
    D204 := 0;
    c_target := D150;
    d_target := D151;
    D216 := 0;
    D220 := 5000;
    
    IF ABS(D10) <= 20 AND ABS(D11) <= 100 AND
       ABS(D12) <= 20 AND ABS(D13) <= 100 AND
       ABS(D18) <= 20 AND ABS(D19) <= 100 AND
       ABS(D20 - 5000) <= 20 AND ABS(D21) <= 100 AND
       ABS(D14 - D150) <= 20 AND ABS(D15) <= 100 AND
       ABS(D16 - D151) <= 20 AND ABS(D17) <= 100 AND
       D90 = 0 AND D91 = 0 AND D92 = 0 THEN
        y2_cond := TRUE;
    ELSE
        y2_cond := FALSE;
    END_IF;
ELSE
    y2_cond := FALSE;
    
    IF (ABS(D10 - (-90000)) < 5000 AND D12 > 100) THEN
        c_target := 73250;
    ELSIF D100 > 0 AND D301 = 0 THEN
        IF NOT X30 THEN
            c_target := 73250;
        ELSE
            IF D104 = 1 THEN c_target := D150; ELSE c_target := 73250; END_IF;
        END_IF;
    ELSE
        c_target := D150;
    END_IF;
    
    IF (ABS(D10 - (-35000)) < 5000 AND D12 > 100) THEN
        d_target := 73250;
    ELSIF D110 > 0 AND D303 = 0 THEN
        IF NOT X31 THEN
            d_target := 73250;
        ELSE
            IF D114 = 2 THEN d_target := D151; ELSE d_target := 73250; END_IF;
        END_IF;
    ELSE
        d_target := D151;
    END_IF;
    
    IF (D100 > 0 AND D301 = 0 AND X30 AND D104 = 1 AND ABS(D14 - D150) <= 20 AND ABS(D15) <= 100) THEN
        D300 := D100;
        D301 := 1;
    END_IF;

    IF (D110 > 0 AND D303 = 0 AND X31 AND D114 = 2 AND ABS(D16 - D151) <= 20 AND ABS(D17) <= 100) THEN
        D302 := D110;
        D303 := 1;
    END_IF;
    
    IF table_state = 0 THEN
        D216 := 0; D220 := 5000;
        IF D91 > 0 AND NOT X52 THEN table_state := 1; END_IF;
    ELSIF table_state = 1 THEN
        D216 := 0; D220 := 5000;
        IF (D12 < 4000 OR ABS(D10 - 85000) > 5000) AND D20 <= 50000 THEN
            table_state := 2;
        END_IF;
    ELSIF table_state = 2 THEN
        D216 := D94; D220 := 5000;
        IF X53 AND ABS(D18 - D94) <= 20 THEN table_state := 3; END_IF;
    ELSIF table_state = 3 THEN
        D216 := D94; D220 := D95;
        IF X52 THEN table_state := 4; END_IF;
    ELSIF table_state = 4 THEN
        D216 := D94; D220 := 5000;
        IF D20 <= 50000 THEN table_state := 5; END_IF;
    ELSIF table_state = 5 THEN
        D216 := 0; D220 := 5000;
        IF X56 AND ABS(D18) <= 20 THEN table_state := 6; END_IF;
    ELSIF table_state = 6 THEN
        D216 := 0; D220 := 5000;
        IF D91 = 0 THEN table_state := 0; END_IF;
    END_IF;
    
    IF ts = 0 THEN
        IF D90 > 0 THEN
            IF D90 = D100 THEN
                IF X30 THEN current_dst := 1;
                ELSIF D91 = 0 AND table_state = 0 THEN current_dst := 4;
                ELSE current_dst := 3; END_IF;
            ELSIF D90 = D110 THEN
                IF X31 THEN current_dst := 2;
                ELSIF D91 = 0 AND table_state = 0 THEN current_dst := 4;
                ELSE current_dst := 3; END_IF;
            END_IF;
            ts := 20;
        ELSE
            IF D100 > 0 AND D301 = 0 AND D104 = 4 AND X30 AND table_state = 6 THEN
                current_src := 4; current_dst := 1; ts := 10;
            ELSIF D110 > 0 AND D303 = 0 AND D114 = 4 AND X31 AND table_state = 6 THEN
                current_src := 4; current_dst := 2; ts := 10;
            ELSIF D100 > 0 AND D104 = 3 AND D91 = 0 AND table_state = 0 THEN
                current_src := 3; current_dst := 4; ts := 10;
            ELSIF D110 > 0 AND D114 = 3 AND D91 = 0 AND table_state = 0 THEN
                current_src := 3; current_dst := 4; ts := 10;
            ELSIF D100 > 0 AND D104 = 1 AND D91 = 0 AND table_state = 0 AND NOT X30 THEN
                current_src := 1; current_dst := 4; ts := 10;
            ELSIF D110 > 0 AND D114 = 2 AND D91 = 0 AND table_state = 0 AND NOT X31 THEN
                current_src := 2; current_dst := 4; ts := 10;
            ELSIF D100 > 0 AND D104 = 1 AND D91 > 0 AND D92 = 0 AND NOT X30 THEN
                current_src := 1; current_dst := 3; ts := 10;
            ELSIF D110 > 0 AND D114 = 2 AND D91 > 0 AND D92 = 0 AND NOT X31 THEN
                current_src := 2; current_dst := 3; ts := 10;
            END_IF;
        END_IF;
    END_IF;
    
    IF ts = 10 THEN
        IF current_src = 1 THEN D200 := -90000;
        ELSIF current_src = 2 THEN D200 := -35000;
        ELSIF current_src = 3 THEN D200 := 15000;
        ELSIF current_src = 4 THEN D200 := 85000;
        END_IF;
        D204 := 0; 
        
        IF ABS(D10 - D200) <= 20 AND ABS(D11) <= 100 THEN
            station_ready := FALSE;
            IF current_src = 1 AND X54 AND ABS(D14 - 73250) <= 20 AND ABS(D15) <= 100 THEN station_ready := TRUE;
            ELSIF current_src = 2 AND X55 AND ABS(D16 - 73250) <= 20 AND ABS(D17) <= 100 THEN station_ready := TRUE;
            ELSIF current_src = 3 THEN station_ready := TRUE;
            ELSIF current_src = 4 AND X56 AND ABS(D18) <= 20 AND ABS(D19) <= 100 AND table_state = 6 THEN station_ready := TRUE;
            END_IF;
            
            IF station_ready THEN ts := 11; END_IF;
        END_IF;
    ELSIF ts = 11 THEN
        D204 := 18000;
        IF ABS(D12 - 18000) <= 20 AND ABS(D13) <= 100 THEN ts := 12; END_IF;
    ELSIF ts = 12 THEN
        D80 := 1;
        D81 := current_src;
        cmd_seq := cmd_seq + 1;
        D82 := cmd_seq;
        ts := 13;
    ELSIF ts = 13 THEN
        IF D96 = D82 AND D90 > 0 THEN ts := 14; END_IF;
    ELSIF ts = 14 THEN
        D204 := 0;
        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN ts := 0; END_IF;
    ELSIF ts = 20 THEN
        IF current_dst = 1 THEN D200 := -90000;
        ELSIF current_dst = 2 THEN D200 := -35000;
        ELSIF current_dst = 3 THEN D200 := 15000;
        ELSIF current_dst = 4 THEN D200 := 85000;
        END_IF;
        D204 := 0;
        
        IF ABS(D10 - D200) <= 20 AND ABS(D11) <= 100 THEN
            station_ready := FALSE;
            IF current_dst = 1 AND X54 AND ABS(D14 - 73250) <= 20 AND ABS(D15) <= 100 THEN station_ready := TRUE;
            ELSIF current_dst = 2 AND X55 AND ABS(D16 - 73250) <= 20 AND ABS(D17) <= 100 THEN station_ready := TRUE;
            ELSIF current_dst = 3 THEN station_ready := TRUE;
            ELSIF current_dst = 4 AND ABS(D18) <= 20 AND ABS(D19) <= 100 AND table_state = 0 THEN station_ready := TRUE;
            END_IF;
            
            IF station_ready THEN ts := 21; END_IF;
        END_IF;
    ELSIF ts = 21 THEN
        D204 := 18000;
        IF ABS(D12 - 18000) <= 20 AND ABS(D13) <= 100 THEN ts := 22; END_IF;
    ELSIF ts = 22 THEN
        D80 := 2;
        D81 := current_dst;
        cmd_seq := cmd_seq + 1;
        D82 := cmd_seq;
        ts := 23;
    ELSIF ts = 23 THEN
        IF D96 = D82 AND D90 = 0 THEN ts := 24; END_IF;
    ELSIF ts = 24 THEN
        D204 := 0;
        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN ts := 0; END_IF;
    END_IF;
END_IF;

D201 := 1000; Y20 := TRUE;
D205 := 1000; Y21 := TRUE;
D208 := c_target; D209 := 1000; Y22 := TRUE;
D212 := d_target; D213 := 1000; Y23 := TRUE;
D217 := 1000; Y24 := TRUE;
D221 := 1000; Y25 := TRUE;
Y2 := y2_cond;

END_PROGRAM