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

    (* internal sequencing *)
    step : INT := 0;
    roll_num : INT := 0;

    accepted_a : BOOL;
    accepted_b : BOOL;
    trimmed_b : BOOL;
    ack_trim_sent : BOOL;
    leader_ready : BOOL;

    active_roll : BOOL;
    accept_roll_sent : BOOL;

    hold_a_cmd : BOOL;
    hold_b_cmd : BOOL;
    jog_b_cmd : BOOL;
    core_feed_cmd : BOOL;
    core_stop_cmd : BOOL;
    extend_cmd : BOOL;
    retract_cmd : BOOL;
    support_cmd : BOOL;
    nip_a_cmd : BOOL;
    nip_b_cmd : BOOL;
    wind_cmd : BOOL;
    wind_allow : BOOL;

    cut_a_sent : BOOL;
    cut_b_sent : BOOL;
    cuts_done : BOOL;
    tail_wind_done : BOOL;

    tape_prepare_cmd : BOOL;
    tape_hold_cmd : BOOL;
    tape_cut_sent : BOOL;
    tape_apply_sent : BOOL;
    apply_guard : BOOL;

    eject_sent : BOOL;
    ack_exit_sent : BOOL;
    release_exit_cmd : BOOL;

    all_rolls_ok : BOOL := TRUE;
    roll_ok : BOOL;
    complete_conditions : BOOL;
    complete_latched : BOOL;

    last_roll_id : INT;
    last_received : INT;

    t_hold_a : TON;
    t_hold_b : TON;
    t_hold_a_cut : TON;
    t_hold_b_cut : TON;
    t_nip_a : TON;
    t_nip_b : TON;
    t_tape_hold : TON;
    t_core_stop : TON;
    t_mandrel_ext : TON;
    t_mandrel_ret : TON;
    t_cut_a : TON;
    t_cut_b : TON;
END_VAR

(* ---- timers: IN depends on retained step/cmd from previous scan ---- *)
t_hold_a(IN := hold_a_cmd AND X14 AND (step = 6), PT := T#200ms);
t_hold_b(IN := hold_b_cmd AND X15 AND (step = 6), PT := T#200ms);
t_hold_a_cut(IN := hold_a_cmd AND X14 AND (step = 45), PT := T#200ms);
t_hold_b_cut(IN := hold_b_cmd AND X15 AND (step = 45), PT := T#200ms);
t_nip_a(IN := nip_a_cmd AND X1B AND (step = 30), PT := T#200ms);
t_nip_b(IN := nip_b_cmd AND X1C AND (step = 30), PT := T#200ms);
t_tape_hold(IN := tape_hold_cmd AND X30 AND (step = 65), PT := T#200ms);
t_core_stop(IN := core_stop_cmd AND X2E AND (step = 10), PT := T#250ms);
t_mandrel_ext(IN := extend_cmd AND X1E AND (step = 20), PT := T#600ms);
t_mandrel_ret(IN := retract_cmd AND X1D AND (step = 80), PT := T#600ms);
t_cut_a(IN := cut_a_sent AND (step = 50), PT := T#100ms);
t_cut_b(IN := cut_b_sent AND (step = 50), PT := T#100ms);

CASE step OF

0: (* wait start *)
    IF X0 THEN
        step := 5;
    END_IF;

5: (* independent web acceptance *)
    IF NOT accepted_a AND X10 THEN
        Y10 := TRUE;
        accepted_a := TRUE;
    ELSE
        Y10 := FALSE;
    END_IF;
    IF NOT accepted_b AND X11 THEN
        Y11 := TRUE;
        accepted_b := TRUE;
    ELSE
        Y11 := FALSE;
    END_IF;
    IF accepted_a AND accepted_b THEN
        step := 6;
    END_IF;

6: (* A hold / B jog-hold-trim-ack *)
    IF X12 THEN
        hold_a_cmd := TRUE;
    END_IF;

    IF X13 AND NOT X15 THEN
        jog_b_cmd := TRUE;
    ELSE
        jog_b_cmd := FALSE;
    END_IF;
    IF X15 THEN
        hold_b_cmd := TRUE;
    END_IF;

    IF t_hold_b.Q AND NOT trimmed_b AND X15 AND NOT cut_a_sent AND NOT cut_b_sent THEN
        Y15 := TRUE;
        trimmed_b := TRUE;
    ELSE
        Y15 := FALSE;
    END_IF;

    IF trimmed_b AND X16 AND X17 AND NOT ack_trim_sent THEN
        Y16 := TRUE;
        ack_trim_sent := TRUE;
    ELSE
        Y16 := FALSE;
    END_IF;

    IF t_hold_a.Q AND ack_trim_sent THEN
        leader_ready := TRUE;
        jog_b_cmd := FALSE;
        step := 10;
    END_IF;

10: (* core prep and accept_roll *)
    IF roll_num < 3 THEN
        core_feed_cmd := TRUE;
        IF X2D THEN
            core_stop_cmd := TRUE;
        END_IF;
        IF t_core_stop.Q AND X2D AND X2E AND NOT active_roll AND X1D AND leader_ready
           AND (roll_num < 3) AND NOT accept_roll_sent THEN
            Y17 := TRUE;
            accept_roll_sent := TRUE;
            active_roll := TRUE;
            last_roll_id := D3;
        ELSE
            Y17 := FALSE;
        END_IF;
        IF accept_roll_sent THEN
            step := 20;
        END_IF;
    ELSE
        step := 900;
    END_IF;
    Y23 := core_feed_cmd;
    Y24 := core_stop_cmd;

20: (* extend mandrel *)
    core_feed_cmd := FALSE;
    extend_cmd := TRUE;
    retract_cmd := FALSE;
    IF t_mandrel_ext.Q THEN
        step := 25;
    END_IF;

25: (* support descend *)
    support_cmd := TRUE;
    IF X1F THEN
        step := 30;
    END_IF;

30: (* nip engage *)
    nip_a_cmd := TRUE;
    nip_b_cmd := TRUE;
    IF t_nip_a.Q AND t_nip_b.Q THEN
        hold_a_cmd := FALSE;
        hold_b_cmd := FALSE;
        step := 35;
    END_IF;

35: (* wait holders open then wind *)
    IF X24 THEN
        wind_cmd := TRUE;
        step := 40;
    END_IF;

40: (* main winding to target *)
    IF (D6 >= D4 - 2) AND (D6 <= D4 + 2) THEN
        wind_cmd := FALSE;
        step := 45;
    END_IF;

45: (* re-engage holders for cutting *)
    hold_a_cmd := TRUE;
    hold_b_cmd := TRUE;
    IF t_hold_a_cut.Q AND t_hold_b_cut.Q THEN
        step := 50;
    END_IF;

50: (* cut a/b *)
    IF NOT cut_a_sent AND t_hold_a_cut.Q THEN
        Y1C := TRUE;
        cut_a_sent := TRUE;
    ELSE
        Y1C := FALSE;
    END_IF;
    IF NOT cut_b_sent AND t_hold_b_cut.Q THEN
        Y1D := TRUE;
        cut_b_sent := TRUE;
    ELSE
        Y1D := FALSE;
    END_IF;
    IF cut_a_sent AND cut_b_sent AND X27 AND X28 AND X29 THEN
        cuts_done := TRUE;
        step := 55;
    END_IF;

55: (* wind residual tail, no new supply *)
    wind_cmd := TRUE;
    IF X26 THEN
        wind_cmd := FALSE;
        tail_wind_done := TRUE;
        step := 60;
    END_IF;

60: (* release holders/nips, prepare tape *)
    hold_a_cmd := FALSE;
    hold_b_cmd := FALSE;
    nip_a_cmd := FALSE;
    nip_b_cmd := FALSE;
    tape_prepare_cmd := TRUE;
    IF X2A THEN
        step := 65;
    END_IF;

65: (* tape hold *)
    tape_hold_cmd := TRUE;
    IF t_tape_hold.Q THEN
        step := 70;
    END_IF;

70: (* tape cut *)
    IF NOT tape_cut_sent AND X30 AND X2A THEN
        Y27 := TRUE;
        tape_cut_sent := TRUE;
    ELSE
        Y27 := FALSE;
    END_IF;
    IF X31 THEN
        step := 75;
    END_IF;

75: (* tape apply *)
    apply_guard := NOT X32 AND active_roll AND X1E AND NOT core_feed_cmd
                   AND (D6 >= D4 - 2) AND (D6 <= D4 + 2)
                   AND tail_wind_done AND cuts_done AND NOT wind_cmd
                   AND X30 AND X31;
    IF NOT tape_apply_sent AND apply_guard THEN
        Y28 := TRUE;
        tape_apply_sent := TRUE;
    ELSE
        Y28 := FALSE;
    END_IF;
    IF X33 THEN
        step := 80;
    END_IF;

80: (* retract mandrel *)
    retract_cmd := cuts_done AND X1F AND tail_wind_done AND tape_apply_sent AND X33 AND NOT X32;
    extend_cmd := FALSE;
    IF t_mandrel_ret.Q THEN
        step := 85;
    END_IF;

85: (* eject *)
    IF NOT eject_sent AND X1D AND X1F AND cuts_done AND tail_wind_done AND active_roll THEN
        Y20 := TRUE;
        eject_sent := TRUE;
    ELSE
        Y20 := FALSE;
    END_IF;
    IF X22 THEN
        step := 90;
    END_IF;

90: (* cradle return, ack_exit *)
    support_cmd := FALSE;
    IF X20 THEN
        IF NOT ack_exit_sent AND X22 THEN
            Y21 := TRUE;
            ack_exit_sent := TRUE;
        ELSE
            Y21 := FALSE;
        END_IF;
        IF ack_exit_sent THEN
            step := 95;
        END_IF;
    END_IF;

95: (* release to external, finalize this roll *)
    release_exit_cmd := X34 AND X35 AND NOT support_cmd AND X20;
    IF X23 THEN
        last_received := D8;
        roll_ok := cuts_done AND tail_wind_done AND tape_apply_sent AND X33
                   AND X1D AND ack_exit_sent AND X22 AND X20 AND NOT X32;
        all_rolls_ok := all_rolls_ok AND roll_ok;
        step := 100;
    END_IF;

100: (* reset per-roll flags, next roll *)
    roll_num := roll_num + 1;
    active_roll := FALSE;
    accept_roll_sent := FALSE;
    cut_a_sent := FALSE;
    cut_b_sent := FALSE;
    cuts_done := FALSE;
    tail_wind_done := FALSE;
    tape_cut_sent := FALSE;
    tape_apply_sent := FALSE;
    ack_exit_sent := FALSE;
    eject_sent := FALSE;
    release_exit_cmd := FALSE;
    core_feed_cmd := FALSE;
    core_stop_cmd := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y27 := FALSE;
    Y28 := FALSE;
    Y17 := FALSE;
    step := 10;

900: (* all rolls processed, hold idle state *)
    Y17 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y27 := FALSE;
    Y28 := FALSE;

ELSE
    step := 0;

END_CASE;

(* ---- wind permission / output ---- *)
wind_allow := (step = 40) AND active_roll AND X1E AND X1B AND X1C AND NOT hold_a_cmd AND NOT hold_b_cmd;
wind_allow := wind_allow OR ((step = 55) AND active_roll AND X1E AND cuts_done);
Y1A := wind_cmd AND wind_allow;

(* ---- level output mapping ---- *)
Y12 := hold_a_cmd;
Y13 := hold_b_cmd;
Y14 := jog_b_cmd;
Y18 := nip_a_cmd;
Y19 := nip_b_cmd;
Y1B := support_cmd;
Y1E := retract_cmd;
Y1F := extend_cmd AND active_roll AND NOT core_feed_cmd;
Y25 := tape_prepare_cmd AND (D9 >= 80);
Y26 := tape_hold_cmd;
Y29 := release_exit_cmd;

(* ---- completion claim and maintenance ---- *)
complete_conditions := (roll_num >= 3) AND all_rolls_ok;
IF complete_conditions THEN
    complete_latched := TRUE;
END_IF;
Y22 := complete_latched;

END_PROGRAM