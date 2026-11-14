PROGRAM Main
VAR
    (* State machine *)
    state : INT := 0;
    current_req : INT := 0;
    req_stage : INT := 0;
    ack_pending : ARRAY[0..1] OF BOOL := [FALSE, FALSE];
    req_done : ARRAY[0..1] OF BOOL := [FALSE, FALSE];
    req_cancelled : ARRAY[0..1] OF BOOL := [FALSE, FALSE];
    
    (* Timers *)
    sync_timer_50 : TON;
    sync_timer_80 : TON;
    sync_timer_100 : TON;
    move_timer : TON;
    
    (* Edge detection *)
    r0_edge : R_TRIG;
    r1_edge : R_TRIG;
    
    (* Internal targets and rates *)
    target_a : DINT := 0;
    target_b : DINT := 0;
    target_c : DINT := 0;
    target_d : DINT := 0;
    target_s3_0 : DINT := 0;
    target_s3_1 : DINT := 0;
    target_s3_2 : DINT := 0;
    target_s4_0 : DINT := 0;
    target_s4_1 : DINT := 0;
    
    (* Station positions in 0.01mm units *)
    STN_1 : DINT := -360000;
    STN_2 : DINT := -230000;
    STN_3 : DINT := 0;
    STN_4 : DINT := 360000;
    HOME_A : DINT := 0;
    
    (* Connection constants *)
    FORK_RETRACTED : DINT := 0;
    FORK_EXTENDED : DINT := 18000;
    LIFT_HOME : DINT := 15000;
    LIFT_DOCK : DINT := 73250;
    
    (* Axis limits *)
    RATE_DEFAULT : DINT := 500;
    RATE_SLOW : DINT := 100;
    
    (* Tracking variables *)
    last_r0_loc : DINT := -1;
    last_r1_loc : DINT := -1;
    shuttle_travel : DINT := 0;
    sync_established : BOOL := FALSE;
    cell3_done : BOOL := FALSE;
    cell4_done : BOOL := FALSE;
    req0_processed : BOOL := FALSE;
    req1_processed : BOOL := FALSE;
    
    (* Completion tracking *)
    completion_start : INT := 0;
    all_completed : BOOL := FALSE;
END_VAR

(* Update request edge detection *)
r0_edge(CLK := D100 > 0);
r1_edge(CLK := D120 > 0);

(* State machine control *)
CASE state OF
    0: (* Initial - home all axes *)
        IF (D1000 > 0) OR (D1004 > 0) OR (D1008 > 15000) OR (D1012 > 15000) OR 
           (D1016 > -50000) OR (D1020 > -50000) OR (D1024 > 0) OR
           (D1028 > 0) OR (D1032 > 0) THEN
            (* Move to home positions *)
            Y40 := TRUE; D2000 := HOME_A; D2001 := RATE_DEFAULT; D2002 := 0;
            Y41 := TRUE; D2004 := FORK_RETRACTED; D2005 := RATE_DEFAULT; D2006 := 0;
            Y42 := TRUE; D2008 := LIFT_HOME; D2009 := RATE_DEFAULT; D2010 := 0;
            Y43 := TRUE; D2012 := LIFT_HOME; D2013 := RATE_DEFAULT; D2014 := 0;
            Y44 := TRUE; D2016 := -50000; D2017 := RATE_DEFAULT; D2018 := 0;
            Y45 := TRUE; D2020 := -50000; D2021 := RATE_DEFAULT; D2022 := 0;
            Y46 := TRUE; D2024 := 0; D2025 := RATE_DEFAULT; D2026 := 0;
            Y47 := TRUE; D2028 := 0; D2029 := RATE_DEFAULT; D2030 := 0;
            Y48 := TRUE; D2032 := 0; D2033 := RATE_DEFAULT; D2034 := 0;
            Y30 := FALSE;
            state := 1;
        ELSE
            state := 2;
        END_IF;
        
    1: (* Wait for home arrival *)
        IF (ABS(D1000 - HOME_A) < 20) AND (ABS(D1004 - FORK_RETRACTED) < 20) AND
           (ABS(D1008 - LIFT_HOME) < 20) AND (ABS(D1012 - LIFT_HOME) < 20) AND
           (ABS(D1016 + 50000) < 20) AND (ABS(D1020 + 50000) < 20) AND
           (ABS(D1024) < 20) AND (ABS(D1028) < 20) AND (ABS(D1032) < 20) THEN
            state := 2;
        END_IF;
        
    2: (* Idle - wait for requests *)
        (* Disable axes when idle *)
        Y40 := FALSE; D2000 := 0; D2001 := 0; D2002 := 0;
        Y41 := FALSE; D2004 := 0; D2005 := 0; D2006 := 0;
        Y42 := FALSE; D2008 := 0; D2009 := 0; D2010 := 0;
        Y43 := FALSE; D2012 := 0; D2013 := 0; D2014 := 0;
        Y44 := FALSE; D2016 := 0; D2017 := 0; D2018 := 0;
        Y45 := FALSE; D2020 := 0; D2021 := 0; D2022 := 0;
        Y46 := FALSE; D2024 := 0; D2025 := 0; D2026 := 0;
        Y47 := FALSE; D2028 := 0; D2029 := 0; D2030 := 0;
        Y48 := FALSE; D2032 := 0; D2033 := 0; D2034 := 0;
        Y30 := FALSE;
        
        (* Check for new requests *)
        IF (D100 > 0) AND NOT req0_processed AND NOT req_done[0] THEN
            current_req := 0;
            req_stage := 0;
            cell3_done := FALSE;
            cell4_done := FALSE;
            sync_established := FALSE;
            req0_processed := TRUE;
            state := 10;
        ELSIF (D120 > 0) AND NOT req1_processed AND NOT req_done[1] THEN
            current_req := 1;
            req_stage := 0;
            cell3_done := FALSE;
            cell4_done := FALSE;
            sync_established := FALSE;
            req1_processed := TRUE;
            state := 10;
        END_IF;
        
    10: (* Move shuttle to lift station *)
        Y40 := TRUE;
        IF (D100 > 0 AND req0_processed) THEN
            IF D101 = 1 THEN
                D2000 := STN_1;
            ELSE
                D2000 := STN_2;
            END_IF;
        ELSE
            IF D121 = 1 THEN
                D2000 := STN_1;
            ELSE
                D2000 := STN_2;
            END_IF;
        END_IF;
        D2001 := RATE_DEFAULT; D2002 := 0;
        
        IF (ABS(D1000 - D2000) < 20) AND (ABS(D1001) < 10) THEN
            state := 11;
        END_IF;
        
    11: (* Connect fork at lift *)
        Y41 := TRUE;
        D2004 := FORK_EXTENDED; D2005 := RATE_DEFAULT; D2006 := 0;
        
        IF (ABS(D1004 - FORK_EXTENDED) < 20) AND (ABS(D1005) < 10) THEN
            state := 12;
        END_IF;
        
    12: (* Lower/raise lift to dock height *)
        IF current_req = 0 THEN
            Y42 := TRUE;
            D2008 := LIFT_DOCK; D2009 := RATE_DEFAULT; D2010 := 0;
            IF (ABS(D1008 - LIFT_DOCK) < 20) AND (ABS(D1009) < 10) THEN
                state := 13;
            END_IF;
        ELSE
            Y43 := TRUE;
            D2012 := LIFT_DOCK; D2013 := RATE_DEFAULT; D2014 := 0;
            IF (ABS(D1012 - LIFT_DOCK) < 20) AND (ABS(D1013) < 10) THEN
                state := 13;
            END_IF;
        END_IF;
        
    13: (* Wait for port ready signal *)
        (* Brake for connection *)
        Y30 := TRUE;
        
        IF X61 OR X62 THEN
            Y30 := FALSE;
            state := 14;
        END_IF;
        
    14: (* Move shuttle to cell 3 *)
        Y40 := TRUE;
        D2000 := STN_3; D2001 := RATE_DEFAULT; D2002 := 0;
        
        IF (ABS(D1000 - STN_3) < 20) AND (ABS(D1001) < 10) THEN
            state := 15;
        END_IF;
        
    15: (* Cell 3 - flying synchronization *)
        Y44 := TRUE; Y45 := TRUE; Y46 := TRUE;
        
        (* Configure cell 3 *)
        Y70 := TRUE; Y71 := TRUE;
        D700 := 1; D701 := 0; D702 := 6000;
        
        IF D101 > 1 THEN
            D2016 := D500; D2017 := 500; D2018 := 0;
            D2020 := D501; D2021 := 500; D2022 := 0;
            D2024 := D502; D2025 := 500; D2026 := 0;
        END_IF;
        
        IF X72 OR X70 THEN
            cell3_done := TRUE;
            state := 16;
        END_IF;
        
    16: (* Move shuttle to cell 4 *)
        Y40 := TRUE;
        D2000 := STN_4; D2001 := RATE_DEFAULT; D2002 := 0;
        
        IF (ABS(D1000 - STN_4) < 20) AND (ABS(D1001) < 10) THEN
            state := 17;
        END_IF;
        
    17: (* Cell 4 - gear synchronization *)
        Y47 := TRUE; Y48 := TRUE;
        
        (* Configure cell 4 *)
        Y75 := TRUE; Y76 := TRUE;
        D710 := 1; D711 := 0; D712 := 7200;
        
        IF D101 > 1 THEN
            D2028 := D600; D2029 := 700; D2030 := 0;
            D2032 := D601; D2033 := 700; D2034 := 0;
        END_IF;
        
        IF X77 OR X75 THEN
            cell4_done := TRUE;
            state := 18;
        END_IF;
        
    18: (* Return shuttle to lift station *)
        Y40 := TRUE;
        IF current_req = 0 THEN
            IF D101 = 1 THEN
                D2000 := STN_1;
            ELSE
                D2000 := STN_2;
            END_IF;
        ELSE
            IF D121 = 1 THEN
                D2000 := STN_1;
            ELSE
                D2000 := STN_2;
            END_IF;
        END_IF;
        D2001 := RATE_DEFAULT; D2002 := 0;
        
        IF (ABS(D1000 - D2000) < 20) AND (ABS(D1001) < 10) THEN
            state := 19;
        END_IF;
        
    19: (* Raise/return lift to home *)
        Y30 := TRUE;
        IF current_req = 0 THEN
            D2008 := LIFT_HOME; D2009 := RATE_DEFAULT; D2010 := 0;
            IF (ABS(D1008 - LIFT_HOME) < 20) AND (ABS(D1009) < 10) THEN
                state := 20;
            END_IF;
        ELSE
            D2012 := LIFT_HOME; D2013 := RATE_DEFAULT; D2014 := 0;
            IF (ABS(D1012 - LIFT_HOME) < 20) AND (ABS(D1013) < 10) THEN
                state := 20;
            END_IF;
        END_IF;
        
    20: (* Disconnect fork *)
        Y41 := TRUE;
        D2004 := FORK_RETRACTED; D2005 := RATE_DEFAULT; D2006 := 0;
        
        IF (ABS(D1004 - FORK_RETRACTED) < 20) AND (ABS(D1005) < 10) THEN
            Y30 := FALSE;
            state := 21;
        END_IF;
        
    21: (* Acknowledge completion *)
        IF current_req = 0 THEN
            D300 := D100;
            D301 := 1;
            req_done[0] := TRUE;
        ELSE
            D302 := D120;
            D303 := 1;
            req_done[1] := TRUE;
        END_IF;
        
        D80 := 0; D81 := 0; D82 := 0;
        
        state := 2;
        
    100: (* Handle cancellation *)
        (* Retract fork and return to home *)
        Y40 := TRUE; D2000 := HOME_A; D2001 := RATE_DEFAULT; D2002 := 0;
        Y41 := TRUE; D2004 := FORK_RETRACTED; D2005 := RATE_DEFAULT; D2006 := 0;
        
        IF (ABS(D1000 - HOME_A) < 20) AND (ABS(D1004 - FORK_RETRACTED) < 20) THEN
            IF current_req = 0 THEN
                D300 := D100;
                D301 := 2;
                req_done[0] := TRUE;
            ELSE
                D302 := D120;
                D303 := 2;
                req_done[1] := TRUE;
            END_IF;
            state := 2;
        END_IF;
END_CASE;

(* Check for cancellation *)
IF (current_req = 0 AND X31) OR (current_req = 1 AND X35) THEN
    state := 100;
END_IF;

(* Completion detection *)
IF req_done[0] AND req_done[1] THEN
    all_completed := TRUE;
END_IF;

IF all_completed THEN
    (* Check completion conditions *)
    IF (ABS(D1000) < 20) AND (ABS(D1004) < 20) AND
       (ABS(D1008 - LIFT_HOME) < 20) AND (ABS(D1012 - LIFT_HOME) < 20) AND
       (ABS(D1016 + 50000) < 20) AND (ABS(D1020 + 50000) < 20) AND
       (ABS(D1024) < 20) AND (ABS(D1028) < 20) AND (ABS(D1032) < 20) THEN
        
        sync_timer_100(IN := TRUE, PT := T#100ms);
        IF sync_timer_100.Q THEN
            Y2 := TRUE;
        END_IF;
    ELSE
        sync_timer_100(IN := FALSE);
        Y2 := FALSE;
    END_IF;
ELSE
    Y2 := FALSE;
END_IF;

(* Reset timers when not in completion *)
IF NOT all_completed THEN
    sync_timer_100(IN := FALSE);
END_IF;

END_PROGRAM