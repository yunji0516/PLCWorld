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

    state : INT;
    roll_idx : INT;
    tape_applied : INT;

    trim_edge : R_TRIG;
    acktrim_edge : R_TRIG;
    accept_roll_edge : R_TRIG;
    cut_a_edge : R_TRIG;
    cut_b_edge : R_TRIG;
    eject_edge : R_TRIG;
    ack_exit_edge : R_TRIG;
    tape_prep_edge : R_TRIG;
    tape_hold_edge : R_TRIG;
    tape_cut_edge : R_TRIG;
    tape_apply_edge : R_TRIG;

    core_stop_timer : TON;
    complete_hold_timer : TON;

    targets : ARRAY[0..2] OF INT;
    prev_trim : BOOL;
    prev_acktrim : BOOL;
    prev_accept_roll : BOOL;
    prev_cut_a : BOOL;
    prev_cut_b : BOOL;
    prev_eject : BOOL;
    prev_ack_exit : BOOL;
    prev_tape_prep : BOOL;
    prev_tape_hold : BOOL;
    prev_tape_cut : BOOL;
    prev_tape_apply : BOOL;
END_VAR

targets[0] := 800;
targets[1] := 1000;
targets[2] := 700;

roll_idx := 0;
tape_applied := 0;

Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;
Y27 := FALSE;
Y28 := FALSE;
Y29 := FALSE;

CASE state OF

0: (* INIT - wait for start *)
    IF X0 THEN
        state := 10;
    END_IF;

10: (* PREP_B - jog B to origin *)
    IF X11 AND NOT X15 THEN
        Y14 := DINT#200 > D2 OR DINT#150 > D2;
        IF (DINT(D0) = D2) OR ((D2 >= DINT(D0) - 2) AND (D2 <= DINT(D0) + 2)) THEN
            Y14 := FALSE;
            state := 11;
        END_IF;
    ELSIF X15 THEN
        state := 11;
    END_IF;

11: (* PREP_B2 - accept B *)
    IF X13 AND NOT X15 THEN
        Y11 := TRUE;
        IF X15 THEN
            Y11 := FALSE;
            state := 12;
        END_IF;
    ELSIF X15 THEN
        state := 12;
    END_IF;

12: (* PREP_B3 - hold B *)
    Y13 := TRUE;
    IF X14 AND X15 AND X13 THEN
        Y13 := FALSE;
        state := 13;
    END_IF;

13: (* PREP_B4 - trim B leader *)
    trim_edge(CLK := Y15);
    IF NOT trim_edge.Q THEN
        Y15 := TRUE;
    ELSE
        Y15 := FALSE;
        state := 14;
    END_IF;

14: (* PREP_B5 - ack trim *)
    acktrim_edge(CLK := Y16);
    IF NOT acktrim_edge.Q THEN
        Y16 := TRUE;
    ELSE
        Y16 := FALSE;
        state := 15;
    END_IF;

15: (* PREP_B6 - wait for trim confirmation *)
    IF X16 AND X17 THEN
        state := 20;
    END_IF;

20: (* PREP_A - accept A *)
    IF X12 AND NOT X14 THEN
        Y10 := TRUE;
        IF X14 THEN
            Y10 := FALSE;
            state := 21;
        END_IF;
    ELSIF X14 THEN
        state := 21;
    END_IF;

21: (* PREP_A2 - hold A *)
    Y12 := TRUE;
    IF X14 AND X15 THEN
        Y12 := FALSE;
        state := 30;
    END_IF;

30: (* ROLL_WIND - extend mandrel *)
    IF NOT X1E THEN
        Y1F := TRUE;
    END_IF;
    IF X1E THEN
        Y1F := FALSE;
        state := 31;
    END_IF;

31: (* ROLL_CORE_FEED - feed core *)
    IF X2C AND NOT X2D THEN
        Y23 := TRUE;
    ELSIF X2D THEN
        Y23 := FALSE;
        state := 32;
    END_IF;

32: (* ROLL_CORE_STOP - close stop jaw *)
    core_stop_timer(IN := TRUE, PT := T#250ms);
    IF core_stop_timer.Q THEN
        core_stop_timer(IN := FALSE);
        Y24 := TRUE;
        state := 33;
    END_IF;

33: (* ROLL_CORE_WAIT - wait for jaw closed *)
    Y24 := TRUE;
    IF X2E THEN
        Y24 := FALSE;
        state := 34;
    END_IF;

34: (* ROLL_ACCEPT - accept roll *)
    IF X2D AND X2E AND X1E AND X14 AND X15 THEN
        accept_roll_edge(CLK := Y17);
        IF NOT accept_roll_edge.Q THEN
            Y17 := TRUE;
        ELSE
            Y17 := FALSE;
            state := 35;
        END_IF;
    END_IF;

35: (* ROLL_NIP_CLOSE *)
    Y18 := TRUE;
    Y19 := TRUE;
    state := 40;

40: (* ROLL_WINDING *)
    Y1A := TRUE;
    IF DINT(D5) >= DINT(D4) - 2 THEN
        Y1A := FALSE;
        Y18 := FALSE;
        Y19 := FALSE;
        state := 50;
    END_IF;

50: (* ROLL_CUT_START - close nips for cutting *)
    Y18 := TRUE;
    Y19 := TRUE;
    state := 51;

51: (* ROLL_CUT - fire cut edges *)
    cut_a_edge(CLK := Y1C);
    cut_b_edge(CLK := Y1D);
    IF NOT cut_a_edge.Q THEN
        Y1C := TRUE;
    ELSE
        Y1C := FALSE;
    END_IF;
    IF NOT cut_b_edge.Q THEN
        Y1D := TRUE;
    ELSE
        Y1D := FALSE;
    END_IF;
    IF Y1C OR Y1D THEN
        (* waiting for edges to pulse *)
    ELSIF X27 AND X28 THEN
        Y1C := FALSE;
        Y1D := FALSE;
        state := 52;
    END_IF;

52: (* ROLL_TAIL_WIND - wind 250mm tail *)
    IF X27 AND X28 THEN
        Y18 := FALSE;
        Y19 := FALSE;
        Y1A := TRUE;
        IF X26 OR DINT(D7) <= 0 THEN
            Y1A := FALSE;
            state := 60;
        END_IF;
    END_IF;

60: (* TAPE_PREPARE - prepare tape for application *)
    tape_prep_edge(CLK := Y25);
    IF NOT tape_prep_edge.Q THEN
        Y25 := TRUE;
    ELSE
        Y25 := FALSE;
        state := 61;
    END_IF;

61: (* TAPE_HOLD - hold tape *)
    tape_hold_edge(CLK := Y26);
    IF NOT tape_hold_edge.Q THEN
        Y26 := TRUE;
    ELSE
        Y26 := FALSE;
        state := 62;
    END_IF;

62: (* TAPE_CUT - cut 80mm *)
    IF X2F AND X30 THEN
        tape_cut_edge(CLK := Y27);
        IF NOT tape_cut_edge.Q THEN
            Y27 := TRUE;
        ELSE
            Y27 := FALSE;
            state := 63;
        END_IF;
    END_IF;

63: (* TAPE_APPLY - apply to roll *)
    IF X31 THEN
        tape_apply_edge(CLK := Y28);
        IF NOT tape_apply_edge.Q THEN
            Y28 := TRUE;
        ELSE
            Y28 := FALSE;
            tape_applied := tape_applied + 1;
            state := 70;
        END_IF;
    END_IF;

70: (* RETRACT_MANDREL *)
    IF X33 OR X31 THEN
        Y1E := TRUE;
    END_IF;
    IF X1D THEN
        Y1E := FALSE;
        state := 80;
    END_IF;

80: (* EJECT *)
    eject_edge(CLK := Y20);
    IF NOT eject_edge.Q THEN
        Y20 := TRUE;
    ELSE
        Y20 := FALSE;
        state := 81;
    END_IF;

81: (* EJECT_WAIT *)
    IF X20 OR X34 THEN
        state := 82;
    END_IF;

82: (* ACK_EXIT *)
    ack_exit_edge(CLK := Y21);
    IF NOT ack_exit_edge.Q THEN
        Y21 := TRUE;
    ELSE
        Y21 := FALSE;
        state := 83;
    END_IF;

83: (* RELEASE_EXIT *)
    Y29 := TRUE;
    IF X35 THEN
        Y29 := FALSE;
        state := 84;
    END_IF;

84: (* CHECK_NEXT *)
    IF roll_idx < 2 THEN
        roll_idx := roll_idx + 1;
        tape_applied := tape_applied;
        D4 := targets[roll_idx];
        state := 30;
    ELSE
        state := 90;
    END_IF;

90: (* COMPLETE *)
    complete_hold_timer(IN := TRUE, PT := T#100ms);
    IF complete_hold_timer.Q THEN
        Y22 := TRUE;
    END_IF;

END_CASE;

END_PROGRAM