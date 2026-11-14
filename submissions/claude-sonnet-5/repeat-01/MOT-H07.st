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
    D1036 : DINT;
    D1037 : DINT;
    D1040 : DINT;
    D1041 : DINT;
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
    D503 : DINT;
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
    D2036 : DINT;
    D2037 : DINT;
    D2038 : DINT;
    Y49 : BOOL;
    D2040 : DINT;
    D2041 : DINT;
    D2042 : DINT;
    Y50 : BOOL;
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
    lock_owner  : INT := 0;   (* 0 = free, 1 = channel0, 2 = channel1 *)
    last_id0    : DINT := 0;
    last_id1    : DINT := 0;
    cur_id      : DINT := 0;
    cur_location: DINT := 0;
    cur_cancel  : BOOL := FALSE;
    use_d       : BOOL := FALSE;

    (* persistent axis command state (raw x100 units) *)
    a_tgt  : DINT := 0;      a_en  : BOOL := FALSE;
    b_tgt  : DINT := 0;      b_en  : BOOL := FALSE;
    c_tgt  : DINT := 40000;  c_en  : BOOL := FALSE;
    d_tgt  : DINT := 40000;  d_en  : BOOL := FALSE;
    s30_tgt: DINT := -6500;  s30_en: BOOL := FALSE;
    s31_tgt: DINT := 0;      s31_en: BOOL := FALSE;
    s32_tgt: DINT := 6500;   s32_en: BOOL := FALSE;
    s33_tgt: DINT := 0;      s33_en: BOOL := FALSE;
    s40_tgt: DINT := -65000; s40_en: BOOL := FALSE;
    s41_tgt: DINT := 65000;  s41_en: BOOL := FALSE;
    s42_tgt: DINT := 0;      s42_en: BOOL := FALSE;

    tol_pos : DINT := 20;
    tol_vel : DINT := 100;

    a_ok, b_ok, c_ok, d_ok               : BOOL;
    s30_ok, s31_ok, s32_ok, s33_ok       : BOOL;
    s40_ok, s41_ok, s42_ok               : BOOL;
    lift_ok                              : BOOL;
    home_ok                              : BOOL;

    nominal1 : DINT := -405000;
    nominal2 : DINT := -185000;
    nominal3 : DINT := 0;
    nominal4 : DINT := 670000;
    nominal_src : DINT := 0;
    lift_target : DINT := 0;

    arrived_tmr : TON;
    y2_tmr      : TON;
END_VAR

(* ---------- compute arrival flags from current feedback ---------- *)
a_ok   := (ABS(D1000 - a_tgt)   <= tol_pos) AND (ABS(D1001) <= tol_vel);
b_ok   := (ABS(D1004 - b_tgt)   <= tol_pos) AND (ABS(D1005) <= tol_vel);
c_ok   := (ABS(D1008 - c_tgt)   <= tol_pos) AND (ABS(D1009) <= tol_vel);
d_ok   := (ABS(D1012 - d_tgt)   <= tol_pos) AND (ABS(D1013) <= tol_vel);
s30_ok := (ABS(D1016 - s30_tgt) <= tol_pos) AND (ABS(D1017) <= tol_vel);
s31_ok := (ABS(D1020 - s31_tgt) <= tol_pos) AND (ABS(D1021) <= tol_vel);
s32_ok := (ABS(D1024 - s32_tgt) <= tol_pos) AND (ABS(D1025) <= tol_vel);
s33_ok := (ABS(D1028 - s33_tgt) <= tol_pos) AND (ABS(D1029) <= tol_vel);
s40_ok := (ABS(D1032 - s40_tgt) <= tol_pos) AND (ABS(D1033) <= tol_vel);
s41_ok := (ABS(D1036 - s41_tgt) <= tol_pos) AND (ABS(D1037) <= tol_vel);
s42_ok := (ABS(D1040 - s42_tgt) <= tol_pos) AND (ABS(D1041) <= tol_vel);

IF use_d THEN
    lift_ok := d_ok;
ELSE
    lift_ok := c_ok;
END_IF;

(* ---------- default output housekeeping ---------- *)
D80 := 0;
D81 := 0;
Y70 := FALSE;
Y71 := FALSE;
Y75 := FALSE;
Y76 := FALSE;
D700 := 0; D701 := 0; D702 := 0;
D710 := 0; D711 := 0; D712 := 0;

(* ================= main state machine ================= *)
CASE state OF

0: (* idle : arbitrate new requests or finalize *)
    IF X51 THEN
        state := 100;
    ELSE
        IF lock_owner = 0 THEN
            IF (D100 <> 0) AND (D100 <> last_id0) THEN
                lock_owner   := 1;
                cur_id       := D100;
                cur_location := D101;
                cur_cancel   := X31;
                D82          := D82 + 1;
                state        := 2;
            ELSIF (D120 <> 0) AND (D120 <> last_id1) THEN
                lock_owner   := 2;
                cur_id       := D120;
                cur_location := D121;
                cur_cancel   := X35;
                D82          := D82 + 1;
                state        := 2;
            END_IF;
        END_IF;
    END_IF;

2: (* check cancel *)
    IF cur_location = 2 THEN
        use_d := TRUE;
    ELSE
        use_d := FALSE;
    END_IF;
    IF cur_location = 1 THEN
        nominal_src := nominal1;
    ELSIF cur_location = 2 THEN
        nominal_src := nominal2;
    ELSE
        nominal_src := nominal1;
    END_IF;
    IF cur_cancel THEN
        state := 90;
    ELSE
        state := 5;
    END_IF;

5: (* raise source lift for pickup *)
    lift_target := LIMIT(0, D92, 120000);
    IF use_d THEN
        d_tgt := lift_target; d_en := TRUE; c_en := FALSE;
    ELSE
        c_tgt := lift_target; c_en := TRUE; d_en := FALSE;
    END_IF;
    arrived_tmr(IN := lift_ok, PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 6;
    END_IF;

6: (* connect fork at source *)
    b_tgt := 18000; b_en := TRUE;
    D80 := 2; D81 := cur_location;
    arrived_tmr(IN := b_ok, PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 7;
    END_IF;

7: (* retrieve fork at source, jig on shuttle *)
    b_tgt := 0; b_en := TRUE;
    D80 := 1; D81 := cur_location;
    arrived_tmr(IN := b_ok, PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 8;
    END_IF;

8: (* lower source lift, free it *)
    IF use_d THEN
        d_tgt := 40000; d_en := TRUE;
    ELSE
        c_tgt := 40000; c_en := TRUE;
    END_IF;
    arrived_tmr(IN := lift_ok, PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 9;
    END_IF;

9: (* shuttle to cell3 *)
    a_tgt := nominal3; a_en := TRUE;
    arrived_tmr(IN := a_ok, PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 10;
    END_IF;

10: (* connect fork at cell3 *)
    b_tgt := 18000; b_en := TRUE;
    D80 := 2; D81 := 3;
    arrived_tmr(IN := b_ok, PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 11;
    END_IF;

11: (* boom retract before swivel *)
    s31_tgt := 0; s31_en := TRUE;
    s33_tgt := 0; s33_en := TRUE;
    arrived_tmr(IN := (s31_ok AND s33_ok), PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 12;
    END_IF;

12: (* boom rotate to goal angles *)
    s30_tgt := LIMIT(-9000, D500, 9000); s30_en := TRUE;
    s32_tgt := LIMIT(-9000, D502, 9000); s32_en := TRUE;
    arrived_tmr(IN := (s30_ok AND s32_ok), PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 13;
    END_IF;

13: (* boom extend to goal lengths *)
    s31_tgt := LIMIT(0, D501, 65000); s31_en := TRUE;
    s33_tgt := LIMIT(0, D503, 65000); s33_en := TRUE;
    arrived_tmr(IN := (s31_ok AND s33_ok), PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 14;
    END_IF;

14: (* configure & wait cell3 served *)
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := cur_id;
    D701 := D526;
    D702 := 500;
    IF X70 THEN
        state := 15;
    END_IF;

15: (* boom return: retract *)
    s31_tgt := 0; s31_en := TRUE;
    s33_tgt := 0; s33_en := TRUE;
    arrived_tmr(IN := (s31_ok AND s33_ok), PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 16;
    END_IF;

16: (* boom return: rotate home *)
    s30_tgt := -6500; s30_en := TRUE;
    s32_tgt := 6500;  s32_en := TRUE;
    arrived_tmr(IN := (s30_ok AND s32_ok), PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 17;
    END_IF;

17: (* retrieve fork at cell3 *)
    b_tgt := 0; b_en := TRUE;
    D80 := 1; D81 := 3;
    arrived_tmr(IN := b_ok, PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 18;
    END_IF;

18: (* shuttle to cell4 *)
    a_tgt := nominal4; a_en := TRUE;
    arrived_tmr(IN := a_ok, PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 19;
    END_IF;

19: (* connect fork at cell4 *)
    b_tgt := 18000; b_en := TRUE;
    D80 := 2; D81 := 4;
    arrived_tmr(IN := b_ok, PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 20;
    END_IF;

20: (* exchange head move to goals *)
    s40_tgt := LIMIT(-90000, D600, 90000); s40_en := TRUE;
    s41_tgt := LIMIT(-90000, D601, 90000); s41_en := TRUE;
    s42_tgt := LIMIT(0, D602, 35000);      s42_en := TRUE;
    arrived_tmr(IN := (s40_ok AND s41_ok AND s42_ok), PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 21;
    END_IF;

21: (* configure & wait cell4 served *)
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := cur_id;
    D711 := D626;
    D712 := 500;
    IF X75 THEN
        state := 22;
    END_IF;

22: (* exchange return home *)
    s40_tgt := -65000; s40_en := TRUE;
    s41_tgt := 65000;  s41_en := TRUE;
    s42_tgt := 0;      s42_en := TRUE;
    arrived_tmr(IN := (s40_ok AND s41_ok AND s42_ok), PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 23;
    END_IF;

23: (* retrieve fork at cell4 *)
    b_tgt := 0; b_en := TRUE;
    D80 := 1; D81 := 4;
    arrived_tmr(IN := b_ok, PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 24;
    END_IF;

24: (* shuttle back to source *)
    a_tgt := nominal_src; a_en := TRUE;
    arrived_tmr(IN := a_ok, PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 25;
    END_IF;

25: (* raise source lift for deposit *)
    lift_target := LIMIT(0, D92, 120000);
    IF use_d THEN
        d_tgt := lift_target; d_en := TRUE;
    ELSE
        c_tgt := lift_target; c_en := TRUE;
    END_IF;
    arrived_tmr(IN := lift_ok, PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 26;
    END_IF;

26: (* connect fork to deposit *)
    b_tgt := 18000; b_en := TRUE;
    D80 := 2; D81 := cur_location;
    arrived_tmr(IN := b_ok, PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 27;
    END_IF;

27: (* retrieve fork, jig now on lift *)
    b_tgt := 0; b_en := TRUE;
    D80 := 1; D81 := cur_location;
    arrived_tmr(IN := b_ok, PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 28;
    END_IF;

28: (* lower lift to initial (home) height *)
    IF use_d THEN
        d_tgt := 40000; d_en := TRUE;
    ELSE
        c_tgt := 40000; c_en := TRUE;
    END_IF;
    arrived_tmr(IN := lift_ok, PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 29;
    END_IF;

29: (* wait for returned confirmation then respond *)
    IF (lock_owner = 1) AND X30 THEN
        D300 := cur_id;
        D301 := 1;
        state := 30;
    ELSIF (lock_owner = 2) AND X34 THEN
        D302 := cur_id;
        D303 := 1;
        state := 30;
    END_IF;

30: (* release lock, ready for next *)
    IF lock_owner = 1 THEN
        last_id0 := cur_id;
    ELSIF lock_owner = 2 THEN
        last_id1 := cur_id;
    END_IF;
    a_en := FALSE; b_en := FALSE; c_en := FALSE; d_en := FALSE;
    s30_en := FALSE; s31_en := FALSE; s32_en := FALSE; s33_en := FALSE;
    s40_en := FALSE; s41_en := FALSE; s42_en := FALSE;
    lock_owner := 0;
    state := 0;

90: (* cancellation retrieval - nothing has moved, respond immediately *)
    IF (lock_owner = 1) AND X30 THEN
        D300 := cur_id;
        D301 := 2;
        state := 30;
    ELSIF (lock_owner = 2) AND X34 THEN
        D302 := cur_id;
        D303 := 2;
        state := 30;
    ELSIF (lock_owner = 1) THEN
        D300 := cur_id; D301 := 2; state := 30;
    ELSIF (lock_owner = 2) THEN
        D302 := cur_id; D303 := 2; state := 30;
    END_IF;

100: (* finalize: bring shuttle & fork home *)
    a_tgt := 0; a_en := TRUE;
    b_tgt := 0; b_en := TRUE;
    c_tgt := 40000; c_en := TRUE;
    d_tgt := 40000; d_en := TRUE;
    s30_tgt := -6500; s30_en := TRUE;
    s31_tgt := 0;     s31_en := TRUE;
    s32_tgt := 6500;  s32_en := TRUE;
    s33_tgt := 0;     s33_en := TRUE;
    s40_tgt := -65000; s40_en := TRUE;
    s41_tgt := 65000;  s41_en := TRUE;
    s42_tgt := 0;      s42_en := TRUE;
    arrived_tmr(IN := (a_ok AND b_ok AND c_ok AND d_ok), PT := T#30ms);
    IF arrived_tmr.Q THEN
        state := 101;
    END_IF;

101: (* hold home for 100 ms then declare completion *)
    a_tgt := 0; a_en := TRUE;
    b_tgt := 0; b_en := TRUE;
    c_tgt := 40000; c_en := TRUE;
    d_tgt := 40000; d_en := TRUE;
    s30_tgt := -6500; s30_en := TRUE;
    s31_tgt := 0;     s31_en := TRUE;
    s32_tgt := 6500;  s32_en := TRUE;
    s33_tgt := 0;     s33_en := TRUE;
    s40_tgt := -65000; s40_en := TRUE;
    s41_tgt := 65000;  s41_en := TRUE;
    s42_tgt := 0;      s42_en := TRUE;

    home_ok := a_ok AND b_ok AND c_ok AND d_ok AND
               s30_ok AND s31_ok AND s32_ok AND s33_ok AND
               s40_ok AND s41_ok AND s42_ok;

    y2_tmr(IN := home_ok, PT := T#100ms);
    IF y2_tmr.Q THEN
        Y2 := TRUE;
        state := 102;
    ELSE
        Y2 := FALSE;
    END_IF;

102: (* completion maintained *)
    a_tgt := 0; a_en := TRUE;
    b_tgt := 0; b_en := TRUE;
    c_tgt := 40000; c_en := TRUE;
    d_tgt := 40000; d_en := TRUE;
    s30_tgt := -6500; s30_en := TRUE;
    s31_tgt := 0;     s31_en := TRUE;
    s32_tgt := 6500;  s32_en := TRUE;
    s33_tgt := 0;     s33_en := TRUE;
    s40_tgt := -65000; s40_en := TRUE;
    s41_tgt := 65000;  s41_en := TRUE;
    s42_tgt := 0;      s42_en := TRUE;
    Y2 := TRUE;

ELSE
    state := 0;
END_CASE;

(* ---------- write physical outputs from persistent command state ---------- *)
D2000 := a_tgt;   D2001 := SEL(a_en, 0, 1000);   D2002 := 0; Y40 := a_en;
D2004 := b_tgt;   D2005 := SEL(b_en, 0, 1000);   D2006 := 0; Y41 := b_en;
D2008 := c_tgt;   D2009 := SEL(c_en, 0, 1000);   D2010 := 0; Y42 := c_en;
D2012 := d_tgt;   D2013 := SEL(d_en, 0, 1000);   D2014 := 0; Y43 := d_en;
D2016 := s30_tgt; D2017 := SEL(s30_en, 0, 1000); D2018 := 0; Y44 := s30_en;
D2020 := s31_tgt; D2021 := SEL(s31_en, 0, 1000); D2022 := 0; Y45 := s31_en;
D2024 := s32_tgt; D2025 := SEL(s32_en, 0, 1000); D2026 := 0; Y46 := s32_en;
D2028 := s33_tgt; D2029 := SEL(s33_en, 0, 1000); D2030 := 0; Y47 := s33_en;
D2032 := s40_tgt; D2033 := SEL(s40_en, 0, 1000); D2034 := 0; Y48 := s40_en;
D2036 := s41_tgt; D2037 := SEL(s41_en, 0, 1000); D2038 := 0; Y49 := s41_en;
D2040 := s42_tgt; D2041 := SEL(s42_en, 0, 1000); D2042 := 0; Y50 := s42_en;

Y30 := NOT a_en;

END_PROGRAM