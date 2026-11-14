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

    (* Internal variables *)
    home_a  : DINT := 0;
    home_b  : DINT := 0;
    home_c  : DINT := 15000;
    home_d  : DINT := 15000;
    home_s30 : DINT := -60000;
    home_s31 : DINT := -60000;
    home_s40 : DINT := 0;
    home_s41 : DINT := 0;
    home_s42 : DINT := 0;

    pos_tol : DINT := 20; (* 0.2 mm/deg in x100 raw units *)

    drive_rate : DINT := 300; (* 0.3 -> above 0.02 floor, within 0..1000 *)

    ack0_done : BOOL := FALSE;
    ack1_done : BOOL := FALSE;

    all_axes_home : BOOL := FALSE;
    completion_latched : BOOL := FALSE;

    y2_timer : TON;
END_VAR

(* ---------- Drive all axes toward their disclosed initial connection posture ---------- *)
D2000 := home_a;
D2001 := drive_rate;
D2002 := 0;
Y40 := TRUE;

D2004 := home_b;
D2005 := drive_rate;
D2006 := 0;
Y41 := TRUE;

D2008 := home_c;
D2009 := drive_rate;
D2010 := 0;
Y42 := TRUE;

D2012 := home_d;
D2013 := drive_rate;
D2014 := 0;
Y43 := TRUE;

D2016 := home_s30;
D2017 := drive_rate;
D2018 := 0;
Y44 := TRUE;

D2020 := home_s31;
D2021 := drive_rate;
D2022 := 0;
Y45 := TRUE;

D2024 := home_s40;
D2025 := drive_rate;
D2026 := 0;
Y46 := TRUE;

D2028 := home_s41;
D2029 := drive_rate;
D2030 := 0;
Y47 := TRUE;

D2032 := home_s42;
D2033 := drive_rate;
D2034 := 0;
Y48 := TRUE;

(* ---------- Cell mechanism configuration outputs kept passive / safe ---------- *)
Y70 := FALSE;
Y71 := FALSE;
D700 := 0;
D701 := 0;
D702 := 0;

Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := 0;
D712 := 0;

(* ---------- Connection/handoff outputs kept passive / safe ---------- *)
D80 := 0;
D81 := 0;
D82 := 0;

(* Brake left disengaged unless final completion parked and latched *)
Y30 := completion_latched;

(* ---------- Per-request completion / cancellation acknowledgement ---------- *)
IF X30 AND NOT ack0_done THEN
    D300 := D100;
    IF X31 THEN
        D301 := 2;
    ELSE
        D301 := 1;
    END_IF;
    ack0_done := TRUE;
END_IF;

IF X34 AND NOT ack1_done THEN
    D302 := D120;
    IF X35 THEN
        D303 := 2;
    ELSE
        D303 := 1;
    END_IF;
    ack1_done := TRUE;
END_IF;

(* ---------- Check all axes are at the disclosed initial connection posture ---------- *)
all_axes_home := (ABS(D1000 - home_a) <= pos_tol) AND
                  (ABS(D1004 - home_b) <= pos_tol) AND
                  (ABS(D1008 - home_c) <= pos_tol) AND
                  (ABS(D1012 - home_d) <= pos_tol) AND
                  (ABS(D1016 - home_s30) <= pos_tol) AND
                  (ABS(D1020 - home_s31) <= pos_tol) AND
                  (ABS(D1024 - home_s40) <= pos_tol) AND
                  (ABS(D1028 - home_s41) <= pos_tol) AND
                  (ABS(D1032 - home_s42) <= pos_tol);

(* ---------- Final completion: hold for 100 ms once all requests done and axes parked ---------- *)
y2_timer(IN := (X51 AND all_axes_home), PT := T#100ms);

IF y2_timer.Q THEN
    completion_latched := TRUE;
END_IF;

Y2 := completion_latched;

END_PROGRAM