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

    (* internal *)
    started      : BOOL := FALSE;
    startTrig    : R_TRIG;

    acc_state    : INT := 0;

    deck_state   : INT := 0;
    src_t        : INT := 0;
    dst_t        : INT := 0;

    kitA_state   : INT := 0;
    kitB_state   : INT := 0;
    a_pack_pending : BOOL := FALSE;
    b_pack_pending : BOOL := FALSE;
    a_ack_done   : BOOL := FALSE;
    b_ack_done   : BOOL := FALSE;

    pack_state   : INT := 0;
    condA        : BOOL := FALSE;
    condB        : BOOL := FALSE;

    box_state    : INT := 0;
    clampTimer   : TON;
    dispatched_count : INT := 0;

    closeA_trig  : R_TRIG;
    closeB_trig  : R_TRIG;

    completeTimer   : TON;
    complete_latched : BOOL := FALSE;
END_VAR

(* ---------- start latch ---------- *)
startTrig(CLK := X0);
IF startTrig.Q THEN
    started := TRUE;
END_IF;

(* close edges: always evaluated *)
closeA_trig(CLK := (D13 = 2));
closeB_trig(CLK := (D14 = 2));
IF started THEN
    Y15 := closeA_trig.Q;
    Y16 := closeB_trig.Q;
END_IF;

IF started THEN

    (* ---------- order acceptance ---------- *)
    CASE acc_state OF
        0:
            IF X13 AND (NOT X15) THEN
                D201 := D9;
                Y13 := TRUE;
                acc_state := 1;
            ELSIF X14 AND (NOT X16) THEN
                D201 := D10;
                Y14 := TRUE;
                acc_state := 2;
            END_IF;
        1:
            Y13 := FALSE;
            acc_state := 0;
        2:
            Y14 := FALSE;
            acc_state := 0;
    ELSE
        acc_state := 0;
    END_CASE;

    (* ---------- deck transfer cycle ---------- *)
    CASE deck_state OF
        0: (* select source *)
            IF (D6 <> 0) AND ( ((D6 = D11) AND X15 AND (D13 < 2)) OR ((D6 = D12) AND X16 AND (D14 < 2)) ) THEN
                src_t := 2;
            ELSIF (D8 <> 0) AND ( ((D8 = D11) AND X15 AND (D13 < 2)) OR ((D8 = D12) AND X16 AND (D14 < 2)) ) THEN
                src_t := 3;
            ELSIF X10 THEN
                src_t := 1;
            ELSE
                src_t := 0;
            END_IF;
            IF src_t <> 0 THEN
                D200 := src_t;
                Y10 := TRUE;
                deck_state := 1;
            END_IF;
        1:
            Y10 := FALSE;
            deck_state := 2;
        2:
            IF (NOT X11) AND (D0 = D200) THEN
                deck_state := 3;
            END_IF;
        3:
            Y11 := TRUE;
            deck_state := 4;
        4:
            Y11 := FALSE;
            deck_state := 5;
        5:
            IF X12 THEN
                deck_state := 6;
            END_IF;
        6: (* compute destination *)
            IF (D2 = D11) AND X15 AND (D13 < 2) THEN
                dst_t := 4;
            ELSIF (D2 = D12) AND X16 AND (D14 < 2) THEN
                dst_t := 5;
            ELSIF D6 = 0 THEN
                dst_t := 2;
            ELSIF D8 = 0 THEN
                dst_t := 3;
            ELSE
                dst_t := 0;
            END_IF;
            IF dst_t <> 0 THEN
                D200 := dst_t;
                Y10 := TRUE;
                deck_state := 7;
            END_IF;
        7:
            Y10 := FALSE;
            deck_state := 8;
        8:
            IF (NOT X11) AND (D0 = D200) THEN
                deck_state := 9;
            END_IF;
        9:
            Y12 := TRUE;
            deck_state := 10;
        10:
            Y12 := FALSE;
            deck_state := 11;
        11:
            IF NOT X12 THEN
                deck_state := 0;
            END_IF;
    ELSE
        deck_state := 0;
    END_CASE;

    (* ---------- kit A pipeline: ready -> release -> received -> pack request ---------- *)
    CASE kitA_state OF
        0:
            IF X17 THEN
                kitA_state := 1;
            END_IF;
        1:
            IF X19 THEN
                Y17 := TRUE;
                kitA_state := 2;
            END_IF;
        2:
            Y17 := FALSE;
            kitA_state := 3;
        3:
            IF X1B THEN
                a_pack_pending := TRUE;
                kitA_state := 4;
            END_IF;
        4:
            IF a_ack_done THEN
                a_pack_pending := FALSE;
                kitA_state := 0;
            END_IF;
    ELSE
        kitA_state := 0;
    END_CASE;

    (* ---------- kit B pipeline ---------- *)
    CASE kitB_state OF
        0:
            IF X18 THEN
                kitB_state := 1;
            END_IF;
        1:
            IF X1A THEN
                Y18 := TRUE;
                kitB_state := 2;
            END_IF;
        2:
            Y18 := FALSE;
            kitB_state := 3;
        3:
            IF X1C THEN
                b_pack_pending := TRUE;
                kitB_state := 4;
            END_IF;
        4:
            IF b_ack_done THEN
                b_pack_pending := FALSE;
                kitB_state := 0;
            END_IF;
    ELSE
        kitB_state := 0;
    END_CASE;

    (* ---------- shared pack head arbiter ---------- *)
    CASE pack_state OF
        0:
            a_ack_done := FALSE;
            b_ack_done := FALSE;
            condA := a_pack_pending AND (D16 = D9) AND (box_state = 2) AND (NOT X21);
            condB := b_pack_pending AND (D16 = D10) AND (box_state = 2) AND (NOT X21);
            IF condA THEN
                Y1E := TRUE;
                pack_state := 1;
            ELSIF condB THEN
                Y1F := TRUE;
                pack_state := 4;
            END_IF;
        1:
            Y1E := FALSE;
            pack_state := 2;
        2:
            IF X22 THEN
                Y19 := TRUE;
                pack_state := 3;
            END_IF;
        3:
            Y19 := FALSE;
            a_ack_done := TRUE;
            pack_state := 0;
        4:
            Y1F := FALSE;
            pack_state := 5;
        5:
            IF X23 THEN
                Y1A := TRUE;
                pack_state := 6;
            END_IF;
        6:
            Y1A := FALSE;
            b_ack_done := TRUE;
            pack_state := 0;
    ELSE
        pack_state := 0;
    END_CASE;

    (* ---------- box feed / clamp / dispatch ---------- *)
    CASE box_state OF
        0:
            IF dispatched_count < 2 THEN
                IF NOT X1F THEN
                    Y1C := TRUE;
                ELSE
                    Y1C := FALSE;
                    box_state := 1;
                END_IF;
            END_IF;
        1:
            Y1D := TRUE;
            clampTimer(IN := TRUE, PT := T#300ms);
            IF clampTimer.Q THEN
                box_state := 2;
            END_IF;
        2:
            Y1D := TRUE;
            clampTimer(IN := TRUE, PT := T#300ms);
            IF X24 THEN
                Y1D := FALSE;
                clampTimer(IN := FALSE, PT := T#300ms);
                box_state := 3;
            END_IF;
        3:
            IF X25 THEN
                Y20 := TRUE;
                box_state := 4;
            END_IF;
        4:
            Y20 := FALSE;
            dispatched_count := dispatched_count + 1;
            IF dispatched_count < 2 THEN
                box_state := 0;
            ELSE
                box_state := 5;
            END_IF;
        5:
            Y1C := FALSE;
            Y1D := FALSE;
    ELSE
        box_state := 0;
    END_CASE;

    (* ---------- completion ---------- *)
    completeTimer(IN := X1D AND (dispatched_count >= 2), PT := T#500ms);
    IF completeTimer.Q THEN
        complete_latched := TRUE;
    END_IF;
    IF complete_latched THEN
        Y1B := TRUE;
    ELSE
        Y1B := FALSE;
    END_IF;

END_IF;

END_PROGRAM