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
    D502 : DINT;
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

    (* ---- internal variables ---- *)
    homeA : DINT := 0;
    homeB : DINT := 0;
    homeC : DINT := 40000;
    homeD : DINT := 40000;
    homeS30 : DINT := 100000;
    homeS31 : DINT := 0;
    homeS40 : DINT := 0;
    homeS41 : DINT := 0;

    A_MIN : DINT := -450000;
    A_MAX : DINT := 510000;
    B_MIN : DINT := 0;
    B_MAX : DINT := 18000;
    C_MIN : DINT := 0;
    C_MAX : DINT := 120000;
    D_MIN : DINT := 0;
    D_MAX : DINT := 120000;
    S30_MIN : DINT := 50000;
    S30_MAX : DINT := 150000;
    S31_MIN : DINT := -100000;
    S31_MAX : DINT := 100000;
    S32_MIN : DINT := -3000;
    S32_MAX : DINT := 3000;
    S40_MIN : DINT := -5000;
    S40_MAX : DINT := 5000;
    S41_MIN : DINT := -45000;
    S41_MAX : DINT := 45000;

    cell3_active : BOOL;
    cell4_active : BOOL;
    liftActive : BOOL;

    tgt_a : DINT;
    tgt_b : DINT;
    tgt_c : DINT;
    tgt_d : DINT;
    tgt_s30 : DINT;
    tgt_s31 : DINT;
    tgt_s32 : DINT;
    tgt_s40 : DINT;
    tgt_s41 : DINT;

    desiredStation : DINT;
    prevStation : DINT := -1;
    seq_counter : DINT := 0;
    newTgtA : DINT;

    posTolRaw : DINT := 20;
    velTolRaw : DINT := 100;
    swayTolRaw : DINT := 3;
    swayVelTolRaw : DINT := 15;

    allAxesHome : BOOL;
    completeTimer : TON;
    y2_latched : BOOL;
END_VAR

(* ---------------- Cell 3 / Cell 4 active detection ---------------- *)
cell3_active := (D520 = 0) OR (D520 = 1);
cell4_active := (D620 = 0) OR (D620 = 1);

(* ---------------- Cell 3 axis commands ---------------- *)
IF cell3_active THEN
    tgt_s30 := MAX(S30_MIN, MIN(S30_MAX, D500));
    tgt_s31 := MAX(S31_MIN, MIN(S31_MAX, D501));
ELSE
    tgt_s30 := homeS30;
    tgt_s31 := homeS31;
END_IF;
tgt_s32 := MAX(S32_MIN, MIN(S32_MAX, D1024)); (* externally driven sway, no independent PLC axis *)

D2016 := tgt_s30; D2017 := 1000; D2018 := 0; Y44 := TRUE;
D2020 := tgt_s31; D2021 := 1000; D2022 := 0; Y45 := TRUE;
D2024 := tgt_s32; D2025 := 0;    D2026 := 0; Y46 := FALSE;

Y70 := cell3_active;
Y71 := cell3_active;
D700 := D520;
D701 := D526;
D702 := 500;

(* ---------------- Cell 4 axis commands ---------------- *)
IF cell4_active THEN
    tgt_s40 := MAX(S40_MIN, MIN(S40_MAX, D600));
    tgt_s41 := MAX(S41_MIN, MIN(S41_MAX, D601));
ELSE
    tgt_s40 := homeS40;
    tgt_s41 := homeS41;
END_IF;

D2028 := tgt_s40; D2029 := 1000; D2030 := 0; Y47 := TRUE;
D2032 := tgt_s41; D2033 := 1000; D2034 := 0; Y48 := TRUE;

Y75 := cell4_active;
Y76 := cell4_active;
D710 := D620;
D711 := D626;
D712 := 500;

(* ---------------- Determine desired shuttle station ---------------- *)
IF cell4_active THEN
    desiredStation := 4;
ELSIF cell3_active THEN
    desiredStation := 3;
ELSIF (D101 >= 1) AND (D101 <= 4) AND (NOT X30) AND (NOT X31) THEN
    desiredStation := D101;
ELSIF (D121 >= 1) AND (D121 <= 4) AND (NOT X34) AND (NOT X35) THEN
    desiredStation := D121;
ELSE
    desiredStation := 0;
END_IF;

(* ---------------- Shuttle target, guarded by fork-entry safety (<=40mm) ---------------- *)
IF D1004 <= 4000 THEN
    CASE desiredStation OF
        1: newTgtA := -405000;
        2: newTgtA := -185000;
        3: newTgtA := 90000;
        4: newTgtA := 470000;
    ELSE
        newTgtA := homeA;
    END_CASE;
    tgt_a := MAX(A_MIN, MIN(A_MAX, newTgtA));
END_IF;
(* else: freeze shuttle target while fork entry exceeds 40 mm *)

IF desiredStation <> prevStation THEN
    seq_counter := seq_counter + 1;
    prevStation := desiredStation;
END_IF;

(* ---------------- Connection fork target ---------------- *)
IF (ABS(D1000 - tgt_a) <= posTolRaw) AND (ABS(D1001) <= velTolRaw)
   AND (desiredStation >= 1) AND (desiredStation <= 4) THEN
    tgt_b := B_MAX;
ELSE
    tgt_b := 0;
END_IF;
tgt_b := MAX(B_MIN, MIN(B_MAX, tgt_b));

D80 := SEL(tgt_b = B_MAX, 1, 2);
D81 := desiredStation;
D82 := seq_counter;

(* ---------------- Lift targets (common lift frame, kept synchronized) ---------------- *)
liftActive := (D101 = 1) OR (D121 = 1);
IF liftActive THEN
    tgt_c := MAX(C_MIN, MIN(C_MAX, D92));
    tgt_d := tgt_c;
ELSE
    tgt_c := homeC;
    tgt_d := homeD;
END_IF;

D2000 := tgt_a; D2001 := 1000; D2002 := 0; Y40 := TRUE;
D2004 := tgt_b; D2005 := 1000; D2006 := 0; Y41 := TRUE;
D2008 := tgt_c; D2009 := 1000; D2010 := 0; Y42 := TRUE;
D2012 := tgt_d; D2013 := 1000; D2014 := 0; Y43 := TRUE;

(* ---------------- Brake ---------------- *)
Y30 := (ABS(D1000 - tgt_a) <= posTolRaw) AND (ABS(D1001) <= velTolRaw);

(* ---------------- Request acknowledgment ---------------- *)
IF X30 THEN
    D300 := D100; D301 := 1;
ELSIF X31 THEN
    D300 := D100; D301 := 2;
END_IF;

IF X34 THEN
    D302 := D120; D303 := 1;
ELSIF X35 THEN
    D302 := D120; D303 := 2;
END_IF;

(* ---------------- Completion condition ---------------- *)
allAxesHome :=
    (ABS(D1000 - homeA) <= posTolRaw) AND (ABS(D1001) <= velTolRaw) AND
    (ABS(D1004 - homeB) <= posTolRaw) AND (ABS(D1005) <= velTolRaw) AND
    (ABS(D1008 - homeC) <= posTolRaw) AND (ABS(D1009) <= velTolRaw) AND
    (ABS(D1012 - homeD) <= posTolRaw) AND (ABS(D1013) <= velTolRaw) AND
    (ABS(D1016 - homeS30) <= posTolRaw) AND (ABS(D1017) <= velTolRaw) AND
    (ABS(D1020 - homeS31) <= posTolRaw) AND (ABS(D1021) <= velTolRaw) AND
    (ABS(D1024) <= swayTolRaw) AND (ABS(D1025) <= swayVelTolRaw) AND
    (ABS(D1028 - homeS40) <= posTolRaw) AND (ABS(D1029) <= velTolRaw) AND
    (ABS(D1032 - homeS41) <= posTolRaw) AND (ABS(D1033) <= velTolRaw);

completeTimer(IN := (allAxesHome AND X51), PT := T#100ms);

IF completeTimer.Q THEN
    y2_latched := TRUE;
END_IF;

Y2 := y2_latched;

END_PROGRAM