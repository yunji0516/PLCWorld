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
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
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
    Y20 : BOOL;
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
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    D15 : INT;
    D16 : INT;
    D200 : INT;
    D201 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    started : BOOL := FALSE;
    r_start : R_TRIG;

    deck_state : INT := 0;
    pend_src : INT := 0;
    pend_dst : INT := 0;
    pend_gen : INT := 0;
    dst_pending_decide : BOOL := FALSE;
    action_found : BOOL := FALSE;

    a_state : INT := 0;
    a_accepted : BOOL := FALSE;
    a_gen_accepted : INT := 0;
    a_orders_done : INT := 0;
    r_a_request : R_TRIG;

    b_state : INT := 0;
    b_accepted : BOOL := FALSE;
    b_gen_accepted : INT := 0;
    b_orders_done : INT := 0;
    r_b_request : R_TRIG;

    pack_issued_this_scan : BOOL := FALSE;

    box_state : INT := 0;
    boxes_dispatched : INT := 0;
    clamping_active : BOOL := FALSE;
    clamp_timer : TON;

    all_acquired : BOOL := FALSE;
    ready_for_complete : BOOL := FALSE;
    complete_timer : TON;
    complete_latched : BOOL := FALSE;
END_VAR

// Edge detection - update every scan
r_start(CLK := X0);
r_a_request(CLK := X13);
r_b_request(CLK := X14);

IF r_start.Q THEN
    started := TRUE;
END_IF;

// Default outputs off each scan (pulse type); levels re-set inside FSMs
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
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;
Y20 := FALSE;
pack_issued_this_scan := FALSE;

IF started THEN

    // ---------------- Deck FSM ----------------
    CASE deck_state OF
    0:
        action_found := FALSE;
        dst_pending_decide := FALSE;

        IF a_accepted AND X15 AND (D6 <> 0) AND (D6 = D11) THEN
            pend_src := 2; pend_dst := 4; pend_gen := a_gen_accepted; action_found := TRUE;
        ELSIF a_accepted AND X15 AND (D8 <> 0) AND (D8 = D11) THEN
            pend_src := 3; pend_dst := 4; pend_gen := a_gen_accepted; action_found := TRUE;
        ELSIF b_accepted AND X16 AND (D6 <> 0) AND (D6 = D12) THEN
            pend_src := 2; pend_dst := 5; pend_gen := b_gen_accepted; action_found := TRUE;
        ELSIF b_accepted AND X16 AND (D8 <> 0) AND (D8 = D12) THEN
            pend_src := 3; pend_dst := 5; pend_gen := b_gen_accepted; action_found := TRUE;
        ELSIF X10 THEN
            pend_src := 1; pend_dst := 0; pend_gen := 0; action_found := TRUE; dst_pending_decide := TRUE;
        END_IF;

        IF action_found THEN
            IF D0 = pend_src THEN
                deck_state := 3;
            ELSE
                D200 := pend_src;
                D201 := pend_gen;
                deck_state := 1;
            END_IF;
        END_IF;

    1:
        Y10 := TRUE;
        deck_state := 2;

    2:
        IF (NOT X11) AND (D0 = pend_src) THEN
            deck_state := 3;
        END_IF;

    3:
        Y11 := TRUE;
        deck_state := 4;

    4:
        IF X12 THEN
            IF dst_pending_decide THEN
                IF a_accepted AND X15 AND (D2 = D11) THEN
                    pend_dst := 4; pend_gen := a_gen_accepted;
                ELSIF b_accepted AND X16 AND (D2 = D12) THEN
                    pend_dst := 5; pend_gen := b_gen_accepted;
                ELSIF D6 = 0 THEN
                    pend_dst := 2; pend_gen := 0;
                ELSIF D8 = 0 THEN
                    pend_dst := 3; pend_gen := 0;
                ELSE
                    pend_dst := 0;
                END_IF;
            END_IF;
            IF pend_dst <> 0 THEN
                IF D0 = pend_dst THEN
                    deck_state := 7;
                ELSE
                    D200 := pend_dst;
                    D201 := pend_gen;
                    deck_state := 5;
                END_IF;
            END_IF;
        END_IF;

    5:
        Y10 := TRUE;
        deck_state := 6;

    6:
        IF (NOT X11) AND (D0 = pend_dst) THEN
            deck_state := 7;
        END_IF;

    7:
        Y12 := TRUE;
        deck_state := 8;

    8:
        IF NOT X12 THEN
            deck_state := 0;
        END_IF;

    ELSE
        deck_state := 0;
    END_CASE;

    // ---------------- Order A FSM ----------------
    CASE a_state OF
    0:
        IF r_a_request.Q THEN
            Y13 := TRUE;
            a_accepted := TRUE;
            a_gen_accepted := D9;
            a_state := 1;
        END_IF;
    1:
        IF D13 = 2 THEN
            Y15 := TRUE;
            a_state := 2;
        END_IF;
    2:
        IF X17 THEN
            a_state := 3;
        END_IF;
    3:
        IF X19 THEN
            Y17 := TRUE;
            a_state := 4;
        END_IF;
    4:
        IF (D16 = a_gen_accepted) AND X1B AND (NOT X21) AND (NOT pack_issued_this_scan) THEN
            Y1E := TRUE;
            pack_issued_this_scan := TRUE;
            a_state := 5;
        END_IF;
    5:
        IF X22 THEN
            Y19 := TRUE;
            a_accepted := FALSE;
            a_orders_done := a_orders_done + 1;
            a_state := 0;
        END_IF;
    ELSE
        a_state := 0;
    END_CASE;

    // ---------------- Order B FSM ----------------
    CASE b_state OF
    0:
        IF r_b_request.Q THEN
            Y14 := TRUE;
            b_accepted := TRUE;
            b_gen_accepted := D10;
            b_state := 1;
        END_IF;
    1:
        IF D14 = 2 THEN
            Y16 := TRUE;
            b_state := 2;
        END_IF;
    2:
        IF X18 THEN
            b_state := 3;
        END_IF;
    3:
        IF X1A THEN
            Y18 := TRUE;
            b_state := 4;
        END_IF;
    4:
        IF (D16 = b_gen_accepted) AND X1C AND (NOT X21) AND (NOT pack_issued_this_scan) THEN
            Y1F := TRUE;
            pack_issued_this_scan := TRUE;
            b_state := 5;
        END_IF;
    5:
        IF X23 THEN
            Y1A := TRUE;
            b_accepted := FALSE;
            b_orders_done := b_orders_done + 1;
            b_state := 0;
        END_IF;
    ELSE
        b_state := 0;
    END_CASE;

    // ---------------- Box FSM ----------------
    clamping_active := (box_state = 2) OR (box_state = 3);
    clamp_timer(IN := clamping_active, PT := T#300ms);

    CASE box_state OF
    0:
        IF X1E THEN
            Y1C := TRUE;
            box_state := 1;
        END_IF;
    1:
        Y1C := TRUE;
        IF X1F THEN
            Y1C := FALSE;
            box_state := 2;
        END_IF;
    2:
        Y1D := TRUE;
        IF clamp_timer.Q AND X20 THEN
            box_state := 3;
        END_IF;
    3:
        Y1D := TRUE;
        IF X24 THEN
            Y1D := FALSE;
            box_state := 4;
        END_IF;
    4:
        IF X25 THEN
            box_state := 5;
        END_IF;
    5:
        Y20 := TRUE;
        box_state := 6;
    6:
        boxes_dispatched := boxes_dispatched + 1;
        IF boxes_dispatched < 2 THEN
            box_state := 0;
        ELSE
            box_state := 7;
        END_IF;
    7:
        box_state := 7;
    ELSE
        box_state := 0;
    END_CASE;

END_IF;

// ---------------- Completion ----------------
all_acquired := (a_orders_done >= 2) AND (b_orders_done >= 2) AND (NOT X12) AND (deck_state = 0);
ready_for_complete := all_acquired AND (boxes_dispatched >= 2) AND X1D;
complete_timer(IN := ready_for_complete, PT := T#500ms);
IF complete_timer.Q THEN
    complete_latched := TRUE;
END_IF;
Y1B := complete_latched;

END_PROGRAM