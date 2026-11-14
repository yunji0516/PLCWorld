PROGRAM Main
VAR
    X0 : BOOL; X10 : BOOL; X11 : BOOL; X12 : BOOL; X13 : BOOL; X14 : BOOL;
    X15 : BOOL; X16 : BOOL; X17 : BOOL; X18 : BOOL; X19 : BOOL; X20 : BOOL;
    X21 : BOOL; X22 : BOOL; X23 : BOOL; X24 : BOOL; X25 : BOOL; X26 : BOOL;
    X27 : BOOL; X28 : BOOL; X29 : BOOL; X1A : BOOL; X1B : BOOL; X1C : BOOL;
    X1D : BOOL; X1E : BOOL; X1F : BOOL;
    Y10 : BOOL; Y11 : BOOL; Y12 : BOOL; Y13 : BOOL; Y14 : BOOL; Y15 : BOOL;
    Y16 : BOOL; Y17 : BOOL; Y18 : BOOL; Y19 : BOOL; Y20 : BOOL; Y21 : BOOL;
    Y22 : BOOL; Y1A : BOOL; Y1B : BOOL; Y1C : BOOL; Y1D : BOOL; Y1E : BOOL;
    Y1F : BOOL;
    D0 : INT; D1 : INT; D2 : INT; D3 : INT; D4 : INT; D5 : INT; D6 : INT;
    D7 : INT; D8 : INT; D9 : INT; D10 : INT; D11 : INT; D200 : INT;
    st : INT := 0;
    batches : INT := 0;
    pieces : INT := 0;
    splice_done : BOOL := FALSE;
    waste_done : BOOL := FALSE;
    batch_ack_flag : BOOL := FALSE;
    target_mm : INT := 0;
    using_a : BOOL := TRUE;
    t_hold : TON;
    t_cut : TON;
    t_rel : TON;
    e_splice : R_TRIG;
    e_spare : R_TRIG;
    e_thread : R_TRIG;
    e_join : R_TRIG;
    e_exit : R_TRIG;
END_VAR

e_splice(CLK := X27);
e_spare(CLK := X20);
e_thread(CLK := X25);
e_join(CLK := X26);
e_exit(CLK := X1D);

CASE st OF
    0:
        accept_batch := FALSE; ack_batch := FALSE; accept_a := FALSE;
        accept_b := FALSE; start_piece := FALSE; feed := FALSE;
        pull := FALSE; hold := FALSE; cut := FALSE; release := FALSE;
        thread := FALSE; splice_press := FALSE; start_waste := FALSE;
        ack_exit := FALSE; spare_advance := FALSE; spare_lock := FALSE;
        old_end_hold := FALSE; new_end_hold := FALSE; complete := FALSE;
        IF X0 AND X10 THEN st := 1; END_IF;

    1:
        accept_batch := X10;
        IF X11 THEN
            batches := batches + 1;
            accept_batch := FALSE;
            batch_ack_flag := FALSE;
            st := 2;
        END_IF;

    2:
        IF X27 AND NOT splice_done THEN
            st := 20;
        ELSIF splice_done AND NOT waste_done THEN
            st := 40;
        ELSIF X17 THEN
            IF using_a THEN
                D200 := 1; accept_a := TRUE; target_mm := D5;
            ELSE
                D200 := 2; accept_b := TRUE; target_mm := D6;
            END_IF;
            start_piece := TRUE;
            st := 3;
        END_IF;

    3:
        start_piece := FALSE; accept_a := FALSE; accept_b := FALSE;
        feed := TRUE;
        pull := X1F;
        IF D8 >= target_mm - 2 AND D8 <= target_mm + 2 THEN
            feed := FALSE; pull := FALSE; st := 4;
        END_IF;
        IF X27 AND NOT splice_done THEN
            feed := FALSE; pull := FALSE; st := 20;
        END_IF;

    4:
        hold := TRUE;
        t_hold(IN := TRUE, PT := T#150ms);
        IF t_hold.Q THEN
            hold := FALSE;
            t_hold(IN := FALSE);
            st := 5;
        END_IF;

    5:
        IF X1B AND D8 >= target_mm - 2 AND D8 <= target_mm + 2 THEN
            cut := TRUE;
        END_IF;
        t_cut(IN := cut, PT := T#600ms);
        IF t_cut.Q THEN
            cut := FALSE;
            t_cut(IN := FALSE);
            st := 6;
        END_IF;

    6:
        IF X19 AND X1F THEN
            release := TRUE;
        END_IF;
        t_rel(IN := release, PT := T#500ms);
        IF t_rel.Q THEN
            release := FALSE;
            t_rel(IN := FALSE);
            st := 7;
        END_IF;

    7:
        IF e_exit.Q THEN
            ack_exit := TRUE;
            st := 8;
        END_IF;

    8:
        ack_exit := TRUE;
        IF NOT X1D THEN
            ack_exit := FALSE;
        END_IF;
        pieces := pieces + 1;
        IF pieces >= 3 THEN
            using_a := FALSE;
        END_IF;
        IF batches < 5 THEN
            st := 1;
        ELSIF pieces >= 6 AND waste_done AND splice_done THEN
            st := 100;
        ELSE
            st := 2;
        END_IF;

    20:
        IF X20 THEN st := 21; END_IF;

    21:
        spare_advance := TRUE;
        IF X21 THEN
            spare_advance := FALSE;
            st := 22;
        END_IF;

    22:
        spare_lock := TRUE;
        IF X22 THEN
            spare_lock := FALSE;
            st := 23;
        END_IF;

    23:
        thread := TRUE;
        IF e_thread.Q THEN
            thread := FALSE;
            st := 24;
        END_IF;

    24:
        old_end_hold := TRUE;
        new_end_hold := TRUE;
        IF X23 AND X24 THEN
            old_end_hold := FALSE;
            new_end_hold := FALSE;
            st := 25;
        END_IF;

    25:
        splice_press := TRUE;
        IF e_join.Q THEN
            splice_press := FALSE;
            splice_done := TRUE;
            using_a := FALSE;
            D200 := 2;
            st := 26;
        END_IF;

    26:
        st := 2;

    40:
        start_waste := TRUE;
        feed := TRUE;
        pull := X1F;
        target_mm := D11;
        st := 41;

    41:
        start_waste := FALSE;
        IF D8 >= target_mm - 2 AND D8 <= target_mm + 2 THEN
            feed := FALSE;
            pull := FALSE;
            st := 42;
        END_IF;

    42:
        hold := TRUE;
        t_hold(IN := TRUE, PT := T#150ms);
        IF t_hold.Q THEN
            hold := FALSE;
            st := 43;
        END_IF;

    43:
        IF X1B AND D8 >= target_mm - 2 AND D8 <= target_mm + 2 THEN
            cut := TRUE;
        END_IF;
        t_cut(IN := cut, PT := T#600ms);
        IF t_cut.Q THEN
            cut := FALSE;
            st := 44;
        END_IF;

    44:
        IF X19 AND X1F THEN
            release := TRUE;
        END_IF;
        t_rel(IN := release, PT := T#500ms);
        IF t_rel.Q THEN
            release := FALSE;
            st := 45;
        END_IF;

    45:
        IF e_exit.Q THEN
            ack_exit := TRUE;
            st := 46;
        END_IF;

    46:
        ack_exit := TRUE;
        waste_done := TRUE;
        IF NOT X1D THEN
            ack_exit := FALSE;
        END_IF;
        st := 2;

    100:
        complete := TRUE;
END_CASE;

IF D1 = 0 AND X12 AND NOT batch_ack_flag THEN
    ack_batch := TRUE;
    batch_ack_flag := TRUE;
ELSIF D1 > 0 THEN
    batch_ack_flag := FALSE;
END_IF;

END_PROGRAM