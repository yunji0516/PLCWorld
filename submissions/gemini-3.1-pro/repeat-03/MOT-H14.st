```iecst
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

    MS_State : INT := 0;
    active_req : INT := -1;
    req_id : DINT := 0;
    start_loc : DINT := 0;
    is_cancelled : BOOL := FALSE;
    state_timer : INT := 0;

    a_cmd : DINT := 0;
    b_cmd : DINT := 0;
    c_cmd : DINT := 15000;
    d_cmd : DINT := 15000;
    s3_0_cmd : DINT := -60000;
    s3_1_cmd : DINT := -60000;
    s4_0_cmd : DINT := -60000;
    s4_1_cmd : DINT := -60000;

    couple_seq_cmd : DINT := 0;
    action_cmd : DINT := 0;
    station_cmd : DINT := 0;
END_VAR

IF active_req = 0 THEN
    is_cancelled := X31;
ELSIF active_req = 1 THEN
    is_cancelled := X35;
ELSE
    is_cancelled := FALSE;
END_IF

IF X51 AND MS_State = 0 THEN
    a_cmd := 0; b_cmd := 0; c_cmd := 15000; d_cmd := 15000;
    s3_0_cmd := -60000; s3_1_cmd := -60000;
    s4_0_cmd := -60000; s4_1_cmd := -60000;
    
    IF ABS(D1000 - 0) <= 20 AND ABS(D1004 - 0) <= 20 AND
       ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20 AND
       ABS(D1016 - (-60000)) <= 20 AND ABS(D1020 - (-60000)) <= 20 AND
       ABS(D1024 - (-60000)) <= 20 AND ABS(D1028 - (-60000)) <= 20 THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF
ELSE
    Y2 := FALSE;
END_IF

CASE MS_State OF
    0:
        IF D100 <> 0 AND D100 <> D300 THEN
            active_req := 0; req_id := D100; start_loc := D101; MS_State := 10;
        ELSIF D120 <> 0 AND D120 <> D302 THEN
            active_req := 1; req_id := D120; start_loc := D121; MS_State := 10;
        END_IF

    10:
        IF start_loc = 1 THEN c_cmd := 73250; ELSE d_cmd := 73250; END_IF
        IF (start_loc = 1 AND ABS(D1008 - 73250) <= 20 AND ABS(D1009) <= 100) OR
           (start_loc = 2 AND ABS(D1012 - 73250) <= 20 AND ABS(D1013) <= 100) THEN
            MS_State := 20;
        END_IF

    20:
        IF start_loc = 1 THEN a_cmd := -360000; ELSE a_cmd := -230000; END_IF
        IF ABS(D1000 - a_cmd) <= 20 AND ABS(D1001) <= 100 THEN
            IF (start_loc = 1 AND X61) OR (start_loc = 2 AND X62) THEN
                MS_State := 21;
            END_IF
        END_IF

    21:
        b_cmd := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            action_cmd := 1; station_cmd := start_loc; 
            couple_seq_cmd := couple_seq_cmd + 1;
            MS_State := 22;
        END_IF

    22:
        IF D90 = req_id THEN
            MS_State := 23;
        END_IF

    23:
        b_cmd := 0;
        IF ABS(D1004 - 0) <= 20 AND ABS(D1005) <= 100 THEN
            MS_State := 30;
        END_IF

    30:
        IF is_cancelled THEN MS_State := 90; ELSE MS_State := 31; END_IF

    31:
        a_cmd := 0;
        IF ABS(D1000 - 0) <= 20 AND ABS(D1001) <= 100 AND X63 THEN
            MS_State := 32;
        END_IF

    32:
        b_cmd := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            action_cmd := 2; station_cmd := 3;
            couple_seq_cmd := couple_seq_cmd + 1;
            MS_State := 33;
        END_IF

    33:
        IF D90 = 0 THEN
            MS_State := 34;
        END_IF

    34:
        b_cmd := 0;
        IF ABS(D1004 - 0) <= 20 AND ABS(D1005) <= 100 THEN
            MS_State := 40;
        END_IF

    40:
        IF ABS(D1017) <= 100 AND ABS(D1021) <= 100 THEN
            Y70 := TRUE;
            state_timer := state_timer + 1;
            IF state_timer > 2 THEN
                MS_State := 41;
                state_timer := 0;
            END_IF
        END_IF

    41:
        Y70 := FALSE;
        MS_State := 42;

    42:
        s3_0_cmd := D500;
        s3_1_cmd := D501;
        MS_State := 43;

    43:
        IF X70 OR is_cancelled THEN
            MS_State := 44;
        END_IF

    44:
        s3_0_cmd := -60000;
        s3_1_cmd := -60000;
        IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 AND X63 THEN
            MS_State := 50;
        END_IF

    50:
        a_cmd := 0;
        IF ABS(D1000 - 0) <= 20 AND ABS(D1001) <= 100 AND X63 THEN
            MS_State := 51;
        END_IF

    51:
        b_cmd := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            action_cmd := 1; station_cmd := 3;
            couple_seq_cmd := couple_seq_cmd + 1;
            MS_State := 52;
        END_IF

    52:
        IF D90 = req_id THEN
            MS_State := 53;
        END_IF

    53:
        b_cmd := 0;
        IF ABS(D1004 - 0) <= 20 AND ABS(D1005) <= 100 THEN
            MS_State := 60;
        END_IF

    60:
        IF is_cancelled THEN MS_State := 90; ELSE MS_State := 61; END_IF

    61:
        a_cmd := 360000;
        IF ABS(D1000 - 360000) <= 20 AND ABS(D1001) <= 100 AND X64 THEN
            MS_State := 62;
        END_IF

    62:
        b_cmd := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            action_cmd := 2; station_cmd := 4;
            couple_seq_cmd := couple_seq_cmd + 1;
            MS_State := 63;
        END_IF

    63:
        IF D90 = 0 THEN
            MS_State := 64;
        END_IF

    64:
        b_cmd := 0;
        IF ABS(D1004 - 0) <= 20 AND ABS(D1005) <= 100 THEN
            MS_State := 70;
        END_IF

    70:
        s4_0_cmd := D600;
        s4_1_cmd := D601;
        MS_State := 71;

    71:
        IF (D622 = req_id AND D624 = D91) THEN
            s4_0_cmd := D623 + 25000;
            s4_1_cmd := D623 + 25000;
            MS_State := 72;
        ELSIF is_cancelled THEN
            MS_State := 73;
        END_IF

    72:
        IF X75 OR is_cancelled THEN
            MS_State := 73;
        END_IF

    73:
        s4_0_cmd := -60000;
        s4_1_cmd := -60000;
        IF ABS(D1024 - (-60000)) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028 - (-60000)) <= 20 AND ABS(D1029) <= 100 AND X64 THEN
            MS_State := 80;
        END_IF

    80:
        a_cmd := 360000;
        IF ABS(D1000 - 360000) <= 20 AND ABS(D1001) <= 100 AND X64 THEN
            MS_State := 81;
        END_IF

    81:
        b_cmd := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            action_cmd := 1; station_cmd := 4;
            couple_seq_cmd := couple_seq_cmd + 1;
            MS_State := 82;
        END_IF

    82:
        IF D90 = req_id THEN
            MS_State := 83;
        END_IF

    83:
        b_cmd := 0;
        IF ABS(D1004 - 0) <= 20 AND ABS(D1005) <= 100 THEN
            MS_State := 90;
        END_IF

    90:
        IF start_loc = 1 THEN a_cmd := -360000; ELSE a_cmd := -230000; END_IF
        IF ABS(D1000 - a_cmd) <= 20 AND ABS(D1001) <= 100 THEN
            IF (start_loc = 1 AND X61) OR (start_loc = 2 AND X62) THEN
                MS_State := 91;
            END_IF
        END_IF

    91:
        b_cmd := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            action_cmd := 2; station_cmd := start_loc;
            couple_seq_cmd := couple_seq_cmd + 1;
            MS_State := 92;
        END_IF

    92:
        IF D90 = 0 THEN
            MS_State := 93;
        END_IF

    93:
        b_cmd := 0;
        IF ABS(D1004 - 0) <= 20 AND ABS(D1005) <= 100 THEN
            MS_State := 94;
        END_IF

    94:
        IF start_loc = 1 THEN c_cmd := 15000; ELSE d_cmd := 15000; END_IF
        IF (start_loc = 1 AND ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100) OR
           (start_loc = 2 AND ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100) THEN
            MS_State := 95;
        END_IF

    95:
        IF active_req = 0 THEN
            D300 := req_id;
            IF is_cancelled THEN D301 := 2; ELSE D301 := 1; END_IF
        ELSE
            D302 := req_id;
            IF is_cancelled THEN D303 := 2; ELSE D303 := 1; END_IF
        END_IF
        MS_State := 0;
        active_req := -1;

END_CASE;

a_cmd := LIMIT(-450000, a_cmd, 450000);
b_cmd := LIMIT(0, b_cmd, 18000);
c_cmd := LIMIT(0, c_cmd, 120000);
d_cmd := LIMIT(0, d_cmd, 120000);
s3_0_cmd := LIMIT(-95000, s3_0_cmd, 95000);
s3_1_cmd := LIMIT(-180000, s3_1_cmd, 180000);
s4_0_cmd := LIMIT(-95000, s4_0_cmd, 95000);
s4_1_cmd := LIMIT(-95000, s4_1_cmd, 95000);

D2000 := a_cmd;
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2004 := b_cmd;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

D2008 := c_cmd;
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

D2012 := d_cmd;
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2016 := s3_0_cmd;
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;

D2020 := s3_1_cmd;
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2024 := s4_0_cmd;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2028 := s4_1_cmd;
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

D80 := action_cmd;
D81 := station_cmd;
D82 := couple_seq_cmd;
D700 := req_id;
D710 := req_id;
Y30 := FALSE;
Y71 := FALSE;
Y75 := FALSE;
Y76 := FALSE;

END_PROGRAM
```