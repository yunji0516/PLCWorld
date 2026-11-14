PROGRAM Main
VAR
    D1000 : DINT; D1001 : DINT; D1004 : DINT; D1005 : DINT; D1008 : DINT; D1009 : DINT;
    D1012 : DINT; D1013 : DINT; D1016 : DINT; D1017 : DINT; D1020 : DINT; D1021 : DINT;
    D1024 : DINT; D1025 : DINT; D1028 : DINT; D1029 : DINT; D1032 : DINT; D1033 : DINT;
    D100 : DINT; D101 : DINT; D102 : DINT; D103 : DINT; D104 : DINT; X30 : BOOL; X31 : BOOL;
    D120 : DINT; D121 : DINT; D122 : DINT; D123 : DINT; D124 : DINT; X34 : BOOL; X35 : BOOL;
    X51 : BOOL; D90 : DINT; D91 : DINT; D92 : DINT; X52 : BOOL; X53 : BOOL;
    D403 : DINT; D404 : DINT; X61 : BOOL; D406 : DINT; D407 : DINT; X62 : BOOL;
    D409 : DINT; D410 : DINT; X63 : BOOL; D412 : DINT; D413 : DINT; X64 : BOOL;
    D500 : DINT; D501 : DINT; D520 : DINT; D521 : DINT; D522 : DINT; D523 : DINT;
    D524 : DINT; D525 : DINT; D526 : DINT; D527 : DINT; X70 : BOOL; X71 : BOOL; X72 : BOOL;
    D600 : DINT; D601 : DINT; D602 : DINT; D620 : DINT; D621 : DINT; D622 : DINT;
    D623 : DINT; D624 : DINT; D625 : DINT; D626 : DINT; D627 : DINT; X75 : BOOL;
    X76 : BOOL; X77 : BOOL;
    D2000 : DINT; D2001 : DINT; D2002 : DINT; Y40 : BOOL; D2004 : DINT; D2005 : DINT;
    D2006 : DINT; Y41 : BOOL; D2008 : DINT; D2009 : DINT; D2010 : DINT; Y42 : BOOL;
    D2012 : DINT; D2013 : DINT; D2014 : DINT; Y43 : BOOL; D2016 : DINT; D2017 : DINT;
    D2018 : DINT; Y44 : BOOL; D2020 : DINT; D2021 : DINT; D2022 : DINT; Y45 : BOOL;
    D2024 : DINT; D2025 : DINT; D2026 : DINT; Y46 : BOOL; D2028 : DINT; D2029 : DINT;
    D2030 : DINT; Y47 : BOOL; D2032 : DINT; D2033 : DINT; D2034 : DINT; Y48 : BOOL;
    D300 : DINT; D301 : DINT; D302 : DINT; D303 : DINT; Y70 : BOOL; Y71 : BOOL; D700 : DINT;
    D701 : DINT; D702 : DINT; Y75 : BOOL; Y76 : BOOL; D710 : DINT; D711 : DINT; D712 : DINT;
    D80 : DINT; D81 : DINT; D82 : DINT; Y30 : BOOL; Y2 : BOOL;
    
    st : DINT := 0;
    req_id : DINT := 0;
    req_loc : DINT := 0;
    lift_h : DINT := 15000;
    station_t : DINT := 0;
    seq_n : DINT := 1;
    ack0_ok : BOOL := FALSE;
    ack1_ok : BOOL := FALSE;
    y2_t : TON;
END_VAR

D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0; D2034 := 0;
D701 := 0; D702 := 0; D711 := 0; D712 := 0;

CASE st OF
0: (* IDLE *)
    IF (D102 > 0) AND NOT X30 AND NOT X31 THEN
        req_id := D100; req_loc := D101;
        st := 1;
    ELSIF (D122 > 0) AND NOT X34 AND NOT X35 THEN
        req_id := D120; req_loc := D121;
        st := 1;
    ELSE
        Y30 := TRUE;
        D2000 := 0; D2001 := 0; Y40 := FALSE;
        D2004 := 0; D2005 := 0; Y41 := FALSE;
        D2008 := 15000; D2009 := 0; Y42 := TRUE;
        D2012 := 15000; D2013 := 0; Y43 := TRUE;
        D2016 := -60000; D2017 := 0; Y44 := FALSE;
        D2020 := -60000; D2021 := 0; Y45 := FALSE;
        D2024 := 0; D2025 := 0; Y46 := FALSE;
        D2028 := 0; D2029 := 0; Y47 := FALSE;
        D2032 := 0; D2033 := 0; Y48 := FALSE;
        Y70 := FALSE; Y71 := FALSE; D700 := 0;
        Y75 := FALSE; Y76 := FALSE; D710 := 0;
        D80 := 0; D81 := 0;
        IF ack0_ok AND ack1_ok THEN
            IF (ABS(D1000) < 20) AND (ABS(D1004) < 20) AND (ABS(D1008 - 15000) < 20) AND (ABS(D1012 - 15000) < 20) THEN
                y2_t(IN := TRUE, PT := T#100ms);
                IF y2_t.Q THEN Y2 := TRUE; END_IF;
            ELSE
                y2_t(IN := FALSE);
            END_IF;
        END_IF;
    END_IF;

1: (* GO_LIFT *)
    IF req_loc = 1 THEN station_t := -360000; ELSE station_t := -230000; END_IF;
    D2000 := station_t; D2001 := 800; Y40 := TRUE;
    D2008 := lift_h; D2009 := 0; Y42 := TRUE;
    D2012 := lift_h; D2013 := 0; Y43 := TRUE;
    D2004 := 0; D2005 := 0; Y41 := FALSE;
    D81 := req_loc; D80 := 0;
    IF (ABS(D1000 - station_t) < 20) AND (D1001 < 100) THEN st := 2; END_IF;

2: (* RAISE_LIFT *)
    lift_h := D92;
    D2000 := station_t; D2001 := 0; Y40 := FALSE;
    D2004 := 0; D2005 := 0; Y41 := FALSE;
    IF req_loc = 1 THEN
        D2008 := lift_h; D2009 := 800; Y42 := TRUE;
        D2012 := 15000; D2013 := 0; Y43 := TRUE;
        IF (ABS(D1008 - lift_h) < 20) AND (D1009 < 100) THEN st := 3; END_IF;
    ELSE
        D2008 := 15000; D2009 := 0; Y42 := TRUE;
        D2012 := lift_h; D2013 := 800; Y43 := TRUE;
        IF (ABS(D1012 - lift_h) < 20) AND (D1013 < 100) THEN st := 3; END_IF;
    END_IF;

3: (* COUPLE *)
    D2000 := station_t; D2001 := 0; Y40 := FALSE;
    IF req_loc = 1 THEN D2008 := lift_h; D2009 := 0; Y42 := TRUE; ELSE D2008 := 15000; D2009 := 0; Y42 := TRUE; END_IF;
    IF req_loc = 2 THEN D2012 := lift_h; D2013 := 0; Y43 := TRUE; ELSE D2012 := 15000; D2013 := 0; Y43 := TRUE; END_IF;
    D2004 := 0; D2005 := 800; Y41 := TRUE;
    D80 := 2; D81 := req_loc; D82 := seq_n; seq_n := seq_n + 1;
    IF (ABS(D1004 - 0) < 20) AND (D1005 < 100) THEN st := 4; END_IF;

4: (* GO_C3 *)
    D2000 := 0; D2001 := 800; Y40 := TRUE;
    D2008 := lift_h; D2009 := 0; Y42 := TRUE;
    D2012 := lift_h; D2013 := 0; Y43 := TRUE;
    D2004 := 0; D2005 := 0; Y41 := FALSE;
    D81 := 3; D80 := 0;
    IF (ABS(D1000) < 20) AND (D1001 < 100) THEN st := 5; END_IF;

5: (* C3_CAPTURE *)
    D2000 := 0; D2001 := 0; Y40 := FALSE;
    D2008 := lift_h; D2009 := 0; Y42 := TRUE;
    D2012 := lift_h; D2013 := 0; Y43 := TRUE;
    D2004 := 0; D2005 := 0; Y41 := FALSE;
    D700 := req_id; Y70 := TRUE; Y71 := TRUE;
    D2016 := D500 + 25000; D2017 := 800; Y44 := TRUE;
    D2020 := D501 + 25000; D2021 := 800; Y45 := TRUE;
    IF X72 OR X70 THEN st := 6; END_IF;

6: (* GO_C4 *)
    D2016 := 0; D2017 := 0; Y44 := FALSE;
    D2020 := 0; D2021 := 0; Y45 := FALSE;
    Y70 := FALSE; Y71 := FALSE;
    D2000 := 360000; D2001 := 800; Y40 := TRUE;
    D2008 := lift_h; D2009 := 0; Y42 := TRUE;
    D2012 := lift_h; D2013 := 0; Y43 := TRUE;
    D2004 := 0; D2005 := 0; Y41 := FALSE;
    D81 := 4; D80 := 0;
    IF (ABS(D1000 - 360000) < 20) AND (D1001 < 100) THEN st := 7; END_IF;

7: (* C4_INDEX *)
    D2000 := 360000; D2001 := 0; Y40 := FALSE;
    D2008 := lift_h; D2009 := 0; Y42 := TRUE;
    D2012 := lift_h; D2013 := 0; Y43 := TRUE;
    D2004 := 0; D2005 := 0; Y41 := FALSE;
    D710 := req_id; Y75 := TRUE; Y76 := TRUE;
    D2024 := D600; D2025 := 800; Y46 := TRUE;
    IF X77 OR X75 THEN
        D2028 := 4000; D2029 := 800; Y47 := TRUE;
        IF (ABS(D1028 - 4000) < 20) AND (D1029 < 100) THEN st := 8; END_IF;
    END_IF;

8: (* RETURN_LIFT *)
    D2024 := 0; D2025 := 0; Y46 := FALSE;
    D2028 := 0; D2029 := 0; Y47 := FALSE;
    Y75 := FALSE; Y76 := FALSE;
    D2000 := station_t; D2001 := 800; Y40 := TRUE;
    D2008 := lift_h; D2009 := 0; Y42 := TRUE;
    D2012 := lift_h; D2013 := 0; Y43 := TRUE;
    D2004 := 0; D2005 := 0; Y41 := FALSE;
    D81 := req_loc; D80 := 0;
    IF (ABS(D1000 - station_t) < 20) AND (D1001 < 100) THEN st := 9; END_IF;

9: (* LOWER_LIFT *)
    D2000 := station_t; D2001 := 0; Y40 := FALSE;
    D2004 := 0; D2005 := 0; Y41 := FALSE;
    D2008 := 15000; D2009 := 800; Y42 := TRUE;
    D2012 := 15000; D2013 := 800; Y43 := TRUE;
    IF (ABS(D1008 - 15000) < 20) AND (D1009 < 100) AND (ABS(D1012 - 15000) < 20) AND (D1013 < 100) THEN st := 10; END_IF;

10: (* DECOUPLE *)
    D2008 := 15000; D2009 := 0; Y42 := TRUE;
    D2012 := 15000; D2013 := 0; Y43 := TRUE;
    D2004 := 18000; D2005 := 800; Y41 := TRUE;
    D80 := 1; D81 := 0;
    IF (ABS(D1004 - 18000) < 20) AND (D1005 < 100) THEN st := 11; END_IF;

11: (* ACK *)
    IF req_id = D100 THEN
        D300 := D100; IF X31 THEN D301 := 2; ELSE D301 := 1; END_IF; ack0_ok := TRUE;
    ELSE
        D302 := D120; IF X35 THEN D303 := 2; ELSE D303 := 1; END_IF; ack1_ok := TRUE;
    END_IF;
    D80 := 0; D81 := 0;
    st := 12;

12: (* WAIT_RETURN *)
    IF (req_id = D100 AND X30) OR (req_id = D120 AND X34) THEN st := 0; END_IF;

END_CASE;
END_PROGRAM