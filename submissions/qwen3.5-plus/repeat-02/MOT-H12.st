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
    state : INT := 0;
    current_req : INT := -1;
    target_port : DINT := 0;
    lift_axis_A : BOOL := TRUE;
    is_cancelled : BOOL := FALSE;
    ack_sent : BOOL := FALSE;
    seq_cnt : DINT := 0;
    y2_active : BOOL := FALSE;
    y2_timer : TON;
END_VAR

BEGIN
    D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
    D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0; D2034 := 0;
    
    Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
    Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
    
    D80 := 0; D81 := 0;
    Y30 := TRUE;
    
    IF NOT X30 AND state = 0 THEN
        current_req := 0;
    ELSIF NOT X34 AND state = 0 THEN
        current_req := 1;
    ELSIF state = 0 THEN
        current_req := -1;
    END_IF;

    IF current_req >= 0 THEN
        is_cancelled := (current_req = 0 AND X31) OR (current_req = 1 AND X35);
        IF current_req = 0 THEN
            target_port := D403;
            lift_axis_A := TRUE;
        ELSE
            target_port := D406;
            lift_axis_A := FALSE;
        END_IF;
    END_IF;

    CASE state OF
    0: (* IDLE *)
        D2000 := 0; D2001 := 300; Y40 := TRUE;
        D2004 := 0; D2005 := 300; Y41 := TRUE;
        D2008 := 15000; D2009 := 300; Y42 := TRUE;
        D2012 := 15000; D2013 := 300; Y43 := TRUE;
        D2016 := -85000; D2017 := 300; Y44 := TRUE;
        D2020 := -85000; D2021 := 300; Y45 := TRUE;
        D2024 := -65000; D2025 := 300; Y46 := TRUE;
        D2028 := 65000; D2029 := 300; Y47 := TRUE;
        D2032 := 0; D2033 := 300; Y48 := TRUE;

        IF current_req >= 0 THEN
            state := 10;
            ack_sent := FALSE;
            seq_cnt := seq_cnt + 1;
            D82 := seq_cnt;
        END_IF;

    10: (* MOVE SHUTTLE TO LIFT *)
        D2000 := target_port; D2001 := 600; Y40 := TRUE;
        D2004 := 0; D2005 := 0; Y41 := TRUE;
        D2008 := 15000; D2009 := 0; Y42 := TRUE;
        D2012 := 15000; D2013 := 0; Y43 := TRUE;
        D2016 := -85000; D2017 := 0; Y44 := TRUE;
        D2020 := -85000; D2021 := 0; Y45 := TRUE;
        D2024 := -65000; D2025 := 0; Y46 := TRUE;
        D2028 := 65000; D2029 := 0; Y47 := TRUE;
        D2032 := 0; D2033 := 0; Y48 := TRUE;
        Y30 := FALSE;

        IF ABS(D1000 - target_port) < 100 AND ABS(D1001) <= 200 THEN
            state := 20;
        END_IF;

    20: (* LIFT PREPARE & FORK EXTEND *)
        D2000 := target_port; D2001 := 0; Y40 := TRUE;
        Y30 := TRUE;
        D2004 := 18000; D2005 := 400; Y41 := TRUE;
        IF lift_axis_A THEN
            D2008 := D92; D2009 := 500; Y42 := TRUE;
            D2012 := D1012; D2013 := 0; Y43 := FALSE;
            D81 := 1;
        ELSE
            D2012 := D92; D2013 := 500; Y43 := TRUE;
            D2008 := D1008; D2009 := 0; Y42 := FALSE;
            D81 := 2;
        END_IF;
        D2016 := -85000; D2017 := 0; Y44 := TRUE;
        D2020 := -85000; D2021 := 0; Y45 := TRUE;
        D2024 := -65000; D2025 := 0; Y46 := TRUE;
        D2028 := 65000; D2029 := 0; Y47 := TRUE;
        D2032 := 0; D2033 := 0; Y48 := TRUE;
        D80 := 2;

        IF (lift_axis_A AND ABS(D1008 - D92) < 500 AND ABS(D1009) <= 200) OR
           (NOT lift_axis_A AND ABS(D1012 - D92) < 500 AND ABS(D1013) <= 200) THEN
            IF ABS(D1004 - 18000) < 2000 THEN
                IF (lift_axis_A AND X61) OR (NOT lift_axis_A AND X62) THEN
                    state := 30;
                END_IF;
            END_IF;
        END_IF;

    30: (* MOVE TO CELL 3 *)
        D2000 := D409; D2001 := 600; Y40 := TRUE;
        D2004 := 18000; D2005 := 0; Y41 := TRUE;
        D2008 := D1008; D2009 := 0; Y42 := TRUE;
        D2012 := D1012; D2013 := 0; Y43 := TRUE;
        D2016 := -85000; D2017 := 0; Y44 := TRUE;
        D2020 := -85000; D2021 := 0; Y45 := TRUE;
        D2024 := -65000; D2025 := 0; Y46 := TRUE;
        D2028 := 65000; D2029 := 0; Y47 := TRUE;
        D2032 := 0; D2033 := 0; Y48 := TRUE;
        Y30 := FALSE;

        IF ABS(D1000 - D409) < 100 AND ABS(D1001) <= 200 THEN
            state := 40;
        END_IF;

    40: (* CELL 3 PROCESS *)
        D2000 := D409; D2001 := 0; Y40 := TRUE;
        Y30 := TRUE;
        D2004 := 18000; D2005 := 0; Y41 := TRUE;
        D2008 := D1008; D2009 := 0; Y42 := TRUE;
        D2012 := D1012; D2013 := 0; Y43 := TRUE;
        D2016 := D500; D2017 := 500; Y44 := TRUE;
        D2020 := D501; D2021 := 500; Y45 := TRUE;
        Y70 := TRUE; Y71 := TRUE; D700 := 1; D701 := 1; D702 := 600;
        D2024 := -65000; D2025 := 0; Y46 := TRUE;
        D2028 := 65000; D2029 := 0; Y47 := TRUE;
        D2032 := 0; D2033 := 0; Y48 := TRUE;
        D80 := 0; D81 := 3;

        IF X70 THEN state := 50; END_IF;

    50: (* MOVE TO CELL 4 *)
        D2000 := D412; D2001 := 600; Y40 := TRUE;
        D2004 := 18000; D2005 := 0; Y41 := TRUE;
        D2008 := D1008; D2009 := 0; Y42 := TRUE;
        D2012 := D1012; D2013 := 0; Y43 := TRUE;
        D2016 := -85000; D2017 := 0; Y44 := TRUE;
        D2020 := -85000; D2021 := 0; Y45 := TRUE;
        Y70 := FALSE; Y71 := FALSE;
        D2024 := -65000; D2025 := 0; Y46 := TRUE;
        D2028 := 65000; D2029 := 0; Y47 := TRUE;
        D2032 := 0; D2033 := 0; Y48 := TRUE;
        Y30 := FALSE;

        IF ABS(D1000 - D412) < 100 AND ABS(D1001) <= 200 THEN state := 60; END_IF;

    60: (* CELL 4 PROCESS *)
        D2000 := D412; D2001 := 0; Y40 := TRUE;
        Y30 := TRUE;
        D2004 := 18000; D2005 := 0; Y41 := TRUE;
        D2008 := D1008; D2009 := 0; Y42 := TRUE;
        D2012 := D1012; D2013 := 0; Y43 := TRUE;
        D2016 := -85000; D2017 := 0; Y44 := TRUE;
        D2020 := -85000; D2021 := 0; Y45 := TRUE;
        D2024 := D600; D2025 := 500; Y46 := TRUE;
        D2028 := D601; D2029 := 500; Y47 := TRUE;
        D2032 := D602; D2033 := 500; Y48 := TRUE;
        Y75 := TRUE; Y76 := TRUE; D710 := 1; D711 := 1; D712 := 600;
        D80 := 0; D81 := 4;

        IF X75 THEN state := 70; END_IF;

    70: (* RETURN TO LIFT *)
        D2000 := target_port; D2001 := 600; Y40 := TRUE;
        D2004 := 18000; D2005 := 0; Y41 := TRUE;
        D2008 := D1008; D2009 := 0; Y42 := TRUE;
        D2012 := D1012; D2013 := 0; Y43 := TRUE;
        D2016 := -85000; D2017 := 0; Y44 := TRUE;
        D2020 := -85000; D2021 := 0; Y45 := TRUE;
        Y70 := FALSE; Y71 := FALSE;
        D2024 := -65000; D2025 := 0; Y46 := TRUE;
        D2028 := 65000; D2029 := 0; Y47 := TRUE;
        D2032 := 0; D2033 := 0; Y48 := TRUE;
        Y75 := FALSE; Y76 := FALSE;
        Y30 := FALSE;

        IF ABS(D1000 - target_port) < 100 AND ABS(D1001) <= 200 THEN state := 80; END_IF;

    80: (* LIFT RETURN & FORK RETRACT *)
        D2000 := target_port; D2001 := 0; Y40 := TRUE;
        Y30 := TRUE;
        D2004 := 0; D2005 := 400; Y41 := TRUE;
        IF lift_axis_A THEN
            D2008 := 15000; D2009 := 500; Y42 := TRUE;
            D81 := 1;
        ELSE
            D2012 := 15000; D2013 := 500; Y43 := TRUE;
            D81 := 2;
        END_IF;
        D2016 := -85000; D2017 := 0; Y44 := TRUE;
        D2020 := -85000; D2021 := 0; Y45 := TRUE;
        D2024 := -65000; D2025 := 0; Y46 := TRUE;
        D2028 := 65000; D2029 := 0; Y47 := TRUE;
        D2032 := 0; D2033 := 0; Y48 := TRUE;
        D80 := 1;

        IF (lift_axis_A AND ABS(D1008 - 15000) < 500) OR
           (NOT lift_axis_A AND ABS(D1012 - 15000) < 500) THEN
            IF ABS(D1004) < 2000 THEN
                IF (current_req = 0 AND X30) OR (current_req = 1 AND X34) THEN
                    state := 90;
                END_IF;
            END_IF;
        END_IF;

    90: (* ACK & RESET *)
        IF current_req = 0 THEN
            D300 := D100;
            D301 := 1;
            IF is_cancelled THEN D301 := 2; END_IF;
        ELSE
            D302 := D120;
            D303 := 1;
            IF is_cancelled THEN D303 := 2; END_IF;
        END_IF;
        state := 0;

    ELSE
        state := 0;
    END_CASE;

    IF is_cancelled AND state > 10 AND state < 90 THEN
        state := 70;
    END_IF;

    y2_timer(IN := (X30 AND X34 AND X51 AND
                    ABS(D1000) < 100 AND ABS(D1004) < 100 AND
                    ABS(D1008 - 15000) < 100 AND ABS(D1012 - 15000) < 100 AND
                    ABS(D1016 - (-85000)) < 100 AND ABS(D1020 - (-85000)) < 100 AND
                    ABS(D1024 - (-65000)) < 100 AND ABS(D1028 - 65000) < 100 AND
                    ABS(D1032) < 100), PT := T#100ms);
    IF y2_timer.Q THEN y2_active := TRUE; END_IF;
    Y2 := y2_active;

END_PROGRAM