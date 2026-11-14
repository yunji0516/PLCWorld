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

    (* ---------- internal variables ---------- *)
    motor_needed     : BOOL;
    cell4_engaged    : BOOL;
    all_parked       : BOOL;
    completion_ready : BOOL;
    y2_declared      : BOOL;
    scan_count       : DINT;

    prev_cap3        : DINT;
    prev_cap4        : DINT;
    seq              : DINT;

    (* synchronization observation (cell 4 gear cell) *)
    ang_err0         : DINT;
    ang_err1         : DINT;
    spd_err0         : DINT;
    spd_err1         : DINT;
    master_moving    : BOOL;
    sync_ok_now      : BOOL;
    sync_established : BOOL;
    sync4_timer      : TON;

    y2_hold          : TON;
    r0_ret_trig      : R_TRIG;
    r1_ret_trig      : R_TRIG;

    accel_fixed_m3   : DINT := 20000;   (* 200.00 deg/s^2, finite ramp for common motor *)
    accel_fixed_m4   : DINT := 20000;   (* 200.00 deg/s^2, finite ramp for cell4 *)
    home_c           : DINT := 40000;   (* 400.00 mm *)
    home_d           : DINT := 40000;   (* 400.00 mm *)
END_VAR

(* ================= scan bookkeeping ================= *)
IF scan_count < 2000000000 THEN
    scan_count := scan_count + 1;
END_IF;

(* ================= shared shuttle / lift park defaults ================= *)
(* This task owns the rotation/sync section; a/b/c/d are held at their
   disclosed home / initial connection posture as safe defaults. *)
D2000 := 0;      D2001 := 1000;  D2002 := 0;  Y40 := TRUE;
D2004 := 0;      D2005 := 1000;  D2006 := 0;  Y41 := TRUE;
D2008 := home_c; D2009 := 1000;  D2010 := 0;  Y42 := TRUE;
D2012 := home_d; D2013 := 1000;  D2014 := 0;  Y43 := TRUE;

(* keep both lift axes referenced to the same target to respect the
   80 mm max height-difference safety constraint *)

(* ================= Cell 3: common rotation drive (master) ================= *)
(* The receiving fixture axes (s3_1, s3_2) stay at home so docking
   conditions are always satisfied and the >40 mm fork-entry motion
   prohibition can never be violated. *)
D2020 := 0; D2021 := 1000; D2022 := 0; Y45 := TRUE;
D2024 := 0; D2025 := 1000; D2026 := 0; Y46 := TRUE;

(* The common motor (s3_0) is not driven through target/rate/ff; it is
   controlled only through configure/retain/select/route/accel per the
   published behavior. It must run whenever anything downstream still
   needs it and must be stopped only for final completion. *)
motor_needed := NOT X51;

Y70  := FALSE;         (* cell 3 is master, not a gear-follow cell *)
Y71  := motor_needed;  (* retain -> finite ramp to 200 deg/s *)
D700 := 0;
D701 := D526;          (* pass through requested route *)
D702 := accel_fixed_m3;
D2016 := 0; D2017 := 0; D2018 := 0;  (* unused for the common motor *)
Y44  := TRUE;                        (* keep torque loop enabled *)

(* common brake: only close once the motor is not needed AND actually
   near standstill, to avoid ever braking a moving shaft *)
Y30 := (NOT motor_needed) AND (ABS(D1017) <= 100);

(* ================= Cell 4: rotation synchronization section (gear) ============ *)
cell4_engaged := (D622 <> 0) AND (NOT X75) AND (NOT X76);

Y75  := cell4_engaged;   (* electronic gear follows master at select/1000 *)
Y76  := cell4_engaged;
D710 := 1000;            (* 1:1 ratio to the common master *)
D711 := D626;
D712 := accel_fixed_m4;

(* Independent axis command that pulls the cell-4 axes home whenever the
   gear is not actively engaged for a live, non-cancelled request. While
   engaged, the electronic gear drives position from the master. *)
D2028 := 0; D2029 := 1000; D2030 := 0; Y47 := TRUE;
D2032 := 0; D2033 := 1000; D2034 := 0; Y48 := TRUE;

(* ---- synchronization observation (not gating outputs, kept for
   internal consistency with the published tolerances) ---- *)
master_moving := ABS(D1017) > 100;  (* > 1.00 deg/s *)

ang_err0 := D1028 - D600;
IF ang_err0 < 0 THEN ang_err0 := -ang_err0; END_IF;
ang_err1 := D1032 - D601;
IF ang_err1 < 0 THEN ang_err1 := -ang_err1; END_IF;
spd_err0 := D1029;
IF spd_err0 < 0 THEN spd_err0 := -spd_err0; END_IF;
spd_err1 := D1033;
IF spd_err1 < 0 THEN spd_err1 := -spd_err1; END_IF;

sync_ok_now := cell4_engaged AND master_moving
               AND (ang_err0 <= 20) AND (ang_err1 <= 20)
               AND (spd_err0 <= 100) AND (spd_err1 <= 100);

sync4_timer(IN := sync_ok_now, PT := T#50ms);
IF sync4_timer.Q THEN
    sync_established := TRUE;
END_IF;
IF (NOT cell4_engaged) THEN
    sync_established := FALSE;
END_IF;

(* ================= Requests / ownership: acknowledgment ================= *)
r0_ret_trig(CLK := X30);
IF r0_ret_trig.Q THEN
    D300 := D100;
    IF X31 THEN
        D301 := 2;
    ELSE
        D301 := 1;
    END_IF;
END_IF;

r1_ret_trig(CLK := X34);
IF r1_ret_trig.Q THEN
    D302 := D120;
    IF X35 THEN
        D303 := 2;
    ELSE
        D303 := 1;
    END_IF;
END_IF;

(* ================= Connection / handoff sequencing ================= *)
IF D522 <> prev_cap3 THEN
    seq := seq + 1;
    D82 := seq;
    D81 := 3;
    IF D522 <> 0 THEN
        D80 := 2;   (* placement into cell 3 *)
    ELSE
        D80 := 1;   (* extraction from cell 3 *)
    END_IF;
    prev_cap3 := D522;
END_IF;

IF D622 <> prev_cap4 THEN
    seq := seq + 1;
    D82 := seq;
    D81 := 4;
    IF D622 <> 0 THEN
        D80 := 2;   (* placement into cell 4 *)
    ELSE
        D80 := 1;   (* extraction from cell 4 *)
    END_IF;
    prev_cap4 := D622;
END_IF;

(* ================= Final completion (Y2) ================= *)
all_parked :=
    (ABS(D1000) <= 20)            AND (ABS(D1001) <= 100)  AND
    (ABS(D1004) <= 20)            AND (ABS(D1005) <= 100)  AND
    (ABS(D1008 - home_c) <= 20)   AND (ABS(D1009) <= 100)  AND
    (ABS(D1012 - home_d) <= 20)   AND (ABS(D1013) <= 100)  AND
    (ABS(D1017) <= 100)                                    AND (* s3_0: speed only, position excluded from origin check *)
    (ABS(D1020) <= 20)            AND (ABS(D1021) <= 100)  AND
    (ABS(D1024) <= 20)            AND (ABS(D1025) <= 100)  AND
    (ABS(D1028) <= 20)            AND (ABS(D1029) <= 100)  AND
    (ABS(D1032) <= 20)            AND (ABS(D1033) <= 100);

completion_ready := X51 AND all_parked;

y2_hold(IN := completion_ready, PT := T#100ms);

IF (NOT y2_declared) AND completion_ready AND (scan_count <= 16000) THEN
    y2_declared := TRUE;
END_IF;

Y2 := y2_declared;

END_PROGRAM