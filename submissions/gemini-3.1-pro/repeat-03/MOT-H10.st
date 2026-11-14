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
    D602 : DINT;
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

    first_scan : BOOL := TRUE;
    timer : TON;
    r0_id_mem : DINT := 0;
    r1_id_mem : DINT := 0;
    
    req_id : ARRAY[0..1] OF DINT;
    req_loc : ARRAY[0..1] OF DINT;
    req_step : ARRAY[0..1] OF DINT;
    req_cancelled : ARRAY[0..1] OF BOOL;
    
    shuttle_state : DINT := 0;
    shuttle_task : DINT := 0;
    shuttle_req : INT := 0;
    
    cell3_occupied : BOOL := FALSE;
    cell4_occupied : BOOL := FALSE;
    cell3_req : INT := 0;
    cell4_req : INT := 0;
    
    port_x : DINT;
    port_ready : BOOL;
    target_station : DINT;
    expected_hold : DINT;
    
    best_task : DINT;
    target_req : INT;
    i : INT;
    
    need_dock_1 : BOOL;
    need_dock_2 : BOOL;
    
    pos_err : REAL;
    vel : REAL;
    sway : REAL;
    sway_vel : REAL;
    vel_cmd : REAL;
    accel_real : REAL;
    s4_1_target_internal : DINT;
END_VAR

IF first_scan THEN
    D2000 := D1000;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := 0;
    D2020 := 0;
    D2024 := 100000;
    D2028 := 0;
    s4_1_target_internal := 0;
    first_scan := FALSE;
END_IF;

Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE;
Y48 := FALSE;

D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
D2017 := 1000; D2021 := 1000; D2025 := 1000; D2029 := 1000;
D2033 := 1000; 

D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0;
D2034 := 0;
D2032 := 0; 
D702 := 1000; 

IF D100 <> 0 AND r0_id_mem <> D100 THEN
    r0_id_mem := D100;
    req_id[0] := D100;
    req_loc[0] := D101;
    req_step[0] := 1;
    req_cancelled[0] := FALSE;
END_IF;
IF D120 <> 0 AND r1_id_mem <> D120 THEN
    r1_id_mem := D120;
    req_id[1] := D120;
    req_loc[1] := D121;
    req_step[1] := 1;
    req_cancelled[1] := FALSE;
END_IF;

IF X31 THEN req_cancelled[0] := TRUE; END_IF;
IF X35 THEN req_cancelled[1] := TRUE; END_IF;

FOR i := 0 TO 1 DO
    IF req_cancelled[i] THEN
        IF req_step[i] = 1 THEN req_step[i] := 9;
        ELSIF req_step[i] = 2 AND D90 = req_id[i] AND shuttle_state = 0 THEN req_step[i] := 8;
        ELSIF req_step[i] = 3 THEN req_step[i] := 4; 
        ELSIF req_step[i] = 5 AND D90 = req_id[i] AND shuttle_state = 0 THEN req_step[i] := 8;
        ELSIF req_step[i] = 6 THEN req_step[i] := 7; 
        END_IF;
    END_IF;
END_FOR;

IF req_step[0] = 9 THEN
    IF (req_loc[0] = 1 AND ABS(D1008 - 15000) <= 20) OR (req_loc[0] = 2 AND ABS(D1012 - 15000) <= 20) THEN
        D300 := req_id[0];
        IF req_cancelled[0] THEN D301 := 2; ELSE D301 := 1; END_IF;
    END_IF;
END_IF;
IF X30 OR D100 = 0 THEN 
    req_step[0] := 0; 
    IF D100 = 0 THEN D300 := 0; D301 := 0; r0_id_mem := 0; END_IF;
END_IF;

IF req_step[1] = 9 THEN
    IF (req_loc[1] = 1 AND ABS(D1008 - 15000) <= 20) OR (req_loc[1] = 2 AND ABS(D1012 - 15000) <= 20) THEN
        D302 := req_id[1];
        IF req_cancelled[1] THEN D303 := 2; ELSE D303 := 1; END_IF;
    END_IF;
END_IF;
IF X34 OR D120 = 0 THEN 
    req_step[1] := 0;
    IF D120 = 0 THEN D302 := 0; D303 := 0; r1_id_mem := 0; END_IF;
END_IF;


IF shuttle_state = 0 THEN
    best_task := 0; target_req := -1;

    IF D90 <> 0 THEN
        FOR i := 0 TO 1 DO
            IF req_id[i] = D90 THEN
                IF req_step[i] = 2 AND NOT cell3_occupied THEN best_task := 2; target_req := i;
                ELSIF req_step[i] = 5 AND NOT cell4_occupied THEN best_task := 5; target_req := i;
                ELSIF req_step[i] = 8 THEN best_task := 8; target_req := i;
                END_IF;
            END_IF;
        END_FOR;
    ELSE
        FOR i := 0 TO 1 DO
            IF req_step[i] = 7 THEN best_task := 7; target_req := i; END_IF;
        END_FOR;
        IF best_task = 0 THEN
            FOR i := 0 TO 1 DO
                IF req_step[i] = 4 THEN
                    IF req_cancelled[i] OR NOT cell4_occupied THEN
                        best_task := 4; target_req := i;
                    END_IF;
                END_IF;
            END_FOR;
        END_IF;
        IF best_task = 0 THEN
            FOR i := 0 TO 1 DO
                IF req_step[i] = 1 THEN
                    IF NOT cell3_occupied THEN
                        best_task := 1; target_req := i;
                    END_IF;
                END_IF;
            END_FOR;
        END_IF;
    END_IF;

    IF best_task <> 0 THEN
        shuttle_task := best_task;
        shuttle_req := target_req;
        shuttle_state := 1;
    END_IF;
END_IF;

IF shuttle_state > 0 THEN
    IF shuttle_task = 1 OR shuttle_task = 8 THEN target_station := req_loc[shuttle_req];
    ELSIF shuttle_task = 2 OR shuttle_task = 4 THEN target_station := 3;
    ELSIF shuttle_task = 5 OR shuttle_task = 7 THEN target_station := 4;
    END_IF;
    
    IF target_station = 1 THEN port_x := D403; port_ready := X61;
    ELSIF target_station = 2 THEN port_x := D406; port_ready := X62;
    ELSIF target_station = 3 THEN port_x := D409; port_ready := X63;
    ELSIF target_station = 4 THEN port_x := D412; port_ready := X64;
    END_IF;
END_IF;

CASE shuttle_state OF
1: 
    D2000 := port_x;
    D2004 := 0;
    IF ABS(D1000 - port_x) <= 20 AND ABS(D1001) <= 100 AND port_ready THEN
        shuttle_state := 2;
    END_IF;

2: 
    D2004 := 18000;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
        shuttle_state := 3;
        D81 := target_station;
        IF shuttle_task = 1 OR shuttle_task = 4 OR shuttle_task = 7 THEN
            D80 := 1; 
        ELSE
            D80 := 2; 
        END_IF;
        D82 := D82 + 1; 
    END_IF;

3: 
    IF D80 = 1 THEN expected_hold := req_id[shuttle_req]; ELSE expected_hold := 0; END_IF;
    IF D90 = expected_hold THEN
        shuttle_state := 4;
    END_IF;

4: 
    D2004 := 0;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        IF shuttle_task = 1 THEN 
            IF req_cancelled[shuttle_req] THEN req_step[shuttle_req] := 8; ELSE req_step[shuttle_req] := 2; END_IF;
        ELSIF shuttle_task = 2 THEN 
            cell3_occupied := TRUE; cell3_req := shuttle_req;
            IF req_cancelled[shuttle_req] THEN req_step[shuttle_req] := 4; ELSE req_step[shuttle_req] := 3; END_IF;
        ELSIF shuttle_task = 4 THEN 
            cell3_occupied := FALSE;
            IF req_cancelled[shuttle_req] THEN req_step[shuttle_req] := 8; ELSE req_step[shuttle_req] := 5; END_IF;
        ELSIF shuttle_task = 5 THEN 
            cell4_occupied := TRUE; cell4_req := shuttle_req;
            IF req_cancelled[shuttle_req] THEN req_step[shuttle_req] := 7; ELSE req_step[shuttle_req] := 6; END_IF;
        ELSIF shuttle_task = 7 THEN 
            cell4_occupied := FALSE;
            req_step[shuttle_req] := 8;
        ELSIF shuttle_task = 8 THEN 
            req_step[shuttle_req] := 9; 
        END_IF;
        shuttle_state := 0;
    END_IF;
END_CASE;


need_dock_1 := FALSE;
need_dock_2 := FALSE;
FOR i := 0 TO 1 DO
    IF req_loc[i] = 1 AND (req_step[i] = 1 OR req_step[i] = 8) THEN need_dock_1 := TRUE; END_IF;
    IF req_loc[i] = 2 AND (req_step[i] = 1 OR req_step[i] = 8) THEN need_dock_2 := TRUE; END_IF;
END_FOR;

IF need_dock_1 THEN D2008 := D92; ELSE D2008 := 15000; END_IF;
IF need_dock_2 THEN D2012 := D92; ELSE D2012 := 15000; END_IF;


IF ABS(D1009) <= 100 AND ABS(D1013) <= 100 AND ABS(D1008 - D2008) <= 20 AND ABS(D1012 - D2012) <= 20 THEN
    Y30 := TRUE; 
ELSE
    Y30 := FALSE; 
END_IF;


IF cell3_occupied AND req_step[cell3_req] = 3 AND NOT req_cancelled[cell3_req] THEN
    D700 := req_id[cell3_req];
    Y70 := TRUE; Y71 := TRUE; D701 := D526;
    D2016 := D500;
    IF D501 <> 0 THEN 
        D2020 := D501; 
    ELSE 
        D2020 := DINT(-45000.0 * SIN(REAL(D1016) * 0.000174532925));
    END_IF;
    IF X70 THEN req_step[cell3_req] := 4; END_IF;
ELSE
    Y70 := FALSE; Y71 := FALSE;
    D2016 := 0;
    D2020 := 0;
END_IF;


IF cell4_occupied AND req_step[cell4_req] = 6 AND NOT req_cancelled[cell4_req] THEN
    D710 := req_id[cell4_req];
    Y75 := TRUE; Y76 := TRUE; D711 := D626;
    D2024 := D600;
    s4_1_target_internal := D601;
    D2028 := D601;
    IF X75 THEN req_step[cell4_req] := 7; END_IF;
ELSE
    Y75 := FALSE; Y76 := FALSE;
    D2024 := 100000;
    s4_1_target_internal := 0;
    D2028 := 0;
END_IF;

pos_err := REAL(s4_1_target_internal - D1028);
vel := REAL(D1029);
sway := REAL(D1032);
sway_vel := REAL(D1033);

vel_cmd := MAX(MIN(pos_err * 1.0, 50000.0), -50000.0);
accel_real := (vel_cmd - vel) * 2.0 + sway * 200.0 + sway_vel * 50.0;
accel_real := MAX(MIN(accel_real, 500000.0), -500000.0);
D712 := DINT(accel_real);


IF X51 AND req_step[0] = 0 AND req_step[1] = 0 AND D100 = 0 AND D120 = 0 THEN
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := 0;
    D2020 := 0;
    D2024 := 100000;
    s4_1_target_internal := 0;
    D2028 := 0;
    
    pos_err := REAL(0 - D1028);
    vel := REAL(D1029);
    sway := REAL(D1032);
    sway_vel := REAL(D1033);
    
    vel_cmd := MAX(MIN(pos_err * 1.0, 50000.0), -50000.0);
    accel_real := (vel_cmd - vel) * 2.0 + sway * 200.0 + sway_vel * 50.0;
    accel_real := MAX(MIN(accel_real, 500000.0), -500000.0);
    D712 := DINT(accel_real);

    IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20 
       AND ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024 - 100000) <= 20 AND ABS(D1028) <= 20 
       AND ABS(D1032) <= 3 AND ABS(D1033) <= 15 THEN
        timer(IN := TRUE, PT := T#100ms);
        IF timer.Q THEN
            Y2 := TRUE;
        END_IF;
    ELSE
        timer(IN := FALSE, PT := T#100ms);
        Y2 := FALSE;
    END_IF;
ELSE
    timer(IN := FALSE, PT := T#100ms);
    Y2 := FALSE;
END_IF;

END_PROGRAM