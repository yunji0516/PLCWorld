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
    e_start : R_TRIG;
    e_a_req : R_TRIG;
    e_b_req : R_TRIG;
    e_fully : R_TRIG;
    e_a_pack : R_TRIG;
    e_b_pack : R_TRIG;
    e_box_at : R_TRIG;
    e_box_full : R_TRIG;
    e_a_clear : R_TRIG;
    e_b_clear : R_TRIG;
    
    (* State machine *)
    stp : INT := 0;
    tgt : INT := 1;
    
    (* Generation / box tracking *)
    gen : INT := 1;
    box_disp : INT := 0;
    
    (* Order flags *)
    a_ok : BOOL := FALSE;
    b_ok : BOOL := FALSE;
    close_a_done : BOOL := FALSE;
    close_b_done : BOOL := FALSE;
    a_ack : BOOL := FALSE;
    b_ack : BOOL := FALSE;
    pack_a_done : BOOL := FALSE;
    pack_b_done : BOOL := FALSE;
    
    (* Deck state *)
    deck_has : BOOL := FALSE;
    
    (* Storage state *)
    s0 : BOOL := FALSE;
    s1 : BOOL := FALSE;
    s0k : INT := 0;
    s1k : INT := 0;
    
    (* Timers *)
    tmr_clamp : TON;
    tmr_exit : TON;
END_VAR

(* Edge detection *)
e_start(CLK := X0);
e_a_req(CLK := X13);
e_b_req(CLK := X14);
e_fully(CLK := X12);
e_a_pack(CLK := X22);
e_b_pack(CLK := X23);
e_box_at(CLK := X1F);
e_box_full(CLK := X24);
e_a_clear(CLK := X19);
e_b_clear(CLK := X1A);

(* Reset all outputs *)
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
Y20 := FALSE;
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

(* Set targets *)
D200 := tgt;
D201 := gen;

(* Main state machine *)
CASE stp OF
    0:
        (* Idle - wait for start *)
        IF e_start.Q THEN
            stp := 10;
        END_IF;

    10:
        (* Accept orders on request edges *)
        IF e_a_req.Q AND NOT a_ok THEN
            a_ok := TRUE;
            Y13 := TRUE;
        END_IF;
        IF e_b_req.Q AND NOT b_ok THEN
            b_ok := TRUE;
            Y14 := TRUE;
        END_IF;
        (* Move deck to load position *)
        tgt := 1;
        IF D0 = 1 AND NOT X11 THEN
            stp := 20;
        END_IF;

    20:
        (* Load part from source *)
        Y11 := TRUE;
        stp := 30;

    30:
        (* Wait for part to be fully on deck *)
        IF X12 THEN
            deck_has := TRUE;
            stp := 40;
        END_IF;

    40:
        (* Route decision: A kit, B kit, or storage *)
        IF D2 = D11 AND a_ok THEN
            tgt := 4;
        ELSIF D2 = D12 AND b_ok THEN
            tgt := 5;
        ELSIF NOT s0 THEN
            tgt := 2;
            s0 := TRUE;
            s0k := D2;
        ELSIF NOT s1 THEN
            tgt := 3;
            s1 := TRUE;
            s1k := D2;
        END_IF;
        stp := 50;

    50:
        (* Move to target and unload *)
        D200 := tgt;
        IF D0 = tgt AND NOT X11 THEN
            Y12 := TRUE;
            deck_has := FALSE;
            stp := 60;
        END_IF;

    60:
        (* Check storage for unloadable parts *)
        IF s0 AND s0k = D11 AND a_ok THEN
            tgt := 4;
            s0 := FALSE;
            stp := 50;
        ELSIF s0 AND s0k = D12 AND b_ok THEN
            tgt := 5;
            s0 := FALSE;
            stp := 50;
        ELSIF s1 AND s1k = D11 AND a_ok THEN
            tgt := 4;
            s1 := FALSE;
            stp := 50;
        ELSIF s1 AND s1k = D12 AND b_ok THEN
            tgt := 5;
            s1 := FALSE;
            stp := 50;
        ELSE
            stp := 100;
        END_IF;

    100:
        (* Kit processing: close, pack, ack, release *)
        (* Close kits when count reaches 2 *)
        IF D13 = 2 AND NOT close_a_done THEN
            close_a_done := TRUE;
            Y15 := TRUE;
        END_IF;
        IF D14 = 2 AND NOT close_b_done THEN
            close_b_done := TRUE;
            Y16 := TRUE;
        END_IF;

        (* Pack kits when generation matches and kit complete *)
        IF D13 = 2 AND D16 = D9 AND NOT pack_a_done THEN
            pack_a_done := TRUE;
            Y1E := TRUE;
        END_IF;
        IF D14 = 2 AND D16 = D10 AND NOT pack_b_done THEN
            pack_b_done := TRUE;
            Y1F := TRUE;
        END_IF;

        (* Ack kits after packed confirmation *)
        IF e_a_pack.Q AND NOT a_ack THEN
            a_ack := TRUE;
            Y19 := TRUE;
        END_IF;
        IF e_b_pack.Q AND NOT b_ack THEN
            b_ack := TRUE;
            Y1A := TRUE;
        END_IF;

        (* Release kits on out_clear edges *)
        IF e_a_clear.Q THEN
            Y17 := TRUE;
        END_IF;
        IF e_b_clear.Q THEN
            Y18 := TRUE;
        END_IF;

        (* If both kits acked, proceed to box handling *)
        IF a_ack AND b_ack THEN
            stp := 200;
        ELSE
            (* Continue loading more parts *)
            stp := 10;
        END_IF;

    200:
        (* Feed next box *)
        Y1C := TRUE;
        stp := 210;

    210:
        (* Wait for box at station, then clamp *)
        IF e_box_at.Q THEN
            Y1D := TRUE;
            tmr_clamp(IN := TRUE, PT := T#300ms);
            stp := 220;
        END_IF;

    220:
        (* Wait for clamp timer to expire *)
        IF tmr_clamp.Q THEN
            tmr_clamp(IN := FALSE, PT := T#300ms);
            stp := 230;
        END_IF;

    230:
        (* Wait for box_full indication *)
        IF X24 THEN
            Y1D := FALSE;
            stp := 240;
        END_IF;

    240:
        (* Dispatch box on exit_clear *)
        IF X25 THEN
            Y20 := TRUE;
            box_disp := box_disp + 1;
            IF box_disp >= 2 THEN
                (* Both boxes dispatched, start exit delay *)
                tmr_exit(IN := TRUE, PT := T#18000ms);
                stp := 250;
            ELSE
                (* Move to next generation *)
                gen := gen + 1;
                a_ok := FALSE;
                b_ok := FALSE;
                close_a_done := FALSE;
                close_b_done := FALSE;
                a_ack := FALSE;
                b_ack := FALSE;
                pack_a_done := FALSE;
                pack_b_done := FALSE;
                stp := 10;
            END_IF;
        END_IF;

    250:
        (* Wait for exit delay to complete *)
        IF tmr_exit.Q THEN
            stp := 300;
        END_IF;

    300:
        (* Completion: all parts acquired, acked, empty deck, stopped *)
        IF X1D AND NOT deck_has AND NOT X11 THEN
            Y1B := TRUE;
        END_IF;
END_CASE;

END_PROGRAM