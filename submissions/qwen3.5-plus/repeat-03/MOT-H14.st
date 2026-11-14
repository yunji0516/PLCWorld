PROGRAM Main
VAR
    D1000 : DINT; D1001 : DINT; D1004 : DINT; D1005 : DINT;
    D1008 : DINT; D1009 : DINT; D1012 : DINT; D1013 : DINT;
    D1016 : DINT; D1017 : DINT; D1020 : DINT; D1021 : DINT;
    D1024 : DINT; D1025 : DINT; D1028 : DINT; D1029 : DINT;
    D100 : DINT; D101 : DINT; D102 : DINT; D103 : DINT; D104 : DINT;
    X30 : BOOL; X31 : BOOL; D120 : DINT; D121 : DINT; D122 : DINT; D123 : DINT; D124 : DINT;
    X34 : BOOL; X35 : BOOL; X51 : BOOL; D90 : DINT; D91 : DINT; D92 : DINT;
    X52 : BOOL; X53 : BOOL; D403 : DINT; D404 : DINT; X61 : BOOL;
    D406 : DINT; D407 : DINT; X62 : BOOL; D409 : DINT; D410 : DINT;
    X63 : BOOL; D412 : DINT; D413 : DINT; X64 : BOOL;
    D500 : DINT; D501 : DINT; D520 : DINT; D521 : DINT; D522 : DINT;
    D523 : DINT; D524 : DINT; D525 : DINT; D526 : DINT; D527 : DINT;
    X70 : BOOL; X71 : BOOL; X72 : BOOL;
    D600 : DINT; D601 : DINT; D620 : DINT; D621 : DINT; D622 : DINT;
    D623 : DINT; D624 : DINT; D625 : DINT; D626 : DINT; D627 : DINT;
    X75 : BOOL; X76 : BOOL; X77 : BOOL;
    D2000 : DINT; D2001 : DINT; D2002 : DINT; Y40 : BOOL;
    D2004 : DINT; D2005 : DINT; D2006 : DINT; Y41 : BOOL;
    D2008 : DINT; D2009 : DINT; D2010 : DINT; Y42 : BOOL;
    D2012 : DINT; D2013 : DINT; D2014 : DINT; Y43 : BOOL;
    D2016 : DINT; D2017 : DINT; D2018 : DINT; Y44 : BOOL;
    D2020 : DINT; D2021 : DINT; D2022 : DINT; Y45 : BOOL;
    D2024 : DINT; D2025 : DINT; D2026 : DINT; Y46 : BOOL;
    D2028 : DINT; D2029 : DINT; D2030 : DINT; Y47 : BOOL;
    D300 : DINT; D301 : DINT; D302 : DINT; D303 : DINT;
    Y70 : BOOL; Y71 : BOOL; D700 : DINT; D701 : DINT; D702 : DINT;
    Y75 : BOOL; Y76 : BOOL; D710 : DINT; D711 : DINT; D712 : DINT;
    D80 : DINT; D81 : DINT; D82 : DINT; Y30 : BOOL; Y2 : BOOL;

    state : INT := 0;
    active_req : INT := 0;
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;
    seq : DINT := 1;
    epoch_snap : DINT := 0;
    t_y2 : TON;
END_VAR

BEGIN
    D2000 := 0; D2001 := 0; D2002 := 0; Y40 := FALSE;
    D2004 := 0; D2005 := 0; D2006 := 0; Y41 := FALSE;
    D2008 := 0; D2009 := 0; D2010 := 0; Y42 := FALSE;
    D2012 := 0; D2013 := 0; D2014 := 0; Y43 := FALSE;
    D2016 := 0; D2017 := 0; D2018 := 0; Y44 := FALSE;
    D2020 := 0; D2021 := 0; D2022 := 0; Y45 := FALSE;
    D2024 := 0; D2025 := 0; D2026 := 0; Y46 := FALSE;
    D2028 := 0; D2029 := 0; D2030 := 0; Y47 := FALSE;
    Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
    Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
    D80 := 0; D81 := 0; D82 := 0; Y30 := FALSE; Y2 := FALSE;

    Y30 := NOT (Y40 OR Y41 OR Y42 OR Y43 OR Y44 OR Y45 OR Y46 OR Y47);

    IF NOT req0_done THEN active_req := 0;
    ELSIF NOT req1_done THEN active_req := 1;
    ELSE active_req := 2; END_IF;

    CASE state OF
        0: 
            D2000 := DINT#0; D2004 := DINT#0; D2001 := DINT#500; D2005 := DINT#500; Y40 := TRUE; Y41 := TRUE;
            D2008 := DINT#15000; D2009 := DINT#500; Y42 := TRUE;
            D2012 := DINT#15000; D2013 := DINT#500; Y43 := TRUE;
            D2016 := DINT#-60000; D2017 := DINT#500; Y44 := TRUE;
            D2020 := DINT#-60000; D2021 := DINT#500; Y45 := TRUE;
            D2024 := DINT#-60000; D2025 := DINT#500; Y46 := TRUE;
            D2028 := DINT#-60000; D2029 := DINT#500; Y47 := TRUE;
            
            IF NOT req0_done THEN state := 10;
            ELSIF NOT req1_done THEN state := 10; active_req := 1;
            ELSE state := 100; END_IF;

        10: 
            D81 := active_req + 1; D80 := 1; D82 := seq;
            IF active_req = 0 THEN D2000 := DINT#-360000;
            ELSE D2000 := DINT#-230000; END_IF;
            D2004 := DINT#18000;
            D2001 := DINT#500; D2005 := DINT#500;
            Y40 := TRUE; Y41 := TRUE;
            IF ((active_req = 0 AND X61) OR (active_req = 1 AND X62)) THEN
                seq := seq + 1; state := 20;
            END_IF;

        20: 
            D81 := 3; D80 := 0; D82 := 0;
            D2000 := DINT#0; D2004 := DINT#0;
            D2001 := DINT#500; D2005 := DINT#500;
            Y40 := TRUE; Y41 := TRUE;
            IF D1000 > -5000 AND D1000 < 5000 THEN state := 30; END_IF;

        30: 
            Y70 := TRUE; D700 := DINT#100;
            IF X70 THEN Y70 := FALSE; state := 40; END_IF;

        40: 
            D81 := 4; D80 := 0; D82 := 0;
            D2000 := DINT#360000; D2004 := DINT#0;
            D2001 := DINT#500; D2005 := DINT#500;
            Y40 := TRUE; Y41 := TRUE;
            IF D1000 > 355000 THEN state := 50; END_IF;

        50: 
            IF active_req = 0 THEN D710 := D100; ELSE D710 := D120; END_IF;
            Y75 := TRUE; Y76 := TRUE;
            D2024 := DINT#25000; D2028 := DINT#25000;
            Y46 := TRUE; Y47 := TRUE;
            D2025 := DINT#500; D2029 := DINT#500;
            IF D91 <> epoch_snap THEN epoch_snap := D91; END_IF;
            IF X75 THEN state := 60; END_IF;

        60: 
            D81 := active_req + 1; D80 := 2; D82 := seq;
            IF active_req = 0 THEN D2000 := DINT#-360000;
            ELSE D2000 := DINT#-230000; END_IF;
            D2004 := DINT#18000;
            D2001 := DINT#500; D2005 := DINT#500;
            Y40 := TRUE; Y41 := TRUE;
            seq := seq + 1;
            IF ((active_req = 0 AND X61) OR (active_req = 1 AND X62)) THEN state := 70; END_IF;

        70: 
            D2004 := DINT#0; D2005 := DINT#500; Y41 := TRUE;
            IF (active_req = 0 AND X30) OR (active_req = 1 AND X34) THEN
                IF active_req = 0 THEN
                    D300 := D100; D301 := DINT#1; req0_done := TRUE;
                ELSE
                    D302 := D120; D303 := DINT#1; req1_done := TRUE;
                END_IF;
                state := 80;
            END_IF;

        80: 
            D2000 := DINT#0; D2004 := DINT#0;
            D2001 := DINT#500; D2005 := DINT#500;
            Y40 := TRUE; Y41 := TRUE;
            D2008 := DINT#15000; D2009 := DINT#500; Y42 := TRUE;
            D2012 := DINT#15000; D2013 := DINT#500; Y43 := TRUE;
            D2016 := DINT#-60000; D2017 := DINT#500; Y44 := TRUE;
            D2020 := DINT#-60000; D2021 := DINT#500; Y45 := TRUE;
            D2024 := DINT#-60000; D2025 := DINT#500; Y46 := TRUE;
            D2028 := DINT#-60000; D2029 := DINT#500; Y47 := TRUE;
            IF D1000 > -5000 AND D1000 < 5000 THEN state := 0; END_IF;

        100: 
            Y2 := req0_done AND req1_done;
            t_y2(IN := Y2, PT := T#100ms);
    END_CASE;

    IF D2000 > 450000 THEN D2000 := 450000; ELSIF D2000 < -450000 THEN D2000 := -450000; END_IF;
    IF D2004 > 18000 THEN D2004 := 18000; ELSIF D2004 < 0 THEN D2004 := 0; END_IF;
    IF D2008 > 120000 THEN D2008 := 120000; ELSIF D2008 < 0 THEN D2008 := 0; END_IF;
    IF D2012 > 120000 THEN D2012 := 120000; ELSIF D2012 < 0 THEN D2012 := 0; END_IF;
    IF D2016 > 95000 THEN D2016 := 95000; ELSIF D2016 < -95000 THEN D2016 := -95000; END_IF;
    IF D2020 > 180000 THEN D2020 := 180000; ELSIF D2020 < -180000 THEN D2020 := -180000; END_IF;
    IF D2024 > 95000 THEN D2024 := 95000; ELSIF D2024 < -95000 THEN D2024 := -95000; END_IF;
    IF D2028 > 95000 THEN D2028 := 95000; ELSIF D2028 < -95000 THEN D2028 := -95000; END_IF;
    IF D2001 > 1000 THEN D2001 := 1000; ELSIF D2001 < 0 THEN D2001 := 0; END_IF;
    IF D2005 > 1000 THEN D2005 := 1000; ELSIF D2005 < 0 THEN D2005 := 0; END_IF;
    IF D2025 > 1000 THEN D2025 := 1000; ELSIF D2025 < 0 THEN D2025 := 0; END_IF;
    IF D2029 > 1000 THEN D2029 := 1000; ELSIF D2029 < 0 THEN D2029 := 0; END_IF;
END_PROGRAM