PROGRAM Main
VAR
    D1000 : DINT; D1001 : DINT; D1004 : DINT; D1005 : DINT; D1008 : DINT; D1009 : DINT; D1012 : DINT; D1013 : DINT;
    D1016 : DINT; D1017 : DINT; D1020 : DINT; D1021 : DINT; D1024 : DINT; D1025 : DINT; D1028 : DINT; D1029 : DINT;
    D100 : DINT; D101 : DINT; D102 : DINT; D103 : DINT; D104 : DINT; X30 : BOOL; X31 : BOOL;
    D120 : DINT; D121 : DINT; D122 : DINT; D123 : DINT; D124 : DINT; X34 : BOOL; X35 : BOOL;
    X51 : BOOL; D90 : DINT; D91 : DINT; D92 : DINT; X52 : BOOL; X53 : BOOL;
    D403 : DINT; D404 : DINT; X61 : BOOL; D406 : DINT; D407 : DINT; X62 : BOOL;
    D409 : DINT; D410 : DINT; X63 : BOOL; D412 : DINT; D413 : DINT; X64 : BOOL;
    D500 : DINT; D501 : DINT; D520 : DINT; D521 : DINT; D522 : DINT; D523 : DINT;
    D524 : DINT; D525 : DINT; D526 : DINT; D527 : DINT; X70 : BOOL; X71 : BOOL; X72 : BOOL;
    D600 : DINT; D601 : DINT; D620 : DINT; D621 : DINT; D622 : DINT; D623 : DINT;
    D624 : DINT; D625 : DINT; D626 : DINT; D627 : DINT; X75 : BOOL; X76 : BOOL; X77 : BOOL;
    D2000 : DINT; D2001 : DINT; D2002 : DINT; Y40 : BOOL; D2004 : DINT; D2005 : DINT; D2006 : DINT; Y41 : BOOL;
    D2008 : DINT; D2009 : DINT; D2010 : DINT; Y42 : BOOL; D2012 : DINT; D2013 : DINT; D2014 : DINT; Y43 : BOOL;
    D2016 : DINT; D2017 : DINT; D2018 : DINT; Y44 : BOOL; D2020 : DINT; D2021 : DINT; D2022 : DINT; Y45 : BOOL;
    D2024 : DINT; D2025 : DINT; D2026 : DINT; Y46 : BOOL; D2028 : DINT; D2029 : DINT; D2030 : DINT; Y47 : BOOL;
    D300 : DINT; D301 : DINT; D302 : DINT; D303 : DINT;
    Y70 : BOOL; Y71 : BOOL; D700 : DINT; D701 : DINT; D702 : DINT;
    Y75 : BOOL; Y76 : BOOL; D710 : DINT; D711 : DINT; D712 : DINT;
    D80 : DINT; D81 : DINT; D82 : DINT; Y30 : BOOL; Y2 : BOOL;
    
    t : TON;
    e_ep : R_TRIG;
    st : INT := 0;
    cr : INT := -1;
    org : INT := 0;
    cid : DINT := 0;
    ep_val : DINT := 0;
    prev_ep : DINT := 0;
    sn : DINT := 0;
    a0d : BOOL := FALSE;
    a1d : BOOL := FALSE;
    c0 : BOOL := FALSE;
    c1 : BOOL := FALSE;
    
    h_a : DINT := 0;
    h_b : DINT := 0;
    h_c : DINT := 15000;
    h_d : DINT := 15000;
    hs0 : DINT := -60000;
    hs1 : DINT := -60000;
    hs2 : DINT := -60000;
    hs3 : DINT := -60000;
    dk1 : DINT := -360000;
    dk2 : DINT := -230000;
    dk3 : DINT := 0;
    dk4 : DINT := 360000;
    fr : DINT := 0;
    fe : DINT := 18000;
    tp : DINT := 20;
    ts : DINT := 100;
    rf : DINT := 800;
    rs : DINT := 300;
END_VAR

e_ep(CLK := D91 <> prev_ep);
IF e_ep.Q THEN
    ep_val := D91;
    prev_ep := D91;
END_IF;

CASE st OF
0: 
    Y40:=FALSE; Y41:=FALSE; Y42:=FALSE; Y43:=FALSE;
    Y44:=FALSE; Y45:=FALSE; Y46:=FALSE; Y47:=FALSE;
    Y70:=FALSE; Y71:=FALSE; Y75:=FALSE; Y76:=FALSE;
    Y30:=TRUE; D80:=0; D81:=0; D82:=0; Y2:=FALSE;
    D2000:=h_a; D2004:=h_b; D2008:=h_c; D2012:=h_d;
    D2016:=hs0; D2020:=hs1; D2024:=hs2; D2028:=hs3;
    D700:=0; D701:=0; D702:=0; D710:=0; D711:=0; D712:=0;
    IF NOT a0d AND D102 > 0 THEN
        cr := 0; org := D101; IF org = 0 THEN org := 1; END_IF; cid := D100; c0 := X31; st := 1;
    ELSIF NOT a1d AND D122 > 0 THEN
        cr := 1; org := D121; IF org = 0 THEN org := 1; END_IF; cid := D120; c1 := X35; st := 1;
    END_IF;

1: 
    Y30 := FALSE;
    D2000 := (IF org = 1 THEN dk1 ELSE dk2 END_IF); D2001 := rf; D2002 := 0; Y40 := TRUE;
    D2004 := fr; D2005 := rf; D2006 := 0; Y41 := TRUE;
    D2008 := h_c; D2009 := 0; Y42 := TRUE; D2012 := h_d; D2013 := 0; Y43 := TRUE;
    D2016 := hs0; D2017 := rf; D2018 := 0; Y44 := TRUE; D2020 := hs1; D2021 := rf; D2022 := 0; Y45 := TRUE;
    D2024 := hs2; D2025 := rf; D2026 := 0; Y46 := TRUE; D2028 := hs3; D2029 := rf; D2030 := 0; Y47 := TRUE;
    Y70 := FALSE; Y75 := FALSE; D80 := 0; D81 := 0;
    IF ABS(D1000 - D2000) < tp AND ABS(D1001) < ts THEN st := 2; END_IF;

2: 
    sn := sn + 1; D82 := sn;
    D80 := 1; D81 := org; Y30 := FALSE; Y70 := FALSE; Y75 := FALSE;
    IF org = 1 THEN D2008 := D92; Y42 := TRUE; ELSE D2012 := D92; Y43 := TRUE; END_IF;
    D2004 := fe; D2005 := rs; D2006 := 0; Y41 := TRUE;
    Y40 := FALSE; D2000 := D2000;
    D2016 := hs0; Y44 := TRUE; D2020 := hs1; Y45 := TRUE;
    D2024 := hs2; Y46 := TRUE; D2028 := hs3; Y47 := TRUE;
    IF (IF org=1 THEN X61 ELSE X62 END_IF) AND D90 = cid THEN st := 3; END_IF;

3: 
    Y30 := FALSE; D80 := 0; D81 := 0; Y70 := FALSE; Y75 := FALSE;
    D2000 := dk3; D2001 := rf; D2002 := 0; Y40 := TRUE;
    D2004 := fr; D2005 := rf; D2006 := 0; Y41 := TRUE;
    D2008 := D92; Y42 := TRUE; D2012 := D92; Y43 := TRUE;
    D2016 := hs0; Y44 := TRUE; D2020 := hs1; Y45 := TRUE;
    D2024 := hs2; Y46 := TRUE; D2028 := hs3; Y47 := TRUE;
    IF ABS(D1000 - dk3) < tp AND ABS(D1001) < ts THEN st := 4; END_IF;

4: 
    Y30 := FALSE; D80 := 0; D81 := 0;
    IF ABS(D1017) < ts AND ABS(D1021) < ts THEN Y70 := TRUE; ELSE Y70 := FALSE; END_IF;
    Y75 := FALSE;
    D2016 := D500; D2017 := rf; D2018 := 0; Y44 := TRUE;
    D2020 := D501; D2021 := rf; D2022 := 0; Y45 := TRUE;
    D2000 := dk3; D2001 := rf; Y40 := TRUE; D2002 := 0;
    D2004 := fr; D2005 := rf; Y41 := TRUE; D2006 := 0;
    D2008 := D92; Y42 := TRUE; D2012 := D92; Y43 := TRUE;
    D2024 := hs2; Y46 := TRUE; D2028 := hs3; Y47 := TRUE;
    IF X70 THEN st := 5; END_IF;

5: 
    Y30 := FALSE; D80 := 0; D81 := 0; Y70 := FALSE; Y75 := FALSE;
    D2000 := dk4; D2001 := rf; D2002 := 0; Y40 := TRUE;
    D2004 := fr; D2005 := rf; D2006 := 0; Y41 := TRUE;
    D2008 := D92; Y42 := TRUE; D2012 := D92; Y43 := TRUE;
    D2016 := D500; Y44 := TRUE; D2020 := D501; Y45 := TRUE;
    D2024 := hs2; Y46 := TRUE; D2028 := hs3; Y47 := TRUE;
    IF ABS(D1000 - dk4) < tp AND ABS(D1001) < ts THEN st := 6; END_IF;

6: 
    Y30 := FALSE; D80 := 0; D81 := 0; Y70 := FALSE; Y75 := FALSE;
    D2000 := dk4; D2001 := rf; Y40 := TRUE; D2002 := 0;
    D2004 := fr; D2005 := rf; Y41 := TRUE; D2006 := 0;
    D2008 := D92; Y42 := TRUE; D2012 := D92; Y43 := TRUE;
    D2016 := D500; Y44 := TRUE; D2020 := D501; Y45 := TRUE;
    D710 := cid; D711 := 0; D712 := 500;
    D2024 := D600 + 25000; D2025 := rf; D2026 := 0; Y46 := TRUE;
    D2028 := D601 + 25000; D2029 := rf; D2030 := 0; Y47 := TRUE;
    IF X75 AND D624 = ep_val AND D622 = cid THEN st := 7; END_IF;

7: 
    Y30 := FALSE; D80 := 0; D81 := 0; Y70 := FALSE; Y75 := FALSE;
    D2000 := (IF org=1 THEN dk1 ELSE dk2 END_IF); D2001 := rf; D2002 := 0; Y40 := TRUE;
    D2004 := fr; D2005 := rf; D2006 := 0; Y41 := TRUE;
    D2008 := D92; Y42 := TRUE; D2012 := D92; Y43 := TRUE;
    D2016 := D500; Y44 := TRUE; D2020 := D501; Y45 := TRUE;
    D2024 := D600+25000; Y46 := TRUE; D2028 := D601+25000; Y47 := TRUE;
    IF ABS(D1000 - D2000) < tp AND ABS(D1001) < ts THEN st := 8; END_IF;

8: 
    sn := sn + 1; D82 := sn;
    D80 := 2; D81 := org; Y30 := FALSE; Y70 := FALSE; Y75 := FALSE;
    IF org = 1 THEN D2008 := D92; Y42 := TRUE; ELSE D2012 := D92; Y43 := TRUE; END_IF;
    D2004 := fe; D2005 := rs; D2006 := 0; Y41 := TRUE;
    Y40 := FALSE; D2000 := D2000;
    D2016 := D500; Y44 := TRUE; D2020 := D501; Y45 := TRUE;
    D2024 := D600+25000; Y46 := TRUE; D2028 := D601+25000; Y47 := TRUE;
    IF (IF org=1 THEN X61 ELSE X62 END_IF) AND D90 = cid THEN st := 9; END_IF;

9: 
    Y30 := FALSE; D80 := 0; D81 := 0; Y70 := FALSE; Y75 := FALSE;
    D2004 := fr; D2005 := rs; D2006 := 0; Y41 := TRUE;
    IF org = 1 THEN D2008 := h_c; Y42 := TRUE; ELSE D2012 := h_d; Y43 := TRUE; END_IF;
    Y40 := FALSE; D2000 := D2000;
    D2016 := D500; Y44 := TRUE; D2020 := D501; Y45 := TRUE;
    D2024 := D600+25000; Y46 := TRUE; D2028 := D601+25000; Y47 := TRUE;
    IF (IF org=1 THEN (ABS(D1008 - h_c) < tp AND ABS(D1009) < ts) ELSE (ABS(D1012 - h_d) < tp AND ABS(D1013) < ts) END_IF)
       AND (IF org=1 THEN X30 ELSE X34 END_IF) THEN st := 10; END_IF;

10:
    Y30 := TRUE; Y40 := FALSE; Y41 := FALSE; Y42 := FALSE; Y43 := FALSE;
    Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE;
    Y70 := FALSE; Y75 := FALSE; D80 := 0; D81 := 0; D82 := 0;
    D2000 := h_a; D2004 := h_b; D2008 := h_c; D2012 := h_d;
    D2016 := hs0; D2020 := hs1; D2024 := hs2; D2028 := hs3;
    IF cr = 0 THEN
        D300 := cid; D301 := (IF c0 THEN 2 ELSE 1 END_IF); a0d := TRUE;
    ELSE
        D302 := cid; D303 := (IF c1 THEN 2 ELSE 1 END_IF); a1d := TRUE;
    END_IF;
    st := 11;

11:
    D700 := 0; D701 := 0; D702 := 0; D710 := 0; D711 := 0; D712 := 0;
    IF (NOT a0d AND D102 > 0) OR (NOT a1d AND D122 > 0) THEN
        st := 0;
    ELSE
        D2000 := h_a; D2004 := h_b; D2008 := h_c; D2012 := h_d;
        D2016 := hs0; D2020 := hs1; D2024 := hs2; D2028 := hs3;
        Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
        Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE;
        Y30 := TRUE; Y2 := TRUE; Y70 := FALSE; Y75 := FALSE;
        st := 12;
    END_IF;

12:
    Y2 := TRUE;
END_CASE;

END_PROGRAM