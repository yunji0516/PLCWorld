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

    (* --- internal state --- *)
    a_home : DINT := 0;
    b_home : DINT := 0;
    c_home : DINT := 15000;
    d_home : DINT := 15000;
    s3_0_home : DINT := -60000;
    s3_1_home : DINT := -60000;
    s4_0_home : DINT := -60000;
    s4_1_home : DINT := -60000;

    reg3_0 : DINT := 0;
    reg3_1 : DINT := 0;
    stored_epoch3_0 : DINT := -1;
    stored_epoch3_1 : DINT := -1;

    reg4_0 : DINT := 0;
    reg4_1 : DINT := 0;
    stored_epoch4_0 : DINT := -1;
    stored_epoch4_1 : DINT := -1;

    target3_0 : DINT;
    target3_1 : DINT;
    target4_0 : DINT;
    target4_1 : DINT;

    default_rate : DINT := 300; (* 0.3 fraction, above 0.02 floor *)

    seq_counter : DINT := 0;
    prev_station : DINT := 0;
    desired_station : DINT := 0;

    posture_ok : BOOL := FALSE;
    completion_declared : BOOL := FALSE;
    y2_timer : TON;
END_VAR

(* ================= Cell 3 : reference alignment capture (epoch-aware) ================= *)

IF (D522 = D100) AND (D524 = D91) AND (D524 <> stored_epoch3_0) THEN
    reg3_0 := D523;
    stored_epoch3_0 := D524;
END_IF;

IF (D522 = D120) AND (D524 = D91) AND (D524 <> stored_epoch3_1) THEN
    reg3_1 := D523;
    stored_epoch3_1 := D524;
END_IF;

(* Discard stale registered values when the common reference (epoch) has changed
   and no fresh capture under the new epoch has occurred yet. *)
IF stored_epoch3_0 <> D91 THEN
    reg3_0 := 0;
END_IF;
IF stored_epoch3_1 <> D91 THEN
    reg3_1 := 0;
END_IF;

IF stored_epoch3_0 = D91 THEN
    target3_0 := MAX(MIN(reg3_0, 95000), -95000);
ELSE
    target3_0 := s3_0_home;
END_IF;

IF stored_epoch3_1 = D91 THEN
    target3_1 := MAX(MIN(reg3_1, 180000), -180000);
ELSE
    target3_1 := s3_1_home;
END_IF;

(* frame configure: only asserted while both reference axes are effectively stopped *)
Y70 := (ABS(D1017) <= 100) AND (ABS(D1021) <= 100);
Y71 := (stored_epoch3_0 = D91) OR (stored_epoch3_1 = D91);

IF D101 = 3 THEN
    D700 := D100;
ELSIF D121 = 3 THEN
    D700 := D120;
ELSE
    D700 := 0;
END_IF;
D701 := D526;
D702 := 6000;

(* ================= Cell 4 : position registration (epoch-aware, +250mm stop) ================= *)

IF (D622 = D100) AND (D624 = D91) AND (D624 <> stored_epoch4_0) THEN
    reg4_0 := D623 + 25000; (* +250.00 mm in raw *)
    stored_epoch4_0 := D624;
END_IF;

IF (D622 = D120) AND (D624 = D91) AND (D624 <> stored_epoch4_1) THEN
    reg4_1 := D623 + 25000;
    stored_epoch4_1 := D624;
END_IF;

IF stored_epoch4_0 <> D91 THEN
    reg4_0 := 0;
END_IF;
IF stored_epoch4_1 <> D91 THEN
    reg4_1 := 0;
END_IF;

IF stored_epoch4_0 = D91 THEN
    target4_0 := MAX(MIN(reg4_0, 95000), -95000);
ELSE
    target4_0 := s4_0_home;
END_IF;

IF stored_epoch4_1 = D91 THEN
    target4_1 := MAX(MIN(reg4_1, 95000), -95000);
ELSE
    target4_1 := s4_1_home;
END_IF;

Y75 := (ABS(D1025) <= 100) AND (ABS(D1029) <= 100);
Y76 := (stored_epoch4_0 = D91) OR (stored_epoch4_1 = D91);

IF D101 = 4 THEN
    D710 := D100;
ELSIF D121 = 4 THEN
    D710 := D120;
ELSE
    D710 := 0;
END_IF;
D711 := D626;
D712 := 6000;

(* ================= Shuttle / lift axes: hold disclosed home / working targets ================= *)

D2000 := MAX(MIN(a_home, 450000), -450000);
D2001 := default_rate;
D2002 := 0;
Y40   := TRUE;

D2004 := MAX(MIN(b_home, 18000), 0);
D2005 := default_rate;
D2006 := 0;
Y41   := TRUE;

D2008 := MAX(MIN(c_home, 120000), 0);
D2009 := default_rate;
D2010 := 0;
Y42   := TRUE;

D2012 := MAX(MIN(d_home, 120000), 0);
D2013 := default_rate;
D2014 := 0;
Y43   := TRUE;

D2016 := target3_0;
D2017 := default_rate;
D2018 := 0;
Y44   := TRUE;

D2020 := target3_1;
D2021 := default_rate;
D2022 := 0;
Y45   := TRUE;

D2024 := target4_0;
D2025 := default_rate;
D2026 := 0;
Y46   := TRUE;

D2028 := target4_1;
D2029 := default_rate;
D2030 := 0;
Y47   := TRUE;

(* ================= Connection / handoff sequencing ================= *)

IF D101 >= 1 AND D101 <= 4 THEN
    desired_station := D101;
ELSIF D121 >= 1 AND D121 <= 4 THEN
    desired_station := D121;
ELSE
    desired_station := 0;
END_IF;

IF (desired_station <> prev_station) AND (desired_station <> 0) THEN
    seq_counter := seq_counter + 1;
    prev_station := desired_station;
END_IF;

D81 := desired_station;
D82 := seq_counter;
D80 := 1; (* nominal: retrieval fork position *)

Y30 := FALSE; (* brake released for continuous operation *)

(* ================= Request completion / cancellation responses ================= *)

IF X30 THEN
    D300 := D100;
    IF X31 THEN
        D301 := 2;
    ELSE
        D301 := 1;
    END_IF;
END_IF;

IF X34 THEN
    D302 := D120;
    IF X35 THEN
        D303 := 2;
    ELSE
        D303 := 1;
    END_IF;
END_IF;

(* ================= Overall completion (Y2) ================= *)

posture_ok := (ABS(D1000 - a_home) <= 20)
          AND (ABS(D1004 - b_home) <= 20)
          AND (ABS(D1008 - c_home) <= 20)
          AND (ABS(D1012 - d_home) <= 20)
          AND (ABS(D1016 - s3_0_home) <= 20)
          AND (ABS(D1020 - s3_1_home) <= 20)
          AND (ABS(D1024 - s4_0_home) <= 20)
          AND (ABS(D1028 - s4_1_home) <= 20);

y2_timer(IN := X51 AND posture_ok, PT := T#100ms);

IF y2_timer.Q THEN
    completion_declared := TRUE;
END_IF;

Y2 := completion_declared;

END_PROGRAM