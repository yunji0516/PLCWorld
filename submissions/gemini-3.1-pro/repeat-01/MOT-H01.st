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

    cmd_active : BOOL := FALSE;
    cmd_type : INT := 0;
    shuttle_step : INT := 0;
    target_st : DINT := 0;
    action_code : DINT := 0;
    shuttle_ready : BOOL := FALSE;
    station_ready : BOOL := FALSE;
    aligned : BOOL := FALSE;
    table_req_id : DINT := 0;
    table_served_flag : BOOL := FALSE;
    rotation_allowed : BOOL := FALSE;
END_VAR

D201 := 1000; Y20 := TRUE;
D205 := 1000; Y21 := TRUE;
D209 := 1000; Y22 := TRUE;
D213 := 1000; Y23 := TRUE;
D217 := 1000; Y24 := TRUE;
D221 := 1000; Y25 := TRUE;

IF X51 THEN
    cmd_active := FALSE;
    shuttle_step := 0;
    D200 := 0;
    D204 := 0;
    D208 := D150;
    D212 := D151;
    D216 := 0;
    D220 := 5000;

    IF (ABS(D10) <= 20) AND (ABS(D12) <= 20) AND (ABS(D18) <= 20) AND (ABS(D20 - 5000) <= 20) AND (ABS(D14 - D150) <= 20) AND (ABS(D16 - D151) <= 20) AND (D90 = 0) AND (D91 = 0) AND (D92 = 0) THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;
ELSE
    Y2 := FALSE;

    table_req_id := D91;
    table_served_flag := FALSE;
    IF table_req_id > 0 THEN
        IF table_req_id = D100 THEN table_served_flag := X30; END_IF;
        IF table_req_id = D110 THEN table_served_flag := X31; END_IF;
    END_IF;

    rotation_allowed := (D12 <= 100 OR ABS(D10 - 85000) > 10000) AND (D20 <= 50000);

    IF table_req_id > 0 AND NOT table_served_flag THEN
        IF rotation_allowed THEN
            D216 := D94;
        END_IF;
        IF X53 THEN
            D220 := D95;
        ELSE
            D220 := 5000;
        END_IF;
    ELSE
        D220 := 5000;
        IF D20 <= 50000 AND rotation_allowed THEN
            D216 := 0;
        END_IF;
    END_IF;

    IF D100 > 0 THEN
        IF X32 THEN
            D208 := D150;
            IF ABS(D14 - D150) <= 20 AND ABS(D15) <= 100 THEN
                D300 := D100;
                D301 := 1;
            END_IF;
        ELSE
            D208 := 73250;
            D300 := 0;
            D301 := 0;
        END_IF;
    ELSE
        D208 := D150;
        D300 := 0;
        D301 := 0;
    END_IF;

    IF D110 > 0 THEN
        IF X33 THEN
            D212 := D151;
            IF ABS(D16 - D151) <= 20 AND ABS(D17) <= 100 THEN
                D302 := D110;
                D303 := 1;
            END_IF;
        ELSE
            D212 := 73250;
            D302 := 0;
            D303 := 0;
        END_IF;
    ELSE
        D212 := D151;
        D302 := 0;
        D303 := 0;
    END_IF;

    IF NOT cmd_active THEN
        IF D90 > 0 THEN
            IF D90 = D100 THEN
                IF X30 THEN
                    cmd_type := 5; cmd_active := TRUE;
                ELSE
                    IF D91 = 0 THEN
                        cmd_type := 8; cmd_active := TRUE;
                    ELSIF D92 = 0 THEN
                        cmd_type := 7; cmd_active := TRUE;
                    END_IF;
                END_IF;
            ELSIF D90 = D110 THEN
                IF X31 THEN
                    cmd_type := 6; cmd_active := TRUE;
                ELSE
                    IF D91 = 0 THEN
                        cmd_type := 8; cmd_active := TRUE;
                    ELSIF D92 = 0 THEN
                        cmd_type := 7; cmd_active := TRUE;
                    END_IF;
                END_IF;
            END_IF;
        ELSE
            IF D91 > 0 AND ((D91 = D100 AND X30) OR (D91 = D110 AND X31)) THEN
                cmd_type := 4; cmd_active := TRUE;
            ELSIF D91 = 0 AND D92 > 0 THEN
                cmd_type := 3; cmd_active := TRUE;
            ELSIF D104 = 1 AND D100 > 0 AND NOT X30 THEN
                cmd_type := 1; cmd_active := TRUE;
            ELSIF D114 = 2 AND D110 > 0 AND NOT X31 THEN
                cmd_type := 2; cmd_active := TRUE;
            END_IF;
        END_IF;
    END_IF;

    IF cmd_active THEN
        CASE shuttle_step OF
        0:
            IF D12 <= 100 THEN
                IF cmd_type = 1 OR cmd_type = 5 THEN D200 := -90000; target_st := 1; END_IF;
                IF cmd_type = 2 OR cmd_type = 6 THEN D200 := -35000; target_st := 2; END_IF;
                IF cmd_type = 3 OR cmd_type = 7 THEN D200 := 15000;  target_st := 3; END_IF;
                IF cmd_type = 4 OR cmd_type = 8 THEN D200 := 85000;  target_st := 4; END_IF;

                IF cmd_type <= 4 THEN action_code := 1; ELSE action_code := 2; END_IF;
                shuttle_step := 1;
            ELSE
                D204 := 0;
            END_IF;

        1:
            shuttle_ready := (ABS(D10 - D200) <= 20) AND (ABS(D11) <= 100);
            station_ready := FALSE;
            IF target_st = 1 THEN station_ready := X54 AND (ABS(D14 - 73250) <= 20);
            ELSIF target_st = 2 THEN station_ready := X55 AND (ABS(D16 - 73250) <= 20);
            ELSIF target_st = 3 THEN station_ready := TRUE;
            ELSIF target_st = 4 THEN station_ready := X56 AND (ABS(D18) <= 20);
            END_IF;

            IF shuttle_ready AND station_ready THEN
                D204 := 18000;
                shuttle_step := 2;
            END_IF;

        2:
            IF ABS(D12 - 18000) <= 20 AND ABS(D13) <= 100 THEN
                aligned := FALSE;
                IF target_st = 1 THEN
                    aligned := (ABS(D10 - D200) <= 20) AND (ABS(D11) <= 100) AND (ABS(D14 - 73250) <= 20) AND (ABS(D15) <= 100);
                ELSIF target_st = 2 THEN
                    aligned := (ABS(D10 - D200) <= 20) AND (ABS(D11) <= 100) AND (ABS(D16 - 73250) <= 20) AND (ABS(D17) <= 100);
                ELSIF target_st = 3 THEN
                    aligned := (ABS(D10 - D200) <= 20) AND (ABS(D11) <= 100);
                ELSIF target_st = 4 THEN
                    aligned := (ABS(D10 - D200) <= 20) AND (ABS(D11) <= 100) AND (ABS(D18) <= 20) AND (ABS(D19) <= 100);
                END_IF;

                IF aligned THEN
                    D80 := action_code;
                    D81 := target_st;
                    D82 := D82 + 1;
                    shuttle_step := 3;
                END_IF;
            END_IF;

        3:
            IF D96 = D82 THEN
                D204 := 0;
                shuttle_step := 4;
            END_IF;

        4:
            IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
                cmd_active := FALSE;
                shuttle_step := 0;
            END_IF;
        END_CASE;
    ELSE
        D204 := 0;
    END_IF;
END_IF;

END_PROGRAM