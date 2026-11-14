PROGRAM Main
VAR
    D1000 : DINT; D1001 : DINT; D1004 : DINT; D1005 : DINT; D1008 : DINT; D1009 : DINT; D1012 : DINT; D1013 : DINT; D1016 : DINT; D1017 : DINT; D1020 : DINT; D1021 : DINT; D1024 : DINT; D1025 : DINT; D1028 : DINT; D1029 : DINT; D1032 : DINT; D1033 : DINT;
    D100 : DINT; D101 : DINT; D102 : DINT; D103 : DINT; D104 : DINT; X30 : BOOL; X31 : BOOL; D120 : DINT; D121 : DINT; D122 : DINT; D123 : DINT; D124 : DINT; X34 : BOOL; X35 : BOOL; X51 : BOOL;
    D90 : DINT; D91 : DINT; D92 : DINT; X52 : BOOL; X53 : BOOL; D403 : DINT; D404 : DINT; X61 : BOOL; D406 : DINT; D407 : DINT; X62 : BOOL; D409 : DINT; D410 : DINT; X63 : BOOL; D412 : DINT; D413 : DINT; X64 : BOOL;
    D500 : DINT; D501 : DINT; D520 : DINT; D521 : DINT; D522 : DINT; D523 : DINT; D524 : DINT; D525 : DINT; D526 : DINT; D527 : DINT; X70 : BOOL; X71 : BOOL; X72 : BOOL;
    D600 : DINT; D601 : DINT; D602 : DINT; D620 : DINT; D621 : DINT; D622 : DINT; D623 : DINT; D624 : DINT; D625 : DINT; D626 : DINT; D627 : DINT; X75 : BOOL; X76 : BOOL; X77 : BOOL;
    D2000 : DINT; D2001 : DINT; D2002 : DINT; Y40 : BOOL; D2004 : DINT; D2005 : DINT; D2006 : DINT; Y41 : BOOL; D2008 : DINT; D2009 : DINT; D2010 : DINT; Y42 : BOOL; D2012 : DINT; D2013 : DINT; D2014 : DINT; Y43 : BOOL;
    D2016 : DINT; D2017 : DINT; D2018 : DINT; Y44 : BOOL; D2020 : DINT; D2021 : DINT; D2022 : DINT; Y45 : BOOL; D2024 : DINT; D2025 : DINT; D2026 : DINT; Y46 : BOOL; D2028 : DINT; D2029 : DINT; D2030 : DINT; Y47 : BOOL; D2032 : DINT; D2033 : DINT; D2034 : DINT; Y48 : BOOL;
    D300 : DINT; D301 : DINT; D302 : DINT; D303 : DINT; Y70 : BOOL; Y71 : BOOL; D700 : DINT; D701 : DINT; D702 : DINT; Y75 : BOOL; Y76 : BOOL; D710 : DINT; D711 : DINT; D712 : DINT; D80 : DINT; D81 : DINT; D82 : DINT; Y30 : BOOL; Y2 : BOOL;
    st : INT := 0;
    req_sel : INT := -1;
    prev0 : DINT := -1;
    prev1 : DINT := -1;
    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;
    cur_loc : DINT := 0;
    cur_id : DINT := 0;
    seq_val : DINT := 0;
    tcross : TON;
    texch : TON;
    tdone : TON;
END_VAR

tcross(IN := FALSE, PT := T#80ms);
texch(IN := FALSE, PT := T#80ms);
tdone(IN := FALSE, PT := T#100ms);

CASE st OF
0:
    Y40 := FALSE; Y41 := FALSE; Y42 := FALSE; Y43 := FALSE;
    Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE; Y48 := FALSE;
    Y30 := TRUE;
    D2000 := 0; D2001 := 0; D2002 := 0;
    D2004 := 0; D2005 := 0; D2006 := 0;
    D2008 := 15000; D2009 := 0; D2010 := 0;
    D2012 := 15000; D2013 := 0; D2014 := 0;
    D2016 := -85000; D2017 := 0; D2018 := 0;
    D2020 := -85000; D2021 := 0; D2022 := 0;
    D2024 := -65000; D2025 := 0; D2026 := 0;
    D2028 := 65000; D2029 := 0; D2030 := 0;
    D2032 := 0; D2033 := 0; D2034 := 0;
    Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
    Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
    D80 := 0; D81 := 0; D82 := 0;
    D300 := 0; D301 := 0; D302 := 0; D303 := 0;
    Y2 := FALSE;

    IF NOT r0_done AND D100 <> prev0 THEN
        req_sel := 0;
        prev0 := D100;
        cur_id := D100;
        cur_loc := D101;
        st := 1;
    ELSIF NOT r1_done AND D120 <> prev1 THEN
        req_sel := 1;
        prev1 := D120;
        cur_id := D120;
        cur_loc := D121;
        st := 1;
    END_IF;

1:
    Y30 := TRUE;
    Y40 := TRUE; Y41 := TRUE;
    Y42 := FALSE; Y43 := FALSE;
    Y44 := FALSE; Y45 := FALSE;
    Y46 := FALSE; Y47 := FALSE; Y48 := FALSE;
    D2001 := 500; D2002 := 0;
    D2005 := 500; D2006 := 0;
    D2009 := 0; D2010 := 0;
    D2013 := 0; D2014 := 0;
    D2017 := 0; D2018 := 0;
    D2021 := 0; D2022 := 0;
    D2025 := 0; D2026 := 0;
    D2029 := 0; D2030 := 0;
    D2033 := 0; D2034 := 0;
    IF cur_loc = 1 THEN D2000 := -360000 ELSE D2000 := -230000 END_IF;
    D2004 := 0;
    D2008 := 15000; D2012 := 15000;
    D2016 := -85000; D2020 := -85000;
    D2024 := -65000; D2028 := 65000; D2032 := 0;
    IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 THEN
        st := 2;
    END_IF;

2:
    Y30 := TRUE;
    Y41 := TRUE;
    D2004 := 18000; D2005 := 500; D2006 := 0;
    Y40 := TRUE;
    D2001 := 500; D2002 := 0;
    IF ABS(D1004 - D2004) <= 20 AND ABS(D1005) <= 100 THEN
        st := 3;
    END_IF;

3:
    Y30 := FALSE;
    IF cur_loc = 1 THEN
        Y42 := TRUE; Y43 := FALSE;
        D2008 := D92; D2009 := 500; D2010 := 0;
        D2012 := 15000; D2013 := 0; D2014 := 0;
    ELSE
        Y43 := TRUE; Y42 := FALSE;
        D2012 := D92; D2013 := 500; D2014 := 0;
        D2008 := 15000; D2009 := 0; D2010 := 0;
    END_IF;
    D81 := cur_loc;
    seq_val := seq_val + 1;
    D82 := seq_val;
    IF (cur_loc = 1 AND ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100) OR
       (cur_loc = 2 AND ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100) THEN
        st := 4;
    END_IF;

4:
    IF (cur_loc = 1 AND X61) OR (cur_loc = 2 AND X62) THEN
        D80 := 1;
        st := 5;
    END_IF;

5:
    Y30 := FALSE;
    Y40 := TRUE; Y44 := TRUE; Y45 := TRUE;
    Y41 := TRUE;
    D2000 := 0; D2001 := 500; D2002 := 0;
    D2016 := -23000; D2017 := 500; D2018 := 0;
    D2020 := 0; D2021 := 500; D2022 := 0;
    D2004 := 18000; D2005 := 500; D2006 := 0;
    Y70 := TRUE; Y71 := FALSE; D700 := cur_id; D701 := 0; D702 := 6000;
    D81 := 3;
    IF ABS(D1000 - 0) <= 20 AND ABS(D1016 - (-23000)) <= 20 AND ABS(D1020 - 0) <= 20 THEN
        tcross(IN := TRUE, PT := T#80ms);
        IF tcross.Q THEN
            tcross(IN := FALSE);
            st := 6;
        END_IF;
    ELSE
        tcross(IN := FALSE);
    END_IF;

6:
    Y44 := FALSE; Y45 := FALSE;
    Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;
    D2000 := 360000; D2001 := 500; D2002 := 0;
    D2024 := -65000; D2025 := 500; D2026 := 0;
    D2028 := 65000; D2029 := 500; D2030 := 0;
    D2032 := 0; D2033 := 500; D2034 := 0;
    Y75 := TRUE; Y76 := FALSE; D710 := cur_id; D711 := 0; D712 := 6000;
    D81 := 4;
    IF ABS(D1000 - 360000) <= 20 AND ABS(D1024 - (-65000)) <= 20 AND ABS(D1028 - 65000) <= 20 THEN
        texch(IN := TRUE, PT := T#80ms);
        IF texch.Q THEN
            texch(IN := FALSE);
            st := 7;
        END_IF;
    ELSE
        texch(IN := FALSE);
    END_IF;

7:
    D2024 := -65000; D2025 := 500; D2026 := 0;
    D2028 := 65000; D2029 := 500; D2030 := 0;
    D2032 := 0; D2033 := 500; D2034 := 0;
    D2000 := 0; D2001 := 500; D2002 := 0;
    IF ABS(D1024 - (-65000)) <= 20 AND ABS(D1028 - 65000) <= 20 AND ABS(D1000 - 0) <= 20 THEN
        Y75 := FALSE; Y76 := TRUE;
        Y46 := FALSE; Y47 := FALSE; Y48 := FALSE;
        st := 8;
    END_IF;

8:
    D2016 := -85000; D2017 := 500; D2018 := 0;
    D2020 := -85000; D2021 := 500; D2022 := 0;
    Y44 := TRUE; Y45 := TRUE;
    IF ABS(D1016 - (-85000)) <= 20 AND ABS(D1020 - (-85000)) <= 20 THEN
        Y70 := FALSE; Y71 := TRUE;
        Y44 := FALSE; Y45 := FALSE;
        st := 9;
    END_IF;

9:
    Y30 := TRUE;
    IF cur_loc = 1 THEN
        Y42 := TRUE; Y43 := FALSE;
        D2008 := 15000; D2009 := 500;
        IF ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 THEN st := 10; END_IF;
    ELSE
        Y43 := TRUE; Y42 := FALSE;
        D2012 := 15000; D2013 := 500;
        IF ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 THEN st := 10; END_IF;
    END_IF;

10:
    Y41 := TRUE;
    D2004 := 0; D2005 := 500; D2006 := 0;
    IF ABS(D1004 - 0) <= 20 AND ABS(D1005) <= 100 THEN st := 11; END_IF;

11:
    Y40 := TRUE;
    D2000 := 0; D2001 := 500; D2002 := 0;
    IF ABS(D1000 - 0) <= 20 AND ABS(D1001) <= 100 THEN st := 12; END_IF;

12:
    Y30 := TRUE; Y40 := FALSE; Y41 := FALSE;
    IF req_sel = 0 THEN
        D300 := cur_id; D301 := 1; r0_done := TRUE;
    ELSE
        D302 := cur_id; D303 := 1; r1_done := TRUE;
    END_IF;
    D80 := 0; D81 := 0;
    
    IF r0_done AND r1_done AND
       ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND
       ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20 AND
       ABS(D1016 - (-85000)) <= 20 AND ABS(D1020 - (-85000)) <= 20 AND
       ABS(D1024 - (-65000)) <= 20 AND ABS(D1028 - 65000) <= 20 AND ABS(D1032) <= 20 THEN
        tdone(IN := TRUE, PT := T#100ms);
        IF tdone.Q THEN
            Y2 := TRUE;
            st := 13;
        END_IF;
    ELSE
        tdone(IN := FALSE);
        IF r0_done AND r1_done THEN
            Y2 := TRUE;
            st := 13;
        ELSE
            st := 0;
        END_IF;
    END_IF;

13:
    Y2 := TRUE;
    Y30 := TRUE;
    Y40 := FALSE; Y41 := FALSE; Y42 := FALSE; Y43 := FALSE;
    Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE; Y48 := FALSE;
END_CASE;

END_PROGRAM