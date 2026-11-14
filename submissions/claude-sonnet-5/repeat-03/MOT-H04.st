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

    (* ---- internal state ---- *)
    state       : INT := 0;
    state_prev  : INT := -1;
    active_req  : INT := -1;
    lift_station: DINT := 1;
    seq_no      : DINT := 0;

    req0_done   : BOOL := FALSE;
    req1_done   : BOOL := FALSE;
    last_ack_id0: DINT := 0;
    last_ack_id1: DINT := 0;

    settle_ton  : TON;
    y2_hold_ton : TON;

    pi_const    : REAL := 3.14159265358979;
    ang_rad     : REAL;
    ang_rad_act : REAL;
    cw_mm       : REAL;
    cw_raw      : DINT;
    moment_act  : REAL;
    x_act       : REAL;
    cond        : BOOL;
    port_ok     : BOOL;

    home_a  : DINT := 0;
    home_b  : DINT := 0;
    home_c  : DINT := 40000;
    home_d  : DINT := 40000;
    home_s30: DINT := 100000;
    home_s31: DINT := 0;
    home_s32: DINT := 0;
    home_s40: DINT := 0;
    home_s41: DINT := 0;

    sta1 : DINT := -405000;
    sta2 : DINT := -185000;
    sta3 : DINT :=   90000;
    sta4 : DINT :=  470000;

    pos_tol : DINT := 20;
    vel_tol : DINT := 100;

    a_tgt, b_tgt, c_tgt, d_tgt : DINT;
    s30_tgt, s31_tgt, s32_tgt  : DINT;
    s40_tgt, s41_tgt           : DINT;

    all_axes_home  : BOOL;
    completion_cond: BOOL;
    system_enable  : BOOL;
END_VAR

(* ---------- reset done flags when a genuinely new request id appears ---------- *)
IF (D100 <> 0) AND (D100 <> last_ack_id0) THEN
    req0_done := FALSE;
END_IF;
IF (D120 <> 0) AND (D120 <> last_ack_id1) THEN
    req1_done := FALSE;
END_IF;

(* ---------- default targets = home each scan, overridden below ---------- *)
a_tgt   := home_a;
b_tgt   := home_b;
c_tgt   := home_c;
d_tgt   := home_d;
s30_tgt := home_s30;
s31_tgt := home_s31;
s32_tgt := D1024; (* externally driven axis: never commanded away from actual *)
s40_tgt := home_s40;
s41_tgt := home_s41;

(* ---------- request selection / immediate cancellation ---------- *)
IF active_req = -1 THEN
    IF (X31) AND (D100 <> 0) AND (NOT req0_done) THEN
        D300 := D100; D301 := 2; req0_done := TRUE; last_ack_id0 := D100;
    ELSIF (X35) AND (D120 <> 0) AND (NOT req1_done) THEN
        D302 := D120; D303 := 2; req1_done := TRUE; last_ack_id1 := D120;
    ELSIF (D100 <> 0) AND (NOT req0_done) THEN
        active_req := 0;
        lift_station := LIMIT(1, D101, 2);
        state := 10;
    ELSIF (D120 <> 0) AND (NOT req1_done) THEN
        active_req := 1;
        lift_station := LIMIT(1, D121, 2);
        state := 10;
    END_IF;
END_IF;

(* ---------- sequence number bump on new connection action ---------- *)
IF state <> state_prev THEN
    CASE state OF
        20,40,60,80,100,120:
            seq_no := seq_no + 1;
            D82 := seq_no;
    ELSE
        ;
    END_CASE;
    state_prev := state;
END_IF;

cond := FALSE;

CASE state OF

10: (* move shuttle to origin lift *)
    a_tgt := SEL(lift_station = 2, sta1, sta2);
    cond := (ABS(D1000 - a_tgt) <= pos_tol) AND (ABS(D1001) <= vel_tol);
    settle_ton(IN := cond, PT := T#30ms);
    IF settle_ton.Q THEN
        state := 20;
    END_IF;

20: (* extract jig from lift *)
    D80 := 1; D81 := lift_station;
    IF lift_station = 1 THEN
        c_tgt := D92;
        port_ok := X61;
    ELSE
        d_tgt := D92;
        port_ok := X62;
    END_IF;
    b_tgt := 0;
    cond := (ABS(D1004 - b_tgt) <= pos_tol) AND (ABS(D1005) <= vel_tol) AND port_ok;
    settle_ton(IN := cond, PT := T#30ms);
    IF settle_ton.Q THEN
        state := 30;
    END_IF;

30: (* move to cell 3 *)
    a_tgt := sta3;
    cond := (ABS(D1000 - a_tgt) <= pos_tol) AND (ABS(D1001) <= vel_tol);
    settle_ton(IN := cond, PT := T#30ms);
    IF settle_ton.Q THEN
        state := 40;
    END_IF;

40: (* place into cell 3 *)
    D80 := 2; D81 := 3;
    b_tgt := 18000;
    cond := (ABS(D1004 - b_tgt) <= pos_tol) AND (ABS(D1005) <= vel_tol) AND X63;
    settle_ton(IN := cond, PT := T#30ms);
    IF settle_ton.Q THEN
        state := 50;
        Y70 := TRUE; Y71 := TRUE;
    END_IF;

50: (* cell 3 (hoist) process *)
    s30_tgt := LIMIT(50000, D500, 150000);
    D700 := D520;
    D701 := D526;
    D702 := LIMIT(-1000, DINT((D501 - D1020) / 50), 1000);
    cond := (ABS(D1016 - s30_tgt) <= pos_tol) AND (ABS(D1017) <= vel_tol)
            AND (ABS(D1020 - D501) <= pos_tol) AND (ABS(D1021) <= vel_tol)
            AND X70;
    settle_ton(IN := cond, PT := T#30ms);
    IF settle_ton.Q THEN
        state := 60;
        Y70 := FALSE; Y71 := FALSE; D702 := 0;
    END_IF;

60: (* extract from cell 3 *)
    D80 := 1; D81 := 3;
    b_tgt := 0;
    cond := (ABS(D1004 - b_tgt) <= pos_tol) AND (ABS(D1005) <= vel_tol) AND X63;
    settle_ton(IN := cond, PT := T#30ms);
    IF settle_ton.Q THEN
        state := 70;
    END_IF;

70: (* move to cell 4 *)
    a_tgt := sta4;
    cond := (ABS(D1000 - a_tgt) <= pos_tol) AND (ABS(D1001) <= vel_tol);
    settle_ton(IN := cond, PT := T#30ms);
    IF settle_ton.Q THEN
        state := 80;
    END_IF;

80: (* place into cell 4 *)
    D80 := 2; D81 := 4;
    b_tgt := 18000;
    cond := (ABS(D1004 - b_tgt) <= pos_tol) AND (ABS(D1005) <= vel_tol) AND X64;
    settle_ton(IN := cond, PT := T#30ms);
    IF settle_ton.Q THEN
        state := 90;
        Y75 := TRUE; Y76 := TRUE;
    END_IF;

90: (* cell 4 (counterbalance) process : moment-balanced target *)
    s40_tgt := LIMIT(-5000, D600, 5000);
    ang_rad := REAL(s40_tgt) * 0.01 * pi_const / 180.0;
    cw_mm   := -450.0 * SIN(ang_rad);
    cw_raw  := DINT(ROUND(cw_mm * 100.0));
    s41_tgt := LIMIT(-45000, cw_raw, 45000);
    D710 := D620;
    D711 := D626;
    D712 := 0;

    ang_rad_act := REAL(D1028) * 0.01 * pi_const / 180.0;
    x_act       := REAL(D1032) * 0.01;
    moment_act  := 0.1962 * (450.0 * SIN(ang_rad_act) + x_act);

    cond := (ABS(D1028 - s40_tgt) <= pos_tol) AND (ABS(D1029) <= vel_tol)
            AND (ABS(D1032 - s41_tgt) <= pos_tol) AND (ABS(D1033) <= vel_tol)
            AND (ABS(moment_act) <= 1.0)
            AND X75;
    settle_ton(IN := cond, PT := T#30ms);
    IF settle_ton.Q THEN
        state := 100;
        Y75 := FALSE; Y76 := FALSE;
    END_IF;

100: (* extract from cell 4 *)
    D80 := 1; D81 := 4;
    b_tgt := 0;
    cond := (ABS(D1004 - b_tgt) <= pos_tol) AND (ABS(D1005) <= vel_tol) AND X64;
    settle_ton(IN := cond, PT := T#30ms);
    IF settle_ton.Q THEN
        state := 110;
    END_IF;

110: (* return to origin lift *)
    a_tgt := SEL(lift_station = 2, sta1, sta2);
    cond := (ABS(D1000 - a_tgt) <= pos_tol) AND (ABS(D1001) <= vel_tol);
    settle_ton(IN := cond, PT := T#30ms);
    IF settle_ton.Q THEN
        state := 120;
    END_IF;

120: (* place back into lift *)
    D80 := 2; D81 := lift_station;
    IF lift_station = 1 THEN
        c_tgt := D92;
        port_ok := X61;
    ELSE
        d_tgt := D92;
        port_ok := X62;
    END_IF;
    b_tgt := 18000;
    cond := (ABS(D1004 - b_tgt) <= pos_tol) AND (ABS(D1005) <= vel_tol) AND port_ok;
    settle_ton(IN := cond, PT := T#30ms);
    IF settle_ton.Q THEN
        state := 130;
    END_IF;

130: (* respond to originating request *)
    IF active_req = 0 THEN
        D300 := D100;
        D301 := SEL(X31, 1, 2);
        req0_done := TRUE;
        last_ack_id0 := D100;
    ELSIF active_req = 1 THEN
        D302 := D120;
        D303 := SEL(X35, 1, 2);
        req1_done := TRUE;
        last_ack_id1 := D120;
    END_IF;
    active_req := -1;
    state := 0;

ELSE
    state := 0;
END_CASE;

(* ---------- clamp all targets to permitted command ranges ---------- *)
a_tgt   := LIMIT(-450000, a_tgt, 510000);
b_tgt   := LIMIT(0, b_tgt, 18000);
c_tgt   := LIMIT(0, c_tgt, 120000);
d_tgt   := LIMIT(0, d_tgt, 120000);
s30_tgt := LIMIT(50000, s30_tgt, 150000);
s31_tgt := LIMIT(-100000, s31_tgt, 100000);
s32_tgt := LIMIT(-3000, s32_tgt, 3000);
s40_tgt := LIMIT(-5000, s40_tgt, 5000);
s41_tgt := LIMIT(-45000, s41_tgt, 45000);

(* ---------- completion / home check ---------- *)
all_axes_home := (ABS(D1000 - home_a) <= pos_tol)
              AND (ABS(D1004 - home_b) <= pos_tol)
              AND (ABS(D1008 - home_c) <= pos_tol)
              AND (ABS(D1012 - home_d) <= pos_tol)
              AND (ABS(D1016 - home_s30) <= pos_tol)
              AND (ABS(D1020 - home_s31) <= pos_tol)
              AND (ABS(D1024 - home_s32) <= pos_tol)
              AND (ABS(D1028 - home_s40) <= pos_tol)
              AND (ABS(D1032 - home_s41) <= pos_tol);

completion_cond := X51 AND all_axes_home;
y2_hold_ton(IN := completion_cond, PT := T#100ms);
Y2 := y2_hold_ton.Q AND completion_cond;

(* ---------- enable / brake outputs ---------- *)
system_enable := NOT (state = 0 AND active_req = -1 AND all_axes_home);

Y40 := system_enable;
Y41 := system_enable;
Y42 := system_enable;
Y43 := system_enable;
Y44 := system_enable;
Y45 := FALSE; (* trolley driven via accel channel D702 *)
Y46 := FALSE; (* externally driven axis, never enabled by PLC *)
Y47 := system_enable;
Y48 := system_enable;

Y30 := NOT (state = 10 OR state = 30 OR state = 70 OR state = 110);

(* ---------- write axis command outputs ---------- *)
D2000 := a_tgt;   D2001 := 300; D2002 := 0;
D2004 := b_tgt;   D2005 := 300; D2006 := 0;
D2008 := c_tgt;   D2009 := 300; D2010 := 0;
D2012 := d_tgt;   D2013 := 300; D2014 := 0;
D2016 := s30_tgt; D2017 := 300; D2018 := 0;
D2020 := s31_tgt; D2021 := 0;   D2022 := 0;
D2024 := s32_tgt; D2025 := 0;   D2026 := 0;
D2028 := s40_tgt; D2029 := 300; D2030 := 0;
D2032 := s41_tgt; D2033 := 300; D2034 := 0;

END_PROGRAM