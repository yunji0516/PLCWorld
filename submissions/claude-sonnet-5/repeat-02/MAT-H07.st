PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
    Y28 : BOOL;
    Y29 : BOOL;

    (* --- internal state --- *)
    step : DINT := 0;
    roll_idx : DINT := 0;

    a_accepted : BOOL := FALSE;
    b_accepted : BOOL := FALSE;
    b_trim_started : BOOL := FALSE;
    leader_ready : BOOL := FALSE;
    active_roll : BOOL := FALSE;
    core_count : DINT := 0;

    accept_roll_pulsed : BOOL := FALSE;
    cut_pulsed : BOOL := FALSE;
    tape_cut_pulsed : BOOL := FALSE;
    tape_apply_pulsed : BOOL := FALSE;
    eject_pulsed : BOOL := FALSE;
    ack_exit_pulsed : BOOL := FALSE;

    completion_latched : BOOL := FALSE;

    jog_time : TIME := T#0ms;
    t_jog_b : TON;

    want_accept_a : BOOL := FALSE;
    want_accept_b : BOOL := FALSE;
    want_trim_b : BOOL := FALSE;
    want_ack_trim : BOOL := FALSE;
    want_accept_roll : BOOL := FALSE;
    want_cut_a : BOOL := FALSE;
    want_cut_b : BOOL := FALSE;
    want_eject : BOOL := FALSE;
    want_ack_exit : BOOL := FALSE;
    want_tape_cut : BOOL := FALSE;
    want_tape_apply : BOOL := FALSE;

    trig_accept_a : R_TRIG;
    trig_accept_b : R_TRIG;
    trig_trim_b : R_TRIG;
    trig_ack_trim : R_TRIG;
    trig_accept_roll : R_TRIG;
    trig_cut_a : R_TRIG;
    trig_cut_b : R_TRIG;
    trig_eject : R_TRIG;
    trig_ack_exit : R_TRIG;
    trig_tape_cut : R_TRIG;
    trig_tape_apply : R_TRIG;

    diff_i : INT;
END_VAR

(* reset one-shot request flags every scan; only the active case branch sets them *)
want_accept_a := FALSE;
want_accept_b := FALSE;
want_trim_b := FALSE;
want_ack_trim := FALSE;
want_accept_roll := FALSE;
want_cut_a := FALSE;
want_cut_b := FALSE;
want_eject := FALSE;
want_ack_exit := FALSE;
want_tape_cut := FALSE;
want_tape_apply := FALSE;

IF NOT X0 AND step = 0 THEN
    ; (* wait *)
END_IF;

CASE step OF

0: (* wait start *)
    IF X0 THEN
        step := 10;
    END_IF;

10: (* accept A and B webs, order free *)
    want_accept_a := X10 AND NOT a_accepted;
    want_accept_b := X11 AND NOT b_accepted;
    IF a_accepted THEN
        Y12 := TRUE; (* hold_a leader clamp, kept on until release *)
    END_IF;
    IF X12 AND X13 THEN
        step := 20;
    END_IF;

20: (* jog B to origin_b *)
    IF jog_time = T#0ms THEN
        jog_time := INT_TO_TIME(D0 * 10); (* 100 mm/s -> 10 ms per mm *)
    END_IF;
    Y14 := TRUE;
    t_jog_b(IN := TRUE, PT := jog_time);
    IF t_jog_b.Q THEN
        Y14 := FALSE;
        Y13 := TRUE; (* engage hold_b for contact *)
        step := 21;
    END_IF;

21: (* wait actual holder contact both sides *)
    IF X14 AND X15 THEN
        step := 22;
    END_IF;

22: (* trim leader on B *)
    want_trim_b := (NOT b_trim_started) AND X15 AND X14 AND (D0 > 0);
    IF X16 AND X17 THEN
        step := 23;
    END_IF;

23: (* ack trim, only after trim_received *)
    want_ack_trim := X17 AND X16;
    IF trig_ack_trim.Q THEN
        leader_ready := TRUE;
    END_IF;
    IF leader_ready THEN
        step := 30;
    END_IF;

30: (* feed next core *)
    IF NOT X1A THEN
        Y23 := TRUE;
    END_IF;
    IF X2C THEN
        Y23 := FALSE;
        Y24 := TRUE; (* close stop jaw *)
        step := 31;
    END_IF;

31: (* wait core seated & stop closed *)
    IF X2D AND X2E THEN
        step := 32;
    END_IF;

32: (* accept roll (new core) *)
    want_accept_roll := (NOT accept_roll_pulsed) AND (NOT active_roll)
                         AND (core_count < 3) AND X1D AND leader_ready
                         AND X2D AND X2E;
    IF trig_accept_roll.Q THEN
        accept_roll_pulsed := TRUE;
        Y24 := FALSE; (* retract stop jaw after core taken *)
        active_roll := TRUE;
        core_count := core_count + 1;
    END_IF;
    IF accept_roll_pulsed AND X18 AND X19 THEN
        step := 33;
    END_IF;

33: (* extend mandrel to take shaft support *)
    IF active_roll AND (NOT X1A) THEN
        Y1F := TRUE;
    END_IF;
    IF X1E THEN
        Y1F := FALSE;
        step := 34;
    END_IF;

34: (* loading support descends *)
    Y1B := TRUE;
    IF X1F THEN
        step := 35;
    END_IF;

35: (* leader path winding with holder clamp, 250 mm *)
    Y12 := TRUE;
    Y13 := TRUE;
    IF active_roll AND X1E AND (X14 OR X1B) THEN
        Y1A := TRUE;
    END_IF;
    IF D6 >= 250 THEN
        Y18 := TRUE;
        Y19 := TRUE;
        step := 36;
    END_IF;

36: (* wait nip contact, release holders *)
    IF X1B AND X1C THEN
        Y12 := FALSE;
        Y13 := FALSE;
        step := 37;
    END_IF;

37: (* main winding to target +-2mm *)
    diff_i := D5 - D4;
    IF diff_i < 0 THEN
        diff_i := -diff_i;
    END_IF;
    IF active_roll AND X1E AND (X1B AND X1C) THEN
        Y1A := TRUE;
    END_IF;
    IF diff_i <= 2 THEN
        Y1A := FALSE;
        Y12 := TRUE;
        Y13 := TRUE;
        step := 38;
    END_IF;

38: (* wait holder contact for cutting *)
    IF X14 AND X15 THEN
        step := 39;
    END_IF;

39: (* cut both webs *)
    want_cut_a := (NOT cut_pulsed) AND X14 AND X15 AND (NOT X27);
    want_cut_b := (NOT cut_pulsed) AND X14 AND X15 AND (NOT X27);
    IF trig_cut_a.Q OR trig_cut_b.Q THEN
        cut_pulsed := TRUE;
    END_IF;
    IF cut_pulsed AND X27 AND X28 THEN
        step := 40;
    END_IF;

40: (* wind remaining tail without new supply *)
    IF active_roll AND X27 THEN
        Y1A := TRUE;
    END_IF;
    IF X26 THEN
        Y1A := FALSE;
        step := 41;
    END_IF;

41: (* prepare tape 80mm *)
    IF (NOT X32) AND (D9 >= 80) THEN
        Y25 := TRUE;
    END_IF;
    IF X2F THEN
        Y25 := FALSE;
        Y26 := TRUE;
        step := 42;
    END_IF;

42: (* tape hold contact *)
    IF X30 THEN
        step := 43;
    END_IF;

43: (* tape cut *)
    want_tape_cut := (NOT tape_cut_pulsed) AND X2F AND X30;
    IF trig_tape_cut.Q THEN
        tape_cut_pulsed := TRUE;
    END_IF;
    IF tape_cut_pulsed AND X31 THEN
        step := 44;
    END_IF;

44: (* tape apply on tail *)
    diff_i := D5 - D4;
    IF diff_i < 0 THEN
        diff_i := -diff_i;
    END_IF;
    want_tape_apply := (NOT tape_apply_pulsed) AND (NOT X32) AND active_roll
                        AND X1E AND (diff_i <= 2) AND X26 AND X27
                        AND (NOT Y1A) AND X14 AND X15;
    IF trig_tape_apply.Q THEN
        tape_apply_pulsed := TRUE;
    END_IF;
    IF tape_apply_pulsed AND X33 THEN
        Y26 := FALSE;
        step := 45;
    END_IF;

45: (* release holders and nips before mandrel retract *)
    Y12 := FALSE;
    Y13 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    IF X24 AND X25 THEN
        step := 46;
    END_IF;

46: (* retract mandrel: only when both connections released, support present, tape ok *)
    IF X27 AND X28 AND X1F AND X33 AND (NOT X32) AND X24 AND X25 THEN
        Y1E := TRUE;
    END_IF;
    IF X1D THEN
        Y1E := FALSE;
        step := 47;
    END_IF;

47: (* eject the finished roll *)
    want_eject := (NOT eject_pulsed) AND X1D AND X1F AND X26 AND X27;
    IF trig_eject.Q THEN
        eject_pulsed := TRUE;
    END_IF;
    IF eject_pulsed AND X20 THEN
        Y1B := FALSE; (* cradle returns first *)
        step := 48;
    END_IF;

48: (* wait exit ready, release pusher *)
    IF X34 AND X35 AND (NOT X21) THEN
        Y29 := TRUE;
    END_IF;
    IF X22 THEN
        Y29 := FALSE;
        step := 49;
    END_IF;

49: (* ack the exit, close out this roll *)
    want_ack_exit := (NOT ack_exit_pulsed) AND X22;
    IF trig_ack_exit.Q THEN
        ack_exit_pulsed := TRUE;
    END_IF;
    IF ack_exit_pulsed THEN
        active_roll := FALSE;
        accept_roll_pulsed := FALSE;
        cut_pulsed := FALSE;
        tape_cut_pulsed := FALSE;
        tape_apply_pulsed := FALSE;
        eject_pulsed := FALSE;
        ack_exit_pulsed := FALSE;
        roll_idx := roll_idx + 1;
        IF roll_idx < 3 THEN
            step := 30;
        ELSE
            step := 50;
        END_IF;
    END_IF;

50: (* completion hold *)
    completion_latched := TRUE;

ELSE
    step := 0;

END_CASE;

(* one shot pulse generation *)
trig_accept_a(CLK := want_accept_a);
trig_accept_b(CLK := want_accept_b);
trig_trim_b(CLK := want_trim_b);
trig_ack_trim(CLK := want_ack_trim);
trig_accept_roll(CLK := want_accept_roll);
trig_cut_a(CLK := want_cut_a);
trig_cut_b(CLK := want_cut_b);
trig_eject(CLK := want_eject);
trig_ack_exit(CLK := want_ack_exit);
trig_tape_cut(CLK := want_tape_cut);
trig_tape_apply(CLK := want_tape_apply);

Y10 := trig_accept_a.Q;
Y11 := trig_accept_b.Q;
Y15 := trig_trim_b.Q;
Y16 := trig_ack_trim.Q;
Y17 := trig_accept_roll.Q;
Y1C := trig_cut_a.Q;
Y1D := trig_cut_b.Q;
Y20 := trig_eject.Q;
Y21 := trig_ack_exit.Q;
Y27 := trig_tape_cut.Q;
Y28 := trig_tape_apply.Q;

IF trig_trim_b.Q THEN
    b_trim_started := TRUE;
END_IF;

IF trig_accept_a.Q THEN
    a_accepted := TRUE;
END_IF;
IF trig_accept_b.Q THEN
    b_accepted := TRUE;
END_IF;

Y22 := completion_latched;

END_PROGRAM