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

    (* Edge detectors *)
    tr_start : R_TRIG;
    tr_a_req : R_TRIG;
    tr_b_req : R_TRIG;
    tr_a_recv : R_TRIG;
    tr_b_recv : R_TRIG;
    tr_a_packed : R_TRIG;
    tr_b_packed : R_TRIG;
    tr_box_at : R_TRIG;
    tr_box_full : R_TRIG;

    (* Timers *)
    tm_clamp : TON;
    tm_complete : TON;

    (* System state *)
    sys_on : BOOL := FALSE;
    main_state : INT := 0;
    gen_phase : INT := 1;
    boxes_done : INT := 0;

    (* Order acceptance *)
    a_acc : BOOL := FALSE;
    b_acc : BOOL := FALSE;
    a_gen_val : INT := 0;
    b_gen_val : INT := 0;

    (* Deck sourcing *)
    d_tgt : INT := 0;
    d_phase : INT := 0;
    d_unload_dest : INT := 0;
    d_has_part : BOOL := FALSE;

    (* Assembly *)
    a_cl : BOOL := FALSE;
    b_cl : BOOL := FALSE;
    a_rcv : BOOL := FALSE;
    b_rcv : BOOL := FALSE;

    (* Box *)
    bfeed : BOOL := FALSE;
    bclamp_on : BOOL := FALSE;
    clamp_ok : BOOL := FALSE;
    box_gen : INT := 0;

    (* Pack / ack *)
    a_pk : BOOL := FALSE;
    b_pk : BOOL := FALSE;
    a_ack : BOOL := FALSE;
    b_ack : BOOL := FALSE;

    (* Pulses *)
    p_dock : BOOL := FALSE;
    p_load : BOOL := FALSE;
    p_unld : BOOL := FALSE;
    p_a_acc : BOOL := FALSE;
    p_b_acc : BOOL := FALSE;
    p_a_cl : BOOL := FALSE;
    p_b_cl : BOOL := FALSE;
    p_a_ack : BOOL := FALSE;
    p_b_ack : BOOL := FALSE;
    p_rel_a : BOOL := FALSE;
    p_rel_b : BOOL := FALSE;
    p_disp : BOOL := FALSE;
    p_p_a : BOOL := FALSE;
    p_p_b : BOOL := FALSE;
    p_bf : BOOL := FALSE;
    p_bc : BOOL := FALSE;

    (* Aux *)
    a_need : INT := 0;
    b_need : INT := 0;
    s0_kind : INT := 0;
    s1_kind : INT := 0;
    complete_ok : BOOL := FALSE;
END_VAR

(* Edge detection *)
tr_start(CLK := X0);
tr_a_req(CLK := X13);
tr_b_req(CLK := X14);
tr_a_recv(CLK := X1B);
tr_b_recv(CLK := X1C);
tr_a_packed(CLK := X22);
tr_b_packed(CLK := X23);
tr_box_at(CLK := X1F);
tr_box_full(CLK := X24);

(* Clamp timer *)
tm_clamp(IN := bclamp_on, PT := T#300ms);

(* Completion timer *)
tm_complete(IN := complete_ok, PT := T#500ms);

(* Start *)
IF tr_start.Q THEN
    sys_on := TRUE;
END_IF;

IF NOT sys_on THEN
    Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE;
    Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
    Y20 := FALSE; D200 := 0; D201 := 0; Y1A := FALSE; Y1B := FALSE;
    Y1C := FALSE; Y1D := FALSE; Y1E := FALSE; Y1F := FALSE;
    RETURN;
END_IF;

(* Reset all pulses each scan *)
p_dock := FALSE; p_load := FALSE; p_unld := FALSE;
p_a_acc := FALSE; p_b_acc := FALSE;
p_a_cl := FALSE; p_b_cl := FALSE;
p_a_ack := FALSE; p_b_ack := FALSE;
p_rel_a := FALSE; p_rel_b := FALSE;
p_disp := FALSE; p_p_a := FALSE; p_p_b := FALSE;
p_bf := FALSE; p_bc := FALSE;

(* ===== MAIN STATE MACHINE ===== *)
CASE main_state OF
(* 0: WAIT START *)
0:
    IF sys_on THEN main_state := 10; END_IF;

(* 10: ACCEPT ORDERS *)
10:
    IF tr_a_req.Q AND NOT a_acc THEN
        p_a_acc := TRUE;
        a_acc := TRUE;
        a_gen_val := D9;
        D201 := D9;
    END_IF;
    IF tr_b_req.Q AND NOT b_acc THEN
        p_b_acc := TRUE;
        b_acc := TRUE;
        b_gen_val := D10;
        D201 := D10;
    END_IF;
    IF a_acc AND b_acc THEN
        main_state := 20;
    END_IF;

(* 20: BOX SETUP *)
20:
    IF NOT bfeed THEN
        p_bf := TRUE;
        bfeed := TRUE;
        box_gen := D16;
    END_IF;
    IF tr_box_at.Q THEN
        p_bc := TRUE;
        bclamp_on := TRUE;
    END_IF;
    IF tm_clamp.Q THEN
        clamp_ok := TRUE;
        bclamp_on := FALSE;
        main_state := 30;
    END_IF;

(* 30: SOURCE PARTS *)
30:
    (* Read storage kinds for decision making *)
    s0_kind := D6;
    s1_kind := D8;
    a_need := D11;
    b_need := D12;

    IF d_phase = 0 THEN
        (* Decide source and destination *)
        IF d_has_part THEN
            (* Part on deck, decide unload *)
            IF D2 = a_need THEN
                d_unload_dest := 4;
            ELSIF D2 = b_need THEN
                d_unload_dest := 5;
            ELSIF D6 = 0 OR D5 = 0 THEN
                d_unload_dest := 2;
            ELSIF D8 = 0 OR D7 = 0 THEN
                d_unload_dest := 3;
            ELSE
                d_unload_dest := 0;
            END_IF;
            IF d_unload_dest > 0 THEN
                d_tgt := d_unload_dest;
                d_phase := 1;
            END_IF;
        ELSE
            (* No part on deck, decide load source *)
            IF s0_kind = a_need AND D5 > 0 THEN
                d_tgt := 2; d_unload_dest := 4;
            ELSIF s1_kind = a_need AND D7 > 0 THEN
                d_tgt := 3; d_unload_dest := 4;
            ELSIF s0_kind = b_need AND D5 > 0 THEN
                d_tgt := 2; d_unload_dest := 5;
            ELSIF s1_kind = b_need AND D7 > 0 THEN
                d_tgt := 3; d_unload_dest := 5;
            ELSE
                d_tgt := 1; d_unload_dest := 0;
            END_IF;
            d_phase := 1;
        END_IF;

    ELSIF d_phase = 1 THEN
        (* Move to target *)
        IF NOT X11 AND D0 = d_tgt THEN
            IF NOT d_has_part THEN
                IF X10 THEN
                    p_load := TRUE;
                    d_phase := 2;
                END_IF;
            ELSE
                p_unld := TRUE;
                d_has_part := FALSE;
                d_phase := 0;
            END_IF;
        ELSE
            p_dock := TRUE;
            D200 := d_tgt;
        END_IF;

    ELSIF d_phase = 2 THEN
        (* Loaded, part on deck *)
        IF X12 AND D1 > 0 THEN
            d_has_part := TRUE;
            d_phase := 0;
        END_IF;
    END_IF;

    (* Close assemblies when count reaches 2 *)
    IF D13 >= 2 AND NOT a_cl THEN
        p_a_cl := TRUE;
        a_cl := TRUE;
    END_IF;
    IF D14 >= 2 AND NOT b_cl THEN
        p_b_cl := TRUE;
        b_cl := TRUE;
    END_IF;

    (* Track kit received *)
    IF tr_a_recv.Q THEN a_rcv := TRUE; END_IF;
    IF tr_b_recv.Q THEN b_rcv := TRUE; END_IF;

    (* Pack when kit received and generation matches box *)
    IF a_rcv AND (a_gen_val = D16) AND NOT a_pk THEN
        p_p_a := TRUE;
        a_pk := TRUE;
    END_IF;
    IF b_rcv AND (b_gen_val = D16) AND NOT b_pk THEN
        p_p_b := TRUE;
        b_pk := TRUE;
    END_IF;

    (* Ack after packed *)
    IF tr_a_packed.Q AND NOT a_ack THEN
        p_a_ack := TRUE;
        a_ack := TRUE;
    END_IF;
    IF tr_b_packed.Q AND NOT b_ack THEN
        p_b_ack := TRUE;
        b_ack := TRUE;
    END_IF;

    (* Check box full -> move to dispatch *)
    IF X24 THEN
        main_state := 40;
    END_IF;

(* 40: BOX RELEASE AND DISPATCH *)
40:
    p_rel_a := TRUE;
    p_rel_b := TRUE;
    IF X25 THEN
        p_disp := TRUE;
        boxes_done := boxes_done + 1;
        IF boxes_done >= 2 THEN
            main_state := 50;
        ELSE
            (* Reset for next generation *)
            main_state := 60;
        END_IF;
    END_IF;

(* 50: CHECK ALL DONE *)
50:
    complete_ok := TRUE;
    IF X1D THEN
        Y1B := TRUE;
    END_IF;

(* 60: RESET FOR NEXT GENERATION *)
60:
    a_acc := FALSE; b_acc := FALSE;
    a_cl := FALSE; b_cl := FALSE;
    a_rcv := FALSE; b_rcv := FALSE;
    a_pk := FALSE; b_pk := FALSE;
    a_ack := FALSE; b_ack := FALSE;
    bfeed := FALSE; clamp_ok := FALSE;
    d_has_part := FALSE; d_phase := 0;
    D201 := 0;
    main_state := 10;
END_CASE;

(* ===== OUTPUT ASSIGNMENT ===== *)
Y10 := p_dock;
Y11 := p_load;
Y12 := p_unld;
Y13 := p_a_acc;
Y14 := p_b_acc;
Y15 := p_a_cl;
Y16 := p_b_cl;
Y17 := p_rel_a;
Y18 := p_rel_b;
Y19 := p_a_ack;
Y20 := p_disp;
D200 := d_tgt;
D201 := D201;
Y1A := p_b_ack;
Y1B := tm_complete.Q;
Y1C := p_bf;
Y1D := bclamp_on;
Y1E := p_p_a;
Y1F := p_p_b;

END_PROGRAM